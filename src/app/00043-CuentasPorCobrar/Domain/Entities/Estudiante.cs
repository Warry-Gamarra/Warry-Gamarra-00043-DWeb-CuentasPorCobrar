﻿using Data.Procedures;
using Data.Types;
using Domain.DTO;
using Domain.Services;
using NDbfReader;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace Domain.Entities
{
    public class Estudiante : IEstudiante
    {
        private readonly USP_IU_GrabarMatricula _grabarMatricula;

        public Estudiante()
        {
            _grabarMatricula = new USP_IU_GrabarMatricula();
        }

        public Response CargarDataAptos(string serverPath, HttpPostedFileBase file, TipoAlumno tipoAlumno, int currentUserId)
        {
            var result = new Response();
            string fileName = "";
            try
            {
                fileName = GuardarArchivoEnHost(serverPath, file);
                result = GuardarDatosRepositorio(serverPath + fileName, currentUserId);
                RemoverArchivo(serverPath, fileName);

                return result;
            }
            catch (Exception ex)
            {
                RemoverArchivo(serverPath, fileName);
                return new Response()
                {
                    Message = ex.Message
                };
            }
        }


        private string GuardarArchivoEnHost(string serverPath, HttpPostedFileBase file)
        {
            string fileName = Guid.NewGuid() + "__" + file.FileName;
            file.SaveAs(serverPath + fileName);

            return fileName;
        }

        private Response GuardarDatosRepositorio(string pathFile, int currentUserId)
        {
            var dataMatricula = new List<DataMatriculaType>();
                        
            using (var table = Table.Open(pathFile))
            {
                var reader = table.OpenReader(Encoding.ASCII);
                while (reader.Read())
                {
                    dataMatricula.Add(new DataMatriculaType()
                    {
                        C_CodRC = reader.GetString("COD_RC"),
                        C_CodAlu = reader.GetString("COD_ALU"),
                        I_Anio = reader.GetInt32("ANO"),
                        C_Periodo = reader.GetString("P"),
                        C_EstMat = reader.GetString("EST_MAT"),
                        C_Ciclo = reader.GetString("NIVEL"),
                       B_Ingresante = reader.GetBoolean("ES_INGRESA"),
                        I_CreditosDesaprob = reader.GetInt32("CRED_DESAP")
                    });
                }
            }

            var listaAgrupada = dataMatricula.GroupBy(x => new { x.C_CodRC, x.C_CodAlu });

            if (listaAgrupada.Any(x => x.Count() > 1))
            {
                throw new Exception("Existen Códigos de Alumnos duplicados para un mismo programa.");
            }

            if (dataMatricula.Any(x => String.IsNullOrWhiteSpace(x.C_Periodo) || x.I_Anio == null))
            {
                throw new Exception("Existen registros con campos incompletos.");
            }

            DataTable dataTable = new DataTable();
            dataTable.Columns.Add("C_CodRC");
            dataTable.Columns.Add("C_CodAlu");
            dataTable.Columns.Add("I_Anio");
            dataTable.Columns.Add("C_Periodo");
            dataTable.Columns.Add("C_EstMat");
            dataTable.Columns.Add("C_Ciclo");
            dataTable.Columns.Add("B_Ingresante");
            dataTable.Columns.Add("I_CredDesaprob");

            dataMatricula.ForEach(x => dataTable.Rows.Add(
                x.C_CodRC,
                x.C_CodAlu,
                x.I_Anio,
                x.C_Periodo,
                x.C_EstMat,
                x.C_Ciclo,
                x.B_Ingresante,
                x.I_CreditosDesaprob
            ));

            _grabarMatricula.UserID = currentUserId;
            _grabarMatricula.D_FecRegistro = DateTime.Now;

            return new Response(_grabarMatricula.Execute(dataTable));
        }

        private void RemoverArchivo(string serverPath, string fileName)
        {
            System.IO.File.Delete(serverPath + fileName);
        }

    }
}
