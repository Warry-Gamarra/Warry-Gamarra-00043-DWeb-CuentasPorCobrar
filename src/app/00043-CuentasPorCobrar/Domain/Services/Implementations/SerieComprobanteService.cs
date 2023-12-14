﻿using Data.Procedures;
using Data;
using Data.Tables;
using Domain.Entities;
using Domain.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Services.Implementations
{
    public class SerieComprobanteService : ISerieComprobanteService
    {
        public IEnumerable<SerieComprobanteDTO> ListarSeriesComprobante(bool soloHabilitados)
        {
            var files = TC_SerieComprobante.GetAll();

            if (soloHabilitados)
            {
                files = files.Where(x => x.B_Habilitado);
            }

            var result = files.Select(x => Mapper.TC_SerieComprobante_To_SerieComprobanteDTO(x));

            return result;
        }

        public Response GrabarSerieComprobante(SerieComprobanteEntity entity, SaveOption saveOption, int userID)
        {
            ResponseData result;

            switch (saveOption)
            {
                case SaveOption.Insert:

                    var grabar = new USP_I_GrabarSerieComprobante()
                    {
                        I_NumeroSerie = entity.numeroSerie,
                        I_FinNumeroComprobante = entity.finNumeroComprobante,
                        I_DiasAnterioresPermitido = entity.diasAnterioresPermitido,

                    };

                    result = grabar.Execute();

                    break;

                case SaveOption.Update:

                    var actualizar = new USP_U_ActualizarSerieComprobante()
                    {
                        I_SerieID = entity.serieID.Value,
                        I_NumeroSerie = entity.numeroSerie,
                        I_FinNumeroComprobante = entity.finNumeroComprobante,
                        I_DiasAnterioresPermitido = entity.diasAnterioresPermitido,
                        UserID = userID
                    };

                    result = actualizar.Execute();

                    break;

                default:
                    result = new ResponseData()
                    {
                        Value = false,
                        Message = "Acción no válida."
                    };

                    break;
            }

            return new Response(result);
        }

        public Response ActualizarEstadoSerieComprobante(int serieID, bool estaHabilitado, int userID)
        {
            ResponseData result;

            var sp = new USP_U_ActualizarEstadoSerieComprobante()
            {
                I_SerieID = serieID,
                B_Habilitado = estaHabilitado,
                UserID = userID
            };

            result = sp.Execute();

            return new Response(result);
        }

        public Response EliminarEstadoSerieComprobante(int serieID)
        {
            ResponseData result;

            var sp = new USP_U_ActualizarEstadoSerieComprobante()
            {
                I_SerieID = serieID
            };

            result = sp.Execute();

            return new Response(result);
        }
    }
}
