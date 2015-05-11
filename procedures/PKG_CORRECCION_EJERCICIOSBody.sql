create or replace PACKAGE BODY PKG_CORRECCION_EJERCICIOS AS

  --Un procedimiento que corrige un solo ejercicio de un solo alumno
  --param: dni alumno, id ejercicio, respuesta del alumno
  PROCEDURE PR_CORREC_EJER_ALUMNO(DNI IN Respuesta.dni_alumno%TYPE, ID_EJER IN Ejercicio.id_ejercicio%TYPE, ANSWER IN Respuesta.respuesta%TYPE) AS
    
    -- Una variable para guardar la solucion ideal del ejercicio
    -- La solucion es un script de sentencias ejecutables
    VAR_EJERCICIO EJERCICIO.SOLUCION%TYPE;
    VAR_NOTA_EJER EJERCICIO.PUNTOS%TYPE;
    -- Otra variable para almacenar el numero de diferentes filas entre la solucion del alumno y la ideal
    VAR_CONT NUMBER;
    
    
  BEGIN
  
  
    VAR_NOTA_EJER := 0; -- Iniciamos la nota a 0 por si no consigue tener bien la respuesta.
    
    -- Guardamos la solcuion del ejercicio en VAR_EJERCICIO
    SELECT Ejercicio.solucion INTO VAR_EJERCICIO FROM Ejercicio WHERE Ejercicio.id_ejercicio = ID_EJER;
    
    
    -- Corregimos el ejercicio haciendo un minus de la consulta correcta y la del alumno. 
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM (('|| VAR_EJERCICIO || ' MINUS ' || ANSWER || ') UNION (' ||ANSWER|| ' MINUS ' || VAR_EJERCICIO || '))' INTO VAR_CONT;
    
    
    -- Siempre aumentamos en 1 el numero de intentos
    UPDATE Respuesta SET INTENTOS = INTENTOS+1 WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
    
    
    -- Al tener la respuesta correcta, se almacena la fecha de entrega
    IF VAR_CONT = 0 THEN
      SELECT EJERCICIO.PUNTOS INTO VAR_NOTA_EJER FROM EJERCICIO WHERE EJERCICIO.ID_EJERCICIO = ID_EJER;
      UPDATE Respuesta SET SUBMITTED_AT = SYSDATE WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
      UPDATE Respuesta SET NOTA = VAR_NOTA_EJER WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
      DBMS_OUTPUT.PUT_LINE('RESPUESTA CORRECTA');
    -- Si tiene la respuesta incorrecta tambien se almacena la fecha y la nota será cero.
    ELSE
      DBMS_OUTPUT.PUT_LINE('RESPUESTA INCORRECTA');
      UPDATE Respuesta SET SUBMITTED_AT = SYSDATE WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
      UPDATE Respuesta SET NOTA = VAR_NOTA_EJER WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
      -- Feedback
    -- Creo que hay que checker antes si submitted at es nulo para poder actualizar cnd entregue la respuesta correcta en el caso contrario
    END IF;
    
    
    EXCEPTION
      WHEN OTHERS THEN -- Si tiene algun error tambien se almacena la fecha, la nota y los intentos
        UPDATE Respuesta SET INTENTOS = INTENTOS+1 WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
        UPDATE Respuesta SET SUBMITTED_AT = SYSDATE WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
        UPDATE Respuesta SET NOTA = VAR_NOTA_EJER WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
        IF SQLCODE = -1789 THEN
          DBMS_OUTPUT.PUT_LINE('ERROR: Las columnas de la respuesta y la solucion del ejercicio no coinciden.');
        ELSIF SQLCODE = -942 THEN
          DBMS_OUTPUT.PUT_LINE('ERROR: La tabla o vista no existe.');
        ELSE
          DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        END IF;
        
        
  END PR_CORREC_EJER_ALUMNO;
  
  ------------------------------                                                 ------------------------------
  ------------------------------ Correccion de todos los ejercicios de un alumno ------------------------------
  ------------------------------                                                 ------------------------------
  
  -- Un procedimiento que corrige todos los ejercicios de un solo alumno
  PROCEDURE PR_CORREC_ALL_EJER_ALUMNO (DNI IN Respuesta.dni_alumno%TYPE) AS
    -- Creamos un cursor para todas las respuestas a ejercicios del alumno
    CURSOR C_RESPUESTAS IS SELECT id_ejercicio, respuesta FROM Respuesta WHERE dni_alumno=DNI;
  BEGIN
    FOR VAR_RESPUESTA IN C_RESPUESTAS LOOP
      PR_CORREC_EJER_ALUMNO(DNI,VAR_RESPUESTA.id_ejercicio,VAR_RESPUESTA.respuesta);
    END LOOP;
  END PR_CORREC_ALL_EJER_ALUMNO;
  
  
  ------------------------------                                                         ------------------------------
  ------------------------------ Correccion de todos los ejercicios de todos los alumnos ------------------------------
  ------------------------------                                                         ------------------------------
  
  
  
  -- Un procedimiento que todos los ejercicios de todos los alumnos de una asignatura 
  PROCEDURE PR_CORREC_ALL_ALUMNOS (ASIGNATURA_COD Asignatura.codigo%TYPE) AS
  -- Una variable para almacenar el curso actual
  CURSO Matricula.curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY');
  -- Excepcion cuando no existe una asignatura
  ERR_ASIG_INEX EXCEPTION;
  -- variable para almacenar el codigo la asignatura (para ver si existe) 
  var_asignatura Asignatura.codigo%TYPE;
  -- Definimos un cursor para todos los alumnos de la asignatura
  CURSOR C_ALUMNOS IS SELECT alumno_dni_alumno FROM Matricula WHERE asignatura_codigo=ASIGNATURA_COD AND curso_academico=CURSO; 
  BEGIN
    BEGIN
      SELECT codigo INTO var_asignatura FROM Asignatura;
    EXCEPTION   
      WHEN NO_DATA_FOUND THEN RAISE ERR_ASIG_INEX;
    END;
    FOR VAR_ALUMNO IN C_ALUMNOS LOOP
      PR_CORREC_ALL_EJER_ALUMNO(VAR_ALUMNO.alumno_dni_alumno);
    END LOOP;
    EXCEPTION 
      WHEN ERR_ASIG_INEX THEN DBMS_OUTPUT.PUT_LINE('Error: Asignatura Inexistente');
      WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error: '||SQLERRM);
  END PR_CORREC_ALL_ALUMNOS;
  
END PKG_CORRECCION_EJERCICIOS;
