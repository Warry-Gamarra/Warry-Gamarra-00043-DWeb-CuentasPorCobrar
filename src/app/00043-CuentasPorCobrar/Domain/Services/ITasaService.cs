﻿using Domain.Entities;
using Domain.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Services
{
    public interface ITasaService
    {
        IEnumerable<TasaDTO> listar_Tasas();

        ImportacionPagoResponse Grabar_Pago_Tasas(List<PagoTasaEntity> dataPagoTasas, string observacion, int currentUserID);

        IEnumerable<PagoTasaDTO> Listar_Pago_Tasas(int? idEntidadFinanciera, int? idCtaDeposito, string codOperacion, DateTime? fechaInicio, DateTime? fechaFinal,
            string codDepositante, string nomDepositante, string codInterno);

        PagoTasaDTO ObtenerPagoTasa(int I_PagoBancoID);

        Response Grabar_TasaUnfv(TasaEntity tasaEntity, SaveOption saveOption, int[] ctasDepositoServicio);

        TasaEntity ObtenerTasaUnfv(int id);

        Response ChangeState(int tasaUnfvId, bool currentState, int currentUserId);

        int[] ObtenerCtaDepositoServicioIDs(int tasaUnfvID);
    }
}
