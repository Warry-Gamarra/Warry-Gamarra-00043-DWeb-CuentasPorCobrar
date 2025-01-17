﻿using Domain.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class ComprobantePagoDTO
    {
        public int pagoBancoID { get; set; }

        public int entidadFinanID { get; set; }

        public string entidadDesc { get; set; }

        public string numeroCuenta { get; set; }

        public string codOperacion { get; set; }

        public string codigoInterno { get; set; }

        public string codDepositante { get; set; }

        public string nomDepositante { get; set; }

        public DateTime fecPago { get; set; }

        public decimal montoPagado { get; set; }

        public decimal interesMoratorio { get; set; }

        public string lugarPago { get; set; }

        public string condicionPago { get; set; }

        public TipoPago tipoPago { get; set; }

        public int? comprobanteID { get; set; }

        public int? serieID { get; set; }

        public int? numeroSerie { get; set; }

        public int? numeroComprobante { get; set; }

        public DateTime? fechaEmision { get; set; }

        public bool? esGravado { get; set; }

        public string ruc { get; set; }

        public string direccion { get; set; }

        public int? tipoComprobanteID { get; set; }

        public string tipoComprobanteCod { get; set; }

        public string tipoComprobanteDesc { get; set; }

        public string inicial {  get; set; }

        public string estadoComprobanteCod { get; set; }

        public string estadoComprobanteDesc { get; set; }

        public string concepto { get; set; }

        public int cantidad { get; set; }

        public string codTasa { get; set; }
    }
}
