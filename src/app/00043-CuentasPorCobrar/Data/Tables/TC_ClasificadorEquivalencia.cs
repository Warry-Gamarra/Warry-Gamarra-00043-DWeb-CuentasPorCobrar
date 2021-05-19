﻿using Dapper;
using Data.Connection;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Data.Tables
{
    public class TC_ClasificadorEquivalencia
    {
        public int I_ClasifEquivalenciaID { get; set; }
        public int I_ClasificadorID { get; set; }
        public string C_ClasificConceptoCod { get; set; }
        public bool B_Eliminado { get; set; }
        public int I_UsuarioCre { get; set; }
        public DateTime? D_FecCre { get; set; }
        public int I_UsuarioMod { get; set; }
        public DateTime? D_FecMod { get; set; }


        public List<TC_ClasificadorPresupuestal> Find()
        {
            List<TC_ClasificadorPresupuestal> result = new List<TC_ClasificadorPresupuestal>();

            try
            {
                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    string s_command = @"SELECT * FROM TC_ClasificadorEquivalencia WHERE CP.B_Eliminado = 0;";

                    result = _dbConnection.Query<TC_ClasificadorPresupuestal>(s_command, commandType: CommandType.Text).ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }

        public TC_ClasificadorPresupuestal Find(int clasifEquivId)
        {
            TC_ClasificadorPresupuestal result = new TC_ClasificadorPresupuestal();

            try
            {
                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    var s_command = @"SELECT * FROM TC_ClasificadorEquivalencia WHERE I_ClasifEquivalenciaID = @I_ClasifEquivalenciaID AND CP.B_Eliminado = 0;";

                    result = _dbConnection.QueryFirstOrDefault<TC_ClasificadorPresupuestal>(s_command, new { I_ClasifEquivalenciaID = clasifEquivId }, commandType: CommandType.Text);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }


        public ResponseData Insert(int currentUserId)
        {
            ResponseData result = new ResponseData();
            DynamicParameters parameters = new DynamicParameters();

            try
            {
                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    parameters.Add(name: "I_ClasificadorID", dbType: DbType.Int32, value: this.I_ClasificadorID);
                    parameters.Add(name: "C_ClasificConceptoCod", dbType: DbType.String, size: 20, value: this.C_ClasificConceptoCod);
                    parameters.Add(name: "D_FecCre", dbType: DbType.DateTime, value: this.D_FecMod);
                    parameters.Add(name: "CurrentUserId", dbType: DbType.Int32, value: currentUserId);

                    parameters.Add(name: "B_Result", dbType: DbType.Boolean, direction: ParameterDirection.Output);
                    parameters.Add(name: "T_Message", dbType: DbType.String, size: 4000, direction: ParameterDirection.Output);

                    _dbConnection.Execute("USP_I_GrabarClasificadorEquivalencia", parameters, commandType: CommandType.StoredProcedure);

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

        public ResponseData Update(int currentUserId)
        {
            ResponseData result = new ResponseData();
            DynamicParameters parameters = new DynamicParameters();

            try
            {
                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    parameters.Add(name: "I_ClasifEquivalenciaID", dbType: DbType.Int32, value: this.I_ClasifEquivalenciaID);
                    parameters.Add(name: "I_ClasificadorID", dbType: DbType.Int32, value: this.I_ClasificadorID);
                    parameters.Add(name: "C_ClasificConceptoCod", dbType: DbType.String, size: 20, value: this.C_ClasificConceptoCod);
                    parameters.Add(name: "D_FecMod", dbType: DbType.DateTime, value: this.D_FecMod);
                    parameters.Add(name: "CurrentUserId", dbType: DbType.Int32, value: currentUserId);

                    parameters.Add(name: "B_Result", dbType: DbType.Boolean, direction: ParameterDirection.Output);
                    parameters.Add(name: "T_Message", dbType: DbType.String, size: 4000, direction: ParameterDirection.Output);

                    _dbConnection.Execute("USP_U_ActualizarClasificadorEquivalencia", parameters, commandType: CommandType.StoredProcedure);

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