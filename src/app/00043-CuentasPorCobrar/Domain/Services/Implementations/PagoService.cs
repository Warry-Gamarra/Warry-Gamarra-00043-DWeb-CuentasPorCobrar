﻿using Data.Procedures;
using Data.Tables;
using Data.Views;
using Domain.Entities;
using Domain.Helpers;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Domain.Services.Implementations
{
    public class PagoService : IPagoService
    {
        private readonly TRI_PagoProcesadoUnfv _pagoProcesadoUnfv;
        private readonly TR_ImportacionArchivo _importacionArchivo;

        public PagoService()
        {
            _pagoProcesadoUnfv = new TRI_PagoProcesadoUnfv();
            _importacionArchivo = new TR_ImportacionArchivo();
        }


        public Response AnularRegistroPago(int pagoProcesId, int currentUserId, DateTime fecUpdate)
        {
            _pagoProcesadoUnfv.I_PagoProcesID = pagoProcesId;
            _pagoProcesadoUnfv.I_UsuarioMod = currentUserId;
            _pagoProcesadoUnfv.D_FecMod = fecUpdate;

            return new Response(_pagoProcesadoUnfv.AnularRegistroPago());
        }

        public Response GrabarNroSiafPago(int pagoProcesId, int nroSiaf, int currentUserId, DateTime fecUpdate)
        {
            _pagoProcesadoUnfv.I_PagoProcesID = pagoProcesId;
            _pagoProcesadoUnfv.N_NroSIAF = nroSiaf;
            _pagoProcesadoUnfv.I_UsuarioMod = currentUserId;
            _pagoProcesadoUnfv.D_FecMod = fecUpdate;

            return new Response(_pagoProcesadoUnfv.SaveNroSIAF());
        }

        public void GrabarRegistroArchivo(string fileName, string urlFile, int rowsCount, int entidadFinanID, int tipoArchivoID, int currentUserId)
        {
            _importacionArchivo.T_NomArchivo = fileName;
            _importacionArchivo.T_UrlArchivo = urlFile;
            _importacionArchivo.I_CantFilas = rowsCount;
            _importacionArchivo.I_EntidadID = entidadFinanID;
            _importacionArchivo.I_TipoArchivo = tipoArchivoID;
            _importacionArchivo.D_FecCre = DateTime.Now;

            _importacionArchivo.Insert(currentUserId);
        }


        public bool ValidarCodOperacionObligacion(string C_CodOperacion, string C_CodDepositante, int I_EntidadFinanID, DateTime? D_FecPago)
        {
            var spParams = new USP_S_ValidarCodOperacionObligacion()
            {
                C_CodOperacion = C_CodOperacion,
                C_CodDepositante = C_CodDepositante,
                I_EntidadFinanID = I_EntidadFinanID,
                D_FecPago = D_FecPago
            };

            return USP_S_ValidarCodOperacionObligacion.Execute(spParams);
        }
        
        public bool ValidarCodOperacionTasa(string C_CodOperacion, int I_EntidadFinanID, DateTime? D_FecPago)
        {
            var spParams = new USP_S_ValidarCodOperacionTasa()
            {
                C_CodOperacion = C_CodOperacion,
                I_EntidadFinanID = I_EntidadFinanID,
                D_FecPago = D_FecPago
            };

            return USP_S_ValidarCodOperacionTasa.Execute(spParams);
        }

        public List<PagoEntity> BuscarPagoRegistrado(int entRecaudaId, string codOperacion)
        {
            List<PagoEntity> result = new List<PagoEntity>();

            foreach (var item in VW_Pagos.Find(entRecaudaId, codOperacion))
            {
                result.Add(new PagoEntity(item));
            }

            return result;
        }

        public List<PagoEntity> ListarPagosRegistrados(DateTime? fecIni, DateTime? fecFin, int? dependenciaId, int? entRecaudaId)
        {
            List<PagoEntity> result = new List<PagoEntity>();

            fecIni = fecIni ?? DateTime.ParseExact("19010101", "yyyyMMdd", CultureInfo.InvariantCulture);
            fecFin = fecFin ?? DateTime.Now.AddDays(1);

            foreach (var item in VW_Pagos.Find(entRecaudaId, dependenciaId, fecIni.Value, fecFin.Value))
            {
                result.Add(new PagoEntity(item));
            }

            return result;
        }

        public PagoEntity ObtenerDatosPago(int pagoProcesId)
        {
            return new PagoEntity(VW_Pagos.Find(pagoProcesId));
        }

        public IEnumerable<ArchivoImportadoDTO> ListarArchivosImportados(TipoArchivoEntFinan tipoArchivo)
        {
            var lista = _importacionArchivo.Find();

            int tipoArchivoID;

            switch (tipoArchivo)
            {
                case TipoArchivoEntFinan.Datos_Alumno:
                    tipoArchivoID = 1;
                    break;
                case TipoArchivoEntFinan.Deuda_Obligaciones:
                    tipoArchivoID = 2;
                    break;
                case TipoArchivoEntFinan.Recaudacion_Obligaciones:
                    tipoArchivoID = 3;
                    break;
                case TipoArchivoEntFinan.Recaudacion_Tasas:
                    tipoArchivoID = 4;
                    break;
                default:
                    tipoArchivoID = 0;
                    break;
            }

            var result = lista.Where(x=> x.I_TipoArchivo.Equals(tipoArchivoID))
                .Select(x => Mapper.TR_ImportacionArchivo_To_ArchivoImportadoDTO(x));

            return result;
        }

        public List<PagoEntity> ListarPagosRegistrados(DateTime? fecIni, DateTime? fecFin, TipoEstudio? tipoEstudio, int? entRecaudaId, TipoPago? tipoPago)
        {
            List<PagoEntity> result = new List<PagoEntity>();
            IEnumerable<VW_Pagos> data; 
            fecIni = fecIni ?? DateTime.ParseExact("19010101", "yyyyMMdd", CultureInfo.InvariantCulture);
            fecFin = fecFin ?? DateTime.Now.AddDays(1);

            bool esObligacion = false;

            if (tipoPago.HasValue)
            {
                esObligacion = TipoPago.Obligacion == tipoPago.Value ? true : false;
            }
  
            switch (tipoEstudio)
            {
                case TipoEstudio.Pregrado:
                    data = VW_Pagos.FindPregrado(entRecaudaId, null, esObligacion, fecIni.Value, fecFin.Value);
                    break;
                case TipoEstudio.Posgrado:
                    data = VW_Pagos.FindPosgrado(entRecaudaId, null, esObligacion, fecIni.Value, fecFin.Value);
                    break;
                default:
                    data = VW_Pagos.Find(entRecaudaId, null, fecIni.Value, fecFin.Value);
                    break;
            }

            foreach (var item in data.OrderBy(x => x.C_CodDepositante))
            {
                result.Add(new PagoEntity(item));
            }

            return result;
        }

        public IEnumerable<PagoBancoObligacionDTO> ListarPagosBanco(int? idEntidadFinanciera, int? ctdDeposito, string codOperacion, string codDepositante, DateTime? fechaInicio, DateTime? fechaFinal,
            int? condicion, string nomAlumno, string apellidoPaterno, string apellidoMaterno)
        {
            var lista = VW_PagoBancoObligaciones.GetAll(idEntidadFinanciera, ctdDeposito, codOperacion, codDepositante, fechaInicio, fechaFinal, condicion,
                nomAlumno, apellidoPaterno, apellidoMaterno);

            var result = lista.Select(x => Mapper.VW_PagoBancoObligaciones_To_PagoObligacionDTO(x));

            return result;
        }

        public IEnumerable<PagoBancoObligacionDTO> ListarPagosBancoPorObligacion(int idObligacion)
        {
            var lista = VW_PagoBancoObligaciones.FindByObligacionID(idObligacion);

            var result = lista.Select(x => Mapper.VW_PagoBancoObligaciones_To_PagoObligacionDTO(x));

            return result;
        }

        public PagoBancoObligacionDTO ObtenerPagoBanco(int idPagoBanco)
        {
            var pago = VW_PagoBancoObligaciones.FindByID(idPagoBanco);

            return pago == null ? null : Mapper.VW_PagoBancoObligaciones_To_PagoObligacionDTO(pago);
        }

        public Response AsignarPagoObligacion(int obligacionID, int pagoBancoID, int UserID, string motivoCoreccion)
        {
            var result = USP_IU_RelacionarPagoConObligacion.Execute(obligacionID, pagoBancoID, UserID, motivoCoreccion);

            return new Response(result);
        }

        public Response DesenlazarPagoObligacion(int pagoBancoID, int UserID, string motivoCoreccion)
        {
            var result = USP_U_DesenlazarPagoObligacion.Execute(pagoBancoID, UserID, motivoCoreccion);

            return new Response(result);
        }

        public IEnumerable<PagoObligacionDetalleDTO> ObtenerPagoObligacionDetalle(int idObligacionDet)
        {
            var lista = PagoObligacionDetalle.FindByObligacionDetId(idObligacionDet);

            var result = lista.Select(x => new PagoObligacionDetalleDTO() {
                C_CodOperacion = x.C_CodOperacion,
                D_FecPago = x.D_FecPago,
                T_LugarPago = x.T_LugarPago
            });

            return result;
        }
    }
}
