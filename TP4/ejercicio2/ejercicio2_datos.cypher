
// === LIMPIEZA PREVIA ===
MATCH (n)
DETACH DELETE n;

// === CREACIÓN DE NODOS ===

// Carreras
CREATE (:Carrera {nombre: 'Ingeniería'}),
       (:Carrera {nombre: 'Arquitectura'}),
       (:Carrera {nombre: 'Literatura'});

// Estudiantes
CREATE (:Estudiante {nombre: 'Lucía'}),
       (:Estudiante {nombre: 'Martín'}),
       (:Estudiante {nombre: 'Sofía'});

// Categorías
CREATE (:Categoria {nombre: 'Tecnología'}),
       (:Categoria {nombre: 'Historia'}),
       (:Categoria {nombre: 'Ficción'}),
       (:Categoria {nombre: 'Diseño'});

// Libros
CREATE (:Libro {titulo: 'Neo4j para Principiantes'}),
       (:Libro {titulo: 'Historia Argentina'}),
       (:Libro {titulo: 'Cuentos Fantásticos'}),
       (:Libro {titulo: 'Diseño Arquitectónico'});

// Relaciones: Estudiantes → Carreras
MATCH (e:Estudiante {nombre:'Lucía'}), (c:Carrera {nombre:'Ingeniería'})
CREATE (e)-[:PERTENECE_A]->(c);

MATCH (e:Estudiante {nombre:'Martín'}), (c:Carrera {nombre:'Arquitectura'})
CREATE (e)-[:PERTENECE_A]->(c);

MATCH (e:Estudiante {nombre:'Sofía'}), (c:Carrera {nombre:'Literatura'})
CREATE (e)-[:PERTENECE_A]->(c);

// Relaciones: Libros → Categorías
MATCH (l:Libro {titulo:'Neo4j para Principiantes'}), (cat:Categoria {nombre:'Tecnología'})
CREATE (l)-[:PERTENECE_A]->(cat);

MATCH (l:Libro {titulo:'Historia Argentina'}), (cat:Categoria {nombre:'Historia'})
CREATE (l)-[:PERTENECE_A]->(cat);

MATCH (l:Libro {titulo:'Cuentos Fantásticos'}), (cat:Categoria {nombre:'Ficción'})
CREATE (l)-[:PERTENECE_A]->(cat);

MATCH (l:Libro {titulo:'Diseño Arquitectónico'}), (cat:Categoria {nombre:'Diseño'})
CREATE (l)-[:PERTENECE_A]->(cat);

// Préstamos
MATCH (e:Estudiante {nombre:'Lucía'}), (l:Libro {titulo:'Neo4j para Principiantes'})
CREATE (e)-[:PIDIO {fecha: '2025-07-01', estado: 'Activo'}]->(l);

MATCH (e:Estudiante {nombre:'Lucía'}), (l:Libro {titulo:'Historia Argentina'})
CREATE (e)-[:PIDIO {fecha: '2025-06-15', estado: 'Devuelto'}]->(l);

MATCH (e:Estudiante {nombre:'Martín'}), (l:Libro {titulo:'Diseño Arquitectónico'})
CREATE (e)-[:PIDIO {fecha: '2025-07-03', estado: 'Activo'}]->(l);

MATCH (e:Estudiante {nombre:'Sofía'}), (l:Libro {titulo:'Cuentos Fantásticos'})
CREATE (e)-[:PIDIO {fecha: '2025-06-25', estado: 'Devuelto'}]->(l);

MATCH (e:Estudiante {nombre:'Sofía'}), (l:Libro {titulo:'Neo4j para Principiantes'})
CREATE (e)-[:PIDIO {fecha: '2025-07-05', estado: 'Activo'}]->(l);
