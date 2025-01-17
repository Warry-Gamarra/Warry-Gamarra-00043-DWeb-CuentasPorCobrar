﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class MatriculaDTO
    {
        public int I_MatAluID { get; set; }

        public string C_CodAlu { get; set; }

        public string C_RcCod { get; set; }

        public string T_Nombre { get; set; }

        public string T_ApePaterno { get; set; }

        public string T_ApeMaterno { get; set; }

        public string N_Grado { get; set; }

        public int I_Anio { get; set; }

        public int I_Periodo { get; set; }

        public string C_CodFac { get; set; }

        public string T_FacDesc { get; set; }

        public string C_CodEsc { get; set; }

        public string T_EscDesc { get; set; }

        public string C_EstMat { get; set; }

        public string C_Ciclo { get; set; }

        public bool? B_Ingresante { get; set; }

        public byte? I_CredDesaprob { get; set; }

        public bool B_Habilitado { get; set; }

        public string C_Periodo { get; set; }

        public string T_Periodo { get; set; }

        public string T_DenomProg { get; set; }

        public string C_CodModIng { get; set; }

        public string T_ModIngDesc { get; set; }

        public bool B_TieneMultaPorNoVotar { get; set; }
    }
}
