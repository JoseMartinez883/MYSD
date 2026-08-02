-- ============================================================
-- (Tablas) Creacion de tablas
-- ============================================================

CREATE TABLE Room_type (
    id          VARCHAR2(6),
    description VARCHAR2(100)
);

CREATE TABLE Rate (
    room_type_id  VARCHAR2(6),
    occupancy     NUMBER(11),
    amount        NUMBER(10,2)
);

-- TRoom: NUMBER(3), valores de 101 a 999 descartando multiplos de 100
-- TNatural: NUMBER(11), debe ser mayor o igual a 1
CREATE TABLE Room (
    id            NUMBER(3),
    room_type_id  VARCHAR2(6),
    max_occupancy NUMBER(11)
);

-- ============================================================
-- (Atributos) Definicion de restricciones para un unico atributo (Tipos)
-- ============================================================

-- max_occupancy debe ser >= 1 (TNatural)
ALTER TABLE Room
    ADD CONSTRAINT CK_ROOM_MAX_OCCUPANCY CHECK (max_occupancy >= 1);

-- occupancy de Rate debe ser >= 1 (TNatural)
ALTER TABLE Rate
    ADD CONSTRAINT CK_RATE_OCCUPANCY CHECK (occupancy >= 1);

-- amount de Rate debe ser positivo
ALTER TABLE Rate
    ADD CONSTRAINT CK_RATE_AMOUNT CHECK (amount > 0);

-- ============================================================
-- (Primarias) Definicion de claves primarias
-- ============================================================

ALTER TABLE Room_type
    ADD CONSTRAINT PK_ROOM_TYPE PRIMARY KEY (id);

-- PK de Rate es compuesta: tipo de habitacion + ocupacion
ALTER TABLE Rate
    ADD CONSTRAINT PK_RATE PRIMARY KEY (room_type_id, occupancy);

ALTER TABLE Room
    ADD CONSTRAINT PK_ROOM PRIMARY KEY (id);

-- ============================================================
-- (Unicas) Definicion de claves unicas
-- ============================================================

-- No se encuentraron claves unicas en los conceptos con los que estamos
-- trabajando

-- ============================================================
-- (Foraneas) Definicion de claves foraneas
-- ============================================================

-- Rate referencia a Room_type
ALTER TABLE Rate
    ADD CONSTRAINT FK_RATE_ROOM_TYPE FOREIGN KEY (room_type_id)
        REFERENCES Room_type(id);

-- Room referencia a Room_type
ALTER TABLE Room
    ADD CONSTRAINT FK_ROOM_ROOM_TYPE FOREIGN KEY (room_type_id)
        REFERENCES Room_type(id);

-- ============================================================
-- (XTablas) Eliminacion de tablas
-- ============================================================

/*
DROP TABLE Room;
DROP TABLE Rate;
DROP TABLE Room_type;
*/

-- ============================================================
-- (Consultas) Consulta SQL 
-- ============================================================

-- Consulta todos los datos basicos de la habitacion:
-- identificador id, tipo de habitacion y maxima ocupacion
SELECT r.id, r.room_type_id, r.max_occupancy
FROM Room r;

-- ============================================================
-- (PoblarOK) 
-- ============================================================

-- Poblar Room_type
INSERT INTO Room_type (id, description) VALUES ('SGL', 'Single Room');
INSERT INTO Room_type (id, description) VALUES ('DBL', 'Double Room');
INSERT INTO Room_type (id, description) VALUES ('STE', 'Suite');

-- Poblar Rate
INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('SGL', 1, 80000);
INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('DBL', 1, 90000);
INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('DBL', 2, 120000);
INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('STE', 1, 200000);
INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('STE', 2, 250000);
INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('STE', 3, 300000);
INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('STE', 4, 350000);

-- Poblar Room con datos validos a nivel de atributo
INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (201, 'DBL', 2);
INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (301, 'STE', 4);
COMMIT;

-- ============================================================
-- (PoblarNoOK) Intento de ingreso de datos que violan tipos de datos,
--              restricciones primarias, unicas y foraneas
-- ============================================================

-- [Tipo] Viola CK_ROOM_MAX_OCCUPANCY: max_occupancy = 0, debe ser >= 1
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (401, 'DBL', 0);

-- [Tipo] Viola CK_ROOM_MAX_OCCUPANCY: max_occupancy negativo
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (402, 'DBL', -1);

-- [Tipo] Viola CK_RATE_OCCUPANCY: occupancy = 0 en Rate, debe ser >= 1
-- INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('DBL', 0, 50000);

-- [Tipo] Viola CK_RATE_AMOUNT: amount = 0, debe ser positivo
-- INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('DBL', 3, 0);

-- [Primaria] Viola PK_ROOM: id duplicado
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (201, 'SGL', 1);

-- [Primaria] Viola PK_RATE: combinacion (room_type_id, occupancy) duplicada
-- INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('DBL', 2, 99999);

-- [Primaria] Viola PK_ROOM_TYPE: id duplicado en Room_type
-- INSERT INTO Room_type (id, description) VALUES ('SGL', 'Single repetido');

-- [Foranea] Viola FK_ROOM_ROOM_TYPE: tipo 'XYZ' no existe en Room_type
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (501, 'XYZ', 2);

-- [Foranea] Viola FK_RATE_ROOM_TYPE: tipo 'AAA' no existe en Room_type
-- INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('AAA', 1, 80000);

-- ============================================================
-- (XPoblar) Eliminacion de datos
-- ============================================================
/*
DELETE FROM Room;
DELETE FROM Rate;
DELETE FROM Room_type;
COMMIT;
*/

-- ============================================================
-- (Tuplas) Definicion de restricciones que implican mas de un atributo
-- ============================================================

-- TRoom: id debe estar entre 101 y 999, descartando multiplos de 100
-- Un multiplo de 100 tiene MOD(id, 100) = 0
-- Validos: 101, 205, 999 | Invalidos: 100, 200, 300, 1000
ALTER TABLE Room
    ADD CONSTRAINT CK_ROOM_ID CHECK (
        id BETWEEN 101 AND 999
        AND MOD(id, 100) != 0
    );

-- Los cuartos del primer piso (FLOOR(id/100) = 1, es decir id entre 101 y 199)
-- no pueden tener mas de 2 ocupantes
ALTER TABLE Room
    ADD CONSTRAINT CK_ROOM_ID_MAX_OCCUPANCY CHECK (
        NOT (FLOOR(id / 100) = 1 AND max_occupancy > 2)
    );

-- ============================================================
-- (Acciones) Definicion de las acciones de referencia
-- ============================================================

-- Si se borra un tipo de habitacion se deben eliminar todas sus habitaciones
-- Se elimina la FK existente y se define con ON DELETE CASCADE
ALTER TABLE Room DROP CONSTRAINT FK_ROOM_ROOM_TYPE;

ALTER TABLE Room
    ADD CONSTRAINT FK_ROOM_ROOM_TYPE FOREIGN KEY (room_type_id)
        REFERENCES Room_type(id)
        ON DELETE CASCADE;

-- La FK de Rate tambien se redefine con CASCADE para consistencia del modelo
ALTER TABLE Rate DROP CONSTRAINT FK_RATE_ROOM_TYPE;

ALTER TABLE Rate
    ADD CONSTRAINT FK_RATE_ROOM_TYPE FOREIGN KEY (room_type_id)
        REFERENCES Room_type(id)
        ON DELETE CASCADE;

-- ============================================================
-- (Disparadores) Definicion de disparadores
-- ============================================================

-- TR_ROOM_BI: BEFORE INSERT en Room
-- Automatiza: si no se indica max_occupancy, asigna la ocupacion mayor
--             de los precios del tipo de habitacion
-- Restringe:  no se puede crear si el tipo no tiene precios asignados
--             los cuartos del primer piso no pueden tener mas de 2 ocupantes
CREATE OR REPLACE TRIGGER TR_ROOM_BI
BEFORE INSERT ON Room
FOR EACH ROW
DECLARE
    v_max_occ NUMBER;
BEGIN
    -- Si no se indica max_occupancy, calcular la mayor ocupacion en Rate
    IF :NEW.max_occupancy IS NULL THEN
        SELECT MAX(occupancy)
          INTO v_max_occ
          FROM Rate
         WHERE room_type_id = :NEW.room_type_id;

        -- Si no hay precios para ese tipo, no se puede crear la habitacion
        IF v_max_occ IS NULL THEN
            RAISE_APPLICATION_ERROR(
                -20001,
                'No se puede crear la habitacion: el tipo no tiene precios asignados.'
            );
        END IF;

        :NEW.max_occupancy := v_max_occ;
    END IF;

    -- Validar que cuartos del primer piso no superen 2 ocupantes
    IF FLOOR(:NEW.id / 100) = 1 AND :NEW.max_occupancy > 2 THEN
        RAISE_APPLICATION_ERROR(
            -20002,
            'Los cuartos del primer piso no pueden tener mas de 2 ocupantes.'
        );
    END IF;
END TR_ROOM_BI;
/

-- TR_ROOM_BU: BEFORE UPDATE en Room
-- Restringe: el unico dato modificable es max_occupancy
--            y unicamente puede aumentar 
CREATE OR REPLACE TRIGGER TR_ROOM_BU
BEFORE UPDATE ON Room
FOR EACH ROW
BEGIN
    -- No se permite modificar el id
    IF :NEW.id != :OLD.id THEN
        RAISE_APPLICATION_ERROR(
            -20003,
            'No se permite modificar el identificador de la habitacion.'
        );
    END IF;

    -- No se permite modificar el tipo de habitacion
    IF :NEW.room_type_id != :OLD.room_type_id THEN
        RAISE_APPLICATION_ERROR(
            -20004,
            'No se permite modificar el tipo de habitacion.'
        );
    END IF;

    -- max_occupancy solo puede aumentar
    IF :NEW.max_occupancy < :OLD.max_occupancy THEN
        RAISE_APPLICATION_ERROR(
            -20005,
            'La maxima ocupacion solo puede aumentar.'
        );
    END IF;
END TR_ROOM_BU;
/

-- ============================================================
-- (XDisparadores) Eliminacion de disparadores
-- ============================================================
/*
DROP TRIGGER TR_ROOM_BI;
DROP TRIGGER TR_ROOM_BU;
*/

-- ============================================================
-- (TuplasOK) Ingreso de datos correctos segun restricciones de tupla
-- ============================================================

-- Valido: id=101, primer piso, max_occupancy=1 <= 2
INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (101, 'SGL', 1);

-- Valido: id=102, primer piso, max_occupancy=2 (limite permitido)
INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (102, 'DBL', 2);

-- Valido: id=501, quinto piso, sin restriccion de ocupacion por piso
INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (501, 'STE', 4);

-- Valido: id=999, limite superior del rango, no es multiplo de 100
INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (999, 'STE', 3);
COMMIT;

-- ============================================================
-- (TuplasNoOK) Intento de ingreso que viola restricciones de tupla
-- ============================================================

-- [CK_ROOM_ID] id=100, es multiplo de 100, no permitido
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (100, 'SGL', 1);

-- [CK_ROOM_ID] id=200, es multiplo de 100
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (200, 'DBL', 2);

-- [CK_ROOM_ID] id=1000, fuera del rango 101-999
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (1000, 'SGL', 1);

-- [CK_ROOM_ID] id=50, por debajo del rango minimo
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (50, 'SGL', 1);

-- [CK_ROOM_ID_MAX_OCCUPANCY] Primer piso (id=103) con 3 ocupantes, maximo es 2
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (103, 'STE', 3);

-- [CK_ROOM_ID_MAX_OCCUPANCY] Primer piso (id=155) con 5 ocupantes
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (155, 'STE', 5);

-- ============================================================
-- (AccionesOK) Casos que prueban las acciones de referencia
-- ============================================================

-- Insertar un tipo de habitacion con habitaciones asociadas
INSERT INTO Room_type (id, description) VALUES ('TST', 'Tipo Test Cascada');
INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('TST', 1, 50000);
INSERT INTO Rate (room_type_id, occupancy, amount) VALUES ('TST', 2, 75000);
INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (401, 'TST', 2);
INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (402, 'TST', 1);
COMMIT;

-- Al borrar el tipo 'TST', las habitaciones 401 y 402 y sus tarifas
-- deben eliminarse automaticamente por ON DELETE CASCADE
DELETE FROM Room_type WHERE id = 'TST';
COMMIT;

-- Verificar que las habitaciones y tarifas fueron eliminadas en cascada
SELECT * FROM Room WHERE room_type_id = 'TST';        -- debe retornar 0 filas
SELECT * FROM Rate WHERE room_type_id = 'TST';        -- debe retornar 0 filas

-- ============================================================
-- (DisparadoresOK) Ingreso de datos usando los disparadores correctamente
-- ============================================================

-- [TR_ROOM_BI - Automatiza] Insertar sin indicar max_occupancy:
-- el trigger debe asignar automaticamente la mayor ocupacion de Rate para 'DBL' (= 2)
INSERT INTO Room (id, room_type_id) VALUES (601, 'DBL');
-- Verificar que max_occupancy quedo en 2
SELECT id, max_occupancy FROM Room WHERE id = 601;

-- [TR_ROOM_BI - Automatiza] Para tipo 'STE' la mayor ocupacion en Rate es 4
INSERT INTO Room (id, room_type_id) VALUES (602, 'STE');
-- Verificar que max_occupancy quedo en 4
SELECT id, max_occupancy FROM Room WHERE id = 602;

-- [TR_ROOM_BU - Aumentar] Aumentar max_occupancy de 2 a 3 es permitido
UPDATE Room SET max_occupancy = 3 WHERE id = 601;
-- Verificar el cambio
SELECT id, max_occupancy FROM Room WHERE id = 601;
COMMIT;

-- ============================================================
-- (DisparadoresNoOK) Casos que prueban que los disparadores protegen la BD
-- ============================================================

-- [TR_ROOM_BI - Restringe] Insertar en un tipo sin precios asignados
-- Primero crear un tipo sin tarifas
INSERT INTO Room_type (id, description) VALUES ('SIN', 'Sin Precios');
COMMIT;
-- Intentar crear una habitacion de ese tipo: debe fallar con ORA-20001
-- INSERT INTO Room (id, room_type_id) VALUES (701, 'SIN');

-- [TR_ROOM_BI - Restringe] Primer piso con mas de 2 ocupantes via trigger
-- (el CK ya lo bloquea, el trigger agrega el mensaje personalizado)
-- INSERT INTO Room (id, room_type_id, max_occupancy) VALUES (103, 'STE', 4);

-- [TR_ROOM_BU - Restringe] Intentar disminuir max_occupancy: debe fallar con ORA-20005
-- UPDATE Room SET max_occupancy = 1 WHERE id = 601;

-- [TR_ROOM_BU - Restringe] Intentar cambiar el tipo de habitacion: debe fallar con ORA-20004
-- UPDATE Room SET room_type_id = 'SGL' WHERE id = 602;

-- [TR_ROOM_BU - Restringe] Intentar cambiar el id: debe fallar con ORA-20003
-- UPDATE Room SET id = 999 WHERE id = 602;