const database = require('../db');

// HU-04 CA3: identificar propuestas según su estado de aprobación.
const getPropuestas = (req, res) => {
  const { estado } = req.query;
  const query = estado
    ? 'SELECT * FROM propuesta_tt WHERE estado_aprobacion = ? ORDER BY fecha_registro DESC, id DESC'
    : 'SELECT * FROM propuesta_tt ORDER BY fecha_registro DESC, id DESC';
  const params = estado ? [estado] : [];

  database.query(query, params, (err, rows) => {
    if (err) return res.status(500).json({ error: 'Error al consultar las propuestas' });
    res.status(200).json(rows);
  });
};

// HU-04 CA1 y CA4: consultar contenido, estado y anotaciones previas.
const getPropuestaDetalle = (req, res) => {
  const propuestaId = req.params.id;
  database.query('SELECT * FROM propuesta_tt WHERE id = ?', [propuestaId], (err, rows) => {
    if (err) return res.status(500).json({ error: 'Error al consultar la propuesta' });
    if (!rows[0]) return res.status(404).json({ error: 'Propuesta no encontrada' });

    database.query(
      'SELECT id, comentario, autor, fecha FROM anotacion_propuesta WHERE propuesta_id = ? ORDER BY fecha, id',
      [propuestaId],
      (err2, annotations) => {
        if (err2) return res.status(500).json({ error: 'Error al consultar las anotaciones de la propuesta' });
        res.status(200).json({ ...rows[0], anotaciones: annotations });
      }
    );
  });
};

// HU-04 CA2 y CA4: aprobar y devolver estado actualizado
const aprobarPropuesta = (req, res) => {
  const propuestaId = req.params.id;
  const updateQuery = "UPDATE propuesta_tt SET estado_aprobacion = 'aprobada' WHERE id = ? AND estado_aprobacion <> 'aprobada'";

  database.query(updateQuery, [propuestaId], (err, result) => {
    if (err) return res.status(500).json({ error: 'Error al aprobar la propuesta' });

    database.query('SELECT * FROM propuesta_tt WHERE id = ?', [propuestaId], (err2, rows) => {
      if (err2) return res.status(500).json({ error: 'Error al consultar la propuesta actualizada' });
      if (!rows[0]) return res.status(404).json({ error: 'Propuesta no encontrada' });
      res.status(200).json({ ...rows[0], ya_estaba_aprobada: result.affectedRows === 0 });
    });
  });
};

// HU-03 CA2: registrar anotación de revisión sobre una versión de propuesta. S-09 
const registrarAnotacionPropuesta = (req, res) => {
  const versionId = req.params.id;
  const { comentario } = req.body;

  if (!comentario || !comentario.trim()) {
    return res.status(400).json({ error: 'El comentario es obligatorio' });
  }

  database.query('SELECT id FROM version_propuesta WHERE id = ?', [versionId], (err, versions) => {
    if (err) return res.status(500).json({ error: 'Error al validar la versión de la propuesta' });
    if (!versions[0]) return res.status(404).json({ error: 'Versión de propuesta no encontrada' });

    const query = "INSERT INTO anotacion_propuesta (version_propuesta_id, comentario, autor, fecha) VALUES (?, ?, 'Profesor TT1', CURDATE())";
    database.query(query, [versionId, comentario.trim()], (err2, result) => {
      if (err2) return res.status(500).json({ error: 'Error al registrar la anotación' });
      database.query('SELECT * FROM anotacion_propuesta WHERE id = ?', [result.insertId], (err3, rows) => {
        if (err3) return res.status(500).json({ error: 'Error al recuperar la anotación registrada' });
        res.status(201).json(rows[0]);
      });
    });
  });
};

// HU-03 CA1: listar versiones de una propuesta para su revisión. S-1O
const getVersionesPropuesta = (req, res) =>{
  const propuestaId = req.params.id;
  database.query(
    'SELECT id, numero_version, fecha_entrega, contenido FROM version_propuesta WHERE propuesta_id = ? ORDER BY fecha_entrega',
    [propuestaId],
    (err, rows) => {
      if (err) return res.status(500).json({ error: 'Error al consultar las versiones de la propuesta' });
      res.status(200).json(rows);
    }
  );
};

// HU-03 CA1 y CA3: contenido + anotaciones de una versión de propuesta.
const getVersionPropuestaDetalle = (req, res) => {
  const versionId = req.params.id;
  database.query('SELECT id, propuesta_id, numero_version, fecha_entrega, contenido FROM version_propuesta WHERE id = ?', [versionId], (err, versions) => {
    if (err) return res.status(500).json({ error: 'Error al consultar la versión de la propuesta' });
    if (!versions[0]) return res.status(404).json({ error: 'Versión de propuesta no encontrada' });

    database.query(
      'SELECT id, comentario, autor, fecha FROM anotacion_propuesta WHERE version_propuesta_id = ? ORDER BY fecha, id',
      [versionId],
      (err2, annotations) => {
        if (err2) return res.status(500).json({ error: 'Error al consultar las anotaciones de la versión' });
        res.status(200).json({ ...versions[0], anotaciones: annotations });
      }
    );
  });
};

/*esta parte del module.exports siempre dejenla al final*/

module.exports = {
  getPropuestas,
  getPropuestaDetalle,
  aprobarPropuesta,
  registrarAnotacionPropuesta,
  getVersionesPropuesta,
  getVersionPropuestaDetalle,
};


