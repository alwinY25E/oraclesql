# oraclesql
Repositorio para control de versiones de PL/SQL de la asignatura de Administración de Bases Datos.


##### Para borrar todo el esquema

select 'drop table '||table_name||' cascade constraints;' from user_tables;
