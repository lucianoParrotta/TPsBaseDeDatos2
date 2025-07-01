# Trabajo Práctico 1 – Base de Datos II  
**Fundamentos, Integridad y Concurrencia**

---

## Ejercicio 1: Reglas de Integridad

**Consigna:**  
Identificar violaciones posibles si se elimina un estudiante con cursos inscritos. ¿Qué mecanismos usarías para evitarlo?

**Respuesta:**

Se pueden usar las siguientes reglas de integridad referencial sobre la tabla `CursosInscritos`:

- **`ON DELETE RESTRICT`**  
  No permite eliminar un estudiante si tiene cursos inscritos.  
  ➤ Esto obliga a eliminar primero sus inscripciones antes de eliminarlo.

- **`ON DELETE CASCADE`**  
  Elimina automáticamente todos los cursos inscritos del estudiante al eliminarlo.  
  ➤ Útil si se considera que sus inscripciones no tienen valor sin el estudiante.

- **`ON DELETE SET NULL`**  
  Deja el campo `id_estudiante` como `NULL` en `CursosInscritos` si el estudiante es eliminado.  
  ➤ Puede servir si queremos conservar el historial, aunque es ambiguo.

---

## Ejercicio 2: Implementación de Restricciones

```sql
CREATE TABLE Estudiantes (
    id_estudiante INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Cursos (
    id_curso INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Matriculas (
    id_matricula INT PRIMARY KEY,
    id_estudiante INT,
    id_curso INT,
    FOREIGN KEY (id_estudiante) REFERENCES Estudiantes(id_estudiante),
    FOREIGN KEY (id_curso) REFERENCES Cursos(id_curso)
);
```

**Datos válidos:**
```sql
INSERT INTO Estudiantes (id_estudiante, nombre) VALUES (1, 'Ana Pérez');
INSERT INTO Cursos (id_curso, nombre) VALUES (101, 'Matemática');
```

**Datos inválidos:**
```sql
-- Este estudiante NO existe
INSERT INTO Matriculas (id_matricula, id_estudiante, id_curso)
VALUES (1, 99, 101);
```

**Resultado esperado:**  
Error de integridad referencial, ya que `id_estudiante = 99` no existe.

---

## Ejercicio 3: Concurrencia y Niveles de Aislamiento

**Tabla de ejemplo:**
```sql
CREATE TABLE Cuentas (
    id_cuenta INT PRIMARY KEY,
    titular VARCHAR(100),
    saldo DECIMAL(10,2)
);

INSERT INTO Cuentas VALUES (1, 'Juan Pérez', 1000.00);
```

### 🔹 Nivel READ COMMITTED

**Transacción A:**
```sql
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id_cuenta = 1; -- 1000
UPDATE Cuentas SET saldo = 900 WHERE id_cuenta = 1;
COMMIT;
```

**Transacción B:**
```sql
START TRANSACTION;
SELECT saldo FROM Cuentas WHERE id_cuenta = 1; -- 1000
UPDATE Cuentas SET saldo = 900 WHERE id_cuenta = 1;
COMMIT;
```

➤ Ambas transacciones leen el mismo saldo original. Posibilidad de sobrescritura.

---

### 🔹 Nivel SERIALIZABLE

```sql
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
```

- Solo una transacción puede completar.
- La otra se bloquea o genera error de serialización.
- Previene errores de concurrencia.

---

## Ejercicio 4: EXPLAIN y Optimización con Índices

```sql
CREATE TABLE Productos (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(255),
    categoria VARCHAR(100),
    precio DECIMAL(10,2)
);

-- Insertar 100.000 registros
INSERT INTO Productos (nombre, categoria, precio)
SELECT 
  'Producto ' || gs::text,
  CASE WHEN gs % 3 = 0 THEN 'Electronica' 
       WHEN gs % 3 = 1 THEN 'Ropa' 
       ELSE 'Hogar' END,
  (random() * 1000)::numeric(10,2)
FROM generate_series(1, 100000) AS gs;
```

**Consulta sin índice:**
```sql
EXPLAIN SELECT * FROM Productos WHERE categoria = 'Electronica';
```

**Crear índice:**
```sql
CREATE INDEX idx_categoria ON Productos(categoria);
```

**Consulta con índice:**
```sql
EXPLAIN SELECT * FROM Productos WHERE categoria = 'Electronica';
```

➤ El uso del índice mejora el rendimiento al evitar escaneos secuenciales.

## Ejercicio 5: Índices Simples vs Compuestos

**Tabla:**
```sql
CREATE TABLE Empleados (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    departamento VARCHAR(50),
    ciudad VARCHAR(50),
    salario DECIMAL(10,2)
);
```

**Insertar 100.000 registros:**
```sql
INSERT INTO Empleados (nombre, departamento, ciudad, salario)
SELECT
  'Empleado_' || gs::text,
  CASE WHEN gs % 5 = 0 THEN 'Ventas'
       WHEN gs % 5 = 1 THEN 'IT'
       WHEN gs % 5 = 2 THEN 'RRHH'
       WHEN gs % 5 = 3 THEN 'Finanzas'
       ELSE 'Marketing' END,
  CASE WHEN gs % 3 = 0 THEN 'Córdoba'
       WHEN gs % 3 = 1 THEN 'Buenos Aires'
       ELSE 'Rosario' END,
  (random() * 50000 + 30000)::numeric(10,2)
FROM generate_series(1, 100000) AS gs;
```

**Consulta a optimizar:**
```sql
SELECT * FROM Empleados
WHERE departamento = 'Ventas' AND ciudad = 'Córdoba';
```

**Medición con EXPLAIN ANALYZE:**
```sql
EXPLAIN ANALYZE
SELECT * FROM Empleados
WHERE departamento = 'Ventas' AND ciudad = 'Córdoba';
```

**Índices simples:**
```sql
CREATE INDEX idx_departamento ON Empleados(departamento);
CREATE INDEX idx_ciudad ON Empleados(ciudad);
```

**Índice compuesto:**
```sql
CREATE INDEX idx_dep_ciudad ON Empleados(departamento, ciudad);
```

➤ El índice compuesto es más eficiente si la consulta utiliza ambas columnas en la cláusula WHERE.

---

## Ejercicio 6: Vistas

**Tablas:**
```sql
CREATE TABLE Productos (
    id INT PRIMARY KEY,
    nombre VARCHAR(100)
);

CREATE TABLE Ventas (
    id INT PRIMARY KEY,
    producto_id INT,
    fecha DATE,
    cantidad INT,
    FOREIGN KEY (producto_id) REFERENCES Productos(id)
);
```

**Vista de ventas mensuales por producto:**
```sql
CREATE VIEW VentasMensualesPorProducto AS
SELECT
    producto_id,
    DATE_TRUNC('month', fecha) AS mes,
    SUM(cantidad) AS total_vendido
FROM Ventas
GROUP BY producto_id, DATE_TRUNC('month', fecha);
```

**Consulta de los 5 productos más vendidos:**
```sql
SELECT 
    p.nombre,
    SUM(v.total_vendido) AS total_vendido
FROM VentasMensualesPorProducto v
JOIN Productos p ON v.producto_id = p.id
GROUP BY p.nombre
ORDER BY total_vendido DESC
LIMIT 5;
```

---

## Ejercicio 7: Seguridad

**Base de datos: Comercio**

**Crear usuario con solo lectura:**
```sql
CREATE USER 'analista'@'localhost' IDENTIFIED BY 'clave_segura';

GRANT SELECT ON Comercio.Productos TO 'analista'@'localhost';
GRANT SELECT ON Comercio.Ventas TO 'analista'@'localhost';
```

➤ Al intentar hacer una inserción o modificación, el sistema arrojará error por falta de permisos.

---

## Ejercicio 8: Auditoría con Triggers

**Tablas:**
```sql
CREATE TABLE Clientes (
    id INT PRIMARY KEY AUTO_INCREMENT,
    nombre VARCHAR(100),
    email VARCHAR(100),
    ciudad VARCHAR(50)
);

CREATE TABLE AuditoriaClientes (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    cliente_id INT,
    operacion VARCHAR(10),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    datos_anteriores TEXT,
    datos_nuevos TEXT
);
```

**Trigger para UPDATE:**
```sql
DELIMITER //

CREATE TRIGGER trg_update_cliente
BEFORE UPDATE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaClientes (cliente_id, operacion, datos_anteriores, datos_nuevos)
    VALUES (
        OLD.id,
        'UPDATE',
        CONCAT('Nombre: ', OLD.nombre, ', Email: ', OLD.email, ', Ciudad: ', OLD.ciudad),
        CONCAT('Nombre: ', NEW.nombre, ', Email: ', NEW.email, ', Ciudad: ', NEW.ciudad)
    );
END;
//

DELIMITER ;
```

**Trigger para DELETE:**
```sql
DELIMITER //

CREATE TRIGGER trg_delete_cliente
BEFORE DELETE ON Clientes
FOR EACH ROW
BEGIN
    INSERT INTO AuditoriaClientes (cliente_id, operacion, datos_anteriores)
    VALUES (
        OLD.id,
        'DELETE',
        CONCAT('Nombre: ', OLD.nombre, ', Email: ', OLD.email, ', Ciudad: ', OLD.ciudad)
    );
END;
//

DELIMITER ;
```

**Prueba:**
```sql
INSERT INTO Clientes (nombre, email, ciudad) VALUES ('Juan Pérez', 'juan@example.com', 'Rosario');
UPDATE Clientes SET ciudad = 'Santa Fe' WHERE id = 1;
DELETE FROM Clientes WHERE id = 1;
SELECT * FROM AuditoriaClientes;
```

---

## Ejercicio 9: Backup y Restore (PostgreSQL)

**Realizar backup comprimido:**
```bash
pg_dump -U postgres -F c -d nombre_base -f backup_nombre_base.dump
```

**Simular pérdida:**
```bash
DROP DATABASE nombre_base;
```

**Restaurar base de datos:**
```bash
createdb -U postgres nombre_base
pg_restore -U postgres -d nombre_base backup_nombre_base.dump
```
