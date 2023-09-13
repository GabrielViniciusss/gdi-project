 /*
 Seu projeto deve ter todos os tipos de consultas abaixo
-Group by/Having CHECK
-Junção interna CHECK
-Junção externa CHECK
-Semi junção CHECK
-Anti-junção CHECK
-Subconsulta do tipo escalar CHECK
-Subconsulta do tipo linha CHECK
-Subconsulta do tipo tabela CHECK
-Operação de conjunto CHECK
*/


-- Usando Group By/Having --

--Quais academias tem mais de 1 extensora?--
SELECT ID_ACAD, COUNT(*)
FROM MAQUINAS
WHERE NOME = 'Extensora'
GROUP BY ID_ACAD
HAVING COUNT(*) > 1;

-- Usando Junção interna --

--Alunos e suas respectivas academias--
SELECT DISTINCT A.NOME, F.ID_ACAD
FROM ALUNO A INNER JOIN TREINO T ON A.CPF = T.CPF_ALUNO INNER JOIN FUNCIONARIOS F ON F.CPF = T.CPF_PROF;

--Academia que os alunos sem promoção frequentam--
SELECT DISTINCT A.NOME, F.ID_ACAD
FROM ALUNO A 
INNER JOIN CADASTRO C ON A.CPF = C.CPF 
INNER JOIN TREINO T ON T.CPF_ALUNO = A.CPF
INNER JOIN FUNCIONARIOS F ON F.CPF = T.CPF_PROF
WHERE C.ID_PROMO IS NULL ;


-- Usando Junção externa --

--Alunos que nunca pegaram plano premium--
SELECT DISTINCT A.NOME
FROM ALUNO A LEFT OUTER JOIN CADASTRO C ON C.CPF = A.CPF
WHERE C.COD = 'PLS';


-- Usando Semi join --

--Quais alunos treinam perna--
SELECT A.NOME
FROM ALUNO A 
WHERE EXISTS (SELECT T.COD FROM TREINO T WHERE (T.CPF_ALUNO = A.CPF) AND (T.COD = 'C')) ;


-- Usando anti join --

--Quais alunos NÃO treinam perna--
SELECT A.NOME
FROM ALUNO A 
WHERE NOT EXISTS (SELECT T.COD FROM TREINO T WHERE (T.CPF_ALUNO = A.CPF) AND (T.COD = 'C'));


-- Usando subselect tipo escalar --

--Quais academias tem mais máquinas que a media EMBARCANDO NA VIAAAGEM--
SELECT ID_ACAD, COUNT(*)
FROM MAQUINAS
GROUP BY ID_ACAD
HAVING COUNT(*) > (SELECT AVG(QTD) FROM (SELECT COUNT(*) AS QTD, ID_ACAD FROM MAQUINAS GROUP BY ID_ACAD));


-- Usando subselect tipo linha --

--ID da academia com mais máquinas--
SELECT ID_ACAD
FROM (SELECT ID_ACAD, COUNT(*) FROM MAQUINAS GROUP BY ID_ACAD HAVING COUNT(*) = (SELECT MAX(QTD) FROM (SELECT COUNT(*) AS QTD, ID_ACAD FROM MAQUINAS GROUP BY ID_ACAD)));
  

-- Usando subselect tipo tabela --

-- Quais alunos treinam com mais de 1 professor--
SELECT A.NOME , COUNT(*) AS QTD_PROF
FROM (SELECT DISTINCT CPF_ALUNO, CPF_PROF FROM TREINO) INNER JOIN ALUNO A ON CPF_ALUNO = A.CPF
GROUP BY A.NOME
HAVING COUNT(*) > 1;


-- Usando operação de conjunto -- 

-- Alunos e suas respectivas academias--
SELECT DISTINCT A.NOME, F.ID_ACAD
FROM ALUNO A, TREINO T, FUNCIONARIOS F
WHERE A.CPF = T.CPF_ALUNO AND T.CPF_PROF = F.CPF;


------PROCEDURES E FUNCTIONS--------------------

----Procedure01 -> Exibe a quantidade de maquinas por acad

-- EXIBIR A QTD DE MAQUINA POR ACAD

CREATE OR REPLACE PROCEDURE EXIBIR_QTD(ID IN VARCHAR) IS
	QTD NUMBER;
BEGIN
	SELECT COUNT(*) INTO QTD FROM MAQUINAS WHERE ID_ACAD = ID;
	dbms_output.put_line('A qtd é : ' ||QTD);
END;

EXEC EXIBIR_QTD('ACAD004');  --usar exec dps de criar procedure

-----Function01 -> Exibe a quantidade de maquinas por acad

CREATE OR REPLACE FUNCTION GET_QTD_MACHINES(ID VARCHAR)
RETURN NUMBER IS QTD NUMBER;
BEGIN 
	SELECT COUNT(*) INTO QTD FROM MAQUINAS WHERE ID_ACAD = ID;
	RETURN QTD;
END;


SELECT DISTINCT ID_ACAD, GET_QTD_MACHINES(ID_ACAD) AS QTD_MAQUINAS --usar dps de criar func
FROM MAQUINAS;
