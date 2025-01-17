﻿using Domain.Helpers;
using Domain.Entities;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using System.Web.Script.Serialization;

namespace WebApp.ViewModels
{
    public class CategoriaPagoViewModel
    {
        public int? Id { get; set; }
        public string Nombre { get; set; }
        public int NivelGradoId { get; set; }
        public string NivelGrado { get; set; }
        public string TipoAlumno { get; set; }
        public string EsObligacion { get; set; }
        public bool Habilitado { get; set; }
        public string CodBcoComercio { get; set; }

        public CategoriaPagoViewModel()
        {

        }

        public CategoriaPagoViewModel(CategoriaPago categoriaPago)
        {
            this.Id = categoriaPago.CategoriaId;
            this.Nombre = categoriaPago.Descripcion;
            this.NivelGrado = categoriaPago.NivelDesc;
            this.NivelGradoId = categoriaPago.Nivel;
            this.TipoAlumno = categoriaPago.TipoAlumnoDesc;
            this.EsObligacion = categoriaPago.EsObligacion ? "Obligación" : "Tasas";
            this.Habilitado = categoriaPago.Habilitado;
            this.CodBcoComercio = categoriaPago.CodBcoComercio;
        }
    }

    public class CategoriaPagoRegistroViewModel
    {
        public int? Id { get; set; }

        [Display(Name = "Descripción")]
        [Required]
        public string Nombre { get; set; }

        [Display(Name = "Nivel")]
        public int NivelId { get; set; }

        [Display(Name = "Tipo de alumno")]
        public int TipoAlumnoId { get; set; }

        [Display(Name = "Tipo de categoría")]
        public bool EsObligacion { get; set; }

        [Display(Name = "Prioridad")]
        public int Prioridad { get; set; }

        [Display(Name = "Código Bco. Comercio")]
        [MaxLength(10)]
        public string CodBcoComercio { get; set; }

        [Display(Name = "Cuentas Habilitadas")]
        public int[] CuentasDeposito { get; set; }
        public bool MostrarCodBanco { get; set; }
        public int[] CtasBcoComercio { get; set; }

        public CategoriaPagoRegistroViewModel() { }

        public CategoriaPagoRegistroViewModel(CategoriaPago categoriaPago)
        {
            this.Id = categoriaPago.CategoriaId;
            this.Nombre = categoriaPago.Descripcion;
            this.NivelId = categoriaPago.Nivel;
            this.TipoAlumnoId = categoriaPago.TipoAlumno;
            this.Prioridad = categoriaPago.Prioridad;
            this.EsObligacion = categoriaPago.EsObligacion;
            this.CodBcoComercio = categoriaPago.CodBcoComercio;
            this.CuentasDeposito = categoriaPago.CuentasDeposito.ToArray();
        }
    }

    public class ConceptoCategoriaPagoViewModel
    {
        public int? CategoriaId { get; set; }
        public List<CatalogoConceptosViewModel> Conceptos { get; set; }
        public string StrListaConceptos
        {
            get
            {
                return new JavaScriptSerializer().Serialize(this.Conceptos);
            }
        }


        public ConceptoCategoriaPagoViewModel()
        {
            this.Conceptos = new List<CatalogoConceptosViewModel>();

        }
    }

}