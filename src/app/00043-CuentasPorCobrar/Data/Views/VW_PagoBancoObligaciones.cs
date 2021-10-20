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
    public class VW_PagoBancoObligaciones
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

        public DateTime? D_FecPago { get; set; }

        public decimal I_MontoPago { get; set; }

        public decimal I_InteresMora { get; set; }

        public string T_LugarPago { get; set; }

        public DateTime D_FecCre { get; set; }

        public string T_Observacion { get; set; }

        public int I_CondicionPagoID { get; set; }

        public string T_Condicion { get; set; }

        public decimal I_MontoProcesado { get; set; }

        public string T_MotivoCoreccion { get; set; }

        public static VW_PagoBancoObligaciones FindByID(int idPagoBanco)
        {
            string s_command;
            VW_PagoBancoObligaciones result;
            DynamicParameters parameters;

            try
            {
                s_command = "SELECT b.* FROM dbo.VW_PagoBancoObligaciones b WHERE b.I_PagoBancoID = @I_PagoBancoID";

                parameters = new DynamicParameters();
                parameters.Add(name: "I_PagoBancoID", dbType: DbType.Int32, value: idPagoBanco);
                
                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    result = _dbConnection.Query<VW_PagoBancoObligaciones>(s_command, parameters, commandType: CommandType.Text).FirstOrDefault();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }

        public static IEnumerable<VW_PagoBancoObligaciones> FindByObligacionID(int idObligacion)
        {
            string s_command, filters;
            IEnumerable<VW_PagoBancoObligaciones> result;
            DynamicParameters parameters;

            try
            {
                s_command = "SELECT b.* FROM dbo.VW_PagoBancoObligaciones b WHERE b.I_ObligacionAluID = @I_ObligacionAluID ORDER BY b.D_FecPago";

                filters = "";

                parameters = new DynamicParameters();
                parameters.Add(name: "I_ObligacionAluID", dbType: DbType.Int32, value: idObligacion);

                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    result = _dbConnection.Query<VW_PagoBancoObligaciones>(s_command + filters, parameters, commandType: CommandType.Text);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }

        public static IEnumerable<VW_PagoBancoObligaciones> GetAll(int? idEntidadFinanciera, int? ctdDeposito, string codOperacion, string codDepositante, DateTime? fechaInicio, DateTime? fechaFinal,
            int? condicion)
        {
            string s_command, filters;
            IEnumerable<VW_PagoBancoObligaciones> result;
            DynamicParameters parameters;

            try
            {
                s_command = "SELECT b.* FROM dbo.VW_PagoBancoObligaciones b ";

                filters = "";

                parameters = new DynamicParameters();

                if (idEntidadFinanciera.HasValue)
                {
                    filters = "WHERE b.I_EntidadFinanID = @I_EntidadFinanID ";

                    parameters.Add(name: "I_EntidadFinanID", dbType: DbType.Int32, value: idEntidadFinanciera);
                }

                if (ctdDeposito.HasValue)
                {
                    filters = filters + (filters.Length == 0 ? "WHERE " : "AND ") + "b.I_CtaDepositoID = @I_CtaDepositoID ";

                    parameters.Add(name: "I_CtaDepositoID", dbType: DbType.Int32, value: ctdDeposito);
                }

                if (!String.IsNullOrWhiteSpace(codOperacion))
                {
                    filters = filters + (filters.Length == 0 ? "WHERE " : "AND ") + "b.C_CodOperacion = @C_CodOperacion ";

                    parameters.Add(name: "C_CodOperacion", dbType: DbType.String, value: codOperacion);
                }

                if (!String.IsNullOrWhiteSpace(codDepositante))
                {
                    filters = filters + (filters.Length == 0 ? "WHERE " : "AND ") + "ISNULL(b.C_CodAlu, b.C_CodDepositante) = @C_CodDepositante ";

                    parameters.Add(name: "C_CodDepositante", dbType: DbType.String, value: codDepositante);
                }

                if (fechaInicio.HasValue)
                {
                    filters = filters + (filters.Length == 0 ? "WHERE " : "AND ") + "DATEDIFF(DAY, b.D_FecPago, @D_FechaInicio) <= 0 ";

                    parameters.Add(name: "D_FechaInicio", dbType: DbType.DateTime, value: fechaInicio.Value);
                }

                if (fechaFinal.HasValue)
                {
                    filters = filters + (filters.Length == 0 ? "WHERE " : "AND ") + "DATEDIFF(DAY, b.D_FecPago, @D_FechaFin) >= 0";

                    parameters.Add(name: "D_FechaFin", dbType: DbType.DateTime, value: fechaFinal.Value);
                }

                if (condicion.HasValue)
                {
                    filters = filters + (filters.Length == 0 ? "WHERE " : "AND ") + "b.I_CondicionPagoID = @I_CondicionPagoID ";

                    parameters.Add(name: "I_CondicionPagoID", dbType: DbType.Int32, value: condicion);
                }

                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    result = _dbConnection.Query<VW_PagoBancoObligaciones>(s_command + filters, parameters, commandType: CommandType.Text);
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
