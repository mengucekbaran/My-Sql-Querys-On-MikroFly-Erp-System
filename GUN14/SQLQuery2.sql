select cha_kod as Cari_Kodu,
dbo.BM_fn_EvrakIsmi(cha_evrak_tip) AS Evrak_Tipi,
dbo.fn_DovizIsmi(cha_d_cins),
chh.cha_vade,
sum(cha_meblag)as Bakiye 
	from CARI_HESAP_HAREKETLERI chh
join CARI_HESAPLAR ch on chh.cha_kod=ch.cari_kod
group by cha_kod,cha_d_cins,cha_evrakno_sira,cha_evrak_tip,cha_tip,cha_vade order by cha_kod,cha_tip,cha_evrakno_sira

select convert(date,cast(cha_vade as char(8))) from CARI_HESAP_HAREKETLERI

--AYLIK BORÇ-ALACAK BÝLGÝSÝ
--******************************************************************************
select chh.cha_kod,
dbo.fn_YilAy(convert(datetime,cast(cha_vade as char(8)))) as yilAy,
dbo.fn_DovizIsmi(cha_d_cins) AS doviz,
sum(case when cha_tip=1 then cha_meblag end) as Borc,
sum(case when cha_tip=0 then cha_meblag end) as Alacak
from CARI_HESAP_HAREKETLERI chh group by cha_kod,cha_d_cins,dbo.fn_YilAy(convert(datetime,cast(cha_vade as char(8)))) order by cha_kod,yilAy

--*******************************************************************************
--HAFTALIK BORC-ALACAK BÝLGÝSÝ
select chh.cha_kod,
dbo.fn_YilHafta(convert(datetime,cast(cha_vade as char(8)))) as yilHaftaVade,
dbo.fn_DovizIsmi(cha_d_cins) AS doviz,
sum(case when cha_tip=1 then cha_meblag end) as Borc,
sum(case when cha_tip=0 then cha_meblag end) as Alacak
from CARI_HESAP_HAREKETLERI chh group by cha_kod,cha_d_cins,dbo.fn_YilHafta(convert(datetime,cast(cha_vade as char(8)))) order by cha_kod,yilHaftaVade

SELECT * FROM CARI_HESAP_HAREKETLERI WHERE cha_kod='M0002'



