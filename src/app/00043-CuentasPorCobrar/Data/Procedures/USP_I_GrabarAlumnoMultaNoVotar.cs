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
    public class USP_I_GrabarAlumnoMultaNoVotar
    {
        public int UserID { get; set; }
        public DateTime D_FecRegistro { get; set; }
        private bool B_Result { get; set; }
        private string T_Message { get; set; }

        public List<MultaNoVotarResult> Execute(DataTable dataTable)
        {
            List<MultaNoVotarResult> result;
            DynamicParameters parameters;

            try
            {
                string s_command = @"USP_I_GrabarAlumnoMultaNoVotar";

                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    parameters = new DynamicParameters();
                    parameters.Add(name: "Tbl_AlumnosMultaNoVotar", value: dataTable.AsTableValuedParameter("dbo.type_dataAlumnoMultaNoVotar"));
                    parameters.Add(name: "D_FecRegistro", dbType: DbType.DateTime, value: this.D_FecRegistro);
                    parameters.Add(name: "UserID", dbType: DbType.Int32, value: this.UserID);
                    parameters.Add(name: "B_Result", dbType: DbType.Boolean, direction: ParameterDirection.Output);
                    parameters.Add(name: "T_Message", dbType: DbType.String, size: 4000, direction: ParameterDirection.Output);

                    result = _dbConnection.Query<MultaNoVotarResult>(s_command, param: parameters, commandType: CommandType.StoredProcedure).ToList();
                    B_Result = parameters.Get<bool>("B_Result");
                    T_Message = parameters.Get<string>("T_Message");

                    if (!B_Result)
                        throw new Exception(T_Message);
                }
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }

            return result;
        }
    }
}
