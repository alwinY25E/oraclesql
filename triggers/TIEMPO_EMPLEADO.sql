create or replace trigger TIEMPO_EMPLEADO 
BEFORE LOGOFF ON DATABASE 
BEGIN
  UPDATE  ESTADISTICAS SET TIEMPO_EMPLEADO = TIEMPO_EMPLEADO+(select round((extract( day from diff ))*24 +
        (extract( hour from diff ))+
           (extract( minute from diff ))/60+
           (extract( second from diff ))/3600,2) as tiempo_invertido
      from (select current_timestamp - ultima_sesion diff
  from ESTADISTICAS),estadisticas) WHERE USUARIO = USER;
END;
