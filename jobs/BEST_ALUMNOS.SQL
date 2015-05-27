CREATE TABLE N_MEJORES
(
  fecha DATE,
  dni_alumno VARCHAR2(9),
  nota_total FLOAT
);

CREATE OR REPLACE PROCEDURE PR_BEST_ALUMNO AS 
  -- Guarda la nota del que sera el mejor alumno del ranking
  VAR_NOTA_TOTAL Respuesta.nota%TYPE;
  -- Guarda el DNI (name) y nº de intentos (value) del mejor alumno
  VAR_BEST_ALUMNO Mas_fiables_view%ROWTYPE;
BEGIN
  -- Seleccionamos el mejor alumno de la vista Mas_fiables_view (dni,nºintentos)
  SELECT name,value INTO VAR_BEST_ALUMNO FROM Mas_fiables_view WHERE ROWNUM = 1;
  -- Guardamos la nota que tiene ese alumno
  SELECT SUM(nota) INTO VAR_NOTA_TOTAL FROM RESPUESTA WHERE dni_alumno = VAR_BEST_ALUMNO.NAME;
  -- Guardamos el resultado del mejor alumno (fecha,dni,nota total)
  INSERT INTO N_mejores VALUES (SYSDATE, VAR_BEST_ALUMNO.NAME, VAR_NOTA_TOTAL);
END PR_BEST_ALUMNO;
/

BEGIN
  DBMS_SCHEDULER.CREATE_JOB (
  job_name          => 'best_student',
  job_type          => 'STORED_PROCEDURE',
  job_action        => 'PR_BEST_ALUMNO',
  start_date        => sysdate,
  repeat_interval   => 'FREQ=DAILY;BYHOUR=02',
  end_date          => null,
  auto_drop         =>FALSE,
  enabled           => TRUE,
  comments          => 'Todos los dias a las 2 de la mañan llama al procedimiento PR_BEST_ALUMNO');
END;
/
