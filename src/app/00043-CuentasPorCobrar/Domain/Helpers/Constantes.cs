﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Helpers
{
    public static class Bancos
    {
        public const int BANCO_COMERCIO_ID = 1;

        public const int BCP_ID = 2;
    }

    public static class FormatosDateTime
    {
        public const string BASIC_DATE = "dd/MM/yyyy";

        public const string BASIC_DATE2 = "dd-MM-yyyy";

        public const string BASIC_DATE3 = "yyyy-MM-dd";

        public const string BASIC_TIME = "HH:mm:ss";

        public const string BASIC_DATETIME = "dd/MM/yyyy HH:mm:ss";

        public const string BASIC_DATETIME2 = "dd-MM-yyyy HH:mm:ss";

        public const string PAYMENT_DATETIME_FORMAT = "yyyyMMddHHmmss";
    }

    public static class FormatosDecimal
    {
        public const string BASIC_DECIMAL = "#,0.00";
        public const string BASIC_DECIMAL_NO_COMA = "0.00";
    }

    public static class ConstantesBCP
    {
        public const string CodExtorno = "E";
    }

    public static class EstadoObligacion
    {
        public static string ObtenerDescripcion(bool? pagado)
        {
            return pagado.HasValue ? (pagado.Value ? "Pagado" : "Pendiente") : "";
        }
    }

    public static class RoleNames
    {
        public const string ADMINISTRADOR = "Administrador";

        public const string CONSULTA = "Consulta";

        public const string CONTABILIDAD = "Contabilidad";

        public const string TESORERIA = "Tesorería";

        public const string DEPENDENCIA = "Dependencia";

        public const string TESORERIA_AVANZADO = "Tesorería Avanzado";
    }

    public static class DependenciaEUPG
    {
        public const int ID = 14;
    }

    public  static class Digiflow
    {
        public static readonly decimal IGV = decimal.Parse(ConfigurationManager.AppSettings["IGV"].ToString());

        public static readonly int MAXIMO_NUMERO_SERIE = int.Parse(ConfigurationManager.AppSettings["MaxNumSerie"].ToString());

        public static readonly string RUC_UNFV = ConfigurationManager.AppSettings["RucUnfv"].ToString();

        public static readonly string GENERAR_COMPROBANTE_URL = ConfigurationManager.AppSettings["ComprobantesApiBaseUrl"].ToString() + "api/comprobantes/generararchivo/";

        public static readonly string LISTAR_CORRECTOS_URL = ConfigurationManager.AppSettings["ComprobantesApiBaseUrl"].ToString() + "api/comprobantes/listarcorrectos/";

        public static readonly string LISTAR_ERRORES_URL = ConfigurationManager.AppSettings["ComprobantesApiBaseUrl"].ToString() + "api/comprobantes/listarerrores/";
    }

    public static class EstadoComprobante
    {
        public const string PENDIENTE = "PEN";

        public const string PROCESADO = "PRO";

        public const string ERROR = "ERR";

        public const string NOFILE = "NOF";

        public const string BAJA = "BAJ";
    }

    public static class CodigoTipoComprobante
    {
        public const string FACTURA = "01";

        public const string BOLETA = "03";

        public const string NOTA_CREDITO = "07";

        public const string NOTA_DEBITO = "08";
    }
}
