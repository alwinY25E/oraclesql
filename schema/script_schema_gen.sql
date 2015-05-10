-- Generado por Oracle SQL Developer Data Modeler 3.3.0.747
--   en:        2015-04-15 09:42:08 CEST
--   sitio:      Oracle Database 11g
--   tipo:      Oracle Database 11g




CREATE TABLE ALUMNO
  (
    dni_alumno VARCHAR2 (9) NOT NULL ,
    expediente VARCHAR2 (20) NOT NULL ,
    nombre     VARCHAR2 (25) NOT NULL ,
    apellidos  VARCHAR2 (50) NOT NULL ,
    fecha_alta TIMESTAMP NOT NULL
  ) ;
ALTER TABLE ALUMNO ADD CONSTRAINT ALUMNO_PK PRIMARY KEY
(
  dni_alumno
)
;
ALTER TABLE ALUMNO ADD CONSTRAINT ALUMNO__UN UNIQUE
(
  expediente
)
;

CREATE TABLE ASIGNATURA
  (
    codigo         VARCHAR2 (10) NOT NULL ,
    nombre         VARCHAR2 (25) NOT NULL ,
    cuatrimestre   INTEGER NOT NULL ,
    num_ejercicios INTEGER ,
    puntos_minimos FLOAT ,
    puntos_maximos FLOAT
  ) ;
ALTER TABLE ASIGNATURA ADD CONSTRAINT ASIGNATURA_PK PRIMARY KEY
(
  codigo
)
;

CREATE TABLE EJERCICIO
  (
    id_ejercicio INTEGER NOT NULL ,
    enunciado VARCHAR2 (4000) NOT NULL ,
    solucion VARCHAR2 (4000) NOT NULL ,
    esquema          VARCHAR2 (25) NOT NULL ,
    tema             VARCHAR2 (20) NOT NULL ,
    grado_dificultad INTEGER NOT NULL ,
    puntos           INTEGER NOT NULL
  ) ;
ALTER TABLE EJERCICIO ADD CONSTRAINT EJERCICIO_PK PRIMARY KEY
(
  id_ejercicio
)
;

CREATE TABLE IMPARTIR
  (
    Profesor_dni_profesor VARCHAR2 (9) NOT NULL ,
    Asignatura_codigo     VARCHAR2 (10) NOT NULL
  ) ;
ALTER TABLE IMPARTIR ADD CONSTRAINT Relation_3__IDX PRIMARY KEY
(
  Profesor_dni_profesor, Asignatura_codigo
)
;

CREATE TABLE MATRICULA
  (
    curso_academico   VARCHAR2 (5) NOT NULL ,
    grupo             CHAR (1) DEFAULT 'A' NOT NULL ,
    usuario           VARCHAR2 (25) NOT NULL ,
    ALUMNO_dni_alumno VARCHAR2 (9) NOT NULL ,
    ASIGNATURA_codigo VARCHAR2 (10) NOT NULL
  ) ;
ALTER TABLE MATRICULA ADD CONSTRAINT MATRICULA_PK PRIMARY KEY
(
  ALUMNO_dni_alumno, ASIGNATURA_codigo, curso_academico
)
;

CREATE TABLE PROFESOR
  (
    dni_profesor VARCHAR2 (9) NOT NULL ,
    nombre       VARCHAR2 (25) NOT NULL ,
    apellidos    VARCHAR2 (50) NOT NULL ,
    usuario      VARCHAR2 (25) NOT NULL
  ) ;
ALTER TABLE PROFESOR ADD CONSTRAINT PROFESOR_PK PRIMARY KEY
(
  dni_profesor
)
;

CREATE TABLE RELACION
  (
    id_relacion                 INTEGER NOT NULL ,
    created_at                  TIMESTAMP NOT NULL ,
    fecha_entrega               TIMESTAMP NOT NULL ,
    MATRICULA_ALUMNO_dni_alumno VARCHAR2 (9) NOT NULL ,
    MATRICULA_ASIGNATURA_codigo VARCHAR2 (10) NOT NULL ,
    MATRICULA_curso_academico   VARCHAR2 (5) NOT NULL ,
    minimo_puntos FLOAT
  ) ;
ALTER TABLE RELACION ADD CONSTRAINT RELACION_PK PRIMARY KEY
(
  id_relacion
)
;

CREATE TABLE RELACION_MATRICULA
  (
    Matricula_dni_alumno      VARCHAR2 (9) NOT NULL ,
    Matricula_codigo          VARCHAR2 (10) NOT NULL ,
    Matricula_curso_academico VARCHAR2 (5) NOT NULL ,
    numero_de_relacion        INTEGER NOT NULL
  ) ;
ALTER TABLE RELACION_MATRICULA ADD CONSTRAINT Relation_5__IDX PRIMARY KEY
(
  Matricula_dni_alumno, Matricula_codigo, Matricula_curso_academico, numero_de_relacion
)
;

CREATE TABLE RELACION_EJERCICIOS
  (
    RELACION_id_relacion   INTEGER NOT NULL ,
    EJERCICIO_id_ejercicio INTEGER NOT NULL
  ) ;
ALTER TABLE RELACION_EJERCICIOS ADD CONSTRAINT RESPUESTAv2_PK PRIMARY KEY
(
  RELACION_id_relacion, EJERCICIO_id_ejercicio
)
;

CREATE TABLE RESPUESTA
  (
    respuesta VARCHAR2 (4000) NOT NULL ,
    nota FLOAT NOT NULL ,
    dni_alumno      VARCHAR2 (9) NOT NULL ,
    codigo          VARCHAR2 (10) NOT NULL ,
    curso_academico VARCHAR2 (5) NOT NULL ,
    submitted_at    TIMESTAMP NOT NULL ,
    id_ejercicio    INTEGER NOT NULL ,
    intentos        INTEGER DEFAULT 0 NOT NULL 
  ) ;
ALTER TABLE RESPUESTA ADD CONSTRAINT Respuesta_PK PRIMARY KEY
(
  dni_alumno, codigo, curso_academico, id_ejercicio
)
;

ALTER TABLE IMPARTIR ADD CONSTRAINT FK_ASS_3 FOREIGN KEY ( Profesor_dni_profesor ) REFERENCES PROFESOR ( dni_profesor ) ;

ALTER TABLE IMPARTIR ADD CONSTRAINT FK_ASS_4 FOREIGN KEY ( Asignatura_codigo ) REFERENCES ASIGNATURA ( codigo ) ;

ALTER TABLE RELACION_MATRICULA ADD CONSTRAINT FK_ASS_6 FOREIGN KEY ( Matricula_dni_alumno, Matricula_codigo, Matricula_curso_academico ) REFERENCES MATRICULA ( ALUMNO_dni_alumno, ASIGNATURA_codigo, curso_academico ) ;

ALTER TABLE MATRICULA ADD CONSTRAINT MATRICULA_ALUMNO_FK FOREIGN KEY ( ALUMNO_dni_alumno ) REFERENCES ALUMNO ( dni_alumno ) ;

ALTER TABLE MATRICULA ADD CONSTRAINT MATRICULA_ASIGNATURA_FK FOREIGN KEY ( ASIGNATURA_codigo ) REFERENCES ASIGNATURA ( codigo ) ;

ALTER TABLE RELACION ADD CONSTRAINT RELACION_MATRICULA_FK FOREIGN KEY ( MATRICULA_ALUMNO_dni_alumno, MATRICULA_ASIGNATURA_codigo, MATRICULA_curso_academico ) REFERENCES MATRICULA ( ALUMNO_dni_alumno, ASIGNATURA_codigo, curso_academico ) ;

ALTER TABLE RELACION_EJERCICIOS ADD CONSTRAINT RESPUESTAv2_EJERCICIO_FK FOREIGN KEY ( EJERCICIO_id_ejercicio ) REFERENCES EJERCICIO ( id_ejercicio ) ;

ALTER TABLE RELACION_EJERCICIOS ADD CONSTRAINT RESPUESTAv2_RELACION_FK FOREIGN KEY ( RELACION_id_relacion ) REFERENCES RELACION ( id_relacion ) ;

ALTER TABLE RESPUESTA ADD CONSTRAINT Respuesta_Ejercicio_FK FOREIGN KEY ( id_ejercicio ) REFERENCES EJERCICIO ( id_ejercicio ) ;

ALTER TABLE RESPUESTA ADD CONSTRAINT Respuesta_Matricula_FK FOREIGN KEY ( dni_alumno, codigo, curso_academico ) REFERENCES MATRICULA ( ALUMNO_dni_alumno, ASIGNATURA_codigo, curso_academico ) ;

CREATE TABLE ESTADISTICAS(
USUARIO VARCHAR2(25),
ULTIMA_SESION TIMESTAMP,
NUMERO_CONEXIONES NUMBER,
TIEMPO_EMPLEADO NUMBER
);

-- Añadido posibles vistas para los triggers

CREATE OR REPLACE VIEW TIEMPO_EMPLEADO_VIEW AS SELECT USUARIO,TIEMPO_EMPLEADO FROM ESTADISTICAS;

CREATE OR REPLACE VIEW MAS_CONEXIONES_VIEW AS SELECT USUARIO,NUMERO_CONEXIONES,ULTIMA_SESION FROM ESTADISTICAS ORDER BY NUMERO_CONEXIONES DESC;

-- Vistas de DATA ANALYSIS

-- Los que mas intentos fallan
CREATE OR REPLACE VIEW MAS_INTENTOS_FALLIDOS_VIEW AS
SELECT dni_alumno as name, SUM(intentos) as value FROM Respuesta 
WHERE nota > 0
GROUP BY dni_alumno
ORDER BY SUM(intentos) DESC;

-- Los más fiables
CREATE OR REPLACE VIEW MAS_FIABLES_VIEW AS
SELECT dni_alumno as name, SUM(intentos) as value FROM Respuesta
WHERE nota > 0
GROUP BY dni_alumno
ORDER BY SUM(intentos);

-- Vista para las graficas (dummy)

CREATE OR REPLACE VIEW VER_GRAFICA_VIEW AS SELECT * FROM DUAL;

-- Informe de Resumen de Oracle SQL Developer Data Modeler: 
-- 
-- CREATE TABLE                            10
-- CREATE INDEX                             0
-- ALTER TABLE                             23
-- CREATE VIEW                              0
-- CREATE PACKAGE                           0
-- CREATE PACKAGE BODY                      0
-- CREATE PROCEDURE                         0
-- CREATE FUNCTION                          0
-- CREATE TRIGGER                           0
-- ALTER TRIGGER                            0
-- CREATE COLLECTION TYPE                   0
-- CREATE STRUCTURED TYPE                   0
-- CREATE STRUCTURED TYPE BODY              0
-- CREATE CLUSTER                           0
-- CREATE CONTEXT                           0
-- CREATE DATABASE                          0
-- CREATE DIMENSION                         0
-- CREATE DIRECTORY                         0
-- CREATE DISK GROUP                        0
-- CREATE ROLE                              0
-- CREATE ROLLBACK SEGMENT                  0
-- CREATE SEQUENCE                          0
-- CREATE MATERIALIZED VIEW                 0
-- CREATE SYNONYM                           0
-- CREATE TABLESPACE                        0
-- CREATE USER                              0
-- 
-- DROP TABLESPACE                          0
-- DROP DATABASE                            0
-- 
-- ERRORS                                   0
-- WARNINGS                                 0
