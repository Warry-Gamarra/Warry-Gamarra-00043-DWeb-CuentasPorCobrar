﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class Proceso
    {
        public int I_ProcesoID { get; set; }
        public int I_CatPagoID { get; set; }
        public short? I_Anio { get; set; }
        public int I_Periodo { get; set; }
        public string T_CatPagoDesc { get; set; }
        public string T_PeriodoDesc { get; set; }
        public string C_PeriodoCod { get; set; }
        public string N_CodBanco { get; set; }
        public string T_ProcesoDesc { get; set; }
        public DateTime? D_FecVencto { get; set; }
        public short? I_Prioridad { get; set; }
        public bool B_Obligacion { get; set; }
        public int I_Nivel { get; set; }
        public string C_Nivel { get; set; }
        public int I_TipoAlumno { get; set; }
        public string T_TipoAlumno { get; set; }
        public string C_TipoAlumno { get; set; }

        public int? cuotaPagoID { get; set; }
        public DateTime? D_FecVenctoExt { get; set; }
    }
}
