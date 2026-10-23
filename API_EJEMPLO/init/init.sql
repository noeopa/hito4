SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

CREATE DATABASE IF NOT EXISTS BD_EJEMPLO CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE BD_EJEMPLO;

CREATE TABLE IF NOT EXISTS paises (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100),
    capital VARCHAR(100),
    continente VARCHAR(100)
);

INSERT INTO paises (nombre, capital, continente)
SELECT 'Chile', 'Santiago', 'America del sur'
WHERE NOT EXISTS (SELECT 1 FROM paises WHERE nombre = 'Chile');
INSERT INTO paises (nombre, capital, continente)
SELECT 'Noruega', 'Oslo', 'Europa'
WHERE NOT EXISTS (SELECT 1 FROM paises WHERE nombre = 'Noruega');
INSERT INTO paises (nombre, capital, continente)
SELECT 'Mexico', 'Ciudad de Mexico', 'America del norte'
WHERE NOT EXISTS (SELECT 1 FROM paises WHERE nombre = 'Mexico');

CREATE DATABASE IF NOT EXISTS BD06_VALIDACIONES CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE BD06_VALIDACIONES;

CREATE TABLE IF NOT EXISTS trabajo_de_titulo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    estado VARCHAR(30) DEFAULT 'en_desarrollo',
    actualizado_en DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS hito (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trabajo_id INT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    estado VARCHAR(30) NOT NULL,
    orden_hito INT NOT NULL,
    FOREIGN KEY (trabajo_id) REFERENCES trabajo_de_titulo(id)
);

CREATE TABLE IF NOT EXISTS accion_pendiente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trabajo_id INT NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    responsable VARCHAR(100) NOT NULL,
    estado VARCHAR(30) DEFAULT 'pendiente',
    FOREIGN KEY (trabajo_id) REFERENCES trabajo_de_titulo(id)
);

CREATE TABLE IF NOT EXISTS version_tt (
    id INT AUTO_INCREMENT PRIMARY KEY,
    trabajo_id INT NOT NULL,
    numero_version VARCHAR(20) NOT NULL,
    fecha_entrega DATE NOT NULL,
    contenido TEXT NOT NULL,
    FOREIGN KEY (trabajo_id) REFERENCES trabajo_de_titulo(id)
);

CREATE TABLE IF NOT EXISTS anotacion_tt (
    id INT AUTO_INCREMENT PRIMARY KEY,
    comentario TEXT NOT NULL,
    version_id INT NOT NULL,
    guia_id INT NOT NULL,
    autor VARCHAR(100) DEFAULT 'Guía',
    fecha DATETIME NOT NULL,
    FOREIGN KEY (version_id) REFERENCES version_tt(id)
);

INSERT INTO trabajo_de_titulo (id, nombre, estado)
SELECT 1, 'Optimización de rutas en redes de transporte público', 'en_desarrollo'
WHERE NOT EXISTS (SELECT 1 FROM trabajo_de_titulo WHERE id = 1);

INSERT INTO hito (trabajo_id, nombre, estado, orden_hito)
SELECT 1, 'TT1 · Propuesta de Trabajo de Título', 'completado', 1
WHERE NOT EXISTS (SELECT 1 FROM hito WHERE trabajo_id = 1 AND orden_hito = 1);
INSERT INTO hito (trabajo_id, nombre, estado, orden_hito)
SELECT 1, 'TT2 · Desarrollo del Trabajo de Título', 'en_revision', 2
WHERE NOT EXISTS (SELECT 1 FROM hito WHERE trabajo_id = 1 AND orden_hito = 2);
INSERT INTO hito (trabajo_id, nombre, estado, orden_hito)
SELECT 1, 'Examen de Título', 'pendiente', 3
WHERE NOT EXISTS (SELECT 1 FROM hito WHERE trabajo_id = 1 AND orden_hito = 3);

INSERT INTO accion_pendiente (trabajo_id, descripcion, responsable, estado)
SELECT 1, 'Entregar nueva versión del Trabajo de Título', 'Memorista', 'pendiente'
WHERE NOT EXISTS (SELECT 1 FROM accion_pendiente WHERE trabajo_id = 1 AND descripcion = 'Entregar nueva versión del Trabajo de Título');
INSERT INTO accion_pendiente (trabajo_id, descripcion, responsable, estado)
SELECT 1, 'Revisar versión 2 del Trabajo de Título', 'Guía', 'pendiente'
WHERE NOT EXISTS (SELECT 1 FROM accion_pendiente WHERE trabajo_id = 1 AND descripcion = 'Revisar versión 2 del Trabajo de Título');
INSERT INTO accion_pendiente (trabajo_id, descripcion, responsable, estado)
SELECT 1, 'Corregir anotaciones de la versión 2', 'Memorista', 'pendiente'
WHERE NOT EXISTS (SELECT 1 FROM accion_pendiente WHERE trabajo_id = 1 AND descripcion = 'Corregir anotaciones de la versión 2');

INSERT INTO version_tt (id, trabajo_id, numero_version, fecha_entrega, contenido)
SELECT 1, 1, '1.0', '2026-05-10', 'Primera versión del Trabajo de Título con definición inicial del problema y objetivos.'
WHERE NOT EXISTS (SELECT 1 FROM version_tt WHERE id = 1);
INSERT INTO version_tt (id, trabajo_id, numero_version, fecha_entrega, contenido)
SELECT 2, 1, '2.0', '2026-05-16', 'Segunda versión con ajustes metodológicos y avance del estado del arte.'
WHERE NOT EXISTS (SELECT 1 FROM version_tt WHERE id = 2);
INSERT INTO version_tt (id, trabajo_id, numero_version, fecha_entrega, contenido)
SELECT 3, 1, '3.0', '2026-05-22', 'Tercera versión con propuesta de solución y plan preliminar de validación.'
WHERE NOT EXISTS (SELECT 1 FROM version_tt WHERE id = 3);

INSERT INTO anotacion_tt (comentario, version_id, guia_id, autor, fecha)
SELECT 'Precisar la metodología y justificar las métricas seleccionadas.', 2, 1, 'Guía', '2026-05-18 10:30:00'
WHERE NOT EXISTS (SELECT 1 FROM anotacion_tt WHERE version_id = 2 AND comentario = 'Precisar la metodología y justificar las métricas seleccionadas.');
INSERT INTO anotacion_tt (comentario, version_id, guia_id, autor, fecha)
SELECT 'Agregar una comparación con trabajos relacionados.', 2, 1, 'Guía', '2026-05-19 15:10:00'
WHERE NOT EXISTS (SELECT 1 FROM anotacion_tt WHERE version_id = 2 AND comentario = 'Agregar una comparación con trabajos relacionados.');

CREATE DATABASE IF NOT EXISTS BD06_TRAMITACION CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE BD06_TRAMITACION;

CREATE TABLE IF NOT EXISTS propuesta_tt (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tema VARCHAR(150) NOT NULL,
    memorista VARCHAR(120) NOT NULL,
    contenido TEXT NOT NULL,
    estado_aprobacion VARCHAR(30) DEFAULT 'pendiente',
    fecha_registro DATE NOT NULL
);

CREATE TABLE IF NOT EXISTS anotacion_propuesta (
    id INT AUTO_INCREMENT PRIMARY KEY,
    propuesta_id INT NOT NULL,
    comentario TEXT NOT NULL,
    autor VARCHAR(100) NOT NULL,
    fecha DATE NOT NULL,
    FOREIGN KEY (propuesta_id) REFERENCES propuesta_tt(id)
);

INSERT INTO propuesta_tt (id, nombre_tema, memorista, contenido, estado_aprobacion, fecha_registro)
SELECT 1, 'Optimización de rutas en redes de transporte público', 'Diego Salinas', 'Propuesta orientada a optimizar rutas de transporte público mediante análisis de datos y criterios de eficiencia.', 'pendiente', '2026-05-21'
WHERE NOT EXISTS (SELECT 1 FROM propuesta_tt WHERE id = 1);
INSERT INTO propuesta_tt (id, nombre_tema, memorista, contenido, estado_aprobacion, fecha_registro)
SELECT 2, 'Sistema de apoyo para planificación académica', 'Camila Soto', 'Propuesta para apoyar la planificación académica mediante seguimiento de carga y requisitos.', 'en_revision', '2026-05-20'
WHERE NOT EXISTS (SELECT 1 FROM propuesta_tt WHERE id = 2);
INSERT INTO propuesta_tt (id, nombre_tema, memorista, contenido, estado_aprobacion, fecha_registro)
SELECT 3, 'Visualización de indicadores para gestión universitaria', 'Martín Pérez', 'Propuesta de tablero para visualizar indicadores relevantes de gestión universitaria.', 'aprobada', '2026-05-18'
WHERE NOT EXISTS (SELECT 1 FROM propuesta_tt WHERE id = 3);

INSERT INTO anotacion_propuesta (propuesta_id, comentario, autor, fecha)
SELECT 1, 'Precisar mejor la definición del problema y revisar que los objetivos específicos estén alineados con la solución propuesta.', 'Profesor TT1', '2026-05-21'
WHERE NOT EXISTS (SELECT 1 FROM anotacion_propuesta WHERE propuesta_id = 1 AND comentario LIKE 'Precisar mejor%');
INSERT INTO anotacion_propuesta (propuesta_id, comentario, autor, fecha)
SELECT 1, 'Incluir antecedentes que permitan justificar la relevancia del problema abordado.', 'Profesor TT1', '2026-05-21'
WHERE NOT EXISTS (SELECT 1 FROM anotacion_propuesta WHERE propuesta_id = 1 AND comentario LIKE 'Incluir antecedentes%');
