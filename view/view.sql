USE bdEscolaIdiomas

--1.Crie uma vis�o �Pre�o_Baixo� que exiba o c�digo, nome do curso, carga hor�ria e o valor do curso de todos os cursos que tenha pre�o inferior ao pre�o m�dio.

	CREATE VIEW vwPreco_Baixo as
	SELECT codCurso, nomeCurso, cargaHorariaCurso, valorCurso from tbCurso
	WHERE valorCurso < (SELECT AVG(valorCurso) from tbCurso)

--2.Usando a vis�o �Pre�o_Baixo�, mostre todos os cursos ordenados por carga hor�ria.
	
	SELECT nomeCurso from vwPreco_Baixo
	ORDER BY cargaHorariaCurso

--3.Crie uma vis�o �Alunos_Turma� que exiba o curso e a quantidade de alunos por turma.

	CREATE VIEW vwAlunos_Turma as
	SELECT COUNT(tbMatricula.codAluno) as 'Qtde. Alunos', nomeCurso from tbMatricula
		inner join tbTurma on tbMatricula.codTurma = tbTurma.codTurma
		inner join tbCurso on tbTurma.codCurso = tbCurso.codCurso
		GROUP BY nomeCurso

--4.Usando a vis�o �Alunos_Turma� exiba a turma com maior n�mero de alunos.
	
	SELECT nomeCurso from vwAlunos_Turma
	WHERE [Qtde. Alunos] in (SELECT MAX([Qtde. Alunos]) from vwAlunos_Turma)

--5.Crie uma vis�o �Turma_Curso" que exiba o curso e a quantidade de turmas.
	
	CREATE VIEW vwTurma_Curso as
	SELECT COUNT(tbTurma.codTurma) as 'Qtde. Turmas', nomeCurso from tbTurma
		inner join tbCurso on tbTurma.codCurso = tbCurso.codCurso
		GROUP BY nomeCurso

--6.Usando a vis�o �Turma_Curso" exiba o curso com menor n�mero de turmas.
	
	SELECT nomeCurso from vwTurma_Curso
	WHERE [Qtde. Turmas] in (SELECT MIN([Qtde. Turmas]) from vwTurma_Curso)