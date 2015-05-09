# oraclesql
Repositorio para control de versiones de PL/SQL de la asignatura de Administración de Bases Datos.


##### Para borrar todo el esquema
```
select 'drop table '||table_name||' cascade constraints;' from user_tables;
```

##### ORA-01843 not a valid month

Cuando nos de este fallo, es debido a que la fecha de la tabla esta en diferente formato a la que el cliente está introduciendo. Para saber que tipo de formato esta usando el cliente debemos mirarlo con este comando:

```
select * from nls_session_parameters;
```
Esto nos dira el formato de fecha que tiene nuestra sesión. Ahora para cambiarla a formato europeo "DD-MM-YY" tenemos que hacer:

```
alter session set nls_date_format ='DD-MM-RR';
```
