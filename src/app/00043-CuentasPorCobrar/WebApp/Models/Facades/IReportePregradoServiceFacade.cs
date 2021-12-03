﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApp.ViewModels;

namespace WebApp.Models.Facades
{
    public interface IReportePregradoServiceFacade
    {
        ReportePagosPregradoGeneralViewModel ReporteGeneral(DateTime fechaInicio, DateTime fechaFin, int? idEntidanFinanc, int? ctaDeposito);

        ReportePagosPregradoPorConceptoViewModel ReportePorConceptos(DateTime fechaInicio, DateTime fechaFin, int? idEntidanFinanc, int? ctaDeposito);

        ReportePorFacultadYConceptoViewModel ReportePorFacultadYConcepto(DateTime fechaInicio, DateTime fechaFin, int? idEntidanFinanc, int? ctaDeposito);

        ReporteConceptosPorFacultadViewModel ReporteConceptosPorFacultad(string codFac, DateTime fechaInicio, DateTime fechaFin, int? idEntidanFinanc, int? ctaDeposito);

        ReporteResumenAnualPagoObligaciones_X_Clasificadores ResumenAnualPagoOblig_X_Clasificadores(int anio, int? entidadFinanID, int? ctaDepositoID);

        ReporteResumenAnualPagoObligaciones_X_Dependencias ResumenAnualPagoOblig_X_Dependencias(int anio, int? entidadFinanID, int? ctaDepositoID);

        IEnumerable<EstadoObligacionViewModel> EstadoObligacionAlumnos(int anio, int? periodo, string codFac, string codEsc, string codRc, bool? esIngresante, bool? estaPagado, bool? obligacionGenerada, 
            DateTime? fechaInicio, DateTime? fechaFin, string codAlu);
    }
}