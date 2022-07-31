CREATE DATABASE bdRecursosHumanos

USE bdRecursosHumanos

CREATE TABLE tbDepartamento(
	codDepartamento INT PRIMARY KEY IDENTITY (1,1)
	,nomeDepartamento VARCHAR(20) NOT NULL
)

CREATE TABLE tbFuncionario(
	codFuncionario INT PRIMARY KEY IDENTITY (1,1)
	,nomeFuncionario VARCHAR(30) NOT NULL
	,cpfFuncionario BIGINT NOT NULL
	,sexoFuncionario CHAR(1) NOT NULL
	,dataNascimentoFuncionario DATETIME NOT NULL
	,salarioFuncionario MONEY NOT NULL
	,codDepartamento INT FOREIGN KEY REFERENCES tbDepartamento(codDepartamento)
)

CREATE TABLE tbDependente(
	codDependente INT PRIMARY KEY IDENTITY (1,1)
	,nomeDependente VARCHAR(30) NOT NULL
	,dataNascimentoDependente DATETIME NOT NULL
	,sexoDependente CHAR(1) NOT NULL
	,codFuncionario INT FOREIGN KEY REFERENCES tbFuncionario(codFuncionario)
)


--Insert

INSERT INTO tbDepartamento(nomeDepartamento) VALUES
('Compras')
,('Vendas')
,('TI')
,('Marketing')

INSERT INTO tbFuncionario(nomeFuncionario, cpfFuncionario, sexoFuncionario, dataNascimentoFuncionario, salarioFuncionario, codDepartamento) VALUES
('Maria Luisa Moura', 12345678900, 'F', '19900210', 3400, 1)
,('Mariana Goulart', 45678909299, 'F', '19910408', 2800, 1)
,('Pedro Paulo Vidigal', 64587222388, 'M', '19940507', 5400, 2)
,('Carlos Calixto', 83738232233, 'M', '19650303', 8900, 2)
,('Viviane Martins', 77832233399, 'F', '19760606', 4300, 3)
,('Analice Mendes', 83703383493, 'F', '19810909', 6800, 3)
,('Patricia Ishikawa', 43356609300, 'F', '19780505', 4900, 4)

INSERT INTO tbDependente(nomeDependente, dataNascimentoDependente, sexoDependente, codFuncionario) VALUES
('Lucas Moura', '20150110', 'M', 1)
,('Carlos Clixto Jr', '20000608', 'M', 4)
,('Michele Costa Calixto', '20030909', 'F', 4)
,('Silvana Costa Calixto', '20060404', 'F', 4)
,('Arthur Mendes Silva', '20100707', 'M', 6)


-- View

CREATE VIEW vw_FuncionarioDepartamento AS
	SELECT nomeDepartamento as 'Departamento', COUNT(tbFuncionario.codFuncionario) Funcionarios from tbDepartamento
	INNER JOIN tbFuncionario
		ON tbDepartamento.codDepartamento = tbFuncionario.codDepartamento
		 GROUP BY nomeDepartamento

SELECT [Departamento] from vw_FuncionarioDepartamento
WHERE Funcionarios IN (SELECT MIN(Funcionarios) FROM vw_FuncionarioDepartamento)


CREATE VIEW vw_SalarioDepartamento AS
	SELECT nomeDepartamento as 'Departamento', SUM(tbFuncionario.salarioFuncionario) Soma from tbDepartamento
	INNER JOIN tbFuncionario
		ON tbDepartamento.codDepartamento = tbFuncionario.codDepartamento
		GROUP BY nomeDepartamento

SELECT [Departamento] FROM vw_SalarioDepartamento
WHERE Soma IN (SELECT MAX(Soma) FROM vw_SalarioDepartamento)


CREATE VIEW vw_FuncSemDependente AS
	SELECT nomeDepartamento AS 'Departamento', nomeFuncionario FROM tbDepartamento
	INNER JOIN tbFuncionario
		ON tbDepartamento.codDepartamento = tbFuncionario.codDepartamento
		WHERE tbFuncionario.codFuncionario NOT IN (SELECT tbFuncionario.codFuncionario from tbDependente INNER JOIN tbFuncionario 
		ON tbDependente.codFuncionario = tbFuncionario.codFuncionario)


CREATE VIEW	vw_QtdeDependentes AS
	SELECT nomeFuncionario AS 'Funcionário', COUNT(tbDependente.codDependente) AS Quantidade FROM tbFuncionario
	INNER JOIN tbDependente
		ON tbFuncionario.codFuncionario = tbDependente.codFuncionario
		GROUP BY nomeFuncionario


SELECT [Funcionário] FROM vw_QtdeDependentes
WHERE Quantidade IN (SELECT MAX(Quantidade) FROM vw_QtdeDependentes)

