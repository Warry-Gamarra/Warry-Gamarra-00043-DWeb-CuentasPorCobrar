﻿using Dapper;
using Data.Connection;
using Data.Types;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data.Procedures
{
    public class USP_I_GrabarPagoTasas
    {
        public int UserID { get; set; }
        private bool B_Result { get; }
        private string T_Message { get; }

        public IEnumerable<DataPagoTasasResult> Execute(DataTable dataTable, string observacion, int UserID)
        {
            IEnumerable<DataPagoTasasResult> response;
            DynamicParameters parameters;

            try
            {
                string s_command = @"USP_I_GrabarPagoTasas";

                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    parameters = new DynamicParameters();
                    parameters.Add(name: "Tbl_Pagos", value: dataTable.AsTableValuedParameter("dbo.type_dataPagoTasa"));
                    parameters.Add(name: "Observacion", dbType: DbType.String, value: observacion);
                    parameters.Add(name: "D_FecRegistro", dbType: DbType.DateTime, value: DateTime.Now);
                    parameters.Add(name: "UserID", dbType: DbType.Int32, value: UserID);

                    response = _dbConnection.Query<DataPagoTasasResult>(s_command, param: parameters, commandType: CommandType.StoredProcedure);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return response;
        }
    }
}