﻿using Dapper;
using Data.Connection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data.Procedures
{
    public class USP_U_ActualizarPeriodo
    {
        public int I_PeriodoID { get; set; }
        public int I_TipoPeriodoID { get; set; }
        public short? I_Anio { get; set; }
        public DateTime? D_FecVencto { get; set; }
        public byte? I_Prioridad { get; set; }
        public bool B_Habilitado { get; set; }
        public int I_UsuarioMod { get; set; }

        public ResponseData Execute()
        {
            ResponseData result = new ResponseData();
            DynamicParameters parameters = new DynamicParameters();

            try
            {
                string s_command = @"USP_U_ActualizarPeriodo";
            
                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    parameters.Add(name: "I_PeriodoID", dbType: DbType.Int32, value: this.I_PeriodoID);
                    parameters.Add(name: "I_TipoPeriodoID", dbType: DbType.Int32, value: this.I_TipoPeriodoID);
                    parameters.Add(name: "I_Anio", dbType: DbType.Int16, value: this.I_Anio);
                    parameters.Add(name: "D_FecVencto", dbType: DbType.DateTime, value: this.D_FecVencto);
                    parameters.Add(name: "I_Prioridad", dbType: DbType.Byte, value: this.I_Prioridad);
                    parameters.Add(name: "B_Habilitado", dbType: DbType.Boolean, value: this.B_Habilitado);
                    parameters.Add(name: "I_UsuarioMod", dbType: DbType.Int32, value: this.I_UsuarioMod);

                    parameters.Add(name: "B_Result", dbType: DbType.Boolean, direction: ParameterDirection.Output);
                    parameters.Add(name: "T_Message", dbType: DbType.String, size: 4000, direction: ParameterDirection.Output);

                    _dbConnection.Execute(s_command, parameters, commandType: CommandType.StoredProcedure);

                    result.CurrentID = this.I_PeriodoID.ToString();
                    result.Value = parameters.Get<bool>("B_Result");
                    result.Message = parameters.Get<string>("T_Message");
                }
            }
            catch (Exception ex)
            {
                result.Value = false;
                result.Message = ex.Message;
            }

            return result;
        }
    }
}
