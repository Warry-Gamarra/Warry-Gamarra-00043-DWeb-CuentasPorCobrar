﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebApp.Models;
using WebApp.ViewModels;
using WebMatrix.WebData;
using Domain.DTO;
using System.IO;

namespace WebApp.Controllers
{
    [Authorize]
    [Route("mantenimiento/conceptos-de-pago/{action}")]
    public class ConceptoController : Controller
    {
        ConceptoPagoModel conceptoPagoModel;
        ProcesoModel procesoModel;

        public ConceptoController()
        {
            conceptoPagoModel = new ConceptoPagoModel();
            procesoModel = new ProcesoModel();
        }

        [Route("mantenimiento/conceptos-de-pago")]
        public ActionResult Index()
        {
            ViewBag.Title = "Conceptos de Pago";

            var lista = conceptoPagoModel.Listar_CatalogoConceptos();

            return View(lista);
        }

        [Route("mantenimiento/conceptos-de-pago/nuevo")]
        [HttpGet]
        public ActionResult Create()
        {
            ViewBag.Title = "Nuevo concepto de pago";


            return PartialView("_RegistrarConcepto", new CatalogoConceptosRegistroViewModel());
        }

        [Route("mantenimiento/conceptos-de-pago/editar/{id}")]
        [HttpGet]
        public ActionResult Edit(int id)
        {
            ViewBag.Title = "editar concepto de pago";


            return PartialView("_RegistrarConcepto", conceptoPagoModel.ObtenerConcepto(id));
        }

        public JsonResult ChangeState(int RowID, bool B_habilitado)
        {
            var result = conceptoPagoModel.ChangeState(RowID, B_habilitado, WebSecurity.CurrentUserId, Url.Action("ChangeState", "EntidadFinanciera"));

            return Json(result, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public ActionResult Save(CatalogoConceptosRegistroViewModel model)
        {
            Response result = new Response();

            if (ModelState.IsValid)
            {
                result = conceptoPagoModel.Save(model, WebSecurity.CurrentUserId);
            }
            else
            {
                string details = "";
                foreach (ModelState modelState in ViewData.ModelState.Values)
                {
                    foreach (ModelError error in modelState.Errors)
                    {
                        details += error.ErrorMessage + " / ";
                    }
                }

                ResponseModel.Error(result, "Ha ocurrido un error con el envio de datos. " + details);
            }
            return PartialView("_MsgPartialWR", result);
        }

    }
}