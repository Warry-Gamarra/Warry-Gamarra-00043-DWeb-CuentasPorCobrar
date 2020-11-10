USE [BD_OCEF_CtasPorCobrar]
GO


/*------------------------------------------ Correos ---------------------------------------------------*/


INSERT INTO [dbo].[TS_CorreoAplicacion](T_DireccionCorreo, T_PasswordCorreo, T_Seguridad, T_HostName, I_Puerto, D_FecUpdate, B_Habilitado, B_Eliminado)
	 VALUES (N'wgamarra@unfv.edu.pe', N'WABIAFMATwBuAG8ASwAyAEAAMgAwADEANgA=', 'TLS', 'smtp.office365.com', 587, GETDATE(), 1, 0)
GO





/* -------------------------------- TC_TipoDocumento ------------------------------------ */

INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'RR', N'RESOL. RECTORAL', 1);
INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'RF', N'RESOL. DE FACULTAD', 1);
INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'RD', N'RESOL. DIRECTORAL', 1);
INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'PR', N'PROVEIDO', 1);
INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'OF', N'OFICIO', 1);
INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'OB', N'OBSERVACION', 1);
INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'RC', N'RESOL. VRAC', 1);
INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'RA', N'RESOL. VRAD', 1);
INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'AC', N'ACUERDO CONSEJO UNIV', 1);
INSERT INTO TC_TipoDocumento (C_DocCod, T_DocDesc, B_Habilitado) VALUES (N'MM', N'MEMORANDO', 1);
GO


/* -------------------------------- TC_TipoResolucion ------------------------------------ */

INSERT INTO TC_TipoResolucion (C_ResolucionCod,T_ResolucionDesc,B_Habilitado) VALUES (N'RD', N'RESOLUCION DIRECTORAL', 1)
INSERT INTO TC_TipoResolucion (C_ResolucionCod,T_ResolucionDesc,B_Habilitado) VALUES (N'RR', N'RESOLUCION RECTORAL', 1)
INSERT INTO TC_TipoResolucion (C_ResolucionCod,T_ResolucionDesc,B_Habilitado) VALUES (N'RF', N'RESOLUCION DE FACULTAD', 1)
GO


/* -------------------------------- TC_TipoPeriodo ------------------------------------ */
INSERT INTO TC_TipoPeriodo (T_TipoPerDesc, I_Prioridad, B_Habilitado, B_Eliminado) VALUES (N'MATRICULA INGRESANTE PRE', 1, 1, 0)
INSERT INTO TC_TipoPeriodo (T_TipoPerDesc, I_Prioridad, B_Habilitado, B_Eliminado) VALUES (N'MATRICULA REGULAR PRE', 1, 1, 0)
INSERT INTO TC_TipoPeriodo (T_TipoPerDesc, I_Prioridad, B_Habilitado, B_Eliminado) VALUES (N'PEN.MA-ING-EUPG', 1, 1, 0)
INSERT INTO TC_TipoPeriodo (T_TipoPerDesc, I_Prioridad, B_Habilitado, B_Eliminado) VALUES (N'PEN.MA-REG-EUPG', 1, 1, 0)
INSERT INTO TC_TipoPeriodo (T_TipoPerDesc, I_Prioridad, B_Habilitado, B_Eliminado) VALUES (N'PEN.DO-ING-EUPG', 1, 1, 0)
INSERT INTO TC_TipoPeriodo (T_TipoPerDesc, I_Prioridad, B_Habilitado, B_Eliminado) VALUES (N'PEN.DO-REG-EUPG', 1, 1, 0)
GO


INSERT TC_EntidadFinanciera(T_EntidadDesc, B_Habilitado, B_Eliminado)values('BANCO DE COMERCIO', 1, 0)
INSERT TC_CuentaDeposito(I_EntidadFinanID, C_NumeroCuenta, B_Habilitado, B_Eliminado) VALUES(1, '110-01-0414438', 1, 0)
INSERT TC_CuentaDeposito_TipoPeriodo(I_CtaDepositoID, I_TipoPeriodoID, B_Habilitado, B_Eliminado) VALUES(1,1,1,0)


INSERT TC_Parametro(T_ParametroDesc, B_Habilitado, B_Eliminado) VALUES('TIPO ALUMNO', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(1, 'Alum. Regulares', '1', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(1, 'Alumn. Ingresantes', '2', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(1, 'Todos', '3', 1, 0)


INSERT TC_Parametro(T_ParametroDesc, B_Habilitado, B_Eliminado) VALUES('GRADO', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(2, 'Pre Grado', '1', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(2, 'Post.G.(Maestr�a)', '2', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(2, 'Post.G.(Doctorado)', '3', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(2, 'Sec.Post.G', '4', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(2, 'Todos', '5', 1, 0)


INSERT TC_Parametro(T_ParametroDesc, B_Habilitado, B_Eliminado) VALUES('TIPO OBLIGACI�N', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, B_Habilitado, B_Eliminado) VALUES(3, 'Matr�cula', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, B_Habilitado, B_Eliminado) VALUES(3, 'Otros pagos', 1, 0)



INSERT TC_Parametro(T_ParametroDesc, B_Habilitado, B_Eliminado) VALUES('CAMPO CALCULADO', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(4, 'Crd. Desaprobados', '1', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(4, 'Deudas Anteriores', '2', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(4, 'Pensi�n de ense�anza', '3', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(4, 'No Voto', '4', 1, 0)



INSERT TC_Parametro(T_ParametroDesc, B_Habilitado, B_Eliminado) VALUES('PERIODOS', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'ANUAL', 'A', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'REGULARIZ. CURSADA', 'G', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'SUBSANACION', 'S', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'EXAMENES EXTRAORDINA', 'E', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'SEMESTRAL (1)', '1', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'SEMESTRAL (2)', '2', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'NIVELACION', 'N', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'REGULARIZACION', 'R', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'APLAZADOS', 'L', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'VERANO O VACACIONAL', 'V', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'CARGO', 'C', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'CONVALIDACION', 'D', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'APLAZADOS', 'P', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'COMPLEMENTACION ACAD', 'M', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'SUBSANACION (COMPLE)', 'B', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'ADELANTO', '0', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'RECONOCIMIENTO', 'T', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'CONV.MOVIL.ESTUDIANT', 'K', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'CICLO ESPECIAL', 'Z', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'CICLO EXTRAORDINARIO', 'X', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'ADELANTO EXTRAORDINA', 'I', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'ESPECIAL CECCPUE', 'W', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(5, 'EVALUACION ESPECIAL', 'U', 1, 0)





INSERT TC_Parametro(T_ParametroDesc, B_Habilitado, B_Eliminado) VALUES('GRUPO COD_RC', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(6, 'GRUPO 1', '1', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(6, 'GRUPO 2', '2', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(6, 'GRUPO 3', '3', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(6, 'GRUPO 4', '4', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(6, 'GRUPO P', 'P', 1, 0)



INSERT TC_Parametro(T_ParametroDesc, B_Habilitado, B_Eliminado) VALUES('COD INGRESO', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'ADMISION ORDINARIA', 'AD', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'BACHILLER FAP (COMPLEMENTACION', 'BF', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONV.COOP. Y COORD. TECN.ACAD.', 'CY', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'PAGANTES-INGRESANTES CONVENIOS', 'PA', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'BACHILLER (OPTAR TITULO)', 'OT', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CENEPA', 'CC', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CENEPA E HIJOS C.TER', 'CN', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CEPREVI', 'CE', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO COMPUTRONIC', 'CT', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO EJERCITO PERUANO', 'CP', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO EMCH', 'CM', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO EMCH-TRASLADO EXTERNO', 'MT', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO EP - BACH. ENFERMERIA', 'PB', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO EP - ENFERMERIA', 'PE', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO EP - SEGUNDA PROFESION', 'PS', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO EUPG-COINDE', 'CI', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO EXTERNO INTERNACIONAL', 'CX', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO FAP - COMPL. BACH.', 'FB', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO FAP-SEGUNDA PROFESION', 'FS', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO FUERZA AEREA DEL PERU', 'CF', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO PNP-SEGUNDA PROFESION', 'LS', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO POLICIA NAC. DEL PERU', 'CL', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'EDUCACION A DISTANCIA', 'ED', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'HEROES DEL CENEPA', 'HC', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'HIJOS - VICT. DE TERRORISMO', 'HT', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'MEJORES DEPORTISTAS', 'MD', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'OTROS CONVENIOS', 'CO', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'PERSONAS CON DISCAPACIDAD', 'PD', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST GRADO', 'PG', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST GRADO (HOSPITAL B-C)', 'BC', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST GRADO (ICTE)', 'IC', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO (C.HOSP.DANIEL CAR)', 'HA', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO (CONV.REG.DE SALUD)', 'GH', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO (CONVENIO UNFV-CAL)', 'CA', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO (DEVIDA)', 'DP', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO (FAP)', 'PF', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO (HOSP. 2 DE MAYO)', 'DM', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO (HOSP. STA. ROSA)', 'HS', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO CON.INST.SALUD NI�O', 'HN', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO SALUD I-C', 'DS', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO SALUD III-CALLAO', 'DC', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO(CONV. MINIST.JUSTIC', 'MJ', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO(CONV.CONT.PUBL.PUN)', 'DA', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO(INST.ESP.MATER.PER)', 'MP', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'PRIMEROS PUESTOS', 'PP', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'PROCAE', 'PC', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'PROCUNED', 'PR', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'PROLICED', 'PL', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'REGULARIZACION POR COBERTURA', 'RC', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'SEGUNDA ESPECIALIDAD', 'SG', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'SEGUNDA PROFESION', 'SP', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'TRASLADO EXTERNO', 'TE', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'TRASLADO EXTERNO (UNIV. NAC.)', 'TN', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'TRASLADO EXTERNO (UNIV. PART.)', 'TP', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'TRASLADO INTERNO', 'TI', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'TRASLADOS', 'TR', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'BACHILLERATO DE ENFERMERIA', 'BE', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO(DISA IV-LIMA-ESTE)', 'CD', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO EP - ENFERMERIA', 'EE', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CONVENIO INTERN.(ANDRES BELLO)', 'CB', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO(C.MED-CO.REG.XVIII)', 'CR', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO(DISA III-HOP.CHANC)', 'IH', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO (ESSALUD-C.R.CAST.)', 'RT', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO(C.MED-HOS.GRAU III)', 'HG', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'SEMIPRESENCIAL Y VIRTUAL', 'SV', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'SEMIPRESENCIAL', 'SM', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO <HOSP. ALMENARA>', 'RA', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'EX.ADM.CADETES EMCH 2004', 'EA', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'EXONERADO POR GRADO-TITULO', 'EX', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'P.A. DE MOVILIDAD ESTUDIANTIL', 'ME', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'PLAN INTEGRAL DE REPARACION', 'PI', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'APTITUD FISICA', 'AF', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'OPTAR GRADO ACADEMICO', 'OG', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'REUBICADO', 'RU', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'CAMBIO DE ESPECIALIDAD', 'BO', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'POST-GRADO (COLEG.ARQ.C.R.HUA)', 'HU', 1, 0)
INSERT TC_CatalogoOpcion(I_ParametroID, T_OpcionDesc, T_OpcionCod, B_Habilitado, B_Eliminado) VALUES(7, 'REGULARIZ.DE INGRESO', 'RI', 1, 0)



INSERT TC_ConceptoPago(T_ConceptoDesc, B_Habilitado, B_Eliminado) VALUES('MATRICULA PREGRADO REGULAR', 1, 0)
GO



SELECT * FROM TC_Parametro WHERE I_ParametroID = 7
SELECT * FROM TC_CatalogoOpcion WHERE I_ParametroID = 7

SELECT * FROM TC_ConceptoPago
SELECT c.* FROM TI_ConceptoPago_Periodo c where c.B_Eliminado = 0 

