﻿using Domain.Helpers;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Web;

namespace WebApp.ViewModels
{
    public class ConsultaPagosBancoObligacionesViewModel
    {
        public bool buscar { get; set; }

        public string codOperacion { get; set; }

        public string codInterno { get; set; }

        public string codAlumno { get; set; }

        public string nomAlumno { get; set; }

        public string apePaternoAlumno { get; set; }

        public string apeMaternoAlumno { get; set; }

        public int? banco { get; set; }

        public int? ctaDeposito { get; set; }

        public int? condicion { get; set; }

        public string fechaDesde { get; set; }

        public DateTime? fechaInicio
        {
            get
            {
                if (String.IsNullOrWhiteSpace(fechaDesde))
                    return null;

                return DateTime.ParseExact(fechaDesde, FormatosDateTime.BASIC_DATE, CultureInfo.InvariantCulture);
            }
        }

        public string fechaHasta { get; set; }

        public DateTime? fechaFin
        {
            get
            {
                if (String.IsNullOrWhiteSpace(fechaHasta))
                    return null;

                return DateTime.ParseExact(fechaHasta, FormatosDateTime.BASIC_DATE, CultureInfo.InvariantCulture);
            }
        }

        public TipoEstudio? tipoEstudio { get; set; }

        public IEnumerable<PagoBancoObligacionViewModel> resultado;

        public ConsultaPagosBancoObligacionesViewModel()
        {
            resultado = new List<PagoBancoObligacionViewModel>();
        }
    }
}