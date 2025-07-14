
// === LIMPIEZA PREVIA ===
MATCH (n)
DETACH DELETE n;

// === CREACIÓN DE NODOS ===

// Departamentos
CREATE (:Departamento {nombre: 'Recursos Humanos'}),
       (:Departamento {nombre: 'IT'}),
       (:Departamento {nombre: 'Marketing'});

// Empleados
CREATE (:Empleado {nombre: 'Ana'}),
       (:Empleado {nombre: 'Bruno'}),
       (:Empleado {nombre: 'Carla'});

// Proyectos
CREATE (:Proyecto {nombre: 'Intranet'}),
       (:Proyecto {nombre: 'CampañaVerano'});

// === CREACIÓN DE RELACIONES ===

// Empleados → Departamentos
MATCH (a:Empleado {nombre:'Ana'}), (d:Departamento {nombre:'Recursos Humanos'})
CREATE (a)-[:PERTENECE_A]->(d);

MATCH (b:Empleado {nombre:'Bruno'}), (d:Departamento {nombre:'IT'})
CREATE (b)-[:PERTENECE_A]->(d);

MATCH (c:Empleado {nombre:'Carla'}), (d:Departamento {nombre:'Marketing'})
CREATE (c)-[:PERTENECE_A]->(d);

// Empleados → Proyectos con horas
MATCH (a:Empleado {nombre:'Ana'}), (p:Proyecto {nombre:'Intranet'})
CREATE (a)-[:TRABAJA_EN {horas: 20}]->(p);

MATCH (b:Empleado {nombre:'Bruno'}), (p:Proyecto {nombre:'Intranet'})
CREATE (b)-[:TRABAJA_EN {horas: 30}]->(p);

MATCH (c:Empleado {nombre:'Carla'}), (p:Proyecto {nombre:'CampañaVerano'})
CREATE (c)-[:TRABAJA_EN {horas: 25}]->(p);

// Liderazgo
MATCH (a:Empleado {nombre:'Ana'}), (p:Proyecto {nombre:'Intranet'})
CREATE (a)-[:LIDERA]->(p);

MATCH (c:Empleado {nombre:'Carla'}), (p:Proyecto {nombre:'CampañaVerano'})
CREATE (c)-[:LIDERA]->(p);
