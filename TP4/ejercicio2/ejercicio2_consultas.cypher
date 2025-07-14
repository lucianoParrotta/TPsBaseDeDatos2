
// === CONSULTA 1: Libros actualmente prestados (estado "Activo") ===
MATCH (e:Estudiante)-[p:PIDIO]->(l:Libro)
WHERE p.estado = "Activo"
RETURN 
  e.nombre      AS estudiante,
  l.titulo      AS libro,
  p.fecha       AS fecha_prestamo,
  p.estado      AS estado;

// === CONSULTA 2: Cantidad de libros prestados por estudiante ===
MATCH (e:Estudiante)-[:PIDIO]->(l:Libro)
RETURN 
  e.nombre      AS estudiante,
  count(l)      AS cantidad_prestamos;

// === CONSULTA 3: Categorías con más préstamos activos ===
MATCH (e:Estudiante)-[p:PIDIO {estado: "Activo"}]->(l:Libro)-[:PERTENECE_A]->(c:Categoria)
RETURN 
  c.nombre      AS categoria,
  count(*)      AS cantidad_prestamos_activos
ORDER BY cantidad_prestamos_activos DESC;

// === CONSULTA 4: Estudiantes sin préstamos activos ===
MATCH (e:Estudiante)
WHERE NOT (e)-[:PIDIO {estado: "Activo"}]->(:Libro)
RETURN 
  e.nombre AS estudiante_sin_prestamos_activos;
