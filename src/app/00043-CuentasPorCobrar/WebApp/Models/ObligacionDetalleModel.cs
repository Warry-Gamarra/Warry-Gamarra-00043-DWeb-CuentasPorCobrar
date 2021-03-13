﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.Models
{
    public class ObligacionDetalleModel
    {
        public int I_ProcesoID { get; set; }

        public string N_CodBanco { get; set; }

        public string C_CodAlu { get; set; }

        public string C_CodRc { get; set; }

        public string T_Nombre { get; set; }

        public string T_ApePaterno { get; set; }

        public string T_ApeMaterno { get; set; }

        public int I_Anio { get; set; }

        public int I_Periodo { get; set; }

        public string C_Periodo { get; set; }

        public string T_Periodo { get; set; }

        public string T_ConceptoDesc { get; set; }

        public string T_CatPagoDesc { get; set; }

        public decimal? I_Monto { get; set; }

        public string T_Monto
        {
            get
            {
                return I_Monto.HasValue ? I_Monto.Value.ToString("N2") : "";
            }
        }

        public bool B_Pagado { get; set; }

        public string T_Pagado
        {
            get
            {
                return B_Pagado ? "Pagd." : "Pendt.";
            }
        }

        public DateTime D_FecVencto { get; set; }

        public string T_FecVencto
        {
            get
            {
                return D_FecVencto.ToString("dd/MM/yyyy");
            }
        }

        public byte? I_Prioridad { get; set; }

        public string C_CodOperacion { get; set; }

        public DateTime? D_FecPago { get; set; }
        
        public string T_FecPago
        {
            get
            {
                return D_FecPago.HasValue ? D_FecPago.Value.ToString("dd/MM/yyyy") : "";
            }
        }

        public string T_LugarPago { get; set; }

        public string C_Moneda { get; set; }

        public int I_TipoObligacion { get; set; }

        public string T_TipoObligacion
        {
            get
            {
                return I_TipoObligacion == 9 ? "Mat" : "Otr" ;
            }
        }
    }
}