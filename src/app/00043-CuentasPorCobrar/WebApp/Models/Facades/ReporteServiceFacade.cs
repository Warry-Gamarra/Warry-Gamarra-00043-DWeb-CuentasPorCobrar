﻿using Domain.Entities;
using Domain.Helpers;
using Domain.Services;
using Domain.Services.Implementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApp.ViewModels;

namespace WebApp.Models.Facades
{
    public class ReporteServiceFacade : IReporteServiceFacade
    {
        private IReporteUnfvService reporteService;
        private IEntidadRecaudadora entidadRecaudadoraService;
        private ICuentaDeposito cuentaDeposito;

        public ReporteServiceFacade()
        {
            entidadRecaudadoraService = new EntidadRecaudadora();
            cuentaDeposito = new CuentaDeposito();
        }

        public ReportePagosUnfvGeneralViewModel ReporteGeneral(DateTime fechaInicio, DateTime fechaFin, int? idEntidanFinanc, int? ctaDeposito, TipoEstudio tipoEstudio, out string tipoReporte)
        {
            string nombreColumnaDependencia;

            GetReporteService(tipoEstudio, out tipoReporte, out nombreColumnaDependencia);

            var pagos = reporteService.ReporteGeneral(fechaInicio, fechaFin, idEntidanFinanc, ctaDeposito);

            string nombreEntidadFinanc = idEntidanFinanc.HasValue ? entidadRecaudadoraService.Find(idEntidanFinanc.Value).Nombre : null;

            string numeroCuenta = ctaDeposito.HasValue ? cuentaDeposito.Find(ctaDeposito.Value).C_NumeroCuenta : null;

            var reporte = new ReportePagosUnfvGeneralViewModel(pagos)
            {
                FechaInicio = fechaInicio.ToString(FormatosDateTime.BASIC_DATE),
                FechaFin = fechaFin.ToString(FormatosDateTime.BASIC_DATE),
                Titulo = "Reporte de Pagos de " + tipoReporte,
                nombreEntidadFinanc = nombreEntidadFinanc,
                numeroCuenta = numeroCuenta,
                nombreColumnaDependencia = nombreColumnaDependencia
            };

            return reporte;
        }

        public ReportePagosUnfvPorConceptoViewModel ReportePorConceptos(DateTime fechaInicio, DateTime fechaFin, int? idEntidanFinanc, int? ctaDeposito, TipoEstudio tipoEstudio, out string tipoReporte)
        {
            string nombreColumnaDependencia;

            GetReporteService(tipoEstudio, out tipoReporte, out nombreColumnaDependencia);

            var pagos = reporteService.ReportePorConceptos(fechaInicio, fechaFin, idEntidanFinanc, ctaDeposito);

            string nombreEntidadFinanc = idEntidanFinanc.HasValue ? entidadRecaudadoraService.Find(idEntidanFinanc.Value).Nombre : null;

            string numeroCuenta = ctaDeposito.HasValue ? cuentaDeposito.Find(ctaDeposito.Value).C_NumeroCuenta : null;

            var reporte = new ReportePagosUnfvPorConceptoViewModel(pagos)
            {
                FechaInicio = fechaInicio.ToString(FormatosDateTime.BASIC_DATE),
                FechaFin = fechaFin.ToString(FormatosDateTime.BASIC_DATE),
                Titulo = "Reporte de Pago por Conceptos",
                nombreEntidadFinanc = nombreEntidadFinanc,
                numeroCuenta = numeroCuenta
            };

            return reporte;
        }

        public ReportePorDependenciaYConceptoViewModel ReportePorDependenciaYConcepto(DateTime fechaInicio, DateTime fechaFin, int? idEntidanFinanc, int? ctaDeposito, TipoEstudio tipoEstudio, out string tipoReporte)
        {
            string nombreColumnaDependencia;

            GetReporteService(tipoEstudio, out tipoReporte, out nombreColumnaDependencia);

            var pagos = reporteService.ReportePorDependenciaYConcepto(fechaInicio, fechaFin, idEntidanFinanc, ctaDeposito);

            string nombreEntidadFinanc = idEntidanFinanc.HasValue ? entidadRecaudadoraService.Find(idEntidanFinanc.Value).Nombre : null;

            string numeroCuenta = ctaDeposito.HasValue ? cuentaDeposito.Find(ctaDeposito.Value).C_NumeroCuenta : null;

            var reporte = new ReportePorDependenciaYConceptoViewModel(pagos)
            {
                FechaInicio = fechaInicio.ToString(FormatosDateTime.BASIC_DATE),
                FechaFin = fechaFin.ToString(FormatosDateTime.BASIC_DATE),
                Titulo = "Reporte de Pagos por " + nombreColumnaDependencia,
                nombreEntidadFinanc = nombreEntidadFinanc,
                numeroCuenta = numeroCuenta,
                nombreColumnaDependencia = nombreColumnaDependencia
            };

            return reporte;
        }

        public ReporteConceptosPorDependenciaViewModel ReporteConceptosPorDependencia(string codDep, DateTime fechaInicio, DateTime fechaFin, int? idEntidanFinanc, int? ctaDeposito, TipoEstudio tipoEstudio, out string tipoReporte)
        {
            string nombreColumnaDependencia;

            GetReporteService(tipoEstudio, out tipoReporte, out nombreColumnaDependencia);

            var pagos = reporteService.ReporteConceptosPorDependencia(codDep, fechaInicio, fechaFin, idEntidanFinanc, ctaDeposito);

            string nombreEntidadFinanc = idEntidanFinanc.HasValue ? entidadRecaudadoraService.Find(idEntidanFinanc.Value).Nombre : null;

            string numeroCuenta = ctaDeposito.HasValue ? cuentaDeposito.Find(ctaDeposito.Value).C_NumeroCuenta : null;

            var reporte = new ReporteConceptosPorDependenciaViewModel(pagos)
            {
                Dependencia = pagos.Count() > 0 ? pagos.FirstOrDefault().T_DependenciaDesc : "",
                FechaInicio = fechaInicio.ToString(FormatosDateTime.BASIC_DATE),
                FechaFin = fechaFin.ToString(FormatosDateTime.BASIC_DATE),
                Titulo = "Reporte de Pago de Conceptos por " + nombreColumnaDependencia,
                nombreEntidadFinanc = nombreEntidadFinanc,
                numeroCuenta = numeroCuenta,
                nombreColumnaDependencia = nombreColumnaDependencia
            };

            return reporte;
        }

        public IEnumerable<EstadoObligacionViewModel> EstadoObligacionAlumnos(ConsultaObligacionEstudianteViewModel parametro)
        {
            GetReporteService(parametro.tipoEstudio);

            var lista = reporteService.EstadoObligacionAlumnos(parametro.anio.Value, parametro.periodo, parametro.codFac, parametro.codEsc, parametro.codRc, parametro.esIngresante, parametro.estaPagado, parametro.obligacionGenerada,
                parametro.fechaInicio, parametro.fechaFin, parametro.codAlumno, parametro.nomAlumno, parametro.apePaternoAlumno, parametro.apeMaternoAlumno, parametro.dependencia);

            var result = lista.Select(x => Mapper.EstadoObligacionDTO_To_EstadoObligacionViewModel(x));

            return result;
        }

        private void GetReporteService(TipoEstudio tipoEstudio)
        {
            if (reporteService == null)
            {
                switch (tipoEstudio)
                {
                    case TipoEstudio.Pregrado:
                        reporteService = new ReportePregradoService();
                        break;

                    case TipoEstudio.Posgrado:
                        reporteService = new ReportePosgradoService();
                        break;

                    case TipoEstudio.Segunda_Especialidad:
                        reporteService = new ReporteSegundaEspecialidadService();
                        break;

                    case TipoEstudio.Residentado:
                        reporteService = new ReporteResidentadoService();
                        break;

                    default:
                        throw new NotImplementedException();
                }
            }
        }

        private void GetReporteService(TipoEstudio tipoEstudio, out string tipoReporte, out string nombreColumnaDependencia)
        {
            switch (tipoEstudio)
            {
                case TipoEstudio.Pregrado:
                    reporteService = new ReportePregradoService();
                    tipoReporte = "Pregrado";
                    nombreColumnaDependencia = "Facultad";
                    break;

                case TipoEstudio.Posgrado:
                    reporteService = new ReportePosgradoService();
                    tipoReporte = "Posgrado";
                    nombreColumnaDependencia = "Grado";
                    break;

                case TipoEstudio.Segunda_Especialidad:
                    reporteService = new ReporteSegundaEspecialidadService();
                    tipoReporte = "Segunda Especialidad";
                    nombreColumnaDependencia = "Facultad";
                    break;

                case TipoEstudio.Residentado:
                    reporteService = new ReporteResidentadoService();
                    tipoReporte = "Residentado Médico";
                    nombreColumnaDependencia = "Dependencia";
                    break;

                default:
                    throw new NotImplementedException();
            }
        }
    }
}