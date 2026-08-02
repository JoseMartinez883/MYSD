-- Habilitar la salida en pantalla
SET SERVEROUTPUT ON;

-- Bucle básico en PL/SQL
DECLARE
    valor NUMBER := 10; -- Variable inicial
BEGIN
    LOOP
        -- Mostrar el valor actual
        DBMS_OUTPUT.PUT_LINE(valor);

        -- Incrementar el valor
        valor := valor + 10;

        -- Salir del bucle si el valor es mayor que 50
        IF valor > 50 THEN
            EXIT; -- salir del bucle
        END IF;
    END LOOP;

    -- Mensaje final después de salir del bucle
    DBMS_OUTPUT.PUT_LINE('Valor final = ' || valor);
END;
/

-- bucle while
SET SERVEROUTPUT ON;

DECLARE 
    valor NUMBER(2) := 10;
BEGIN 
    WHILE valor < 20 LOOP
        DBMS_OUTPUT.PUT_LINE('El valor es : ' || valor);
        valor := valor + 1;
    END LOOP;
END;
/



SET SERVEROUTPUT ON;
DECLARE 
    valor NUMBER(2) := 10;
    valor2 NUMBER(2) := 1;
    answer NUMBER(3);
BEGIN
    WHILE valor2 <= 10 LOOP
        answer := valor * valor2;
        DBMS_OUTPUT.PUT_LINE(valor || ' X ' || valor2 || ' = ' || answer);
        valor2 := valor2 + 1;           
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('Se salio del while');
END;
/


-- BUCLES ANIDADOS
SET SERVEROUTPUT ON;

DECLARE
    VALOR NUMBER(2) := 10;
    VALOR2 NUMBER(2) := 1;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE('TABLA DE MULTPLICAR DEL ' || VALOR);
        LOOP
            DBMS_OUTPUT.PUT_LINE(VALOR || ' X ' || VALOR2 || ' = ' ||  VALOR*VALOR2);
            VALOR2 := VALOR2 + 1;
        EXIT WHEN VALOR2  > 10;
        END LOOP;
        VALOR := VALOR - 1;
        VALOR2 := 1;
    EXIT WHEN VALOR = 0;
    END LOOP;
END;
/


-- BUCLES FOR
-- se ejecuta una cantidad de veces ya definidas
SET SERVEROUTPUT ON;

DECLARE 
    NUMERO NUMBER(2);
BEGIN
    FOR NUMERO IN 10..20 LOOP 
        DBMS_OUTPUT.PUT_LINE('VALOR DE NUMERO ' || NUMERO);
    END LOOP;
END;


-- MODALIDAD DE BUCLE FOR IN REVERSE 

SET SERVEROUTPUT ON;

BEGIN
    FOR F IN REVERSE 0..5 LOOP
        DBMS_OUTPUT.PUT_LINE('VALOR DE F = ' || F);
    END LOOP;
END;
/



BEGIN 
    FOR F IN REVERSE 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('2 X ' || ' = ' || (F*3));
    END LOOP;
END;
/

-- CONDICIONES SQL

-- EJEMPLO CONDICIONAL IF-ELSE

DECLARE
    A NUMBER(2) := 10;
    B NUMBER(2) := 20;
BEGIN
    IF A > B THEN
        DBMS_OUTPUT.PUT_LINE(A || ' ES MAYOR QUE: ' || B);
    ELSE 
        DBMS_OUTPUT.PUT_LINE(B || ' ES MAYOR QUE: ' || A);
    END IF;
END;
/


DECLARE 
    NUMERO NUMBER(3) := 100;
BEGIN
    IF (NUMERO = 10) THEN
        DBMS_OUTPUT.PUT_LINE('VALOR DE NUMERO ES 10');
    ELSIF (NUMERO = 20) THEN
        DBMS_OUTPUT.PUT_LINE(' VALOR DE NUMER ES 20');
    ELSIF (NUMERO = 30) THEN
        DBMS_OUTPUT.PUT_LINE(' VALOR DE NUMERO ES 30');
    ELSE 
        DBMS_OUTPUT.PUT_LINE(' NINGUNO DE LOS VALORES FUE ENCONTRADO');
    END IF;
        DBMS_OUTPUT.PUT_LINE(' EL VALOR EXACTO DE LA VARIABLE ES: ' || NUMERO);
END;
/

-- CONDICIONAL CASE
CREATE OR REPLACE FUNCTION F_DIASEMANA(NUMERO INT)
RETURN VARCHAR2
IS 
    DIA VARCHAR2(25);
    BEGIN
        DIA := '';
        CASE NUMERO
            WHEN 1 THEN DIA := 'LUNES';
            WHEN 2 THEN DIA := 'MARTES';
            WHEN 3 THEN DIA := 'MIERCOLES';
            WHEN 4 THEN DIA := 'JUEVES';
            WHEN 5 THEN DIA := 'VIERNES';
            WHEN 6 THEN DIA := 'SABADO';
            WHEN 7 THEN DIA := 'DOMINGO';
            ELSE DIA := 'NO ES NUMERO CORRECTO';
        END CASE;
            RETURN DIA;
END;
/

-- EJECUTANDO LA FUNCION
SELECT F_DIASEMANA(1) AS "DIA DE LA SEMANA" FROM DUAL;

-- EJEMPLO 2 FUNCION

CREATE OR REPLACE FUNCTION F_TRIMESTRE(FECHA DATE)
RETURN VARCHAR2
IS 
    MES VARCHAR2(20);
    TRIMESTRE NUMBER;
BEGIN
    MES:= EXTRACT (MONTH FROM FECHA);
    TRIMESTRE := 0;
    CASE MES
        WHEN 1 THEN TRIMESTRE := 1;
        WHEN 2 THEN TRIMESTRE := 1;
        WHEN 3 THEN TRIMESTRE := 1;
        WHEN 4 THEN TRIMESTRE := 2;
        WHEN 5 THEN TRIMESTRE := 2;
        WHEN 6 THEN TRIMESTRE := 2;
        WHEN 7 THEN TRIMESTRE := 3;
        WHEN 8 THEN TRIMESTRE := 3;
        WHEN 9 THEN TRIMESTRE := 3;
        ELSE TRIMESTRE := 4;
    END CASE;
    RETURN TRIMESTRE;
END;
/
        
SELECT F_TRIMESTRE(TO_DATE('07/01/2021','DD/MM/YY')) FROM DUAL;
