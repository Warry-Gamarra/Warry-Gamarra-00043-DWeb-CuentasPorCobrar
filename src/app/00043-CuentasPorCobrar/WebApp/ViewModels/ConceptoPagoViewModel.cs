﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WebApp.ViewModels
{
    public class ConceptoPagoViewModel
    {
        public int? ProcesoId { get; set; }
        public int ConceptoPagoID { get; set; }
        public string DescProceso { get; set; }
        public string ConceptoDesc { get; set; }
        public decimal MontoMinimo { get; set; }
        public decimal Monto { get; set; }
        public bool Habilitado { get; set; }
    }

    public class RegistroConceptoPagoViewModel
    {
        public int? I_ConcPagID { get; set; }
        [Display(Name = "Descripción del concepto")]
        [Required]
        public int I_ConceptoID { get; set; }

        [Display(Name = "Descripción del concepto")]
        [Required]
        public string T_ConceptoPagoDesc { get; set; }

        public bool B_Fraccionable { get; set; }
        public bool B_ConceptoGeneral { get; set; }
        public bool B_AgrupaConcepto { get; set; }
        public int? I_AlumnosDestino { get; set; }
        public int? I_GradoDestino { get; set; }
        public int? I_TipoObligacion { get; set; }
        [Display(Name = "Cuota de Pago")]
        public int I_ProcesoID { get; set; }
        [Display(Name = "Clasificador")]
        public string T_Clasificador { get; set; }
        [Display(Name = "Clasificador (5 dígitos)")]
        public string C_CodTasa { get; set; }
        public bool B_Calculado { get; set; }
        public int? I_Calculado { get; set; }
        public bool B_AnioPeriodo { get; set; }
        [Display(Name = "Año")]
        [RequiredWhenBoolenIsTrue("B_AnioPeriodo")]
        public int? I_Anio { get; set; }
        [Display(Name = "Periodo")]
        [RequiredWhenBoolenIsTrue("B_AnioPeriodo")]
        public int? I_Periodo { get; set; }
        public bool B_Especialidad { get; set; }
        [Display(Name = "Especialidad")]
        [RequiredWhenBoolenIsTrue("B_Especialidad")]
        public char? C_CodRc { get; set; }
        public bool B_Dependencia { get; set; }
        [Display(Name = "Dependencia")]
        [RequiredWhenBoolenIsTrue("B_Dependencia")]
        public int? C_DepCod { get; set; }
        public bool B_GrupoCodRc { get; set; }
        [Display(Name = "Grupo Cod_Rc")]
        [RequiredWhenBoolenIsTrue("B_GrupoCodRc")]
        public int? I_GrupoCodRc { get; set; }
        public bool B_ModalidadIngreso { get; set; }
        [Display(Name = "Cód. Ingreso")]
        [RequiredWhenBoolenIsTrue("B_ModalidadIngreso")]
        public int? I_ModalidadIngresoID { get; set; }
        public bool B_ConceptoAgrupa { get; set; }
        [Display(Name = "Concepto Agrupa")]
        [RequiredWhenBoolenIsTrue("B_ConceptoAgrupa")]
        public int? I_ConceptoAgrupaID { get; set; }
        public bool B_ConceptoAfecta { get; set; }
        [Display(Name = "Concepto Afecta")]
        [RequiredWhenBoolenIsTrue("B_ConceptoAfecta")]
        public int? I_ConceptoAfectaID { get; set; }
        [Display(Name = "Nro de Pagos")]
        [Required]
        public int? N_NroPagos { get; set; }
        [Display(Name = "Porcentaje")]
        public bool B_Porcentaje { get; set; }
        [Required]
        [Display(Name = "Monto")]
        [Range(0, Int32.MaxValue)]
        public decimal? M_Monto { get; set; }
        [Display(Name = "Monto Mínimo")]
        [Range(0, Int32.MaxValue)]
        public decimal? M_MontoMinimo { get; set; }
        public string T_DescripcionLarga { get; set; }
        public string T_Documento { get; set; }
        public bool? B_Habilitado { get; set; }

        public string T_ClasifCorto { get; set; }
        public string C_Moneda { get; set; }

        public bool B_Mora { get; set; }

        public int? I_TipoDescuentoID { get; set; }
        public bool? B_EsPagoMatricula { get; set; }
        public bool? B_EsPagoExtmp { get; set; }
    }
}
