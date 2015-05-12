-- Author: Grupo Sexy Query Language
-- Script completo del trabajo en grupo para sistema de correción, gestión y estadísticas para alumnos.
-- Versión 1.0 
-- Date: 12-05-2015


-----------------------------                                -----------------------------
----------------------------- GENERACIÓN DE ESQUEMA DE DATOS -----------------------------
-----------------------------                                -----------------------------


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


-----------------------------                    -----------------------------
----------------------------- INSERCIÓN DE DATOS -----------------------------
-----------------------------                    -----------------------------

INSERT INTO ALUMNO VALUES ('54119932N', '123ABC', 'Nicolas', 'Vargas Ortega', '21/ABR/2015');
INSERT INTO ALUMNO VALUES ('54119931B', '456ABC', 'Rime', 'Munoz Perez', '19/ABR/2015');
INSERT INTO ALUMNO VALUES ('54119933C', '789ABC', 'Fran', 'Castellon Mena', '03/MAR/2015');
INSERT INTO ALUMNO VALUES ('54119934H', '123DEF', 'Adrian', 'Africa Pasanto', '05/ENE/2015');
INSERT INTO ALUMNO VALUES ('54119935K', '823GHI', 'Pepe', 'Gonzalez Ortega', '12/FEB/2015');
INSERT INTO ALUMNO VALUES ('54119936L', '623JKL', 'Juan', 'Leiva Redondo', '12/FEB/2015');
INSERT INTO ALUMNO VALUES ('54119937M', '223MNL', 'Antonio', 'Ronaldo Amancio', '13/MAR/2015');
INSERT INTO ALUMNO VALUES ('54119938P', '323HIJ', 'Morcilla', 'Tito Bambino', '21/MAR/2015');
INSERT INTO ALUMNO VALUES ('54119939Q', '124PRB', 'Fresca', 'Omar Don', '02/FEB/2015');
INSERT INTO ALUMNO VALUES ('54119940X', '125HGT', 'Arroz', 'Omega Flojo', '21/MAY/2015');

INSERT INTO ASIGNATURA VALUES ('123RFT', 'Matematicas', 1, 20, 100, 250);
INSERT INTO ASIGNATURA VALUES ('367GHS', 'Lengua', 2, 30, 150, 450);
INSERT INTO ASIGNATURA VALUES ('231SDC', 'AdministracionBD', 2, 150, 1000, 2500);
INSERT INTO ASIGNATURA VALUES ('546ZLA', 'Fisica', 1, 15, 75, 180);

INSERT INTO EJERCICIO VALUES (1, 'Esto es un enunciado', 'SELECT * FROM EMPLEADO', 'esquema1', 'Tema 1', 5, 7);
INSERT INTO EJERCICIO VALUES (2, 'Esto es un enunciado2', 'SELECT * FROM TRABAJAR', 'esquema2', 'Tema 2', 6, 4);
INSERT INTO EJERCICIO VALUES (3, 'Esto es un enunciado3', 'SELECT * FROM EMPRESA', 'esquema3', 'Tema 2', 6, 8);
INSERT INTO EJERCICIO VALUES (4, 'Esto es un enunciado4', 'SELECT NOMBRE FROM EMPLEADO', 'esquema4', 'Tema 2', 10, 10);
INSERT INTO EJERCICIO VALUES (5, 'Esto es un enunciado5', 'SELECT NOMBRE, APELLIDOS FROM EMPLEADO', 'esquema5', 'Tema 3', 3, 4);
INSERT INTO EJERCICIO VALUES (6, 'Esto es un enunciado6', 'SELECT EMPRESA_CIF_EMPRESA FROM TRABAJAR', 'esquema6', 'Tema 3', 3, 4);
INSERT INTO EJERCICIO VALUES (7, 'Esto es un enunciado7', 'SELECT EMPLEADO_NIF_EMPLEADO FROM TRABAJAR', 'esquema7', 'Tema 3', 10, 10);
INSERT INTO EJERCICIO VALUES (8, 'Esto es un enunciado8', 'SELECT APELLIDOS FROM EMPLEADO', 'esquema8', 'Tema 4', 6, 12);
INSERT INTO EJERCICIO VALUES (9, 'Esto es un enunciado9', 'SELECT SECTOR FROM EMPRESA', 'esquema9', 'Tema 4', 3, 7);
INSERT INTO EJERCICIO VALUES (10, 'Esto es un enunciado10', 'SELECT NOMBRE FROM EMPRESA', 'esquema10', 'Tema 5', 3, 2);
INSERT INTO EJERCICIO VALUES (11, 'Esto es un enunciado11', 'SELECT NIF_EMPLEADO FROM EMPLEADO', 'esquema11', 'Tema 5', 8, 5);
INSERT INTO EJERCICIO VALUES (12, 'Esto es un enunciado12', 'SELECT CIF_EMPRESA FROM EMPRESA', 'esquema12', 'Tema 5', 7, 10);

INSERT INTO PROFESOR VALUES('12345678H', 'Antonio', 'Alias Cano', 'aacano');
INSERT INTO PROFESOR VALUES('12345679X', 'Juan', 'Rodriguez Camacho', 'jrcamacho');
INSERT INTO PROFESOR VALUES('12345680F', 'Rodolfo', 'Marruecos Del Rio', 'rmdrio');
INSERT INTO PROFESOR VALUES('12345665T', 'Fuencisla', 'Ortega Blanco', 'foblanco');

INSERT INTO IMPARTIR VALUES ('12345678H', '123RFT');
INSERT INTO IMPARTIR VALUES ('12345679X', '367GHS');
INSERT INTO IMPARTIR VALUES ('12345680F', '231SDC');
INSERT INTO IMPARTIR VALUES ('12345665T', '546ZLA');



INSERT INTO MATRICULA VALUES ('15/16', 'A', 'soasada', '54119932N', '123RFT');
INSERT INTO MATRICULA VALUES ('15/16', 'A', 'penqui', '54119931B', '367GHS');
INSERT INTO MATRICULA VALUES ('15/16', 'A', 'soy', '54119933C', '231SDC');
INSERT INTO MATRICULA VALUES ('15/16', 'B', 'mari', '54119934H', '546ZLA');
INSERT INTO MATRICULA VALUES ('15/16', 'B', 'con', '54119935K', '367GHS');
INSERT INTO MATRICULA VALUES ('15/16', 'B', 'tengo', '54119936L', '231SDC');
INSERT INTO MATRICULA VALUES ('15/16', 'C', 'hambre', '54119937M', '546ZLA');
INSERT INTO MATRICULA VALUES ('15/16', 'C', 'platano', '54119938P', '367GHS');
INSERT INTO MATRICULA VALUES ('15/16', 'C', 'mandarina', '54119939Q', '546ZLA');
INSERT INTO MATRICULA VALUES ('15/16', 'C', 'hachis', '54119940X', '123RFT');

INSERT INTO RELACION VALUES (1, '19/JUN/2014', '05/JUL/2014', '54119932N', '123RFT', '15/16', 50);
INSERT INTO RELACION VALUES (2, '18/MAY/2014', '06/JUL/2014', '54119931B', '367GHS', '15/16', 70);
INSERT INTO RELACION VALUES (3, '17/JUN/2014', '05/JUL/2014', '54119933C', '231SDC', '15/16', 40);
INSERT INTO RELACION VALUES (4, '17/MAY/2014', '06/JUL/2014', '54119934H', '546ZLA', '15/16', 30);
INSERT INTO RELACION VALUES (5, '15/JUN/2014', '05/JUL/2014', '54119935K', '367GHS', '15/16', 40);
INSERT INTO RELACION VALUES (6, '15/MAY/2014', '06/JUL/2014', '54119936L', '231SDC', '15/16', 90);
INSERT INTO RELACION VALUES (7, '18/JUN/2014', '05/JUL/2014', '54119937M', '546ZLA', '15/16', 70);
INSERT INTO RELACION VALUES (8, '19/MAY/2014', '06/JUL/2014', '54119938P', '367GHS', '15/16', 40);
INSERT INTO RELACION VALUES (9, '12/JUN/2014', '05/JUL/2014', '54119939Q', '546ZLA', '15/16', 60);
INSERT INTO RELACION VALUES (10, '13/MAY/2014', '06/JUL/2014', '54119940X', '123RFT', '15/16', 20);

INSERT INTO RELACION_MATRICULA VALUES ('54119932N', '123RFT', '15/16', 1);
INSERT INTO RELACION_MATRICULA VALUES ('54119931B', '367GHS', '15/16', 2);
INSERT INTO RELACION_MATRICULA VALUES ('54119933C', '231SDC', '15/16', 3);
INSERT INTO RELACION_MATRICULA VALUES ('54119934H', '546ZLA', '15/16', 4);
INSERT INTO RELACION_MATRICULA VALUES ('54119935K', '367GHS', '15/16', 5);
INSERT INTO RELACION_MATRICULA VALUES ('54119936L', '231SDC', '15/16', 6);
INSERT INTO RELACION_MATRICULA VALUES ('54119937M', '546ZLA', '15/16', 7);
INSERT INTO RELACION_MATRICULA VALUES ('54119938P', '367GHS', '15/16', 8);
INSERT INTO RELACION_MATRICULA VALUES ('54119939Q', '546ZLA', '15/16', 9);
INSERT INTO RELACION_MATRICULA VALUES ('54119940X', '123RFT', '15/16', 10);

INSERT INTO RELACION_EJERCICIOS VALUES (1, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (1, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (1, 3);
INSERT INTO RELACION_EJERCICIOS VALUES (2, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (2, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (2, 3);
INSERT INTO RELACION_EJERCICIOS VALUES (3, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (3, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (3, 3);
INSERT INTO RELACION_EJERCICIOS VALUES (4, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (4, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (4, 3);
INSERT INTO RELACION_EJERCICIOS VALUES (5, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (5, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (5, 3);
INSERT INTO RELACION_EJERCICIOS VALUES (6, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (6, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (6, 3);
INSERT INTO RELACION_EJERCICIOS VALUES (7, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (7, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (7, 3);
INSERT INTO RELACION_EJERCICIOS VALUES (8, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (8, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (8, 3);
INSERT INTO RELACION_EJERCICIOS VALUES (9, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (9, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (9, 3);
INSERT INTO RELACION_EJERCICIOS VALUES (10, 1);
INSERT INTO RELACION_EJERCICIOS VALUES (10, 2);
INSERT INTO RELACION_EJERCICIOS VALUES (10, 3);

INSERT INTO RESPUESTA VALUES('SELECT * FROM EMPLEADO', 0, '54119932N', '123RFT', '15/16', sysdate, 1, 0);
INSERT INTO RESPUESTA VALUES('SELECT * FROM TRABAJAR', 0, '54119932N', '123RFT', '15/16', sysdate, 2, 0);
INSERT INTO RESPUESTA VALUES('SELECT NOMBRE FROM EMPRESA', 0, '54119932N', '123RFT', '15/16', sysdate, 3, 0);
INSERT INTO RESPUESTA VALUES('SELECT APELLIDOS FROM EMPLEADO', 0, '54119931B', '367GHS', '15/16', sysdate, 1, 0);
INSERT INTO RESPUESTA VALUES('SELECT EMPRESA_CIF_EMPRESA FROM TRABAJAR', 0, '54119931B', '367GHS', '15/16', sysdate, 2, 0);
INSERT INTO RESPUESTA VALUES('SELECT * FROM EMPRESA', 0, '54119931B', '367GHS', '15/16', sysdate, 3, 0);


-----------------------------                                                 -----------------------------
----------------------------- ESQUEMA DE PRUEBA PARA CORRECCIÓN DE EJERCICIOS -----------------------------
-----------------------------                                                 -----------------------------

-- Script para la generación de un pequeño esquema de Empleados que Trabajan en Empresas.

CREATE TABLE EMPRESA(
  cif_empresa VARCHAR2 (9) NOT NULL,
  nombre VARCHAR2 (20) NOT NULL,
  sector VARCHAR2 (20) NOT NULL
);
ALTER TABLE EMPRESA ADD CONSTRAINT EMPRESA_PK PRIMARY KEY
(
  cif_empresa
)
;

CREATE TABLE EMPLEADO(
  nif_empleado VARCHAR2 (9) NOT NULL,
  nombre VARCHAR2 (20) NOT NULL,
  apellidos VARCHAR2 (20) NOT NULL
);
ALTER TABLE EMPLEADO ADD CONSTRAINT EMPLEADO_PK PRIMARY KEY
(
  nif_empleado
)
;

CREATE TABLE TRABAJAR (
  empresa_cif_empresa VARCHAR2 (9) NOT NULL,
  empleado_nif_empleado VARCHAR2 (9) NOT NULL
);

ALTER TABLE TRABAJAR ADD CONSTRAINT TRABAJAR_PK PRIMARY KEY
(
  empresa_cif_empresa, empleado_nif_empleado
)
;
ALTER TABLE TRABAJAR ADD CONSTRAINT FK_TRABAJAR_1 FOREIGN KEY ( empresa_cif_empresa ) REFERENCES EMPRESA ( cif_empresa ) ;

ALTER TABLE TRABAJAR ADD CONSTRAINT FK_TRABAJAR_2 FOREIGN KEY ( empleado_nif_empleado ) REFERENCES EMPLEADO ( nif_empleado ) ;

-----------------------------                                  -----------------------------
----------------------------- INSERCIÓN PARA ESQUEMA DE PRUEBA -----------------------------
-----------------------------                                  -----------------------------

INSERT INTO EMPRESA VALUES ('78695949T','Apple','Informatica');
INSERT INTO EMPRESA VALUES ('12345678G','Patatas Pepe','Comestibles');
INSERT INTO EMPRESA VALUES ('43253567Y','Microsoft','Informatica');
INSERT INTO EMPRESA VALUES ('28494753X','Nestle','Comestibles');
INSERT INTO EMPRESA VALUES ('14535674D','Pascual','Comestibles');
INSERT INTO EMPRESA VALUES ('65543345B','Mercedes Benz','Automovil');
INSERT INTO EMPRESA VALUES ('23678356S','BMW','Automovil');
INSERT INTO EMPRESA VALUES ('98645673K','Coca Cola','Refrescos');
INSERT INTO EMPRESA VALUES ('23564767L','Gallina Blanca','Pastas');
INSERT INTO EMPRESA VALUES ('45367864C','Campofrio','Embutidos');

INSERT INTO EMPLEADO VALUES ('78695949P','Juan','Teatino Larios');
INSERT INTO EMPLEADO VALUES ('12345678O','Pepe','Fernandez Dominguez');
INSERT INTO EMPLEADO VALUES ('43253567I','Antonio','Benavides Sanchez');
INSERT INTO EMPLEADO VALUES ('28494753U','Daniel','Ortega Castellon');
INSERT INTO EMPLEADO VALUES ('14535674Y','Pascual','Sanchez Verde');
INSERT INTO EMPLEADO VALUES ('65543345T','Mercedes','Goya Gomez');
INSERT INTO EMPLEADO VALUES ('23678356R','Roberto','Fornieles Gongora');
INSERT INTO EMPLEADO VALUES ('98645673E','Pablo','Barranco Sanchez');
INSERT INTO EMPLEADO VALUES ('23564767W','Blanca','Zorrilla España');
INSERT INTO EMPLEADO VALUES ('45367864G','Cebollinpop','Marruecos Perez');

INSERT INTO TRABAJAR VALUES ('78695949T', '12345678O');
INSERT INTO TRABAJAR VALUES ('12345678G', '78695949P');
INSERT INTO TRABAJAR VALUES ('43253567Y', '98645673E');
INSERT INTO TRABAJAR VALUES ('28494753X', '65543345T');
INSERT INTO TRABAJAR VALUES ('14535674D', '23564767W');
INSERT INTO TRABAJAR VALUES ('65543345B', '28494753U');
INSERT INTO TRABAJAR VALUES ('23678356S', '14535674Y');
INSERT INTO TRABAJAR VALUES ('98645673K', '23678356R');
INSERT INTO TRABAJAR VALUES ('23564767L', '45367864G');
INSERT INTO TRABAJAR VALUES ('45367864C', '43253567I');

-- EJEMPLO PARA COMPROBAR QUE TODO FUNCIONA
-- Dame los nombres los de los empleados que trabajen en la empresa con cif 78695949T
SELECT empleado.NOMBRE, empresa.nombre AS empresa
FROM EMPLEADO 
JOIN TRABAJAR ON empleado.nif_empleado = trabajar.empleado_nif_empleado
JOIN empresa ON trabajar.empresa_cif_empresa = empresa.cif_empresa
WHERE trabajar.empresa_cif_empresa = '78695949T';


-----------------------------                            -----------------------------
----------------------------- PAQUETES DE PROCEDIMIENTOS -----------------------------
-----------------------------                            -----------------------------

-- 1. Corrección de ejercicios
create or replace PACKAGE PKG_CORRECCION_EJERCICIOS AS
  PROCEDURE PR_CORREC_EJER_ALUMNO(DNI IN Respuesta.dni_alumno%TYPE, ID_EJER IN Ejercicio.id_ejercicio%TYPE, ANSWER IN Respuesta.respuesta%TYPE);
  PROCEDURE PR_CORREC_ALL_EJER_ALUMNO (DNI IN Respuesta.dni_alumno%TYPE);
  PROCEDURE PR_CORREC_ALL_ALUMNOS (ASIGNATURA_COD Asignatura.codigo%TYPE);
END PKG_CORRECCION_EJERCICIOS;
/

-- 2. Gestión de usuarios
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
/

-- 3. Paquete para gráficas
CREATE OR REPLACE 
PACKAGE PKG_GRAFICAS AS 

  PROCEDURE PR_DIBUJAR_GRAFICA (VIEW_NAME IN VARCHAR2); 
  
END PKG_GRAFICAS;
/

-----------------------------                     -----------------------------
----------------------------- CUERPOS DE PAQUETES -----------------------------
-----------------------------                     -----------------------------

-- 1. Cuerpo de corrección ejercicios
create or replace PACKAGE BODY PKG_CORRECCION_EJERCICIOS AS

  --Un procedimiento que corrige un solo ejercicio de un solo alumno
  --param: dni alumno, id ejercicio, respuesta del alumno
  PROCEDURE PR_CORREC_EJER_ALUMNO(DNI IN Respuesta.dni_alumno%TYPE, ID_EJER IN Ejercicio.id_ejercicio%TYPE, ANSWER IN Respuesta.respuesta%TYPE) AS
    
    -- Una variable para guardar la solucion ideal del ejercicio
    -- La solucion es un script de sentencias ejecutables
    VAR_EJERCICIO EJERCICIO.SOLUCION%TYPE;
    VAR_NOTA_EJER EJERCICIO.PUNTOS%TYPE;
    -- Otra variable para almacenar el numero de diferentes filas entre la solucion del alumno y la ideal
    VAR_CONT NUMBER;
    
    
  BEGIN
  
  
    VAR_NOTA_EJER := 0; -- Iniciamos la nota a 0 por si no consigue tener bien la respuesta.
    
    -- Guardamos la solcuion del ejercicio en VAR_EJERCICIO
    SELECT Ejercicio.solucion INTO VAR_EJERCICIO FROM Ejercicio WHERE Ejercicio.id_ejercicio = ID_EJER;
    
    
    -- Corregimos el ejercicio haciendo un minus de la consulta correcta y la del alumno. 
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM (('|| VAR_EJERCICIO || ' MINUS ' || ANSWER || ') UNION (' ||ANSWER|| ' MINUS ' || VAR_EJERCICIO || '))' INTO VAR_CONT;
    
    
    -- Siempre aumentamos en 1 el numero de intentos
    UPDATE Respuesta SET INTENTOS = INTENTOS+1 WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
    
    
    -- Al tener la respuesta correcta, se almacena la fecha de entrega
    IF VAR_CONT = 0 THEN
      SELECT EJERCICIO.PUNTOS INTO VAR_NOTA_EJER FROM EJERCICIO WHERE EJERCICIO.ID_EJERCICIO = ID_EJER;
      UPDATE Respuesta SET SUBMITTED_AT = SYSDATE WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
      UPDATE Respuesta SET NOTA = VAR_NOTA_EJER WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
      DBMS_OUTPUT.PUT_LINE('RESPUESTA CORRECTA');
    -- Si tiene la respuesta incorrecta tambien se almacena la fecha y la nota será cero.
    ELSE
      DBMS_OUTPUT.PUT_LINE('RESPUESTA INCORRECTA');
      UPDATE Respuesta SET SUBMITTED_AT = SYSDATE WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
      UPDATE Respuesta SET NOTA = VAR_NOTA_EJER WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
      -- Feedback
    -- Creo que hay que checker antes si submitted at es nulo para poder actualizar cnd entregue la respuesta correcta en el caso contrario
    END IF;
    
    
    EXCEPTION
      WHEN OTHERS THEN -- Si tiene algun error tambien se almacena la fecha, la nota y los intentos
      
        UPDATE Respuesta SET INTENTOS = INTENTOS+1 WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
        UPDATE Respuesta SET SUBMITTED_AT = SYSDATE WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
        UPDATE Respuesta SET NOTA = VAR_NOTA_EJER WHERE Respuesta.id_ejercicio = ID_EJER AND Respuesta.dni_alumno = DNI;
        
        IF SQLCODE = -1789 THEN
          DBMS_OUTPUT.PUT_LINE('ERROR: Las columnas de la respuesta y la solucion del ejercicio no coinciden.');
        ELSIF SQLCODE = -942 THEN
          DBMS_OUTPUT.PUT_LINE('ERROR: La tabla o vista no existe.');
        ELSE
          DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
        END IF;
        
        
  END PR_CORREC_EJER_ALUMNO;
  
  ------------------------------                                                 ------------------------------
  ------------------------------ Correccion de todos los ejercicios de un alumno ------------------------------
  ------------------------------                                                 ------------------------------
  
  -- Un procedimiento que corrige todos los ejercicios de un solo alumno
  PROCEDURE PR_CORREC_ALL_EJER_ALUMNO (DNI IN Respuesta.dni_alumno%TYPE) AS
    -- Creamos un cursor para todas las respuestas a ejercicios del alumno
    CURSOR C_RESPUESTAS IS SELECT id_ejercicio, respuesta FROM Respuesta WHERE dni_alumno=DNI;
  BEGIN
    FOR VAR_RESPUESTA IN C_RESPUESTAS LOOP
      PR_CORREC_EJER_ALUMNO(DNI,VAR_RESPUESTA.id_ejercicio,VAR_RESPUESTA.respuesta);
    END LOOP;
  END PR_CORREC_ALL_EJER_ALUMNO;
  
  
  ------------------------------                                                         ------------------------------
  ------------------------------ Correccion de todos los ejercicios de todos los alumnos ------------------------------
  ------------------------------                                                         ------------------------------
  
  
  
  -- Un procedimiento que todos los ejercicios de todos los alumnos de una asignatura 
  PROCEDURE PR_CORREC_ALL_ALUMNOS (ASIGNATURA_COD Asignatura.codigo%TYPE) AS
  -- Una variable para almacenar el curso actual
  CURSO Matricula.curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY');
  -- Excepcion cuando no existe una asignatura
  ERR_ASIG_INEX EXCEPTION;
  -- variable para almacenar el codigo la asignatura (para ver si existe) 
  var_asignatura Asignatura.codigo%TYPE;
  -- Definimos un cursor para todos los alumnos de la asignatura
  CURSOR C_ALUMNOS IS SELECT alumno_dni_alumno FROM Matricula WHERE asignatura_codigo=ASIGNATURA_COD AND curso_academico=CURSO; 
  BEGIN
  
  
    BEGIN
    
      SELECT codigo INTO var_asignatura FROM Asignatura WHERE ASIGNATURA_COD = ASIGNATURA.codigo;
    EXCEPTION   
      WHEN NO_DATA_FOUND THEN RAISE ERR_ASIG_INEX;
      
    END;
    
    
    FOR VAR_ALUMNO IN C_ALUMNOS LOOP
      PR_CORREC_ALL_EJER_ALUMNO(VAR_ALUMNO.alumno_dni_alumno);
    END LOOP;
    EXCEPTION 
      WHEN ERR_ASIG_INEX THEN DBMS_OUTPUT.PUT_LINE('Error: Asignatura Inexistente');
      WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('Error: '||SQLERRM);
  END PR_CORREC_ALL_ALUMNOS;
  
END PKG_CORRECCION_EJERCICIOS;
/


-- 2. Cuerpo de gestión de usuarios
create or replace 
PACKAGE BODY PKG_GESTION_USUARIOS AS

  -- El proceso crea un usuario con el nombre dado. 
  -- La password inicial sera el nombre de usuario.
  -- Param: NOMBRE
  PROCEDURE PR_CREAR_USUARIO (NOMBRE IN Matricula.usuario%TYPE) AS
  BEGIN
    -- Ejecutamos la instruccion de crear un usuario
    EXECUTE IMMEDIATE 'CREATE USER '|| NOMBRE ||' IDENTIFIED BY '|| NOMBRE;
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -1920 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Usuario ya existente.');
      ELSIF SQLCODE = -1031 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No tienes permisos.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
      END IF;
  END PR_CREAR_USUARIO;

  -- El proceso borra el usuario con el nombre dado. 
  -- Param: NOMBRE
  PROCEDURE PR_BORRAR_USUARIO(NOMBRE IN Matricula.usuario%TYPE) AS
  BEGIN
    -- Ejecutamos la instruccion de borrar un usuario
    EXECUTE IMMEDIATE 'DROP USER '|| NOMBRE ||' CASCADE';
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -1918 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Usuario no existente.');
      ELSIF SQLCODE = -1031 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No tienes permisos.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
      END IF;
  END PR_BORRAR_USUARIO;

  -- El proceso bloquea el usuario con el nombre dado. 
  -- Param: NOMBRE
  PROCEDURE PR_BLOQ_USUARIO(NOMBRE IN Matricula.usuario%TYPE) AS
  BEGIN
    -- Ejecutamos la instruccion de bloquear un usuario
    EXECUTE IMMEDIATE 'ALTER USER '|| NOMBRE ||' ACCOUNT LOCK';
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -1918 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Usuario no existente.');
      ELSIF SQLCODE = -1031 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No tienes permisos.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
      END IF;
  END PR_BLOQ_USUARIO;
  
  -- El proceso mata la sesion del usuario con el nombre dado. 
  -- Param: NOMBRE
  PROCEDURE PR_KILL_SESSION(NOMBRE IN Matricula.usuario%TYPE) AS
  -- Variable que va a guardar los parametros necesarios para la instruccion
  -- alter system kill session 'SID,SERIAL#' immediate
   VAR_KILL_PARAMS SESIONES%ROWTYPE;
  BEGIN    
    -- Seleccionamos los parametros necesario para matar la session del usuario
    -- de la tabla v$session
     SELECT * INTO VAR_KILL_PARAMS
     FROM SESIONES WHERE username=UPPER(NOMBRE);
    
    -- Ejecutamos la instruccion que mata la sesion
    --DBMS_OUTPUT.PUT_LINE('ALTER SYSTEM KILL SESSION '''|| VAR_KILL_PARAMS.sid ||','|| VAR_KILL_PARAMS.serial# ||''' IMMEDIATE');
    EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION '''|| VAR_KILL_PARAMS.sid ||','|| VAR_KILL_PARAMS.serial# ||''' IMMEDIATE';
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -26 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Sesion inválida.');
      ELSIF SQLCODE = -1031 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No tienes permisos.');
      ELSIF SQLCODE = +100 THEN
      DBMS_OUTPUT.PUT_LINE('ERROR: Usuario sin sesión.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
      END IF;
  END PR_KILL_SESSION;
  
  -- El proceso crea todos los usuarios que pertenecen a la asignatura. 
  -- Si no se proporciona curso academico se toma por defecto el curso actual.
  -- Calculado con to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')
  -- Param: ASIGNATURA_NAME, CURSO ACADEMICO
  PROCEDURE PR_CREAR_USUARIO_ASIG(ASIGNATURA_NAME IN Asignatura.nombre%TYPE, 
      CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')) AS
    -- Variable que guarda si una asignatura existe o no (select)
    VAR_ASIG_NAME Asignatura.nombre%TYPE;
    -- Excepcion para cuando no existe una asignatura
    ERR_ASIG_INEXISTENTE EXCEPTION;
    -- Cursor con todos los nombres de usuarios de alumnos que pertenecen
    -- a la asignatura con el nombre dado
    CURSOR C_USUARIOS_ASIG IS
    SELECT Matricula.usuario FROM Matricula 
    JOIN Asignatura ON Matricula.asignatura_codigo = Asignatura.codigo
    WHERE UPPER(Asignatura.nombre) = UPPER(ASIGNATURA_NAME)
    AND Matricula.curso_academico = CURSO;
  BEGIN    
    BEGIN
      -- Seleccionamos el nombre de la tabla por si no existe
      SELECT nombre INTO VAR_ASIG_NAME FROM Asignatura 
      WHERE UPPER(nombre) = UPPER(ASIGNATURA_NAME);
    EXCEPTION
      -- Sin es vacio lanzamos la excepcion
      WHEN NO_DATA_FOUND THEN RAISE ERR_ASIG_INEXISTENTE; 
    END;
    -- Recorremos el cursor y vamos creando usuarios
    FOR VAR_USUARIO IN C_USUARIOS_ASIG 
    LOOP
      PR_CREAR_USUARIO(VAR_USUARIO.usuario);
    END LOOP;
  EXCEPTION
    WHEN ERR_ASIG_INEXISTENTE THEN DBMS_OUTPUT.PUT_LINE('ERROR: Asignatura inexistente.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
  END PR_CREAR_USUARIO_ASIG;

  -- El proceso borra todos los usuarios que pertenecen a la asignatura. 
  -- Si no se proporciona curso academico se toma por defecto el curso actual.
  -- Calculado con to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')
  -- Param: ASIGNATURA_NAME, CURSO ACADEMICO
  PROCEDURE PR_BORRAR_USUARIO_ASIG(ASIGNATURA_NAME IN Asignatura.nombre%TYPE, 
      CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')) AS
    -- Variable que guarda si una asignatura existe o no (select)
    VAR_ASIG_NAME Asignatura.nombre%TYPE;
    -- Excepcion para cuando no existe una asignatura
    ERR_ASIG_INEXISTENTE EXCEPTION;
    -- Cursor con todos los nombres de usuarios de alumnos que pertenecen
    -- a la asignatura con el nombre dado
    CURSOR C_USUARIOS_ASIG IS
    SELECT Matricula.usuario FROM Matricula 
    JOIN Asignatura ON Matricula.asignatura_codigo = Asignatura.codigo
    WHERE UPPER(Asignatura.nombre) = UPPER(ASIGNATURA_NAME)
    AND Matricula.curso_academico = CURSO;
  BEGIN
    BEGIN
      -- Seleccionamos el nombre de la tabla por si no existe
      SELECT nombre INTO VAR_ASIG_NAME FROM Asignatura 
      WHERE UPPER(nombre) = UPPER(ASIGNATURA_NAME);
    EXCEPTION
      -- Sin es vacio lanzamos la excepcion
      WHEN NO_DATA_FOUND THEN RAISE ERR_ASIG_INEXISTENTE; 
    END;
    -- Recorremos el cursor y vamos bloqueando usuarios
    FOR VAR_USUARIO IN C_USUARIOS_ASIG 
    LOOP
      PR_BORRAR_USUARIO(VAR_USUARIO.usuario);
    END LOOP;
  EXCEPTION
    WHEN ERR_ASIG_INEXISTENTE THEN DBMS_OUTPUT.PUT_LINE('ERROR: Asignatura inexistente.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
  END PR_BORRAR_USUARIO_ASIG;

  -- El proceso bloquea a todos los usuarios que pertenecen a la asignatura.
  -- Si no se proporciona curso academico se toma por defecto el curso actual.
  -- Calculado con to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')
  -- Param: ASIGNATURA_NAME, CURSO ACADEMICO
  PROCEDURE PR_BLOQ_USUARIO_ASIG(ASIGNATURA_NAME IN Asignatura.nombre%TYPE, 
      CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')) AS
    -- Variable que guarda si una asignatura existe o no (select)
    VAR_ASIG_NAME Asignatura.nombre%TYPE;
    -- Excepcion para cuando no existe una asignatura
    ERR_ASIG_INEXISTENTE EXCEPTION;
    -- Cursor con todos los nombres de usuarios de alumnos que pertenecen
    -- a la asignatura con el nombre dado
    CURSOR C_USUARIOS_ASIG IS
    SELECT Matricula.usuario FROM Matricula 
    JOIN Asignatura ON Matricula.asignatura_codigo = Asignatura.codigo
    WHERE UPPER(Asignatura.nombre) = UPPER(ASIGNATURA_NAME)
    AND Matricula.curso_academico = CURSO;
  BEGIN
    BEGIN
      -- Seleccionamos el nombre de la tabla por si no existe
      SELECT nombre INTO VAR_ASIG_NAME FROM Asignatura 
      WHERE UPPER(nombre) = UPPER(ASIGNATURA_NAME);
    EXCEPTION
      -- Sin es vacio lanzamos la excepcion
      WHEN NO_DATA_FOUND THEN RAISE ERR_ASIG_INEXISTENTE; 
    END;
    -- Recorremos el cursor y vamos bloqueando usuarios
    FOR VAR_USUARIO IN C_USUARIOS_ASIG 
    LOOP
      PR_BLOQ_USUARIO(VAR_USUARIO.usuario);
    END LOOP;
  EXCEPTION
    WHEN ERR_ASIG_INEXISTENTE THEN DBMS_OUTPUT.PUT_LINE('ERROR: Asignatura inexistente.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
  END PR_BLOQ_USUARIO_ASIG;
  
  PROCEDURE PR_KILL_SESSION_ASIG(ASIGNATURA_NAME IN Asignatura.nombre%TYPE,
      CURSO IN Matricula.Curso_academico%TYPE DEFAULT to_char(sysdate, 'YY')||'/'||to_char(add_months(sysdate,12), 'YY')) AS
    -- Variable que guarda si una asignatura existe o no (select)
    VAR_ASIG_NAME Asignatura.nombre%TYPE;
    -- Excepcion para cuando no existe una asignatura
    ERR_ASIG_INEXISTENTE EXCEPTION;
    -- Cursor con todos los nombres de usuarios de alumnos que pertenecen
    -- a la asignatura con el nombre dado
    CURSOR C_USUARIOS_ASIG IS
    SELECT Matricula.usuario FROM Matricula 
    JOIN Asignatura ON Matricula.asignatura_codigo = Asignatura.codigo
    WHERE UPPER(Asignatura.nombre) = UPPER(ASIGNATURA_NAME)
    AND Matricula.curso_academico = CURSO;
  BEGIN
    BEGIN
      -- Seleccionamos el nombre de la tabla por si no existe
      SELECT nombre INTO VAR_ASIG_NAME FROM Asignatura 
      WHERE UPPER(nombre) = UPPER(ASIGNATURA_NAME);
    EXCEPTION
      -- Sin es vacio lanzamos la excepcion
      WHEN NO_DATA_FOUND THEN RAISE ERR_ASIG_INEXISTENTE; 
    END;
     -- Recorremos el cursor y vamos bloqueando usuarios
    FOR VAR_USUARIO IN C_USUARIOS_ASIG 
    LOOP
      PR_KILL_SESSION(VAR_USUARIO.usuario);
    END LOOP;
  EXCEPTION
    WHEN ERR_ASIG_INEXISTENTE THEN DBMS_OUTPUT.PUT_LINE('ERROR: Asignatura inexistente.');
    WHEN OTHERS THEN DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
  END PR_KILL_SESSION_ASIG;

END PKG_GESTION_USUARIOS;
/

-- 3.Cuerpo de gráficas
CREATE OR REPLACE
PACKAGE BODY PKG_GRAFICAS AS

  -- Dado el nombre de la vista que contiene los datos genera un gráfico de barras
  -- PARA USAR EL METODO: La vista que contiene los datos tiene que tener dos columnas:
  -- NAME(varchar2), VALUE(integer)
  -- VISUALIZAR LA GRAFICA: la vista donde se guarda la grafica es VER_GRAFICA_VIEW
  -- ARGUMENTOS: VIEW_NAME
  PROCEDURE PR_DIBUJAR_GRAFICA (VIEW_NAME IN VARCHAR2) AS
  BEGIN
    EXECUTE IMMEDIATE 'CREATE OR REPLACE VIEW VER_GRAFICA_VIEW AS 
    SELECT name, LPAD('' '', value, ''*'') as amount FROM '|| VIEW_NAME;
    DBMS_OUTPUT.PUT_LINE('Grafica guardada. Para ver el resultado ejecuta: SELECT * FROM VER_GRAFICA_VIEW;');
  EXCEPTION
    WHEN OTHERS THEN
      IF SQLCODE = -1031 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: No tienes permisos.');
      ELSIF SQLCODE =-942 THEN
        DBMS_OUTPUT.PUT_LINE('ERROR: Vista de datos desconocida.');
      ELSE
        DBMS_OUTPUT.PUT_LINE('ERROR: ' || SQLERRM);
      END IF;
  END PR_DIBUJAR_GRAFICA;

END PKG_GRAFICAS;
/


  ------------------------------              ------------------------------
  ------------------------------    VISTAS    ------------------------------
  ------------------------------              ------------------------------


-- Añadido posibles vistas para los triggers

CREATE OR REPLACE VIEW TIEMPO_EMPLEADO_VIEW AS SELECT USUARIO,TIEMPO_EMPLEADO FROM ESTADISTICAS;

CREATE OR REPLACE VIEW MAS_CONEXIONES_VIEW AS SELECT USUARIO,NUMERO_CONEXIONES,ULTIMA_SESION FROM ESTADISTICAS ORDER BY NUMERO_CONEXIONES DESC;

-- Vistas de DATA ANALYSIS

-- Los que mas intentos fallan
CREATE OR REPLACE VIEW MAS_INTENTOS_FALLIDOS_VIEW AS
SELECT dni_alumno as name, SUM(intentos) as value FROM Respuesta 
GROUP BY dni_alumno
ORDER BY SUM(intentos) DESC;

-- Los más fiables
CREATE OR REPLACE VIEW MAS_FIABLES_VIEW AS
SELECT dni_alumno as name, SUM(intentos) as value FROM Respuesta
GROUP BY dni_alumno
ORDER BY SUM(intentos);

-- Vista para las graficas (dummy)

CREATE OR REPLACE VIEW VER_GRAFICA_VIEW AS SELECT * FROM DUAL;

  ------------------------------                ------------------------------
  ------------------------------    TRIGGERS    ------------------------------
  ------------------------------                ------------------------------
  
  -- 1. Fecha de entrega
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

-- 2. Ultima sesión del alumno
create or replace 
trigger LAST_SESSION 
AFTER LOGON ON DATABASE 

BEGIN
  IF USER != 'SYS' THEN
    UPDATE ESTADISTICAS SET ULTIMA_SESION = CURRENT_TIMESTAMP,NUMERO_CONEXIONES = NUMERO_CONEXIONES+1 WHERE USUARIO = USER;
  
      if sql%notfound then 
        insert into estadisticas(USUARIO,ULTIMA_SESION,NUMERO_CONEXIONES,TIEMPO_EMPLEADO) VALUES(USER,CURRENT_TIMESTAMP,1,0);
      end if;
  END IF;
END;

-- 3. Tiempo empleado para realizar los ejercicioscreate or replace trigger TIEMPO_EMPLEADO 
BEFORE LOGOFF ON DATABASE 
BEGIN
  UPDATE  ESTADISTICAS SET TIEMPO_EMPLEADO = TIEMPO_EMPLEADO+(select round((extract( day from diff ))*24 +
        (extract( hour from diff ))+
           (extract( minute from diff ))/60+
           (extract( second from diff ))/3600,2) as tiempo_invertido
      from (select current_timestamp - ultima_sesion diff
  from ESTADISTICAS),estadisticas) WHERE USUARIO = USER;
END;

