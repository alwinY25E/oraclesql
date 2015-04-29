create or replace 
PACKAGE PKG_GESTION_USUARIOS AS 

-- PROCESOS INDIVIDUALES
PROCEDURE PR_CREAR_USUARIO(NOMBRE IN Matricula.usuario%TYPE);
PROCEDURE PR_BORRAR_USUARIO(NOMBRE IN Matricula.usuario%TYPE);
PROCEDURE PR_BLOQ_USUARIO(NOMBRE IN Matricula.usuario%TYPE);
PROCEDURE PR_KILL_SESSION(NOMBRE IN Matricula.usuario%TYPE);

-- PROCESOS POR ASIGNATURAS
PROCEDURE PR_CREAR_USUARIO_ASIG(ASIGNATURA_NAME IN Asignatura.nombre%TYPE, 
    CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY'));
PROCEDURE PR_BORRAR_USUARIO_ASIG(ASIGNATURA_NAME IN Asignatura.nombre%TYPE, 
    CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY'));
PROCEDURE PR_BLOQ_USUARIO_ASIG(ASIGNATURA_NAME IN Asignatura.nombre%TYPE, 
    CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY'));
PROCEDURE PR_KILL_SESSION_ASIG(ASIGNATURA_NAME IN Asignatura.nombre%TYPE,
      CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY'));

END PKG_GESTION_USUARIOS;
