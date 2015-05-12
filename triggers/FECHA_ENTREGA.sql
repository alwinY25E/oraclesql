create or replace TRIGGER FECHA_ENTREGA
-- Antes del insert para todas las filas
BEFORE INSERT ON RESPUESTA FOR EACH ROW
DECLARE
  -- Variable para guardar la fecha de entrega
  VAR_ENTREGA Relacion.fecha_entrega%TYPE;
BEGIN
  -- Seleccionamos la fecha de entrega que corresponde a cada ejercicio
  -- para el cual estamos insertando una repsuesta
  SELECT DISTINCT rel.fecha_entrega INTO VAR_ENTREGA FROM respuesta r 
  JOIN relacion_matricula rm ON 
    ( r.dni_alumno = rm.matricula_dni_alumno AND
      r.codigo = rm.matricula_codigo AND
      r.curso_academico = rm.matricula_curso_academico )
  JOIN relacion rel ON rm.numero_de_relacion = rel.id_relacion
  WHERE r.dni_alumno = :new.dni_alumno AND
  r.codigo = :new.codigo AND
  r.curso_academico = :new.curso_academico;
  
  -- Si la fecha es mayor que la entrega, rechazamos el insert y lanzamos error
  IF :new.submitted_at > VAR_ENTREGA THEN
    raise_application_error(-20101, 'La fecha de entrega ya ha pasado.');
  END IF;
  
END;
