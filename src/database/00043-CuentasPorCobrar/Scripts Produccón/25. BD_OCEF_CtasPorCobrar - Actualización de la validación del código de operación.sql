USE [BD_OCEF_CtasPorCobrar]
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO 
ALTER PROCEDURE [dbo].[USP_S_ValidarCodOperacionObligacion]  
@C_CodOperacion VARCHAR(50),  
@C_CodDepositante VARCHAR(20) = NULL,  
@I_EntidadFinanID INT,  
@D_FecPago DATETIME =  NULL,  
@I_ProcesoIDArchivo INT = NULL,
@D_FecVenctoArchivo DATE = NULL,
@B_Correct BIT OUTPUT  
AS  
BEGIN  
	SET NOCOUNT ON;  
  
	DECLARE @I_BcoComercio INT = 1,  
	@I_BcoCredito INT = 2  
  
	SET @B_Correct = 0  
  
	IF (@I_EntidadFinanID = @I_BcoComercio) BEGIN  
		SET @B_Correct = CASE WHEN EXISTS(SELECT p.I_PagoBancoID FROM dbo.TR_PagoBanco p  
			WHERE p.B_Anulado = 0 AND p.I_EntidadFinanID = @I_BcoComercio AND  
				C_CodOperacion = @C_CodOperacion AND p.I_TipoPagoID = 133) THEN 0 ELSE 1 END  
	END  
  
	IF (@I_EntidadFinanID = @I_BcoCredito) BEGIN  
		SET @B_Correct = CASE WHEN EXISTS(SELECT p.I_PagoBancoID FROM dbo.TR_PagoBanco p  
			WHERE p.B_Anulado = 0 AND p.I_EntidadFinanID = @I_BcoCredito AND 
				((NOT p.C_CodDepositante = @C_CodDepositante AND DATEDIFF(HOUR, p.D_FecPago, @D_FecPago) = 0 AND C_CodOperacion = @C_CodOperacion) 
				OR 
				(p.I_ProcesoIDArchivo = @I_ProcesoIDArchivo AND p.C_CodOperacion = @C_CodOperacion AND DATEDIFF(SECOND, p.D_FecPago, @D_FecPago) = 0 AND DATEDIFF(DAY, p.D_FecVenctoArchivo, @D_FecVenctoArchivo) = 0))
			) THEN 0 ELSE 1 END  
	END  
END
GO