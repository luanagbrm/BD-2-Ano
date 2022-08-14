USE bdEscola

-- 1. Criar uma stored procedure “Busca_Aluno” que receba o código do aluno e retorne seu nome e data de nascimento.
CREATE PROCEDURE spBusca_Aluno
	@codAluno INT
AS
	SELECT nomeAluno, dataNascimento FROM tbAluno
	WHERE codAluno = @codAluno

-- EXEC Ex. 1 - Busca Aluno
-- Pedro Nogueira da Silva
EXEC spBusca_Aluno 3
-------------------



-- 2. Criar uma stored procedure “Insere_Aluno” que insira um registro na tabela de Alunos.​
CREATE PROCEDURE spInsere_Aluno
	@nomeAluno VARCHAR(30), @dataNascimento SMALLDATETIME, @rgAluno VARCHAR(25), @cpfAluno VARCHAR(25), @logradouro VARCHAR(50), @numero INT, @complemento VARCHAR(20), @cep INT, @bairro VARCHAR(30), @cidade VARCHAR(30)
AS
	INSERT INTO tbAluno(nomeAluno,dataNascimento,rgAluno,cpfAluno,logradouro,numero,complemento,cep,bairro,cidade)
	VALUES (@nomeAluno,@dataNascimento,@rgAluno,@cpfAluno,@logradouro,@numero,@complemento,@cep,@bairro,@cidade)

-- EXEC Ex. 2 - Insert Aluno sem validação
EXEC spInsere_Aluno 'Gustavo Joia','20050530','56.956.728-5','480.985.364-13','Rua Lema',697,'Ap. 34A',06587045,'Cidade Tiradentes','São Paulo'
-------------------



-- 3. Criar uma stored procedure “Aumenta_Preco” que, dados o nome do curso e um percentual, aumente o valor do curso com a porcentagem informada​
CREATE PROCEDURE spAumenta_Preco
	@nomeCurso VARCHAR(30), @porcentagem INT
AS
BEGIN
	IF(@nomeCurso LIKE 'Alemão' OR @nomeCurso LIKE 'Espanhol' OR @nomeCurso LIKE 'Inglês')
		BEGIN
			UPDATE tbCurso
			SET valorCurso = valorCurso+valorCurso*@porcentagem/100
			WHERE codCurso IN (SELECT codCurso FROM tbCurso WHERE nomeCurso = @nomeCurso)
			PRINT('O curso de '+@nomeCurso+' sofreu um reajuste de '+CONVERT(VARCHAR(5),@porcentagem)+'%')
		END
	ELSE
		PRINT('Não possuímos essa opção de curso')
END

-- EXECS Ex. 3 - Aumenta Preço
--Válido
EXEC spAumenta_Preco 'Espanhol',10
SELECT * FROM tbCurso

--Inválido (curso inexistente)
EXEC spAumenta_Preco 'Francês',10



-- 4. Criar uma stored procedure “Exibe_Turma” que, dado o nome da turma exiba todas as informações dela.
CREATE PROCEDURE spExibe_Turma
	@descricaoTurma VARCHAR(5)
AS
	SELECT * FROM tbTurma
	WHERE descricaoTurma = @descricaoTurma

-- EXECS Ex. 4 - Dados Turma
-- Alemão
EXEC spExibe_Turma '1AA'
-- Espanhol
EXEC spExibe_Turma '1IC'
-- Inglês 2
EXEC spExibe_Turma '1IB'
-------------------------



-- 5. Criar uma stored procedure “Exibe_AlunosdaTurma” que, dado o nome da turma exiba os seus alunos
CREATE PROCEDURE spExibe_AlunosdaTurma
	@descricaoTurma VARCHAR(5)
AS
	SELECT nomeAluno FROM tbAluno
		inner join tbMatricula
			on tbAluno.codAluno = tbMatricula.codAluno
		inner join tbTurma
			on tbTurma.codTurma = tbMatricula.codTurma
	WHERE descricaoTurma LIKE @descricaoTurma

-- EXECS Ex. 5 - Alunos Turma
-- Alemão
EXEC spExibe_AlunosdaTurma '1AA'
-- Inglês 1
EXEC spExibe_AlunosdaTurma '1IA'
--Inglês 2
EXEC spExibe_AlunosdaTurma '1IB'
--------



-- 6. Criar uma stored procedure para inserir alunos, verificando pelo cpf se o aluno existe ou não, e informar essa condição via mensagem​
CREATE PROCEDURE spInsere_AlunoCPF
	@nomeAluno VARCHAR(30), @dataNascimento SMALLDATETIME, @rgAluno VARCHAR(25), @cpfAluno VARCHAR(25), @logradouro VARCHAR(50), @numero INT, @complemento VARCHAR(20), @cep INT, @bairro VARCHAR(30), @cidade VARCHAR(30)
AS
BEGIN
	IF EXISTS(SELECT cpfAluno FROM tbAluno WHERE cpfAluno = @cpfAluno)
		BEGIN
			PRINT('O CPF '+@cpfAluno+' já está registrado. Não é possível adicionar esse usuário.')
		END
	ELSE
		BEGIN
			INSERT INTO tbAluno(nomeAluno,dataNascimento,rgAluno,cpfAluno,logradouro,numero,complemento,cep,bairro,cidade)
			VALUES (@nomeAluno,@dataNascimento,@rgAluno,@cpfAluno,@logradouro,@numero,@complemento,@cep,@bairro,@cidade)
			PRINT('O aluno '+@nomeAluno+' foi registrado com sucesso.')
		END
END

-- EXECS Ex. 6 - Insert com Validação
-- Válido
EXEC spInsere_AlunoCPF 'Luana Macedo','20050424','56.021.568-2','481.113.698-23','Rua 3',228,'Ap. 32C',08974005,'Cidade Tiradentes','São Paulo'

--Inválido (Previamente registrado)
EXEC spInsere_AlunoCPF 'Luana Macedo','20050424','56.021.568-2','481.113.698-23','Rua 3',228,'Ap. 32C',08974005,'Cidade Tiradentes','São Paulo'
--------



-- 7. Criar uma stored procedure que receba o nome do curso e o nome do aluno e matricule o mesmo no curso pretendido​
CREATE PROCEDURE spMatricula_Aluno
	@nomeAluno VARCHAR(30), @nomeCurso VARCHAR(30)
AS
BEGIN 
	IF EXISTS(SELECT nomeAluno FROM tbAluno WHERE nomeAluno LIKE @nomeAluno)
		BEGIN
			DECLARE @codAluno INT
			SET @codAluno = (SELECT codAluno FROM tbAluno WHERE nomeAluno LIKE @nomeAluno)

			DECLARE @codTurma INT
			SET @codTurma = (SELECT MAX(codTurma) FROM tbTurma WHERE codCurso IN (SELECT codCurso FROM tbCurso WHERE nomeCurso LIKE @nomeCurso))

			IF(@nomeCurso LIKE 'Alemão' OR @nomeCurso LIKE 'Espanhol' OR @nomeCurso LIKE 'Inglês')
				BEGIN
					IF EXISTS(SELECT codAluno FROM tbMatricula WHERE codAluno LIKE @codAluno 
					AND codTurma LIKE @codTurma)
						BEGIN
							PRINT('O aluno já está matriculado nesse curso')
						END
					ELSE
						BEGIN
							INSERT INTO tbMatricula(dataMatricula,codAluno,codTurma)
							VALUES(GETDATE(),@codAluno,@codTurma)
								PRINT('O aluno '+@nomeAluno+' foi registrado com sucesso no curso de '+@nomeCurso)
						END
				END
			ELSE
				BEGIN
					PRINT('Não possuímos essa opção de curso.')
				END
		END
	ELSE
		BEGIN
			PRINT('É necessário cadastrar o aluno antes de matriculá-lo a um curso')
		END
END

-- EXECS Ex. 7 - Matricula de Aluno
-- Válido
EXEC spMatricula_Aluno 'Aline Melo','Alemão'

--Inválido (Aluno não existente)
EXEC spMatricula_Aluno 'Ana Paula','Inglês'

--Inválido (Curso não existente)
EXEC spMatricula_Aluno 'Gilson Barros Silva','Francês'
---------