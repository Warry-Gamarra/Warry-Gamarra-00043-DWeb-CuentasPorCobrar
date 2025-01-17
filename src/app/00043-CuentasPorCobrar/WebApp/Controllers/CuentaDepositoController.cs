﻿using Domain.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WebApp.Models;
using WebApp.ViewModels;
using WebMatrix.WebData;

namespace WebApp.Controllers
{
    [Authorize(Roles = RoleNames.ADMINISTRADOR + ", " + RoleNames.TESORERIA_AVANZADO)]
    public class CuentaDepositoController : Controller
    {
        public readonly CuentaDepositoModel _cuentaDeposito;
        public readonly EntidadRecaudadoraModel _entidadRecaudadora;

        public CuentaDepositoController()
        {
            _cuentaDeposito = new CuentaDepositoModel();
            _entidadRecaudadora = new EntidadRecaudadoraModel();
        }


        [Route("mantenimiento/numeros-de-cuenta")]
        public ActionResult Index()
        {
            ViewBag.Title = "Números de cuenta";

            return View(_cuentaDeposito.Find());
        }

        [Route("mantenimiento/numeros-de-cuenta/nuevo")]
        [HttpGet]
        public ActionResult Create()
        {
            ViewBag.Title = "Agregar Cuenta de Depósito";
            ViewBag.EntidadRecaudadora = new SelectList(_entidadRecaudadora.Find(enabled: true), "Id", "NombreEntidad");

            return PartialView("_RegistrarCuentaDeposito", new CuentaDepositoRegistroViewModel());
        }

        [Route("mantenimiento/numeros-de-cuenta/editar/{id}")]
        [HttpGet]
        public ActionResult Edit(int id)
        {
            ViewBag.Title = "Editar Cuenta de Depósito";
            ViewBag.EntidadRecaudadora = new SelectList(_entidadRecaudadora.Find(enabled: true), "Id", "NombreEntidad");

            return PartialView("_RegistrarCuentaDeposito", _cuentaDeposito.Find(id));
        }

        public JsonResult ChangeState(int RowID, bool B_habilitado)
        {
            var result = _cuentaDeposito.ChangeState(RowID, B_habilitado, WebSecurity.CurrentUserId, Url.Action("ChangeState", "CuentaDeposito"));

            return Json(result, JsonRequestBehavior.AllowGet);
        }


        [HttpPost]
        public ActionResult Save(CuentaDepositoRegistroViewModel model)
        {
            Response result = new Response();

            if (ModelState.IsValid)
            {
                result = _cuentaDeposito.Save(model, WebSecurity.CurrentUserId);
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