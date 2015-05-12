drop table ALUMNO cascade constraints;
drop table ASIGNATURA cascade constraints;
drop table EJERCICIO cascade constraints;
drop table EMPLEADO cascade constraints;
drop table EMPRESA cascade constraints;
drop table ESTADISTICAS cascade constraints;
drop table IMPARTIR cascade constraints;
drop table MATRICULA cascade constraints;
drop table PROFESOR cascade constraints;
drop table RELACION cascade constraints;
drop table RELACION_EJERCICIOS cascade constraints;
drop table RELACION_MATRICULA cascade constraints;
drop table RESPUESTA cascade constraints;
drop table TRABAJAR cascade constraints;

drop view MAS_CONEXIONES_VIEW cascade constraints;
drop view MAS_FIABLES_VIEW cascade constraints;
drop view MAS_INTENTOS_FALLIDOS_VIEW cascade constraints;
drop view TIEMPO_EMPLEADO_VIEW cascade constraints;
drop view VER_GRAFICA_VIEW cascade constraints;

DROP PACKAGE PKG_CORRECCION_EJERCICIOS;
DROP PACKAGE PKG_GESTION_USUARIOS;
DROP PACKAGE PKG_GRAFICAS;
