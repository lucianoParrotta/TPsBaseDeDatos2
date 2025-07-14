
// === CONSULTA 1: Nombre del proyecto, su líder y los empleados asignados ===
MATCH (l:Empleado)-[:LIDERA]->(p:Proyecto)
OPTIONAL MATCH (e:Empleado)-[:TRABAJA_EN]->(p)
RETURN 
  p.nombre     AS proyecto,
  l.nombre     AS lider,
  collect(e.nombre) AS empleados;

// === CONSULTA 2: Total de horas semanales por proyecto ===
MATCH (e:Empleado)-[r:TRABAJA_EN]->(p:Proyecto)
RETURN 
  p.nombre       AS proyecto,
  sum(r.horas)   AS total_horas;

// === CONSULTA 3: Empleados que trabajan en más de un proyecto ===
MATCH (e:Empleado)-[:TRABAJA_EN]->(p:Proyecto)
WITH e, count(DISTINCT p) AS proyectos
WHERE proyectos > 1
RETURN 
  e.nombre      AS empleado,
  proyectos     AS cantidad_de_proyectos;
