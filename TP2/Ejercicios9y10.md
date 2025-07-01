# Ejercicio 9
## Replicación y Sharding

### Replica Set
- Es un grupo de servidores que mantienen copias sincronizadas de los mismos datos.
- Sus principales ventajas son:
  - Alta disponibilidad (tolerancia a fallos).
  - Redundancia de datos.
  - Lecturas distribuidas.
- También permite la recuperación automática ante caídas de un nodo.

---

### Sharding
- Es una técnica que divide grandes volúmenes de datos en múltiples servidores (shards).
- Permite:
  - Escalar horizontalmente.
  - Mejorar el rendimiento.
  - Manejar grandes cantidades de datos y realizar consultas en paralelo.

---

# Ejercicio 10
## Seguridad y Backups

### Crear un usuario con permisos de lectura y escritura

Primero, accedemos a la base de datos `admin`:

```javascript
use admin;
```
luego creamos el usuario:
```javascript
db.createUser({
    user: "usuarioApp",
    pwd: "clave",
    roles: [
        { role: "readWrite", db: "empresa" }
    ]
});
```
- Para geerar un backup de la empresa desde la terminal:

    - mongodump --db empresa --out backup_empresa

- Para restaurar la base de datos:

    - mongorestore --db empresa backup_empresa/empresa