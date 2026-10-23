const express = require('express');
const router = new express.Router();
const index = require('../controllers/index');

//router.get('/api/trabajos/:id/estado', index.getEstadoTrabajo);
router.get('/api/trabajos/:id/seguimiento', index.getSeguimientoTrabajo);
router.get('/api/trabajos/:id/versiones', index.getVersionesTrabajo);
router.get('/api/versiones/:id', index.getVersionDetalle);
router.post('/api/versiones/:id/anotaciones', index.registrarAnotacion);

module.exports = router;
