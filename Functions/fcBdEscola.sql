
-- 1. Crie uma função que informada uma data da matrícula , retorne o dia da semana.
CREATE FUNCTION fc_diaSemana(@Data date)
	RETURNS VARCHAR(40) as

BEGIN
	DECLARE @diaSemana VARCHAR(40), @dia INT

	SET @dia = DATEPART(dw,@Data)

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
			set @diaSemana = 'Terça-feira'
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
			set @diaSemana = 'Sábado'
		END
		RETURN @diaSemana
END

-- Exec. dia da Matricula
SELECT codAluno, dataMatricula 'Data', 'Dia da Semana'=dbo.fc_diaSemana(dataMatricula) from tbMatricula





-- 2. Crie uma função que de acordo com a carga horária do curso exiba curso rápido ou curso extenso. (Rápido menos de 1000 horas).
CREATE FUNCTION fc_cargaClassifica(@cargaHorariaCurso INT) 
	RETURNS VARCHAR(20) AS
BEGIN
	DECLARE @CClassif VARCHAR(20)

	IF (@cargaHorariaCurso<1000)
		BEGIN
			SET @CClassif = 'Curso Rápido'
		END
	ELSE 
		BEGIN
			SET @CClassif = 'Curso Extenso'
		END

	RETURN @CClassif
END

-- Exec. Classificação do Carga-Curso
SELECT codCurso, CONVERT(VARCHAR(12), cargaHorariaCurso) 'Carga Horária', 'Classificação do curso'=dbo.fc_cargaClassifica(cargaHorariaCurso) from tbCurso





-- 3. Crie uma função que de acordo com o valor do curso exiba  curso caro ou curso barato. (Curso caro acima de 400).
CREATE FUNCTION fc_valorClassifica(@valorCurso money)
	RETURNS VARCHAR(20) AS
BEGIN
	DECLARE @VClassif VARCHAR(20)

	IF (@valorCurso<400)
		BEGIN
			SET @VClassif = 'Curso barato'
		END
	ELSE 
		BEGIN
			SET @VClassif = 'Curso caro'
		END

	RETURN @VClassif
END

-- Exec. Classificação Valor-Curso
SELECT codCurso, CONVERT(VARCHAR(12), valorCurso) 'Preço', 'Classificação do preço'=dbo.fc_valorClassifica(valorCurso) from tbCurso





-- 4. Criar uma função que informada a data da matrícula converta-a no formato dd/mm/aaaa.
CREATE FUNCTION fc_convertDataM(@dataMatricula date)
	RETURNS VARCHAR(10) AS
BEGIN
	DECLARE @dataConvertida VARCHAR(10)
	SET @dataConvertida = (SELECT CONVERT(VARCHAR(12),@dataMatricula,103))
	RETURN @dataConvertida
END

-- Exec. Conversor de data
SELECT codAluno, dataMatricula 'Data YYYY-MM-DD', 'Data DD/MM/YYYY'=dbo.fc_convertDataM(dataMatricula) from tbMatricula