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
    public class TR_DevolucionPago
    {
        public int I_DevolucionPagoID { get; set; }
        public int I_PagoBancoID { get; set; }
        public decimal I_MontoPagoDev { get; set; }
        public DateTime? D_FecDevAprob { get; set; }
        public DateTime? D_FecDevPago { get; set; }
        public DateTime? D_FecProc { get; set; }
        public string T_Comentario { get; set; }
        public int? I_UsuarioCre { get; set; }
        public DateTime? D_FecCre { get; set; }
        public int? I_UsuarioMod { get; set; }
        public DateTime? D_FecMod { get; set; }
        public bool B_Anulado { get; set; }

        public ResponseData AnularDevolcionPago(int currentUserId)
        {
            ResponseData result = new ResponseData();
            DynamicParameters parameters = new DynamicParameters();

            try
            {
                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    parameters.Add(name: "I_DevolucionPagoID", dbType: DbType.Int32, value: this.I_DevolucionPagoID);
                    parameters.Add(name: "D_FecMod", dbType: DbType.DateTime, value: this.D_FecMod);
                    parameters.Add(name: "CurrentUserId", dbType: DbType.Int32, value: currentUserId);

                    parameters.Add(name: "B_Result", dbType: DbType.Boolean, direction: ParameterDirection.Output);
                    parameters.Add(name: "T_Message", dbType: DbType.String, size: 4000, direction: ParameterDirection.Output);

                    _dbConnection.Execute("USP_U_AnularDevolucionPago", parameters, commandType: CommandType.StoredProcedure);

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

        public ResponseData Insert(int currentUserId)
        {
            ResponseData result = new ResponseData();
            DynamicParameters parameters = new DynamicParameters();

            try
            {
                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    parameters.Add(name: "I_PagoBancoID", dbType: DbType.Int32, value: this.I_PagoBancoID);
                    parameters.Add(name: "I_MontoPagoDev", dbType: DbType.Decimal, value: this.I_MontoPagoDev);
                    parameters.Add(name: "D_FecDevAprob", dbType: DbType.DateTime, value: this.D_FecDevAprob);
                    parameters.Add(name: "D_FecDevPago", dbType: DbType.DateTime, value: this.D_FecDevPago);
                    parameters.Add(name: "T_Comentario", dbType: DbType.String, value: this.T_Comentario);
                    parameters.Add(name: "D_FecProc", dbType: DbType.DateTime, value: this.D_FecProc);
                    parameters.Add(name: "D_FecCre", dbType: DbType.DateTime, value: this.D_FecCre);
                    parameters.Add(name: "CurrentUserId", dbType: DbType.Int32, value: currentUserId);

                    parameters.Add(name: "B_Result", dbType: DbType.Boolean, direction: ParameterDirection.Output);
                    parameters.Add(name: "T_Message", dbType: DbType.String, size: 4000, direction: ParameterDirection.Output);

                    _dbConnection.Execute("USP_I_GrabarDevolucionPago", parameters, commandType: CommandType.StoredProcedure);

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
                    parameters.Add(name: "I_DevolucionPagoID", dbType: DbType.Int32, value: this.I_DevolucionPagoID);
                    parameters.Add(name: "I_MontoPagoDev", dbType: DbType.Decimal, value: this.I_MontoPagoDev);
                    parameters.Add(name: "D_FecDevAprob", dbType: DbType.DateTime, value: this.D_FecDevAprob);
                    parameters.Add(name: "D_FecDevPago", dbType: DbType.DateTime, value: this.D_FecDevPago);
                    parameters.Add(name: "T_Comentario", dbType: DbType.String, value: this.T_Comentario);
                    parameters.Add(name: "D_FecMod", dbType: DbType.DateTime, value: this.D_FecMod);
                    parameters.Add(name: "CurrentUserId", dbType: DbType.Int32, value: currentUserId);

                    parameters.Add(name: "B_Result", dbType: DbType.Boolean, direction: ParameterDirection.Output);
                    parameters.Add(name: "T_Message", dbType: DbType.String, size: 4000, direction: ParameterDirection.Output);

                    _dbConnection.Execute("USP_U_ActualizarDevolucionPago", parameters, commandType: CommandType.StoredProcedure);

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

        public bool ExisteDevolucion(int I_PagoBancoID)
        {
            bool exist;

            try
            {
                string s_command = "SELECT d.I_DevolucionPagoID FROM TR_DevolucionPago d WHERE d.B_Anulado = 0 AND d.I_PagoBancoID = @I_PagoBancoID;";

                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    var result = _dbConnection.Query<TR_DevolucionPago>(s_command, new { I_PagoBancoID = I_PagoBancoID }, commandType: CommandType.Text).FirstOrDefault();

                    exist = (result != null);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return exist;
        }
    }
}
