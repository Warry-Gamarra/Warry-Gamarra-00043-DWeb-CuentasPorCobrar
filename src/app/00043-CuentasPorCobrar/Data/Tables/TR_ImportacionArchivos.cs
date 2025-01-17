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
    public class TR_ImportacionArchivo
    {
        public int I_ImportacionID { get; set; }
        public string T_NomArchivo { get; set; }
        public string T_UrlArchivo { get; set; }
        public int I_CantFilas { get; set; }
        public int I_EntidadID { get; set; }
        public int I_TipoArchivo { get; set; }
        public bool B_Eliminado { get; set; }
        public int? I_UsuarioCre { get; set; }
        public DateTime? D_FecCre { get; set; }
        public int? I_UsuarioMod { get; set; }
        public DateTime? D_FecMod { get; set; }
        public string UserName { get; set; }
        public string T_EntidadDesc { get; set; }

        public List<TR_ImportacionArchivo> Find()
        {
            List<TR_ImportacionArchivo> result;

            try
            {
                string s_command = @"SELECT TOP 1000 i.I_ImportacionID, i.T_NomArchivo, i.T_UrlArchivo, i.I_CantFilas, i.I_EntidadID, i.I_TipoArchivo, 
                    i.I_UsuarioCre, i.D_FecCre, i.I_UsuarioMod, i.D_FecMod, u.UserName, e.T_EntidadDesc
                    FROM	dbo.TR_ImportacionArchivo i
                    LEFT JOIN dbo.TC_Usuario U ON I.I_UsuarioCre = U.UserId
                    INNER JOIN dbo.TC_EntidadFinanciera e ON e.I_EntidadFinanID = i.I_EntidadID
                    WHERE i.B_Eliminado = 0 ORDER BY i.D_FecCre DESC;";

                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    result = _dbConnection.Query<TR_ImportacionArchivo>(s_command, commandType: CommandType.Text).ToList();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }

        public TR_ImportacionArchivo Find(int importacionID)
        {
            TR_ImportacionArchivo result;

            try
            {
                string s_command = @"SELECT	I_ImportacionID, T_NomArchivo, T_UrlArchivo, I_CantFilas, I_EntidadID, I_TipoArchivo, B_Eliminado, 
                                        I_UsuarioCre, D_FecCre, I_UsuarioMod, D_FecMod, UserName
                                       FROM	TR_ImportacionArchivo I
		                                    INNER JOIN TC_Usuarios U ON I.I_UsuarioCre = U.UserId
                                      WHERE I_ImportacionID = @I_ImportacionID;";

                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    result = _dbConnection.QueryFirstOrDefault<TR_ImportacionArchivo>(s_command, new { I_ImportacionID = importacionID }, commandType: CommandType.Text);
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
                    parameters.Add(name: "T_NomArchivo", dbType: DbType.String, value: this.T_NomArchivo);
                    parameters.Add(name: "T_UrlArchivo", dbType: DbType.String, value: this.T_UrlArchivo);
                    parameters.Add(name: "I_CantFilas", dbType: DbType.Int32, value: this.I_CantFilas);
                    parameters.Add(name: "I_EntidadID", dbType: DbType.Int32, value: this.I_EntidadID);
                    parameters.Add(name: "I_TipoArchivo", dbType: DbType.Int32, value: this.I_TipoArchivo);
                    parameters.Add(name: "D_FecCre", dbType: DbType.DateTime, value: this.D_FecCre);
                    parameters.Add(name: "CurrentUserId", dbType: DbType.Int32, value: currentUserId);

                    parameters.Add(name: "B_Result", dbType: DbType.Boolean, direction: ParameterDirection.Output);
                    parameters.Add(name: "T_Message", dbType: DbType.String, size: 4000, direction: ParameterDirection.Output);

                    _dbConnection.Execute("USP_I_GrabarImportacionArchivo", parameters, commandType: CommandType.StoredProcedure);

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
