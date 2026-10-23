const express = require('express');
const router = new express.Router();
const index = require('../controllers/index');

router.get('/api/propuestas', index.getPropuestas);
router.get('/api/propuestas/:id', index.getPropuestaDetalle);
router.put('/api/propuestas/:id/aprobar', index.aprobarPropuesta);

module.exports = router;
