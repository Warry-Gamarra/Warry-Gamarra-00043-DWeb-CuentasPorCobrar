﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class TipoComprobanteDTO
    {
        public int tipoComprobanteID { get; set; }

        public string tipoComprobanteCod { get; set; }

        public string tipoComprobanteDesc { get; set; }

        public string inicial {  get; set; }

        public bool estaHabilitado { get; set; }
    }
}