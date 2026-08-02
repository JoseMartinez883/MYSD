BEGIN
    FOR cur_rec IN (SELECT object_name, object_type
                    FROM user_objects
                    WHERE object_type IN ('TABLE', 'VIEW', 'PACKAGE', 'PROCEDURE', 'FUNCTION', 'SEQUENCE', 'TRIGGER'))
    LOOP
        BEGIN
            IF cur_rec.object_type = 'TABLE' THEN
                EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '" CASCADE CONSTRAINTS';
            ELSE
                EXECUTE IMMEDIATE 'DROP ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"';
            END IF;
        EXCEPTION
            WHEN OTHERS THEN
                DBMS_OUTPUT.put_line('Falló al borrar: ' || cur_rec.object_type || ' "' || cur_rec.object_name || '"');
        END;
    END LOOP;
END;
/

SET SERVEROUTPUT ON;

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


CREATE TABLE REGISTROS (
    numero NUMBER(5) NOT NULL,      
    fecha DATE NOT NULL,
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
DROP TABLE COMENTARIOS C;
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
 
ALTER TABLE REGISTROS ADD CONSTRAINT UQ_REGISTROS_CICLISTA_SEGMENTO
    UNIQUE (id_ciclista, nombre_segmento);
 
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
-- CICLO 1: unicas
-- ============================================================

-- Las restricciones de valores unicos estan en el ciclo 2

-- ============================================================
-- CICLO 1: Foraneas
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
 
-- FK de Registros usando llaves compuestas hacia las tablas asociativas
ALTER TABLE REGISTROS ADD CONSTRAINT FK_REG_CICLISTA_VERSION
    FOREIGN KEY (id_ciclista, nombre_version) REFERENCES CICLISTA_VERSION (id_ciclista, nombre_version);
 
ALTER TABLE REGISTROS ADD CONSTRAINT FK_REG_VERSION_SEGMENTO
    FOREIGN KEY (nombre_version, nombre_segmento) REFERENCES VERSION_SEGMENTO (nombre_version, nombre_segmento);
 
-- Tablas asociativas N:M
 
ALTER TABLE CICLISTA_VERSION ADD CONSTRAINT FK_CICLISTA_VERSION_CICLISTAS
    FOREIGN KEY (id_ciclista) REFERENCES CICLISTAS (id_persona);
 
ALTER TABLE CICLISTA_VERSION ADD CONSTRAINT FK_CICLISTA_VERSION_VERSIONES
    FOREIGN KEY (nombre_version) REFERENCES VERSIONES (nombre);
 
ALTER TABLE VERSION_SEGMENTO ADD CONSTRAINT FK_VERSION_SEGMENTO_VERSIONES
    FOREIGN KEY (nombre_version) REFERENCES VERSIONES (nombre);
 
ALTER TABLE VERSION_SEGMENTO ADD CONSTRAINT FK_VERSION_SEGMENTO_SEGMENTOS
    FOREIGN KEY (nombre_segmento) REFERENCES SEGMENTOS (nombre);
 
ALTER TABLE PARTICIPANTE_VERSION ADD CONSTRAINT FK_VERSION_PARTICIPANTES
    FOREIGN KEY (id_participante) REFERENCES PARTICIPANTES (id);
 
ALTER TABLE PARTICIPANTE_VERSION ADD CONSTRAINT FK_PARTICIPANTE_VERSIONES
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

-- Las reglas de eliminacion estan controladas por TR_REGISTROS_BD.

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- Disparadores
-- ============================================================
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_REGISTROS_BI
BEFORE INSERT ON REGISTROS
FOR EACH ROW
DECLARE
    v_max_numero  REGISTROS.numero%TYPE;
    v_count       NUMBER;
BEGIN
    
    SELECT NVL(MAX(numero), 0) + 1
    INTO v_max_numero
    FROM REGISTROS;
    :NEW.numero := v_max_numero;
 
    :NEW.fecha := SYSDATE;
    
    -- AutomatizaciÃ³n faltante: El registro nace como pendiente
    IF :NEW.revision IS NULL THEN
        :NEW.revision := 'Pendiente';
    END IF;
    
    -- Nota: Ya no es necesario validar manualmente si el segmento o ciclista
    -- pertenecen a la versiÃ³n porque ahora tenemos FK compuestas que lo
    -- garantizan automÃ¡ticamente a nivel de base de datos.
END;
/

-- ------------------------------------------------------------
-- TR_REGISTROS_BU
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_REGISTROS_BU
BEFORE UPDATE ON REGISTROS
FOR EACH ROW
BEGIN
    IF :NEW.numero <> :OLD.numero THEN
        RAISE_APPLICATION_ERROR(-20003,
            'No se puede modificar el numero del registro.');
    END IF;

    IF :NEW.fecha <> :OLD.fecha THEN
        RAISE_APPLICATION_ERROR(-20104,
            'No se puede modificar la fecha del registro.');
    END IF;
 
    IF :NEW.tiempo <> :OLD.tiempo THEN
        RAISE_APPLICATION_ERROR(-20005,
            'No se puede modificar el tiempo del registro.');
    END IF;
    
    IF :NEW.posicion <> :OLD.posicion THEN
        RAISE_APPLICATION_ERROR(-20006,
            'No se puede modificar la posicion del registro.');
    END IF;
 
    IF :NEW.dificultad <> :OLD.dificultad THEN
        RAISE_APPLICATION_ERROR(-20007,
            'No se puede modificar la dificultad del registro.');
    END IF;
 
    IF :NEW.nombre_version <> :OLD.nombre_version THEN
        RAISE_APPLICATION_ERROR(-20008,
            'No se puede modificar la version del registro.');
    END IF;
 
    IF :NEW.id_ciclista <> :OLD.id_ciclista THEN
        RAISE_APPLICATION_ERROR(-20009,
            'No se puede modificar el ciclista del registro.');
    END IF;
 
    IF :NEW.nombre_segmento <> :OLD.nombre_segmento THEN
        RAISE_APPLICATION_ERROR(-20010,
            'No se puede modificar el segmento del registro.');
    END IF;
END;
/


-- ------------------------------------------------------------
-- TR_REGISTROS_BD
-- ------------------------------------------------------------
CREATE OR REPLACE TRIGGER TR_REGISTROS_BD
BEFORE DELETE ON REGISTROS
FOR EACH ROW
BEGIN
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

INSERT INTO SEGMENTOS VALUES ('SEG01', 'M', 'SALIDA1', 'ALTO1'); -- M: Montaï¿½a
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
INSERT INTO VERSION_SEGMENTO VALUES ('V24', 'SEG02');

INSERT INTO PARTICIPANTE_VERSION VALUES (1, 'V24');
INSERT INTO PARTICIPANTE_VERSION VALUES (4, 'V23');

-- GC: REGISTROS
INSERT INTO REGISTROS VALUES (1, DATE '2024-06-08', 390, 1, 'Oficial', 'A', 'Gran etapa', 'V24', 1, 'SEG01');
INSERT INTO REGISTROS VALUES (2, DATE '2024-06-08', 410, 2, 'Oficial', 'M', NULL, 'V24', 2, 'SEG01');
INSERT INTO REGISTROS VALUES (3, DATE '2024-06-08', 450, 3, 'Oficial', 'B', 'Segmento tranquilo', 'V24', 1, 'SEG02');

-- GC: FOTOS (URL siguiendo regla T)
INSERT INTO FOTOS VALUES (1, 'www.afterride.com/foto1.gif', 1);
INSERT INTO FOTOS VALUES (2, 'www.afterride.com/foto2.pdf', 1);

-- GC: EXPERIENCIA DE USUARIOS
INSERT INTO ENCUESTAS VALUES (1, 'calidad percibida', 500000, 10000, DATE '2024-06-01', DATE '2024-06-30', 'V24');

-- Nota: detalle_experiencia requiere un XML vï¿½lido en Oracle
INSERT INTO EVALUACIONES VALUES (1, DATE '2024-06-10', 5, 'publicada', 
    XMLTYPE('<experiencia><dispositivo>PC</dispositivo><clima>Soleado</clima></experiencia>'), 
    'Excelente organizacion', 'Web', 1, 1);

INSERT INTO COMENTARIOS VALUES (1, 'Totalmente de acuerdo', 1);

-- ============================================================
-- CICLO 1: PoblarNoOK
-- ============================================================

-- CASOS QUE FALLAN POR REGLAS DE DOMINIO (Aun no hay CHECKs, pero fallarian por tipo de dato o NOT NULL)

-- Caso 1: ID de Participante excede TConsecutivo (NUMBER(5))
-- INSERT INTO PARTICIPANTES VALUES (123456, 'CC', 1111111111, 'COLOMBIA', 'error@mail.com');

-- Caso 2: IDN (Documento) menor al mï¿½nimo de TNid (Aun se permite hasta que pongamos el CHECK)
-- INSERT INTO PARTICIPANTES VALUES (10, 'CC', 999, 'COLOMBIA', 'error@mail.com');
-- Se permite por ahora, pero fallarï¿½ cuando agreguemos la secciï¿½n de ATRIBUTOS.

-- Caso 3: Categorï¿½a fuera de rango (Aun se permite hasta que pongamos el CHECK)
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
 
-- Caso 1: Violaciï¿½n de TIdn (debe ser >= 1111111111)
-- INSERT INTO PARTICIPANTES VALUES (6, 'CC', 999999, 'COLOMBIA', 'error@mail.com');

-- Caso 2: Violaciï¿½n de TPais (debe ser MAYï¿½SCULAS y solo letras/espacios)
-- INSERT INTO PARTICIPANTES VALUES (7, 'CC', 1555555555, 'colombia', 'error@mail.com');

-- Caso 3: Violaciï¿½n de Tcorreo (formato de correo invï¿½lido)
-- INSERT INTO PARTICIPANTES VALUES (8, 'CC', 1666666666, 'COLOMBIA', 'correo_sin_punto@dominio');

-- Caso 4: Violaciï¿½n de TCategoria en Ciclista (debe ser entre 1 y 5)
-- INSERT INTO CICLISTAS VALUES (1, DATE '1990-01-01', 9);

-- Caso 5: Violaciï¿½n de TPeriodicidad en Carrera (valor no permitido)
-- INSERT INTO CARRERAS VALUES ('VCOLX', 'Vuelta X', 'COLOMBIA', 1, 'Z');

-- Caso 6: Violaciï¿½n de TFoto (URL no empieza por www. o no termina en .gif/.pdf)
-- INSERT INTO FOTOS VALUES (10, 'http://fotos.com/bici.jpg', 1);

-- Caso 7: Violaciï¿½n de TPuntuaciï¿½n en Evaluaciï¿½n (fuera de rango 1-5)
-- INSERT INTO EVALUACIONES VALUES (99, SYSDATE, 10, 'publicada', XMLTYPE('<exp></exp>'), 'Malo', 'Web', 1, 1);

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


-- CICLO 1: Consultar los cinco segmentos con tiempos mï¿½s cortos
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
-- CICLO 1:  Construcciï¿½n:  nuevamente poblando
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
INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
    VALUES (180, 1, 'Oficial', 'A', 'Nivel pro', 'VE24', 11, 'SEG_EC1');
INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
    VALUES (195, 2, 'Oficial', 'M', NULL, 'VE24', 12, 'SEG_EC1');
INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
    VALUES (220, 1, 'Oficial', 'B', 'Paisa', 'VE24', 13, 'SEG_EC2');
 
-- GC: FOTOS
INSERT INTO FOTOS VALUES (11, 'www.afterride.com/ganador.gif', 1);
INSERT INTO FOTOS VALUES (12, 'www.afterride.com/podio.pdf', 1);
INSERT INTO FOTOS VALUES (13, 'www.afterride.com/meta.gif', 2);


-- ============================================================
-- CICLO 2 CRUD - Caso de uso 1: Registrar resultado
-- TuplasOK
-- ============================================================
 
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
INSERT INTO REGISTROS (tiempo, posicion, revision, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
    VALUES (310, 4, 'Oficial', 'B', 'Buen descenso', 'VE24', 12, 'SEG_EC2');
 
UPDATE REGISTROS
    SET comentario = 'Etapa muy tecnica'
    WHERE id_ciclista = 11 AND nombre_segmento = 'SEG_EC1' AND nombre_version = 'VE24';
 
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
-- CICLO 2 CRUD - Caso de uso 2: Registrar Evaluaciï¿½n
-- XDisparadores
-- ============================================================
/*
DROP TRIGGER TR_EVALUACION_BI;
DROP TRIGGER TR_EVALUACION_AI;
DROP TRIGGER TR_EVALUACION_BU;
DROP TRIGGER TR_EVALUACION_BD;
*/

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 2: Registrar Evaluaciï¿½n
-- Disparadores
-- ============================================================

CREATE OR REPLACE TRIGGER TR_EVALUACION_BI
BEFORE INSERT ON EVALUACIONES
FOR EACH ROW
DECLARE
    v_fecha_inicio DATE;
    v_fecha_fin DATE;
BEGIN
    :NEW.fecha := SYSDATE;

    SELECT fechaInicio, fechaFin INTO v_fecha_inicio, v_fecha_fin
    FROM ENCUESTAS WHERE id = :NEW.id_encuesta;

    IF :NEW.fecha < v_fecha_inicio OR :NEW.fecha > v_fecha_fin THEN
        RAISE_APPLICATION_ERROR(-20001, 'Error: La encuesta no estï¿½ activa en la fecha actual.');
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'Error: La encuesta asociada no existe.');
END;
/

CREATE OR REPLACE TRIGGER TR_EVALUACION_AI
AFTER INSERT ON EVALUACIONES
FOR EACH ROW
DECLARE
    v_presupuesto NUMBER;
    v_incentivo NUMBER;
BEGIN
    SELECT presupuesto, valorIncentivo INTO v_presupuesto, v_incentivo
    FROM ENCUESTAS WHERE id = :NEW.id_encuesta;

    IF v_presupuesto >= v_incentivo THEN
        UPDATE ENCUESTAS
        SET presupuesto = presupuesto - v_incentivo
        WHERE id = :NEW.id_encuesta;
    ELSE
        RAISE_APPLICATION_ERROR(-20003, 'Error: El presupuesto de la encuesta es insuficiente para pagar este incentivo.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TR_EVALUACION_BU
BEFORE UPDATE ON EVALUACIONES
FOR EACH ROW
BEGIN
    IF :OLD.id != :NEW.id OR
       :OLD.fecha != :NEW.fecha OR
       :OLD.puntuacion != :NEW.puntuacion OR
       :OLD.origen != :NEW.origen OR
       :OLD.id_encuesta != :NEW.id_encuesta OR
       :OLD.id_participante != :NEW.id_participante THEN
        
        RAISE_APPLICATION_ERROR(-20104, 'Error: Solo es posible modificar el estado, retroalimentaciï¿½n o detalle de experiencia. Los campos crï¿½ticos son inmutables.');
    END IF;
END;
/

CREATE OR REPLACE TRIGGER TR_EVALUACION_BD
BEFORE DELETE ON EVALUACIONES
FOR EACH ROW
BEGIN
    RAISE_APPLICATION_ERROR(-20005, 'Error de Seguridad: No es posible eliminar una evaluaciï¿½n una vez registrada en el sistema.');
END;
/

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 2: Registrar Evaluacion
-- TuplasOK 
-- ============================================================

INSERT INTO ENCUESTAS (id, criterio, presupuesto, valorIncentivo, fechaInicio, fechaFin, nombre_version) 
VALUES (100, 'calidad percibida', 500000, 10000, SYSDATE - 1, SYSDATE + 10, 'VE24');

INSERT INTO EVALUACIONES (id, puntuacion, estado, detalle_experiencia, retroalimentacion, origen, id_encuesta, id_participante)
VALUES (100, 5, 'publicada', XMLTYPE('<experiencia><clima>Bueno</clima></experiencia>'), 'Excelente evento', 'Movil', 100, 12);

UPDATE EVALUACIONES 
SET estado = 'en moderacion', 
    retroalimentacion = 'Hubo mucho barro' 
WHERE id = 100;

-- ============================================================
-- CICLO 2 CRUD - Caso de uso 2: Registrar Evaluaciï¿½n
-- TuplasNoOK 
-- ============================================================

-- NoOK 1: Intentar modificar un campo inmutable (Puntuaciï¿½n) - TR_EVALUACION_BU lo bloquea
-- UPDATE EVALUACIONES SET puntuacion = 1 WHERE id = 100;

-- NoOK 2: Intentar eliminar una evaluaciï¿½n - TR_EVALUACION_BD lo bloquea
-- DELETE FROM EVALUACIONES WHERE id = 100;

-- NoOK 3: Insertar en una encuesta sin fondos suficientes - TR_EVALUACION_AI lo bloquea
-- (Para probarlo, inserta en una encuesta donde presupuesto < valorIncentivo)


-- ============================================================
-- CONSULTAS OPERATIVAS (Punto 3 - Refactorizacion General)
-- ============================================================

-- Consulta: Consultar reporte de desempeno por criterio y plataforma
-- COMO Administrador QUIERO visualizar un reporte consolidado del desempeno de cada criterio segun la plataforma (Web o Movil) PARA PODER tomar decisiones estrategicas.

SELECT 
    en.criterio AS "Criterio Evaluado",
    COUNT(CASE WHEN ev.origen = 'Web' THEN 1 END) AS "Volumen Web",
    COUNT(CASE WHEN ev.origen = 'Movil' THEN 1 END) AS "Volumen Movil",
    ROUND(AVG(ev.puntuacion), 1) AS "Indice de Calidad",
    NVL(SUM(en.valorIncentivo), 0) AS "Inversion Total"
FROM ENCUESTAS en
JOIN EVALUACIONES ev ON en.id = ev.id_encuesta
GROUP BY en.criterio
ORDER BY "Indice de Calidad" DESC;

-- ============================================================
-- Realizacion del Lab 05 (insercion de los datos)
-- ============================================================

ALTER TABLE PARTICIPANTES DROP CONSTRAINT CK_PARTICIPANTES_IDN;

-- PASO 1: Importar a PARTICIPANTES
INSERT INTO PARTICIPANTES (id, idt, idn, pais, correo)
SELECT 
    ROWNUM + (SELECT NVL(MAX(id), 0) FROM PARTICIPANTES),
    'CC',
    NUMERO,
    SUBSTR(REGEXP_REPLACE(UPPER(NVL(PAIS, 'DESCONOCIDO')), '[^A-Z ]', ''), 1, 15),
    CASE 
        WHEN CORREO IS NULL OR LENGTH(CORREO) > 30 THEN 'u' || NUMERO || '@imp.com'
        ELSE CORREO
    END
FROM (
    SELECT NUMERO, PAIS, CORREO,
           ROW_NUMBER() OVER(PARTITION BY NUMERO ORDER BY NUMERO) as rn
    FROM mbda.DATA
    WHERE NUMERO IS NOT NULL
      AND NUMERO <= 999999999999999 
      AND NUMERO NOT IN (SELECT idn FROM PARTICIPANTES)
)
WHERE rn = 1;

-- PASO 2: Importar a PERSONAS
INSERT INTO PERSONAS (id_participante, nombres)
SELECT p.id,
       SUBSTR(TRIM(
           NVL(d.NOMBRE, '') || 
           CASE WHEN d.NOMBRE IS NOT NULL AND d.APELLIDO IS NOT NULL THEN ' ' ELSE '' END || 
           NVL(d.APELLIDO, '')
       ), 1, 60)
FROM (
    SELECT NUMERO, NOMBRE, APELLIDO,
           ROW_NUMBER() OVER(PARTITION BY NUMERO ORDER BY NUMERO) as rn
    FROM mbda.DATA
    WHERE NUMERO IS NOT NULL
      AND NUMERO <= 999999999999999
      AND (NOMBRE IS NOT NULL OR APELLIDO IS NOT NULL)
) d
JOIN PARTICIPANTES p ON p.idn = d.NUMERO
WHERE d.rn = 1
  AND p.id NOT IN (SELECT id_participante FROM PERSONAS);

-- PASO 3: Importar a CICLISTAS 
INSERT INTO CICLISTAS (id_persona, nacimiento, categoria)
SELECT pe.id_participante,
       TO_DATE(REPLACE(d.NACIMIENTO, '-', '/'), 'DD/MM/RRRR'),
       CASE 
           WHEN d.CATEGORIA > 5 THEN 5
           WHEN d.CATEGORIA < 1 OR d.CATEGORIA IS NULL THEN 1
           ELSE d.CATEGORIA
       END
FROM (
    SELECT NUMERO, NACIMIENTO, CATEGORIA,
           ROW_NUMBER() OVER(PARTITION BY NUMERO ORDER BY NUMERO) as rn
    FROM mbda.DATA
    WHERE NUMERO IS NOT NULL
      AND NUMERO <= 999999999999999
      AND NACIMIENTO IS NOT NULL
      AND REGEXP_LIKE(NACIMIENTO, '^[0-9]{2}[/-][0-9]{2}[/-]([0-9]{2}|[0-9]{4})$')
) d
JOIN PARTICIPANTES p ON p.idn = d.NUMERO
JOIN PERSONAS pe ON pe.id_participante = p.id
WHERE d.rn = 1
  AND pe.id_participante NOT IN (SELECT id_persona FROM CICLISTAS);

ALTER TABLE PARTICIPANTES ADD CONSTRAINT CK_PARTICIPANTES_IDN CHECK (idn >= 1111111111) NOVALIDATE;


-- Comprobaciones, esto nos srive para verificar que si haya cumplido las reglas impuestas

-- categorias entre 1 y 5
SELECT categoria, COUNT(*) 
FROM CICLISTAS 
GROUP BY categoria 
ORDER BY categoria;

-- paises que esten dentro de 15 caracteres
SELECT DISTINCT pais 
FROM PARTICIPANTES 
WHERE idt = 'CC';

-- Verificar todos los datos sean unicos
SELECT idn, COUNT(*) 
FROM PARTICIPANTES 
GROUP BY idn 
HAVING COUNT(*) > 1;

--Consulta de todos los datos nuevos
-- SELECT * FROM PARTICIPANTES;

-- comprobacion de la tabla de datos poblados, cuantos datos quedaron en cada uno
SELECT 'PARTICIPANTES' AS Tabla, COUNT(*) AS Total FROM PARTICIPANTES
UNION ALL
SELECT 'PERSONAS', COUNT(*) FROM PERSONAS
UNION ALL
SELECT 'CICLISTAS',COUNT(*) FROM CICLISTAS
UNION ALL
SELECT 'EMPRESAS', COUNT(*) FROM EMPRESAS;

-- ============================================================
-- PARTE II: MODELO FISICO DE DATOS - CU1: Registrar Resultado
-- Vistas
-- ============================================================

-- Vista 1: Registros con tiempos (soporta consulta operativa "5 segmentos con tiempos mas cortos")
CREATE OR REPLACE VIEW VI_REGISTRO_TIEMPOS AS
SELECT 
    r.nombre_segmento   AS segmento,
    pe.nombres          AS ciclista,
    r.tiempo,
    r.nombre_version    AS version,
    r.dificultad,
    r.revision
FROM REGISTROS r
JOIN CICLISTAS c  ON r.id_ciclista = c.id_persona
JOIN PERSONAS  pe ON c.id_persona  = pe.id_participante
ORDER BY r.tiempo ASC;

-- Vista 2: Detalle completo de cada registro con datos enriquecidos
CREATE OR REPLACE VIEW VI_REGISTRO_DETALLE AS
SELECT 
    r.numero,
    r.fecha,
    pe.nombres           AS ciclista,
    r.nombre_segmento    AS segmento,
    s.tipo               AS tipo_segmento,
    r.nombre_version     AS version,
    ca.nombre            AS carrera,
    r.tiempo,
    r.posicion,
    r.dificultad,
    r.revision,
    r.comentario,
    (SELECT COUNT(*) FROM FOTOS f WHERE f.id_registro = r.numero) AS cantidad_fotos
FROM REGISTROS r
JOIN CICLISTAS c   ON r.id_ciclista     = c.id_persona
JOIN PERSONAS  pe  ON c.id_persona      = pe.id_participante
JOIN SEGMENTOS s   ON r.nombre_segmento = s.nombre
JOIN VERSIONES v   ON r.nombre_version  = v.nombre
JOIN CARRERAS  ca  ON v.codigo_carrera  = ca.codigo;

-- Vista 3: Estadisticas por version de carrera
CREATE OR REPLACE VIEW VI_ESTADISTICAS_VERSION AS
SELECT 
    r.nombre_version              AS version,
    ca.nombre                     AS carrera,
    COUNT(*)                      AS total_registros,
    ROUND(AVG(r.tiempo), 2)       AS promedio_tiempo,
    MIN(r.tiempo)                 AS mejor_tiempo,
    MAX(r.tiempo)                 AS peor_tiempo,
    COUNT(DISTINCT r.id_ciclista) AS total_ciclistas
FROM REGISTROS r
JOIN VERSIONES v  ON r.nombre_version = v.nombre
JOIN CARRERAS  ca ON v.codigo_carrera = ca.codigo
GROUP BY r.nombre_version, ca.nombre;

-- ============================================================
-- PARTE II: MODELO FISICO DE DATOS - CU1: Registrar Resultado
-- Indices
-- ============================================================

CREATE INDEX IX_REG_TIEMPO   ON REGISTROS(tiempo);
CREATE INDEX IX_REG_VERSION  ON REGISTROS(nombre_version);
CREATE INDEX IX_REG_CICLISTA ON REGISTROS(id_ciclista);

-- ============================================================
-- PARTE II: MODELO FISICO DE COMPONENTES - CU1: Registrar Resultado
-- CRUDE (Especificacion del Paquete)
-- ============================================================

CREATE OR REPLACE PACKAGE PC_REGISTRO AS

    -- Adicionar un nuevo registro de resultado
    PROCEDURE AD_REGISTRO(
        xTIEMPO           IN NUMBER,
        xPOSICION         IN NUMBER,
        xDIFICULTAD       IN VARCHAR2,
        xCOMENTARIO       IN VARCHAR2,
        xNOMBRE_VERSION   IN VARCHAR2,
        xID_CICLISTA      IN NUMBER,
        xNOMBRE_SEGMENTO  IN VARCHAR2
    );

    -- Modificar campos permitidos de un registro (comentario y revision)
    PROCEDURE MOD_REGISTRO(
        xID_CICLISTA      IN NUMBER,
        xNOMBRE_SEGMENTO  IN VARCHAR2,
        xNOMBRE_VERSION   IN VARCHAR2,
        xCOMENTARIO       IN VARCHAR2,
        xREVISION         IN VARCHAR2
    );

    -- Eliminar un registro (solo si tiene menos de 24h)
    PROCEDURE ELI_REGISTRO(
        xID_CICLISTA      IN NUMBER,
        xNOMBRE_SEGMENTO  IN VARCHAR2,
        xNOMBRE_VERSION   IN VARCHAR2
    );

    -- Adicionar una foto a un registro existente
    PROCEDURE AD_FOTO(
        xURL              IN VARCHAR2,
        xID_REGISTRO      IN NUMBER
    );

    -- Consultar un registro especifico
    FUNCTION CO_REGISTRO(
        xID_CICLISTA      IN NUMBER,
        xNOMBRE_SEGMENTO  IN VARCHAR2,
        xNOMBRE_VERSION   IN VARCHAR2
    ) RETURN SYS_REFCURSOR;

    -- Consultar los 5 segmentos con tiempos mas cortos
    FUNCTION CO_TOP5_TIEMPOS RETURN SYS_REFCURSOR;

END PC_REGISTRO;
/

-- ====================================================================
-- PARTE II: MODELO FISICO DE COMPONENTES - CU1: Registrar Resultado
-- CRUDI (Implementacion del Paquete)
-- ====================================================================

CREATE OR REPLACE PACKAGE BODY PC_REGISTRO AS

    PROCEDURE AD_REGISTRO(
        xTIEMPO           IN NUMBER,
        xPOSICION         IN NUMBER,
        xDIFICULTAD       IN VARCHAR2,
        xCOMENTARIO       IN VARCHAR2,
        xNOMBRE_VERSION   IN VARCHAR2,
        xID_CICLISTA      IN NUMBER,
        xNOMBRE_SEGMENTO  IN VARCHAR2
    ) IS
    BEGIN
        INSERT INTO REGISTROS (tiempo, posicion, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento)
        VALUES (xTIEMPO, xPOSICION, xDIFICULTAD, xCOMENTARIO, xNOMBRE_VERSION, xID_CICLISTA, xNOMBRE_SEGMENTO);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('OK: Registro creado exitosamente para ciclista ' || xID_CICLISTA || ' en segmento ' || xNOMBRE_SEGMENTO);
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR AD_REGISTRO: ' || SQLERRM);
            RAISE;
    END AD_REGISTRO;

    PROCEDURE MOD_REGISTRO(
        xID_CICLISTA      IN NUMBER,
        xNOMBRE_SEGMENTO  IN VARCHAR2,
        xNOMBRE_VERSION   IN VARCHAR2,
        xCOMENTARIO       IN VARCHAR2,
        xREVISION         IN VARCHAR2
    ) IS
    BEGIN
        UPDATE REGISTROS
        SET comentario = xCOMENTARIO,
            revision   = xREVISION
        WHERE id_ciclista      = xID_CICLISTA
          AND nombre_segmento  = xNOMBRE_SEGMENTO
          AND nombre_version   = xNOMBRE_VERSION;
        
        IF SQL%ROWCOUNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20020, 'El registro especificado no existe.');
        END IF;
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('OK: Registro modificado. Comentario: ' || xCOMENTARIO || ', Revision: ' || xREVISION);
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR MOD_REGISTRO: ' || SQLERRM);
            RAISE;
    END MOD_REGISTRO;

    PROCEDURE ELI_REGISTRO(
        xID_CICLISTA      IN NUMBER,
        xNOMBRE_SEGMENTO  IN VARCHAR2,
        xNOMBRE_VERSION   IN VARCHAR2
    ) IS
        v_numero REGISTROS.numero%TYPE;
    BEGIN
        -- Obtener el numero del registro para borrar sus fotos primero
        SELECT numero INTO v_numero
        FROM REGISTROS
        WHERE id_ciclista      = xID_CICLISTA
          AND nombre_segmento  = xNOMBRE_SEGMENTO
          AND nombre_version   = xNOMBRE_VERSION;

        -- Borrar fotos hijas antes de borrar el registro padre
        DELETE FROM FOTOS WHERE id_registro = v_numero;
        
        -- Borrar el registro (el trigger BD validara la antiguedad)
        DELETE FROM REGISTROS
        WHERE numero = v_numero;
        
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('OK: Registro #' || v_numero || ' y sus fotos eliminados exitosamente.');
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('ERROR ELI_REGISTRO: El registro especificado no existe.');
            RAISE_APPLICATION_ERROR(-20021, 'El registro especificado no existe.');
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR ELI_REGISTRO: ' || SQLERRM);
            RAISE;
    END ELI_REGISTRO;

    PROCEDURE AD_FOTO(
        xURL              IN VARCHAR2,
        xID_REGISTRO      IN NUMBER
    ) IS
        v_next_id FOTOS.id%TYPE;
    BEGIN
        SELECT NVL(MAX(id), 0) + 1 INTO v_next_id FROM FOTOS;
        
        INSERT INTO FOTOS (id, url, id_registro)
        VALUES (v_next_id, xURL, xID_REGISTRO);
        COMMIT;
        DBMS_OUTPUT.PUT_LINE('OK: Foto #' || v_next_id || ' agregada al registro #' || xID_REGISTRO);
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('ERROR AD_FOTO: ' || SQLERRM);
            RAISE;
    END AD_FOTO;

    FUNCTION CO_REGISTRO(
        xID_CICLISTA      IN NUMBER,
        xNOMBRE_SEGMENTO  IN VARCHAR2,
        xNOMBRE_VERSION   IN VARCHAR2
    ) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT *
            FROM VI_REGISTRO_DETALLE
            WHERE numero = (
                SELECT numero FROM REGISTROS
                WHERE id_ciclista      = xID_CICLISTA
                  AND nombre_segmento  = xNOMBRE_SEGMENTO
                  AND nombre_version   = xNOMBRE_VERSION
            );
        RETURN v_cursor;
    END CO_REGISTRO;

    FUNCTION CO_TOP5_TIEMPOS RETURN SYS_REFCURSOR IS 
    v_cur SYS_REFCURSOR;
    BEGIN
        OPEN v_cur FOR
            SELECT * FROM (
                SELECT r.nombre_version, p.nombres AS nombre_ciclista, r.posicion, r.tiempo
                FROM REGISTROS r
                JOIN PERSONAS p ON r.id_ciclista = p.id_participante
                ORDER BY r.tiempo ASC
            )
            WHERE ROWNUM <= 5;
        RETURN v_cur;
    END CO_TOP5_TIEMPOS;

END PC_REGISTRO;
/

-- ============================================================
-- PARTE II: CU1 - Registrar Resultado
-- CRUDOK 
-- ============================================================
-- 1. LA BARREDORA (Se asegura de limpiar la basura del intento anterior)
DELETE FROM FOTOS WHERE id_registro IN (SELECT numero FROM REGISTROS WHERE id_ciclista = 99);
DELETE FROM REGISTROS WHERE id_ciclista = 99;
DELETE FROM VERSION_SEGMENTO WHERE nombre_version = 'VTST';
DELETE FROM PARTICIPANTE_VERSION WHERE nombre_version = 'VTST';
DELETE FROM CICLISTA_VERSION WHERE id_ciclista = 99;
DELETE FROM VERSIONES WHERE nombre = 'VTST';
DELETE FROM SEGMENTOS WHERE nombre = 'SEGTST';
DELETE FROM PUNTOS WHERE nombre IN ('PTST1', 'PTST2');
DELETE FROM CARRERAS WHERE codigo = 'CARTST';
DELETE FROM CICLISTAS WHERE id_persona = 99;
DELETE FROM PERSONAS WHERE id_participante = 99;
DELETE FROM PARTICIPANTES WHERE id = 99;
COMMIT;

-- 2. LOS INSERTS LIMPIOS (Con el IDN corregido a 10 digitos)
INSERT INTO PARTICIPANTES VALUES (99, 'CC', 9999999999, 'COLOMBIA', 'prueba@test.com');
INSERT INTO PERSONAS VALUES (99, 'Ciclista Prueba');
INSERT INTO CICLISTAS VALUES (99, DATE '1995-01-01', 1);

INSERT INTO CARRERAS VALUES ('CARTST', 'Carrera Test', 'COLOMBIA', 1, 'A');
INSERT INTO PUNTOS VALUES ('PTST1', 1, 'P', 0, 100, 'CARTST');
INSERT INTO PUNTOS VALUES ('PTST2', 2, 'L', 10, 100, 'CARTST');
INSERT INTO SEGMENTOS VALUES ('SEGTST', 'M', 'PTST1', 'PTST2');
INSERT INTO VERSIONES VALUES ('VTST', DATE '2024-01-01', 'CARTST');

INSERT INTO CICLISTA_VERSION VALUES (99, 'VTST');
INSERT INTO VERSION_SEGMENTO VALUES ('VTST', 'SEGTST');
INSERT INTO PARTICIPANTE_VERSION VALUES (99, 'VTST');
COMMIT;

---------------------
-- OK 1: Registrar un resultado completo usando el paquete.
--        Demuestra que AD_REGISTRO delega correctamente al trigger BI
--        (auto-numero, fecha=SYSDATE, revision='Pendiente') y que la
--        FK compuesta valida la pertenencia del ciclista a la version.
BEGIN 
    PC_REGISTRO.AD_REGISTRO(185, 1, 'A', 'Etapa montana', 'VTST', 99, 'SEGTST'); 
END;
/

-- OK 2: Modificar el comentario y la revision de un registro existente.
--        Demuestra que MOD_REGISTRO solo toca los campos permitidos
--        mientras el trigger BU protege los demas.
BEGIN
    PC_REGISTRO.MOD_REGISTRO(99, 'SEGTST', 'VTST', 'Revision completada', 'Oficial');
END;
/


-- OK 3: Agregar una foto 
DECLARE
    v_num NUMBER;
BEGIN
    -- Busca el ID real del ciclista 99 y le pega la foto
    SELECT MAX(numero) INTO v_num FROM REGISTROS WHERE id_ciclista = 99;
    PC_REGISTRO.AD_FOTO('www.afterride.com/montana.gif', v_num); 
END;
/

-- OK 4: Consultar los 5 segmentos con tiempos mas cortos.
DECLARE
    v_cur SYS_REFCURSOR;
    v_ver VARCHAR2(5);
    v_cic VARCHAR2(60);
    v_pos NUMBER;
    v_tie NUMBER;
BEGIN
    v_cur := PC_REGISTRO.CO_TOP5_TIEMPOS();
    DBMS_OUTPUT.PUT_LINE('--- TOP 5 TIEMPOS MAS CORTOS ---');
    DBMS_OUTPUT.PUT_LINE('VERSION | CICLISTA           | POSICION | TIEMPO');
    LOOP
        FETCH v_cur INTO v_ver, v_cic, v_pos, v_tie;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_ver || '    | ' || RPAD(v_cic, 18) || ' | ' || LPAD(v_pos, 8) || ' | ' || v_tie || 's');
    END LOOP;
    CLOSE v_cur;
END;
/

-- OK 5: Consultar el registro especifico del Sandbox (Ciclista 99).
DECLARE
    v_cur SYS_REFCURSOR;
    v_num NUMBER; v_fec DATE; v_cic VARCHAR2(60); v_seg VARCHAR2(10);
    v_tip VARCHAR2(1); v_ver VARCHAR2(5); v_car VARCHAR2(30);
    v_tie NUMBER; v_pos NUMBER; v_dif VARCHAR2(1);
    v_rev VARCHAR2(20); v_com VARCHAR2(20); v_fot NUMBER;
BEGIN
    v_cur := PC_REGISTRO.CO_REGISTRO(99, 'SEGTST', 'VTST');
    DBMS_OUTPUT.PUT_LINE('--- DETALLE DEL REGISTRO ---');
    FETCH v_cur INTO v_num, v_fec, v_cic, v_seg, v_tip, v_ver, v_car, v_tie, v_pos, v_dif, v_rev, v_com, v_fot;
    IF v_cur%FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Numero: ' || v_num);
        DBMS_OUTPUT.PUT_LINE('Ciclista: ' || v_cic);
        DBMS_OUTPUT.PUT_LINE('Segmento: ' || v_seg || ' (Tipo: ' || v_tip || ')');
        DBMS_OUTPUT.PUT_LINE('Carrera: ' || v_car || ' - Version: ' || v_ver);
        DBMS_OUTPUT.PUT_LINE('Tiempo: ' || v_tie || 's | Posicion: ' || v_pos);
        DBMS_OUTPUT.PUT_LINE('Revision: ' || v_rev || ' | Fotos: ' || v_fot);
    END IF;
    CLOSE v_cur;
END;
/


-- OK 6: Verificar que las vistas estadisticas funcionan correctamente.
SELECT * FROM VI_ESTADISTICAS_VERSION;

-- ============================================================
-- PARTE II: CU1 - Registrar Resultado
-- CRUDNoOK (Pruebas que deben fallar - demuestran integridad)
-- ============================================================

-- NoOK 1: Intentar registrar con un ciclista que NO participa en la version.
--          La FK compuesta hacia CICLISTA_VERSION debe rechazarlo.
-- EXEC PC_REGISTRO.AD_REGISTRO(200, 5, 'A', NULL, 'VE24', 17, 'SEG_EC1');

-- NoOK 2: Intentar registrar con un segmento que NO pertenece a la version.
--          La FK compuesta hacia VERSION_SEGMENTO debe rechazarlo.
-- EXEC PC_REGISTRO.AD_REGISTRO(200, 6, 'M', NULL, 'VE24', 11, 'SEG01');


-- NoOK 4: Intentar agregar una foto con URL invalida (no cumple el CHECK).
-- EXEC PC_REGISTRO.AD_FOTO('http://fotos.com/bici.jpg', 1);

-- NoOK 5: Intentar eliminar un registro antiguo (mas de 24h).
--          El trigger TR_REGISTROS_BD debe bloquearlo con ORA-20011.
-- EXEC PC_REGISTRO.ELI_REGISTRO(11, 'SEG_EC1', 'VE24');

-- NoOK 6: Intentar consultar un registro que no existe.
--          CO_REGISTRO devuelve un cursor vacio (sin filas).
-- Se puede verificar con un bloque PL/SQL que compruebe v_cur%NOTFOUND.

-- ============================================================
-- PARTE II: CU1 - Registrar Resultado
-- XCRUD (Limpieza)
-- ============================================================

-- DROP VIEW VI_REGISTRO_TIEMPOS;
-- DROP VIEW VI_REGISTRO_DETALLE;
-- DROP VIEW VI_ESTADISTICAS_VERSION;
-- DROP INDEX IX_REG_TIEMPO;
-- DROP INDEX IX_REG_VERSION;
-- DROP INDEX IX_REG_CICLISTA;
-- DROP PACKAGE PC_REGISTRO;

-- BONO
/* ==================================================================
   1. VISTA DE APOYO: VI_EVALUACIONES_REPORTES
   Une los datos necesarios para los reportes de desempeño y participante.
   ================================================================== */
CREATE OR REPLACE VIEW VI_EVALUACIONES_REPORTES AS
SELECT 
    p.nombres             AS nombre_participante,
    en.criterio          AS criterio_evaluado,
    ev.puntuacion,
    en.valorIncentivo    AS incentivo,
    ev.origen,
    ev.id_participante
FROM EVALUACIONES ev
JOIN PARTICIPANTES pa ON ev.id_participante = pa.id
JOIN PERSONAS      p  ON pa.id             = p.id_participante
JOIN ENCUESTAS     en ON ev.id_encuesta    = en.id;


/* ==================================================================
   2. ESPECIFICACIÓN DEL PAQUETE: PC_EVALUACION
   ================================================================== */
CREATE OR REPLACE PACKAGE PC_EVALUACION AS
    -- Adiciona una evaluación (La fecha se pone por Trigger)
    PROCEDURE AD_EVALUACION(
        xnPuntuacion IN NUMBER,
        xvEstado IN VARCHAR2,
        xxDetalle IN XMLTYPE,
        xvRetro IN VARCHAR2,
        xvOrigen IN VARCHAR2,
        xnEncuesta IN NUMBER,
        xnParticipante IN NUMBER
    );

    -- Modifica solo campos permitidos (Estado, Retroalimentación, Detalle)
    PROCEDURE MOD_EVALUACION(
        xnId IN NUMBER,
        xvEstado IN VARCHAR2,
        xvRetro IN VARCHAR2,
        xxDetalle IN XMLTYPE
    );

    -- Intenta eliminar (Chocará con el Trigger de seguridad)
    PROCEDURE ELI_EVALUACION(xnId IN NUMBER);

    -- Consulta 1: Historial de evaluación por participante
    FUNCTION CO_HISTORIAL_PARTICIPANTE(xnParticipante IN NUMBER) RETURN SYS_REFCURSOR;

    -- Consulta 2: Reporte de desempeño por criterio y plataforma
    FUNCTION CO_REPORTE_DESEMPENO RETURN SYS_REFCURSOR;
END PC_EVALUACION;
/


/* ==================================================================
   3. CUERPO DEL PAQUETE: PC_EVALUACION
   ================================================================== */
CREATE OR REPLACE PACKAGE BODY PC_EVALUACION AS

    PROCEDURE AD_EVALUACION(
        xnPuntuacion IN NUMBER, xvEstado IN VARCHAR2, xxDetalle IN XMLTYPE,
        xvRetro IN VARCHAR2, xvOrigen IN VARCHAR2, xnEncuesta IN NUMBER,
        xnParticipante IN NUMBER
    ) IS
    BEGIN
        INSERT INTO EVALUACIONES (id, puntuacion, estado, detalle_experiencia, retroalimentacion, origen, id_encuesta, id_participante)
        VALUES ((SELECT NVL(MAX(id), 0) + 1 FROM EVALUACIONES), 
                xnPuntuacion, xvEstado, xxDetalle, xvRetro, xvOrigen, xnEncuesta, xnParticipante);
        COMMIT;
    END AD_EVALUACION;

    PROCEDURE MOD_EVALUACION(
        xnId IN NUMBER, xvEstado IN VARCHAR2, xvRetro IN VARCHAR2, xxDetalle IN XMLTYPE
    ) IS
    BEGIN
        UPDATE EVALUACIONES 
        SET estado = xvEstado, retroalimentacion = xvRetro, detalle_experiencia = xxDetalle
        WHERE id = xnId;
        COMMIT;
    END MOD_EVALUACION;

    PROCEDURE ELI_EVALUACION(xnId IN NUMBER) IS
    BEGIN
        -- Bloqueado por Trigger TR_EVALUACION_BD
        DELETE FROM EVALUACIONES WHERE id = xnId;
        COMMIT;
    END ELI_EVALUACION;

    -- Implementación Consulta 1 (Historial por Participante)
    FUNCTION CO_HISTORIAL_PARTICIPANTE(xnParticipante IN NUMBER) RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT 
                nombre_participante,
                criterio_evaluado,
                COUNT(*) AS cantidad_evaluaciones,
                ROUND(AVG(puntuacion), 2) AS promedio_puntuacion,
                SUM(incentivo) AS total_incentivos
            FROM VI_EVALUACIONES_REPORTES
            WHERE id_participante = xnParticipante
            GROUP BY nombre_participante, criterio_evaluado;
        RETURN v_cursor;
    END CO_HISTORIAL_PARTICIPANTE;

    -- Implementación Consulta 2 (Reporte de Desempeño)
    FUNCTION CO_REPORTE_DESEMPENO RETURN SYS_REFCURSOR IS
        v_cursor SYS_REFCURSOR;
    BEGIN
        OPEN v_cursor FOR
            SELECT 
                criterio_evaluado,
                COUNT(CASE WHEN origen = 'Web' THEN 1 END) AS volumen_web,
                COUNT(CASE WHEN origen = 'Movil' THEN 1 END) AS volumen_movil,
                ROUND(AVG(puntuacion), 1) AS indice_calidad,
                SUM(incentivo) AS inversion_total
            FROM VI_EVALUACIONES_REPORTES
            GROUP BY criterio_evaluado
            ORDER BY indice_calidad DESC;
        RETURN v_cursor;
    END CO_REPORTE_DESEMPENO;

END PC_EVALUACION;
/

/* ============================================================
Limpeiza e insersacion ded atos para las pruebas
   ============================================================ */
DELETE FROM COMENTARIOS WHERE id_evaluacion IN (200, 201, 202, 203, 204);
DELETE FROM EVALUACIONES WHERE id IN (200, 201, 202, 203, 204);
DELETE FROM ENCUESTAS WHERE id IN (200, 201);
COMMIT;

-- Cambiamos 'experiencia corredor' por 'calidad percibida'
INSERT INTO ENCUESTAS (id, criterio, presupuesto, valorIncentivo, fechaInicio, fechaFin, nombre_version)
VALUES (200, 'calidad percibida', 500000, 5000, SYSDATE - 5, SYSDATE + 30, 'VE24');

-- Cambiamos 'logistica evento' por 'atencion'
INSERT INTO ENCUESTAS (id, criterio, presupuesto, valorIncentivo, fechaInicio, fechaFin, nombre_version)
VALUES (201, 'atencion', 1000, 50000, SYSDATE - 1, SYSDATE + 10, 'VE24');



/* ============================================================
   OK 1: Crear una evaluacion exitosa (AD_EVALUACION).
   Demuestra que el trigger BI pone la fecha automaticamente
   y el trigger AI descuenta el incentivo del presupuesto.
   ============================================================ */
BEGIN
    PC_EVALUACION.AD_EVALUACION(
        5, 'publicada',
        XMLTYPE('<experiencia><clima>Soleado</clima><dispositivo>Movil</dispositivo></experiencia>'),
        'Excelente organizacion de la etapa',
        'Movil', 200, 12
    );
    DBMS_OUTPUT.PUT_LINE('OK 1: Evaluacion creada exitosamente.');
END;
/

/* ============================================================
   OK 2: Modificar campos permitidos (MOD_EVALUACION).
   Demuestra que el trigger BU permite cambiar solo el estado
   y la retroalimentacion, sin tocar la puntuacion.
   ============================================================ */
DECLARE
    v_id NUMBER;
BEGIN
    SELECT MAX(id) INTO v_id FROM EVALUACIONES WHERE id_encuesta = 200;
    PC_EVALUACION.MOD_EVALUACION(
        v_id,
        'en moderacion',
        'Hubo retrasos en el avituallamiento',
        XMLTYPE('<experiencia><clima>Soleado</clima><nota>Modificada</nota></experiencia>')
    );
    DBMS_OUTPUT.PUT_LINE('OK 2: Evaluacion modificada exitosamente.');
END;
/

/* ============================================================
   OK 3: Consultar historial de evaluaciones de un participante.
   Demuestra CO_HISTORIAL_PARTICIPANTE con datos reales.
   Columnas: nombre_participante, criterio, cantidad, promedio, incentivos
   ============================================================ */
DECLARE
    v_cur SYS_REFCURSOR;
    v_nombre VARCHAR2(60);
    v_criterio VARCHAR2(60);
    v_cantidad NUMBER;
    v_promedio NUMBER;
    v_incentivos NUMBER;
BEGIN
    v_cur := PC_EVALUACION.CO_HISTORIAL_PARTICIPANTE(12);
    DBMS_OUTPUT.PUT_LINE('--- HISTORIAL PARTICIPANTE 12 ---');
    LOOP
        FETCH v_cur INTO v_nombre, v_criterio, v_cantidad, v_promedio, v_incentivos;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_nombre || ' | ' || v_criterio || ' | Evaluaciones:' || v_cantidad || ' | Promedio:' || v_promedio || ' | Incentivos:' || v_incentivos);
    END LOOP;
    CLOSE v_cur;
END;
/

/* ============================================================
   OK 4: Consultar reporte de desempeno por criterio y plataforma.
   Demuestra CO_REPORTE_DESEMPENO con las 5 columnas exactas.
   ============================================================ */
DECLARE
    v_cur SYS_REFCURSOR;
    v_criterio VARCHAR2(60);
    v_web NUMBER;
    v_movil NUMBER;
    v_calidad NUMBER;
    v_inversion NUMBER;
BEGIN
    v_cur := PC_EVALUACION.CO_REPORTE_DESEMPENO();
    DBMS_OUTPUT.PUT_LINE('--- REPORTE DESEMPENO ---');
    LOOP
        FETCH v_cur INTO v_criterio, v_web, v_movil, v_calidad, v_inversion;
        EXIT WHEN v_cur%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(v_criterio || ' | Web:' || v_web || ' | Movil:' || v_movil || ' | Calidad:' || v_calidad || ' | Inversion:' || v_inversion);
    END LOOP;
    CLOSE v_cur;
END;
/

/* ============================================================
   OK 5: Intentar eliminar (ELI_EVALUACION) - Toca el Trigger.
   Demuestra que el sistema intenta el borrado pero el trigger
   TR_EVALUACION_BD lo atrapa y lanza el error de seguridad.
   Este error ES el resultado esperado (el sistema funciona).
   ============================================================ */
DECLARE
    v_id NUMBER;
BEGIN
    SELECT MAX(id) INTO v_id FROM EVALUACIONES WHERE id_encuesta = 200;
    PC_EVALUACION.ELI_EVALUACION(v_id);
    DBMS_OUTPUT.PUT_LINE('OK 5: Eliminacion procesada.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('OK 5 (Esperado): ' || SQLERRM);
END;
/


/* ============================================================
   NoOK 1: Intentar modificar la puntuacion (campo inmutable).
   El trigger TR_EVALUACION_BU debe bloquear la accion.
   ============================================================ */
DECLARE
    v_id NUMBER;
BEGIN
    SELECT MAX(id) INTO v_id FROM EVALUACIONES WHERE id_encuesta = 200;
    UPDATE EVALUACIONES SET puntuacion = 1 WHERE id = v_id;
    DBMS_OUTPUT.PUT_LINE('ERROR: Esto no debia ejecutarse.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('NoOK 1 (Correcto): ' || SQLERRM);
END;
/

/* ============================================================
   NoOK 2: Insertar en encuesta sin presupuesto suficiente.
   El trigger TR_EVALUACION_AI debe detectar que el presupuesto
   (1000) es menor al incentivo (50000) y lanzar el error.
   ============================================================ */
BEGIN
    PC_EVALUACION.AD_EVALUACION(
        4, 'publicada',
        XMLTYPE('<experiencia><nota>Sin fondos</nota></experiencia>'),
        'Prueba sin presupuesto',
        'Web', 201, 12
    );
    DBMS_OUTPUT.PUT_LINE('ERROR: Esto no debia ejecutarse.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('NoOK 2 (Correcto): ' || SQLERRM);
END;
/

/* ============================================================
   NoOK 3: Puntuacion fuera del rango valido (1-5).
   El constraint CK_EVALUACIONES_PUNTUACION debe rechazarlo.
   ============================================================ */
BEGIN
    PC_EVALUACION.AD_EVALUACION(
        10, 'publicada',
        XMLTYPE('<experiencia><nota>Fuera de rango</nota></experiencia>'),
        'Puntuacion invalida',
        'Web', 200, 12
    );
    DBMS_OUTPUT.PUT_LINE('ERROR: Esto no debia ejecutarse.');
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('NoOK 3 (Correcto): ' || SQLERRM);
END;
/

-- FIN BONO
-- ============================================================
-- PARTE III: MODELO FISICO DE ACTORES - CU1: Registrar Resultado
-- ActoresE (Especificacion de Paquetes de Actor)
-- ============================================================
CREATE OR REPLACE PACKAGE PA_PARTICIPANTE AS
    FUNCTION CO_TOP5_TIEMPOS RETURN SYS_REFCURSOR;
END PA_PARTICIPANTE;
/

CREATE OR REPLACE PACKAGE PA_PERSONA AS
    PROCEDURE AD_REGISTRO(
        xTIEMPO IN NUMBER, xPOSICION IN NUMBER, xDIFICULTAD IN VARCHAR2,
        xCOMENTARIO IN VARCHAR2, xNOMBRE_VERSION IN VARCHAR2,
        xID_CICLISTA IN NUMBER, xNOMBRE_SEGMENTO IN VARCHAR2
    );
    PROCEDURE MOD_REGISTRO(
        xID_CICLISTA IN NUMBER, xNOMBRE_SEGMENTO IN VARCHAR2,
        xNOMBRE_VERSION IN VARCHAR2, xCOMENTARIO IN VARCHAR2, xREVISION IN VARCHAR2
    );
    PROCEDURE ELI_REGISTRO(
        xID_CICLISTA IN NUMBER, xNOMBRE_SEGMENTO IN VARCHAR2, xNOMBRE_VERSION IN VARCHAR2
    );
    PROCEDURE AD_FOTO(xURL IN VARCHAR2, xID_REGISTRO IN NUMBER);
    FUNCTION CO_REGISTRO(
        xID_CICLISTA IN NUMBER, xNOMBRE_SEGMENTO IN VARCHAR2, xNOMBRE_VERSION IN VARCHAR2
    ) RETURN SYS_REFCURSOR;
    FUNCTION CO_TOP5_TIEMPOS RETURN SYS_REFCURSOR;
END PA_PERSONA;
/

-- ============================================================
-- PARTE III: ActoresI (Implementacion de Paquetes de Actor)
-- ============================================================

CREATE OR REPLACE PACKAGE BODY PA_PARTICIPANTE AS
    FUNCTION CO_TOP5_TIEMPOS RETURN SYS_REFCURSOR IS
    BEGIN
        RETURN PC_REGISTRO.CO_TOP5_TIEMPOS();
    END CO_TOP5_TIEMPOS;
END PA_PARTICIPANTE;
/

CREATE OR REPLACE PACKAGE BODY PA_PERSONA AS
    PROCEDURE AD_REGISTRO(
        xTIEMPO IN NUMBER, xPOSICION IN NUMBER, xDIFICULTAD IN VARCHAR2,
        xCOMENTARIO IN VARCHAR2, xNOMBRE_VERSION IN VARCHAR2,
        xID_CICLISTA IN NUMBER, xNOMBRE_SEGMENTO IN VARCHAR2
    ) IS
    BEGIN
        PC_REGISTRO.AD_REGISTRO(xTIEMPO, xPOSICION, xDIFICULTAD, xCOMENTARIO, xNOMBRE_VERSION, xID_CICLISTA, xNOMBRE_SEGMENTO);
    END AD_REGISTRO;

    PROCEDURE MOD_REGISTRO(
        xID_CICLISTA IN NUMBER, xNOMBRE_SEGMENTO IN VARCHAR2,
        xNOMBRE_VERSION IN VARCHAR2, xCOMENTARIO IN VARCHAR2, xREVISION IN VARCHAR2
    ) IS
    BEGIN
        PC_REGISTRO.MOD_REGISTRO(xID_CICLISTA, xNOMBRE_SEGMENTO, xNOMBRE_VERSION, xCOMENTARIO, xREVISION);
    END MOD_REGISTRO;

    PROCEDURE ELI_REGISTRO(
        xID_CICLISTA IN NUMBER, xNOMBRE_SEGMENTO IN VARCHAR2, xNOMBRE_VERSION IN VARCHAR2
    ) IS
    BEGIN
        PC_REGISTRO.ELI_REGISTRO(xID_CICLISTA, xNOMBRE_SEGMENTO, xNOMBRE_VERSION);
    END ELI_REGISTRO;

    PROCEDURE AD_FOTO(xURL IN VARCHAR2, xID_REGISTRO IN NUMBER) IS
    BEGIN
        PC_REGISTRO.AD_FOTO(xURL, xID_REGISTRO);
    END AD_FOTO;

    FUNCTION CO_REGISTRO(
        xID_CICLISTA IN NUMBER, xNOMBRE_SEGMENTO IN VARCHAR2, xNOMBRE_VERSION IN VARCHAR2
    ) RETURN SYS_REFCURSOR IS
    BEGIN
        RETURN PC_REGISTRO.CO_REGISTRO(xID_CICLISTA, xNOMBRE_SEGMENTO, xNOMBRE_VERSION);
    END CO_REGISTRO;

    FUNCTION CO_TOP5_TIEMPOS RETURN SYS_REFCURSOR IS
    BEGIN
        RETURN PC_REGISTRO.CO_TOP5_TIEMPOS();
    END CO_TOP5_TIEMPOS;
END PA_PERSONA;
/

-- ============================================================
-- PARTE III: SEGURIDAD - Roles y Usuarios
-- ============================================================

CREATE ROLE RL_PARTICIPANTE;
CREATE ROLE RL_PERSONA;

GRANT EXECUTE ON PA_PARTICIPANTE TO RL_PARTICIPANTE;
GRANT EXECUTE ON PA_PERSONA TO RL_PERSONA;


GRANT RL_PARTICIPANTE TO bd1000105506; -- David Malaver (equipo)
GRANT RL_PERSONA TO BD1000105520;  -- Persona del curso

DROP ROLE RL_PARTICIPANTE;
DROP ROLE RL_PERSONA;

-- ============================================================
-- PARTE III: SeguridadOK
-- ============================================================
-- limpieza e insersecion de datos para las pruebas
-- A. Borrar tablas hijas primero (Fotos y Registros)
DELETE FROM FOTOS WHERE id_registro IN (
    SELECT numero FROM REGISTROS WHERE id_ciclista IN (98, 99)
);
DELETE FROM REGISTROS WHERE id_ciclista IN (98, 99);

-- B. Borrar tablas asociativas
DELETE FROM VERSION_SEGMENTO WHERE nombre_version IN ('VSEG', 'VTST');
DELETE FROM PARTICIPANTE_VERSION WHERE nombre_version IN ('VSEG', 'VTST');
DELETE FROM CICLISTA_VERSION WHERE id_ciclista IN (98, 99);

-- C. Borrar componentes de la carrera
DELETE FROM VERSIONES WHERE nombre IN ('VSEG', 'VTST');
DELETE FROM SEGMENTOS WHERE nombre IN ('SEGSEG', 'SEGTST');
DELETE FROM PUNTOS WHERE nombre IN ('PSEG1', 'PSEG2', 'PTST1', 'PTST2');
DELETE FROM CARRERAS WHERE codigo IN ('CARSEG', 'CARTST');

-- D. Borrar la jerarquia de personas
DELETE FROM CICLISTAS WHERE id_persona IN (98, 99);
DELETE FROM PERSONAS WHERE id_participante IN (98, 99);
DELETE FROM PARTICIPANTES WHERE id IN (98, 99);
COMMIT;

INSERT INTO PARTICIPANTES VALUES (98, 'CC', 9898989898, 'COLOMBIA', 'seguridad@test.com');
INSERT INTO PERSONAS VALUES (98, 'Ciclista Seguridad');
INSERT INTO CICLISTAS VALUES (98, DATE '1996-01-01', 1);
INSERT INTO CARRERAS VALUES ('CARSEG', 'Carrera Segura', 'COLOMBIA', 1, 'A');
INSERT INTO PUNTOS VALUES ('PSEG1', 1, 'P', 0, 100, 'CARSEG');
INSERT INTO PUNTOS VALUES ('PSEG2', 2, 'L', 10, 100, 'CARSEG');
INSERT INTO SEGMENTOS VALUES ('SEGSEG', 'M', 'PSEG1', 'PSEG2');
INSERT INTO VERSIONES VALUES ('VSEG', DATE '2024-01-01', 'CARSEG');
INSERT INTO CICLISTA_VERSION VALUES (98, 'VSEG');
INSERT INTO VERSION_SEGMENTO VALUES ('VSEG', 'SEGSEG');
INSERT INTO PARTICIPANTE_VERSION VALUES (98, 'VSEG');
COMMIT;

-- OK 1: Registro de un resultado nuevo valido usando el paquete (PA_PERSONA)
BEGIN 
    PA_PERSONA.AD_REGISTRO(195, 2, 'M', 'Buen ritmo', 'VSEG', 98, 'SEGSEG'); 
END;
/
-- OK 2: Modificacion de un comentario valido
BEGIN 
    PA_PERSONA.MOD_REGISTRO(98, 'SEGSEG', 'VSEG', 'Ajuste del juez', 'Oficial'); 
END;
/
-- OK 3: Agregar una fotografia valida
-- Buscamos dinamicamente el numero del registro 
DECLARE
    v_num_reg NUMBER;
BEGIN 
    SELECT MAX(numero) INTO v_num_reg FROM REGISTROS WHERE id_ciclista = 98;
    PA_PERSONA.AD_FOTO('www.afterride.com/meta2.gif', v_num_reg); 
END;
/

-- OK 4: Consulta de un registro especifico usando el paquete del Juez
DECLARE
    v_cur SYS_REFCURSOR;
BEGIN
    v_cur := PA_PERSONA.CO_REGISTRO(98, 'SEGSEG', 'VSEG');
    DBMS_SQL.RETURN_RESULT(v_cur);
END;
/

/* OK 5: Consulta exitosa del reporte general de Top 5 tiempos usando el paquete del Participante. */
DECLARE
    v_cur SYS_REFCURSOR;
BEGIN
    v_cur := PA_PARTICIPANTE.CO_TOP5_TIEMPOS();
    DBMS_SQL.RETURN_RESULT(v_cur);
END;
/


-- ============================================================
-- PARTE III: SeguridadNoOK
-- ============================================================

-- NoOK 1: Intento de insertar un registro duplicado (Viola Restricción Única)
-- Como el ciclista 12 ya se registró en SEG_EC1 arriba, esto debe fallar.
BEGIN 
    PA_PERSONA.AD_REGISTRO(200, 5, 'A', 'Trampa', 'VE24', 12, 'SEG_EC1'); 
END;
/
-- NoOK 2: Intento de añadir foto a un registro que NO existe (Viola Llave Foránea)
BEGIN 
    PA_PERSONA.AD_FOTO('www.afterride.com/hack.gif', 9999); 
END;
/
-- NoOK 3: Modificar un registro asignando un estado de revisión inválido (Viola Check)
BEGIN 
    PA_PERSONA.MOD_REGISTRO(12, 'SEG_EC1', 'VE24', 'Mod', 'EstadoInventado'); 
END;
/

--  No OK 2: Falla por Llave Foranea Compuesta (FK_REG_CICLISTA_VERSION). El ciclista 17 NO participa en la version VE24. El motor lo bloquea. */
BEGIN 
    PA_PERSONA.AD_REGISTRO(190, 1, 'M', 'No inscrito', 'VE24', 17, 'VE24'); 
END;
/


-- ============================================================
-- PARTE III: XActores (Limpieza)
-- ============================================================

-- DROP PACKAGE PA_PARTICIPANTE;
-- DROP PACKAGE PA_PERSONA;
-- DROP USER US_PARTICIPANTE_TEST CASCADE;
-- DROP USER US_PERSONA_TEST CASCADE;
-- DROP ROLE RL_PARTICIPANTE;
-- DROP ROLE RL_PERSONA;

-- ============================================================
-- PARTE IV: PROBANDO (Pruebas de Aceptación)
-- Historia: "Jornada de Control y Auditoria de Tiempos"
-- ============================================================
/* ============================================================
   Preparamos el entorno, con el fin de evitar errores de duplicidad
   ============================================================ */
-- limpieza de datos
DELETE FROM FOTOS WHERE id_registro IN (SELECT numero FROM REGISTROS WHERE id_ciclista IN (11, 12, 91, 92));
DELETE FROM REGISTROS WHERE id_ciclista IN (11, 12, 91, 92);

DELETE FROM PARTICIPANTE_VERSION WHERE id_participante IN (91, 92);
DELETE FROM CICLISTA_VERSION WHERE id_ciclista IN (91, 92);
DELETE FROM CICLISTAS WHERE id_persona IN (91, 92);
DELETE FROM PERSONAS WHERE id_participante IN (91, 92);
DELETE FROM PARTICIPANTES WHERE id IN (91, 92);
COMMIT;

-- insercion de datos
INSERT INTO PARTICIPANTES VALUES (91, 'CC', 9191919191, 'COLOMBIA', 'p91@test.com');
INSERT INTO PERSONAS VALUES (91, 'Relleno Uno');
INSERT INTO CICLISTAS VALUES (91, DATE '1990-01-01', 1);

INSERT INTO PARTICIPANTES VALUES (92, 'CC', 9292929292, 'COLOMBIA', 'p92@test.com');
INSERT INTO PERSONAS VALUES (92, 'Relleno Dos');
INSERT INTO CICLISTAS VALUES (92, DATE '1990-01-01', 1);

INSERT INTO PARTICIPANTE_VERSION VALUES (91, 'VE24');
INSERT INTO CICLISTA_VERSION VALUES (91, 'VE24');
INSERT INTO PARTICIPANTE_VERSION VALUES (92, 'VE24');
INSERT INTO CICLISTA_VERSION VALUES (92, 'VE24');


INSERT INTO REGISTROS (numero, tiempo, posicion, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento, revision)
VALUES (999, 200, 5, 'M', 'Registro a borrar', 'VE24', 11, 'SEG_EC2', 'Pendiente');

-- El 91 y 92 son para que sobrevivan hasta el Top 5
INSERT INTO REGISTROS (tiempo, posicion, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento, revision)
VALUES (182, 6, 'M', 'Relleno Top 5', 'VE24', 91, 'SEG_EC1', 'Oficial');
INSERT INTO REGISTROS (tiempo, posicion, dificultad, comentario, nombre_version, id_ciclista, nombre_segmento, revision)
VALUES (183, 4, 'M', 'Relleno Top 5', 'VE24', 92, 'SEG_EC1', 'Oficial');
COMMIT;

-- prueba de aceptacion

-- Paso 1: El Juez oficial ingresa el tiempo de llegada de Juan Krause (Ciclista 12) 
-- en el segmento de montana (SEG_EC1). (Exito)
BEGIN
    PA_PERSONA.AD_REGISTRO(180, 2, 'M', 'Llegada en peloton', 'VE24', 12, 'SEG_EC1');
END;
/

-- Paso 2: El Juez consulta el sistema para verificar que el registro quedo creado 
-- y que se le asigno automaticamente el estado "Pendiente". (Confirmacion)
DECLARE
    v_cur SYS_REFCURSOR;
BEGIN
    v_cur := PA_PERSONA.CO_REGISTRO(12, 'SEG_EC1', 'VE24');
    DBMS_SQL.RETURN_RESULT(v_cur);
END;
/

-- Paso 3: El Juez adjunta la fotografia de la camara de meta de Juan Krause 
-- como soporte documental del tiempo registrado. (Exito)
BEGIN
    PA_PERSONA.AD_FOTO('www.afterride.com/llegada_juan.pdf', 4);
END;
/

-- Paso 4: El Juez intenta ingresar el tiempo de la corredora Elena Santos (17), 
-- pero el sistema rechaza la accion porque ella no esta inscrita en la version VE24. (Rechazo FK)
BEGIN
    PA_PERSONA.AD_REGISTRO(195, 5, 'A', 'Sin inscripcion', 'VE24', 17, 'SEG_EC1');
END;
/

-- Paso 5: Un asistente intenta registrar de nuevo el tiempo de Juan Krause (12) 
-- en el mismo segmento (SEG_EC1). El sistema bloquea la accion para evitar duplicidad. (Rechazo UQ)
BEGIN
    PA_PERSONA.AD_REGISTRO(185, 3, 'M', 'Duplicado', 'VE24', 12, 'SEG_EC1');
END;
/

-- Paso 6: El equipo de soporte intenta cargar un archivo de video no permitido (.mp4) 
-- como evidencia, siendo bloqueado por el formato del sistema. (Rechazo CK)
BEGIN
    PA_PERSONA.AD_FOTO('www.afterride.com/video.mp4', 4);
END;
/

-- Paso 7: Tras auditar la fotografia, el Juez oficializa el registro de Juan Krause 
-- cambiando su revision a "Oficial" y actualizando el comentario. (Exito)
BEGIN
    PA_PERSONA.MOD_REGISTRO(12, 'SEG_EC1', 'VE24', 'Tiempo validado', 'Oficial');
END;
/

-- Paso 8: El Juez identifica un registro de prueba antiguo de Sofia (11) en el segmento 
-- de llegada (SEG_EC2) y procede a eliminarlo. (Exito)
BEGIN
    PA_PERSONA.ELI_REGISTRO(11, 'SEG_EC2', 'VE24');
END;
/

-- Paso 9: El Juez consulta el registro recien eliminado para confirmar que la 
-- base de datos lo borro correctamente en cascada. (Confirmacion)
DECLARE
    v_cur SYS_REFCURSOR;
BEGIN
    v_cur := PA_PERSONA.CO_REGISTRO(11, 'SEG_EC2', 'VE24');
    DBMS_SQL.RETURN_RESULT(v_cur);
END;
/

-- Paso 10: Un espectador desde el publico general accede al sistema para consultar 
-- el Ranking Top 5 y verificar quienes lideran la etapa oficialmente. (Exito - Actor Externo)
DECLARE
    v_cur SYS_REFCURSOR;
BEGIN
    v_cur := PA_PARTICIPANTE.CO_TOP5_TIEMPOS();
    DBMS_SQL.RETURN_RESULT(v_cur);
END;
/







