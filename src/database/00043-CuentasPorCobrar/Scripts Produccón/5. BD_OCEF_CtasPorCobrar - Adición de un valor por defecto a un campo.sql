USE BD_OCEF_CtasPorCobrar
GO


ALTER TABLE dbo.TR_ObligacionAluDet ADD CONSTRAINT DEFAULT_MORA DEFAULT 0 FOR B_MORA;
GO