create or replace TRIGGER FECHA_ENTREGA 
-- Antes y para cada uno de los insert que hagamos (row)
BEFORE INSERT ON RESPUESTA FOR EACH ROW
DECLARE
  -- Variable para guardar la fecha de entrega
  VAR_ENTREGA Relacion.fecha_entrega%TYPE;
BEGIN
  -- Seleccionamos la fecha de entrega que corresponde al ejercicio que
  -- tratamos de insertar (no es seguro que este bien, pero en general funciona)
  select distinct rel.fecha_entrega into VAR_ENTREGA from respuesta r 
  join relacion_matricula rm on 
    ( r.dni_alumno = rm.matricula_dni_alumno AND
      r.codigo = rm.matricula_codigo AND
      r.curso_academico = rm.matricula_curso_academico )
  join relacion rel on rm.numero_de_relacion = rel.id_relacion
  where r.dni_alumno = :new.dni_alumno AND
  r.codigo = :new.codigo AND
  r.curso_academico = :new.curso_academico;
  
  -- Comprobamos qe este bien o no la fecha de entrega
  IF :new.submitted_at <= VAR_ENTREGA THEN
    DBMS_OUTPUT.PUT_LINE('Bien entregado');
  ELSE
    DBMS_OUTPUT.PUT_LINE('Te pasaste');
  END IF;
  
END;
