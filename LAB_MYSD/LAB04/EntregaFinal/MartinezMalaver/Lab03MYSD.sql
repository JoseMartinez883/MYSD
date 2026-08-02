-- ============================================================
-- CICLO 1: Tablas
-- ============================================================

-- GC: PARTICIPANTES

CREATE TABLE PARTICIPANTES (
    id NUMBER(5) NOT NULL,            
    idt VARCHAR2(2) NOT NULL,        
    idn NUMBER(15) NOT NULL,        
    pais VARCHAR2(15) NOT NULL,       
    correo VARCHAR2(30) NOT NULL    
);

CREATE TABLE PERSONAS (
    id_participante NUMBER(5) NOT NULL,
    nombres VARCHAR2(60) NOT NULL
);

CREATE TABLE CICLISTAS (
    id_persona NUMBER(5) NOT NULL,
    nacimiento DATE NOT NULL,
    categoria NUMBER(1) NOT NULL   
);

CREATE TABLE EMPRESAS (
    id_participante NUMBER(5) NOT NULL,
    razonSocial VARCHAR2(80) NOT NULL
);

-- GC: CARRERAS

CREATE TABLE CARRERAS (
    codigo VARCHAR2(15) NOT NULL,   
    nombre VARCHAR2(30) NOT NULL,
    pais VARCHAR2(15) NOT NULL,      
    categoria NUMBER(1) NOT NULL,    
    periodicidad VARCHAR2(1) NOT NULL 
);

CREATE TABLE PUNTOS (
    nombre VARCHAR2(10) NOT NULL,
    orden NUMBER(2) NOT NULL,
    tipo VARCHAR2(1) NOT NULL,       
    distancia NUMBER(8,2) NOT NULL,
    tiempoLimite NUMBER(9) NOT NULL,
    codigo_carrera VARCHAR2(15) NOT NULL
);

CREATE TABLE SEGMENTOS (
    nombre VARCHAR2(10) NOT NULL,
    tipo VARCHAR2(1) NOT NULL,      
    nombre_iniciaEn VARCHAR2(10) NOT NULL,
    nombre_finalizaEn VARCHAR2(10) NOT NULL
);

CREATE TABLE PROPIEDADDE (
    id_participante NUMBER(5) NOT NULL,
    codigo_carrera  VARCHAR2(15) NOT NULL,
    porcentaje NUMBER(5,2) NOT NULL  
);

-- GC: VERSIONES

CREATE TABLE VERSIONES (
    nombre VARCHAR2(5) NOT NULL,
    fecha DATE NOT NULL,
    codigo_carrera VARCHAR2(15) NOT NULL
);

-- GC: REGISTROS
-- NOTA: numero y fecha son NULL porque se asignan automaticamente
--       por el trigger TR_REGISTROS_BI (CICLO 2 CRUD)
-- GC: REGISTROS

CREATE TABLE REGISTROS (
    numero NUMBER(5),      
    fecha DATE,
    tiempo NUMBER(9) NOT NULL,       
    posicion NUMBER(5) NOT NULL,
    revision VARCHAR2(20),           
    dificultad VARCHAR2(1) NOT NULL, 
    comentario VARCHAR2(20),
    nombre_version VARCHAR2(5) NOT NULL,
    id_ciclista NUMBER(5) NOT NULL,
    nombre_segmento VARCHAR2(10) NOT NULL
);

CREATE TABLE FOTOS (
    id NUMBER(10) NOT NULL,
    url VARCHAR2(50) NOT NULL,
    id_registro NUMBER(10) NOT NULL
);

-- Tablas asociativas N:M
 
CREATE TABLE CICLISTA_VERSION (
    id_ciclista NUMBER(5) NOT NULL,
    nombre_version VARCHAR2(5) NOT NULL
);
 
CREATE TABLE VERSION_SEGMENTO (
    nombre_version VARCHAR2(5) NOT NULL,
    nombre_segmento VARCHAR2(10) NOT NULL
);

CREATE TABLE PARTICIPANTE_VERSION (
    id_participante NUMBER(5) NOT NULL,
    nombre_version VARCHAR2(5) NOT NULL
);

-- GC: EXPERIENCIA DE USUARIOS

CREATE TABLE ENCUESTAS (
    id NUMBER(10) NOT NULL,
    criterio VARCHAR2(30) NOT NULL,
    presupuesto NUMBER(12) NOT NULL,
    valorIncentivo NUMBER(12) NOT NULL,
    fechaInicio DATE NOT NULL,
    fechaFin DATE NOT NULL,
    nombre_version VARCHAR2(5) NOT NULL
);

CREATE TABLE EVALUACIONES (
    id NUMBER(10) NOT NULL,
    fecha DATE NOT NULL,
    puntuacion NUMBER(1) NOT NULL,  
    estado VARCHAR2(15) NOT NULL,   
    detalle_experiencia XMLTYPE NOT NULL, 
    retroalimentacion VARCHAR2(200) NOT NULL,
    origen VARCHAR2(10) NOT NULL,   
    id_encuesta NUMBER(10) NOT NULL,
    id_participante NUMBER(5) NOT NULL
);

CREATE TABLE COMENTARIOS (
    id NUMBER(10) NOT NULL,
    contenido VARCHAR2(50) NOT NULL,
    id_evaluacion NUMBER(10) NOT NULL
);

-- ============================================================
-- CICLO 1: XTablas
-- ============================================================
/**
DROP TABLE COMENTARIOS;
DROP TABLE EVALUACIONES;
DROP TABLE ENCUESTAS;
DROP TABLE FOTOS;
DROP TABLE PARTICIPANTE_VERSION;
DROP TABLE CICLISTA_VERSION;
DROP TABLE VERSION_SEGMENTO;
DROP TABLE REGISTROS;
DROP TABLE VERSIONES;
DROP TABLE PROPIEDADDE;
DROP TABLE SEGMENTOS;
DROP TABLE PUNTOS;
DROP TABLE CARRERAS;
DROP TABLE EMPRESAS;
DROP TABLE CICLISTAS;
DROP TABLE PERSONAS;
DROP TABLE PARTICIPANTES;
*/
 
-- ============================================================
-- CICLO 1: Atributos
-- ============================================================
 
-- GC: PARTICIPANTES
 
ALTER TABLE PARTICIPANTES ADD CONSTRAINT CK_PARTICIPANTES_ID 
    CHECK (id BETWEEN 1 AND 99999);

ALTER TABLE PARTICIPANTES ADD CONSTRAINT CK_PARTICIPANTES_IDT 
    CHECK (idt IN ('CC', 'CE', 'NT'));

ALTER TABLE PARTICIPANTES ADD CONSTRAINT CK_PARTICIPANTES_IDN 
    CHECK (idn >= 1111111111);

ALTER TABLE PARTICIPANTES ADD CONSTRAINT CK_PARTICIPANTES_PAIS 
    CHECK (REGEXP_LIKE(pais, '^[A-Z ]+$') AND LENGTH(pais) <= 15);

ALTER TABLE PARTICIPANTES ADD CONSTRAINT CK_PARTICIPANTES_CORREO 
    CHECK (REGEXP_LIKE(correo, '^[^@]+@[^@]+\.[^@]+$'));

-- GC: CICLISTAS

ALTER TABLE CICLISTAS ADD CONSTRAINT CK_CICLISTAS_CATEGORIA 
    CHECK (categoria BETWEEN 1 AND 5);
    
-- GC: CARRERAS

ALTER TABLE CARRERAS ADD CONSTRAINT CK_CARRERAS_CODIGO 
    CHECK (REGEXP_LIKE(codigo, '^[A-Z]+$') AND LENGTH(codigo) <= 15);

ALTER TABLE CARRERAS ADD CONSTRAINT CK_CARRERAS_PAIS 
    CHECK (REGEXP_LIKE(pais, '^[A-Z ]+$') AND LENGTH(pais) <= 15);

ALTER TABLE CARRERAS ADD CONSTRAINT CK_CARRERAS_CATEGORIA 
    CHECK (categoria BETWEEN 1 AND 5);

ALTER TABLE CARRERAS ADD CONSTRAINT CK_CARRERAS_PERIODICIDAD 
    CHECK (periodicidad IN ('A', 'B', 'S', 'M'));
 
-- GC: PUNTOS
 
ALTER TABLE PUNTOS ADD CONSTRAINT CK_PUNTOS_TIPO 
    CHECK (tipo IN ('P', 'L', 'H', 'A', 'M', 'V', 'C'));
 
ALTER TABLE PUNTOS ADD CONSTRAINT CK_PUNTOS_DISTANCIA
    CHECK (distancia >= 0);
 
ALTER TABLE PUNTOS ADD CONSTRAINT CK_PUNTOS_TIEMPOLIMITE
    CHECK (tiempoLimite > 0);
 
-- GC: SEGMENTOS
 
ALTER TABLE SEGMENTOS ADD CONSTRAINT CK_SEGMENTOS_TIPO 
    CHECK (tipo IN ('C', 'M', 'L'));
 
-- GC: PROPIEDADDE
 
ALTER TABLE PROPIEDADDE ADD CONSTRAINT CK_PROPIEDADDE_PORCENTAJE 
    CHECK (porcentaje BETWEEN 0 AND 100);
 
-- GC: REGISTROS

ALTER TABLE REGISTROS ADD CONSTRAINT CK_REGISTROS_NUMERO 
    CHECK (numero BETWEEN 1 AND 99999);
    
ALTER TABLE REGISTROS ADD CONSTRAINT CK_REGISTROS_POSICION
    CHECK (posicion > 0);
 
ALTER TABLE REGISTROS ADD CONSTRAINT CK_REGISTROS_TIEMPO
    CHECK (tiempo > 0);
 
ALTER TABLE REGISTROS ADD CONSTRAINT CK_REGISTROS_DIFICULTAD 
    CHECK (dificultad IN ('A', 'M', 'B'));
 
ALTER TABLE REGISTROS ADD CONSTRAINT CK_REGISTROS_REVISION
    CHECK (revision IN ('Oficial', 'Pendiente', 'Rechazada'));
 
-- GC: FOTOS
ALTER TABLE FOTOS ADD CONSTRAINT CK_FOTOS_URL 
    CHECK (REGEXP_LIKE(url, '^www\..+\.(gif|pdf)$'));
    
-- GC: ENCUESTAS
 
ALTER TABLE ENCUESTAS ADD CONSTRAINT CK_ENCUESTAS_CRITERIO
    CHECK (criterio IN ('atencion', 'tiempo de espera', 'calidad percibida', 'infraestructura'));
 
ALTER TABLE ENCUESTAS ADD CONSTRAINT CK_ENCUESTAS_PRESUPUESTO
    CHECK (presupuesto > 0);
 
ALTER TABLE ENCUESTAS ADD CONSTRAINT CK_ENCUESTAS_VALORINCENTIVO
    CHECK (valorIncentivo > 0);
 
ALTER TABLE ENCUESTAS ADD CONSTRAINT CK_ENCUESTAS_FECHAS
    CHECK (fechaFin > fechaInicio);
 
-- GC: EVALUACIONES
 
ALTER TABLE EVALUACIONES ADD CONSTRAINT CK_EVALUACIONES_PUNTUACION
    CHECK (puntuacion BETWEEN 1 AND 5);
 
ALTER TABLE EVALUACIONES ADD CONSTRAINT CK_EVALUACIONES_ESTADO
    CHECK (estado IN ('publicada', 'en moderacion', 'validada', 'archivada'));
 
ALTER TABLE EVALUACIONES ADD CONSTRAINT CK_EVALUACIONES_ORIGEN
    CHECK (origen IN ('Web', 'Movil'));
 
 
 -- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- Atributos
-- ============================================================
 
-- Restriccion: un ciclista solo puede tener un unico registro en un segmento
ALTER TABLE REGISTROS ADD CONSTRAINT UQ_REGISTROS_CICLISTA_SEGMENTO
    UNIQUE (id_ciclista, nombre_segmento);
 
-- Restriccion: no pueden quedar dos ciclistas con la misma posicion en un segmento
ALTER TABLE REGISTROS ADD CONSTRAINT UQ_REGISTROS_POSICION_SEGMENTO
    UNIQUE (posicion, nombre_segmento);
    
-- ============================================================
-- CICLO 1: Primarias
-- ============================================================
 
ALTER TABLE PARTICIPANTES ADD CONSTRAINT PK_PARTICIPANTES
    PRIMARY KEY (id);
 
ALTER TABLE PERSONAS ADD CONSTRAINT PK_PERSONAS
    PRIMARY KEY (id_participante);
 
ALTER TABLE CICLISTAS ADD CONSTRAINT PK_CICLISTAS
    PRIMARY KEY (id_persona);
 
ALTER TABLE EMPRESAS ADD CONSTRAINT PK_EMPRESAS
    PRIMARY KEY (id_participante);
 
ALTER TABLE CARRERAS ADD CONSTRAINT PK_CARRERAS
    PRIMARY KEY (codigo);
 
ALTER TABLE PUNTOS ADD CONSTRAINT PK_PUNTOS
    PRIMARY KEY (nombre);
 
ALTER TABLE SEGMENTOS ADD CONSTRAINT PK_SEGMENTOS
    PRIMARY KEY (nombre);
 
ALTER TABLE PROPIEDADDE ADD CONSTRAINT PK_PROPIEDADDE
    PRIMARY KEY (id_participante, codigo_carrera);
 
ALTER TABLE VERSIONES ADD CONSTRAINT PK_VERSIONES
    PRIMARY KEY (nombre);
 
ALTER TABLE FOTOS ADD CONSTRAINT PK_FOTOS
    PRIMARY KEY (id);
 
ALTER TABLE REGISTROS ADD CONSTRAINT PK_REGISTROS
    PRIMARY KEY (numero);
 
ALTER TABLE CICLISTA_VERSION ADD CONSTRAINT PK_CICLISTA_VERSION
    PRIMARY KEY (id_ciclista, nombre_version);
 
ALTER TABLE VERSION_SEGMENTO ADD CONSTRAINT PK_VERSION_SEGMENTO
    PRIMARY KEY (nombre_version, nombre_segmento);
 
ALTER TABLE PARTICIPANTE_VERSION ADD CONSTRAINT PK_PARTICIPANTE_VERSION
    PRIMARY KEY (id_participante, nombre_version);
 
ALTER TABLE ENCUESTAS ADD CONSTRAINT PK_ENCUESTAS
    PRIMARY KEY (id);
 
ALTER TABLE EVALUACIONES ADD CONSTRAINT PK_EVALUACIONES
    PRIMARY KEY (id);
 
ALTER TABLE COMENTARIOS ADD CONSTRAINT PK_COMENTARIOS
    PRIMARY KEY (id);
 
-- ============================================================
-- CICLO 1: Únicas
-- ============================================================

-- Las restricciones de valores unicos estan en el ciclo 2
-- Caso de uso 1: Atributos

-- ============================================================
-- CICLO 1: Foráneas
-- ============================================================
 
-- GC: PARTICIPANTES
 
ALTER TABLE PERSONAS ADD CONSTRAINT FK_PERSONAS_PARTICIPANTES
    FOREIGN KEY (id_participante) REFERENCES PARTICIPANTES (id);
 
ALTER TABLE CICLISTAS ADD CONSTRAINT FK_CICLISTAS_PERSONAS
    FOREIGN KEY (id_persona) REFERENCES PERSONAS (id_participante);
 
ALTER TABLE EMPRESAS ADD CONSTRAINT FK_EMPRESAS_PARTICIPANTES
    FOREIGN KEY (id_participante) REFERENCES PARTICIPANTES (id);
 
-- GC: CARRERAS
 
ALTER TABLE PUNTOS ADD CONSTRAINT FK_PUNTOS_CARRERAS
    FOREIGN KEY (codigo_carrera) REFERENCES CARRERAS (codigo);
 
ALTER TABLE SEGMENTOS ADD CONSTRAINT FK_SEGMENTOS_PUNTOS_INICIA
    FOREIGN KEY (nombre_iniciaEn) REFERENCES PUNTOS (nombre);
 
ALTER TABLE SEGMENTOS ADD CONSTRAINT FK_SEGMENTOS_PUNTOS_FINALIZA
    FOREIGN KEY (nombre_finalizaEn) REFERENCES PUNTOS (nombre);
 
ALTER TABLE PROPIEDADDE ADD CONSTRAINT FK_PROPIEDADDE_PARTICIPANTES
    FOREIGN KEY (id_participante) REFERENCES PARTICIPANTES (id);
 
ALTER TABLE PROPIEDADDE ADD CONSTRAINT FK_PROPIEDADDE_CARRERAS
    FOREIGN KEY (codigo_carrera) REFERENCES CARRERAS (codigo);
 
-- GC: VERSIONES
 
ALTER TABLE VERSIONES ADD CONSTRAINT FK_VERSIONES_CARRERAS
    FOREIGN KEY (codigo_carrera) REFERENCES CARRERAS (codigo);
 
ALTER TABLE FOTOS ADD CONSTRAINT FK_FOTOS_REGISTROS
    FOREIGN KEY (id_registro) REFERENCES REGISTROS (numero);
 
-- GC: REGISTROS
 
ALTER TABLE REGISTROS ADD CONSTRAINT FK_REGISTROS_VERSIONES
    FOREIGN KEY (nombre_version) REFERENCES VERSIONES (nombre);
 
ALTER TABLE REGISTROS ADD CONSTRAINT FK_REGISTROS_CICLISTAS
    FOREIGN KEY (id_ciclista) REFERENCES CICLISTAS (id_persona);
 
ALTER TABLE REGISTROS ADD CONSTRAINT FK_REGISTROS_SEGMENTOS
    FOREIGN KEY (nombre_segmento) REFERENCES SEGMENTOS (nombre);
 
-- Tablas asociativas N:M
 
ALTER TABLE CICLISTA_VERSION ADD CONSTRAINT FK_CICLISTA_VERSION_CICLISTAS
    FOREIGN KEY (id_ciclista) REFERENCES CICLISTAS (id_persona);
 
ALTER TABLE CICLISTA_VERSION ADD CONSTRAINT FK_CICLISTA_VERSION_VERSIONES
    FOREIGN KEY (nombre_version) REFERENCES VERSIONES (nombre);
 
ALTER TABLE VERSION_SEGMENTO ADD CONSTRAINT FK_VERSION_SEGMENTO_VERSIONES
    FOREIGN KEY (nombre_version) REFERENCES VERSIONES (nombre);
 
ALTER TABLE VERSION_SEGMENTO ADD CONSTRAINT FK_VERSION_SEGMENTO_SEGMENTOS
    FOREIGN KEY (nombre_segmento) REFERENCES SEGMENTOS (nombre);
 
ALTER TABLE PARTICIPANTE_VERSION ADD CONSTRAINT FK_PARTICIPANTE_VERSION_PARTICIPANTES
    FOREIGN KEY (id_participante) REFERENCES PARTICIPANTES (id);
 
ALTER TABLE PARTICIPANTE_VERSION ADD CONSTRAINT FK_PARTICIPANTE_VERSION_VERSIONES
    FOREIGN KEY (nombre_version) REFERENCES VERSIONES (nombre);
 
-- GC: EXPERIENCIA DE USUARIOS
 
ALTER TABLE ENCUESTAS ADD CONSTRAINT FK_ENCUESTAS_VERSIONES
    FOREIGN KEY (nombre_version) REFERENCES VERSIONES (nombre);
 
ALTER TABLE EVALUACIONES ADD CONSTRAINT FK_EVALUACIONES_ENCUESTAS
    FOREIGN KEY (id_encuesta) REFERENCES ENCUESTAS (id);
 
ALTER TABLE EVALUACIONES ADD CONSTRAINT FK_EVALUACIONES_PARTICIPANTES
    FOREIGN KEY (id_participante) REFERENCES PARTICIPANTES (id);
 
ALTER TABLE COMENTARIOS ADD CONSTRAINT FK_COMENTARIOS_EVALUACIONES
    FOREIGN KEY (id_evaluacion) REFERENCES EVALUACIONES (id);

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- Acciones
-- ============================================================

-- No aplica accion referencial ON DELETE CASCADE para este caso de uso.
-- Las reglas de eliminacion estan controladas por TR_REGISTROS_BD.

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- Disparadores
-- ============================================================
 
-- ------------------------------------------------------------
-- TR_REGISTROS_BI
-- Automatiza: asigna numero y fecha automaticamente al insertar
-- Restringe:  el segmento debe pertenecer a la version indicada
-- Restringe:  el ciclista debe haber participado en esa version
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_REGISTROS_BI
BEFORE INSERT ON REGISTROS
FOR EACH ROW
DECLARE
    v_max_numero  REGISTROS.numero%TYPE;
    v_count       NUMBER;
BEGIN
    -- AUTOMATIZAR: asignar el numero consecutivo
    SELECT NVL(MAX(numero), 0) + 1
    INTO v_max_numero
    FROM REGISTROS;
    :NEW.numero := v_max_numero;
 
    -- AUTOMATIZAR: asignar la fecha actual
    :NEW.fecha := SYSDATE;
 
    -- RESTRINGIR: el segmento debe pertenecer a la version
    SELECT COUNT(*)
    INTO v_count
    FROM VERSION_SEGMENTO
    WHERE nombre_version  = :NEW.nombre_version
      AND nombre_segmento = :NEW.nombre_segmento;
 
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20001,
            'El segmento no pertenece a la version de la carrera indicada.');
    END IF;
    
    -- RESTRINGIR: el ciclista debe haber participado en la version
    SELECT COUNT(*)
    INTO v_count
    FROM CICLISTA_VERSION
    WHERE id_ciclista    = :NEW.id_ciclista
      AND nombre_version = :NEW.nombre_version;
 
    IF v_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20002,
            'El ciclista no participo en la version de la carrera indicada.');
    END IF;
END;
/

-- ------------------------------------------------------------
-- TR_REGISTROS_BU
-- Restringe: solo se pueden modificar revision, comentario y fotos.
--            Cualquier otro campo genera un error.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_REGISTROS_BU
BEFORE UPDATE ON REGISTROS
FOR EACH ROW
BEGIN
    -- RESTRINGIR: numero no puede cambiar
    IF :NEW.numero <> :OLD.numero THEN
        RAISE_APPLICATION_ERROR(-20003,
            'No se puede modificar el numero del registro.');
    END IF;
 
    -- RESTRINGIR: fecha no puede cambiar
    IF :NEW.fecha <> :OLD.fecha THEN
        RAISE_APPLICATION_ERROR(-20004,
            'No se puede modificar la fecha del registro.');
    END IF;
 
    -- RESTRINGIR: tiempo no puede cambiar
    IF :NEW.tiempo <> :OLD.tiempo THEN
        RAISE_APPLICATION_ERROR(-20005,
            'No se puede modificar el tiempo del registro.');
    END IF;
    
    -- RESTRINGIR: posicion no puede cambiar
    IF :NEW.posicion <> :OLD.posicion THEN
        RAISE_APPLICATION_ERROR(-20006,
            'No se puede modificar la posicion del registro.');
    END IF;
 
    -- RESTRINGIR: dificultad no puede cambiar
    IF :NEW.dificultad <> :OLD.dificultad THEN
        RAISE_APPLICATION_ERROR(-20007,
            'No se puede modificar la dificultad del registro.');
    END IF;
 
    -- RESTRINGIR: version no puede cambiar
    IF :NEW.nombre_version <> :OLD.nombre_version THEN
        RAISE_APPLICATION_ERROR(-20008,
            'No se puede modificar la version del registro.');
    END IF;
 
    -- RESTRINGIR: ciclista no puede cambiar
    IF :NEW.id_ciclista <> :OLD.id_ciclista THEN
        RAISE_APPLICATION_ERROR(-20009,
            'No se puede modificar el ciclista del registro.');
    END IF;
 
    -- RESTRINGIR: segmento no puede cambiar
    IF :NEW.nombre_segmento <> :OLD.nombre_segmento THEN
        RAISE_APPLICATION_ERROR(-20010,
            'No se puede modificar el segmento del registro.');
    END IF;
END;
/


-- ------------------------------------------------------------
-- TR_REGISTROS_BD
-- Restringe: solo se puede eliminar si no ha pasado mas de un
--            dia desde que fue creado.
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_REGISTROS_BD
BEFORE DELETE ON REGISTROS
FOR EACH ROW
BEGIN
    -- RESTRINGIR: verificar que no ha pasado mas de un dia
    IF (SYSDATE - :OLD.fecha) > 1 THEN
        RAISE_APPLICATION_ERROR(-20011,
            'No se puede eliminar el registro porque ya paso mas de un dia desde su creacion.');
    END IF;
END;
/

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- XDisparadores
-- ============================================================
 
-- DROP TRIGGER TR_REGISTROS_BI;
-- DROP TRIGGER TR_REGISTROS_BU;
-- DROP TRIGGER TR_REGISTROS_BD;

-- ============================================================
-- CICLO 1: PoblarOK
-- ============================================================

-- GC: PARTICIPANTES
INSERT INTO PARTICIPANTES VALUES (1, 'CC', 1111111111, 'COLOMBIA', 'ana.gomez@mail.com');
INSERT INTO PARTICIPANTES VALUES (2, 'CC', 1222222222, 'COLOMBIA', 'luis.perez@mail.com');
INSERT INTO PARTICIPANTES VALUES (3, 'CE', 1333333333, 'CHILE', 'maria.torres@mail.com');
INSERT INTO PARTICIPANTES VALUES (4, 'NT', 9001234560, 'COLOMBIA', 'info@teamcol.com');
INSERT INTO PARTICIPANTES VALUES (5, 'CC', 1444444444, 'PERU', 'carlos.rios@mail.com');

INSERT INTO PERSONAS VALUES (1, 'Ana Gomez');
INSERT INTO PERSONAS VALUES (2, 'Luis Perez');
INSERT INTO PERSONAS VALUES (3, 'Maria Torres');
INSERT INTO PERSONAS VALUES (5, 'Carlos Rios');

INSERT INTO CICLISTAS VALUES (1, DATE '1990-03-15', 1); -- 1: Elite
INSERT INTO CICLISTAS VALUES (2, DATE '1985-07-22', 2); -- 2: Master
INSERT INTO CICLISTAS VALUES (5, DATE '1995-11-01', 1);

INSERT INTO EMPRESAS VALUES (4, 'Team Colombia SAS');

-- GC: CARRERAS
INSERT INTO CARRERAS VALUES ('VCOL', 'Vuelta Colombia', 'COLOMBIA', 1, 'A'); -- A: Anual
INSERT INTO CARRERAS VALUES ('TCAF', 'Tour del Cafe', 'COLOMBIA', 2, 'A');
INSERT INTO CARRERAS VALUES ('RCN',  'Clasica RCN', 'COLOMBIA', 1, 'A');

INSERT INTO PUNTOS VALUES ('SALIDA1', 1, 'P', 0.00, 540, 'VCOL'); -- P: Partida
INSERT INTO PUNTOS VALUES ('ALTO1',   4, 'H', 95.30, 300, 'VCOL'); -- H: Hidratacion
INSERT INTO PUNTOS VALUES ('META1',   8, 'L', 180.50, 540, 'VCOL'); -- L: Llegada

INSERT INTO SEGMENTOS VALUES ('SEG01', 'M', 'SALIDA1', 'ALTO1'); -- M: Montaña
INSERT INTO SEGMENTOS VALUES ('SEG02', 'M', 'ALTO1', 'META1');   -- D: Descenso

INSERT INTO PROPIEDADDE VALUES (4, 'VCOL', 60.00);
INSERT INTO PROPIEDADDE VALUES (4, 'TCAF', 100.00);

-- GC: VERSIONES
INSERT INTO VERSIONES VALUES ('V24', DATE '2024-06-01', 'VCOL');
INSERT INTO VERSIONES VALUES ('V23', DATE '2023-06-10', 'VCOL');

-- Tablas asociativas N:M
INSERT INTO CICLISTA_VERSION VALUES (1, 'V24');
INSERT INTO CICLISTA_VERSION VALUES (2, 'V24');
INSERT INTO CICLISTA_VERSION VALUES (5, 'V23');

INSERT INTO VERSION_SEGMENTO VALUES ('V24', 'SEG01');
INSERT INTO VERSION_SEGMENTO VALUES ('V25', 'SEG02');

INSERT INTO PARTICIPANTE_VERSION VALUES (1, 'V24');
INSERT INTO PARTICIPANTE_VERSION VALUES (4, 'V23');

-- GC: REGISTROS
INSERT INTO REGISTROS VALUES (1, DATE '2024-06-08', 390, 1, 'Oficial', 'A', 'Gran etapa', 'V24', 1, 'SEG01');
INSERT INTO REGISTROS VALUES (2, DATE '2024-06-08', 410, 2, 'Oficial', 'M', NULL, 'V24', 2, 'SEG01');

-- GC: FOTOS (URL siguiendo regla T)
INSERT INTO FOTOS VALUES (1, 'www.afterride.com/foto1.gif', 1);
INSERT INTO FOTOS VALUES (2, 'www.afterride.com/foto2.pdf', 1);

-- GC: EXPERIENCIA DE USUARIOS
INSERT INTO ENCUESTAS VALUES (1, 'calidad percibida', 500000, 10000, DATE '2024-06-01', DATE '2024-06-30', 'V24');

-- Nota: detalle_experiencia requiere un XML válido en Oracle
INSERT INTO EVALUACIONES VALUES (1, DATE '2024-06-10', 5, 'publicada', 
    XMLTYPE('<experiencia><dispositivo>PC</dispositivo><clima>Soleado</clima></experiencia>'), 
    'Excelente organizacion', 'Web', 1, 1);

INSERT INTO COMENTARIOS VALUES (1, 'Totalmente de acuerdo', 1);

-- ============================================================
-- CICLO 1: PoblarNoOK
-- ============================================================

-- CASOS QUE FALLAN POR REGLAS DE DOMINIO (Aun no hay CHECKs, pero fallarán por tipo de dato o NOT NULL)

-- Caso 1: ID de Participante excede TConsecutivo (NUMBER(5))
-- INSERT INTO PARTICIPANTES VALUES (123456, 'CC', 1111111111, 'COLOMBIA', 'error@mail.com');

-- Caso 2: IDN (Documento) menor al mínimo de TNid (Aun se permite hasta que pongamos el CHECK)
-- INSERT INTO PARTICIPANTES VALUES (10, 'CC', 999, 'COLOMBIA', 'error@mail.com');
-- Se permite por ahora, pero fallará cuando agreguemos la sección de ATRIBUTOS.

-- Caso 3: Categoría fuera de rango (Aun se permite hasta que pongamos el CHECK)
-- INSERT INTO CICLISTAS VALUES (1, DATE '1990-01-01', 9);

-- CASOS QUE YA NO SE PERMITEN POR RESTRICCIONES DECLARATIVAS (NOT NULL)

-- Caso 4: Registro sin dificultad (NOT NULL)
-- INSERT INTO REGISTROS VALUES (3, DATE '2024-06-08', 300, 1, 'OK', NULL, NULL, 'V24', 1, 'SEG01');

-- Caso 5: Carrera sin periodicidad (NOT NULL)
-- INSERT INTO CARRERAS VALUES ('VCOL2', 'Vuelta 2', 'COLOMBIA', 1, NULL);

-- Caso 6: Foto sin URL (NOT NULL)
-- INSERT INTO FOTOS VALUES (99, NULL, 1);

-- ============================================================
-- CICLO 1: PoblarNoOK (con proteccion activa)
-- ============================================================
 
-- Caso 1: Violación de TIdn (debe ser >= 1111111111)
-- INSERT INTO PARTICIPANTES VALUES (6, 'CC', 999999, 'COLOMBIA', 'error@mail.com');

-- Caso 2: Violación de TPais (debe ser MAYÚSCULAS y solo letras/espacios)
-- INSERT INTO PARTICIPANTES VALUES (7, 'CC', 1555555555, 'colombia', 'error@mail.com');

-- Caso 3: Violación de Tcorreo (formato de correo inválido)
-- INSERT INTO PARTICIPANTES VALUES (8, 'CC', 1666666666, 'COLOMBIA', 'correo_sin_punto@dominio');

-- Caso 4: Violación de TCategoria en Ciclista (debe ser entre 1 y 5)
-- INSERT INTO CICLISTAS VALUES (1, DATE '1990-01-01', 9);

-- Caso 5: Violación de TPeriodicidad en Carrera (valor no permitido)
-- INSERT INTO CARRERAS VALUES ('VCOLX', 'Vuelta X', 'COLOMBIA', 1, 'Z');

-- Caso 6: Violación de TFoto (URL no empieza por www. o no termina en .gif/.pdf)
-- INSERT INTO FOTOS VALUES (10, 'http://fotos.com/bici.jpg', 1);

-- Caso 7: Violación de TPuntuación en Evaluación (fuera de rango 1-5)
-- INSERT INTO EVALUACIONES VALUES (99, SYSDATE, 10, 'publicada', XMLTYPE('<exp></exp>'), 'Malo', 'Web', 1, 1);

-- ============================================================
-- CICLO 1: XPoblar
-- ============================================================
 
DELETE FROM COMENTARIOS;
DELETE FROM EVALUACIONES;
DELETE FROM ENCUESTAS;
DELETE FROM FOTOS;
DELETE FROM REGISTROS;
DELETE FROM PARTICIPANTE_VERSION;
DELETE FROM CICLISTA_VERSION;
DELETE FROM VERSION_SEGMENTO;
DELETE FROM VERSIONES;
DELETE FROM PROPIEDADDE;
DELETE FROM SEGMENTOS;
DELETE FROM PUNTOS;
DELETE FROM CARRERAS;
DELETE FROM EMPRESAS;
DELETE FROM CICLISTAS;
DELETE FROM PERSONAS;
DELETE FROM PARTICIPANTES;

-- ============================================================
-- CICLO 1: Consultando
-- ============================================================

-- CICLO 1: Puntos de la carrera
SELECT 
    c.nombre AS carrera,
    p.nombre AS punto,
    p.orden,
    p.tipo,
    p.distancia,
    p.tiempoLimite
FROM PUNTOS p
JOIN CARRERAS c
    ON p.codigo_carrera = c.codigo
ORDER BY c.nombre, p.orden;


-- CICLO 1: Consultar los cinco segmentos con tiempos más cortos
SELECT 
    r.nombre_segmento AS segmento,
    p.nombres         AS ciclista,
    r.tiempo
FROM REGISTROS r
JOIN CICLISTAS c ON r.id_ciclista = c.id_persona
JOIN PERSONAS  p ON c.id_persona  = p.id_participante
ORDER BY r.tiempo ASC
FETCH FIRST 5 ROWS ONLY;


-- CICLO 1: El historial de evaluaciones por participante
SELECT 
    p.nombres                    AS nombre_participante,
    en.criterio                  AS criterio_evaluado,
    COUNT(ev.id)                 AS cantidad_evaluaciones,
    ROUND(AVG(ev.puntuacion), 2) AS promedio_puntuacion,
    SUM(en.valorIncentivo)       AS total_incentivos
FROM EVALUACIONES ev
JOIN PARTICIPANTES pa ON ev.id_participante = pa.id
JOIN PERSONAS      p  ON pa.id             = p.id_participante
JOIN ENCUESTAS     en ON ev.id_encuesta    = en.id
GROUP BY p.nombres, en.criterio
ORDER BY cantidad_evaluaciones DESC;


-- ============================================================
-- CICLO 1:  Construcción:  nuevamente poblando
-- ============================================================

-- GC: PARTICIPANTES
INSERT INTO PARTICIPANTES VALUES (11, 'CC', 1120304050, 'COLOMBIA', 'sofia.m@mail.com');
INSERT INTO PARTICIPANTES VALUES (12, 'CC', 1120304060, 'COLOMBIA', 'juan.k@mail.com');
INSERT INTO PARTICIPANTES VALUES (13, 'CE', 2120304070, 'ECUADOR',  'lucia.p@mail.com');
INSERT INTO PARTICIPANTES VALUES (14, 'NT', 8111111111, 'COLOMBIA', 'admin@teambogota.co');
INSERT INTO PARTICIPANTES VALUES (15, 'CC', 3120304080, 'PERU',     'mario.v@mail.com');
INSERT INTO PARTICIPANTES VALUES (16, 'CE', 4120304090, 'ARGENTINA', 'pablo.r@mail.com');
INSERT INTO PARTICIPANTES VALUES (17, 'CC', 5120304010, 'COLOMBIA', 'elena.s@mail.com');
INSERT INTO PARTICIPANTES VALUES (18, 'CC', 6120304020, 'COLOMBIA', 'fabian.d@mail.com');
INSERT INTO PARTICIPANTES VALUES (19, 'NT', 9111111111, 'COLOMBIA', 'ventas@biciplus.co');
INSERT INTO PARTICIPANTES VALUES (20, 'CC', 7120304030, 'PANAMA',   'beto.c@mail.com');

-- GC: PERSONAS 
INSERT INTO PERSONAS VALUES (11, 'Sofia Mendez');
INSERT INTO PERSONAS VALUES (12, 'Juan Krause');
INSERT INTO PERSONAS VALUES (13, 'Lucia Paz');
INSERT INTO PERSONAS VALUES (15, 'Mario Vargas');
INSERT INTO PERSONAS VALUES (16, 'Pablo Rossi');
INSERT INTO PERSONAS VALUES (17, 'Elena Santos');
INSERT INTO PERSONAS VALUES (18, 'Fabian Duarte');
INSERT INTO PERSONAS VALUES (20, 'Beto Castillo');

-- GC: CICLISTAS
INSERT INTO CICLISTAS VALUES (11, DATE '1998-05-20', 1);
INSERT INTO CICLISTAS VALUES (12, DATE '1992-10-12', 2);
INSERT INTO CICLISTAS VALUES (13, DATE '2000-01-30', 3);
INSERT INTO CICLISTAS VALUES (15, DATE '1988-12-05', 2);
INSERT INTO CICLISTAS VALUES (16, DATE '1995-08-22', 1);
INSERT INTO CICLISTAS VALUES (17, DATE '2002-04-14', 4);
INSERT INTO CICLISTAS VALUES (18, DATE '1991-07-07', 1);
INSERT INTO CICLISTAS VALUES (20, DATE '1999-11-11', 3);

-- GC: EMPRESAS
INSERT INTO EMPRESAS VALUES (14, 'Team Bogota Ciclo');
INSERT INTO EMPRESAS VALUES (19, 'Bici Plus Colombia');

-- GC: CARRERAS
INSERT INTO CARRERAS VALUES ('VUEE', 'Vuelta Ecuador', 'ECUADOR', 1, 'A');
INSERT INTO CARRERAS VALUES ('TANT', 'Tour Antioquia', 'COLOMBIA', 2, 'B');
INSERT INTO CARRERAS VALUES ('CLAS', 'Clasica Sur', 'ARGENTINA', 1, 'A');
INSERT INTO CARRERAS VALUES ('GFON', 'Gran Fondo', 'COLOMBIA', 3, 'S');
INSERT INTO CARRERAS VALUES ('COPA', 'Copa Andes', 'PERU', 1, 'A');
INSERT INTO CARRERAS VALUES ('RUTA', 'Ruta Sol', 'COLOMBIA', 2, 'M');
INSERT INTO CARRERAS VALUES ('CRIT', 'Criterium', 'PANAMA', 1, 'S');
INSERT INTO CARRERAS VALUES ('MAST', 'Master Cup', 'COLOMBIA', 2, 'A');
INSERT INTO CARRERAS VALUES ('JUNI', 'Junior Tour', 'COLOMBIA', 4, 'B');
INSERT INTO CARRERAS VALUES ('FEMI', 'Tour Fem', 'COLOMBIA', 1, 'A');

-- GC: PUNTOS 
INSERT INTO PUNTOS VALUES ('SALIDA_E', 1, 'P', 0.00, 300, 'VUEE');
INSERT INTO PUNTOS VALUES ('CONTROL1', 2, 'C', 45.00, 120, 'VUEE');
INSERT INTO PUNTOS VALUES ('META_E',   3, 'L', 120.00, 300, 'VUEE');

-- GC: SEGMENTOS
INSERT INTO SEGMENTOS VALUES ('SEG_EC1', 'M', 'SALIDA_E', 'CONTROL1');
INSERT INTO SEGMENTOS VALUES ('SEG_EC2', 'L', 'CONTROL1', 'META_E');

-- GC: VERSIONES
INSERT INTO VERSIONES VALUES ('VE24', DATE '2024-10-10', 'VUEE');
INSERT INTO VERSIONES VALUES ('TA24', DATE '2024-05-15', 'TANT');
INSERT INTO VERSIONES VALUES ('CS24', DATE '2024-03-20', 'CLAS');
INSERT INTO VERSIONES VALUES ('GF24', DATE '2024-07-01', 'GFON');
INSERT INTO VERSIONES VALUES ('CA24', DATE '2024-09-12', 'COPA');
INSERT INTO VERSIONES VALUES ('RS24', DATE '2024-11-05', 'RUTA');
INSERT INTO VERSIONES VALUES ('CR24', DATE '2024-12-01', 'CRIT');
INSERT INTO VERSIONES VALUES ('MC24', DATE '2024-02-15', 'MAST');
INSERT INTO VERSIONES VALUES ('JT24', DATE '2024-08-18', 'JUNI');
INSERT INTO VERSIONES VALUES ('TF24', DATE '2024-06-25', 'FEMI');

-- Tablas asociativas: ciclistas en sus versiones 
INSERT INTO CICLISTA_VERSION VALUES (11, 'VE24');
INSERT INTO CICLISTA_VERSION VALUES (12, 'VE24');
INSERT INTO CICLISTA_VERSION VALUES (13, 'VE24');
INSERT INTO CICLISTA_VERSION VALUES (11, 'TA24');
INSERT INTO CICLISTA_VERSION VALUES (16, 'CS24');
INSERT INTO CICLISTA_VERSION VALUES (18, 'GF24');
INSERT INTO CICLISTA_VERSION VALUES (20, 'CA24');
INSERT INTO CICLISTA_VERSION VALUES (12, 'RS24');
INSERT INTO CICLISTA_VERSION VALUES (11, 'CR24');
INSERT INTO CICLISTA_VERSION VALUES (15, 'MC24');
 
-- Tablas asociativas: segmentos en sus versiones 
INSERT INTO VERSION_SEGMENTO VALUES ('VE24', 'SEG_EC1');
INSERT INTO VERSION_SEGMENTO VALUES ('VE24', 'SEG_EC2');
INSERT INTO VERSION_SEGMENTO VALUES ('TA24', 'SEG_EC1');
INSERT INTO VERSION_SEGMENTO VALUES ('CS24', 'SEG_EC1');
INSERT INTO VERSION_SEGMENTO VALUES ('GF24', 'SEG_EC2');
INSERT INTO VERSION_SEGMENTO VALUES ('CA24', 'SEG_EC1');
INSERT INTO VERSION_SEGMENTO VALUES ('RS24', 'SEG_EC1');
INSERT INTO VERSION_SEGMENTO VALUES ('CR24', 'SEG_EC1');
INSERT INTO VERSION_SEGMENTO VALUES ('MC24', 'SEG_EC1');

INSERT INTO PARTICIPANTE_VERSION VALUES (11, 'VE24');
INSERT INTO PARTICIPANTE_VERSION VALUES (14, 'VE24');
INSERT INTO PARTICIPANTE_VERSION VALUES (19, 'TA24');
-- GC: REGISTROS
-- Nota: numero y fecha se asignan automaticamente por TR_REGISTROS_BI
INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
    VALUES (180, 1, 'Oficial', 'A', 'Nivel pro', 'VE24', 11, 'SEG_EC1');
INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
    VALUES (195, 2, 'Oficial', 'M', NULL, 'VE24', 12, 'SEG_EC1');
INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
    VALUES (220, 1, 'Oficial', 'B', 'Paisa', 'VE24', 13, 'SEG_EC2');
 
-- GC: FOTOS
INSERT INTO FOTOS VALUES (11, 'www.afterride.co/ganador.gif', 1);
INSERT INTO FOTOS VALUES (12, 'www.afterride.co/podio.pdf', 1);
INSERT INTO FOTOS VALUES (13, 'www.afterride.co/meta.gif', 3);


-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- TuplasOK
-- ============================================================
 
-- OK: insertar registro valido para ciclista 13 en SEG_EC1 version VE24
-- Condicion: ciclista 13 participa en VE24 y SEG_EC1 pertenece a VE24
INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
    VALUES (200, 3, 'Oficial', 'M', 'Buen ritmo', 'VE24', 13, 'SEG_EC1');
    
-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- TuplasNoOK
-- ============================================================
 
-- NoOK: ciclista duplicado en el mismo segmento (viola UQ_REGISTROS_CICLISTA_SEGMENTO)
-- Condicion: ciclista 11 ya tiene registro en SEG_EC1
-- INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
--     VALUES (190, 4, 'Oficial', 'A', NULL, 'VE24', 11, 'SEG_EC1');
 
-- NoOK: posicion duplicada en el mismo segmento (viola UQ_REGISTROS_POSICION_SEGMENTO)
-- Condicion: posicion 1 ya existe en SEG_EC1
-- INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
--     VALUES (205, 1, 'Oficial', 'B', NULL, 'VE24', 13, 'SEG_EC1');

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- AccionesOK
-- ============================================================
 
-- No hay acciones referenciales nuevas en este caso de uso.

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- DisparadoresOK
-- ============================================================
 
-- OK 1: Insertar registro valido - trigger asigna numero y fecha automaticamente
-- Condicion: ciclista 12 participa en VE24 y SEG_EC2 pertenece a VE24
INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
    VALUES (310, 4, 'Oficial', 'B', 'Buen descenso', 'VE24', 12, 'SEG_EC2');
 
-- OK 2: Modificar solo el comentario - campo permitido por TR_REGISTROS_BU
-- Condicion: solo cambia comentario, los demas campos quedan igual
UPDATE REGISTROS
    SET comentario = 'Etapa muy tecnica'
    WHERE id_ciclista = 11 AND nombre_segmento = 'SEG_EC1' AND nombre_version = 'VE24';
 
-- OK 3: Modificar solo la revision - campo permitido por TR_REGISTROS_BU
-- Condicion: solo cambia revision, los demas campos quedan igual
UPDATE REGISTROS
    SET revision = 'Pendiente'
    WHERE id_ciclista = 12 AND nombre_segmento = 'SEG_EC1' AND nombre_version = 'VE24';
 
-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- DisparadoresNoOK
-- ============================================================
 
-- NoOK 1: Insertar con ciclista que NO participo en la version
-- Condicion: ciclista 17 no tiene registro en CICLISTA_VERSION para VE24
-- INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
--     VALUES (200, 5, 'Oficial', 'A', NULL, 'VE24', 17, 'SEG_EC1');
 
-- NoOK 2: Insertar con segmento que NO pertenece a la version
-- Condicion: SEG01 no esta en VERSION_SEGMENTO para VE24
-- INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
--     VALUES (200, 6, 'Oficial', 'M', NULL, 'VE24', 11, 'SEG01');
 
-- NoOK 3: Modificar el tiempo - campo NO permitido por TR_REGISTROS_BU
-- Condicion: el trigger debe rechazar el cambio en tiempo
-- UPDATE REGISTROS SET tiempo = 999 WHERE id_ciclista = 11 AND nombre_segmento = 'SEG_EC1';
 
-- NoOK 4: Eliminar registro con mas de un dia de antiguedad
-- Condicion: registros poblados tienen fecha anterior a hoy, TR_REGISTROS_BD debe bloquear
-- DELETE FROM REGISTROS WHERE id_ciclista = 11 AND nombre_segmento = 'SEG_EC1';

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 2: Registrar Evaluación
-- XDisparadores
-- ============================================================
/*
DROP TRIGGER TR_EVALUACION_BI;
DROP TRIGGER TR_EVALUACION_AI;
DROP TRIGGER TR_EVALUACION_BU;
DROP TRIGGER TR_EVALUACION_BD;
*/

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 2: Registrar Evaluación
-- Disparadores
-- ============================================================

-- TRIGGER BI: Automatiza la Fecha y Restringe la vigencia de la encuesta
CREATE OR REPLACE TRIGGER TR_EVALUACION_BI
BEFORE INSERT ON EVALUACIONES
FOR EACH ROW
DECLARE
    v_fecha_inicio DATE;
    v_fecha_fin DATE;
BEGIN
    -- 1. Automatizar Fecha (El sistema pone la fecha actual automáticamente)
    :NEW.fecha := SYSDATE;

    -- 2. Restringir: La encuesta debe estar activa
    SELECT fechaInicio, fechaFin INTO v_fecha_inicio, v_fecha_fin
    FROM ENCUESTAS WHERE id = :NEW.id_encuesta;

    IF :NEW.fecha < v_fecha_inicio OR :NEW.fecha > v_fecha_fin THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: La encuesta no está activa en la fecha actual.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: La encuesta asociada no existe.');
END;
/

-- TRIGGER AI: Verifica fondos y descuenta el presupuesto (Regla Crítica)
CREATE OR REPLACE TRIGGER TR_EVALUACION_AI
AFTER INSERT ON EVALUACIONES
FOR EACH ROW
DECLARE
    v_presupuesto NUMBER;
    v_incentivo NUMBER;
BEGIN
    SELECT presupuesto, valorIncentivo INTO v_presupuesto, v_incentivo
    FROM ENCUESTAS WHERE id = :NEW.id_encuesta;

    -- Verificar si hay suficiente dinero en la encuesta
    IF v_presupuesto >= v_incentivo THEN
        -- Descontar el dinero de la encuesta
        UPDATE ENCUESTAS
        SET presupuesto = presupuesto - v_incentivo
        WHERE id = :NEW.id_encuesta;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'Error: El presupuesto de la encuesta es insuficiente para pagar este incentivo.');
    END IF;
END;
/

-- TRIGGER BU: Restringe qué campos pueden ser modificados
CREATE OR REPLACE TRIGGER TR_EVALUACION_BU
BEFORE UPDATE ON EVALUACIONES
FOR EACH ROW
BEGIN
    -- Si intentan cambiar ID, Fecha, Puntuación, Origen, Encuesta o Participante, lanza error
    IF :OLD.id != :NEW.id OR
       :OLD.fecha != :NEW.fecha OR
       :OLD.puntuacion != :NEW.puntuacion OR
       :OLD.origen != :NEW.origen OR
       :OLD.id_encuesta != :NEW.id_encuesta OR
       :OLD.id_participante != :NEW.id_participante THEN
        
        RAISE_APPLICATION_ERROR(-20004, 'Error: Solo es posible modificar el estado, retroalimentación o detalle de experiencia. Los campos críticos son inmutables.');
    END IF;
END;
/

-- TRIGGER BD: Bloquea cualquier intento de eliminación
CREATE OR REPLACE TRIGGER TR_EVALUACION_BD
BEFORE DELETE ON EVALUACIONES
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20005, 'Error de Seguridad: No es posible eliminar una evaluación una vez registrada en el sistema.');
END;
/

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 2: Registrar Evaluación
-- TuplasOK (Pruebas Exitosas con INSERT/UPDATE directos)
-- ============================================================

-- 1. Creamos una encuesta activa (Fechas desde ayer hasta en 10 días) y con presupuesto
INSERT INTO ENCUESTAS (id, criterio, presupuesto, valorIncentivo, fechaInicio, fechaFin, nombre_version) 
VALUES (100, 'calidad percibida', 500000, 10000, SYSDATE - 1, SYSDATE + 10, 'VE24');

-- 2. Ahora sí, insertamos la Evaluación OK (Apuntando a la encuesta 100 que acabamos de crear)
INSERT INTO EVALUACIONES (id, puntuacion, estado, detalle_experiencia, retroalimentacion, origen, id_encuesta, id_participante)
VALUES (100, 5, 'publicada', XMLTYPE('<experiencia><clima>Bueno</clima></experiencia>'), 'Excelente evento', 'Movil', 100, 12);

-- 3. Modificamos la evaluación (TuplaOK 2)
UPDATE EVALUACIONES 
SET estado = 'en moderacion', 
    retroalimentacion = 'Hubo mucho barro' 
WHERE id = 100;

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 2: Registrar Evaluación
-- TuplasNoOK (Pruebas que deben lanzar error)
-- ============================================================

-- NoOK 1: Intentar modificar un campo inmutable (Puntuación) - TR_EVALUACION_BU lo bloquea
-- UPDATE EVALUACIONES SET puntuacion = 1 WHERE id = 100;

-- NoOK 2: Intentar eliminar una evaluación - TR_EVALUACION_BD lo bloquea
-- DELETE FROM EVALUACIONES WHERE id = 100;

-- NoOK 3: Insertar en una encuesta sin fondos suficientes - TR_EVALUACION_AI lo bloquea
-- (Para probarlo, inserta en una encuesta donde presupuesto < valorIncentivo)


-- Ejecuta esto primero para soltar cualquier proceso pendiente
ROLLBACK;
ALTER SESSION SET DDL_LOCK_TIMEOUT = 30;

-- Borra primero las tablas que dependen de otras (Hijas)
DROP TABLE COMENTARIOS CASCADE CONSTRAINTS;
DROP TABLE EVALUACIONES CASCADE CONSTRAINTS;
DROP TABLE ENCUESTAS CASCADE CONSTRAINTS;
DROP TABLE FOTOS CASCADE CONSTRAINTS;
DROP TABLE REGISTROS CASCADE CONSTRAINTS;
DROP TABLE PARTICIPANTE_VERSION CASCADE CONSTRAINTS;
DROP TABLE CICLISTA_VERSION CASCADE CONSTRAINTS;
DROP TABLE VERSION_SEGMENTO CASCADE CONSTRAINTS;
DROP TABLE PROPIEDADDE CASCADE CONSTRAINTS;
DROP TABLE SEGMENTOS CASCADE CONSTRAINTS;
DROP TABLE PUNTOS CASCADE CONSTRAINTS;
DROP TABLE VERSIONES CASCADE CONSTRAINTS;
DROP TABLE CARRERAS CASCADE CONSTRAINTS;

-- Por último, las tablas maestras (Padres) que te están dando el error
DROP TABLE EMPRESAS CASCADE CONSTRAINTS;
DROP TABLE CICLISTAS CASCADE CONSTRAINTS;
DROP TABLE PERSONAS CASCADE CONSTRAINTS;
DROP TABLE PARTICIPANTES CASCADE CONSTRAINTS;

COMMIT;