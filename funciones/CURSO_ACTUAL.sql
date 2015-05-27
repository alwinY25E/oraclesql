CREATE OR REPLACE FUNCTION CURSO_ACTUAL RETURN VARCHAR2 AS 
pragma autonomous_transaction;

var_curso varchar2(5);
cuantos number;
BEGIN
  
  if to_char(sysdate,'MM') > '09' then
    var_curso := to_char(sysdate,'YY')||'/'||to_char(add_months(sysdate,12),'YY'); 
  else    
    var_curso := to_char(add_months(sysdate,12),'YY')||'/'||to_char(sysdate,'YY');
  end if;
  select count(*) into cuantos from cursos_academicos where curso= var_curso ;
    if cuantos = 0 then 
      insert into cursos_academicos VALUES(var_curso);
    end if;
  RETURN var_curso;
END CURSO_ACTUAL;
