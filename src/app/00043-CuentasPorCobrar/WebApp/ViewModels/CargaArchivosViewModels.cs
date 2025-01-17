﻿using Domain.Helpers;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace WebApp.ViewModels
{
    public class CargarArchivoViewModel
    {
        public TipoPago TipoArchivo { get; set; }
        public int EntidadRecaudadora { get; set; }
        public bool InfoInFile { get; set; }
        public int Anio { get; set; }
        public int Periodo { get; set; }
        public string Observacion { get; set; }
    }


    public class ArchivoImportadoViewModel
    {
        public TipoArchivoEntFinan TipoArchivo { get; set; }
        public string EntidadRecaudadora { get; set; }
        public string FileName { get; set; }
        public string UrlFile { get; set; }
        public DateTime FecCarga{ get; set; }
        public decimal FileSize { get; set; }
    }

}