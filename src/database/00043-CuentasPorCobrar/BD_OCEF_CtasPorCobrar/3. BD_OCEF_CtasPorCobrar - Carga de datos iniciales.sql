USE [BD_OCEF_CtasPorCobrar]
GO


/*------------------------------------------ Correos ---------------------------------------------------*/


INSERT INTO [dbo].[TS_CorreoAplicacion](T_DireccionCorreo, T_PasswordCorreo, T_Seguridad, T_HostName, I_Puerto, D_FecUpdate, B_Habilitado, B_Eliminado)
	 VALUES (N'wgamarra@unfv.edu.pe', N'WABIAFMATwBuAG8ASwAyAEAAMgAwADEANgA=', 'TLS', 'smtp.office365.com', 587, GETDATE(), 1, 0)
GO


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



/* -------------------------------- TC_CategoriaPago ------------------------------------ */

INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'MIGRADO (CATEGORIA TEMPORAL)', 10, 1, 8, 3, 0, 0)

INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'MATR�CULA PREGRADO INGRESANTE', 1, 1, 4, 2, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'MATR�CULA PREGRADO REGULAR', 1, 1, 4, 1, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'MATR�CULA EUPG MAESTR�A INGRESANTE', 1, 1, 5, 2, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'MATR�CULA EUPG MAESTR�A REGULAR', 1, 1, 5, 1, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'MATR�CULA EUPG DOCTORADO INGRESANTE', 1, 1, 6, 2, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'MATR�CULA EUPG DOCTORADO REGULAR', 1, 1, 6, 1, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'PENSI�N EUPG MAESTR�A INGRESANTE', 2, 1, 5, 2, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'PENSI�N EUPG MAESTR�A REGULAR', 2, 1, 5, 1, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'PENSI�N EUPG DOCTORADO INGRESANTE', 2, 1, 6, 2, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'PENSI�N EUPG DOCTORADO REGULAR', 2, 1, 6, 1, 1, 0)

INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'OTROS PAGOS PREGRADO INGRESANTE', 2, 1, 4, 2, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'OTROS PAGOS PREGRADO REGULAR', 2, 1, 4, 1, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'OTROS PAGOS EUPG INGRESANTE', 2, 1, 7, 2, 1, 0)
INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'OTROS PAGOS EUPG REGULAR', 2, 1, 7, 1, 1, 0)

INSERT INTO TC_CategoriaPago (T_CatPagoDesc, I_Prioridad, B_Obligacion, I_Nivel, I_TipoAlumno, B_Habilitado, B_Eliminado) VALUES (N'SERVICIO DE SALUD', 2, 1, 6, 1, 1, 0)

GO


INSERT TC_EntidadFinanciera(T_EntidadDesc, B_Habilitado, B_Eliminado)values('BANCO DE COMERCIO', 1, 0)
INSERT TC_EntidadFinanciera(T_EntidadDesc, B_Habilitado, B_Eliminado)values('BANCO DE CR�DITO', 1, 0)

INSERT TC_CuentaDeposito(I_EntidadFinanID, C_NumeroCuenta, B_Habilitado, B_Eliminado) VALUES(1, '110-01-0414438', 1, 0)
INSERT TC_CuentaDeposito(I_EntidadFinanID, C_NumeroCuenta, B_Habilitado, B_Eliminado) VALUES(2, '119-104146435-1-01', 1, 0)

INSERT TC_CuentaDeposito_CategoriaPago(I_CtaDepositoID, I_CatPagoID, B_Habilitado, B_Eliminado) VALUES(1,1,1,0)
INSERT TC_CuentaDeposito_CategoriaPago(I_CtaDepositoID, I_CatPagoID, B_Habilitado, B_Eliminado) VALUES(2,1,1,0)



/*------------------------------------ Dependencias ------------------------------------*/
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('000000','0000000000','ADMINISTRACION CENTRAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010000','03000OGREC','RECTORADO',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010007','03091APREC','OFICINA DE ACREDITACION',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010100','03010OCREC','OFICINA GENERAL DE AUDITORIA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010200','03020ASREC','OFICINA CENTRAL DE PLANIFICACION',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010300','03040RNREC','OFICINA CENTRAL DE RELACIONES NACIONALES E INTERNACIONES',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010400','03030ASREC','OFICINA CENTRAL JURIDICO LEGAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010500','03050ASREC','SECRETARIA GENERAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010600','03060APREC','OFICINA CENTRAL DE COMUNICACI�N E IMAGEN INSTITUCIONAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010700','03070APREC','OFICINA CENTRAL DE BIENESTAR UNIVERSITARIO',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010800','03080APREC','CENTRO UNIVERSITARIO DE COMPUTO E INFORMATICA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010901','03140DCREC','CENTRO PRE UNIVERSITARIO VILLARREAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('010902','04010ODREC','EDITORIAL UNIVERSITARIA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('011000','03100DCREC','ESCUELA UNIVERSITARIA DE POST GRADO',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('011100','','CENTRO UNIVERSITARIO INVESTIGACION Y PROYECCION NACIONAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('011104','04020ODREC','FONDO DOCUMENTARIO DE LA CULTURA PERUANA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('011200','','CENTRO UNIVERSITARIO RELACION, GESTION Y ACCION SOCIAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('011300','03130DCREC','CENTRO DE EXTENSION UNIVERSITARIA Y PROYECCION SOCIAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('011302','04060APVAC','INSTITUTO DE IDIOMAS',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('011400','03110DCREC','ESCUELA UNIVERSITARIA DE EDUCACION .A DISTANCIA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('011500','03120DCREC','CENTRO UNIVERSITARIO DE PRODUCCION DE BIENES Y SERVICIOS',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('020000','04000OGVAC','VICE RECTORADO ACADEMICO',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('020100','04010APVAC','OFICINA CENTRAL DE ADMISION',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('020200','04020APVAC','OFICINA CENTRAL DE ASUNTOS ACADEMICOS',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('020300','04030APVAC','OFICINA CENTRAL DE INVESTIGACION',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('020400','03150DCREC','CENTRO CULTURAL FEDERICO VILLARREAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('020500','04040APVAC','INSTITUTO CENTRAL DE RECREACION EDUCACION FISICA Y DEPORTES',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('020600','04050APVAC','OFICINA CENTRAL DE REGISTRO CENTRAL Y CENTRO DE COMPUTO',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('030000','05000OGVAD','VICE RECTORADO ADMINISTRATIVO',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('030100','05020APVAD','OFICINA CENTRAL DE RECURSOS HUMANOS',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('030200','05030APVAD','OFICINA CENTRAL DE LOGISTICA Y SERVICIOS GENERALES',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('030300','05010APVAD','OFICINA CENTRAL ECONOMICO FINANCIERA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('030500','05040APVAD','OFICINA DE INFRAESTRUCTURA Y DESARROLLO',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('039003','05050APVAD','OFICINA DE PATRIMONIO',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('100000','06020OLFAC','ARQUITECTURA Y URBANISMO',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('110000','06010OLFAC','ADMINISTRACION',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('120000','06030OLFAC','CIENCIAS ECONOMICAS',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('130000','06040OLFAC','CIENCIAS FINANCIERAS Y CONTABLES',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('140000','06050OLFAC','CIENCIAS NATURALES Y MATEMATICA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('150000','06060OLFAC','CIENCIAS SOCIALES',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('160000','06090OLFAC','HUMANIDADES',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('170000','06070OLFAC','DERECHO Y CIENCIA POLITICA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('180000','06080OLFAC','EDUCACION',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('190000','06100OLFAC','INGENIERIA CIVIL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('200000','06120OLFAC','INGENIERIA GEOGRAFICA Y AMBIENTAL',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('210000','06130OLFAC','INGENIERIA INDUSTRIAL Y SISTEMAS',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('220000','06140OLFAC','MEDICINA "HIPOLITO UNANUE"',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('230000','06150OLFAC','OCEANOGRAFIA, PESQUERIA Y CC.AA.',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('240000','06160OLFAC','ODONTOLOGIA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('250000','06170OLFAC','PSICOLOGIA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('260000','06180OLFAC','TECNOLOGIA MEDICA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('270000','06110OLFAC','INGENIERIA ELECTRONICA E INFORMATICA',1,0)
INSERT INTO TC_DependenciaUNFV (C_DepCod, C_DepCodPl, T_DepDesc, B_Habilitado, B_Eliminado) VALUES ('040000','06000OGVRI','VICERRECTORADO DE INVESTIGACION',1,0)
GO


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


--INSERT TC_ConceptoPago(T_ConceptoDesc, B_Habilitado, B_Eliminado) VALUES('MATRICULA PREGRADO REGULAR', 1, 0)
--GO

SET IDENTITY_INSERT TC_TipoArchivo ON;

INSERT INTO TC_TipoArchivo (I_TipoArchivoID, T_TipoArchivDesc, B_ArchivoEntrada, B_ArchivoSalida, B_Habilitado, B_Eliminado) VALUES (1, 'DATOS DE ALUMNO', 0, 1, 1, 0)
INSERT INTO TC_TipoArchivo (I_TipoArchivoID, T_TipoArchivDesc, B_ArchivoEntrada, B_ArchivoSalida, B_Habilitado, B_Eliminado) VALUES (2, 'RELACI�N DE OBLIGACIONES', 0, 1, 1, 0)
INSERT INTO TC_TipoArchivo (I_TipoArchivoID, T_TipoArchivDesc, B_ArchivoEntrada, B_ArchivoSalida, B_Habilitado, B_Eliminado) VALUES (3, 'PAGO DE OBLIGACIONES ', 1, 0, 1, 0)
INSERT INTO TC_TipoArchivo (I_TipoArchivoID, T_TipoArchivDesc, B_ArchivoEntrada, B_ArchivoSalida, B_Habilitado, B_Eliminado) VALUES (4, 'PAGO DE TASAS SIN OBLIGACIONES', 1, 0, 1, 0)

SET IDENTITY_INSERT TC_TipoArchivo OFF;


/*---------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/*														MIGRACION DE DATOS DEL TEMPORAL DE PAGOS										 */
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------------------------------*/

SET IDENTITY_INSERT TC_Proceso ON

INSERT INTO TC_Proceso (I_ProcesoID, I_CatPagoID, T_ProcesoDesc, I_Anio, I_Periodo, N_CodBanco, D_FecVencto, I_Prioridad, B_Mora, B_Migrado, B_Habilitado, B_Eliminado)
		SELECT CAST(CUOTA_PAGO AS INT), 1, DESCRIPCIO, CASE ISNUMERIC(LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),1,4))) WHEN 1 THEN SUBSTRING(LTRIM(DESCRIPCIO),1,4) ELSE 0 END, NULL, 
				CODIGO_BNC, FCH_VENC, PRIORIDAD, CASE C_MORA WHEN 'VERDADERO' THEN 1 ELSE 0 END, 1, 1, ELIMINADO
		FROM temporal_pagos.dbo.cp_des
		WHERE CUOTA_PAGO NOT IN (143, 330, 331, 438, 439)
		UNION 
		SELECT CAST(CUOTA_PAGO AS INT), 1, DESCRIPCIO, CASE ISNUMERIC(LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),1,4))) WHEN 1 THEN SUBSTRING(LTRIM(DESCRIPCIO),1,4) ELSE 0 END, NULL, 
				CODIGO_BNC, FCH_VENC, PRIORIDAD, CASE C_MORA WHEN 'VERDADERO' THEN 1 ELSE 0 END, 1, 1, ELIMINADO
		FROM temporal_pagos.dbo.cp_des
		WHERE CUOTA_PAGO IN (143, 330, 331, 438, 439) AND ELIMINADO = 0

SET IDENTITY_INSERT TC_Proceso OFF
GO


SET IDENTITY_INSERT TC_Concepto ON

INSERT INTO TC_Concepto (I_ConceptoID, T_ConceptoDesc, B_Habilitado, B_Eliminado) VALUES (0, 'MIGRADO', 0, 0)

SET IDENTITY_INSERT TC_Concepto OFF
GO
