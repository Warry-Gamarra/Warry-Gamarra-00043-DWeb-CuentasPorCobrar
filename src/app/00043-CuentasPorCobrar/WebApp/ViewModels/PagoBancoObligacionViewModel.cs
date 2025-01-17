﻿using Domain.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace WebApp.ViewModels
{
    public class PagoBancoObligacionViewModel
    {
        public int I_PagoBancoID { get; set; }

        public int I_EntidadFinanID { get; set; }

        public string T_EntidadDesc { get; set; }

        public int? I_CtaDepositoID { get; set; }

        public string C_NumeroCuenta { get; set; }

        public string C_CodOperacion { get; set; }

        public string C_CodDepositante { get; set; }
        
        public int? I_ObligacionAluID { get; set; }

        public int? I_MatAluID { get; set; }

        public string C_CodAlu { get; set; }

        public string T_NomDepositante { get; set; }

        public string T_Nombre { get; set; }

        public string T_ApePaterno { get; set; }

        public string T_ApeMaterno { get; set; }

        public string N_Grado { get; set; }

        public string T_CodDepositante
        {
            get
            {
                return I_MatAluID.HasValue ? C_CodAlu : C_CodDepositante;
            }
        }

        public string T_DatosDepositante
        {
            get
            {
                return I_MatAluID.HasValue ? 
                    String.Format("{1} {2}, {0}", T_Nombre, T_ApePaterno, T_ApeMaterno) : T_NomDepositante;
            }
        }

        public DateTime? D_FecPago { get; set; }

        public string T_FecPago
        {
            get
            {
                return D_FecPago.HasValue ? D_FecPago.Value.ToString(FormatosDateTime.BASIC_DATETIME) : "";
            }
        }

        public decimal I_MontoPago { get; set; }

        public string T_MontoPago
        {
            get
            {
                return I_MontoPago.ToString(FormatosDecimal.BASIC_DECIMAL);
            }
        }

        public decimal I_InteresMora { get; set; }

        public string T_InteresMora
        {
            get
            {
                return I_InteresMora.ToString(FormatosDecimal.BASIC_DECIMAL);
            }
        }

        public decimal I_MontoPagoTotal
        {
            get
            {
                return I_MontoPago + I_InteresMora;
            }
        }

        public string T_MontoPagoTotal
        {
            get
            {
                return I_MontoPagoTotal.ToString(FormatosDecimal.BASIC_DECIMAL);
            }
        }

        public string T_LugarPago { get; set; }

        public DateTime D_FecCre { get; set; }

        public string T_Observacion { get; set; }

        public int I_CondicionPagoID { get; set; }

        public string T_Condicion { get; set; }

        public decimal I_MontoProcesado { get; set; }

        public string T_MotivoCoreccion { get; set; }

        public string C_CodigoInterno { get; set; }

        public string T_ProcesoDesc { get; set; }

        public string T_ProcesoDescFecVcto
        {
            get
            {
                return D_FecVencto.HasValue ? String.Format("{0} (F.Vcto. {1})", T_ProcesoDesc, T_FecVencto) : T_ProcesoDesc;
            }
        }

        public DateTime? D_FecVencto { get; set; }

        public string T_FecVencto
        {
            get
            {
                return D_FecVencto.HasValue ? D_FecVencto.Value.ToString(FormatosDateTime.BASIC_DATE) : "";
            }
        }

        public int? I_AnioConstancia { get; set; }

        public int? I_NroConstancia { get; set; }

        public string T_Constancia
        {
            get
            {
                if (I_AnioConstancia.HasValue && I_NroConstancia.HasValue)
                {
                    return String.Format("{0}-{1}", I_AnioConstancia.Value, I_NroConstancia.Value.ToString().PadLeft(5, '0'));
                }
                else
                {
                    return "";
                }
            }
        }
    }
}