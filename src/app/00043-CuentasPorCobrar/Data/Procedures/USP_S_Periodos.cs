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
    public class USP_S_Periodos
    {
        public int I_PeriodoID { get; set; }
        public string T_CuotaPagoDesc { get; set; }
        public int N_Anio { get; set; }
        public DateTime D_FecIni { get; set; }
        public DateTime D_FecFin { get; set; }

        public static List<USP_S_Periodos> Execute()
        {
            List<USP_S_Periodos> result;

            try
            {
                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    string s_command = @"USP_S_Periodos";

                    result = _dbConnection.Query<USP_S_Periodos>(s_command, commandType: CommandType.StoredProcedure).ToList();
                    
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
