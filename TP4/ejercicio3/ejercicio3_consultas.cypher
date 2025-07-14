
// === CONSULTA 1: Usuarios con más conexiones ===
MATCH (u:Usuario)-[:CONOCE]-(:Usuario)
RETURN 
  u.nombre AS usuario,
  count(*) AS conexiones
ORDER BY conexiones DESC;

// === CONSULTA 2: Top 2 usuarios con más publicaciones ===
MATCH (u:Usuario)-[:PUBLICA]->(p:Post)
RETURN 
  u.nombre AS usuario,
  count(p) AS publicaciones
ORDER BY publicaciones DESC
LIMIT 2;

// === CONSULTA 3: Habilidades más endosadas en total ===
MATCH (:Usuario)-[:ENDOSA]->(h:Habilidad)
RETURN 
  h.nombre AS habilidad,
  count(*) AS total_endosos
ORDER BY total_endosos DESC;

// === CONSULTA 4: Habilidades que un usuario no ha endosado aún ===
// Reemplaza 'Juan' por el nombre deseado
MATCH (u:Usuario {nombre:'Juan'})
MATCH (h:Habilidad)
WHERE NOT (u)-[:ENDOSA]->(h)
RETURN 
  h.nombre AS habilidad_sin_endosar;
