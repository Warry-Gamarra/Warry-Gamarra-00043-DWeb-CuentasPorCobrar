USE [BD_OCEF_CtasPorCobrar]
GO

/*
Generación de obligaciones para: GALVAN ANDAMAYO, HARVIN JOEL.
*/

declare @B_Result bit,
		@T_Message nvarchar(4000)

exec USP_IU_GenerarObligacionesPosgrado_X_Ciclo 
	@I_Anio = 2021, 
	@I_Periodo = 20, 
	@C_CodEsc = NULL, 
	@C_CodAlu = '2015327375', 
	@C_CodRc = 'M18', 
	@I_UsuarioCre = 1, 
	@B_Result = @B_Result OUTPUT,
	@T_Message = @T_Message OUTPUT

select @B_Result, @T_Message
go
