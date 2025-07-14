
// === CONSULTA 1: Transcripción académica de un estudiante ===
// Reemplaza 'Ana' por el nombre deseado
MATCH (e:Estudiante {nombre:'Ana'})-[r:INSCRITO]->(c:Curso)-[:CORRESPONDE_A]->(m:Materia)
RETURN 
  e.nombre        AS estudiante,
  m.nombre        AS materia,
  c.codigo        AS curso,
  r.calificacion  AS calificacion
ORDER BY m.nombre;

// === CONSULTA 2: Verificar inscripción según prerrequisitos ===
// Reemplaza 'Lucía' y 'Programación' por el estudiante y materia deseados
WITH 'Lucía' AS est, 'Programación' AS mat
MATCH (e:Estudiante {nombre:est})
MATCH (m:Materia {nombre:mat})
OPTIONAL MATCH (req:Materia)<-[:PRERREQUISITO]-(m)
WITH e, m, collect(req.nombre) AS prerequisitos
OPTIONAL MATCH (e)-[r:INSCRITO]->(:Curso)-[:CORRESPONDE_A]->(reqReq:Materia)
WHERE reqReq.nombre IN prerequisitos AND r.calificacion >= 7
WITH e, m, prerequisitos, collect(reqReq.nombre) AS cumplidos
RETURN
  e.nombre                         AS estudiante,
  m.nombre                         AS materia,
  prerequisitos                    AS prerrequisitos,
  cumplidos                        AS prerrequisitos_aprobados,
  size(prerequisitos)=size(cumplidos) AS puede_inscribirse;

// === CONSULTA 3: Promedio de calificaciones por estudiante ===
MATCH (e:Estudiante)-[r:INSCRITO]->(c:Curso)
RETURN
  e.nombre             AS estudiante,
  avg(r.calificacion)  AS promedio
ORDER BY promedio DESC;

// === CONSULTA 4: Materias con promedio inferior a 7 ===
MATCH (e:Estudiante)-[r:INSCRITO]->(c:Curso)-[:CORRESPONDE_A]->(m:Materia)
WITH m, avg(r.calificacion) AS promedio
WHERE promedio < 7
RETURN
  m.nombre AS materia,
  promedio AS promedio_final;
