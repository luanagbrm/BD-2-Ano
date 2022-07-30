USE bdEscolaIdiomas

-- 1) Apresentar os nomes dos alunos ao lado do nome dos cursos que eles fazem;
	SELECT nomeAluno as 'Aluno', nomeCurso as 'Curso em que está matriculado' from tbAluno
		inner join tbMatricula on tbAluno.codAluno = tbMatricula.codAluno
		inner join tbTurma on tbMatricula.codTurma = tbTurma.codTurma
		inner join tbCurso on tbTurma.codCurso = tbCurso.codCurso

-- 2) Apresentar a quantidade de alunos matriculados por nome do curso;
	SELECT nomeCurso as 'Curso',
		COUNT (tbAluno.codAluno) as 'Quantidade de alunos matriculados' from tbCurso
		inner join tbTurma on tbCurso.codCurso = tbTurma.codCurso
		inner join tbMatricula on tbTurma.codTurma = tbMatricula.codTurma
		inner join tbAluno on tbMatricula.codAluno = tbAluno.codAluno

		group by nomeCurso

-- 3) Apresentar a quantidade de alunos matriculados por nome da turma;
	SELECT nomeTurma as 'Turma',
		COUNT (tbAluno.codAluno) as 'Quantidade de alunos matriculados' from tbTurma
		inner join tbMatricula on tbTurma.codTurma = tbMatricula.codTurma
		inner join tbAluno on tbMatricula.codAluno = tbAluno.codAluno

		group by nomeTurma

-- 4) Apresentar a quantidade de alunos que fizeram matricula em maio de 2016;
	SELECT COUNT(codAluno) as 'Matriculados em 05/2016' from tbMatricula
		WHERE month(tbMatricula.dataMatricula) = 5 and year(tbMatricula.dataMatricula) = 2016

-- 5) Apresentar o nome dos alunos em ordem alfabética ao lado do nome das turmas em que estão matriculados;
		SELECT nomeAluno as 'Aluno', nomeTurma as 'Turma em que está matriculado' from tbAluno
			inner join tbMatricula on tbAluno.codAluno = tbMatricula.codAluno
			inner join tbTurma on tbMatricula.codTurma = tbTurma.codTurma

			order by nomeAluno asc
	
-- 6) Apresentar o nome dos cursos e os horários em que eles são oferecidos;
		SELECT nomeCurso as 'Curso', 
			FORMAT (tbTurma.horarioTurma, 'HH:mm') as 'Horário disponível' from tbCurso
				inner join tbTurma
				on tbTurma.codCurso = tbCurso.codCurso


-- 7) Apresentar a quantidade de alunos nascidos por estado;
	SELECT naturalidadeAluno as 'Estado',
		COUNT (codAluno) as 'Quantidade de pertencentes' from tbAluno
			group by naturalidadeAluno

-- 8) Apresentar o nome dos alunos ao lado da data de matrícula no formato dd/mm/aaaa;
		SELECT nomeAluno as 'Aluno',
			FORMAT (tbMatricula.dataMatricula, 'dd/MM/yyyy') as 'Data que foi matriculado' from tbAluno
				inner join tbMatricula
				on tbMatricula.codAluno = tbAluno.codAluno

-- 9) Apresentar os alunos cujo nome comece com A e que estejam matriculados no curso de inglês;
	SELECT nomeAluno as 'Alunos com inicial A matriculados no curso de Inglês' from tbAluno
		inner join tbMatricula on tbAluno.codAluno = tbMatricula.codAluno
		inner join tbTurma on tbMatricula.codTurma = tbTurma.codTurma
		WHERE nomeAluno LIKE 'A%' and codCurso = 1


-- 10) Apresentar a quantidade de matrículas feitas no ano de 2016;
	 SELECT COUNT(codMatricula) as 'Matriculas feitas em 2016' from tbMatricula
	 WHERE year(tbMatricula.dataMatricula) = 2016