-- TRANSACCIONES

/*
unidad atomica de trabajo que consta de una o varias sentencias sql,
estas se puede deshacer o hacerse permanente en la base de datos
*/

drop table clientes;
create table clientes(
id_cliente int not null,
nombre varchar2(30),
edad numeric(2),
direccion varchar(60),
salario number(6,2));

--SOLO HACER ESTOS INSERTS PRIMERO
insert into clientes values (1,'Ramon Rodriguez',32,'Calle primera numero 001',2000.00); 
insert into clientes values (2,'Jose Tomas',25,'Calle segunda numero 002',1500.00); 
insert into clientes values (3,'Ana Jimenez',23,'Calle tercera numero 003',2000.00); 
insert into clientes values (4,'Emilio Contreras',25,'Calle cuarta numero 004',6500.00); 
insert into clientes values (6,'Pedro Sandoval',22,'Calle quinta numero 005',4500.00); 
commit;
-- esto no se ve como una transaccion permanente
-- pero con el commit confirmamos que lo realizado se volvio permanente ahora

--------------------------------------------------------------------------------------------
-- rollback cambios que se aplicaran de manera permanente en la tabla de datos

--INSERTS 2
insert into  clientes values (7,'Esther Sanchez',27,'Calle sexta numero 006',5500.00 ); 
insert into  clientes values (8,'Antonio Peralta',21,'Calle septima numero 007',4500.00 ); 


SELECT * FROM clientes;
rollback;
-- rollback, deshacer cambios devuelve a la tabla a su estado inicial, por lo tanto sin insetos de datos
-- commit, hacer los cambios permanentes


SELECT * FROM clientes;
insert into  clientes values (7,'Esther Sanchez',27,'Calle sexta numero 006',5500.00 ); 
insert into  clientes values (8,'Antonio Peralta',21,'Calle septima numero 007',4500.00 );

SAVEPOINT punto1;
-- es un punto de partido, en el cual la tabla se guardara en ese punto de partida que nosotros queremos
-- al hacer rollback, se volvera otra vez al punto savepoint puesto
-- del savepoint para abajo se elimina o se retrocede con el rollback

UPDATE clientes
SET salario = salario + 100;

SELECT * FROM clientes;
commit;
-- al hacer commit despues de un savepoint, este queda inhabilitado, por lo tanto al hacer rollback sucede un error
-- ya que como tal busca transacciones hacia atras pero no hay como tal

rollback to punto1;



-- TRANSACCIONES PARTE 2 (TRANSACCIONES CON UNDO)
CREATE TABLE transacciones (
    datos VARCHAR2(100)
    );

INSERT INTO transacciones VALUES('AAAAAAAAAAAAAAAAAAAA');
    
SELECT * FROM v$transaction;
COMMIT;

UPDATE transacciones SET datos = 'GWEGWEGWEGWEGW';

INSERT INTO transacciones VALUES('00000000000000000000');


-- TRANSACCIONES PARTE 3
-- LECTURAS SUCIAS, NO REPETIBLES Y FANTASMAS

-- LECTURAS SUCIAS
select * from ESTUDIANTE;


