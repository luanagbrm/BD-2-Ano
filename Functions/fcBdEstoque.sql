
-- 1. Criar uma fun��o que retorne o dia de semana da venda (no formato segunda, ter�a, etc) ao lado do c�digo da venda, valor total da venda e sua data
CREATE FUNCTION fc_dadosVenda(@codVenda INT)
	RETURNS VARCHAR(80) AS
BEGIN
	DECLARE @dia INT, @dataC date, @diaSemana VARCHAR(15)
	SET @dataC = (SELECT dataVenda FROM tbVenda WHERE codVenda = @codVenda)
	SET @dia = DATEPART(dw,@dataC)

		--Dia das semana
		IF @dia = 1
			BEGIN
				set @diaSemana = 'Domingo'
			END
		IF @dia = 2
			BEGIN
				set @diaSemana = 'Segunda-Feira'
			END
		IF @dia = 3
			BEGIN
				set @diaSemana = 'Ter�a-feira'
			END
		IF @dia = 4
			BEGIN
				set @diaSemana = 'Quarta-feira'
			END
		IF @dia = 5
			BEGIN
				set @diaSemana = 'Quinta-feira'
			END
		IF @dia = 6
			BEGIN
				set @diaSemana = 'Sexta-feira'
			END
		IF @dia = 7
			BEGIN
				set @diaSemana = 'S�bado'
			END

		-- Dados
		DECLARE @valor money
		SET @valor = (SELECT valorTotalVenda FROM tbVenda WHERE codVenda = @codVenda)

		-- Output
		RETURN CONVERT(VARCHAR(4),@codVenda)+'    '+CONVERT(VARCHAR(10),@valor)+'    '+CONVERT(VARCHAR(20),@dataC)+'    '+CONVERT(VARCHAR(20),@diaSemana)
END

--Exec. Dados Compra
SELECT 'Dados da compra:'=dbo.fc_dadosVenda(1)



-- 2. Criar uma fun��o que receba o c�digo do cliente e retorne o total de vendas que o cliente j� realizou
CREATE FUNCTION fc_totalVenda(@codCliente INT)
	RETURNS INT AS
BEGIN
	DECLARE @totalVendas INT
	SET @totalVendas = (SELECT COUNT(codVenda) FROM tbVenda WHERE codCliente = @codCliente)
	RETURN @totalVendas
END

-- Exec. Rela��o Vendas-Cliente
SELECT dbo.fc_totalVenda(1)

select * from tbVenda




-- 3. Criar uma fun��o que receba o c�digo de um vendedor e o m�s e informe o total de vendas do vendedor no m�s informado
-- (N�o possu�mos um c�digo de vendedor, ent�o usamos o do fornecedor e uma alternativa sem inser��o de c�digo)
CREATE FUNCTION fc_totalFornecedor(@codFornecedor INT, @mes INT)
	RETURNS VARCHAR(50) AS
BEGIN
		Declare @qtdVendas INT
		SET @qtdVendas = (SELECT COUNT(distinct tbItensVenda.codVenda) FROM tbItensVenda
				INNER JOIN tbProduto ON
					tbItensVenda.codProduto = tbProduto.codProduto
				INNER JOIN tbVenda ON
					tbVenda.codVenda = tbItensVenda.codVenda
				WHERE codFornecedor = @codFornecedor 
				AND tbItensVenda.codProduto IN (SELECT codProduto FROM tbProduto WHERE codFornecedor = @codFornecedor) 
				AND month(tbVenda.dataVenda) = @mes
			GROUP BY codFornecedor)

		RETURN @qtdVendas
END

-- Apenas vendas do m�s, sem nenhum intermedi�rio
CREATE FUNCTION fc_totalVendas(@mes INT)
	RETURNS INT AS
BEGIN
		DECLARE @qtdVendas INT
		SET @qtdVendas = (SELECT COUNT(codVenda) FROM tbVenda WHERE month(tbVenda.dataVenda) = @mes)
		RETURN @qtdVendas
END

-- Exec. Rela��o Fornecedor-Vendas
SELECT 'Qtd. Vendas Mensais por Fornecedor'=dbo.fc_totalFornecedor(1,2)

-- Exec. Rela��o Vendas Mensais
SELECT 'Qtd. Vendas Mensais'=dbo.fc_totalVendas(2)




-- 4. Criar uma fun��o que usando o bdEstoque diga se o cpf do cliente � ou n�o v�lido
CREATE FUNCTION fc_validaCPF(@codCliente int)
	RETURNS VARCHAR(20) AS
BEGIN
	DECLARE @cpf VARCHAR(11)
	SET @cpf = (SELECT cpfCliente FROM tbCliente WHERE codCliente = @codCliente)

	DECLARE @soma int, @dig1 INT, @dig2 INT, @cpf_temp VARCHAR(11), @Resultado VARCHAR(20)
	SET @Resultado = 'N�o � v�lido'

	-- Base
	SET @cpf_temp = SUBSTRING(@cpf,1,1)

	-- Verifica��o d�gitos iguais
	DECLARE @indice INT, @digitosIguais char(1)
	SET @indice = 1
	SET @digitosIguais = 'S'

	WHILE (@indice <=11)
	BEGIN
		IF SUBSTRING(@cpf,@indice,1)<>@cpf_temp
			SET @digitosIguais ='N'
			SET @indice = @indice+1
	END;

	--Caso os d�gitos n�o sejam iguais, iniciar c�lculo
		IF @digitosIguais = 'N'
		BEGIN
		-- C�lculo 1 digito
			SET @soma = 0
			SET @indice = 1

				WHILE (@indice <=9)
				BEGIN
					SET @soma = @soma+CONVERT(INT,SUBSTRING(@cpf,@indice,1)) * (11-@indice)
					SET @indice = @indice+1
				END

				SET @dig1 = 11 - (@soma%11)

				IF @dig1 > 9
				BEGIN
					SET @dig1 = 0	
				END

		--C�lculo 2� d�gito
			SET @soma = 0
			SET @indice = 1

				WHILE (@indice <=10)
				BEGIN
					SET @soma = @soma+CONVERT(INT,SUBSTRING(@cpf,@indice,1)) * (12-@indice)
					SET @indice = @indice+1
				END

				SET @dig2 = 11 - (@soma%11)

				IF @dig2 > 9
				BEGIN
					SET @dig2 = 0	
				END

				IF (@dig1 = SUBSTRING(@cpf,len(@cpf)-1,1)) AND (@dig2 = SUBSTRING(@cpf,len(@cpf),1))
					SET @Resultado = '� v�lido'
				ELSE
					SET @Resultado = 'N�o � v�lido'
		END
			RETURN @Resultado
END

---- Exec. Validador de CPF
SELECT 'O CPF inserido:'=dbo.fc_validaCPF(2)

---Insert de cpf v�lido
INSERT INTO tbCliente
	VALUES('Ana M','16929206008','anamilano@gmail.com','f','20001224')

	SELECT max(codCliente) 'Cod - CPF V�lido' from tbCliente