
// === LIMPIEZA PREVIA ===
MATCH (n) 
DETACH DELETE n;

// === CREACIÓN DE NODOS ===
// Estudiantes
CREATE (:Estudiante {nombre:'Ana'}),
       (:Estudiante {nombre:'Javier'}),
       (:Estudiante {nombre:'Lucía'});

// Materias
CREATE (:Materia {nombre:'Matemáticas'}),
       (:Materia {nombre:'Física'}),
       (:Materia {nombre:'Programación'});

// Prerrequisitos
MATCH (m1:Materia {nombre:'Programación'}), (m2:Materia {nombre:'Matemáticas'})
CREATE (m1)-[:PRERREQUISITO]->(m2);

// Cursos dictados
CREATE (:Curso {codigo:'MAT101', nombre:'Matemáticas I'}),
       (:Curso {codigo:'FIS101', nombre:'Física I'}),
       (:Curso {codigo:'PRO101', nombre:'Programación I'}),
       (:Curso {codigo:'PRO102', nombre:'Programación II'});

// Relacionar Curso → Materia
MATCH (c:Curso {codigo:'MAT101'}), (m:Materia {nombre:'Matemáticas'})
CREATE (c)-[:CORRESPONDE_A]->(m);
MATCH (c:Curso {codigo:'FIS101'}), (m:Materia {nombre:'Física'})
CREATE (c)-[:CORRESPONDE_A]->(m);
MATCH (c:Curso {codigo:'PRO101'}), (m:Materia {nombre:'Programación'})
CREATE (c)-[:CORRESPONDE_A]->(m);
MATCH (c:Curso {codigo:'PRO102'}), (m:Materia {nombre:'Programación'})
CREATE (c)-[:CORRESPONDE_A]->(m);

// Inscripciones y calificaciones
MATCH (e:Estudiante {nombre:'Ana'}), (c:Curso {codigo:'MAT101'})
CREATE (e)-[:INSCRITO {calificacion:8}]->(c);
MATCH (e:Estudiante {nombre:'Ana'}), (c:Curso {codigo:'PRO101'})
CREATE (e)-[:INSCRITO {calificacion:9}]->(c);
MATCH (e:Estudiante {nombre:'Javier'}), (c:Curso {codigo:'MAT101'})
CREATE (e)-[:INSCRITO {calificacion:6}]->(c);
MATCH (e:Estudiante {nombre:'Lucía'}), (c:Curso {codigo:'FIS101'})
CREATE (e)-[:INSCRITO {calificacion:7}]->(c);
MATCH (e:Estudiante {nombre:'Lucía'}), (c:Curso {codigo:'PRO102'})
CREATE (e)-[:INSCRITO {calificacion:8}]->(c);
