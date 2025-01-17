﻿using ClosedXML.Excel;
using DocumentFormat.OpenXml.EMMA;
using Domain.Helpers;
using Microsoft.Reporting.WebForms;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebApp.Models;
using WebApp.Models.Facades;
using WebApp.ViewModels;
using WebMatrix.WebData;

namespace WebApp.Controllers
{
    [Authorize]
    [Authorize(Roles = RoleNames.ADMINISTRADOR + ", " + RoleNames.CONSULTA + ", " + RoleNames.DEPENDENCIA + ", " + RoleNames.TESORERIA + ", " + RoleNames.TESORERIA_AVANZADO)]
    public class EstadosCuentaController : Controller
    {
        IReporteServiceFacade reporteServiceFacade;
        IProgramasClientFacade programasClientFacade;
        IGeneralServiceFacade generalServiceFacade;
        SelectModel selectModels;
        PagosModel pagoModel;
        IReporteGeneralServiceFacade reporteGeneralServiceFacade;
        ICatalogoServiceFacade catalogoServiceFacade;
        UsersModel usersModel;

        public EstadosCuentaController()
        {
            reporteServiceFacade = new ReporteServiceFacade();
            programasClientFacade = new ProgramasClientFacade();
            generalServiceFacade = new GeneralServiceFacade();
            selectModels = new SelectModel();
            pagoModel = new PagosModel();
            reporteGeneralServiceFacade = new ReporteGeneralServiceFacade();
            catalogoServiceFacade = new CatalogoServiceFacade();
            usersModel = new UsersModel();
        }
        
        // GET: EstadosCuenta
        [Route("consultas/estados-de-cuenta")]
        public ActionResult Index()
        {
            ViewBag.Title = "Estados de Cuenta";
            return View();
        }

        [Authorize(Roles = RoleNames.ADMINISTRADOR + ", " + RoleNames.CONSULTA + ", " + RoleNames.TESORERIA + ", " + RoleNames.DEPENDENCIA + ", " + RoleNames.TESORERIA_AVANZADO)]
        [Route("consultas/reporte-pago-de-obligaciones")]
        public ActionResult ReportesPagoObligaciones(ReportePagosObligacionesViewModel model)
        {
            var userId = usersModel.Find()
                .Where(u => u.UserName.Equals(User.Identity.Name, StringComparison.InvariantCultureIgnoreCase))
                .First().UserId;

            var user = usersModel.Find(userId.Value);

            IEnumerable<SelectViewModel> listaTipoEstudios = generalServiceFacade.Listar_TipoEstudios(model.idDependencia);

            if (user.RoleName.Equals(RoleNames.DEPENDENCIA))
            {
                model.idDependencia = user.DependenciaId;

                model.tipoEstudio = (model.idDependencia == DependenciaEUPG.ID) ? TipoEstudio.Posgrado : TipoEstudio.Pregrado;

                listaTipoEstudios = listaTipoEstudios.Where(x => x.Value == model.tipoEstudio.ToString());
            }

            ViewBag.TipoEstudios = new SelectList(listaTipoEstudios, "Value", "TextDisplay", model.tipoEstudio);

            ViewBag.TipoReportes = new SelectList(generalServiceFacade.Listar_TipoReporteObligaciones(model.idDependencia), "Value", "TextDisplay", model.tipoReporte);

            IEnumerable<SelectViewModel> listaDependencias = programasClientFacade.GetFacultades(model.tipoEstudio, model.idDependencia);

            ViewBag.Dependencias = new SelectList(listaDependencias, "Value", "TextDisplay", model.dependencia);

            ViewBag.EntidadesFinancieras = new SelectList(selectModels.GetEntidadesFinancieras(), "Value", "TextDisplay", model.idEntidadFinanciera);

            ViewBag.CtaDeposito = new SelectList(
                model.idEntidadFinanciera.HasValue ? selectModels.GetCtasDeposito(model.idEntidadFinanciera.Value) : new List<SelectViewModel>(), "Value", "TextDisplay", model.ctaDeposito);

            ViewBag.LabelReporte = model.idDependencia.HasValue ? null : "SELECCIONAR";

            ViewBag.LabelDependencias = (model.idDependencia.HasValue && model.idDependencia != DependenciaEUPG.ID) ? null : "TODOS";

            ViewBag.DependenciaDefault = model.idDependencia.HasValue ? listaDependencias.First().Value : "";

            string tipoReporte;

            ObtenerReportePagoDeObligaciones(model, out tipoReporte);

            ViewBag.Title = "Reportes de Pago de Obligaciones de " + tipoReporte;
            
            return View(model);
        }

        [Route("consultas/reporte-pago-de-obligaciones/descarga")]
        public ActionResult DescargaReportesPagoObligaciones(ReportePagosObligacionesViewModel model)
        {
            var userId = usersModel.Find()
                .Where(u => u.UserName.Equals(User.Identity.Name, StringComparison.InvariantCultureIgnoreCase))
                .First().UserId;

            var user = usersModel.Find(userId.Value);

            if (user.RoleName.Equals(RoleNames.DEPENDENCIA))
            {
                model.idDependencia = user.DependenciaId;

                model.tipoEstudio = (model.idDependencia == DependenciaEUPG.ID) ? TipoEstudio.Posgrado : TipoEstudio.Pregrado;
            }

            Tuple<string, XLWorkbook> reporte;

            reporte = ObtenerReporteExcelPagoDeObligaciones(model);

            using (var stream = new MemoryStream())
            {
                reporte.Item2.SaveAs(stream);

                var content = stream.ToArray();

                return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", reporte.Item1);
            }
        }

        private void ObtenerReportePagoDeObligaciones(ReportePagosObligacionesViewModel model, out string tipoReporte)
        {
            if (model.tipoReporte == Reportes.REPORTE_GENERAL)
            {
                model.reportePagosGeneralViewModel = reporteServiceFacade.ReporteGeneral(
                    model.fechaInicio.Value, model.fechaFin.Value, model.idEntidadFinanciera, model.ctaDeposito, model.tipoEstudio, out tipoReporte);
            }
            else if (model.tipoReporte == Reportes.REPORTE_CONCEPTO)
            {
                model.reportePagosPorConceptoViewModel = reporteServiceFacade.ReportePorConceptos(
                    model.fechaInicio.Value, model.fechaFin.Value, model.idEntidadFinanciera, model.ctaDeposito, model.tipoEstudio, out tipoReporte);
            }
            else if (model.tipoReporte == Reportes.REPORTE_FACULTAD)
            {
                if (String.IsNullOrEmpty(model.dependencia))
                {
                    model.reportePorDependenciaYConceptoViewModel = reporteServiceFacade.ReportePorDependenciaYConcepto(
                        model.fechaInicio.Value, model.fechaFin.Value, model.idEntidadFinanciera, model.ctaDeposito, model.tipoEstudio, out tipoReporte);
                }
                else
                {
                    model.reporteConceptosPorDependenciaViewModel = reporteServiceFacade.ReporteConceptosPorDependencia(
                        model.dependencia, model.fechaInicio.Value, model.fechaFin.Value, model.idEntidadFinanciera, model.ctaDeposito, model.tipoEstudio, out tipoReporte);
                }
            }
            else
            {
                tipoReporte = "la UNFV";
            }
        }

        private Tuple<string, XLWorkbook> ObtenerReporteExcelPagoDeObligaciones(ReportePagosObligacionesViewModel model)
        {
            string nombreArchivo = "";
            string tipoReporte;
            XLWorkbook workbook = null;

            if (model.tipoReporte == Reportes.REPORTE_GENERAL)
            {
                workbook  = ReporteExcelPagosEnGeneral(
                    reporteServiceFacade.ReporteGeneral(model.fechaInicio.Value, model.fechaFin.Value, model.idEntidadFinanciera, model.ctaDeposito, model.tipoEstudio, out tipoReporte));

                nombreArchivo = "Reporte " + tipoReporte + " General" + " al " + DateTime.Now.ToString(FormatosDateTime.BASIC_DATE2) + ".xlsx";
            }
            else  if (model.tipoReporte == Reportes.REPORTE_CONCEPTO)
            {
                workbook = ReporteExcelPagosPorConcepto(
                    reporteServiceFacade.ReportePorConceptos(model.fechaInicio.Value, model.fechaFin.Value, model.idEntidadFinanciera, model.ctaDeposito, model.tipoEstudio, out tipoReporte));

                nombreArchivo = "Reporte " + tipoReporte + " por Conceptos" + " al " + DateTime.Now.ToString(FormatosDateTime.BASIC_DATE2) + ".xlsx";
            }
            else if (model.tipoReporte == Reportes.REPORTE_FACULTAD)
            {
                if (String.IsNullOrEmpty(model.dependencia))
                {
                    var reporte = reporteServiceFacade.ReportePorDependenciaYConcepto(model.fechaInicio.Value, model.fechaFin.Value, model.idEntidadFinanciera, model.ctaDeposito, model.tipoEstudio, out tipoReporte);
                    
                    workbook = ReporteExcelDependenciaYConceptos(reporte, model.tipoEstudio);

                    nombreArchivo = "Reporte " + tipoReporte + " por " + reporte.nombreColumnaDependencia + " al " + DateTime.Now.ToString(FormatosDateTime.BASIC_DATE2) + ".xlsx";
                }
                else
                {
                    workbook = ReporteExcelConceptosPorDependencia(
                        reporteServiceFacade.ReporteConceptosPorDependencia(model.dependencia, model.fechaInicio.Value, model.fechaFin.Value, model.idEntidadFinanciera, model.ctaDeposito, model.tipoEstudio, out tipoReporte));

                    nombreArchivo = "Reporte " + tipoReporte + " por Conceptos" + " al " + DateTime.Now.ToString(FormatosDateTime.BASIC_DATE2) + ".xlsx";
                }
            }

            return new Tuple<string, XLWorkbook>(nombreArchivo, workbook);
        }

        private XLWorkbook ReporteExcelPagosEnGeneral(ReportePagosUnfvGeneralViewModel reporte)
        {
            var workbook = new XLWorkbook();

            var worksheet = workbook.Worksheets.Add("Reporte");

            worksheet.Column("A").Width = 14;

            worksheet.Column("B").Width = 60;

            worksheet.Column("C").Width = 14;

            var titleCell = worksheet.Cell(1, 1);

            titleCell.Value = reporte.Titulo.ToUpper();

            titleCell.RichText.SetBold(true);

            titleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

            worksheet.Range(titleCell, worksheet.Cell(1, 3)).Merge(true);

            var subTitleCell = worksheet.Cell(2, 1);

            subTitleCell.Value = reporte.SubTitulo.ToUpper();

            subTitleCell.RichText.SetBold(true);

            subTitleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

            worksheet.Range(subTitleCell, worksheet.Cell(2, 3)).Merge(true);

            var bankNameCell = worksheet.Cell(4, 1);

            bankNameCell.Value = String.IsNullOrEmpty(reporte.nombreEntidadFinanc) ? "" : "Entidad Financiera: " + reporte.nombreEntidadFinanc;

            var ctaDepositoCell = worksheet.Cell(5, 1);

            ctaDepositoCell.Value = String.IsNullOrEmpty(reporte.numeroCuenta) ? "" : "Número Cuenta: " + reporte.numeroCuenta;

            var dateCell = worksheet.Cell(4, 3);

            dateCell.Value = "Fecha consulta: " + reporte.FechaActual;

            dateCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

            var timeCell = worksheet.Cell(5, 3);

            timeCell.Value = "Hora consulta: " + reporte.HoraActual;

            timeCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

            var currentRow = 7;

            worksheet.Cell(currentRow, 1).Value = "Código";
            worksheet.Cell(currentRow, 2).Value = reporte.nombreColumnaDependencia;
            worksheet.Cell(currentRow, 3).Value = "Monto (S/)";

            currentRow++;

            var inicial = currentRow;

            foreach (var item in reporte.listaPagos)
            {
                worksheet.Cell(currentRow, 1).SetValue<string>(item.C_CodDependencia);
                worksheet.Cell(currentRow, 2).SetValue<string>(item.T_DependenciaDesc);
                worksheet.Cell(currentRow, 3).SetValue<decimal>(item.I_MontoTotal);

                currentRow++;
            }
            
            worksheet.Cell(currentRow, 2).Value = "Total (S/)";
            worksheet.Cell(currentRow, 3).SetValue<decimal>(reporte.MontoTotal);
            
            worksheet.Range(worksheet.Cell(inicial, 3), worksheet.Cell(currentRow, 3)).Style.NumberFormat.Format = FormatosDecimal.BASIC_DECIMAL;

            return workbook;
        }

        private XLWorkbook ReporteExcelPagosPorConcepto(ReportePagosUnfvPorConceptoViewModel reporte)
        {
            var workbook = new XLWorkbook();

            var worksheet = workbook.Worksheets.Add("Reporte");

            worksheet.Column("A").Width = 14;
            worksheet.Column("B").Width = 30;
            worksheet.Column("C").Width = 60;
            worksheet.Columns("D:E").Width = 14;

            var titleCell = worksheet.Cell(1, 1);

            titleCell.Value = reporte.Titulo.ToUpper();

            titleCell.RichText.SetBold(true);

            titleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

            worksheet.Range(titleCell, worksheet.Cell(1, 5)).Merge(true);

            var subTitleCell = worksheet.Cell(2, 1);

            subTitleCell.Value = reporte.SubTitulo.ToUpper();

            subTitleCell.RichText.SetBold(true);

            subTitleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

            worksheet.Range(subTitleCell, worksheet.Cell(2, 5)).Merge(true);

            var bankNameCell = worksheet.Cell(4, 1);

            bankNameCell.Value = String.IsNullOrEmpty(reporte.nombreEntidadFinanc) ? "" : "Entidad Financiera: " + reporte.nombreEntidadFinanc;

            var ctaDepositoCell = worksheet.Cell(5, 1);

            ctaDepositoCell.Value = String.IsNullOrEmpty(reporte.numeroCuenta) ? "" : "Número Cuenta: " + reporte.numeroCuenta;

            var dateCell = worksheet.Cell(4, 5);

            dateCell.Value = "Fecha consulta: " + reporte.FechaActual;

            dateCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

            var timeCell = worksheet.Cell(5, 5);

            timeCell.Value = "Hora consulta: " + reporte.HoraActual;

            timeCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

            var currentRow = 7;

            worksheet.Cell(currentRow, 1).Value = "Cod.Clasificador";
            worksheet.Cell(currentRow, 2).Value = "Clasificador";
            worksheet.Cell(currentRow, 3).Value = "Concepto";
            worksheet.Cell(currentRow, 4).Value = "Monto (S/)";
            worksheet.Cell(currentRow, 5).Value = "Total (S/)";

            currentRow++;

            var inicial = currentRow;
            int i;

            foreach (var grupoClasif in reporte.listaPagos.GroupBy(x => x.C_CodClasificador))
            {
                i = 1;

                foreach (var item in grupoClasif)
                {
                    if (i == 1)
                    {
                        worksheet.Cell(currentRow, 1).SetValue<string>(item.C_CodClasificador);
                        worksheet.Cell(currentRow, 1).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 1), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 1)).Merge();

                        worksheet.Cell(currentRow, 2).SetValue<string>(item.T_ClasificadorDesc);
                        worksheet.Cell(currentRow, 2).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 2), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 2)).Merge();
                    }
                    
                    worksheet.Cell(currentRow, 3).SetValue<string>(item.T_ConceptoPagoDesc);
                    worksheet.Cell(currentRow, 4).SetValue<decimal>(item.I_MontoTotal);

                    if (i == 1)
                    {
                        worksheet.Cell(currentRow, 5).SetValue<decimal>(grupoClasif.Sum(x => x.I_MontoTotal));
                        worksheet.Cell(currentRow, 5).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 5), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 5)).Merge();
                    }
                    
                    currentRow++;
                    i++;
                }
            }

            worksheet.Cell(currentRow, 4).Value = "Total (S/)";
            worksheet.Cell(currentRow, 5).SetValue<decimal>(reporte.MontoTotal);

            worksheet.Range(worksheet.Cell(inicial, 4), worksheet.Cell(currentRow, 5)).Style.NumberFormat.Format = FormatosDecimal.BASIC_DECIMAL;
            return workbook;
        }

        private XLWorkbook ReporteExcelDependenciaYConceptos(ReportePorDependenciaYConceptoViewModel reporte, TipoEstudio tipoEstudio)
        {
            var workbook = new XLWorkbook();

            var worksheet = workbook.Worksheets.Add("Reporte");

            if (tipoEstudio.Equals(TipoEstudio.Posgrado))
            {
                worksheet.Column("A").Width = 14;
            }
            else
            {
                worksheet.Column("A").Width = 60;
            }

            worksheet.Column("B").Width = 14;

            worksheet.Column("C").Width = 30;

            worksheet.Column("D").Width = 60;

            worksheet.Columns("E:F").Width = 14;

            var titleCell = worksheet.Cell(1, 1);

            titleCell.Value = reporte.Titulo.ToUpper();

            titleCell.RichText.SetBold(true);

            titleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

            worksheet.Range(titleCell, worksheet.Cell(1, 6)).Merge(true);

            var subTitleCell = worksheet.Cell(2, 1);

            subTitleCell.Value = reporte.SubTitulo.ToUpper();

            subTitleCell.RichText.SetBold(true);

            subTitleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

            worksheet.Range(subTitleCell, worksheet.Cell(2, 6)).Merge(true);

            var dateCell = worksheet.Cell(4, 6);

            dateCell.Value = "Fecha consulta: " + reporte.FechaActual;

            dateCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

            var bankNameCell = worksheet.Cell(4, 1);

            bankNameCell.Value = String.IsNullOrEmpty(reporte.nombreEntidadFinanc) ? "" : "Entidad Financiera: " + reporte.nombreEntidadFinanc;

            var ctaDepositoCell = worksheet.Cell(5, 1);

            ctaDepositoCell.Value = String.IsNullOrEmpty(reporte.numeroCuenta) ? "" : "Número Cuenta: " + reporte.numeroCuenta;

            var timeCell = worksheet.Cell(5, 6);

            timeCell.Value = "Hora consulta: " + reporte.HoraActual;

            timeCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

            var currentRow = 7;

            worksheet.Cell(currentRow, 1).Value = reporte.nombreColumnaDependencia;
            worksheet.Cell(currentRow, 2).Value = "Cod.Clasificador";
            worksheet.Cell(currentRow, 3).Value = "Clasificador";
            worksheet.Cell(currentRow, 4).Value = "Concepto";
            worksheet.Cell(currentRow, 5).Value = "Monto (S/)";
            worksheet.Cell(currentRow, 6).Value = "Total (S/)";

            currentRow++;

            var inicial = currentRow;
            int i;

            foreach (var grupoClasif in reporte.listaPagos.GroupBy(x => new { x.C_CodClasificador, x.C_CodDependencia }))
            {
                i = 1;
                foreach (var item in grupoClasif)
                {
                    if (i == 1)
                    {
                        worksheet.Cell(currentRow, 1).SetValue<string>(item.T_DependenciaDesc);
                        worksheet.Cell(currentRow, 1).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 1), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 1)).Merge();

                        worksheet.Cell(currentRow, 2).SetValue<string>(item.C_CodClasificador);
                        worksheet.Cell(currentRow, 2).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 2), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 2)).Merge();

                        worksheet.Cell(currentRow, 3).SetValue<string>(item.T_ClasificadorDesc);
                        worksheet.Cell(currentRow, 3).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 3), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 3)).Merge();
                    }
                    
                    worksheet.Cell(currentRow, 4).SetValue<string>(item.T_ConceptoPagoDesc);
                    worksheet.Cell(currentRow, 5).SetValue<decimal>(item.I_MontoTotal);

                    if (i == 1)
                    {
                        worksheet.Cell(currentRow, 6).SetValue<decimal>(grupoClasif.Sum(x => x.I_MontoTotal));
                        worksheet.Cell(currentRow, 6).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 6), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 6)).Merge();
                    }

                    currentRow++;
                    i++;
                }
            }

            worksheet.Cell(currentRow, 5).Value = "Total (S/)";
            worksheet.Cell(currentRow, 6).SetValue<decimal>(reporte.MontoTotal);

            worksheet.Range(worksheet.Cell(inicial, 5), worksheet.Cell(currentRow, 6)).Style.NumberFormat.Format = FormatosDecimal.BASIC_DECIMAL;

            return workbook;
        }

        private XLWorkbook ReporteExcelConceptosPorDependencia(ReporteConceptosPorDependenciaViewModel reporte)
        {
            var workbook = new XLWorkbook();

            var worksheet = workbook.Worksheets.Add("Reporte");

            worksheet.Column("A").Width = 14;

            worksheet.Column("B").Width = 30;

            worksheet.Column("C").Width = 60;

            worksheet.Columns("D:F").Width = 14;

            var titleCell = worksheet.Cell(1, 1);

            titleCell.Value = reporte.Titulo.ToUpper();

            titleCell.RichText.SetBold(true);

            titleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

            worksheet.Range(titleCell, worksheet.Cell(1, 5)).Merge(true);

            var subTitleCell = worksheet.Cell(2, 1);

            subTitleCell.Value = reporte.SubTitulo.ToUpper();

            subTitleCell.RichText.SetBold(true);

            subTitleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

            worksheet.Range(subTitleCell, worksheet.Cell(2, 5)).Merge(true);

            var facultadCell = worksheet.Cell(4, 1);

            facultadCell.Value = reporte.nombreColumnaDependencia + ": " + reporte.Dependencia.ToUpper();

            var dateCell = worksheet.Cell(4, 6);

            dateCell.Value = "Fecha consulta: " + reporte.FechaActual;

            dateCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

            var bankNameCell = worksheet.Cell(5, 1);

            bankNameCell.Value = String.IsNullOrEmpty(reporte.nombreEntidadFinanc) ? "" : "Entidad Financiera: " + reporte.nombreEntidadFinanc;

            var timeCell = worksheet.Cell(5, 6);

            timeCell.Value = "Hora consulta: " + reporte.HoraActual;

            timeCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

            var ctaDepositoCell = worksheet.Cell(6, 1);

            ctaDepositoCell.Value = String.IsNullOrEmpty(reporte.numeroCuenta) ? "" : "Número Cuenta: " + reporte.numeroCuenta;

            var currentRow = String.IsNullOrEmpty(reporte.numeroCuenta) ? 7 : 8;

            worksheet.Cell(currentRow, 1).Value = "Cod.Clasificador";
            worksheet.Cell(currentRow, 2).Value = "Clasificador";
            worksheet.Cell(currentRow, 3).Value = "Concepto";
            worksheet.Cell(currentRow, 4).Value = "Cantidad";
            worksheet.Cell(currentRow, 5).Value = "Monto (S/)";
            worksheet.Cell(currentRow, 6).Value = "Total (S/)";

            currentRow++;

            var inicial = currentRow;
            int i;

            foreach (var grupoClasif in reporte.listaPagos.GroupBy(x => new { x.C_CodClasificador }))
            {
                i = 1;
                foreach (var item in grupoClasif)
                {
                    if (i == 1)
                    {
                        worksheet.Cell(currentRow, 1).SetValue<string>(item.C_CodClasificador);
                        worksheet.Cell(currentRow, 1).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 1), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 1)).Merge();

                        worksheet.Cell(currentRow, 2).SetValue<string>(item.T_ClasificadorDesc);
                        worksheet.Cell(currentRow, 2).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 2), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 2)).Merge();
                    }

                    worksheet.Cell(currentRow, 3).SetValue<string>(item.T_ConceptoPagoDesc);                    
                    worksheet.Cell(currentRow, 4).SetValue<int>(item.I_Cantidad);
                    worksheet.Cell(currentRow, 5).SetValue<decimal>(item.I_MontoTotal);

                    if (i == 1)
                    {
                        worksheet.Cell(currentRow, 6).SetValue<decimal>(grupoClasif.Sum(x => x.I_MontoTotal));
                        worksheet.Cell(currentRow, 6).Style.Alignment.SetVertical(XLAlignmentVerticalValues.Top);
                        worksheet.Range(worksheet.Cell(currentRow, 6), worksheet.Cell(currentRow + grupoClasif.Count() - 1, 6)).Merge();
                    }

                    currentRow++;
                    i++;
                }
            }

            worksheet.Cell(currentRow, 5).Value = "Total (S/)";
            worksheet.Cell(currentRow, 6).SetValue<decimal>(reporte.MontoTotal);

            worksheet.Range(worksheet.Cell(inicial, 5), worksheet.Cell(currentRow, 6)).Style.NumberFormat.Format = FormatosDecimal.BASIC_DECIMAL;

            return workbook;
        }

        [Authorize(Roles = RoleNames.ADMINISTRADOR + ", " + RoleNames.CONSULTA + ", " + RoleNames.TESORERIA + ", " + RoleNames.TESORERIA_AVANZADO)]
        [Route("consulta/ingresos-de-obligaciones")]
        public ActionResult ListarPagosBancoObligaciones(ConsultaPagosBancoObligacionesViewModel model)
        {
            bool verConstanciaPago = false;

            if (model.buscar)
            {
                model.resultado = pagoModel.ListarPagoBancoObligacion(model);

                var user = usersModel.Find(WebSecurity.CurrentUserId);

                if (user.RoleName.Equals(RoleNames.ADMINISTRADOR) || user.RoleName.Equals(RoleNames.TESORERIA) || user.RoleName.Equals(RoleNames.TESORERIA_AVANZADO))
                {
                    verConstanciaPago = true;
                }
            }
            
            ViewBag.Title = "Consulta de Ingresos de Pago de Obligaciones";

            ViewBag.EntidadesFinancieras = new SelectList(selectModels.GetEntidadesFinancieras(), "Value", "TextDisplay", model.banco);

            ViewBag.CtaDeposito = new SelectList(
                model.banco.HasValue ? selectModels.GetCtasDeposito(model.banco.Value) : new List<SelectViewModel>(), "Value", "TextDisplay", model.ctaDeposito);

            ViewBag.CondicionesPago = new SelectList(selectModels.GetCondicionesPago(), "Value", "TextDisplay", model.condicion);

            ViewBag.TipoEstudios = new SelectList(generalServiceFacade.Listar_TipoEstudios(null), "Value", "TextDisplay", model.tipoEstudio);

            ViewBag.VerConstanciaPago = verConstanciaPago;

            return View(model);
        }

        [Authorize(Roles = RoleNames.ADMINISTRADOR + ", " + RoleNames.CONSULTA + ", " + RoleNames.TESORERIA + ", " + RoleNames.TESORERIA_AVANZADO)]
        [Route("consulta/ingresos-de-obligaciones/descarga")]
        public ActionResult ListarPagosBancoObligacionesDescargaExcel(ConsultaPagosBancoObligacionesViewModel model)
        {
            model.resultado = pagoModel.ListarPagoBancoObligacion(model);

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("PagosBanco");

                worksheet.Column("A").Width = 30;
                worksheet.Columns("B:D").Width  = 16;
                worksheet.Column("E").Width = 25;
                worksheet.Columns("F:G").Width = 16;
                worksheet.Column("H").Width = 30;
                worksheet.Columns("I:O").Width = 16;
                worksheet.Column("P").Width = 30;

                var currentRow = 1;

                #region Header
                worksheet.Cell(currentRow, 1).Value = "Banco";
                worksheet.Cell(currentRow, 2).Value = "Cta.Deposito";
                worksheet.Cell(currentRow, 3).Value = "Cod.Operación";
                worksheet.Cell(currentRow, 4).Value = "Cod.Interno (BCP)";
                worksheet.Cell(currentRow, 5).Value = "Cuota Pago";
                worksheet.Cell(currentRow, 6).Value = "Fecha Vcto";
                worksheet.Cell(currentRow, 7).Value = "Cod.Depositante";
                worksheet.Cell(currentRow, 8).Value = "Depositante";
                worksheet.Cell(currentRow, 9).Value = "Fecha Pago";
                worksheet.Cell(currentRow, 10).Value = "Monto Pagado";
                worksheet.Cell(currentRow, 11).Value = "Mora";
                worksheet.Cell(currentRow, 12).Value = "Lugar";
                worksheet.Cell(currentRow, 13).Value = "Nro.Constancia";
                worksheet.Cell(currentRow, 14).Value = "Fec.Reg.Sistema";
                worksheet.Cell(currentRow, 15).Value = "Condición";
                worksheet.Cell(currentRow, 16).Value = "Observación";
                #endregion

                #region Body
                foreach (var item in model.resultado)
                {
                    currentRow++;
                    worksheet.Cell(currentRow, 1).SetValue<string>(item.T_EntidadDesc);
                    worksheet.Cell(currentRow, 2).SetValue<string>(item.C_NumeroCuenta);
                    worksheet.Cell(currentRow, 3).SetValue<string>(item.C_CodOperacion);
                    worksheet.Cell(currentRow, 4).SetValue<string>(item.C_CodigoInterno);
                    worksheet.Cell(currentRow, 5).SetValue<string>(item.T_ProcesoDesc);
                    worksheet.Cell(currentRow, 6).SetValue<string>(item.T_FecVencto);
                    worksheet.Cell(currentRow, 7).SetValue<string>(item.C_CodDepositante);
                    worksheet.Cell(currentRow, 8).SetValue<string>(item.T_DatosDepositante);
                    worksheet.Cell(currentRow, 9).SetValue<DateTime?>(item.D_FecPago);
                    worksheet.Cell(currentRow, 10).SetValue<decimal>(item.I_MontoPago);
                    worksheet.Cell(currentRow, 11).SetValue<decimal>(item.I_InteresMora);
                    worksheet.Cell(currentRow, 12).SetValue<string>(item.T_LugarPago);
                    worksheet.Cell(currentRow, 13).SetValue<string>(item.T_Constancia);
                    worksheet.Cell(currentRow, 14).SetValue<DateTime>(item.D_FecCre);
                    worksheet.Cell(currentRow, 15).SetValue<string>(item.T_Condicion);
                    worksheet.Cell(currentRow, 16).SetValue<string>(item.T_Observacion);
                }
                #endregion

                worksheet.Range(worksheet.Cell(2, 10), worksheet.Cell(currentRow, 11)).Style.NumberFormat.Format = FormatosDecimal.BASIC_DECIMAL;
                worksheet.Columns("M").Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();

                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "Consulta Pago de Obligaciones.xlsx");
                }
            }
        }

        [Authorize(Roles = RoleNames.ADMINISTRADOR + ", " + RoleNames.CONSULTA + ", " + RoleNames.TESORERIA + ", " + RoleNames.TESORERIA_AVANZADO)]
        [Route("consultas/resumen-obligaciones-por-dia")]
        public ActionResult ResumenAnualObligacionesPorDia(int? anio, int? entidadFinanID, int? ctaDepositoID, int? condicion)
        {
            anio = anio.HasValue ? anio : DateTime.Now.Year;

            var model = reporteGeneralServiceFacade.ReporteResumenAnualPagoObligaciones_X_Dia(anio.Value, entidadFinanID, ctaDepositoID, condicion);

            ViewBag.Anios = new SelectList(generalServiceFacade.Listar_Anios(), "Value", "TextDisplay", anio);
            
            ViewBag.EntidadesFinancieras = new SelectList(selectModels.GetEntidadesFinancieras(), "Value", "TextDisplay", entidadFinanID);

            ViewBag.CtaDeposito = new SelectList(
                entidadFinanID.HasValue ? selectModels.GetCtasDeposito(entidadFinanID.Value) : new List<SelectViewModel>(), "Value", "TextDisplay", ctaDepositoID);

            ViewBag.CondicionesPago = new SelectList(selectModels.GetCondicionesPago(), "Value", "TextDisplay", condicion);

            ViewBag.Title = "Resumen de Ingresos de Pago de Obligaciones";

            return View(model);
        }

        [Route("consultas/resumen-obligaciones-por-dia/descarga")]
        public ActionResult DescargaResumenAnualObligacionesPorDia(int anio, int? entidadFinanID, int? ctaDepositoID, int? condicion)
        {
            var model = reporteGeneralServiceFacade.ReporteResumenAnualPagoObligaciones_X_Dia(anio, entidadFinanID, ctaDepositoID, condicion);

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("IngresosDiarios");

                worksheet.Column("A").Width = 14;

                worksheet.Columns("B:N").Width = 14;

                var titleCell = worksheet.Cell(1, 1);

                titleCell.Value = "RESUMEN DE INGRESOS DE PAGO DE OBLIGACIONES AL AÑO " + model.anio;

                titleCell.RichText.SetBold(true);

                titleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

                worksheet.Range(titleCell, worksheet.Cell(1, 14)).Merge(true);

                var bankNameCell = worksheet.Cell(3, 1);

                bankNameCell.Value = String.IsNullOrEmpty(model.nombreEntidadFinanc) ? "" : "Entidad Financiera: " + model.nombreEntidadFinanc;

                var dateCell = worksheet.Cell(3, 14);

                dateCell.Value = "Fecha consulta: " + model.FechaActual;

                dateCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

                var timeCell = worksheet.Cell(4, 14);

                timeCell.Value = "Hora consulta: " + model.HoraActual;

                timeCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

                var currentRow = 6;

                worksheet.Cell(currentRow, 1).Value = "Día";
                worksheet.Cell(currentRow, 2).Value = "Enero";
                worksheet.Cell(currentRow, 3).Value = "Febrero";
                worksheet.Cell(currentRow, 4).Value = "Marzo";
                worksheet.Cell(currentRow, 5).Value = "Abril";
                worksheet.Cell(currentRow, 6).Value = "Mayo";
                worksheet.Cell(currentRow, 7).Value = "Junio";
                worksheet.Cell(currentRow, 8).Value = "Julio";
                worksheet.Cell(currentRow, 9).Value = "Agosto";
                worksheet.Cell(currentRow, 10).Value = "Setiembre";
                worksheet.Cell(currentRow, 11).Value = "Octubre";
                worksheet.Cell(currentRow, 12).Value = "Noviembre";
                worksheet.Cell(currentRow, 13).Value = "Diciembre";
                worksheet.Cell(currentRow, 14).Value = "Total (S/)";

                currentRow++;

                var inicial = currentRow;

                foreach (var item in model.resumen_x_dia)
                {
                    worksheet.Cell(currentRow, 1).SetValue<string>(item.I_Dia.ToString());
                    worksheet.Cell(currentRow, 2).SetValue<decimal>(item.Enero);
                    worksheet.Cell(currentRow, 3).SetValue<decimal>(item.Febrero);
                    worksheet.Cell(currentRow, 4).SetValue<decimal>(item.Marzo);
                    worksheet.Cell(currentRow, 5).SetValue<decimal>(item.Abril);
                    worksheet.Cell(currentRow, 6).SetValue<decimal>(item.Mayo);
                    worksheet.Cell(currentRow, 7).SetValue<decimal>(item.Junio);
                    worksheet.Cell(currentRow, 8).SetValue<decimal>(item.Julio);
                    worksheet.Cell(currentRow, 9).SetValue<decimal>(item.Agosto);
                    worksheet.Cell(currentRow, 10).SetValue<decimal>(item.Setiembre);
                    worksheet.Cell(currentRow, 11).SetValue<decimal>(item.Octubre);
                    worksheet.Cell(currentRow, 12).SetValue<decimal>(item.Noviembre);
                    worksheet.Cell(currentRow, 13).SetValue<decimal>(item.Diciembre);
                    worksheet.Cell(currentRow, 14).SetValue<decimal>(model.TotalDia(item.I_Dia));

                    currentRow++;
                }

                worksheet.Cell(currentRow, 1).Value = "Total (S/)";
                worksheet.Cell(currentRow, 2).SetValue<decimal>(model.TotalEnero);
                worksheet.Cell(currentRow, 3).SetValue<decimal>(model.TotalFebrero);
                worksheet.Cell(currentRow, 4).SetValue<decimal>(model.TotalMarzo);
                worksheet.Cell(currentRow, 5).SetValue<decimal>(model.TotalAbril);
                worksheet.Cell(currentRow, 6).SetValue<decimal>(model.TotalMayo);
                worksheet.Cell(currentRow, 7).SetValue<decimal>(model.TotalJunio);
                worksheet.Cell(currentRow, 8).SetValue<decimal>(model.TotalJulio);
                worksheet.Cell(currentRow, 9).SetValue<decimal>(model.TotalAgosto);
                worksheet.Cell(currentRow, 10).SetValue<decimal>(model.TotalSetiembre);
                worksheet.Cell(currentRow, 11).SetValue<decimal>(model.TotalOctubre);
                worksheet.Cell(currentRow, 12).SetValue<decimal>(model.TotalNoviembre);
                worksheet.Cell(currentRow, 13).SetValue<decimal>(model.TotalDiciembre);
                worksheet.Cell(currentRow, 14).SetValue<decimal>(model.TotalGeneral);

                worksheet.Range(worksheet.Cell(inicial, 2), worksheet.Cell(currentRow, 14)).Style.NumberFormat.Format = FormatosDecimal.BASIC_DECIMAL;

                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);

                    var content = stream.ToArray();

                    string nombreArchivo = "Resumen Ingresos por día  al " + DateTime.Now.ToString(FormatosDateTime.BASIC_DATE2) + ".xlsx";

                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", nombreArchivo);
                }
            }
        }

        [Authorize(Roles = RoleNames.ADMINISTRADOR + ", " + RoleNames.CONSULTA + ", " + RoleNames.TESORERIA + ", " + RoleNames.TESORERIA_AVANZADO)]
        [Route("consultas/pagos-por-dia")]
        public ActionResult CantidadDePagosPorDia(int? anio, int? tipoPago, int? entidadFinanID, int? ctaDepositoID, int? condicion)
        {
            anio = anio.HasValue ? anio : DateTime.Now.Year;

            tipoPago = tipoPago ?? int.Parse(catalogoServiceFacade.Listar_TipoPagos().First().Value);

            var model = reporteGeneralServiceFacade.ReporteCantidadDePagosRegistrados_X_Dia(anio.Value, tipoPago.Value, entidadFinanID, ctaDepositoID, condicion);

            ViewBag.Anios = new SelectList(generalServiceFacade.Listar_Anios(), "Value", "TextDisplay", anio);

            ViewBag.TipoPagos = new SelectList(catalogoServiceFacade.Listar_TipoPagos(), "Value", "TextDisplay", anio);

            ViewBag.EntidadesFinancieras = new SelectList(selectModels.GetEntidadesFinancieras(), "Value", "TextDisplay", entidadFinanID);

            ViewBag.CtaDeposito = new SelectList(
                entidadFinanID.HasValue ? selectModels.GetCtasDeposito(entidadFinanID.Value) : new List<SelectViewModel>(), "Value", "TextDisplay", ctaDepositoID);

            ViewBag.CondicionesPago = new SelectList(selectModels.GetCondicionesPago(), "Value", "TextDisplay", condicion);

            ViewBag.Title = "Cantidad de Pagos por Día";

            return View(model);
        }

        [Route("consultas/pagos-por-dia/descarga")]
        public ActionResult DescargaCantidadDePagosPorDia(int anio, int tipoPago, int? entidadFinanID, int? ctaDepositoID, int? condicion)
        {
            var model = reporteGeneralServiceFacade.ReporteCantidadDePagosRegistrados_X_Dia(anio, tipoPago, entidadFinanID, ctaDepositoID, condicion);

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("IngresosDiarios");

                worksheet.Column("A").Width = 14;

                worksheet.Columns("B:M").Width = 14;

                var titleCell = worksheet.Cell(1, 1);

                titleCell.Value = "CANTIDAD DE PAGOS POR DÍA AL AÑO " + model.anio;

                titleCell.RichText.SetBold(true);

                titleCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Center);

                worksheet.Range(titleCell, worksheet.Cell(1, 13)).Merge(true);

                var bankNameCell = worksheet.Cell(3, 1);

                bankNameCell.Value = String.IsNullOrEmpty(model.nombreEntidadFinanc) ? "" : "Entidad Financiera: " + model.nombreEntidadFinanc;

                var dateCell = worksheet.Cell(3, 13);

                dateCell.Value = "Fecha consulta: " + model.FechaActual;

                dateCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

                var timeCell = worksheet.Cell(4, 13);

                timeCell.Value = "Hora consulta: " + model.HoraActual;

                timeCell.Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

                var currentRow = 6;

                worksheet.Cell(currentRow, 1).Value = "Día";
                worksheet.Cell(currentRow, 2).Value = "Enero";
                worksheet.Cell(currentRow, 3).Value = "Febrero";
                worksheet.Cell(currentRow, 4).Value = "Marzo";
                worksheet.Cell(currentRow, 5).Value = "Abril";
                worksheet.Cell(currentRow, 6).Value = "Mayo";
                worksheet.Cell(currentRow, 7).Value = "Junio";
                worksheet.Cell(currentRow, 8).Value = "Julio";
                worksheet.Cell(currentRow, 9).Value = "Agosto";
                worksheet.Cell(currentRow, 10).Value = "Setiembre";
                worksheet.Cell(currentRow, 11).Value = "Octubre";
                worksheet.Cell(currentRow, 12).Value = "Noviembre";
                worksheet.Cell(currentRow, 13).Value = "Diciembre";

                currentRow++;

                var inicial = currentRow;

                foreach (var item in model.resumen_x_dia)
                {
                    worksheet.Cell(currentRow, 1).SetValue<string>(item.I_Dia.ToString());
                    worksheet.Cell(currentRow, 2).SetValue<int>(item.Enero);
                    worksheet.Cell(currentRow, 3).SetValue<int>(item.Febrero);
                    worksheet.Cell(currentRow, 4).SetValue<int>(item.Marzo);
                    worksheet.Cell(currentRow, 5).SetValue<int>(item.Abril);
                    worksheet.Cell(currentRow, 6).SetValue<int>(item.Mayo);
                    worksheet.Cell(currentRow, 7).SetValue<int>(item.Junio);
                    worksheet.Cell(currentRow, 8).SetValue<int>(item.Julio);
                    worksheet.Cell(currentRow, 9).SetValue<int>(item.Agosto);
                    worksheet.Cell(currentRow, 10).SetValue<int>(item.Setiembre);
                    worksheet.Cell(currentRow, 11).SetValue<int>(item.Octubre);
                    worksheet.Cell(currentRow, 12).SetValue<int>(item.Noviembre);
                    worksheet.Cell(currentRow, 13).SetValue<int>(item.Diciembre);

                    currentRow++;
                }

                worksheet.Cell(currentRow, 1).Value = "Cantidad";
                worksheet.Cell(currentRow, 2).SetValue<int>(model.TotalEnero);
                worksheet.Cell(currentRow, 3).SetValue<int>(model.TotalFebrero);
                worksheet.Cell(currentRow, 4).SetValue<int>(model.TotalMarzo);
                worksheet.Cell(currentRow, 5).SetValue<int>(model.TotalAbril);
                worksheet.Cell(currentRow, 6).SetValue<int>(model.TotalMayo);
                worksheet.Cell(currentRow, 7).SetValue<int>(model.TotalJunio);
                worksheet.Cell(currentRow, 8).SetValue<int>(model.TotalJulio);
                worksheet.Cell(currentRow, 9).SetValue<int>(model.TotalAgosto);
                worksheet.Cell(currentRow, 10).SetValue<int>(model.TotalSetiembre);
                worksheet.Cell(currentRow, 11).SetValue<int>(model.TotalOctubre);
                worksheet.Cell(currentRow, 12).SetValue<int>(model.TotalNoviembre);
                worksheet.Cell(currentRow, 13).SetValue<int>(model.TotalDiciembre);

                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);

                    var content = stream.ToArray();

                    string nombreArchivo = "Cantidad de Pagos por día  al " + DateTime.Now.ToString(FormatosDateTime.BASIC_DATE2) + ".xlsx";

                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", nombreArchivo);
                }
            }
        }
    }
}
