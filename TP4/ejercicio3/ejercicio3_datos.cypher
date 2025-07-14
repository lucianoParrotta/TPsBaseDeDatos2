
// === LIMPIEZA PREVIA ===
MATCH (n) DETACH DELETE n;

// === CREACIÓN DE NODOS ===

// Usuarios
CREATE (:Usuario {nombre:'Juan'}),
       (:Usuario {nombre:'María'}),
       (:Usuario {nombre:'Pablo'}),
       (:Usuario {nombre:'Elena'});

// Conexiones
MATCH (u1:Usuario {nombre:'Juan'}), (u2:Usuario {nombre:'María'})
CREATE (u1)-[:CONOCE]->(u2), (u2)-[:CONOCE]->(u1);
MATCH (u1:Usuario {nombre:'Juan'}), (u3:Usuario {nombre:'Pablo'})
CREATE (u1)-[:CONOCE]->(u3), (u3)-[:CONOCE]->(u1);
MATCH (u1:Usuario {nombre:'María'}), (u4:Usuario {nombre:'Elena'})
CREATE (u1)-[:CONOCE]->(u4), (u4)-[:CONOCE]->(u1);

// Posts
CREATE (:Post {contenido:'Explorando Neo4j', fecha:'2025-07-01'}),
       (:Post {contenido:'Mi segundo post', fecha:'2025-07-02'}),
       (:Post {contenido:'Tips de Cypher', fecha:'2025-07-03'});

// Relaciones PUBLICA
MATCH (u:Usuario {nombre:'Juan'}), (p:Post {contenido:'Explorando Neo4j'})
CREATE (u)-[:PUBLICA]->(p);
MATCH (u:Usuario {nombre:'María'}), (p:Post {contenido:'Mi segundo post'})
CREATE (u)-[:PUBLICA]->(p);
MATCH (u:Usuario {nombre:'Pablo'}), (p:Post {contenido:'Tips de Cypher'})
CREATE (u)-[:PUBLICA]->(p);

// Habilidades
CREATE (:Habilidad {nombre:'Graph DB', owner:'Juan'}),
       (:Habilidad {nombre:'Cypher', owner:'Juan'}),
       (:Habilidad {nombre:'JavaScript', owner:'María'}),
       (:Habilidad {nombre:'Node.js', owner:'María'}),
       (:Habilidad {nombre:'MongoDB', owner:'Pablo'}),
       (:Habilidad {nombre:'Express', owner:'Pablo'}),
       (:Habilidad {nombre:'React', owner:'Elena'}),
       (:Habilidad {nombre:'Tailwind', owner:'Elena'});

// Relaciones TIENE
MATCH (u:Usuario {nombre:'Juan'}), (h:Habilidad {nombre:'Graph DB', owner:'Juan'})
CREATE (u)-[:TIENE]->(h);
MATCH (u:Usuario {nombre:'Juan'}), (h:Habilidad {nombre:'Cypher', owner:'Juan'})
CREATE (u)-[:TIENE]->(h);
MATCH (u:Usuario {nombre:'María'}), (h:Habilidad {nombre:'JavaScript', owner:'María'})
CREATE (u)-[:TIENE]->(h);
MATCH (u:Usuario {nombre:'María'}), (h:Habilidad {nombre:'Node.js', owner:'María'})
CREATE (u)-[:TIENE]->(h);
MATCH (u:Usuario {nombre:'Pablo'}), (h:Habilidad {nombre:'MongoDB', owner:'Pablo'})
CREATE (u)-[:TIENE]->(h);
MATCH (u:Usuario {nombre:'Pablo'}), (h:Habilidad {nombre:'Express', owner:'Pablo'})
CREATE (u)-[:TIENE]->(h);
MATCH (u:Usuario {nombre:'Elena'}), (h:Habilidad {nombre:'React', owner:'Elena'})
CREATE (u)-[:TIENE]->(h);
MATCH (u:Usuario {nombre:'Elena'}), (h:Habilidad {nombre:'Tailwind', owner:'Elena'})
CREATE (u)-[:TIENE]->(h);

// Endosos
MATCH (endorser:Usuario {nombre:'María'}), (h:Habilidad {nombre:'Graph DB', owner:'Juan'})
CREATE (endorser)-[:ENDOSA]->(h);
MATCH (endorser:Usuario {nombre:'Pablo'}), (h:Habilidad {nombre:'Graph DB', owner:'Juan'})
CREATE (endorser)-[:ENDOSA]->(h);
MATCH (endorser:Usuario {nombre:'Elena'}), (h:Habilidad {nombre:'Cypher', owner:'Juan'})
CREATE (endorser)-[:ENDOSA]->(h);
MATCH (endorser:Usuario {nombre:'Juan'}), (h:Habilidad {nombre:'JavaScript', owner:'María'})
CREATE (endorser)-[:ENDOSA]->(h);
MATCH (endorser:Usuario {nombre:'María'}), (h:Habilidad {nombre:'React', owner:'Elena'})
CREATE (endorser)-[:ENDOSA]->(h);
