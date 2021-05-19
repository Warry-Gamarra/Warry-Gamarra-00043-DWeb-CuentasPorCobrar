﻿using Data.Tables;
using Domain.Helpers;
using Domain.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Entities
{
    public class ClasificadorPresupuestal : IClasificadores
    {
        public int? Id { get; set; }
        public string CodClasificador { get; set; }
        public string Descripcion { get; set; }
        public string DescripDetalle { get; set; }
        public string AnioEjercicio { get; set; }
        public string CodigoUnfv { get; set; }
        public bool Habilitado { get; set; }
        public DateTime FecUpdated { get; set; }
        public Response Response { get; set; }

        private readonly TC_ClasificadorPresupuestal _clasificadorRepository;
        public ClasificadorPresupuestal()
        {
            _clasificadorRepository = new TC_ClasificadorPresupuestal();
        }

        public ClasificadorPresupuestal(TC_ClasificadorPresupuestal table)
        {
            this.Id = table.I_ClasificadorID;
            this.CodClasificador = table.C_TipoTransCod + "." + table.C_GenericaCod + 
                                   (string.IsNullOrEmpty(table.C_SubGeneCod) ? "" : "." + table.C_SubGeneCod ) +
                                   (string.IsNullOrEmpty(table.C_EspecificaCod) ? "" : "." + table.C_EspecificaCod);
            this.Descripcion = table.T_ClasificadorDesc;
            this.DescripDetalle = table.T_ClasificadorDetalle;
            this.CodigoUnfv = table.T_ClasificadorUnfv;
            this.AnioEjercicio = table.N_Anio;
            this.Habilitado = table.B_Habilitado;
            this.FecUpdated = table.D_FecMod.HasValue ? table.D_FecMod.Value : table.D_FecCre.Value;
            this.Response = new Response() { Value = true };
        }


        public Response ChangeState(int clasificadorId, bool currentState, int currentUserId)
        {
            _clasificadorRepository.I_ClasificadorID = clasificadorId;
            _clasificadorRepository.D_FecMod = DateTime.Now;
            _clasificadorRepository.B_Habilitado = !currentState;

            return new Response(_clasificadorRepository.ChangeState(currentUserId));
        }

        public List<ClasificadorPresupuestal> Find(string anio)
        {
            var result = new List<ClasificadorPresupuestal>();
            foreach (var item in _clasificadorRepository.Find(anio.ToString()))
            {
                result.Add(new ClasificadorPresupuestal(item));
            }

            return result;
        }

        public ClasificadorPresupuestal Find(int clasificadorId)
        {
            return new ClasificadorPresupuestal(_clasificadorRepository.Find(clasificadorId));
        }

        public Response Save(ClasificadorPresupuestal clasificadorDeIngreso, int currentUserId, SaveOption saveOption)
        {
            _clasificadorRepository.I_ClasificadorID = clasificadorDeIngreso.Id.Value;
            //_clasificadorRepository.T_ClasificadorCod = clasificadorDeIngreso.CodigoMef;
            _clasificadorRepository.T_ClasificadorDesc = clasificadorDeIngreso.Descripcion;
            _clasificadorRepository.N_Anio = clasificadorDeIngreso.AnioEjercicio;
            _clasificadorRepository.T_ClasificadorUnfv = clasificadorDeIngreso.CodigoUnfv;
            _clasificadorRepository.D_FecMod = clasificadorDeIngreso.FecUpdated;

            switch (saveOption)
            {
                case SaveOption.Insert:
                    return new Response(_clasificadorRepository.Insert(currentUserId));
                case SaveOption.Update:
                    return new Response(_clasificadorRepository.Update(currentUserId));
            }

            return new Response()
            {
                Value = false,
                Message = "Operación Inváiida."
            };
        }
    }
}