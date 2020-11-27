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
    public class USP_S_ConceptoPago_Periodo_Habilitados
    {
        public int I_ConcPagPerID { get; set; }
        public string T_TipoPerDesc { get; set; }
        public string T_ConceptoDesc { get; set; }
        public int I_Anio { get; set; }
        public int I_Periodo { get; set; }
        public decimal M_Monto { get; set; }
        
        public static List<USP_S_ConceptoPago_Periodo_Habilitados> Execute()
        {
            List<USP_S_ConceptoPago_Periodo_Habilitados> result;

            try
            {
                string s_command = @"USP_S_ConceptoPago_Periodo_Habilitados";

                using (var _dbConnection = new SqlConnection(Database.ConnectionString))
                {
                    result = _dbConnection.Query<USP_S_ConceptoPago_Periodo_Habilitados>(s_command, commandType: CommandType.StoredProcedure).ToList();
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