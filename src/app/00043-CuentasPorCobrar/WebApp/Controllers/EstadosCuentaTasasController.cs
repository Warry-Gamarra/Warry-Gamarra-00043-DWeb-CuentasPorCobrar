﻿using ClosedXML.Excel;
using Domain.Helpers;
using System;
using System.Collections.Generic;
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
    [Authorize(Roles = RoleNames.ADMINISTRADOR + ", " + RoleNames.CONSULTA + ", " + RoleNames.TESORERIA + ", " + RoleNames.TESORERIA_AVANZADO)]
    public class EstadosCuentaTasasController : Controller
    {
        ITasaServiceFacade tasaService;
        SelectModel selectModels;
        UsersModel usersModel;

        public EstadosCuentaTasasController()
        {
            tasaService = new TasaServiceFacade();
            selectModels = new SelectModel();
            usersModel = new UsersModel();
        }

        [Authorize(Roles = RoleNames.ADMINISTRADOR + ", " + RoleNames.CONSULTA + ", " + RoleNames.TESORERIA + ", " + RoleNames.TESORERIA_AVANZADO)]
        [Route("consulta/tasas")]
        public ActionResult Consulta(ConsultaPagoTasasViewModel model)
        {
            bool verConstanciaPago = false;

            if (model.buscar)
            {
                model.resultado = tasaService.listarPagoTasas(model);

                var user = usersModel.Find(WebSecurity.CurrentUserId);

                if (user.RoleName.Equals(RoleNames.ADMINISTRADOR) || user.RoleName.Equals(RoleNames.TESORERIA) || user.RoleName.Equals(RoleNames.TESORERIA_AVANZADO))
                {
                    verConstanciaPago = true;
                }
            }

            ViewBag.Title = "Consulta de Pago de Tasas";

            ViewBag.EntidadesFinancieras = new SelectList(selectModels.GetEntidadesFinancieras(), "Value", "TextDisplay", model.entidadFinanciera);

            ViewBag.CtaDeposito = new SelectList(
                model.entidadFinanciera.HasValue ? selectModels.GetCtasDeposito(model.entidadFinanciera.Value) : new List<SelectViewModel>(), "Value", "TextDisplay", model.idCtaDeposito);

            ViewBag.VerConstanciaPago = verConstanciaPago;

            return View(model);
        }

        [Route("consulta/tasas/descarga")]
        public ActionResult DescargaExcelConsultaTasas(ConsultaPagoTasasViewModel model)
        {
            if (model.buscar)
            {
                model.resultado = tasaService.listarPagoTasas(model);
            }
            else
            {
                return RedirectToAction("Consulta", "EstadosCuentaTasas");
            }

            using (var workbook = new XLWorkbook())
            {
                var worksheet = workbook.Worksheets.Add("PagoTasas");
                var currentRow = 1;

                worksheet.Columns("A:B").Width = 15;
                worksheet.Column("C").Width = 20;
                worksheet.Column("D").Width = 35;
                worksheet.Column("E").Width = 15;
                worksheet.Column("F").Width = 35;
                worksheet.Columns("G:H").Width = 15;
                worksheet.Column("I").Width = 30;
                worksheet.Columns("J:M").Width = 15;
                worksheet.Column("N").Width = 35;

                worksheet.Cell(currentRow, 1).Value = "Cod.Operación";
                worksheet.Cell(currentRow, 2).Value = "Cod.Interno (BCP)";
                worksheet.Cell(currentRow, 3).Value = "Cod.Depositante";
                worksheet.Cell(currentRow, 4).Value = "Nom.Depositante";
                worksheet.Cell(currentRow, 5).Value = "Tasa";
                worksheet.Cell(currentRow, 6).Value = "Concepto";
                worksheet.Cell(currentRow, 7).Value = "Fec.Pago";
                worksheet.Cell(currentRow, 8).Value = "Monto Tasa";
                worksheet.Cell(currentRow, 9).Value = "Banco";
                worksheet.Cell(currentRow, 10).Value = "Cta.Deposito";
                worksheet.Cell(currentRow, 11).Value = "Monto Pagado";
                worksheet.Cell(currentRow, 12).Value = "Nro.Constancia";
                worksheet.Cell(currentRow, 13).Value = "Fec.Mod";
                worksheet.Cell(currentRow, 14).Value = "Obs.";

                foreach (var item in model.resultado)
                {
                    currentRow++;
                    worksheet.Cell(currentRow, 1).SetValue<string>(item.C_CodOperacion);
                    worksheet.Cell(currentRow, 2).SetValue<string>(item.C_CodigoInterno);
                    worksheet.Cell(currentRow, 3).SetValue<string>(item.C_CodDepositante);
                    worksheet.Cell(currentRow, 4).SetValue<string>(item.T_NomDepositante);
                    worksheet.Cell(currentRow, 5).SetValue<string>(item.C_CodTasa);
                    worksheet.Cell(currentRow, 6).SetValue<string>(item.T_ConceptoPagoDesc);
                    worksheet.Cell(currentRow, 7).SetValue<DateTime>(item.D_FecPago);
                    worksheet.Cell(currentRow, 8).SetValue<decimal?>(item.M_Monto);
                    worksheet.Cell(currentRow, 9).SetValue<string>(item.T_EntidadDesc);
                    worksheet.Cell(currentRow, 10).SetValue<string>(item.C_NumeroCuenta);
                    worksheet.Cell(currentRow, 11).SetValue<decimal>(item.I_MontoTotalPagado);
                    worksheet.Cell(currentRow, 12).SetValue<string>(item.T_Constancia);
                    worksheet.Cell(currentRow, 13).SetValue<DateTime?>(item.D_FecMod);
                    worksheet.Cell(currentRow, 14).SetValue<string>(item.T_Observacion);
                }

                worksheet.Columns("H").Style.NumberFormat.Format = FormatosDecimal.BASIC_DECIMAL;
                worksheet.Columns("K").Style.NumberFormat.Format = FormatosDecimal.BASIC_DECIMAL;
                worksheet.Columns("L").Style.Alignment.SetHorizontal(XLAlignmentHorizontalValues.Right);

                using (var stream = new MemoryStream())
                {
                    workbook.SaveAs(stream);
                    var content = stream.ToArray();

                    return File(content, "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet", "Consulta Pago de Tasas.xlsx");
                }
            }
        }
    }
}