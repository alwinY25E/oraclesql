create or replace PACKAGE BODY PKG_GESTION_USUARIOS AS

  -- El proceso crea un usuario con el nombre dado. 
  -- La password inicial sera el nombre de usuario.
  -- Param: NOMBRE
  PROCEDURE PR_CREAR_USUARIO (NOMBRE IN Matricula.usuario%TYPE) AS
  BEGIN
    -- Ejecutamos la instruccion de crear un usuario
    EXECUTE IMMEDIATE 'CREATE USER '|| NOMBRE ||' IDENTIFIED BY '|| NOMBRE;
  EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error '|| SQLERRM);
  END PR_CREAR_USUARIO;

  -- El proceso borra el usuario con el nombre dado. 
  -- Param: NOMBRE
  PROCEDURE PR_BORRAR_USUARIO(NOMBRE IN Matricula.usuario%TYPE) AS
  BEGIN
    -- Ejecutamos la instruccion de borrar un usuario
    EXECUTE IMMEDIATE 'DROP USER '|| NOMBRE ||' CASCADE';
  EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error '|| SQLERRM);
  END PR_BORRAR_USUARIO;

  -- El proceso bloquea el usuario con el nombre dado. 
  -- Param: NOMBRE
  PROCEDURE PR_BLOQ_USUARIO(NOMBRE IN Matricula.usuario%TYPE) AS
  BEGIN
    -- Ejecutamos la instruccion de bloquear un usuario
    EXECUTE IMMEDIATE 'ALTER USER '|| NOMBRE ||' ACCOUNT LOCK';
  EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error '|| SQLERRM);
  END PR_BLOQ_USUARIO;
  
  -- El proceso mata la sesion del usuario con el nombre dado. 
  -- Param: SID, SERIAL#
  PROCEDURE PR_KILL_SESSION(SID_N IN NUMBER, SERIAL IN NUMBER) AS
  -- Variable que va a guardar los parametros necesarios para la instruccion
  -- alter system kill session 'SID,SERIAL#' immediate
  -- VAR_KILL_PARAMS V$SESSION%ROWTYPE;
  BEGIN    
    -- Seleccionamos los parametros necesario para matar la session del usuario
    -- de la tabla v$session
    -- SELECT sid,serial# INTO VAR_KILL_PARAMS
    -- FROM V$SESSION WHERE username=UPPER(NOMBRE);
    
    -- Ejecutamos la instruccion que mata la sesion
    --DBMS_OUTPUT.PUT_LINE('ALTER SYSTEM KILL SESSION '''|| VAR_KILL_PARAMS.sid ||','|| VAR_KILL_PARAMS.serial# ||''' IMMEDIATE');
    EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION '''|| SID_N ||','|| SERIAL ||''' IMMEDIATE';
  EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error '|| SQLERRM);
  END PR_KILL_SESSION;
  
  -- El proceso crea todos los usuarios que pertenecen a la asignatura. 
  -- Si no se proporciona curso academico se toma por defecto el curso actual.
  -- Calculado con to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')
  -- Param: ASIGNATURA, CURSO ACADEMICO
  PROCEDURE PR_CREAR_USUARIO_ASIG(ASIGNATURA IN Asignatura.nombre%TYPE, 
      CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')) AS
    -- Cursor con todos los nombres de usuarios de alumnos que pertenecen
    -- a la asignatura con el nombre dado
    CURSOR C_USUARIOS_ASIG IS
    SELECT Matricula.usuario FROM Matricula 
    JOIN Asignatura ON Matricula.asignatura_codigo = Asignatura.codigo
    WHERE UPPER(Asignatura.nombre) = UPPER(ASIGNATURA)
    AND Matricula.curso_academico = CURSO;
  BEGIN
    -- Recorremos el cursor y vamos creando usuarios
    FOR VAR_USUARIO IN C_USUARIOS_ASIG 
    LOOP
      PR_CREAR_USUARIO(VAR_USUARIO.usuario);
    END LOOP;
  END PR_CREAR_USUARIO_ASIG;

  -- El proceso borra todos los usuarios que pertenecen a la asignatura. 
  -- Si no se proporciona curso academico se toma por defecto el curso actual.
  -- Calculado con to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')
  -- Param: ASIGNATURA, CURSO ACADEMICO
  PROCEDURE PR_BORRAR_USUARIO_ASIG(ASIGNATURA IN Asignatura.nombre%TYPE, 
      CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')) AS
    -- Cursor con todos los nombres de usuarios de alumnos que pertenecen
    -- a la asignatura con el nombre dado
    CURSOR C_USUARIOS_ASIG IS
    SELECT Matricula.usuario FROM Matricula 
    JOIN Asignatura ON Matricula.asignatura_codigo = Asignatura.codigo
    WHERE UPPER(Asignatura.nombre) = UPPER(ASIGNATURA)
    AND Matricula.curso_academico = CURSO;
  BEGIN
    -- Recorremos el cursor y vamos bloqueando usuarios
    FOR VAR_USUARIO IN C_USUARIOS_ASIG 
    LOOP
      PR_BORRAR_USUARIO(VAR_USUARIO.usuario);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error '|| SQLERRM);
  END PR_BORRAR_USUARIO_ASIG;

  -- El proceso bloquea a todos los usuarios que pertenecen a la asignatura.
  -- Si no se proporciona curso academico se toma por defecto el curso actual.
  -- Calculado con to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')
  -- Param: ASIGNATURA, CURSO ACADEMICO
  PROCEDURE PR_BLOQ_USUARIO_ASIG(ASIGNATURA IN Asignatura.nombre%TYPE, 
      CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')) AS
    -- Cursor con todos los nombres de usuarios de alumnos que pertenecen
    -- a la asignatura con el nombre dado
    CURSOR C_USUARIOS_ASIG IS
    SELECT Matricula.usuario FROM Matricula 
    JOIN Asignatura ON Matricula.asignatura_codigo = Asignatura.codigo
    WHERE UPPER(Asignatura.nombre) = UPPER(ASIGNATURA)
    AND Matricula.curso_academico = CURSO;
  BEGIN
    -- Recorremos el cursor y vamos bloqueando usuarios
    FOR VAR_USUARIO IN C_USUARIOS_ASIG 
    LOOP
      PR_BLOQ_USUARIO(VAR_USUARIO.usuario);
    END LOOP;
  EXCEPTION
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Ha ocurrido un error '|| SQLERRM);
  END PR_BLOQ_USUARIO_ASIG;
  
  PROCEDURE PR_KILL_SESSION_ASIG(ASIGNATURA IN Asignatura.nombre%TYPE) AS
  BEGIN
    NULL;
  END PR_KILL_SESSION_ASIG;

END PKG_GESTION_USUARIOS;