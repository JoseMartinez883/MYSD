-- INDICES Y VISTAS

-- INDICES
/*
create TIPOdeINDICE index NOMBREINDICE
  on NOMBRETABLA(CAMPOS);
  */
  

 drop table empleados;
 create table empleados(
  legajo number(5),
  documento char(8),
  apellido varchar2(25),
  nombre varchar2(25),
  domicilio varchar2(30)
 );
 
 alter table empleados
  add constraint PK_empleados_legajo
  primary key (legajo);
  
  
select constraint_name, constraint_type, index_name
  from user_constraints
  where table_name='EMPLEADOS';
  
select index_name, index_type, uniqueness
  from user_indexes
  where table_name='EMPLEADOS'
  
select index_name, index_type, uniqueness
  from user_indexes
  where table_name='EMPLEADOS';
  
create unique index I_empleados_documento
  on empleados(documento); 

   select index_name, index_type, uniqueness
  from user_indexes where table_name='EMPLEADOS';
  
   alter table empleados
  add constraint UQ_empleados_documento
  unique(documento);


 select constraint_name, constraint_type, index_name
  from user_constraints
  where table_name='EMPLEADOS';
  
create index I_empleados_apellidonombre
 on empleados(apellido,nombre);

 select index_name, index_type, uniqueness
  from user_indexes
  where table_name='EMPLEADOS'; 
  
   select *from user_objects
  where object_type='INDEX'; 
  
   select index_name,column_name,column_position
  from user_ind_columns
  where table_name='EMPLEADOS';
  
insert into empleados values(1,'22333444','Lopez','Juan','Colon 123');
insert into empleados values(2,'23444555','Lopez','Luis','Lugones 1234');
insert into empleados values(3,'24555666','Garcia','Pedro','Avellaneda 987');
insert into empleados values(4,'25666777','Garcia','Ana','Caseros 678');
 
 create unique index I_empleados_nombre
 on empleados(nombre);
 
  insert into empleados values(5,'30111222','Perez','Juan','Bulnes 233');
  
  
  -- ELIMINAR INDICES
  
/*
Los índices se eliminan con "drop index"; la siguiente es la sintaxis básica:

 drop index NOMBREINDICE;
Eliminamos el índice "I_empleados_documento":

 drop index I_empleados_documento;
Los índices usados por las restricciones "primary key" y "unique" no pueden eliminarse con "drop index", se eliminan automáticamente cuando quitamos la restricción.

Si eliminamos una tabla, todos los índices asociados a ella se eliminan.
*/


  drop table empleados;

 create table empleados(
  legajo number (5),
  documento char(8),
  apellido varchar2(40),
  nombre varchar2(40)
 );
 
  create unique index I_empleados_legajo
  on empleados(legajo);
  
  alter table empleados
  add constraint UQ_empleados_legajo
  unique (legajo); 

 select constraint_name, constraint_type, index_name
  from user_constraints
  where table_name='EMPLEADOS';
  
  alter table empleados
  add constraint PK_empleados_documento
  primary key(documento);
  
 select constraint_name, constraint_type, index_name
  from user_constraints
  where table_name='EMPLEADOS';
  
   select index_name,uniqueness
  from user_indexes
  where table_name='EMPLEADOS';

   create index I_empleados_nombre
  on empleados(nombre);
  
   create index I_empleados_apellido
  on empleados(apellido);
  
   drop index I_empleados_legajo;
   
    select constraint_name, constraint_type, index_name
  from user_constraints
  where index_name='I_EMPLEADOS_LEGAJO';
  
   drop index I_empleados_nombre;
   
   select *from user_objects
  where object_type='INDEX'; 
  
   drop table empleados;
   
    select *from user_indexes where table_name='EMPLEADOS';
    
     select *from user_objects
  where object_type='INDEX';
  

-- INDICES PARTE 2

  create table alumnos(
  legajo char(5) not null,
  documento char(8) not null,
  nombre varchar2(30),
  curso char(1),
  materia varchar2(30),
  notafinal number(4,2)
 );

 insert into alumnos values ('A123','22222222','Perez Patricia','5','Matematica',9);
 insert into alumnos values ('A234','23333333','Lopez Ana','5','Matematica',9);
 insert into alumnos values ('A345','24444444','Garcia Carlos','6','Matematica',8.5);
 insert into alumnos values ('A348','25555555','Perez Patricia','6','Lengua',7.85);
 insert into alumnos values ('A457','26666666','Perez Fabian','6','Lengua',3.2);
 
 
 CREATE INDEX I_ALUMNOS_NOMBRE ON
    alumnos(nombre);

SELECT * FROM alumnos;

CREATE UNIQUE INDEX I_ALUMNOS_LEGAJO
    ON alumnos(legajo);
    
CREATE UNIQUE INDEX i_alumnos_materia
    ON alumnos(materia);

SELECT * FROM user_indexes WHERE table_name = 'ALUMNOS';
  ----------------------------------------------
  ----------------------------------------------
  ----------------------------------------------
  ----------------------------------------------
  
--  VISTAS
SELECT * FROM empleados

CREATE OR REPLACE VIEW v_promovidos AS
SELECT * FROM empleados
WHERE sueldo LIKE '5%'
OR seccion  = 'Secretaria' 
OR codigosucursal = 4;

select * from v_promovidos;

CREATE OR REPLACE VIEW aumentos AS
SELECT nombre, sueldo + (sueldo*0.10) AS Nuevos_sueldos
FROM empleados;


DROP VIEW Aumentos;

-- MATERIALIZED VIEWS/ VIEWS READ ONLY
drop table clientes;
create table clientes(
  nombre varchar2(40),
  documento char(8),
  domicilio varchar2(30),
  ciudad varchar2(30)
 );
 insert into clientes values('Juan Perez','22222222','Colon 1123','Santiago');
 insert into clientes values('Karina Lopez','23333333','San Martin 254','Monte Rey');
 insert into clientes values('Luis Garcia','24444444','Caseros 345','Río de janeiro');
 insert into clientes values('Marcos Gonzalez','25555555','Sucre 458','Santo Domingo');
 insert into clientes values('Nora Torres','26666666','Bulnes 567','Bogotá');
 insert into clientes values('Oscar Luque','27777777','San Martin 786','Asunción');
 insert into clientes values('Pedro Perez','28888888','Colon 234','Buenos Madrid');
 insert into clientes values('Rosa Rodriguez','29999999','Avellaneda 23','Lima');

CREATE OR REPLACE VIEW v_clientes
AS 
    SELECT nombre,ciudad
    FROM clientes
    WITH READ ONLY;
    -- LA VISTA YA ES SOLO PARA VISUALIZACION, NO PODEMOS HACER CAMBIOS EN ELLA 

SELECT * FROM v_clientes

INSERT INTO v_clientes VALUES ('Miguel Monegro', 'Colombia');
-- EL CAMBIO QUE SE HACE EN LA VISTA SE HACE TAMBIEN EN LA TABLA ORIGINAL
-- LA VISTA PUEDE SER UN INTERMEDIO PARA CAMBIAR LA VISTA

-- COMO HACEMOS QUE LA VISTA NO PERMITA QUE SE INSERTEN REGISTROS

UPDATE v_clientes SET ciudad = 'San Juan' WHERE nombre = 'Juan Perez';

-- VISTAS MATERIALIZADA, EL RESULTADO DE LA CONSULTA SE ALMACENA EN UNA TABLA REAL QUE SE ACTUALIZA
-- EN TIEMPO REAL, ES UNA COPIA PARA REALIZAR CAMBIOS SIN MODIFICAR LA ORIGINAL, NOS SIRVE PARA HACER PRUEBAS

CREATE MATERIALIZED VIEW clientes
AS SELECT * FROM clientes;



-- VISTAS PARTE 2

