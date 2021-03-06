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
