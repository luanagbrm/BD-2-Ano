USE bdEscolaDeIdiomas


-- 1) Criar uma consulta que retorne o nome e o preço dos cursos que custem abaixo do valor médio.
SELECT nomeCurso, valorCurso FROM tbCurso
WHERE valorCurso < (SELECT AVG(valorCurso) FROM tbCurso)

-- 2) Criar uma consulta que retorne o nome e o rg do aluno mais novo.
SELECT nomeAluno, rgAluno FROM tbAluno
WHERE dataNascimento IN (SELECT MAX(dataNascimento) FROM tbAluno)

-- 3) Criar uma consulta que retorne o nome do aluno mais velho.
SELECT nomeAluno FROM tbAluno
WHERE dataNascimento IN (SELECT MIN(dataNascimento) FROM tbAluno)

-- 4) Criar uma consulta que retorne o nome e o valor do curso mais caro.
SELECT nomeCurso, valorCurso FROM tbCurso
WHERE valorCurso IN (SELECT MAX(valorCurso) FROM tbCurso)

-- 5) Criar uma consulta que retorne o nome do aluno e o nome do curso, do aluno que fez a última matrícula.
SELECT nomeAluno, nomeCurso from tbAluno
INNER JOIN tbMatricula on tbAluno.codAluno = tbMatricula.codAluno
INNER JOIN tbTurma on tbMatricula.codTurma = tbTurma.codTurma
INNER JOIN tbCurso on tbTurma.codCurso = tbCurso.codCurso
WHERE dataMatricula IN (SELECT MAX(dataMatricula) from tbMatricula)

-- 6) Criar uma consulta que retorne o nome do primeiro aluno a ser matriculado na escola de Idiomas.
SELECT nomeAluno from tbAluno
INNER JOIN tbMatricula on tbAluno.codAluno = tbMatricula.codAluno
WHERE dataMatricula IN (SELECT MIN(dataMatricula) from tbMatricula)


-- 7) Criar uma consulta que retorne o nome, rg e data de nascimento de todos os alunos que estejam matriculados no curso de inglês.
SELECT nomeAluno, rgAluno, dataNascimento from tbAluno
INNER JOIN tbMatricula on tbAluno.codAluno = tbMatricula.codAluno
INNER JOIN tbTurma on tbMatricula.codTurma = tbTurma.codTurma
INNER JOIN tbCurso on tbTurma.codCurso = tbCurso.codCurso
WHERE tbCurso.nomeCurso IN (SELECT nomeCurso = 'Inglês' from tbCurso)