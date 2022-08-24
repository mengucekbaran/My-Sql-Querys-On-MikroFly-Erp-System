CREATE FUNCTION Depodaki_Miktarlar 

(@stok_kodu nvarchar(25),
@depo int)

RETURNS float
AS
	BEGIN

	DECLARE @miktar As Float

	SELECT @miktar=SUM(CASE

		WHEN (sth_tip=0) OR ((sth_tip=2) AND (sth_giris_depo_no=@depo)) THEN sth_miktar

		WHEN (sth_tip=1) OR ((sth_tip=2) AND (sth_cikis_depo_no=@depo)) THEN (-1) * sth_miktar

		ELSE 0

		END
		)

	FROM   dbo.STOK_HAREKETLERI 

	WHERE  (sth_stok_kod=@stok_kodu) AND
	(
	((sth_tip=0) and ((sth_giris_depo_no=@depo) OR (@depo=0))) OR
	((sth_tip=1) and ((sth_cikis_depo_no=@depo) OR (@depo=0))) OR
	((sth_tip=2) AND
	(sth_giris_depo_no!=sth_cikis_depo_no) AND
	((sth_giris_depo_no=@depo) OR (sth_cikis_depo_no=@depo))
	)

	)

	IF @miktar is NULL SET @miktar=0

	RETURN @miktar

END

select 
dep.dep_no,
sh.sth_stok_kod,
(select dbo.Depodaki_Miktarlar (sh.sth_stok_kod,dep.dep_no)) as miktar from STOK_HAREKETLERI sh
right join DEPOLAR dep 
on (sh.sth_giris_depo_no=dep.dep_no or sh.sth_cikis_depo_no=dep.dep_no) where sh.sth_stok_kod is not null
group by 
dep.dep_no,sh.sth_stok_kod










