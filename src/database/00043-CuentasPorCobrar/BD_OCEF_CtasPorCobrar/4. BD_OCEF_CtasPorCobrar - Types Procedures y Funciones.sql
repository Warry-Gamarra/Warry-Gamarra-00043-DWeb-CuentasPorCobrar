USE BD_OCEF_CtasPorCobrar
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_I_GrabarCuentaCorreo')
	DROP PROCEDURE [dbo].[USP_I_GrabarCuentaCorreo]
GO

CREATE PROCEDURE [dbo].[USP_I_GrabarCuentaCorreo]
	 @I_CorreoID	int
	,@T_DireccionCorreo	varchar(50)
	,@T_PasswordCorreo	varchar(500)
	,@T_Seguridad		varchar(10)
	,@T_HostName		varchar(50)
	,@I_Puerto			smallint
	,@D_FecUpdate		datetime

	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
		UPDATE	TS_CorreoAplicacion  
			SET	B_Habilitado = 0
				, D_FecUpdate = @D_FecUpdate
			
		INSERT INTO TS_CorreoAplicacion (T_DireccionCorreo, T_PasswordCorreo, T_Seguridad, T_HostName, I_Puerto, B_Habilitado, D_FecUpdate, B_Eliminado)
								VALUES	 (@T_DireccionCorreo, @T_PasswordCorreo, @T_Seguridad, @T_HostName, @I_Puerto, 1, @D_FecUpdate, 0)
		

		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos de correo correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH

END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_GrabarCuentaCorreo')
	DROP PROCEDURE [dbo].[USP_U_GrabarCuentaCorreo]
GO

CREATE PROCEDURE [dbo].[USP_U_GrabarCuentaCorreo]
	 @I_CorreoID	int
	,@T_DireccionCorreo	varchar(50)
	,@T_PasswordCorreo	varchar(500)
	,@T_Seguridad		varchar(10)
	,@T_HostName		varchar(50)
	,@I_Puerto			smallint
	,@D_FecUpdate		datetime

	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
	UPDATE	TS_CorreoAplicacion 
		SET	T_DireccionCorreo = @T_DireccionCorreo
			, T_PasswordCorreo = @T_PasswordCorreo
			, T_Seguridad = @T_Seguridad
			, T_HostName = @T_HostName
			, I_Puerto = @I_Puerto
			, D_FecUpdate = @D_FecUpdate
		WHERE	I_CorreoID = @I_CorreoID
			
		
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos de correo correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH

END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarEstadoCuentaCorreo')
	DROP PROCEDURE [dbo].[USP_U_ActualizarEstadoCuentaCorreo]
GO

CREATE PROCEDURE [dbo].[USP_U_ActualizarEstadoCuentaCorreo]
	 @I_CorreoID		int
	,@B_Habilitado		bit
	,@D_FecUpdate		datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
		IF(@B_Habilitado = 1)
		BEGIN
			UPDATE	TS_CorreoAplicacion 
			SET		B_Habilitado = 0,
					D_FecUpdate = @D_FecUpdate
					WHERE	I_CorreoID <> @I_CorreoID
		END 

		UPDATE	TS_CorreoAplicacion 
		SET		B_Habilitado = @B_Habilitado,
				D_FecUpdate = @D_FecUpdate
		WHERE	I_CorreoID = @I_CorreoID
			
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos de correo correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_U_ActualizarEstadoUsuario' AND ROUTINE_TYPE = 'PROCEDURE')
	DROP PROCEDURE [dbo].[USP_U_ActualizarEstadoUsuario]
GO

CREATE PROCEDURE [dbo].[USP_U_ActualizarEstadoUsuario]
	 @UserId			int
	,@B_Habilitado		bit
	,@D_FecActualiza	datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	BEGIN TRY

		UPDATE	TC_Usuario 
		   SET	B_Habilitado = @B_Habilitado,
				D_FecActualiza = @D_FecActualiza
		 WHERE	UserId = @UserId

	 	SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos de correo correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH

END
GO



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_S_CuentaDeposito_Habilitadas')
	DROP PROCEDURE dbo.USP_S_CuentaDeposito_Habilitadas
GO

CREATE PROCEDURE dbo.USP_S_CuentaDeposito_Habilitadas
@I_CatPagoID int
AS
BEGIN
	SET NOCOUNT ON;
	SELECT cd.I_CtaDepositoID, cd.C_NumeroCuenta, ef.T_EntidadDesc FROM dbo.TC_CuentaDeposito_CategoriaPago cp
	INNER JOIN dbo.TC_CuentaDeposito cd ON cp.I_CtaDepositoID = cd.I_CtaDepositoID
	INNER JOIN dbo.TC_EntidadFinanciera ef ON ef.I_EntidadFinanID = cd.I_EntidadFinanID
	WHERE cp.B_Habilitado = 1 AND cp.B_Eliminado = 0 AND 
	cd.B_Habilitado = 1 AND cd.B_Eliminado = 0 AND
	ef.B_Habilitado = 1 AND ef.B_Eliminado = 0 AND
	cp.I_CatPagoID = @I_CatPagoID
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_S_Procesos')
	DROP PROCEDURE dbo.USP_S_Procesos
GO

CREATE PROCEDURE dbo.USP_S_Procesos
AS
BEGIN
	SET NOCOUNT ON;
	SELECT p.I_ProcesoID, cp.T_CatPagoDesc, p.I_Anio, p.D_FecVencto, p.I_Prioridad FROM dbo.TC_Proceso p
	INNER JOIN dbo.TC_CategoriaPago cp ON p.I_CatPagoID = cp.I_CatPagoID
	WHERE p.B_Eliminado = 0
END
GO



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_I_GrabarProceso')
	DROP PROCEDURE dbo.USP_I_GrabarProceso
GO


CREATE PROCEDURE dbo.USP_I_GrabarProceso
@I_CatPagoID int,
@I_Anio smallint = null,
@D_FecVencto datetime = null,
@I_Prioridad tinyint = null,
@I_UsuarioCre int,
@I_ProcesoID int OUTPUT,
@B_Result bit OUTPUT,
@T_Message nvarchar(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON
  	BEGIN TRY
		INSERT dbo.TC_Proceso(I_CatPagoID, I_Anio, D_FecVencto, I_Prioridad, B_Migrado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
		VALUES(@I_CatPagoID, @I_Anio, @D_FecVencto, @I_Prioridad, 0, 1, 0, @I_UsuarioCre, getdate())
		
		SET @I_ProcesoID = SCOPE_IDENTITY()
		SET @B_Result = 1
		SET @T_Message = 'Inserci�n de datos correcta.'
	END TRY
	BEGIN CATCH
		SET @I_ProcesoID = 0
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarProceso')
	DROP PROCEDURE dbo.USP_U_ActualizarProceso
GO


CREATE PROCEDURE dbo.USP_U_ActualizarProceso
@I_ProcesoID int,
@I_CatPagoID int,
@I_Anio smallint = null,
@D_FecVencto datetime = null,
@I_Prioridad tinyint = null,
@B_Habilitado bit,
@I_UsuarioMod int,
@B_Result bit OUTPUT,
@T_Message nvarchar(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON
  	BEGIN TRY
		UPDATE dbo.TC_Proceso SET
			I_CatPagoID = @I_CatPagoID, 
			I_Anio = @I_Anio, 
			D_FecVencto = @D_FecVencto, 
			I_Prioridad = @I_Prioridad,
			B_Habilitado = @B_Habilitado,
			I_UsuarioMod = @I_UsuarioMod,
			D_FecMod = getdate()
		WHERE I_ProcesoID = @I_ProcesoID
		
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos correcta.'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_I_GrabarCtaDeposito_Proceso')
	DROP PROCEDURE dbo.USP_I_GrabarCtaDeposito_Proceso
GO


CREATE PROCEDURE dbo.USP_I_GrabarCtaDeposito_Proceso
@I_CtaDepositoID int,
@I_ProcesoID int,
@I_UsuarioCre int,
@I_CtaDepoProID int OUTPUT,
@B_Result bit OUTPUT,
@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
	SET NOCOUNT ON
  	BEGIN TRY
		INSERT dbo.TI_CtaDepo_Proceso(I_CtaDepositoID, I_ProcesoID, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
		VALUES(@I_CtaDepositoID, @I_ProcesoID, 1, 0, @I_UsuarioCre, getdate())
		
		SET @I_CtaDepoProID = SCOPE_IDENTITY()

		SET @B_Result = 1
		SET @T_Message = 'Inserci�n de datos correcta.'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarCtaDeposito_Proceso')
	DROP PROCEDURE dbo.USP_U_ActualizarCtaDeposito_Proceso
GO


CREATE PROCEDURE dbo.USP_U_ActualizarCtaDeposito_Proceso
@I_CtaDepoProID int,
@I_CtaDepositoID int,
@I_ProcesoID int,
@B_Habilitado bit,
@I_UsuarioMod int,
@B_Result bit OUTPUT,
@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
	SET NOCOUNT ON
  	BEGIN TRY
		UPDATE dbo.TI_CtaDepo_Proceso SET
		I_CtaDepositoID = @I_CtaDepositoID, 
		I_ProcesoID = @I_ProcesoID, 
		B_Habilitado = @B_Habilitado,
		I_UsuarioMod = @I_UsuarioMod,
		D_FecMod = getdate()
		WHERE I_CtaDepoProID = @I_CtaDepoProID
		
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos correcta.'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_S_CtaDepo_Proceso')
	DROP PROCEDURE dbo.USP_S_CtaDepo_Proceso
GO


CREATE PROCEDURE dbo.USP_S_CtaDepo_Proceso
@I_ProcesoID int
AS
BEGIN
	SET NOCOUNT ON
  	SELECT cp.I_CtaDepoProID, cp.I_CtaDepositoID, cp.I_ProcesoID, cp.B_Habilitado, c.C_NumeroCuenta, e.T_EntidadDesc FROM dbo.TI_CtaDepo_Proceso cp
	INNER JOIN dbo.TC_CuentaDeposito c ON c.I_CtaDepositoID = cp.I_CtaDepositoID
	INNER JOIN dbo.TC_EntidadFinanciera e ON e.I_EntidadFinanID = c.I_EntidadFinanID
	WHERE cp.B_Eliminado = 0 AND cp.I_ProcesoID = @I_ProcesoID
END
GO



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_S_ConceptoPago')
	DROP PROCEDURE dbo.USP_S_ConceptoPago
GO

CREATE PROCEDURE dbo.USP_S_ConceptoPago
AS
BEGIN
	SET NOCOUNT ON;
	SELECT c.I_ConcPagID, cp.T_ConceptoDesc, c.I_Anio, c.I_Periodo, c.M_Monto FROM dbo.TI_ConceptoPago c
	INNER JOIN dbo.TC_Concepto cp ON cp.I_ConceptoID = c.I_ConceptoID
	WHERE c.B_Habilitado = 1 AND c.B_Eliminado = 0
END
GO



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_I_GrabarConceptoPago')
	DROP PROCEDURE dbo.USP_I_GrabarConceptoPago
GO

CREATE PROCEDURE dbo.USP_I_GrabarConceptoPago
@I_ProcesoID int,
@I_ConceptoID int,
@B_Fraccionable bit = null,
@B_ConceptoGeneral bit = null,
@B_AgrupaConcepto bit = null,
@I_AlumnosDestino int = null,
@I_GradoDestino int = null,
@I_TipoObligacion int = null,
@T_Clasificador varchar(250) = null,
@C_CodTasa varchar(250) = null,
@B_Calculado bit = null,
@I_Calculado int = null,
@B_AnioPeriodo bit = null,
@I_Anio int = null,
@I_Periodo int = null,
@B_Especialidad bit = null,
@C_CodRc char(3) = null,
@B_Dependencia bit = null,
@C_DepCod int = null,
@B_GrupoCodRc bit = null,
@I_GrupoCodRc int = null,
@B_ModalidadIngreso bit = null,
@I_ModalidadIngresoID int = null,
@B_ConceptoAgrupa bit = null,
@I_ConceptoAgrupaID int = null,
@B_ConceptoAfecta bit = null,
@I_ConceptoAfectaID int = null,
@N_NroPagos int = null,
@B_Porcentaje bit = null,
@M_Monto decimal(10,4) = null,
@M_MontoMinimo decimal(10,4) = null,
@T_DescripcionLarga varchar(250) = null,
@T_Documento varchar(250) = null,
@I_UsuarioCre int,
@I_ConcPagID int OUTPUT,
@B_Result bit OUTPUT,
@T_Message nvarchar(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON
  	BEGIN TRY
		INSERT dbo.TI_ConceptoPago(I_ProcesoID, I_ConceptoID, B_Fraccionable, B_ConceptoGeneral, B_AgrupaConcepto, 
			I_AlumnosDestino, I_GradoDestino, I_TipoObligacion, T_Clasificador, C_CodTasa, B_Calculado, I_Calculado, 
			B_AnioPeriodo, I_Anio, I_Periodo, B_Especialidad, C_CodRc, B_Dependencia, C_DepCod, B_GrupoCodRc, I_GrupoCodRc, 
			B_ModalidadIngreso, I_ModalidadIngresoID, B_ConceptoAgrupa, I_ConceptoAgrupaID, B_ConceptoAfecta, I_ConceptoAfectaID, 
			N_NroPagos, B_Porcentaje, M_Monto, M_MontoMinimo, T_DescripcionLarga, T_Documento, B_Migrado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
		
		VALUES(@I_ProcesoID, @I_ConceptoID, @B_Fraccionable, @B_ConceptoGeneral, @B_AgrupaConcepto, 
			@I_AlumnosDestino, @I_GradoDestino, @I_TipoObligacion, @T_Clasificador, @C_CodTasa, @B_Calculado, @I_Calculado, 
			@B_AnioPeriodo, @I_Anio, @I_Periodo, @B_Especialidad, @C_CodRc, @B_Dependencia, @C_DepCod, @B_GrupoCodRc, @I_GrupoCodRc,
			@B_ModalidadIngreso, @I_ModalidadIngresoID, @B_ConceptoAgrupa, @I_ConceptoAgrupaID, @B_ConceptoAfecta, @I_ConceptoAfectaID, 
			@N_NroPagos, @B_Porcentaje, @M_Monto, @M_MontoMinimo, @T_DescripcionLarga, @T_Documento, 0, 1, 0, @I_UsuarioCre, getdate())
		
		SET @I_ConcPagID = SCOPE_IDENTITY()
		SET @B_Result = 1
		SET @T_Message = 'Inserci�n de datos correcta.'
	END TRY
	BEGIN CATCH
		SET @I_ConcPagID = 0
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO



IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarConceptoPago')
	DROP PROCEDURE dbo.USP_U_ActualizarConceptoPago
GO

CREATE PROCEDURE dbo.USP_U_ActualizarConceptoPago
@I_ConcPagID int,
@I_ProcesoID int,
@I_ConceptoID int,
@B_Fraccionable bit = null,
@B_ConceptoGeneral bit = null,
@B_AgrupaConcepto bit = null,
@I_AlumnosDestino int = null,
@I_GradoDestino int = null,
@I_TipoObligacion int = null,
@T_Clasificador varchar(250) = null,
@C_CodTasa varchar(250) = null,
@B_Calculado bit = null,
@I_Calculado int = null,
@B_AnioPeriodo bit = null,
@I_Anio int = null,
@I_Periodo int = null,
@B_Especialidad bit = null,
@C_CodRc char(3) = null,
@B_Dependencia bit = null,
@C_DepCod int = null,
@B_GrupoCodRc bit = null,
@I_GrupoCodRc int = null,
@B_ModalidadIngreso bit = null,
@I_ModalidadIngresoID int = null,
@B_ConceptoAgrupa bit = null,
@I_ConceptoAgrupaID int = null,
@B_ConceptoAfecta bit = null,
@I_ConceptoAfectaID int = null,
@N_NroPagos int = null,
@B_Porcentaje bit = null,
@M_Monto decimal(10,4) = null,
@M_MontoMinimo decimal(10,4) = null,
@T_DescripcionLarga varchar(250) = null,
@T_Documento varchar(250) = null,
@B_Habilitado bit,
@I_UsuarioMod int,
@B_Result bit OUTPUT,
@T_Message nvarchar(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON
  	BEGIN TRY
		UPDATE dbo.TI_ConceptoPago SET
			I_ProcesoID = @I_ProcesoID,
			I_ConceptoID = @I_ConceptoID,
			B_Fraccionable = @B_Fraccionable,
			B_ConceptoGeneral = @B_ConceptoGeneral,
			B_AgrupaConcepto = @B_AgrupaConcepto,
			I_AlumnosDestino = @I_AlumnosDestino,
			I_GradoDestino = @I_GradoDestino,
			I_TipoObligacion = @I_TipoObligacion,
			T_Clasificador = @T_Clasificador,
			C_CodTasa = @C_CodTasa,
			B_Calculado = @B_Calculado,
			I_Calculado = @I_Calculado,
			B_AnioPeriodo = @B_AnioPeriodo,
			I_Anio = @I_Anio,
			I_Periodo = @I_Periodo,
			B_Especialidad = @B_Especialidad,
			C_CodRc = @C_CodRc,
			B_Dependencia = @B_Dependencia,
			C_DepCod = @C_DepCod,
			B_GrupoCodRc = @B_GrupoCodRc,
			I_GrupoCodRc = @I_GrupoCodRc,
			B_ModalidadIngreso = @B_ModalidadIngreso,
			I_ModalidadIngresoID = @I_ModalidadIngresoID,
			B_ConceptoAgrupa = @B_ConceptoAgrupa,
			I_ConceptoAgrupaID = @I_ConceptoAgrupaID,
			B_ConceptoAfecta = @B_ConceptoAfecta,
			I_ConceptoAfectaID = @I_ConceptoAfectaID,
			N_NroPagos = @N_NroPagos,
			B_Porcentaje = @B_Porcentaje,
			M_Monto = @M_Monto,
			M_MontoMinimo = @M_MontoMinimo,
			T_DescripcionLarga = @T_DescripcionLarga,
			T_Documento = @T_Documento,
			B_Habilitado = @B_Habilitado,
			I_UsuarioMod = @I_UsuarioMod,
			D_FecMod = getdate()
		WHERE I_ConcPagID = @I_ConcPagID
		
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos correcta.'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_I_GrabarDatosUsuario' AND ROUTINE_TYPE = 'PROCEDURE')
	DROP PROCEDURE [dbo].[USP_I_GrabarDatosUsuario]
GO

CREATE PROCEDURE [dbo].[USP_I_GrabarDatosUsuario]
	@I_DatosUsuarioID	int	= NULL
	,@N_NumDoc			varchar(15)
	,@T_NomPersona		varchar(250)
	,@T_CorreoUsuario	varchar(100)
	,@D_FecRegistro		datetime
	,@B_Habilitado		bit
	,@UserId			int = NULL

	,@CurrentUserId		int
	,@B_Result			bit OUTPUT
	,@T_Message			nvarchar(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRANSACTION
	BEGIN TRY

		INSERT INTO TC_DatosUsuario(N_NumDoc, T_NomPersona, T_CorreoUsuario, D_FecRegistro, B_Habilitado, B_Eliminado)
			VALUES(@N_NumDoc, @T_NomPersona, @T_CorreoUsuario, @D_FecRegistro, 1, 0)

		SET @I_DatosUsuarioID = SCOPE_IDENTITY()

		INSERT INTO TI_UsuarioDatosUsuario(UserId, I_DatosUsuarioID, D_FecAlta, D_FecBaja, B_Habilitado)
			VALUES(@UserId, @I_DatosUsuarioID, @D_FecRegistro, NULL, 1)

		COMMIT TRANSACTION
		SET @B_Result = 1
		SET @T_Message = 'La operaci�n se realiz� con �xito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10))
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_U_GrabarDatosUsuario' AND ROUTINE_TYPE = 'PROCEDURE')
	DROP PROCEDURE [dbo].[USP_U_GrabarDatosUsuario]
GO

CREATE PROCEDURE [dbo].[USP_U_GrabarDatosUsuario]
	@I_DatosUsuarioID	int	= NULL
	,@N_NumDoc			varchar(15)
	,@T_NomPersona		varchar(250)
	,@T_CorreoUsuario	varchar(100)
	,@I_DependenciaID	int
	,@D_FecRegistro		datetime
	,@B_Habilitado		bit
	,@UserId			int = NULL

	,@CurrentUserId		int
	,@B_Result			bit OUTPUT
	,@T_Message			nvarchar(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRANSACTION
	BEGIN TRY
		UPDATE  TC_Usuario
			SET I_DependenciaID = @I_DependenciaID,
				D_FecActualiza = @D_FecRegistro,
				I_UsuarioMod = @CurrentUserId
		  WHERE	
				UserId = @UserId

		UPDATE  TC_DatosUsuario 
			SET	N_NumDoc = @N_NumDoc, 
				T_NomPersona = @T_NomPersona, 
				T_CorreoUsuario = @T_CorreoUsuario, 
				D_FecActualiza = @D_FecRegistro,
				B_Habilitado = @B_Habilitado
			WHERE
				I_DatosUsuarioID = @I_DatosUsuarioID
			
		IF(@UserId IS NOT NULL)
		BEGIN
			IF NOT EXISTS(SELECT * FROM TI_UsuarioDatosUsuario WHERE UserId = @UserId AND I_DatosUsuarioID = @I_DatosUsuarioID)
			BEGIN
				INSERT INTO TI_UsuarioDatosUsuario(UserId, I_DatosUsuarioID, D_FecAlta, D_FecBaja, B_Habilitado)
					VALUES(@UserId, @I_DatosUsuarioID, @D_FecRegistro, NULL, 1)
			END
			ELSE
			BEGIN
				UPDATE	TI_UsuarioDatosUsuario
					SET	B_Habilitado = 0,
						D_FecBaja = @D_FecRegistro					
					WHERE	UserId = @UserId
						AND B_Habilitado = 1

				UPDATE	TI_UsuarioDatosUsuario 
				SET		B_Habilitado = 1,
						D_FecAlta = @D_FecRegistro
				WHERE	UserId = @UserId 
						AND I_DatosUsuarioID = @I_DatosUsuarioID
			END
		END						

		COMMIT TRANSACTION
		SET @B_Result = 1
		SET @T_Message = 'La operaci�n se realiz� con �xito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10))
	END CATCH
END
GO



/*-------------------------- */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_I_GrabarEntidadFinanciera')
	DROP PROCEDURE [dbo].[USP_I_GrabarEntidadFinanciera]
GO

CREATE PROCEDURE [dbo].[USP_I_GrabarEntidadFinanciera]
	 @I_EntidadFinanID	int
	,@T_EntidadDesc		varchar(250)
	,@B_Habilitado		bit
	,@D_FecCre			datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
	BEGIN TRANSACTION
  	BEGIN TRY
		
		INSERT INTO TC_EntidadFinanciera(T_EntidadDesc, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
								VALUES	 (@T_EntidadDesc, @B_Habilitado, 0, @CurrentUserId, @D_FecCre)

		SET @I_EntidadFinanID = SCOPE_IDENTITY();

		INSERT INTO TI_TipoArchivo_EntidadFinanciera(I_EntidadFinanID, I_TipoArchivoID, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
							SELECT @I_EntidadFinanID, I_TipoArchivoID, 0, 0, @CurrentUserId, @D_FecCre
							FROM TC_TipoArchivo

		COMMIT TRANSACTION

		SET @B_Result = 1
		SET @T_Message = 'Nuevo registro agregado.'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarEntidadFinanciera')
	DROP PROCEDURE [dbo].[USP_U_ActualizarEntidadFinanciera]
GO

CREATE PROCEDURE [dbo].[USP_U_ActualizarEntidadFinanciera]
	 @I_EntidadFinanID	int
	,@T_EntidadDesc		varchar(250)
	,@B_Habilitado		bit
	,@D_FecMod  		datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
	UPDATE	TC_EntidadFinanciera 
		SET	T_EntidadDesc = @T_EntidadDesc
			, B_Habilitado = @B_Habilitado
			, I_UsuarioMod = @CurrentUserId
			, D_FecMod = @D_FecMod
		WHERE I_EntidadFinanID = @I_EntidadFinanID
			
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH

END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarEstadoEntidadFinanciera')
	DROP PROCEDURE [dbo].[USP_U_ActualizarEstadoEntidadFinanciera]
GO

CREATE PROCEDURE [dbo].[USP_U_ActualizarEstadoEntidadFinanciera]
	 @I_EntidadFinanID	int
	,@B_Habilitado		bit
	,@D_FecMod			datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
		UPDATE	TC_EntidadFinanciera 
		SET		B_Habilitado = @B_Habilitado,
				I_UsuarioMod = @CurrentUserId,
				D_FecMod = @D_FecMod
				WHERE	I_EntidadFinanID = @I_EntidadFinanID
			
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos de correo correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_I_GrabarTipoArchivosEntidadFinanciera')
	DROP PROCEDURE [dbo].[USP_I_GrabarTipoArchivosEntidadFinanciera]
GO

CREATE PROCEDURE [dbo].[USP_I_GrabarTipoArchivosEntidadFinanciera]
	 @I_EntidadFinanID	int
	,@D_FecCre			datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
		INSERT INTO TI_TipoArchivo_EntidadFinanciera(I_EntidadFinanID, I_TipoArchivoID, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
							SELECT @I_EntidadFinanID, I_TipoArchivoID, 0, 0, @CurrentUserId, @D_FecCre
							FROM TC_TipoArchivo

		SET @B_Result = 1
		SET @T_Message = 'Nuevo registro agregado.'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO


/*-------------------------- */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_I_GrabarCuentaDeposito')
	DROP PROCEDURE [dbo].[USP_I_GrabarCuentaDeposito]
GO

CREATE PROCEDURE [dbo].[USP_I_GrabarCuentaDeposito]
	 @I_CtaDepositoID	int
	,@I_EntidadFinanID	int
	,@C_NumeroCuenta	varchar(50)
	,@T_Observacion		varchar(500)
	,@D_FecCre			datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
		INSERT INTO TC_CuentaDeposito(I_EntidadFinanID, C_NumeroCuenta, T_Observacion, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
								VALUES	 (@I_EntidadFinanID, @C_NumeroCuenta, @T_Observacion, 1, 0, @CurrentUserId, @D_FecCre)

		SET @B_Result = 1
		SET @T_Message = 'Nuevo registro agregado.'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH

END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarCuentaDeposito')
	DROP PROCEDURE [dbo].[USP_U_ActualizarCuentaDeposito]
GO

CREATE PROCEDURE [dbo].[USP_U_ActualizarCuentaDeposito]
	 @I_CtaDepositoID	int
	,@I_EntidadFinanID	int
	,@C_NumeroCuenta	varchar(50)
	,@T_Observacion		varchar(500)
	,@D_FecMod			datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
	UPDATE	TC_CuentaDeposito 
		SET	C_NumeroCuenta = @C_NumeroCuenta
			, I_EntidadFinanID = @I_EntidadFinanID
			, T_Observacion = @T_Observacion
		WHERE I_CtaDepositoID = @I_CtaDepositoID
			
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH

END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarEstadoCuentaDeposito')
	DROP PROCEDURE [dbo].[USP_U_ActualizarEstadoCuentaDeposito]
GO

CREATE PROCEDURE [dbo].[USP_U_ActualizarEstadoCuentaDeposito]
	 @I_CtaDepositoID	int
	,@B_Habilitado		bit
	,@D_FecMod			datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
		UPDATE	TC_CuentaDeposito 
		SET		B_Habilitado = @B_Habilitado,
				D_FecMod = @D_FecMod,
				I_UsuarioMod = @CurrentUserId
				WHERE	I_CtaDepositoID = @I_CtaDepositoID
			
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos de correo correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO


/*-------------------------- */

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_I_GrabarClasificadorIngreso')
	DROP PROCEDURE [dbo].[USP_I_GrabarClasificadorIngreso]
GO

CREATE PROCEDURE [dbo].[USP_I_GrabarClasificadorIngreso]
	 @I_ClasificadorID		int
	,@T_ClasificadorDesc	varchar(250)
	,@T_ClasificadorCod		varchar(50)
	,@T_ClasificadorUnfv	varchar(50)
	,@N_Anio			varchar(4)
	,@D_FecCre			datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
		INSERT INTO TC_ClasificadorIngreso(T_ClasificadorDesc,T_ClasificadorCod, T_ClasificadorUnfv, N_Anio, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
								VALUES	 (@T_ClasificadorDesc, @T_ClasificadorCod,@T_ClasificadorUnfv, @N_Anio, 1, 0, @CurrentUserId, @D_FecCre)

		SET @B_Result = 1
		SET @T_Message = 'Nuevo registro agregado.'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH

END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarClasificadorIngreso')
	DROP PROCEDURE [dbo].[USP_U_ActualizarClasificadorIngreso]
GO

CREATE PROCEDURE [dbo].[USP_U_ActualizarClasificadorIngreso]
	 @I_ClasificadorID		int
	,@T_ClasificadorDesc	varchar(250)
	,@T_ClasificadorCod		varchar(50)
	,@T_ClasificadorUnfv	varchar(50)
	,@N_Anio			varchar(4)
	,@D_FecMod			datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
	UPDATE	TC_ClasificadorIngreso 
		SET	T_ClasificadorDesc = @T_ClasificadorDesc
			,T_ClasificadorCod = @T_ClasificadorCod
			,T_ClasificadorUnfv = @T_ClasificadorUnfv
			,N_Anio = @N_Anio
			, D_FecMod = @D_FecMod
			, I_UsuarioMod = @CurrentUserId
		WHERE I_ClasificadorID = @I_ClasificadorID
			
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH

END
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_U_ActualizarEstadoClasificadorIngreso')
	DROP PROCEDURE [dbo].[USP_U_ActualizarEstadoClasificadorIngreso]
GO

CREATE PROCEDURE [dbo].[USP_U_ActualizarEstadoClasificadorIngreso]
	 @I_ClasificadorID		int
	,@B_Habilitado		bit
	,@D_FecMod			datetime
	,@CurrentUserId		int

	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT	
AS
BEGIN
  SET NOCOUNT ON
  	BEGIN TRY
		UPDATE	TC_ClasificadorIngreso 
		SET		B_Habilitado = @B_Habilitado,
				D_FecMod = @D_FecMod,
				I_UsuarioMod = @CurrentUserId
				WHERE I_ClasificadorID = @I_ClasificadorID
			
		SET @B_Result = 1
		SET @T_Message = 'Actualizaci�n de datos de correo correcta'
	END TRY
	BEGIN CATCH
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO


/*-----------------------------------------------------------*/

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_NAME = 'type_dataMatricula')
	DROP TYPE [dbo].[type_dataMatricula]
GO

CREATE TYPE [dbo].[type_dataMatricula] AS TABLE(
	C_CodRC			varchar(3)  NULL,
	C_CodAlu		varchar(10) NULL,
	I_Anio			int			NULL,
	C_Periodo		char(1)		NULL,
	C_EstMat		varchar(2)  NULL,
	C_Ciclo			varchar(2)  NULL,
	B_Ingresante	bit	NULL
)
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME = 'USP_IU_GrabarMatricula')
	DROP PROCEDURE [dbo].[USP_IU_GrabarMatricula]
GO

CREATE PROCEDURE [dbo].[USP_IU_GrabarMatricula]
(
	 @Tbl_Matricula	[dbo].[type_dataMatricula]	READONLY
	,@D_FecRegistro datetime

	,@UserID			int
	,@B_Result		bit				OUTPUT
	,@T_Message		nvarchar(4000)	OUTPUT
)
AS
BEGIN
	SET NOCOUNT ON
	BEGIN TRY

		DECLARE @errors int = 0
		DECLARE @Codigos varchar(500) 

		-- comprobar que el archivo no tiene filas con codigos de alumno repetidos
		IF EXISTS (SELECT C_CodAlu FROM @Tbl_Matricula GROUP BY C_CodAlu HAVING COUNT(C_CodAlu) > 1)
		BEGIN
			SET @errors += 1
					
			SELECT @Codigos = COALESCE(@Codigos + ', ', '') + C_CodAlu  
			FROM @Tbl_Matricula GROUP BY C_CodAlu HAVING COUNT(C_CodAlu) > 1

			SET @T_Message = 'El archivo tiene codigos repetidos: ' + @Codigos + '.'
		END

		IF(@errors = 0)
		BEGIN
			BEGIN TRANSACTION
			
			DECLARE @Tbl_Actions AS TABLE( T_Action varchar(10), T_Codigo varchar(10))

			SELECT m.C_CodRC, m.C_CodAlu, m.I_Anio, c.I_OpcionID AS I_Periodo, m.C_EstMat, m.C_Ciclo, m.B_Ingresante
			INTO #Tmp_Matricula FROM @Tbl_Matricula AS m
			INNER JOIN dbo.TC_CatalogoOpcion c ON c.I_ParametroID = 5 AND c.T_OpcionCod = m.C_Periodo

			MERGE INTO TC_MatriculaAlumno AS TRG
			USING #Tmp_Matricula AS SRC
			ON TRG.C_CodRc = SRC.C_CodRc AND TRG.C_CodAlu = SRC.C_CodAlu AND TRG.I_Anio = SRC.I_Anio AND TRG.I_Periodo = SRC.I_Periodo
			WHEN MATCHED THEN
			 		UPDATE SET   C_EstMat = SRC.C_EstMat
			 	  				, C_Ciclo = SRC.C_Ciclo
								, B_Ingresante = SRC.B_Ingresante
								, I_UsuarioMod = @UserID
								, D_FecMod = @D_FecRegistro
			WHEN NOT MATCHED BY TARGET THEN INSERT (C_CodRc, C_CodAlu, I_Anio, I_Periodo, C_EstMat, C_Ciclo, B_Ingresante, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
			 	  							VALUES (SRC.C_CodRc, SRC.C_CodAlu, SRC.I_Anio, SRC.I_Periodo, SRC.C_EstMat, SRC.C_Ciclo, SRC.B_Ingresante, 1, 0, @UserID, @D_FecRegistro)
			OUTPUT $action AS accion, inserted.C_CodAlu as codigo INTO @Tbl_Actions;

			COMMIT TRANSACTION

			SET @B_Result = 1
			SET @T_Message = 'La importaci�n de datos de alumno finaliz� de manera exitosa'
		END
		ELSE
		BEGIN
			SET @B_Result = 0
			SET @T_Message = 'Se encontraron problemas en el archivo. <ul>' + @T_Message + '</ul>'
		END
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10)) 
	END CATCH
END
GO




/*-----------------------------------------------------------*/

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.DOMAINS WHERE DOMAIN_NAME = 'type_roles' AND DATA_TYPE = 'table type')
BEGIN
	IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_I_GrabarDocumentacionUsuario' AND ROUTINE_TYPE = 'PROCEDURE')
		DROP PROCEDURE [dbo].[USP_I_GrabarDocumentacionUsuario]

	IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_U_GrabarDocumentacionUsuario' AND ROUTINE_TYPE = 'PROCEDURE')
		DROP PROCEDURE [dbo].[USP_U_GrabarDocumentacionUsuario]

	DROP TYPE [dbo].[type_roles]
END
GO


CREATE TYPE [dbo].[type_roles] AS TABLE(
	RoleId			int  NULL ,
	RoleName		varchar(50)  NULL ,
	B_Habilitado	bit  NULL
)
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_I_GrabarDocumentacionUsuario' AND ROUTINE_TYPE = 'PROCEDURE')
	DROP PROCEDURE [dbo].[USP_I_GrabarDocumentacionUsuario]
GO

CREATE PROCEDURE [dbo].[USP_I_GrabarDocumentacionUsuario]
(
	@I_RutaDocID		int
	,@T_DocDesc			varchar(200)
	,@T_RutaDocumento	nvarchar(4000)
	,@Tbl_Roles			[dbo].[type_roles] READONLY
	,@I_UserID			int

	,@B_Result			bit OUTPUT
	,@T_Message			nvarchar(4000) OUTPUT
)
AS
BEGIN
	
	BEGIN TRANSACTION
	BEGIN TRY
		
		INSERT INTO [dbo].[TS_RutaDocumentacion] (T_DocDesc, T_RutaDocumento, B_Habilitado, B_Eliminado, D_FecCre, I_UsuarioCre) 
			VALUES ( @T_DocDesc, @T_RutaDocumento, 1, 0, GETDATE(), @I_UserID)
			
		SET @I_RutaDocID = IDENT_CURRENT('TS_RutaDocumentacion')

		--EXEC USP_U_GrabarHistorialRegistroUsuario @I_UserID, 17, 'TS_RutaDocumentacion'

		INSERT INTO [dbo].[TS_DocumentosRoles] (I_RutaDocID, RoleId, B_Habilitado, B_Eliminado, D_FecCre, I_UsuarioCre)
				SELECT	@I_RutaDocID, RoleId, B_Habilitado,  0, GETDATE(), @I_UserID
				FROM @Tbl_Roles

		--EXEC USP_U_GrabarHistorialRegistroUsuario @I_UserID, 17, 'TS_DocumentosRoles'

		SET @B_Result = 1
		SET @T_Message = 'La operaci�n se realiz� correctamente.'

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10))
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_U_GrabarDocumentacionUsuario' AND ROUTINE_TYPE = 'PROCEDURE')
	DROP PROCEDURE [dbo].[USP_U_GrabarDocumentacionUsuario]
GO

CREATE PROCEDURE [dbo].[USP_U_GrabarDocumentacionUsuario]
(
	@I_RutaDocID		tinyint
	,@T_DocDesc			varchar(200)
	,@T_RutaDocumento	nvarchar(4000)
	,@Tbl_Roles			[dbo].[type_roles] READONLY
	,@I_UserID			int

	,@B_Result			bit OUTPUT
	,@T_Message			nvarchar(4000) OUTPUT
)
AS
BEGIN
	
	BEGIN TRANSACTION
	BEGIN TRY

		UPDATE [dbo].[TS_RutaDocumentacion]
			SET T_DocDesc = @T_DocDesc
				,T_RutaDocumento = @T_RutaDocumento
				,D_FecMod = GETDATE()
				,I_UsuarioMod = @I_UserID
			WHERE I_RutaDocID = @I_RutaDocID

		--EXEC USP_U_GrabarHistorialRegistroUsuario @I_UserID, 17, 'TS_RutaDocumentacion'

		MERGE  [dbo].[TS_DocumentosRoles]
		USING  @Tbl_Roles AS roles
		ON	roles.RoleId = [dbo].[TS_DocumentosRoles].[RoleId]
			AND [dbo].[TS_DocumentosRoles].[I_RutaDocID] = @I_RutaDocID
		WHEN MATCHED THEN
			UPDATE SET [dbo].[TS_DocumentosRoles].[B_Habilitado] = roles.B_Habilitado
				,[dbo].[TS_DocumentosRoles].[D_FecMod] = GETDATE()
				,[dbo].[TS_DocumentosRoles].[I_UsuarioMod] = @I_UserID

		WHEN NOT MATCHED BY TARGET THEN
			INSERT (I_RutaDocID, RoleId, B_Habilitado, B_Eliminado, D_FecCre, I_UsuarioCre)
			VALUES (@I_RutaDocID, roles.RoleId, roles.B_Habilitado,  0, GETDATE(), @I_UserID);

		--EXEC USP_U_GrabarHistorialRegistroUsuario @I_UserID, 17, 'TS_DocumentosRoles'

		SET @B_Result = 1
		SET @T_Message = 'La operaci�n se realiz� correctamente.'

		COMMIT TRANSACTION
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10))
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_U_ActualizarEstadoArchivo' AND ROUTINE_TYPE = 'PROCEDURE')
	DROP PROCEDURE [dbo].[USP_U_ActualizarEstadoArchivo]
GO


CREATE PROCEDURE [dbo].[USP_U_ActualizarEstadoArchivo]
	 @I_RutaDocID	int
	,@B_Habilitado	bit

	,@IdUser int
	,@B_Result bit OUTPUT
	,@T_Message nvarchar(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON

	BEGIN TRANSACTION
	BEGIN TRY

		UPDATE	TS_RutaDocumentacion 
		SET		B_Habilitado = @B_Habilitado
		WHERE	I_RutaDocID = @I_RutaDocID

--		EXEC USP_U_GrabarHistorialRegistroUsuario @IdUser, 17, 'TS_RutaDocumentacion'

	COMMIT TRANSACTION
		SET @B_Result = 1
		SET @T_Message = 'La operaci�n se realiz� con �xito'
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION
		SET @B_Result = 0
		SET @T_Message = ERROR_MESSAGE() + ' LINE: ' + CAST(ERROR_LINE() AS varchar(10))
	END CATCH
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_S_DocumentacionUsuarioRoles' AND ROUTINE_TYPE = 'PROCEDURE')
	DROP PROCEDURE [dbo].[USP_S_DocumentacionUsuarioRoles]
GO


CREATE PROCEDURE [dbo].[USP_S_DocumentacionUsuarioRoles]
AS
BEGIN
	SET NOCOUNT ON
	SELECT RD.I_RutaDocID, RD.T_DocDesc, RD.T_RutaDocumento, RD.B_Habilitado, DR.RoleId, DR.B_Habilitado As B_DocRolHabilitado
	FROM TS_RutaDocumentacion RD
		 LEFT JOIN TS_DocumentosRoles DR ON RD.[I_RutaDocID] = DR.[I_RutaDocID]
END
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.ROUTINES WHERE ROUTINE_NAME = 'USP_IU_GenerarObligacionesPregrado_X_Ciclo' AND ROUTINE_TYPE = 'PROCEDURE')
	DROP PROCEDURE [dbo].[USP_IU_GenerarObligacionesPregrado_X_Ciclo]
GO


CREATE PROCEDURE [dbo].[USP_IU_GenerarObligacionesPregrado_X_Ciclo]
@I_Anio int,
@I_Periodo int,
@I_TipoAlumno int,
@I_UsuarioCre int,
@B_Result bit OUTPUT,
@T_Message nvarchar(4000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;
	--select * from dbo.TC_Parametro
	select * from dbo.TC_CatalogoOpcion where I_ParametroID = 1--tipo alumno
	select * from dbo.TC_CatalogoOpcion where I_ParametroID = 2--grado (nivel)
	select * from dbo.TC_CatalogoOpcion where I_ParametroID = 5--periodo
	select * from dbo.TC_CatalogoOpcion where I_ParametroID = 8--estados alumnos
	select * from dbo.TC_CategoriaPago

	DECLARE @Pregrado int = (select I_OpcionID from dbo.TC_CatalogoOpcion where I_ParametroID = 2 and T_OpcionCod = '1'),
			@MatriculaApta varchar(1) = (select T_OpcionCod from dbo.TC_CatalogoOpcion where I_ParametroID = 8 and T_OpcionCod = 'S'),
			@C_Moneda varchar(3) = 'PEN',
			@D_CurrentDate datetime = GETDATE()

	--1ro Obtener los conceptos seg�n a�o y periodo
	select p.I_ProcesoID, p.I_CatPagoID, cp.I_Nivel, cp.I_TipoAlumno, p.I_Anio, p.I_Periodo,
		c.I_ConcPagID, cp.T_CatPagoDesc, c.M_Monto into #tmp_conceptos_pregrado
	from dbo.TC_Proceso p
	inner join dbo.TC_CategoriaPago cp on cp.I_CatPagoID = p.I_CatPagoID
	inner join dbo.TI_ConceptoPago c on c.I_ProcesoID = p.I_ProcesoID
	where p.B_Habilitado = 1 and p.B_Eliminado = 0 and
		cp.B_Habilitado = 1 and cp.B_Eliminado = 0 and cp.B_Obligacion = 1 and
		c.B_Habilitado = 1 and p.B_Eliminado = 0 and
		p.I_Anio = @I_Anio and p.I_Periodo = @I_Periodo and cp.I_Nivel = @Pregrado and cp.I_TipoAlumno = @I_TipoAlumno
		

	--drop table #tmp_conceptos_pregrado
	--select * from #tmp_conceptos_pregrado

	--2do Generar las oligaciones para alumnos regulares
	BEGIN TRAN
	BEGIN TRY
		
		insert dbo.TR_ObligacionAluCab(I_ProcesoID, I_MatAluID, C_Moneda, I_MontoOblig, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
		select DISTINCT c.I_ProcesoID, m.I_MatAluID, @C_Moneda, SUM(c.M_Monto), 1, 0, @I_UsuarioCre, @D_CurrentDate from dbo.TC_MatriculaAlumno m
		cross join #tmp_conceptos_pregrado c
		where m.I_Anio = 2021 and m.I_Periodo = 15 AND  m.C_EstMat = @MatriculaApta
		group by c.I_ProcesoID, m.I_MatAluID

		INSERT dbo.TR_ObligacionAluDet(I_ObligacionAluID, I_ConcPagID, I_Monto, B_Pagado, B_Habilitado, B_Eliminado, I_UsuarioCre, D_FecCre)
		select cab.I_ObligacionAluID, c.I_ConcPagID, c.M_Monto, 0, 1, 0,1 , getdate() from dbo.TC_MatriculaAlumno m
		cross join #tmp_conceptos_pregrado c
		inner join dbo.TR_ObligacionAluCab cab on cab.I_ProcesoID = c.I_ProcesoID and cab.I_MatAluID = m.I_MatAluID
		where m.I_Anio = 2021 and m.I_Periodo = 15 AND  m.C_EstMat = 'S'/*@MatriculaApta*/
		


		COMMIT TRAN
	END TRY
	BEGIN CATCH
		ROLLBACK TRAN
	END CATCH
END
GO



