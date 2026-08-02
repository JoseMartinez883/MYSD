-- ============================================================
-- afterRide - Construcción SQL
-- MYSD 2026-1 - Laboratorio 3/6
-- ============================================================

-- ============================================================
-- CICLO 1: Tablas
-- ============================================================

-- GC: PARTICIPANTES

CREATE TABLE PARTICIPANTES (
    id          NUMBER(10)      NOT NULL,
    idt         VARCHAR2(20)    NOT NULL,
    idn         VARCHAR2(20)    NOT NULL,
    pais        VARCHAR2(30)    NOT NULL,
    correo      VARCHAR2(50)
);

CREATE TABLE PERSONAS (
    id_participante NUMBER(10)  NOT NULL,
    nombres         VARCHAR2(60) NOT NULL
);

CREATE TABLE CICLISTAS (
    id_persona      NUMBER(10)  NOT NULL,
    nacimiento      DATE,
    categoria       VARCHAR2(20) NOT NULL
);

CREATE TABLE EMPRESAS (
    id_participante NUMBER(10)  NOT NULL,
    razonSocial     VARCHAR2(80) NOT NULL
);

-- GC: CARRERAS

CREATE TABLE CARRERAS (
    codigo          VARCHAR2(10)    NOT NULL,
    nombre          VARCHAR2(30)    NOT NULL,
    pais            VARCHAR2(30)    NOT NULL,
    categoria       VARCHAR2(20)    NOT NULL,
    periodicidad    VARCHAR2(20)    NOT NULL
);

CREATE TABLE PUNTOS (
    nombre          VARCHAR2(10)    NOT NULL,
    orden           NUMBER(2)       NOT NULL,
    tipo            VARCHAR2(20)    NOT NULL,
    distancia       NUMBER(8,2)     NOT NULL,
    tiempoLimite    NUMBER(10),
    codigo_carrera  VARCHAR2(10)    NOT NULL
);

CREATE TABLE SEGMENTOS (
    nombre              VARCHAR2(10)    NOT NULL,
    tipo                VARCHAR2(20)    NOT NULL,
    nombre_iniciaEn     VARCHAR2(10)    NOT NULL,
    nombre_finalizaEn   VARCHAR2(10)    NOT NULL
);

CREATE TABLE PROPIEDADDE (
    id_participante NUMBER(10)  NOT NULL,
    codigo_carrera  VARCHAR2(10) NOT NULL,
    porcentaje      NUMBER(5,2)
);

-- GC: VERSIONES

CREATE TABLE VERSIONES (
    nombre          VARCHAR2(5)     NOT NULL,
    fecha           DATE            NOT NULL,
    codigo_carrera  VARCHAR2(10)    NOT NULL
);

-- GC: REGISTROS

CREATE TABLE REGISTROS (
    numero          NUMBER(10)      NOT NULL,
    fecha           DATE            NOT NULL,
    tiempo          NUMBER(10)      NOT NULL,
    posicion        NUMBER(5)       NOT NULL,
    revision        VARCHAR2(20),
    dificultad      VARCHAR2(20),
    fotos           VARCHAR2(200),
    comentario      VARCHAR2(20),
    nombre_version  VARCHAR2(5)     NOT NULL,
    id_ciclista     NUMBER(10)      NOT NULL,
    nombre_segmento VARCHAR2(10)    NOT NULL
);

-- GC: EXPERIENCIA DE USUARIOS

CREATE TABLE ENCUESTAS (
    id NUMBER(10) NOT NULL,
    criterio VARCHAR2(40) NOT NULL,
    presupuesto NUMBER(12) NOT NULL,
    valorIncentivo  NUMBER(12)      NOT NULL,
    fechaInicio     DATE            NOT NULL,
    fechaFin        DATE            NOT NULL,
    nombre_version  VARCHAR2(5)     NOT NULL
);

CREATE TABLE EVALUACIONES (
    id                  NUMBER(10)      NOT NULL,
    fecha               DATE            NOT NULL,
    puntuacion          NUMBER(1)       NOT NULL,
    estado              VARCHAR2(20)    NOT NULL,
    detalle_experiencia XMLTYPE,
    retroalimentacion   VARCHAR2(200),
    origen              VARCHAR2(10)    NOT NULL,
    id_encuesta         NUMBER(10)      NOT NULL,
    id_participante     NUMBER(10)
);

CREATE TABLE COMENTARIOS (
    id              NUMBER(10)      NOT NULL,
    contenido       VARCHAR2(50)    NOT NULL,
    id_evaluacion   NUMBER(10)      NOT NULL
);

-- ============================================================
-- CICLO 1: XTablas
-- ============================================================

DROP TABLE COMENTARIOS;
DROP TABLE EVALUACIONES;
DROP TABLE ENCUESTAS;
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

-- ============================================================
-- CICLO 1: PoblarOK
-- ============================================================
 
-- GC: PARTICIPANTES
 
INSERT INTO PARTICIPANTES VALUES (1, 'CC', '12345678',  'Colombia', 'ana.gomez@mail.com');
INSERT INTO PARTICIPANTES VALUES (2, 'CC', '87654321',  'Colombia', 'luis.perez@mail.com');
INSERT INTO PARTICIPANTES VALUES (3, 'CE', '99988877',  'Ecuador',  NULL);
INSERT INTO PARTICIPANTES VALUES (4, 'NIT','900123456', 'Colombia', 'info@teamcol.com');
INSERT INTO PARTICIPANTES VALUES (5, 'CC', '11223344',  'Peru',     'carlos.rios@mail.com');
INSERT INTO PARTICIPANTES VALUES (6, 'CE', '55566677',  'Chile',    NULL);
 
INSERT INTO PERSONAS VALUES (1, 'Ana Gomez');
INSERT INTO PERSONAS VALUES (2, 'Luis Perez');
INSERT INTO PERSONAS VALUES (3, 'Maria Torres');
INSERT INTO PERSONAS VALUES (5, 'Carlos Rios');
INSERT INTO PERSONAS VALUES (6, 'Diego Mora');
 
INSERT INTO CICLISTAS VALUES (1, DATE '1990-03-15', 'Elite');
INSERT INTO CICLISTAS VALUES (2, DATE '1985-07-22', 'Master');
INSERT INTO CICLISTAS VALUES (5, DATE '1995-11-01', 'Elite');
 
INSERT INTO EMPRESAS VALUES (4, 'Team Colombia SAS');
 
-- GC: CARRERAS
 
INSERT INTO CARRERAS VALUES ('CAR001', 'Vuelta Colombia',  'Colombia', 'Elite',  'Anual');
INSERT INTO CARRERAS VALUES ('CAR002', 'Tour del Cafe',    'Colombia', 'Master', 'Anual');
INSERT INTO CARRERAS VALUES ('CAR003', 'Clasica RCN',      'Colombia', 'Elite',  'Anual');
 
INSERT INTO PUNTOS VALUES ('Salida1',  1, 'Salida',  0.00,    NULL,  'CAR001');
INSERT INTO PUNTOS VALUES ('Meta1',    8, 'Llegada', 180.50,  32400, 'CAR001');
INSERT INTO PUNTOS VALUES ('Alto1',    4, 'Paso',    95.30,   18000, 'CAR001');
INSERT INTO PUNTOS VALUES ('Salida2',  1, 'Salida',  0.00,    NULL,  'CAR002');
INSERT INTO PUNTOS VALUES ('Meta2',    6, 'Llegada', 120.00,  25200, 'CAR002');
INSERT INTO PUNTOS VALUES ('Alto2',    3, 'Paso',    60.00,   14400, 'CAR002');
 
INSERT INTO SEGMENTOS VALUES ('Seg001', 'Montana',  'Salida1', 'Alto1');
INSERT INTO SEGMENTOS VALUES ('Seg002', 'Descenso', 'Alto1',   'Meta1');
INSERT INTO SEGMENTOS VALUES ('Seg003', 'Plano',    'Salida2', 'Alto2');
 
INSERT INTO PROPIEDADDE VALUES (4, 'CAR001', 60.00);
INSERT INTO PROPIEDADDE VALUES (4, 'CAR002', 100.00);
INSERT INTO PROPIEDADDE VALUES (1, 'CAR003', NULL);
 
-- GC: VERSIONES
 
INSERT INTO VERSIONES VALUES ('V2024', DATE '2024-06-01', 'CAR001');
INSERT INTO VERSIONES VALUES ('V2023', DATE '2023-06-10', 'CAR001');
INSERT INTO VERSIONES VALUES ('V2024', DATE '2024-08-15', 'CAR002');
 
-- GC: REGISTROS
 
INSERT INTO REGISTROS VALUES (1, DATE '2024-06-08', 23400, 1,  NULL,      'Alta',  NULL, NULL, 'V2024', 1, 'Seg001');
INSERT INTO REGISTROS VALUES (2, DATE '2024-06-08', 24100, 2,  NULL,      'Media', NULL, NULL, 'V2024', 2, 'Seg001');
INSERT INTO REGISTROS VALUES (3, DATE '2024-06-08', 25300, 3,  'Oficial', 'Alta',  NULL, 'Gran etapa', 'V2024', 5, 'Seg002');
 
-- GC: EXPERIENCIA DE USUARIOS
 
INSERT INTO ENCUESTAS VALUES (1, 'calidad percibida', 500000, 10000, DATE '2024-06-01', DATE '2024-06-30', 'V2024');
INSERT INTO ENCUESTAS VALUES (2, 'infraestructura',   300000, 8000,  DATE '2024-08-01', DATE '2024-08-31', 'V2024');
INSERT INTO ENCUESTAS VALUES (3, 'atencion',          200000, 5000,  DATE '2023-06-01', DATE '2023-06-30', 'V2023');
 
INSERT INTO EVALUACIONES VALUES (1, DATE '2024-06-10', 5, 'publicada',      NULL, 'Excelente organizacion', 'Web',   1, 1);
INSERT INTO EVALUACIONES VALUES (2, DATE '2024-06-12', 2, 'en moderacion',  NULL, NULL,                     'Movil', 1, 2);
INSERT INTO EVALUACIONES VALUES (3, DATE '2024-06-15', 4, 'publicada',      NULL, 'Buena logistica',        'Web',   1, 5);
 
INSERT INTO COMENTARIOS VALUES (1, 'Totalmente de acuerdo',   1);
INSERT INTO COMENTARIOS VALUES (2, 'No estoy de acuerdo',     2);
INSERT INTO COMENTARIOS VALUES (3, 'Me parece correcto',      3);
 
-- ============================================================
-- CICLO 1: PoblarNoOK
-- ============================================================
 
-- Caso 1: Insertar un CICLISTA cuyo id_persona no existe en PERSONAS
-- Valida: integridad referencial CICLISTAS -> PERSONAS
-- En este punto AUN SE PERMITE porque no hay FK definida (punto C solo tiene NOT NULL)
-- Se documenta aqui como caso que NO deberia permitirse
 
-- INSERT INTO CICLISTAS VALUES (99, DATE '2000-01-01', 'Elite');
-- ^ id_persona=99 no existe en PERSONAS. Deberia fallar pero se permite.
 
-- Caso 2: Insertar un REGISTRO con nombre_version que no existe en VERSIONES
-- Valida: integridad referencial REGISTROS -> VERSIONES
 
-- INSERT INTO REGISTROS VALUES (99, DATE '2024-01-01', 10000, 1, NULL, NULL, NULL, NULL, 'VXXX', 1, 'Seg001');
-- ^ nombre_version='VXXX' no existe. Deberia fallar pero se permite.
 
-- Caso 3: Insertar una EVALUACION con id_encuesta inexistente
-- Valida: integridad referencial EVALUACIONES -> ENCUESTAS
 
-- INSERT INTO EVALUACIONES VALUES (99, DATE '2024-01-01', 3, 'publicada', NULL, NULL, 'Web', 999, 1);
-- ^ id_encuesta=999 no existe. Deberia fallar pero se permite.
 
-- -----------------------------------------------------------
-- Casos que YA NO se permiten por NOT NULL definido en punto C
-- -----------------------------------------------------------
 
-- Caso 4: Insertar PARTICIPANTE sin pais (NOT NULL)
-- Valida: nulidad de atributo obligatorio
 
-- INSERT INTO PARTICIPANTES VALUES (99, 'CC', '99999999', NULL, 'test@mail.com');
-- ^ pais es NOT NULL -> Oracle lanza ORA-01400. NO se permite. CORRECTO.
 
-- Caso 5: Insertar CARRERA sin nombre (NOT NULL)
-- Valida: nulidad de atributo obligatorio
 
-- INSERT INTO CARRERAS VALUES ('CAR999', NULL, 'Colombia', 'Elite', 'Anual');
-- ^ nombre es NOT NULL -> Oracle lanza ORA-01400. NO se permite. CORRECTO.
 
-- Caso 6: Insertar REGISTRO sin posicion (NOT NULL)
-- Valida: nulidad de atributo obligatorio
 
-- INSERT INTO REGISTROS VALUES (99, DATE '2024-01-01', 10000, NULL, NULL, NULL, NULL, NULL, 'V2024', 1, 'Seg001');
-- ^ posicion es NOT NULL -> Oracle lanza ORA-01400. NO se permite. CORRECTO.
 
-- ============================================================
-- CICLO 1: XPoblar
-- ============================================================
 
DELETE FROM COMENTARIOS;
DELETE FROM EVALUACIONES;
DELETE FROM ENCUESTAS;
DELETE FROM REGISTROS;
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
-- CICLO 1: Atributos
-- ============================================================
 
-- GC: PARTICIPANTES
 
ALTER TABLE PARTICIPANTES ADD CONSTRAINT CK_PARTICIPANTES_IDT
    CHECK (idt IN ('CC', 'CE', 'NIT', 'PA'));
 
ALTER TABLE PARTICIPANTES ADD CONSTRAINT CK_PARTICIPANTES_PAIS
    CHECK (LENGTH(pais) >= 2);
 
ALTER TABLE PARTICIPANTES ADD CONSTRAINT CK_PARTICIPANTES_CORREO
    CHECK (correo LIKE '%@%.%');
 
-- GC: CARRERAS
 
ALTER TABLE CARRERAS ADD CONSTRAINT CK_CARRERAS_CATEGORIA
    CHECK (categoria IN ('Elite', 'Master', 'Sub23', 'Junior'));
 
ALTER TABLE CARRERAS ADD CONSTRAINT CK_CARRERAS_PERIODICIDAD
    CHECK (periodicidad IN ('Anual', 'Bianual', 'Irregular'));
 
-- GC: PUNTOS
 
ALTER TABLE PUNTOS ADD CONSTRAINT CK_PUNTOS_TIPO
    CHECK (tipo IN ('Salida', 'Llegada', 'Paso'));
 
ALTER TABLE PUNTOS ADD CONSTRAINT CK_PUNTOS_DISTANCIA
    CHECK (distancia >= 0);
 
ALTER TABLE PUNTOS ADD CONSTRAINT CK_PUNTOS_TIEMPOLIMITE
    CHECK (tiempoLimite > 0);
 
-- GC: SEGMENTOS
 
ALTER TABLE SEGMENTOS ADD CONSTRAINT CK_SEGMENTOS_TIPO
    CHECK (tipo IN ('Montana', 'Descenso', 'Plano', 'Contrarreloj'));
 
-- GC: PROPIEDADDE
 
ALTER TABLE PROPIEDADDE ADD CONSTRAINT CK_PROPIEDADDE_PORCENTAJE
    CHECK (porcentaje BETWEEN 0 AND 100);
 
-- GC: REGISTROS
 
ALTER TABLE REGISTROS ADD CONSTRAINT CK_REGISTROS_POSICION
    CHECK (posicion > 0);
 
ALTER TABLE REGISTROS ADD CONSTRAINT CK_REGISTROS_TIEMPO
    CHECK (tiempo > 0);
 
ALTER TABLE REGISTROS ADD CONSTRAINT CK_REGISTROS_DIFICULTAD
    CHECK (dificultad IN ('Alta', 'Media', 'Baja'));
 
ALTER TABLE REGISTROS ADD CONSTRAINT CK_REGISTROS_REVISION
    CHECK (revision IN ('Oficial', 'Pendiente', 'Rechazada'));
 
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
 
ALTER TABLE REGISTROS ADD CONSTRAINT PK_REGISTROS
    PRIMARY KEY (numero);
 
ALTER TABLE ENCUESTAS ADD CONSTRAINT PK_ENCUESTAS
    PRIMARY KEY (id);
 
ALTER TABLE EVALUACIONES ADD CONSTRAINT PK_EVALUACIONES
    PRIMARY KEY (id);
 
ALTER TABLE COMENTARIOS ADD CONSTRAINT PK_COMENTARIOS
    PRIMARY KEY (id);
 
-- ============================================================
-- CICLO 1: Únicas
-- ============================================================
 
ALTER TABLE PARTICIPANTES ADD CONSTRAINT UK_PARTICIPANTES_IDN
    UNIQUE (idn);
 
ALTER TABLE PARTICIPANTES ADD CONSTRAINT UK_PARTICIPANTES_IDT
    UNIQUE (idt, idn);
 
ALTER TABLE PARTICIPANTES ADD CONSTRAINT UK_PARTICIPANTES_CORREO
    UNIQUE (correo);
 
ALTER TABLE CARRERAS ADD CONSTRAINT UK_CARRERAS_NOMBRE
    UNIQUE (nombre);
 
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
 
-- GC: REGISTROS
 
ALTER TABLE REGISTROS ADD CONSTRAINT FK_REGISTROS_VERSIONES
    FOREIGN KEY (nombre_version) REFERENCES VERSIONES (nombre);
 
ALTER TABLE REGISTROS ADD CONSTRAINT FK_REGISTROS_CICLISTAS
    FOREIGN KEY (id_ciclista) REFERENCES CICLISTAS (id_persona);
 
ALTER TABLE REGISTROS ADD CONSTRAINT FK_REGISTROS_SEGMENTOS
    FOREIGN KEY (nombre_segmento) REFERENCES SEGMENTOS (nombre);
 
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
-- CICLO 1: PoblarNoOK (con proteccion activa)
-- ============================================================
 
-- Caso 1: CICLISTA con id_persona inexistente -> ahora bloqueado por FK_CICLISTAS_PERSONAS
-- INSERT INTO CICLISTAS VALUES (99, DATE '2000-01-01', 'Elite');
-- ORA-02291: restriccion FK_CICLISTAS_PERSONAS violada - clave padre no encontrada.
 
-- Caso 2: REGISTRO con nombre_version inexistente -> ahora bloqueado por FK_REGISTROS_VERSIONES
-- INSERT INTO REGISTROS VALUES (99, DATE '2024-01-01', 10000, 1, NULL, NULL, NULL, NULL, 'VXXX', 1, 'Seg001');
-- ORA-02291: restriccion FK_REGISTROS_VERSIONES violada - clave padre no encontrada.
 
-- Caso 3: EVALUACION con id_encuesta inexistente -> ahora bloqueado por FK_EVALUACIONES_ENCUESTAS
-- INSERT INTO EVALUACIONES VALUES (99, DATE '2024-01-01', 3, 'publicada', NULL, NULL, 'Web', 999, 1);
-- ORA-02291: restriccion FK_EVALUACIONES_ENCUESTAS violada - clave padre no encontrada.
 
-- Casos adicionales de proteccion
 
-- Caso 4: EVALUACION con puntuacion fuera de rango -> bloqueado por CK_EVALUACIONES_PUNTUACION
-- INSERT INTO EVALUACIONES VALUES (99, DATE '2024-01-01', 9, 'publicada', NULL, NULL, 'Web', 1, 1);
-- ORA-02290: restriccion CK_EVALUACIONES_PUNTUACION violada.
 
-- Caso 5: ENCUESTA con fechaFin anterior a fechaInicio -> bloqueado por CK_ENCUESTAS_FECHAS
-- INSERT INTO ENCUESTAS VALUES (99, 'atencion', 100000, 5000, DATE '2024-12-31', DATE '2024-01-01', 'V2024');
-- ORA-02290: restriccion CK_ENCUESTAS_FECHAS violada.
 
-- Caso 6: PARTICIPANTE con correo duplicado -> bloqueado por UK_PARTICIPANTES_CORREO
-- INSERT INTO PARTICIPANTES VALUES (99, 'CC', '00000001', 'Colombia', 'ana.gomez@mail.com');
-- ORA-00001: restriccion unica UK_PARTICIPANTES_CORREO violada.