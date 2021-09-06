﻿using Dapper;
using Data.Connection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data.Views
{
    public class VW_PagoTasas
    {
        public int I_EntidadFinanID { get; set; }

        public string T_EntidadDesc { get; set; }

        public string C_CodTasa { get; set; }

        public string T_ConceptoPagoDesc { get; set; }

        public string T_Clasificador { get; set; }

        public string C_CodClasificador { get; set; }

        public string T_ClasificadorDesc { get; set; }

        public decimal? M_Monto { get; set; }

        public string C_CodOperacion { get; set; }

        public string C_CodDepositante { get; set; }

        public string T_NomDepositante { get; set; }

        public DateTime D_FecPago { get; set; }

        public decimal I_MontoPagado { get; set; }

        public decimal I_InteresMoratorio { get; set; }

        public DateTime D_FecCre { get; set; }

        public static IEnumerable<VW_PagoTasas> GetAll(int? idEntidadFinanciera, string codOperacion, DateTime? fechaInicio, DateTime? fechaFinal)
        {
            string s_command, filters;
            IEnumerable<VW_PagoTasas> result;
            DynamicParameters parameters;
            
            try
            {
                s_command = "SELECT t.* FROM dbo.VW_PagoTasas t ";

                filters = "";

                parameters = new DynamicParameters();

                if (idEntidadFinanciera.HasValue)
                {
                    filters = "WHERE t.I_EntidadFinanID = @I_EntidadFinanID ";

                    parameters.Add(name: "I_EntidadFinanID", dbType: DbType.Int32, value: idEntidadFinanciera);
                }

                if (!String.IsNullOrWhiteSpace(codOperacion))
                {
                    filters = filters + (filters.Length == 0 ? "WHERE " : "AND ") + "t.C_CodOperacion = @C_CodOperacion ";

                    parameters.Add(name: "C_CodOperacion", dbType: DbType.String, value: codOperacion);
                }

                if (fechaInicio.HasValue)
                {
                    filters = filters + (filters.Length == 0 ? "WHERE " : "AND ") + "DATEDIFF(DAY, t.D_FecPago, @D_FechaInicio) <= 0 ";

                    parameters.Add(name: "D_FechaInicio", dbType: DbType.DateTime, value: fechaInicio.Value);
                }

                if (fechaFinal.HasValue)
                {
                    filters = filters + (filters.Length == 0 ? "WHERE " : "AND ") + "DATEDIFF(DAY, t.D_FecPago, @D_FechaFin) >= 0";

                    parameters.Add(name: "D_FechaFin", dbType: DbType.DateTime, value: fechaFinal.Value);
                }

                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    result = _dbConnection.Query<VW_PagoTasas>(s_command + filters, parameters, commandType: CommandType.Text);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }
    }
}
