
SELECT -- CUOTA_PAGO, DESCRIPCIO , SUBSTRING(LTRIM(DESCRIPCIO),1,4), SUBSTRING(LTRIM(DESCRIPCIO),5,1), 
	   LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),5,LEN(DESCRIPCIO))), COUNT(*)
FROM cp_des
WHERE ISNUMERIC(LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),1,4))) = 1 
	AND SUBSTRING(LTRIM(DESCRIPCIO),5,1) = ' '
GROUP BY LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),5,LEN(DESCRIPCIO)))--, PRIORIDAD
ORDER BY 2 DESC

SELECT -- CUOTA_PAGO, DESCRIPCIO , SUBSTRING(LTRIM(DESCRIPCIO),1,4), SUBSTRING(LTRIM(DESCRIPCIO),5,1), 
		LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),5,LEN(DESCRIPCIO))), COUNT(*)
FROM cp_des
WHERE ISNUMERIC(LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),1,4))) = 1 
	AND SUBSTRING(LTRIM(DESCRIPCIO),5,1) <> ''
GROUP BY LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),5,LEN(DESCRIPCIO)))
ORDER BY 2 DESC

SELECT -- CUOTA_PAGO, DESCRIPCIO , SUBSTRING(LTRIM(DESCRIPCIO),1,4), SUBSTRING(LTRIM(DESCRIPCIO),5,1), 
		LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),5,LEN(DESCRIPCIO))), COUNT(*)
FROM cp_des
WHERE ISNUMERIC(LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),1,4))) = 0 
	AND SUBSTRING(LTRIM(DESCRIPCIO),5,1) <> ''
GROUP BY LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),5,LEN(DESCRIPCIO)))
ORDER BY 2 DESC

SELECT COUNT(*) FROM cp_des

select SUBSTRING(LTRIM(DESCRIPCIO),1,4), SUBSTRING(LTRIM(DESCRIPCIO),5,1),SUBSTRING(LTRIM(DESCRIPCIO),5,LEN(DESCRIPCIO))  from cp_des

SELECT * FROM cp_pri
WHERE CUOTA_PAGO IN(
SELECT CUOTA_PAGO
FROM cp_des
WHERE ISNUMERIC(LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),1,4))) = 0
)

SELECT * FROM ec_det 
WHERE ano is null


SELECT Concepto,ID_CP, P.DESCRIPCIO, D.Cuota_pago, CD.DESCRIPCIO, COUNT(Concepto)  FROM ec_det D
INNER JOIN cp_pri P ON D.Concepto = P.ID_CP
INNER JOIN cp_des CD ON CD.CUOTA_PAGO = D.Cuota_pago
GROUP BY Concepto,ID_CP, P.DESCRIPCIO, D.Cuota_pago, CD.DESCRIPCIO ORDER BY 1 DESC



SELECT D.DESCRIPCIO, P.DESCRIPCIO, O.* FROM ec_det O 
INNER JOIN cp_des D ON O.CUOTA_PAGO = D.CUOTA_PAGO
INNER JOIN cp_pri P ON P.ID_CP = O.Concepto
WHERE O.CUOTA_PAGO IN(
SELECT CUOTA_PAGO
FROM cp_des
WHERE ISNUMERIC(LTRIM(SUBSTRING(LTRIM(DESCRIPCIO),1,4))) = 1
)


SELECT ID_CP, P.DESCRIPCIO, cD.Cuota_pago, CD.DESCRIPCIO, COUNT(P.Cuota_pago)  FROM cp_pri P 
INNER JOIN cp_des CD ON CD.CUOTA_PAGO = P.Cuota_pago
GROUP BY ID_CP, P.DESCRIPCIO, CD.Cuota_pago, CD.DESCRIPCIO ORDER BY 3





SELECT * FROM ec_det 
WHERE Cuota_pago = 4 and Concepto = 9 ORDER BY Ano DESC

SELECT ID_CP, P.DESCRIPCIO, cD.Cuota_pago, CD.DESCRIPCIO, COUNT(P.Cuota_pago)  FROM cp_pri P 
INNER JOIN cp_des CD ON CD.CUOTA_PAGO = P.Cuota_pago
where CD.CUOTA_PAGO = 4
GROUP BY ID_CP, P.DESCRIPCIO, CD.Cuota_pago, CD.DESCRIPCIO ORDER BY 3

select * from ec_det
SELECT  *FROM cp_DES
SELECT * FROM cp_pri WHERE ELIMINADO = 1  --  ID_CP IN (3899,3898,3897,3896)
SELECT ID_CP, COUNT(ID_CP) FROM cp_pri GROUP BY ID_CP HAVING COUNT(ID_CP) > 1

select * from ec_det where cast(Concepto as int) in (select id_cp from cp_pri where ID_CP IN (3899,3898,3897,3896) AND ELIMINADO = 0) 

SELECT *  FROM ec_det WHERE Ano IN ('2019', '2020') ORDER BY cast(Concepto as int) ASC

SELECT * FROM ec_det WHERE CAST(Concepto AS INT) IN (3899,3898,3897,3896)

select distinct CAST(Concepto AS INT) from ec_det order by CAST(Concepto AS INT)

SELECT LTRIM(DESCRIPCIO), COUNT(*) as repetidos
FROM cp_pri
GROUP BY LTRIM(DESCRIPCIO)
ORDER BY 2 desc

SELECT DISTINCT LTRIM(DESCRIPCIO), ELIMINADO FROM cp_pri ORDER BY LTRIM(DESCRIPCIO)

SELECT * FROM TC_ConceptoPago W WHERE I_ConceptoID IN (3899,3898,3897,3896)

insert into TC_ConceptoPago (T_ConceptoDesc, B_Habilitado, B_Eliminado) values ('asdasdasd', 1, 0)

SELECT D.Concepto,D.Cuota_pago, T.N_Cta_Cte, D.P, D.Ano, D.Cod_Alu, T.Des_Pri, D.Fch_ec, D.Fch_Venc, Fch_pago, Nro_recibo, d.monto as Det_Monto, D.COD_RC, p.Tot_APagar,P.Tot_pagado, o.pagado, o.monto as Obl_Monto
FROM Ec_det D 
INNER JOIN (SELECT ID_CP, Clasificad, N_Cta_Cte, Cod_RC, Monto, CP_D.Descripcio +SPACE(1) + '|' + SPACE(1) + CP_P.Descripcio AS Des_Pri, Fraccionab, Cod_dep_pl, CP_D.Cuota_Pago, CP_P.Ano, CP_P.P
FROM cp_pri CP_P INNER JOIN CP_des CP_D ON CP_D.CUOTA_PAGO=CP_P.CUOTA_PAGO 
WHERE CP_P.Eliminado=0 AND CP_D.Eliminado=0
)
T ON T.ID_CP=D.Concepto AND T.Cuota_Pago=D.Cuota_Pago AND T.ano = D.ano AND T.p = D.p
INNER JOIN Ec_PRI P ON D.ano = P.ano AND D.p = P.p AND d.cod_rc=p.cod_rc AND D.Cod_Alu = P.Cod_Alu
INNER JOIN Ec_Obl O ON P.ano = O.ano AND P.p = O.p AND P.cod_rc = O.cod_rc AND P.cod_alu = O.Cod_alu AND O.cuota_pago = D.cuota_pago AND O.tipo_oblig = D.tipo_oblig AND O.fch_venc = D.fch_venc
WHERE P.Eliminado=0 AND D.Eliminado=0 AND D.p='A' and d.Ano IN ('2019', '2020')



DELETE TC_ConceptoPago
DBCC CHECKIDENT(TC_ConceptoPago, RESEED, 0)


