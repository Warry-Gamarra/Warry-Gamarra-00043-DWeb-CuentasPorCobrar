﻿using Domain.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using WebApp.Controllers;

namespace WebApp.ViewModels
{
    public class DevolucionesViewModel
    {
        public int? DevolucionId { get; set; }
        public string CodOperacionPago { get; set; }
        public string ReferenciaBCP { get; set; }
        public string EntidadRecaudadora { get; set; }
        public DateTime? FecAprobacion { get; set; }
        public DateTime? FecDevuelve { get; set; }
        public decimal MontoPago { get; set; }
        public decimal MontoDevolucion { get; set; }
        public string Concepto { get; set; }

        public DevolucionesViewModel() { }

        public DevolucionesViewModel(DevolucionPago devolucionPago)
        {
            this.DevolucionId = devolucionPago.DevolucionId;
            this.CodOperacionPago = devolucionPago.CodOperacionPago;
            this.ReferenciaBCP = devolucionPago.ReferenciaBCP;
            this.EntidadRecaudadora = devolucionPago.EntidadRecaudadoraDesc;
            this.FecAprobacion = devolucionPago.FecAprueba;
            this.FecDevuelve = devolucionPago.FecDevuelve;
            this.MontoPago = devolucionPago.MontoPagado;
            this.MontoDevolucion = devolucionPago.MontoDevolucion;
            this.Concepto = devolucionPago.ConceptoPago;
        }
    }

    public class RegistrarDevolucionPagoViewModel
    {
        public int? DevolucionId { get; set; }

        [Display(Name = "Entidad recaudadora")]
        public int EntidadRecaudadora { get; set; }

        [Display(Name = "Referencia de pago")]
        public string CodOperacionPago { get; set; }

        public DatosPagoViewModel DatosPago { get; set; }

        [Display(Name = "Total descuentos")]
        [Required]
        public decimal MontoDescuento { get; set; }

        [Display(Name = "Total a devolver")]
        [Required]
        public decimal MontoDevolucion { get; set; }

        [Display(Name = "Fec. Aprobación")]
        [Required]
        public DateTime? FecAprueba { get; set; }

        [Display(Name = "Fec. Devolución")]
        public DateTime? FecDevuelve { get; set; }

        [Display(Name = "Comentarios")]
        public string Comentario { get; set; }

        public RegistrarDevolucionPagoViewModel()
        {
            this.DatosPago = new DatosPagoViewModel();
        }

        public RegistrarDevolucionPagoViewModel(DevolucionPago devolucionPago)
        {
            this.DevolucionId = devolucionPago.DevolucionId;
            this.EntidadRecaudadora = devolucionPago.EntidadRecaudadoraId;
            this.CodOperacionPago = devolucionPago.CodOperacionPago;
            this.MontoDevolucion = devolucionPago.MontoDevolucion;
            this.MontoDescuento = devolucionPago.MontoPagado - devolucionPago.MontoDevolucion;
            this.FecAprueba = devolucionPago.FecAprueba;
            this.FecDevuelve = devolucionPago.FecDevuelve;
            this.Comentario = devolucionPago.Comentario;
            this.DatosPago = new DatosPagoViewModel()
            {
                PagoId = devolucionPago.PagoBancoID,
                FecPago = devolucionPago.FecPagoRef,
                EntidadRecaudadoraId = devolucionPago.EntidadRecaudadoraId,
                EntidadRecaudadora = devolucionPago.EntidadRecaudadoraDesc,
                Concepto = devolucionPago.ConceptoPago,
                MontoPago = devolucionPago.MontoPagado
            };
        }

    }
}