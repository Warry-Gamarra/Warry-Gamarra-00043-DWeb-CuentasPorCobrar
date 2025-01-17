﻿using Domain.Helpers;
using Domain.Entities;
using Domain.Services;
using Domain.Services.Implementations;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WebApp.ViewModels;

namespace WebApp.Models
{
    public class ConceptoPagoModel
    {
        ConceptoPagoService conceptoPagoService;
        IProcesoService procesoService;
        readonly CategoriaPago categoriaPago;

        public ConceptoPagoModel()
        {
            conceptoPagoService = new ConceptoPagoService();
            procesoService = new ProcesoService();
            categoriaPago = new CategoriaPago();
        }


        public Response ChangeState(int conceptoId, bool currentState, int currentUserId, string returnUrl)
        {
            Response result = conceptoPagoService.ChangeStateConceptoProceso(conceptoId, currentState, currentUserId);
            result.Redirect = returnUrl;

            return result;
        }

        public List<CatalogoConceptosViewModel> Listar_CatalogoConceptos(TipoPago tipoPago, bool conceptoAgrupa = false)
        {
            List<CatalogoConceptosViewModel> result = new List<CatalogoConceptosViewModel>();

            foreach (var item in conceptoPagoService.Listar_Concepto(tipoPago).Where(x => x.B_ConceptoAgrupa == conceptoAgrupa))
            {
                result.Add(new CatalogoConceptosViewModel(item));
            }

            return result;
        }

        public List<SelectViewModel> Listar_Combo_Procesos()
        {
            List<SelectViewModel> result = new List<SelectViewModel>();

            var lista = procesoService.Listar_Procesos();

            if (lista != null)
            {
                result = lista.Select(x => new SelectViewModel()
                {
                    Value = x.I_ProcesoID.ToString(),
                    TextDisplay = x.T_CatPagoDesc
                }).ToList();
            }

            return result;
        }

        public RegistroConceptoPagoViewModel InicializarConceptoPago(int procesoId)
        {
            var proceso = procesoService.Obtener_Proceso(procesoId);
            var categoria = categoriaPago.Find(proceso.I_CatPagoID);

            RegistroConceptoPagoViewModel result = new RegistroConceptoPagoViewModel()
            {
                I_ProcesoID = procesoId,
                I_AlumnosDestino = categoria.TipoAlumno,
                I_GradoDestino = categoria.Nivel,
                I_Anio = proceso.I_Anio,
                I_Periodo = proceso.I_Periodo,
            };

            return result;
        }

        public Response Grabar_ConceptoPago(RegistroConceptoPagoViewModel model, int currentUserId)
        {
            ConceptoPagoEntity conceptoPagoEntity;
            
            var saveOption = (!model.I_ConcPagID.HasValue) ? SaveOption.Insert : SaveOption.Update;

            conceptoPagoEntity = new ConceptoPagoEntity()
            {
                I_ConcPagID = model.I_ConcPagID.GetValueOrDefault(),
                I_ProcesoID = model.I_ProcesoID,
                I_ConceptoID = model.I_ConceptoID,
                T_ConceptoPagoDesc = model.T_ConceptoPagoDesc.ToUpper(),
                B_Fraccionable = model.B_Fraccionable,
                B_ConceptoGeneral = model.B_ConceptoGeneral,
                B_AgrupaConcepto = model.B_AgrupaConcepto,
                I_AlumnosDestino = model.I_AlumnosDestino,
                I_GradoDestino = model.I_GradoDestino,
                I_TipoObligacion = model.I_TipoObligacion,
                T_Clasificador = model.T_Clasificador,
                C_CodTasa = model.C_CodTasa,
                B_Calculado = (!model.I_Calculado.HasValue || model.I_Calculado.Value == 0) ? false : true,
                I_Calculado = model.I_Calculado,
                B_AnioPeriodo = (model.I_Anio.HasValue && model.I_Periodo.HasValue) ? true : false,
                I_Anio = model.I_Anio,
                I_Periodo = model.I_Periodo,
                B_Especialidad = model.C_CodRc.HasValue,
                C_CodRc = model.C_CodRc,
                B_Dependencia = (!model.C_DepCod.HasValue || model.C_DepCod.Value == 0) ? false : true,
                C_DepCod = model.C_DepCod,
                B_GrupoCodRc = (!model.I_GrupoCodRc.HasValue || model.I_GrupoCodRc.Value == 0) ? false : true,
                I_GrupoCodRc = model.I_GrupoCodRc,
                B_ModalidadIngreso = (!model.I_ModalidadIngresoID.HasValue || model.I_ModalidadIngresoID.Value == 0) ? false : true,
                I_ModalidadIngresoID = model.I_ModalidadIngresoID,
                B_ConceptoAgrupa = (!model.I_ConceptoAgrupaID.HasValue || model.I_ConceptoAgrupaID.Value == 0) ? false : true,
                I_ConceptoAgrupaID = model.I_ConceptoAgrupaID,
                B_ConceptoAfecta = (!model.I_ConceptoAfectaID.HasValue || model.I_ConceptoAfectaID.Value == 0) ? false : true,
                I_ConceptoAfectaID = model.I_ConceptoAfectaID,
                N_NroPagos = model.N_NroPagos,
                B_Porcentaje = model.B_Porcentaje,
                C_Moneda = model.C_Moneda,
                M_Monto = model.M_Monto,
                M_MontoMinimo = model.M_MontoMinimo,
                T_DescripcionLarga = model.T_DescripcionLarga,
                T_Documento = model.T_Documento,
                B_Habilitado = model.B_Habilitado.HasValue ? model.B_Habilitado.GetValueOrDefault() : true,
                I_UsuarioCre = currentUserId,
                I_UsuarioMod = currentUserId,
                B_Mora = model.B_Mora,
                I_TipoDescuentoID = model.I_TipoDescuentoID,
                B_EsPagoMatricula = model.B_EsPagoMatricula ?? false,
                B_EsPagoExtmp = model.B_EsPagoExtmp ?? false
            };

            var result = conceptoPagoService.Grabar_ConceptoPago(conceptoPagoEntity, saveOption);

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

        public RegistroConceptosProcesoViewModel ObtenerConceptoPagoProceso(int procesoId, int conceptoPagoId)
        {
            var result = new RegistroConceptosProcesoViewModel()
            {
                ProcesoId = procesoId,
                ConceptoPago = Obtener_ConceptoPago(conceptoPagoId),
                MostrarFormulario = true,
            };

            return result;
        }

        public RegistroConceptoPagoViewModel Obtener_ConceptoPago(int I_ConcPagID)
        {
            var conceptoPago = conceptoPagoService.Obtener_ConceptoPago(I_ConcPagID);

            var model = new RegistroConceptoPagoViewModel()
            {
                I_ConcPagID = conceptoPago.I_ConcPagID,
                I_ProcesoID = conceptoPago.I_ProcesoID,
                I_ConceptoID = conceptoPago.I_ConceptoID,
                T_ConceptoPagoDesc = conceptoPago.T_ConceptoPagoDesc,
                B_Fraccionable = conceptoPago.B_Fraccionable.HasValue ? conceptoPago.B_Fraccionable.Value : false,
                B_ConceptoGeneral = conceptoPago.B_ConceptoGeneral.HasValue ? conceptoPago.B_ConceptoGeneral.Value : false,
                B_AgrupaConcepto = conceptoPago.B_AgrupaConcepto.HasValue ? conceptoPago.B_AgrupaConcepto.Value : false,
                I_AlumnosDestino = conceptoPago.I_AlumnosDestino,
                I_GradoDestino = conceptoPago.I_GradoDestino,
                I_TipoObligacion = conceptoPago.I_TipoObligacion,
                T_Clasificador = conceptoPago.T_Clasificador,
                C_CodTasa = conceptoPago.C_CodTasa,
                B_Calculado = conceptoPago.B_Calculado.HasValue ? conceptoPago.B_Calculado.Value : false,
                I_Calculado = conceptoPago.I_Calculado,
                B_AnioPeriodo = conceptoPago.B_AnioPeriodo.HasValue ? conceptoPago.B_AnioPeriodo.Value : false,
                I_Anio = conceptoPago.I_Anio,
                I_Periodo = conceptoPago.I_Periodo,
                B_Especialidad = conceptoPago.B_Especialidad.HasValue ? conceptoPago.B_Especialidad.Value : false,
                C_CodRc = conceptoPago.C_CodRc,
                B_Dependencia = conceptoPago.B_Dependencia.HasValue ? conceptoPago.B_Dependencia.Value : false,
                C_DepCod = conceptoPago.C_DepCod,
                B_GrupoCodRc = conceptoPago.B_GrupoCodRc.HasValue ? conceptoPago.B_GrupoCodRc.Value : false,
                I_GrupoCodRc = conceptoPago.I_GrupoCodRc,
                B_ModalidadIngreso = conceptoPago.B_ModalidadIngreso.HasValue ? conceptoPago.B_ModalidadIngreso.Value : false,
                I_ModalidadIngresoID = conceptoPago.I_ModalidadIngresoID,
                B_ConceptoAgrupa = conceptoPago.B_ConceptoAgrupa.HasValue ? conceptoPago.B_ConceptoAgrupa.Value : false,
                I_ConceptoAgrupaID = conceptoPago.I_ConceptoAgrupaID,
                B_ConceptoAfecta = conceptoPago.B_ConceptoAfecta.HasValue ? conceptoPago.B_ConceptoAfecta.Value : false,
                I_ConceptoAfectaID = conceptoPago.I_ConceptoAfectaID,
                N_NroPagos = conceptoPago.N_NroPagos,
                B_Porcentaje = conceptoPago.B_Porcentaje.HasValue ? conceptoPago.B_Porcentaje.Value : false,
                M_Monto = conceptoPago.M_Monto,
                M_MontoMinimo = conceptoPago.M_MontoMinimo,
                T_DescripcionLarga = conceptoPago.T_DescripcionLarga,
                T_Documento = conceptoPago.T_Documento,
                B_Habilitado = conceptoPago.B_Habilitado,
                B_Mora = conceptoPago.B_Mora.GetValueOrDefault(),
                I_TipoDescuentoID = conceptoPago.I_TipoDescuentoID,
                B_EsPagoMatricula = conceptoPago.B_EsPagoMatricula,
                B_EsPagoExtmp = conceptoPago.B_EsPagoExtmp
            };

            return model;
        }
    }
}