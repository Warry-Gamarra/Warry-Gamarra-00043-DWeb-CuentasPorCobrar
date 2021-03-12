﻿using Domain.DTO;
using Domain.Entities;
using Domain.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApp.ViewModels;

namespace WebApp.Models
{
    public class CategoriaPagoModel
    {
        private readonly ICategoriaPago _categoriaPago;
        private readonly IEntidadFinanciera _entidadFinanciera;
        private readonly ICuentaDeposito _cuentaDeposito;

        public CategoriaPagoModel()
        {
            _categoriaPago = new CategoriaPago();
            _entidadFinanciera = new EntidadFinanciera();
            _cuentaDeposito = new CuentaDeposito();
        }

        public List<CategoriaPagoViewModel> Find()
        {
            var result = new List<CategoriaPagoViewModel>();

            foreach (var item in _categoriaPago.Find())
            {
                result.Add(new CategoriaPagoViewModel(item));
            }

            return result;
        }

        public CategoriaPagoRegistroViewModel Find(int categoriaPagoID)
        {
            CategoriaPago categoriaPago = _categoriaPago.Find(categoriaPagoID);
            var ctasBcoComercio = _cuentaDeposito.Find().Where(x => x.I_EntidadFinanId == Constantes.BANCO_COMERCIO_ID);

            var result = new CategoriaPagoRegistroViewModel(categoriaPago)
            {
                CtasBcoComercio = ctasBcoComercio.Select(x => x.I_CtaDepID).ToArray()
            };

            if (categoriaPago.CuentasDepositoEntidad.Where(x => x.EntidadFinanId == Constantes.BANCO_COMERCIO_ID).Count() > 0)
                result.MostrarCodBanco = true;

            return result;
        }

        public Response Save(CategoriaPagoRegistroViewModel model, int currentUserId)
        {
            CategoriaPago categoriaPago = new CategoriaPago()
            {
                CategoriaId = model.Id,
                Descripcion = model.Nombre,
                Nivel = model.NivelId,
                TipoAlumno = model.TipoAlumnoId,
                Prioridad = model.Prioridad,
                EsObligacion = model.EsObligacion,
                CodBcoComercio = model.CodBcoComercio,
                CuentasDeposito = model.CuentasDeposito.ToList()
            };

            Response result = _categoriaPago.Save(categoriaPago, currentUserId, (model.Id.HasValue ? SaveOption.Update : SaveOption.Insert));

            if (result.Value)
            {
                result.Success(false);
            }
            else
            {
                result.Error(true);
            }
            return result;
        }

        public Response ChangeState(int categoriaPagoID, bool currentState, int currentUserId, string returnUrl)
        {
            Response result = _categoriaPago.ChangeState(categoriaPagoID, currentState, currentUserId);
            result.Redirect = returnUrl;

            return result;
        }

    }
}