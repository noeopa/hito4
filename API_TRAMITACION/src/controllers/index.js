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

// HU-04 CA2 y CA4: aprobar y devolver estado actualizado.
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

module.exports = {
  getPropuestas,
  getPropuestaDetalle,
  aprobarPropuesta,
};
