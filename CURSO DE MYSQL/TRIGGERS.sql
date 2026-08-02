--borrar tablas (si existen)
 drop table libros;
 drop table control;

 --crear tablas
 create table libros(
  codigo number(6),
  titulo varchar2(40),
  autor varchar2(30),
  editorial varchar2(20),
  precio number(6,2)
 );
 create table control(
  usuario varchar2(30),
  fecha date
 );


CREATE OR REPLACE TRIGGER TR_INGRESO_LIBROS
BEFORE INSERT 
ON LIBROS
BEGIN
    INSERT INTO CONTROL VALUES(user, SYSDATE);
END TR_INGRESO_LIBROS;

INSERT INTO libros VALUES (1242,'jose','jose','jose',235);

SELECT * FROM control;
--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------
--------------------------------------------

-- TRIGERS FOR EACH ROW
-- ESTE TRIGGER SE LANZA PARA CADA FILA DE LA TABLA, POR CADA REGISTRO DE LA TABLA
drop table empleados;

 create table empleados(
  documento char(8),
  apellido varchar2(30),
  nombre varchar2(30),
  seccion varchar2(20)
 );


 
SELECT * FROM control;
 
CREATE OR REPLACE TRIGGER TRG_INGRESA_EMPLEADOS
 BEFORE INSERT
ON empleados
 FOR EACH ROW
    BEGIN
        INSERT INTO control VALUES (USER, SYSDATE);
END TRG_INGRESA_EMPLEADOS;
/

--INSERTS
 insert into empleados values('22333444','ACOSTA','Ana','Secretaria');
 insert into empleados values('22777888','DOMINGUEZ','Daniel','Secretaria');
 insert into empleados values('22999000','FUENTES','Federico','Sistemas');
 insert into empleados values('22555666','CASEROS','Carlos','Contaduria');
 insert into empleados values('23444555','GOMEZ','Gabriela','Sistemas');
 insert into empleados values('23666777','JUAREZ','Juan','Contaduria');
 
 SELECT * FROM control;




-- BEFORE DELETE
create table alumnos(
legajo varchar2(4) not null,
documento varchar2(8) not null,
nombre varchar2(30) not null,
curso number(1) not null,
materia varchar2(15) not null,
nota_final number(3,2) not null);

insert into alumnos values('A234','23333333','LOPEZ ANA',5,'MATEMATICA',9);
insert into alumnos values('A345','24444444','GARCIA CARLOS',6,'MATEMATICA',8.5);
insert into alumnos values('A457','26666666','PEREZ FABIAN',6,'LENGUA',3.2);
insert into alumnos values('A348','25555555','PEREZ PATRICIA',6,'LENGUA',7.85);
insert into alumnos values('A123','22222222','PEREZ PATRICIA',5,'MATEMATICAS',9);
insert into alumnos values('A124','32222222','GONZALES JOSE',5,'BIOLOGIA',9);
insert into alumnos values('A124','32222222','GONZALES JOSE',5,'MATEMATICAS',8);

CREATE OR REPLACE TRIGGER TRG_BORRAR_REGISTRO
BEFORE DELETE
ON alumnos
FOR EACH ROW
    BEGIN 
        INSERT INTO control VALUES (user, SYSDATE);
END TRG_BORRAR_REGISTRO;

DELETE FROM alumnos
WHERE curso = 5;

SELECT * FROM control;

-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
-----------------------------------------------------
TRUNCATE TABLE control;
TRUNCATE TABLE empleados;
DROP TABLE control;
DROP TABLE empleados;

--creacion tabla empleados
create table empleados(
  documento char(8),
  apellido varchar2(20),
  nombre varchar2(20),
  seccion varchar2(30),
  sueldo number(8,2)
 );
--creacion tala control
 create table control(
  usuario varchar2(30),
  fecha date
 );

--ingreso de datos
 insert into empleados values('22333444','ACOSTA','Ana','Secretaria',500);
 insert into empleados values('22777888','DOMINGUEZ','Daniel','Secretaria',560);
 insert into empleados values('22999000','FUENTES','Federico','Sistemas',680);
 insert into empleados values('22555666','CASEROS','Carlos','Contaduria',900);
 insert into empleados values('23444555','GOMEZ','Gabriela','Sistemas',1200);
 insert into empleados values('23666777','JUAREZ','Juan','Contaduria',1000);


CREATE OR REPLACE TRIGGER TRG_ACTUALIZA
BEFORE UPDATE
ON empleados
    FOR EACH ROW
        BEGIN
            INSERT INTO control VALUES (USER, SYSDATE);
END TRG_ACTUALIZA;
/

SELECT * FROM empleados;
UPDATE empleados SET SUELDO = SUELDO * 0.1
WHERE seccion = 'Secretaria';

SELECT * FROM control;


-- TRIGGERS CONTROL DE MUTIPLES EVENTOS ES DECIR UN TRIGGER QUE PUEDA TANTO INSERT,BORRAR, ELIMINAR DATOS, ETC

CREATE TABLE control_empleados (
usuario VARCHAR2(20),
fecha DATE,
accion VARCHAR2(20));


CREATE OR REPLACE TRIGGER TRG_CONTROL_EMPLEADOS
BEFORE INSERT OR UPDATE OR DELETE
ON empleados
FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO control_empleados VALUES(USER, SYSDATE, 'ingreso');
    END IF;
    IF DELETING THEN
        INSERT INTO control_empleados VALUES(USER, SYSDATE, 'borrado');
    END IF;
    IF UPDATING THEN
        INSERT INTO control_empleados VALUES(USER, SYSDATE, 'actualizacion');
    END IF;
END TRG_CONTROL_EMPLEADOS;
/

INSERT INTO empleados VALUES(124124,'JOSE','JOSE','GERENCIA',12421);
SELECT * FROM control_empleados;

UPDATE empleados SET sueldo = 2000 WHERE documento = '2325235235';
DELETE from empleados WHERE documento = 252352;


----------------------------------------------
----------------------------------------------
----------------------------------------------
---------------------------------------------------------------------
-- TRIGGER :NEW , :OLD 

drop table libros;
drop table ofertas;

 create table libros(
  codigo number(6),
  titulo varchar2(40),
  autor varchar2(30),
  editorial varchar(20),
  precio number(6,2)
 );
 create table ofertas(
  codigo number(6),
  precio number(6,2),
  usuario varchar2(20),
  fecha date
 );
 insert into libros values(100,'Uno','Richard Bach','Planeta',25);
 insert into libros values(103,'El aleph','Borges','Emece',28);
 insert into libros values(105,'Matematica estas ahi','Paenza','Nuevo siglo',12);
 insert into libros values(120,'Aprenda PHP','Molina Mario','Nuevo siglo',55);
 insert into libros values(145,'Alicia en el pais de las maravillas','Carroll','Planeta',35);


CREATE OR REPLACE TRIGGER TRG_INGRESAR_CONTROL_OFERTAS
BEFORE INSERT ON libros
FOR EACH ROW
    BEGIN
        IF(:new.precio <= 30) THEN
        INSERT INTO ofertas VALUES(:new.codigo,:new.precio, USER, SYSDATE);
        END IF;
END TRG_INGRESAR_CONTROL_OFERTAS;


SELECT * FROM ofertas;
INSERT INTO libros VALUES(155, 'El Gato con botas', 'Gaskin', 'Planeta', 28);


CREATE OR REPLACE TRIGGER TRG_ACTUALIZAR_LIBROS
BEFORE UPDATE OF precio ON libros
FOR EACH ROW
    BEGIN
        IF(:old.precio <= 30) AND (:new.precio > 30) THEN
            DELETE FROM ofertas WHERE codigo = :old.codigo;
        END IF;
        IF(:old.precio > 30) AND (:new.precio <= 30) THEN
            INSERT INTO ofertas VALUES(:new.codigo, :new.precio, USER, SYSDATE);
        END IF;
    END TRG_ACTUALIZAR_LIBROS;
    
UPDATE libros SET precio = 25 WHERE codigo = 120;
SELECT * FROM ofertas;

UPDATE libros SET precio = 60 WHERE codigo = 120;

--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
--------------------------------------
-- WHEN / IF
DROP TABLE empleados;
DROP TABLE control;

 create table empleados(
  documento char(8),
  apellido varchar2(20),
  nombre varchar2(20),
  seccion varchar2(30),
  sueldo number(8,2)
 );
   drop table control;
 create table control(
  usuario varchar2(30),
  fecha date,
  documento char(8),
  antiguosueldo number(8,2),
  nuevosueldo number(8,2)
 ); 
  insert into empleados values('22333444','ACOSTA','Ana','Secretaria',500);
 insert into empleados values('22555666','CASEROS','Carlos','Contaduria',900);
 insert into empleados values('22777888','DOMINGUEZ','Daniel','Secretaria',560);
 insert into empleados values('22999000','FUENTES','Federico','Sistemas',680);
 insert into empleados values('23444555','GOMEZ','Gabriela','Sistemas',1200);
 insert into empleados values('23666777','JUAREZ','Juan','Contaduria',1000);
 
CREATE OR REPLACE TRIGGER TRG_SUELDO_NUEVO
BEFORE UPDATE OF sueldo ON empleados
FOR EACH ROW WHEN(new.sueldo > old.sueldo)
BEGIN
    INSERT INTO control VALUES(USER, SYSDATE, :old.documento, :old.sueldo, :new.sueldo);
END;

SELECT * FROM empleados;
SELECT * FROM control;
UPDATE empleados SET sueldo = 600 WHERE documento = 22333444;

-- ejemplo 2
CREATE OR REPLACE TRIGGER TRG_ACTUALIZA_DATOS
BEFORE INSERT 
ON empleados 
FOR EACH ROW
BEGIN
    :new.apellido := upper(:new.apellido);
    IF :new.sueldo IS NULL THEN 
    :new.sueldo := 0;
    END IF;
END;

SELECT * FROM empleados;
INSERT INTO empleados VALUES('25667777','LOPEZ','LUISA','SECRETARIA',NULL);


----------------------------------------------
----------------------------------------------
----------------------------------------------
-- como oracle desabilito y habilita un trigger que se halla creado

CREATE OR REPLACE TRIGGER TRG_SUELDO_NUEVO
BEFORE UPDATE OF sueldo ON empleados
FOR EACH ROW WHEN(new.sueldo > old.sueldo)
BEGIN
    INSERT INTO control VALUES(USER, SYSDATE, :old.documento, :old.sueldo, :new.sueldo);
END;

SELECT * FROM empleados;
SELECT * FROM control;
TRUNCATE TABLE control;

ALTER TRIGGER TRG_SUELDO_NUEVO DISABLE;
UPDATE empleados SET sueldo = 1000 WHERE documento = '22333444';
----------------------------------------------
----------------------------------------------
--------------------------------------------------------------------------------------------
----------------------------------------------
----------------------------------------------
----------------------------------------------
----------------------------------------------
----------------------------------------------

-- MOSTRART ERRORES CUANDO EL TRIGGER FALLE RAISE_APPLICATION_ERROR

drop table empleados;
drop table control;

 create table empleados(
  documento char(8),
  apellido varchar2(30),
  nombre varchar2(30),
  domicilio varchar2(30),
  seccion varchar2(20),
  sueldo number(8,2)
 );

 create table control(
  usuario varchar2(30),
  fecha date,
  operacion varchar2(30)
 );

 insert into empleados values('22222222','Acosta','Ana','Avellaneda 11','Secretaria',1800);
 insert into empleados values('23333333','Bustos','Betina','Bulnes 22','Gerencia',5000);
 insert into empleados values('24444444','Caseres','Carlos','Colon 333','Contaduria',3000);
 
 CREATE OR REPLACE TRIGGER TR_CONTROL_EMPLEADOS
 BEFORE INSERT OR UPDATE OR DELETE
 ON EMPLEADOS
 FOR EACH ROW
    BEGIN
        IF(:new.sueldo > 5000) THEN
            RAISE_APPLICATION_ERROR(-20000, 'SUELDO NO PUEDE SUPERAR LOS $5000');
        END IF;
        INSERT INTO control VALUES(USER,SYSDATE,'insercion');
        IF(:old.seccion = 'Gerencia') THEN 
            RAISE_APPLICATION_ERROR(-20000,'NO SE PUEDE ELIMINAR PUESTO DE GERENCIA');
        END IF;
        INSERT INTO control VALUES(USER,SYSDATE, 'BORRADO');
        IF UPDATING('documento') THEN
            RAISE_APPLICATION_ERROR(-20000, 'NO SE PUEDE ACTUALIZAR NUMERO DE DOCUMENTO');
        END IF;
END TR_CONTROL_EMPLEADOS;


SELECT * FROM empleados;

INSERT INTO empleados VALUES('2342352', 'Suarez', 'Jose', 'Calle 3ra No. 54', 'informatica',50090);
DELETE FROM empleados WHERE seccion = 'Gerencia';
UPDATE empleados SET documento = '321332' WHERE documento = '22222222';
