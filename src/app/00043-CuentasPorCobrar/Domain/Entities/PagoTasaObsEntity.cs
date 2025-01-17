﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class PagoTasaObsEntity
    {
        public int id { get; set; }
        public int? I_TasaUnfvID { get; set; }
        public string C_CodDepositante { get; set; }
        public string T_NomDepositante { get; set; }
        public string C_CodTasa { get; set; }
        public string T_TasaDesc { get; set; }
        public string C_CodOperacion { get; set; }
        public string C_Referencia { get; set; }
        public int I_EntidadFinanID { get; set; }
        public int? I_CtaDepositoID { get; set; }
        public DateTime D_FecPago { get; set; }
        public int I_Cantidad { get; set; }
        public string C_Moneda { get; set; }
        public decimal I_MontoPago { get; set; }
        public decimal I_InteresMora { get; set; }
        public string T_LugarPago { get; set; }
        public string T_InformacionAdicional { get; set; }
        public bool B_Success { get; set; }
        public string T_ErrorMessage { get; set; }
        public string C_CodigoInterno { get; set; }
        public string T_SourceFileName { get; set; }
        public string C_Extorno { get; set; }
        
        public string C_CodServicio { get; set; }
    }
}
