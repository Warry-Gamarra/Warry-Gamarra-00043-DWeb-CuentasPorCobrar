USE [BD_OCEF_CtasPorCobrar]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[USP_IU_GrabarMatriculaPregrado]
(  
	@Tbl_Matricula [dbo].[type_dataMatricula] READONLY
	,@D_FecRegistro datetime
	,@UserID  int
	,@B_Result  bit    OUTPUT
	,@T_Message  nvarchar(4000) OUTPUT
)  
AS  
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY  
	BEGIN TRANSACTION  
    
		DECLARE @Tmp_Matricula TABLE (
			id			INT IDENTITY(1, 1),
			C_CodRC		VARCHAR(3),
			C_CodAlu	VARCHAR(20),
			I_Anio		INT,
			C_Periodo	VARCHAR(50),
			I_Periodo	INT,
			C_EstMat	VARCHAR(2),
			C_Ciclo		VARCHAR(2),
			B_Ingresante	BIT,
			B_ExisteAlumno	BIT
		)

		DECLARE @Tmp_MatriculaCursoResultado TABLE (
			C_CodRC		VARCHAR(3),
			C_CodAlu	VARCHAR(20),
			I_Anio		INT,
			C_Periodo	VARCHAR(50),
			C_EstMat	VARCHAR(2),
			C_Ciclo		VARCHAR(2),
			B_Ingresante	BIT,
			I_CredDesaprob	TINYINT,
			C_CodCurso	VARCHAR(10),
			I_Vez		TINYINT,
			B_Success	BIT,
			T_Message	VARCHAR(250)
		)


		INSERT @Tmp_Matricula(C_CodRC, C_CodAlu, I_Anio, C_Periodo, I_Periodo, C_EstMat, C_Ciclo, B_Ingresante, B_ExisteAlumno)
		SELECT DISTINCT 
			m.C_CodRC, m.C_CodAlu, m.I_Anio, m.C_Periodo, c.I_OpcionID AS I_Periodo, m.C_EstMat, m.C_Ciclo, m.B_Ingresante,
			CASE WHEN a.C_CodAlu IS NULL THEN 0 ELSE 1 END
		FROM @Tbl_Matricula AS m
		LEFT JOIN dbo.TC_CatalogoOpcion c ON c.I_ParametroID = 5 AND c.T_OpcionCod = m.C_Periodo AND c.B_Eliminado = 0
		LEFT JOIN BD_UNFV_Repositorio.dbo.VW_Alumnos a ON a.C_CodAlu = m.C_CodAlu and a.C_RcCod = m.C_CodRC AND a.N_Grado = '1'

		INSERT @Tmp_MatriculaCursoResultado(C_CodRC, C_CodAlu, I_Anio, C_Periodo, C_EstMat, C_Ciclo, B_Ingresante,
			I_CredDesaprob, C_CodCurso, I_Vez)
		SELECT m.C_CodRC, m.C_CodAlu, m.I_Anio, m.C_Periodo, m.C_EstMat, m.C_Ciclo, m.B_Ingresante,
			m.I_CredDesaprob, m.C_CodCurso, m.I_Vez
		FROM @Tbl_Matricula AS m
  
		DECLARE @actual INT = 1,
				@fin	INT = (SELECT COUNT(*) FROM @Tmp_Matricula),
				@C_CodRC VARCHAR(3),
				@C_CodAlu VARCHAR(20),
				@I_Anio INT,
				@C_Periodo VARCHAR(50),
				@I_Periodo	INT,
				@C_EstMat	VARCHAR(2),
				@C_Ciclo		VARCHAR(2),
				@B_Ingresante	BIT,
				@B_ExisteAlumno BIT,
				---
				@I_MatAluID INT,
				@I_ObligacionAluID INT,
				--
				@B_ExisteError BIT,
				@B_Success BIT,
				@T_MsgError VARCHAR(250)

		WHILE (@actual <= @fin)
		BEGIN
			SELECT 
				@C_CodRC = C_CodRC,
				@C_CodAlu = C_CodAlu,
				@I_Anio = I_Anio,
				@C_Periodo = C_Periodo,
				@I_Periodo = I_Periodo,
				@C_EstMat = C_EstMat,
				@C_Ciclo = C_Ciclo,
				@B_Ingresante = B_Ingresante,
				@B_ExisteAlumno = B_ExisteAlumno
			FROM @Tmp_Matricula
			WHERE id = @actual

			SET @B_ExisteError = CASE WHEN @B_ExisteAlumno = 0 THEN 1 ELSE 0 END
			
			SET @T_MsgError = NULL

			IF (@B_ExisteError = 1) BEGIN
				SET @T_MsgError = 'El Código de Alumno no existe en pregrado.'
			END ELSE BEGIN
				SET @B_ExisteError = CASE WHEN @I_Periodo IS NULL THEN 1 ELSE 0 END

				IF (@B_ExisteError = 1) BEGIN
					SET @T_MsgError = 'El Periodo es incorrecto.'
				END
			END

			IF (@B_ExisteError = 0) BEGIN
				
				SET @I_MatAluID = (SELECT I_MatAluID FROM dbo.TC_MatriculaAlumno m WHERE m.B_Eliminado = 0 AND C_CodAlu = @C_CodAlu AND C_CodRc = @C_CodRC AND
					I_Anio = @I_Anio AND I_Periodo = @I_Periodo)

				IF (@I_MatAluID IS NULL)
				BEGIN
					INSERT dbo.TC_MatriculaAlumno(C_CodRc, C_CodAlu, I_Anio, I_Periodo, C_EstMat, C_Ciclo, B_Ingresante, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre, B_Migrado)
					VALUES(@C_CodRC, @C_CodAlu, @I_Anio, @I_Periodo, @C_EstMat, @C_Ciclo, @B_Ingresante, 1, 0, @UserID, @D_FecRegistro, 0)

					SET @I_MatAluID = SCOPE_IDENTITY()

					IF (@B_Ingresante = 0) BEGIN
						INSERT dbo.TC_MatriculaCurso(I_MatAluID, C_CodCurso, I_Vez, I_CredDesaprob, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
						SELECT @I_MatAluID, C_CodCurso, I_Vez, I_CredDesaprob, 1, 0, @UserID, @D_FecRegistro 
						FROM @Tmp_MatriculaCursoResultado
						WHERE C_CodAlu = @C_CodAlu AND C_CodRC = @C_CodRC AND I_Anio = @I_Anio AND C_Periodo = @C_Periodo AND I_CredDesaprob > 0
					END
				END
				ELSE
				BEGIN
					IF NOT EXISTS (SELECT I_ObligacionAluID FROM dbo.TR_ObligacionAluCab
						WHERE B_Habilitado = 1 AND B_Eliminado = 0 AND I_MatAluID = @I_MatAluID)
					BEGIN
						--Actualización data matrícula
						UPDATE dbo.TC_MatriculaAlumno SET
							C_EstMat = @C_EstMat,
							C_Ciclo = @C_Ciclo,
							B_Ingresante = @B_Ingresante,
							I_UsuarioMod = @UserID,
							D_FecMod = @D_FecRegistro
						WHERE I_MatAluID = @I_MatAluID

						IF (@B_Ingresante = 0) BEGIN
							--Deshabilito todos los cursos habilitados
							UPDATE dbo.TC_MatriculaCurso SET
								B_Habilitado = 0,
								I_UsuMod = @UserID,
								D_FecMod = @D_FecRegistro
							WHERE I_MatAluID = @I_MatAluID AND B_Eliminado = 0 AND B_Habilitado = 1

							--Habilitado los cursos necesarios
							UPDATE c SET c.I_CredDesaprob = m.I_CredDesaprob, I_Vez = m.I_Vez, c.B_Habilitado = 1, c.I_UsuMod = @UserID, D_FecMod = @D_FecRegistro 
							FROM dbo.TC_MatriculaCurso c
							INNER JOIN @Tmp_MatriculaCursoResultado m ON c.C_CodCurso = m.C_CodCurso
							WHERE c.I_MatAluID = @I_MatAluID AND c.B_Eliminado = 0 AND
								m.C_CodAlu = @C_CodAlu AND m.C_CodRC = @C_CodRC AND m.I_Anio = @I_Anio AND m.C_Periodo = @C_Periodo AND m.I_CredDesaprob > 0

							--Agrego los cursos restantes
							INSERT dbo.TC_MatriculaCurso(I_MatAluID, C_CodCurso, I_Vez, I_CredDesaprob, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
							SELECT @I_MatAluID, m.C_CodCurso, m.I_Vez, m.I_CredDesaprob, 1, 0, @UserID, @D_FecRegistro FROM @Tmp_MatriculaCursoResultado m
							WHERE m.C_CodAlu = @C_CodAlu AND m.C_CodRC = @C_CodRC AND m.I_Anio = @I_Anio AND m.C_Periodo = @C_Periodo AND m.I_CredDesaprob > 0 AND
								NOT EXISTS(SELECT * FROM dbo.TC_MatriculaCurso c WHERE c.B_Eliminado = 0 AND c.I_MatAluID = @I_MatAluID AND c.C_CodCurso = m.C_CodCurso)
						END
					END
					ELSE BEGIN
						IF EXISTS(SELECT cab.I_ObligacionAluID FROM dbo.TR_ObligacionAluCab cab
							INNER JOIN dbo.TR_ObligacionAluDet det ON det.I_ObligacionAluID = cab.I_ObligacionAluID
							WHERE det.B_Habilitado = 1 AND det.B_Eliminado = 0 AND det.B_Pagado = 1 AND
								cab.I_MatAluID = @I_MatAluID AND cab.B_Habilitado = 1 AND cab.B_Eliminado = 0) BEGIN

							SET @T_MsgError = 'El alumno tiene obligaciones pagadas.'
							SET @B_ExisteError = 0

						END
						ELSE BEGIN
							--Actualización data matrícula
							UPDATE dbo.TC_MatriculaAlumno SET
								C_EstMat = @C_EstMat,
								C_Ciclo = @C_Ciclo,
								B_Ingresante = @B_Ingresante,
								I_UsuarioMod = @UserID,
								D_FecMod = @D_FecRegistro
							WHERE I_MatAluID = @I_MatAluID

							IF (@B_Ingresante = 0) BEGIN
								--Deshabilito todos los cursos habilitados
								UPDATE dbo.TC_MatriculaCurso SET
									B_Habilitado = 0,
									I_UsuMod = @UserID,
									D_FecMod = @D_FecRegistro
								WHERE I_MatAluID = @I_MatAluID AND B_Eliminado = 0 AND B_Habilitado = 1

								--Habilitado los cursos necesarios
								UPDATE c SET c.I_CredDesaprob = m.I_CredDesaprob, I_Vez = m.I_Vez, c.B_Habilitado = 1, c.I_UsuMod = @UserID, D_FecMod = @D_FecRegistro 
								FROM dbo.TC_MatriculaCurso c
								INNER JOIN @Tmp_MatriculaCursoResultado m ON c.C_CodCurso = m.C_CodCurso
								WHERE c.I_MatAluID = @I_MatAluID AND c.B_Eliminado = 0 AND
									m.C_CodAlu = @C_CodAlu AND m.C_CodRC = @C_CodRC AND m.I_Anio = @I_Anio AND m.C_Periodo = @C_Periodo AND m.I_CredDesaprob > 0

								--Agrego los cursos restantes
								INSERT dbo.TC_MatriculaCurso(I_MatAluID, C_CodCurso, I_Vez, I_CredDesaprob, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
								SELECT @I_MatAluID, m.C_CodCurso, m.I_Vez, m.I_CredDesaprob, 1, 0, @UserID, @D_FecRegistro FROM @Tmp_MatriculaCursoResultado m
								WHERE m.C_CodAlu = @C_CodAlu AND m.C_CodRC = @C_CodRC AND m.I_Anio = @I_Anio AND m.C_Periodo = @C_Periodo AND m.I_CredDesaprob > 0 AND
									NOT EXISTS(SELECT * FROM dbo.TC_MatriculaCurso c WHERE c.B_Eliminado = 0 AND c.I_MatAluID = @I_MatAluID AND c.C_CodCurso = m.C_CodCurso)
							END

							--Elimino las obligaciones antiguas
							UPDATE det SET det.B_Habilitado = 0, det.B_Eliminado = 1, det.I_UsuarioMod = @UserID, det.D_FecMod = @D_FecRegistro  
							FROM dbo.TR_ObligacionAluDet det
							INNER JOIN dbo.TR_ObligacionAluCab cab ON cab.I_ObligacionAluID = det.I_ObligacionAluID AND cab.B_Eliminado = 0
							WHERE cab.I_MatAluID = @I_MatAluID AND det.B_Eliminado = 0

							UPDATE cab SET cab.B_Habilitado = 0, cab.B_Eliminado = 1, cab.I_UsuarioMod = @UserID, cab.D_FecMod = @D_FecRegistro  
							FROM dbo.TR_ObligacionAluCab cab
							WHERE cab.I_MatAluID = @I_MatAluID AND cab.B_Eliminado = 0

						END
					END
				END
			END

			SET @B_Success = CASE WHEN (@B_ExisteError = 1) THEN 0 ELSE 1 END

			UPDATE @Tmp_MatriculaCursoResultado SET B_Success = @B_Success, T_Message = @T_MsgError
			WHERE C_CodAlu = @C_CodAlu AND C_CodRC = @C_CodRC AND I_Anio = @I_Anio AND C_Periodo = @C_Periodo

			SET @actual = @actual + 1
		END
  
		SELECT * FROM @Tmp_MatriculaCursoResultado

		COMMIT TRANSACTION
  
		SET @B_Result = 1  
		SET @T_Message = 'La importación de datos de alumno finalizó de manera exitosa'  
    
	END TRY  
	BEGIN CATCH  
		ROLLBACK TRANSACTION  
		SET @B_Result = 0  
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10))   
	END CATCH  
END 
GO