USE [BD_OCEF_CtasPorCobrar]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_IU_GenerarObligacionesPosgrado_X_Ciclo]
@I_Anio INT,  
@I_Periodo INT,
@B_AlumnosSinObligaciones BIT,  
@C_CodEsc VARCHAR(2) = NULL,  
@C_CodAlu VARCHAR(20) = NULL,  
@C_CodRc VARCHAR(3) = NULL,
@B_Ingresante BIT = NULL,
@B_SoloAplicarExtemporaneo BIT = NULL,
@I_UsuarioCre INT,  
@B_Result BIT OUTPUT,  
@T_Message nvarchar(4000) OUTPUT  
AS  
/*  
DECLARE @B_Result BIT,  
	@T_Message nvarchar(4000);
  
EXEC USP_IU_GenerarObligacionesPosgrado_X_Ciclo  2021, 19, NULL, NULL,  NULL, 1,  
@B_Result OUTPUT,  
@T_Message OUTPUT;
  
SELECT @B_Result, @T_Message
GO
*/  
BEGIN  
	SET NOCOUNT ON;  

	SET @B_SoloAplicarExtemporaneo = CASE WHEN @B_SoloAplicarExtemporaneo IS NULL THEN 0 ELSE 1 END;

	DECLARE @N_GradoMaestria CHAR(1) = '2';
	DECLARE @N_Doctorado CHAR(1) = '3';
    
	--1ro Obtener los conceptos según ano y periodo  
	SELECT 
		p.I_ProcesoID, p.D_FecVencto, cp.T_CatPagoDesc, conpag.I_ConcPagID, con.T_ConceptoDesc, cp.I_TipoAlumno, conpag.M_Monto, conpag.M_MontoMinimo, conpag.I_TipoObligacion,  
		ISNULL(conpag.B_Calculado, 0) AS B_Calculado, conpag.I_Calculado, ISNULL(conpag.B_GrupoCodRc, 0) AS B_GrupoCodRc,  conpag.I_GrupoCodRc, conpag.B_ModalidadIngreso, moding.T_OpcionCod AS C_CodModIng,   
		ISNULL(conpag.B_EsPagoMatricula, 0) AS B_EsPagoMatricula, ISNULL(conpag.B_EsPagoExtmp, 0) AS B_EsPagoExtmp, conpag.N_NroPagos, cp.I_Prioridad, cp.I_Nivel, niv.T_OpcionCod as C_Nivel  
		INTO #tmp_conceptos_posgrado  
	FROM dbo.TC_Proceso p  
	INNER JOIN dbo.TC_CategoriaPago cp on cp.I_CatPagoID = p.I_CatPagoID  
	INNER JOIN dbo.TI_ConceptoPago conpag on conpag.I_ProcesoID = p.I_ProcesoID  
	INNER JOIN dbo.TC_Concepto con on con.I_ConceptoID = conpag.I_ConceptoID  
	LEFT JOIN dbo.TC_CatalogoOpcion moding on moding.I_ParametroID = 7 AND moding.I_OpcionID = conpag.I_ModalidadIngresoID  
	LEFT JOIN dbo.TC_CatalogoOpcion gr on gr.I_ParametroID = 6 AND gr.I_OpcionID = conpag.I_GrupoCodRc  
	LEFT JOIN dbo.TC_CatalogoOpcion niv on niv.I_ParametroID = 2 AND niv.I_OpcionID = cp.I_Nivel  
	WHERE p.B_Habilitado = 1 AND p.B_Eliminado = 0 AND  
		conpag.B_Habilitado = 1 AND conpag.B_Eliminado = 0  AND ISNULL(conpag.B_Mora, 0) = 0 AND  
		cp.B_Obligacion = 1 AND p.I_Anio = @I_Anio AND p.I_Periodo = @I_Periodo AND cp.I_Nivel in (SELECT I_OpcionID FROM dbo.TC_CatalogoOpcion WHERE I_ParametroID = 2 AND T_OpcionCod IN (@N_GradoMaestria, @N_Doctorado));
		--cp.B_Obligacion = 1 AND p.I_Anio = 2023 AND p.I_Periodo = 19 AND cp.I_Nivel in (SELECT I_OpcionID FROM dbo.TC_CatalogoOpcion WHERE I_ParametroID = 2 AND T_OpcionCod IN ('2', '3'));
  
	--2do Obtengo la relación de alumnos  
	CREATE TABLE #Tmp_MatriculaAlumno (
		id INT identity(1,1), 
		I_MatAluID INT, 
		C_CodRc VARCHAR(3), 
		C_CodAlu VARCHAR(20), 
		C_EstMat VARCHAR(2),   
		B_Ingresante BIT, 
		C_CodModIng VARCHAR(2), 
		N_Grupo CHAR(1), 
		I_CredDesaprob TINYINT, 
		N_Grado CHAR(1)
	);

	DECLARE	@SQLString NVARCHAR(4000),
			@ParmDefinition NVARCHAR(500);

	SET @SQLString = N'INSERT #Tmp_MatriculaAlumno(I_MatAluID, C_CodRc, C_CodAlu, C_EstMat, B_Ingresante, C_CodModIng, N_Grupo, I_CredDesaprob, N_Grado)
		SELECT m.I_MatAluID, m.C_CodRc, m.C_CodAlu, m.C_EstMat, m.B_Ingresante, a.C_CodModIng, a.N_Grupo, ISNULL(m.I_CredDesaprob, 0), a.N_Grado
		FROM dbo.TC_MatriculaAlumno m
		INNER JOIN BD_UNFV_Repositorio.dbo.VW_Alumnos a ON a.C_CodAlu = m.C_CodAlu AND a.C_RcCod = m.C_CodRc
		WHERE m.B_Habilitado = 1 AND m.B_Eliminado = 0 AND a.N_Grado in (@N_GradoMaestria, @N_Doctorado) AND
		m.I_Anio = @I_Anio AND m.I_Periodo = @I_Periodo ';

	IF (@C_CodAlu IS NOT NULL) AND (@C_CodRc IS NOT NULL) BEGIN
		SET @SQLString = @SQLString + N'AND m.C_CodAlu = @C_CodAlu AND m.C_CodRc = @C_CodRc ';
	END ELSE BEGIN
		IF NOT (@C_CodEsc IS NULL) AND NOT (@C_CodEsc = '') BEGIN
			SET @SQLString = @SQLString + N'AND a.C_CodEsc = @C_CodEsc ';
		END
	END

	IF (@B_Ingresante IS NOT NULL) BEGIN
		SET @SQLString = @SQLString + N'AND m.B_Ingresante = @B_Ingresante ';
	END

	IF (@B_AlumnosSinObligaciones = 1) BEGIN
		SET @SQLString = @SQLString + N'AND NOT EXISTS(SELECT c.I_ObligacionAluID FROM dbo.TR_ObligacionAluCab c WHERE c.B_Habilitado = 1 AND c.B_Eliminado = 0 AND c.I_MatAluID = m.I_MatAluID) ';
	END

	SET @ParmDefinition = N'@N_GradoMaestria CHAR(1), @N_Doctorado CHAR(1), @I_Anio INT, @I_Periodo INT, 
		@C_CodAlu VARCHAR(20), @C_CodRc VARCHAR(3), @C_CodEsc VARCHAR(2), @B_Ingresante BIT';
   
	EXECUTE SP_EXECUTESQL @SQLString, @ParmDefinition,  
		@N_GradoMaestria = @N_GradoMaestria,
		@N_Doctorado = @N_Doctorado,  
		@I_Anio = @I_Anio,  
		@I_Periodo = @I_Periodo,  
		@C_CodAlu = @C_CodAlu,  
		@C_CodRc = @C_CodRc,
		@C_CodEsc = @C_CodEsc,
		@B_Ingresante = @B_Ingresante;

	--3ro Comienzo con el calculo las obligaciones por alumno almacenandolas en @Tmp_Procesos.  
	DECLARE @Tmp_Procesos table (I_ProcesoID INT, I_ConcPagID INT, M_Monto decimal(15,2), D_FecVencto datetime, I_TipoObligacion INT, I_Prioridad TINYINT);
  
	DECLARE @C_Moneda VARCHAR(3) = 'PEN',  
		@D_CurrentDate datetime = getdate(),  
		@I_FilaActual INT = 1,  
		@I_CantRegistros INT = (SELECT max(id) FROM #Tmp_MatriculaAlumno),  
  
  
		--Tipo de alumno  
		@I_AlumnoRegular INT = (SELECT I_OpcionID FROM dbo.TC_CatalogoOpcion WHERE I_ParametroID = 1 AND T_OpcionCod = '1'),  
		@I_AlumnoIngresante INT = (SELECT I_OpcionID FROM dbo.TC_CatalogoOpcion WHERE I_ParametroID = 1 AND T_OpcionCod = '2'),  
  
  
		--Tipo obligación  
		@I_Matricula INT = (SELECT I_OpcionID FROM dbo.TC_CatalogoOpcion WHERE I_ParametroID = 3 AND T_OpcionCod = '1'),  
		@I_OtrosPagos INT = (SELECT I_OpcionID FROM dbo.TC_CatalogoOpcion WHERE I_ParametroID = 3 AND T_OpcionCod = '0'),  
  
  
		--Campo calculado  
		@I_CrdtDesaprobados INT = (SELECT I_OpcionID FROM dbo.TC_CatalogoOpcion WHERE I_ParametroID = 4 AND T_OpcionCod = '1'),  
		@I_DeudasAnteriores INT = (SELECT I_OpcionID FROM dbo.TC_CatalogoOpcion WHERE I_ParametroID = 4 AND T_OpcionCod = '2'),  
		@I_Pensiones INT = (SELECT I_OpcionID FROM dbo.TC_CatalogoOpcion WHERE I_ParametroID = 4 AND T_OpcionCod = '3'),  
  
		--Otras variables  
		@I_ObligacionAluID INT,  
		@I_MatAluID INT,  
		@C_EstMat VARCHAR(2),  
		@C_CodModIng VARCHAR(2),  
		@N_Grupo CHAR(1),  
		@I_TipoAlumno INT,  
		@I_MontoDeuda decimal(15,2),  
		@I_CredDesaprob TINYINT,  
		@N_NroPagos TINYINT,  
		@N_Grado CHAR(1),  
  
		--Variables para comprobar modificaciones  
		@I_MontoInicial decimal(15,2),  
		@I_MontoActual decimal(15,2),  
		@D_FecVenctoInicial datetime,  
		@D_FecVenctoActual datetime,  
		@I_ProcesoID INT, 
		@B_MatriculaPagada BIT,
		@B_Pagado BIT;

	DECLARE @Tmp_grupo_otros_pagos table (id INT, I_ProcesoID INT);
	
	DECLARE @I_FilaActual_OtrsPag INT,  
		@I_CantRegistros_OtrsPag INT,  
		@I_ProcesoID_OtrsPag INT;
  
	WHILE (@I_FilaActual <= @I_CantRegistros) BEGIN  
		BEGIN TRAN  
		BEGIN TRY  
			--4to obtengo la información alumno por alumno e inicializo variables  
			SELECT @I_MatAluID= I_MatAluID, @C_CodRc = C_CodRc, @C_CodAlu = C_CodAlu, @C_EstMat = C_EstMat, @C_CodModIng = C_CodModIng,   
				@N_Grupo = N_Grupo, @I_CredDesaprob = ISNULL(I_CredDesaprob, 0), @N_Grado = N_Grado,  
				@I_TipoAlumno = (case when B_Ingresante = 0 then @I_AlumnoRegular ELSE @I_AlumnoIngresante END)   
			FROM #Tmp_MatriculaAlumno   
			WHERE id = @I_FilaActual  
  
			DELETE @Tmp_Procesos  
			
			IF (@B_SoloAplicarExtemporaneo = 0)
			BEGIN
				--Pagos de Matrícula  
				IF (SELECT count(I_ProcesoID) FROM #tmp_conceptos_posgrado  
				WHERE I_TipoAlumno = @I_TipoAlumno AND I_TipoObligacion = @I_Matricula AND   
				B_EsPagoMatricula = 1 AND C_CodModIng = @C_CodModIng AND C_Nivel = @N_Grado) = 1  
				BEGIN  
					INSERT @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
					SELECT I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad FROM #tmp_conceptos_posgrado  
					WHERE I_TipoAlumno = @I_TipoAlumno AND I_TipoObligacion = @I_Matricula AND   
						B_EsPagoMatricula = 1 AND C_CodModIng = @C_CodModIng AND C_Nivel = @N_Grado  
				END  
				ELSE  
				BEGIN  
					IF (SELECT count(I_ProcesoID) FROM #tmp_conceptos_posgrado  
						WHERE I_TipoAlumno = @I_TipoAlumno AND I_TipoObligacion = @I_Matricula AND   
						B_EsPagoMatricula = 1 AND C_Nivel = @N_Grado AND C_CodModIng is NULL) = 1  
					BEGIN  
						INSERT @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
						SELECT I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad FROM #tmp_conceptos_posgrado  
						WHERE I_TipoAlumno = @I_TipoAlumno AND I_TipoObligacion = @I_Matricula AND   
						B_EsPagoMatricula = 1 AND C_Nivel = @N_Grado AND C_CodModIng is NULL  
					END   
				END  
  
				--Pagos generales de matrícula  
				INSERT @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
				SELECT I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad FROM #tmp_conceptos_posgrado  
				WHERE I_TipoAlumno = @I_TipoAlumno AND I_TipoObligacion = @I_Matricula AND  
					B_EsPagoMatricula = 0 AND B_Calculado = 0 AND B_GrupoCodRc = 0 AND B_EsPagoExtmp = 0 AND C_Nivel = @N_Grado  
  
				--Pagos extemoráneos  
				IF (SELECT count(I_ProcesoID) FROM #tmp_conceptos_posgrado  
				WHERE I_TipoAlumno = @I_TipoAlumno AND I_TipoObligacion = @I_Matricula AND   
					B_EsPagoMatricula = 0 AND B_EsPagoExtmp = 1 AND C_Nivel = @N_Grado AND  
					datediff(day, @D_CurrentDate, D_FecVencto) < 0) = 1  
				BEGIN  
					INSERT @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
					SELECT I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad FROM #tmp_conceptos_posgrado  
					WHERE I_TipoAlumno = @I_TipoAlumno AND I_TipoObligacion = @I_Matricula AND   
						B_EsPagoMatricula = 0 AND B_EsPagoExtmp = 1 AND C_Nivel = @N_Grado AND  
						datediff(day, @D_CurrentDate, D_FecVencto) < 0  
				END
     
				--Monto de Pensión de ensenanza  
				IF (SELECT count(I_ProcesoID) FROM #tmp_conceptos_posgrado  
				WHERE I_TipoAlumno = @I_TipoAlumno AND B_Calculado = 1 AND I_Calculado = @I_Pensiones AND C_Nivel = @N_Grado) = 1  
				BEGIN  
					SET @N_NroPagos = isnull((SELECT top 1 N_NroPagos FROM #tmp_conceptos_posgrado   
						WHERE I_TipoAlumno = @I_TipoAlumno AND B_Calculado = 1 AND I_Calculado = @I_Pensiones AND C_Nivel = @N_Grado), 1);  
      
					with CTE_Recursivo as  
					(  
						SELECT 1 as num, I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad FROM #tmp_conceptos_posgrado  
						WHERE I_TipoAlumno = @I_TipoAlumno AND B_Calculado = 1 AND I_Calculado = @I_Pensiones AND C_Nivel = @N_Grado  
						union all  
						SELECT num + 1, I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad  
						FROM CTE_Recursivo  
						WHERE num < @N_NroPagos  
					)  
					INSERT @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
					SELECT I_ProcesoID, I_ConcPagID, cast(M_Monto / @N_NroPagos as decimal(15,2)) as M_Monto,   
						DATEADD(MONTH, num-1, D_FecVencto), I_TipoObligacion, I_Prioridad  
					FROM CTE_Recursivo  
				END 
			END
			ELSE
			BEGIN
				--Pagos extemoráneos
				IF (SELECT count(I_ProcesoID) FROM #tmp_conceptos_posgrado  
				WHERE I_TipoAlumno = @I_TipoAlumno AND I_TipoObligacion = @I_Matricula AND   
					B_EsPagoMatricula = 0 AND B_EsPagoExtmp = 1 AND C_Nivel = @N_Grado AND  
					datediff(day, @D_CurrentDate, D_FecVencto) < 0) = 1  
				BEGIN  
					INSERT @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
					SELECT I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad FROM #tmp_conceptos_posgrado  
					WHERE I_TipoAlumno = @I_TipoAlumno AND I_TipoObligacion = @I_Matricula AND   
						B_EsPagoMatricula = 0 AND B_EsPagoExtmp = 1 AND C_Nivel = @N_Grado AND  
						datediff(day, @D_CurrentDate, D_FecVencto) < 0
				END
			END
  
			--Grabando pago de matrícula  
			SET @I_ProcesoID = 0
			SET @B_MatriculaPagada = 0

			IF (@B_SoloAplicarExtemporaneo = 0)
			BEGIN
				IF EXISTS(SELECT p.I_ProcesoID FROM @Tmp_Procesos p WHERE p.I_Prioridad = 1)  
				BEGIN  
					SET @I_ProcesoID = (SELECT distinct p.I_ProcesoID FROM @Tmp_Procesos p WHERE p.I_Prioridad = 1);
  
					IF EXISTS(SELECT cab.I_ObligacionAluID FROM dbo.TR_ObligacionAluCab cab   
						WHERE cab.B_Eliminado = 0 AND I_MatAluID = @I_MatAluID AND I_ProcesoID = @I_ProcesoID)  
					BEGIN  
						SELECT @I_MontoInicial = cab.I_MontoOblig, @D_FecVenctoInicial = cab.D_FecVencto, @B_Pagado = cab.B_Pagado FROM dbo.TR_ObligacionAluCab cab   
						WHERE cab.B_Eliminado = 0 AND I_MatAluID = @I_MatAluID AND I_ProcesoID = @I_ProcesoID  
  
						SELECT @D_FecVenctoActual = p.D_FecVencto, @I_MontoActual = Sum(p.M_Monto) FROM @Tmp_Procesos p   
						WHERE p.I_Prioridad = 1 group by p.D_FecVencto  
  
						IF (@B_Pagado = 0)
						BEGIN  
							IF Not (DATEDIFF(Day, @D_FecVenctoInicial, @D_FecVenctoActual) = 0) Or Not (@I_MontoInicial = @I_MontoActual)  
							BEGIN  
								UPDATE d SET d.B_Habilitado = 0, d.B_Eliminado = 1, d.I_UsuarioMod = @I_UsuarioCre, d.D_FecMod = @D_CurrentDate  
								FROM dbo.TR_ObligacionAluCab c  
								INNER JOIN dbo.TR_ObligacionAluDet d on d.I_ObligacionAluID = c.I_ObligacionAluID  
								WHERE d.B_Eliminado = 0 AND c.B_Eliminado = 0 AND c.I_MatAluID = @I_MatAluID AND c.I_ProcesoID = @I_ProcesoID  
  
								UPDATE dbo.TR_ObligacionAluCab SET B_Habilitado = 0, B_Eliminado = 1, I_UsuarioMod = @I_UsuarioCre, D_FecMod = @D_CurrentDate  
								WHERE B_Eliminado = 0 AND I_MatAluID = @I_MatAluID AND I_ProcesoID = @I_ProcesoID  
  
								INSERT dbo.TR_ObligacionAluCab(I_ProcesoID, I_MatAluID, C_Moneda, I_MontoOblig, B_Pagado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, D_FecVencto)  
								SELECT p.I_ProcesoID, @I_MatAluID, @C_Moneda, Sum(p.M_Monto), 0, 1, 0, @I_UsuarioCre, @D_CurrentDate, p.D_FecVencto FROM @Tmp_Procesos p  
								WHERE p.I_Prioridad = 1   
								group by p.I_ProcesoID, p.D_FecVencto  
  
								SET @I_ObligacionAluID = SCOPE_IDENTITY()  
  
								INSERT dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)  
								SELECT @I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, p.D_FecVencto, 1, 0, @I_UsuarioCre, @D_CurrentDate FROM @Tmp_Procesos p  
								WHERE p.I_Prioridad = 1  
							END  
						END
						ELSE
						BEGIN
							SET @B_MatriculaPagada = 1
						END
					END  
					ELSE  
					BEGIN  
						--INSERT  
						INSERT dbo.TR_ObligacionAluCab(I_ProcesoID, I_MatAluID, C_Moneda, I_MontoOblig, B_Pagado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, D_FecVencto)  
						SELECT p.I_ProcesoID, @I_MatAluID, @C_Moneda, Sum(p.M_Monto), 0, 1, 0, @I_UsuarioCre, @D_CurrentDate, p.D_FecVencto FROM @Tmp_Procesos p  
						WHERE p.I_Prioridad = 1   
						group by p.I_ProcesoID, p.D_FecVencto  
  
						SET @I_ObligacionAluID = SCOPE_IDENTITY()  
  
						INSERT dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, B_Mora)  
						SELECT @I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, p.D_FecVencto, 1, 0, @I_UsuarioCre, @D_CurrentDate, 0 FROM @Tmp_Procesos p  
						WHERE p.I_Prioridad = 1  
					END  
				END  
			
				IF (@B_MatriculaPagada = 0) BEGIN			
					--Grabando otros pagos  
					IF EXISTS(SELECT p.I_ProcesoID FROM @Tmp_Procesos p WHERE p.I_Prioridad = 2)  
					BEGIN  
						IF NOT EXISTS(SELECT cab.I_ObligacionAluID FROM dbo.TR_ObligacionAluCab cab  
							WHERE cab.B_Eliminado = 0 AND cab.I_MatAluID = @I_MatAluID AND  
							cab.I_ProcesoID in (SELECT p.I_ProcesoID FROM @Tmp_Procesos p WHERE p.I_Prioridad = 2))  
						BEGIN  
							--Nuevos registros de obligaciones  
  
							--Insert de cabecera  
							INSERT dbo.TR_ObligacionAluCab(I_ProcesoID, I_MatAluID, C_Moneda, I_MontoOblig, B_Pagado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, D_FecVencto)  
							SELECT p.I_ProcesoID, @I_MatAluID, @C_Moneda, Sum(p.M_Monto), 0, 1, 0, @I_UsuarioCre, @D_CurrentDate, p.D_FecVencto FROM @Tmp_Procesos p  
							WHERE p.I_Prioridad = 2  
							group by p.I_ProcesoID, p.D_FecVencto  
  
							--Insert de detalle  
							INSERT dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, B_Mora)  
							SELECT cab.I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, p.D_FecVencto, 1, 0, @I_UsuarioCre, @D_CurrentDate, 0 FROM @Tmp_Procesos p  
							INNER JOIN dbo.TR_ObligacionAluCab cab on cab.B_Habilitado = 1 AND cab.B_Eliminado = 0 AND p.I_ProcesoID = cab.I_ProcesoID AND cab.I_MatAluID = @I_MatAluID AND  
							DATEDIFF(Day, p.D_FecVencto, cab.D_FecVencto) = 0  
							WHERE p.I_Prioridad = 2  
						END  
						ELSE  
						BEGIN  
							--Edición de obligaciones  
  
							IF EXISTS(SELECT id FROM @Tmp_grupo_otros_pagos) BEGIN  
								DELETE @Tmp_grupo_otros_pagos  
							END  
  
							INSERT @Tmp_grupo_otros_pagos(id, I_ProcesoID)  
							SELECT ROW_NUMBER() OVER (ORDER BY I_ProcesoID), I_ProcesoID FROM @Tmp_Procesos p  
							WHERE p.I_Prioridad = 2  
							group by p.I_ProcesoID  
       
							SET @I_FilaActual_OtrsPag = 1  
							SET @I_CantRegistros_OtrsPag = (SELECT max(id) FROM @Tmp_grupo_otros_pagos)  
  
							WHILE (@I_FilaActual_OtrsPag <= @I_CantRegistros_OtrsPag) BEGIN  
								--Los otros pagos se agrupan primero por proceso y luego por fecha de vcto.  
								SET @I_ProcesoID_OtrsPag = (SELECT I_ProcesoID FROM @Tmp_grupo_otros_pagos WHERE id = @I_FilaActual_OtrsPag)  
  
								IF EXISTS(SELECT cab.I_ObligacionAluID FROM dbo.TR_ObligacionAluCab cab  
								INNER JOIN dbo.TR_ObligacionAluDet det on det.I_ObligacionAluID = cab.I_ObligacionAluID  
								WHERE cab.B_Eliminado = 0 AND det.B_Eliminado = 0 AND cab.I_MatAluID = @I_MatAluID AND   
								cab.I_ProcesoID = @I_ProcesoID_OtrsPag AND cab.B_Pagado = 1) BEGIN  
         
									PRINT 'Existen al menos un pago realizado.'  
  
								END  
								ELSE BEGIN  
									UPDATE d SET d.B_Habilitado = 0, d.B_Eliminado = 1, d.I_UsuarioMod = @I_UsuarioCre, d.D_FecMod = @D_CurrentDate  
									FROM dbo.TR_ObligacionAluCab c  
									INNER JOIN dbo.TR_ObligacionAluDet d on d.I_ObligacionAluID = c.I_ObligacionAluID  
									WHERE d.B_Eliminado = 0 AND c.B_Eliminado = 0 AND c.I_MatAluID = @I_MatAluID AND c.I_ProcesoID = @I_ProcesoID_OtrsPag  
  
									UPDATE dbo.TR_ObligacionAluCab SET B_Habilitado = 0, B_Eliminado = 1, I_UsuarioMod = @I_UsuarioCre, D_FecMod = @D_CurrentDate  
									WHERE B_Eliminado = 0 AND I_MatAluID = @I_MatAluID AND I_ProcesoID = @I_ProcesoID_OtrsPag  
  
									INSERT dbo.TR_ObligacionAluCab(I_ProcesoID, I_MatAluID, C_Moneda, I_MontoOblig, B_Pagado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, D_FecVencto)  
									SELECT p.I_ProcesoID, @I_MatAluID, @C_Moneda, Sum(p.M_Monto), 0, 1, 0, @I_UsuarioCre, @D_CurrentDate, p.D_FecVencto FROM @Tmp_Procesos p  
									WHERE p.I_Prioridad = 2 AND p.I_ProcesoID = @I_ProcesoID_OtrsPag  
									group by p.I_ProcesoID, p.D_FecVencto  
  
									INSERT dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, B_Mora)  
									SELECT cab.I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, p.D_FecVencto, 1, 0, @I_UsuarioCre, @D_CurrentDate, 0 FROM @Tmp_Procesos p  
									INNER JOIN dbo.TR_ObligacionAluCab cab on cab.B_Habilitado = 1 AND cab.B_Eliminado = 0 AND p.I_ProcesoID = cab.I_ProcesoID  AND cab.I_MatAluID = @I_MatAluID AND  
									DATEDIFF(Day, p.D_FecVencto, cab.D_FecVencto) = 0  
									WHERE p.I_Prioridad = 2 AND p.I_ProcesoID = @I_ProcesoID_OtrsPag  
								END  
  
								SET @I_FilaActual_OtrsPag = (@I_FilaActual_OtrsPag + 1)  
							END  
						END  
					END  
				END
			END
			ELSE
			BEGIN
				--Sólo se agregará el pago extemporáneo
				IF ((SELECT COUNT(*) FROM @Tmp_Procesos) = 1) BEGIN	
					
					SET @I_ProcesoID = (SELECT p.I_ProcesoID FROM @Tmp_Procesos p WHERE p.I_Prioridad = 1);

					IF ((SELECT COUNT(cab.I_ObligacionAluID) FROM dbo.TR_ObligacionAluCab cab   
						WHERE cab.B_Habilitado = 1 AND cab.B_Eliminado = 0 AND cab.I_MatAluID = @I_MatAluID AND cab.I_ProcesoID = @I_ProcesoID) = 1) BEGIN

						SELECT @I_ObligacionAluID = cab.I_ObligacionAluID, @D_FecVenctoInicial = cab.D_FecVencto, @B_Pagado = cab.B_Pagado FROM dbo.TR_ObligacionAluCab cab
						WHERE cab.B_Habilitado = 1 AND cab.B_Eliminado = 0 AND cab.I_MatAluID = @I_MatAluID AND cab.I_ProcesoID = @I_ProcesoID

						IF (@B_Pagado = 0) BEGIN
							INSERT dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
							SELECT @I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, @D_FecVenctoInicial, 1, 0, @I_UsuarioCre, @D_CurrentDate FROM @Tmp_Procesos p
							
							UPDATE dbo.TR_ObligacionAluCab SET I_MontoOblig = (I_MontoOblig + (SELECT SUM(p.M_Monto) FROM @Tmp_Procesos p))
							WHERE I_ObligacionAluID = @I_ObligacionAluID
						END
					END
				END
			END

			COMMIT TRAN

		END TRY  
		BEGIN CATCH  
			ROLLBACK TRAN  
			
			PRINT ERROR_MESSAGE()  
			PRINT ERROR_LINE()  
		END CATCH 
  
		SET @I_FilaActual = (@I_FilaActual +1)  
	END  
  
	SET @B_Result = 1;
	SET @T_Message = 'El proceso finalizó correctamente.';
END
GO



SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[USP_IU_GenerarObligacionesPregrado_X_Ciclo]
@I_Anio int,
@I_Periodo int,
@B_AlumnosSinObligaciones BIT,
@C_CodFac varchar(2) = null,
@C_CodAlu varchar(20) = null,
@C_CodRc varchar(3) = null,
@B_Ingresante BIT = NULL,
@B_SoloAplicarExtemporaneo BIT = NULL,
@I_UsuarioCre int,  
@B_Result bit OUTPUT,  
@T_Message nvarchar(4000) OUTPUT  
AS  
BEGIN  
 SET NOCOUNT ON;  
  SET @B_SoloAplicarExtemporaneo = CASE WHEN @B_SoloAplicarExtemporaneo IS NULL THEN 0 ELSE 1 END;
 --1ro Obtener los conceptos según año y periodo  
 declare @N_GradoBachiller char(1) = '1'  
  
 select p.I_ProcesoID, p.D_FecVencto, cp.T_CatPagoDesc, conpag.I_ConcPagID, con.T_ConceptoDesc, cp.I_TipoAlumno, conpag.M_Monto, conpag.M_MontoMinimo, conpag.I_TipoObligacion,  
 ISNULL(conpag.B_Calculado, 0) AS B_Calculado, conpag.I_Calculado, ISNULL(conpag.B_GrupoCodRc, 0) AS B_GrupoCodRc, gr.T_OpcionCod AS I_GrupoCodRc, conpag.B_ModalidadIngreso, moding.T_OpcionCod AS C_CodModIng,   
 ISNULL(conpag.B_EsPagoMatricula, 0) AS B_EsPagoMatricula, ISNULL(con.B_EsPagoExtmp, 0) AS B_EsPagoExtmp, conpag.N_NroPagos, cp.I_Prioridad  
 into #tmp_conceptos_pregrado  
 from dbo.TC_Proceso p  
 inner join dbo.TC_CategoriaPago cp on cp.I_CatPagoID = p.I_CatPagoID  
 inner join dbo.TI_ConceptoPago conpag on conpag.I_ProcesoID = p.I_ProcesoID  
 inner join dbo.TC_Concepto con on con.I_ConceptoID = conpag.I_ConceptoID  
 left join dbo.TC_CatalogoOpcion moding on moding.I_ParametroID = 7 and moding.I_OpcionID = conpag.I_ModalidadIngresoID  
 left join dbo.TC_CatalogoOpcion gr on gr.I_ParametroID = 6 and gr.I_OpcionID = conpag.I_GrupoCodRc  
 where p.B_Habilitado = 1 and p.B_Eliminado = 0 and  
  conpag.B_Habilitado = 1 and conpag.B_Eliminado = 0 and ISNULL(conpag.B_Mora, 0) = 0 and  
  cp.B_Obligacion = 1 and p.I_Anio = @I_Anio and p.I_Periodo = @I_Periodo and cp.I_Nivel = (select I_OpcionID from dbo.TC_CatalogoOpcion where I_ParametroID = 2 and T_OpcionCod = @N_GradoBachiller)  
  
 --2do Obtengo la relación de alumnos  
	CREATE TABLE #Tmp_MatriculaAlumno (
		id int identity(1,1), 
		I_MatAluID int, 
		C_CodRc varchar(3), 
		C_CodAlu varchar(20), 
		C_EstMat varchar(2), 
		B_Ingresante bit, 
		C_CodModIng varchar(2), 
		N_Grupo char(1), 
		I_CredDesaprob tinyint
	)
         
	DECLARE	@SQLString NVARCHAR(4000),
			@ParmDefinition NVARCHAR(500)

	SET @SQLString = N'insert #Tmp_MatriculaAlumno(I_MatAluID, C_CodRc, C_CodAlu, C_EstMat, B_Ingresante, C_CodModIng, N_Grupo, I_CredDesaprob)
	select m.I_MatAluID, m.C_CodRc, m.C_CodAlu, m.C_EstMat, m.B_Ingresante, a.C_CodModIng, a.N_Grupo, ISNULL(m.I_CredDesaprob, 0)
	from dbo.TC_MatriculaAlumno m
	inner join BD_UNFV_Repositorio.dbo.VW_Alumnos a ON a.C_CodAlu = m.C_CodAlu and a.C_RcCod = m.C_CodRc
	where m.B_Habilitado = 1 and m.B_Eliminado = 0 and
	a.N_Grado = @N_GradoBachiller and m.I_Anio = @I_Anio and m.I_Periodo = @I_Periodo ';

	IF (@C_CodAlu is not null) and (@C_CodRc is not null) BEGIN
		SET @SQLString = @SQLString + N'AND m.C_CodAlu = @C_CodAlu and m.C_CodRc = @C_CodRc '
	END ELSE BEGIN
		IF NOT(@C_CodFac is null) AND NOT(@C_CodFac = '') BEGIN
			SET @SQLString = @SQLString + N'AND a.C_CodFac = @C_CodFac '
		END
	END

	IF (@B_Ingresante IS NOT NULL) BEGIN
		SET @SQLString = @SQLString + N'AND m.B_Ingresante = @B_Ingresante '
	END

	IF (@B_AlumnosSinObligaciones = 1) BEGIN
		SET @SQLString = @SQLString + N'AND NOT EXISTS(SELECT c.I_ObligacionAluID FROM dbo.TR_ObligacionAluCab c WHERE c.B_Habilitado = 1 AND c.B_Eliminado = 0 AND c.I_MatAluID = m.I_MatAluID) '
	END

	SET @ParmDefinition = N'@N_GradoBachiller CHAR(1), @I_Anio INT, @I_Periodo INT, @C_CodAlu VARCHAR(20), 
		@C_CodRc VARCHAR(3), @C_CodFac VARCHAR(2), @B_Ingresante BIT'
  
	EXECUTE sp_executesql @SQLString, @ParmDefinition,  
		@N_GradoBachiller = @N_GradoBachiller,  
		@I_Anio = @I_Anio,  
		@I_Periodo = @I_Periodo,  
		@C_CodAlu = @C_CodAlu,  
		@C_CodRc = @C_CodRc,
		@C_CodFac = @C_CodFac,
		@B_Ingresante = @B_Ingresante

 --3ro Comienzo con el calculo las obligaciones por alumno almacenandolas en @Tmp_Procesos.  
 declare @Tmp_Procesos table (I_ProcesoID int, I_ConcPagID int, M_Monto decimal(15,2), D_FecVencto datetime, I_TipoObligacion int, I_Prioridad tinyint)  
  
 declare @C_Moneda varchar(3) = 'PEN',  
   @D_CurrentDate datetime = getdate(),  
   @I_FilaActual int = 1,  
   @I_CantRegistros int = (select max(id) from #Tmp_MatriculaAlumno),  
     
   --Tipo de alumno  
   @I_AlumnoRegular int = (select I_OpcionID from dbo.TC_CatalogoOpcion where I_ParametroID = 1 and T_OpcionCod = '1'),  
   @I_AlumnoIngresante int = (select I_OpcionID from dbo.TC_CatalogoOpcion where I_ParametroID = 1 and T_OpcionCod = '2'),  
     
   --Tipo obligación  
   @I_Matricula int = (select I_OpcionID from dbo.TC_CatalogoOpcion where I_ParametroID = 3 and T_OpcionCod = '1'),  
   @I_OtrosPagos int = (select I_OpcionID from dbo.TC_CatalogoOpcion where I_ParametroID = 3 and T_OpcionCod = '0'),  
  
   --Campo calculado  
   @I_CrdtDesaprobados int = (select I_OpcionID from dbo.TC_CatalogoOpcion where I_ParametroID = 4 and T_OpcionCod = '1'),  
   @I_DeudasAnteriores int = (select I_OpcionID from dbo.TC_CatalogoOpcion where I_ParametroID = 4 and T_OpcionCod = '2'),  
   @I_Pensiones int = (select I_OpcionID from dbo.TC_CatalogoOpcion where I_ParametroID = 4 and T_OpcionCod = '3'),  
   @I_MultaNoVotar int = (select I_OpcionID from dbo.TC_CatalogoOpcion WHERE I_ParametroID = 4 and T_OpcionCod = '4'),  
     
   --Otras variables  
   @I_ObligacionAluID int,  
   @I_MatAluID int,  
   @C_EstMat varchar(2),  
   @C_CodModIng varchar(2),  
   @N_Grupo char(1),  
   @I_TipoAlumno int,  
   @I_MontoDeuda decimal(15,2),  
   @I_CredDesaprob tinyint,  
   @I_MultiplicMontoCredt int,  
   @N_NroPagos tinyint,  
  
   --Variables para comprobar modificaciones  
   @I_MontoInicial decimal(15,2),  
   @I_MontoActual decimal(15,2),  
   @D_FecVenctoInicial datetime,  
   @D_FecVenctoActual datetime,  
   @I_ProcesoID int,  
   @B_Pagado bit  
  
 declare @Tmp_grupo_otros_pagos table (id int, I_ProcesoID int)  
 declare @I_FilaActual_OtrsPag int,  
   @I_CantRegistros_OtrsPag int,  
   @I_ProcesoID_OtrsPag int  
  
 while (@I_FilaActual <= @I_CantRegistros) begin  
  begin tran  
  begin try  
     
   --4to obtengo la información alumno por alumno e inicializo variables  
   select @I_MatAluID = I_MatAluID, @C_CodRc = C_CodRc, @C_CodAlu = C_CodAlu, @C_EstMat = C_EstMat, @C_CodModIng = C_CodModIng,   
    @N_Grupo = N_Grupo, @I_TipoAlumno = (case when B_Ingresante = 0 then @I_AlumnoRegular else @I_AlumnoIngresante end)   
   from #Tmp_MatriculaAlumno   
   where id = @I_FilaActual  
  
   delete @Tmp_Procesos  

   IF (@B_SoloAplicarExtemporaneo = 0)
   BEGIN
  
	   --Pagos de Matrícula  
	   if (select count(I_ProcesoID) from #tmp_conceptos_pregrado  
		where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		B_EsPagoMatricula = 1 and C_CodModIng = @C_CodModIng) = 1  
	   begin  
		insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
		select I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
		where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		 B_EsPagoMatricula = 1 and C_CodModIng = @C_CodModIng  
	   end  
	   else  
	   begin  
		if (select count(I_ProcesoID) from #tmp_conceptos_pregrado  
		 where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		 B_EsPagoMatricula = 1 and C_CodModIng is null) = 1  
		begin  
		 insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
		 select I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
		 where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		  B_EsPagoMatricula = 1 and C_CodModIng is null  
		end   
	   end  
  
	   --Pagos generales de matrícula  
	   insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
	   select I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
	   where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and  
		B_EsPagoMatricula = 0 and B_Calculado = 0 and B_GrupoCodRc = 0 and B_EsPagoExtmp = 0  
  
	   --Pagos de laboratorio  
	   if (select count(I_ProcesoID) from #tmp_conceptos_pregrado  
		where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		B_EsPagoMatricula = 0 and B_GrupoCodRc = 1 and I_GrupoCodRc = @N_Grupo) = 1  
	   begin  
		insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
		select I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
		where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		 B_EsPagoMatricula = 0 and B_GrupoCodRc = 1 and I_GrupoCodRc = @N_Grupo  
	   end  
  
	   --Multa por no votar  
	   if (@I_TipoAlumno = @I_AlumnoRegular) and (select count(I_ProcesoID) from #tmp_conceptos_pregrado   
		where I_TipoAlumno = @I_AlumnoRegular and I_TipoObligacion = @I_Matricula and  
		 B_EsPagoMatricula = 0 and B_Calculado = 1 and I_Calculado = @I_MultaNoVotar) = 1  
	   begin  
		if exists(select * from dbo.TC_AlumnoMultaNoVotar nv   
		 where nv.B_Eliminado = 0 and nv.C_CodAlu = @C_CodAlu and nv.C_CodRc = @C_CodRc and nv.I_Anio = @I_Anio and nv.I_Periodo = @I_Periodo)  
		begin  
		 insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
		 select I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
		 where I_TipoAlumno = @I_AlumnoRegular and I_TipoObligacion = @I_Matricula and  
		  B_EsPagoMatricula = 0 and B_Calculado = 1 and I_Calculado = @I_MultaNoVotar  
		end  
	   end  
  
	   --Pagos extemoráneos  
	   if (select count(I_ProcesoID) from #tmp_conceptos_pregrado  
		where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		 B_EsPagoMatricula = 0 and B_EsPagoExtmp = 1 and  
		 datediff(day, @D_CurrentDate, D_FecVencto) < 0) = 1  
	   begin  
		insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
		select I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
		where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		 B_EsPagoMatricula = 0 and B_EsPagoExtmp = 1 and  
		 datediff(day, @D_CurrentDate, D_FecVencto) < 0  
	   end  
  
	   --Monto de deuda anterior  
	   if (select count(I_ProcesoID) from #tmp_conceptos_pregrado   
		where I_TipoAlumno = @I_TipoAlumno and B_Calculado = 1 and I_Calculado = @I_DeudasAnteriores) = 1  
	   begin  
		set @I_MontoDeuda = isnull((select SUM(cab.I_MontoOblig) from dbo.TR_ObligacionAluCab cab  
		 inner join (select top 1 m.I_MatAluID from dbo.TC_MatriculaAlumno m   
		  where m.B_Eliminado = 0 and not m.I_MatAluID = @I_MatAluID and m.C_CodAlu = @C_CodAlu and m.C_CodRc = @C_CodRc  
		  order by m.I_Anio desc, m.C_Ciclo desc) mat on mat.I_MatAluID = cab.I_MatAluID  
		 where cab.B_Eliminado = 0 and cab.B_Pagado = 0), 0)  
  
		if (@I_MontoDeuda > 0)  
		begin  
		 set @N_NroPagos = isnull((select top 1 N_NroPagos from #tmp_conceptos_pregrado   
		  where I_TipoAlumno = @I_TipoAlumno and B_Calculado = 1 and I_Calculado = @I_DeudasAnteriores), 1);  
  
		 with CTE_Recursivo as  
		 (  
		  select 1 as num, I_ProcesoID, I_ConcPagID, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
		  where I_TipoAlumno = @I_TipoAlumno and B_Calculado = 1 and I_Calculado = @I_DeudasAnteriores  
		  union all  
		  select num + 1, I_ProcesoID, I_ConcPagID, D_FecVencto, I_TipoObligacion, I_Prioridad  
		  from CTE_Recursivo  
		  where num < @N_NroPagos  
		 )  
		 insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
		 select I_ProcesoID, I_ConcPagID, dbo.FN_CalcularCuotasDeuda(@I_MontoDeuda, @N_NroPagos, num) AS M_Monto,   
		  DATEADD(MONTH, num-1, D_FecVencto), I_TipoObligacion, I_Prioridad  
		 from CTE_Recursivo;  
		end  
	   end  
     
	   --Monto de cursos desaprobados  
	   if (select count(I_ProcesoID) from #tmp_conceptos_pregrado  
		 where I_TipoAlumno = @I_TipoAlumno and B_Calculado = 1 and I_Calculado = @I_CrdtDesaprobados) = 1  
	   begin  
		SET @I_CredDesaprob = (SELECT SUM(c.I_CredDesaprob) FROM dbo.TC_MatriculaCurso c WHERE c.I_MatAluID = @I_MatAluID AND c.B_Habilitado = 1 AND c.B_Eliminado = 0)  
  
		if (@I_CredDesaprob > 0)  
		begin  
		 set @N_NroPagos = isnull((select top 1 N_NroPagos from #tmp_conceptos_pregrado   
		  where I_TipoAlumno = @I_TipoAlumno and B_Calculado = 1 and I_Calculado = @I_CrdtDesaprobados), 1);  
  
		 set @I_MultiplicMontoCredt = (SELECT SUM(c.I_CredDesaprob * (c.I_Vez - 1)) FROM dbo.TC_MatriculaCurso c WHERE c.I_MatAluID = @I_MatAluID AND c.B_Habilitado = 1 AND c.B_Eliminado = 0);      
      
		 with CTE_Recursivo as  
		 (  
		  select 1 as num, I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
		  where I_TipoAlumno = @I_TipoAlumno and B_Calculado = 1 and I_Calculado = @I_CrdtDesaprobados  
		  union all  
		  select num + 1, I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad  
		  from CTE_Recursivo  
		  where num < @N_NroPagos  
		 )  
		 insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
		 select I_ProcesoID, I_ConcPagID, cast((M_Monto * @I_MultiplicMontoCredt) / @N_NroPagos as decimal(15,2)),   
		  DATEADD(MONTH, num-1, D_FecVencto), I_TipoObligacion, I_Prioridad  
		 from CTE_Recursivo  
		end  
	   end  
  
	   --Monto de Pensión de enseñanza  
	   if (select count(I_ProcesoID) from #tmp_conceptos_pregrado  
		where I_TipoAlumno = @I_TipoAlumno and B_Calculado = 1 and I_Calculado = @I_Pensiones and C_CodModIng = @C_CodModIng) = 1  
	   begin  
		set @N_NroPagos = isnull((select top 1 N_NroPagos from #tmp_conceptos_pregrado   
		 where I_TipoAlumno = @I_TipoAlumno and B_Calculado = 1 and I_Calculado = @I_Pensiones and C_CodModIng = @C_CodModIng), 1);  
      
		with CTE_Recursivo as  
		(  
		 select 1 as num, I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
		 where I_TipoAlumno = @I_TipoAlumno and B_Calculado = 1 and I_Calculado = @I_Pensiones and C_CodModIng = @C_CodModIng  
		 union all  
		 select num + 1, I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad  
		 from CTE_Recursivo  
		 where num < @N_NroPagos  
		)  
		insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
		select I_ProcesoID, I_ConcPagID, cast(M_Monto / @N_NroPagos as decimal(15,2)) as M_Monto,   
		 DATEADD(MONTH, num-1, D_FecVencto), I_TipoObligacion, I_Prioridad  
		from CTE_Recursivo  
	   end  
	END
	ELSE BEGIN
		--Pagos extemoráneos  
	   if (select count(I_ProcesoID) from #tmp_conceptos_pregrado  
		where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		 B_EsPagoMatricula = 0 and B_EsPagoExtmp = 1 and  
		 datediff(day, @D_CurrentDate, D_FecVencto) < 0) = 1  
	   begin  
		insert @Tmp_Procesos(I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad)  
		select I_ProcesoID, I_ConcPagID, M_Monto, D_FecVencto, I_TipoObligacion, I_Prioridad from #tmp_conceptos_pregrado  
		where I_TipoAlumno = @I_TipoAlumno and I_TipoObligacion = @I_Matricula and   
		 B_EsPagoMatricula = 0 and B_EsPagoExtmp = 1 and  
		 datediff(day, @D_CurrentDate, D_FecVencto) < 0  
	   end  
	END
  
   --Grabando pago de matrícula  
   set @I_ProcesoID = 0  

   IF (@B_SoloAplicarExtemporaneo = 0)
   BEGIN
  
	   if exists(select p.I_ProcesoID from @Tmp_Procesos p where p.I_Prioridad = 1)  
	   begin  
		set @I_ProcesoID = (select distinct p.I_ProcesoID from @Tmp_Procesos p where p.I_Prioridad = 1)  
  
		if exists(select cab.I_ObligacionAluID from dbo.TR_ObligacionAluCab cab   
		 where cab.B_Eliminado = 0 and I_MatAluID = @I_MatAluID and I_ProcesoID = @I_ProcesoID)  
		begin  
		 select @I_MontoInicial = cab.I_MontoOblig, @D_FecVenctoInicial = cab.D_FecVencto, @B_Pagado = cab.B_Pagado from dbo.TR_ObligacionAluCab cab   
		 where cab.B_Eliminado = 0 and I_MatAluID = @I_MatAluID and I_ProcesoID = @I_ProcesoID  
  
		 select @D_FecVenctoActual = p.D_FecVencto, @I_MontoActual = Sum(p.M_Monto) from @Tmp_Procesos p   
		 where p.I_Prioridad = 1 group by p.D_FecVencto  
  
		 if (@B_Pagado = 0)  
		 begin  
		  if Not (DATEDIFF(Day, @D_FecVenctoInicial, @D_FecVenctoActual) = 0) Or Not (@I_MontoInicial = @I_MontoActual)  
		  begin  
		   update d set d.B_Habilitado = 0, d.B_Eliminado = 1, d.I_UsuarioMod = @I_UsuarioCre, d.D_FecMod = @D_CurrentDate  
		   from dbo.TR_ObligacionAluCab c  
		   inner join dbo.TR_ObligacionAluDet d on d.I_ObligacionAluID = c.I_ObligacionAluID  
		   where d.B_Eliminado = 0 and c.B_Eliminado = 0 and c.I_MatAluID = @I_MatAluID and c.I_ProcesoID = @I_ProcesoID  
  
		   update dbo.TR_ObligacionAluCab set B_Habilitado = 0, B_Eliminado = 1, I_UsuarioMod = @I_UsuarioCre, D_FecMod = @D_CurrentDate  
		   where B_Eliminado = 0 and I_MatAluID = @I_MatAluID and I_ProcesoID = @I_ProcesoID  
  
		   insert dbo.TR_ObligacionAluCab(I_ProcesoID, I_MatAluID, C_Moneda, I_MontoOblig, B_Pagado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, D_FecVencto)  
		   select p.I_ProcesoID, @I_MatAluID, @C_Moneda, Sum(p.M_Monto), 0, 1, 0, @I_UsuarioCre, @D_CurrentDate, p.D_FecVencto from @Tmp_Procesos p  
		   where p.I_Prioridad = 1   
		   group by p.I_ProcesoID, p.D_FecVencto  
  
		   set @I_ObligacionAluID = SCOPE_IDENTITY()  
  
		   insert dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, B_Mora)  
		   select @I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, p.D_FecVencto, 1, 0, @I_UsuarioCre, @D_CurrentDate, 0 from @Tmp_Procesos p  
		   where p.I_Prioridad = 1  
		  end  
		 end  
		end  
		else  
		begin  
		 --insert  
		 insert dbo.TR_ObligacionAluCab(I_ProcesoID, I_MatAluID, C_Moneda, I_MontoOblig, B_Pagado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, D_FecVencto)  
		 select p.I_ProcesoID, @I_MatAluID, @C_Moneda, Sum(p.M_Monto), 0, 1, 0, @I_UsuarioCre, @D_CurrentDate, p.D_FecVencto from @Tmp_Procesos p  
		 where p.I_Prioridad = 1   
		 group by p.I_ProcesoID, p.D_FecVencto  
  
		 set @I_ObligacionAluID = SCOPE_IDENTITY()  
  
		 insert dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, B_Mora)  
		 select @I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, p.D_FecVencto, 1, 0, @I_UsuarioCre, @D_CurrentDate, 0 from @Tmp_Procesos p  
		 where p.I_Prioridad = 1  
		end  
	   end  
  
	   --Grabando otros pagos  
	   if exists(select p.I_ProcesoID from @Tmp_Procesos p where p.I_Prioridad = 2)  
	   begin  
		if not exists(select cab.I_ObligacionAluID from dbo.TR_ObligacionAluCab cab  
		 where cab.B_Eliminado = 0 and cab.I_MatAluID = @I_MatAluID and  
		  cab.I_ProcesoID in (select p.I_ProcesoID from @Tmp_Procesos p where p.I_Prioridad = 2))  
		begin  
		 --Nuevos registros de obligaciones  
  
		 --Insert de cabecera  
		 insert dbo.TR_ObligacionAluCab(I_ProcesoID, I_MatAluID, C_Moneda, I_MontoOblig, B_Pagado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, D_FecVencto)  
		 select p.I_ProcesoID, @I_MatAluID, @C_Moneda, Sum(p.M_Monto), 0, 1, 0, @I_UsuarioCre, @D_CurrentDate, p.D_FecVencto from @Tmp_Procesos p  
		 where p.I_Prioridad = 2  
		 group by p.I_ProcesoID, p.D_FecVencto  
  
		 --Insert de detalle  
		 insert dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, B_Mora)  
		 select cab.I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, p.D_FecVencto, 1, 0, @I_UsuarioCre, @D_CurrentDate, 0 from @Tmp_Procesos p  
		 inner join dbo.TR_ObligacionAluCab cab on cab.B_Habilitado = 1 and cab.B_Eliminado = 0 and p.I_ProcesoID = cab.I_ProcesoID and cab.I_MatAluID = @I_MatAluID and  
		  DATEDIFF(Day, p.D_FecVencto, cab.D_FecVencto) = 0  
		 where p.I_Prioridad = 2  
		end  
		else  
		begin  
		 --Edición de obligaciones  
  
		 if exists(select id from @Tmp_grupo_otros_pagos) begin  
		  delete @Tmp_grupo_otros_pagos  
		 end  
  
		 insert @Tmp_grupo_otros_pagos(id, I_ProcesoID)  
		 select ROW_NUMBER() OVER (ORDER BY I_ProcesoID), I_ProcesoID from @Tmp_Procesos p  
		 where p.I_Prioridad = 2  
		 group by p.I_ProcesoID  
       
		 set @I_FilaActual_OtrsPag = 1  
		 set @I_CantRegistros_OtrsPag = (select max(id) from @Tmp_grupo_otros_pagos)  
  
		 while (@I_FilaActual_OtrsPag <= @I_CantRegistros_OtrsPag) begin  
		  --Los otros pagos se agrupan primero por proceso y luego por fecha de vcto.  
		  set @I_ProcesoID_OtrsPag = (select I_ProcesoID from @Tmp_grupo_otros_pagos where id = @I_FilaActual_OtrsPag)  
  
		  if exists(select cab.I_ObligacionAluID from dbo.TR_ObligacionAluCab cab  
		   inner join dbo.TR_ObligacionAluDet det on det.I_ObligacionAluID = cab.I_ObligacionAluID  
		   where cab.B_Eliminado = 0 and det.B_Eliminado = 0 and cab.I_MatAluID = @I_MatAluID and   
		   cab.I_ProcesoID = @I_ProcesoID_OtrsPag AND cab.B_Pagado = 1) begin  
         
		   print 'Existen al menos un pago realizado.'  
  
		  end  
		  else begin  
		   update d set d.B_Habilitado = 0, d.B_Eliminado = 1, d.I_UsuarioMod = @I_UsuarioCre, d.D_FecMod = @D_CurrentDate  
		   from dbo.TR_ObligacionAluCab c  
		   inner join dbo.TR_ObligacionAluDet d on d.I_ObligacionAluID = c.I_ObligacionAluID  
		   where d.B_Eliminado = 0 and c.B_Eliminado = 0 and c.I_MatAluID = @I_MatAluID and c.I_ProcesoID = @I_ProcesoID_OtrsPag  
  
		   update dbo.TR_ObligacionAluCab set B_Habilitado = 0, B_Eliminado = 1, I_UsuarioMod = @I_UsuarioCre, D_FecMod = @D_CurrentDate  
		   where B_Eliminado = 0 and I_MatAluID = @I_MatAluID and I_ProcesoID = @I_ProcesoID_OtrsPag  
  
		   insert dbo.TR_ObligacionAluCab(I_ProcesoID, I_MatAluID, C_Moneda, I_MontoOblig, B_Pagado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, D_FecVencto)  
		   select p.I_ProcesoID, @I_MatAluID, @C_Moneda, Sum(p.M_Monto), 0, 1, 0, @I_UsuarioCre, @D_CurrentDate, p.D_FecVencto from @Tmp_Procesos p  
		   where p.I_Prioridad = 2 and p.I_ProcesoID = @I_ProcesoID_OtrsPag  
		   group by p.I_ProcesoID, p.D_FecVencto  
  
		   insert dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, B_Mora)  
		   select cab.I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, p.D_FecVencto, 1, 0, @I_UsuarioCre, @D_CurrentDate, 0 from @Tmp_Procesos p  
		   inner join dbo.TR_ObligacionAluCab cab on cab.B_Habilitado = 1 and cab.B_Eliminado = 0 and p.I_ProcesoID = cab.I_ProcesoID  and cab.I_MatAluID = @I_MatAluID and  
			DATEDIFF(Day, p.D_FecVencto, cab.D_FecVencto) = 0  
		   where p.I_Prioridad = 2 and p.I_ProcesoID = @I_ProcesoID_OtrsPag  
		  end  
  
		  set @I_FilaActual_OtrsPag = (@I_FilaActual_OtrsPag + 1)  
		 end  
		end  
	   end  
  
	END
	ELSE
	BEGIN
		--Sólo se agregará el pago extemporáneo
		IF ((SELECT COUNT(*) FROM @Tmp_Procesos) = 1) BEGIN	
					
			SET @I_ProcesoID = (SELECT p.I_ProcesoID FROM @Tmp_Procesos p WHERE p.I_Prioridad = 1);

			IF ((SELECT COUNT(cab.I_ObligacionAluID) FROM dbo.TR_ObligacionAluCab cab   
				WHERE cab.B_Habilitado = 1 AND cab.B_Eliminado = 0 AND cab.I_MatAluID = @I_MatAluID AND cab.I_ProcesoID = @I_ProcesoID) = 1) BEGIN

				SELECT @I_ObligacionAluID = cab.I_ObligacionAluID, @D_FecVenctoInicial = cab.D_FecVencto, @B_Pagado = cab.B_Pagado FROM dbo.TR_ObligacionAluCab cab
				WHERE cab.B_Habilitado = 1 AND cab.B_Eliminado = 0 AND cab.I_MatAluID = @I_MatAluID AND cab.I_ProcesoID = @I_ProcesoID

				IF (@B_Pagado = 0) BEGIN
					INSERT dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, D_FecVencto, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
					SELECT @I_ObligacionAluID, p.I_ConcPagID, p.M_Monto, 0, @D_FecVenctoInicial, 1, 0, @I_UsuarioCre, @D_CurrentDate FROM @Tmp_Procesos p
							
					UPDATE dbo.TR_ObligacionAluCab SET I_MontoOblig = (I_MontoOblig + (SELECT SUM(p.M_Monto) FROM @Tmp_Procesos p))
					WHERE I_ObligacionAluID = @I_ObligacionAluID
				END
			END
		END
	END
   commit tran  
  end try  
  begin catch  
   rollback tran  
  
   print ERROR_MESSAGE()  
   print ERROR_LINE()  
  end catch  
  
  set @I_FilaActual = (@I_FilaActual +1)  
 end  
  
 set @B_Result = 1  
 set @T_Message = 'El proceso finalizó correctamente.'  
/*  
  
declare @B_Result bit,  
  @T_Message nvarchar(4000)  
  
exec USP_IU_GenerarObligacionesPregrado_X_Ciclo @I_Anio = 2021, @I_Periodo = 15,   
@C_CodFac = null, @C_CodAlu = null, @C_CodRc = null, @I_UsuarioCre = 1,  
@B_Result = @B_Result OUTPUT,  
@T_Message = @T_Message OUTPUT  
go  
  
*/  
END  
GO