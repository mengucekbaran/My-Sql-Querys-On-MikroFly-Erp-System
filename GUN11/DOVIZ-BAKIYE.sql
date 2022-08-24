select cha_kod as Cari_Kodu,ch.cari_muh_kod as Cari_Muh_kod,case
when cha_d_cins=0 then 'TL'
when cha_d_cins=1 then 'USD'
WHEN cha_d_cins=2 then 'EURO' END as Doviz_Cinsi,
sum(
case
	when cha_tip=0  then cha_meblag
	when cha_tip=1 then -1*cha_meblag
	end )as Bakiye 
	from CARI_HESAP_HAREKETLERI chh
join CARI_HESAPLAR ch on chh.cha_kod=ch.cari_kod
group by cha_kod,cha_d_cins,ch.cari_muh_kod order by cha_kod

--************
select cha_kod as Cari_Kodu,ch.cari_muh_kod as Cari_Muh_kod,case
when cha_evrak_tip=65 then 'Kasa Tediye Fiþi'
when cha_evrak_tip=35 then 'Gonderilen Havale'
when cha_evrak_tip=67 then 'Çek Çýkýþ'
when cha_evrak_tip =0 then 'Alýþ Faturasý'
when cha_evrak_tip=34 then 'Gelen Havale'
end as Evrak_Tip,
case
	when cha_d_cins=0 then 'TL'
	when cha_d_cins=1 then 'USD'
	WHEN cha_d_cins=2 then 'EURO' END as Doviz_Cinsi,
	case
		when cha_tip=0 then(
			case 
				when cha_evrak_tip=65 then cha_meblag
				when cha_evrak_tip=35 then cha_meblag
				when cha_evrak_tip=67 then cha_meblag
			end
			)
		when cha_tip=1 then -1*cha_meblag
end
	from CARI_HESAP_HAREKETLERI chh
join CARI_HESAPLAR ch on chh.cha_kod=ch.cari_kod
group by cha_kod,cha_evrak_tip,cha_d_cins,ch.cari_muh_kod,cha_tip,cha_meblag order by cha_kod

--********************************
select cha_kod as Cari_Kodu,ch.cari_muh_kod as Cari_Muh_kod,
case
when cha_evrak_tip=65 then 'Kasa Tediye Fiþi'
when cha_evrak_tip=35 then 'Gonderilen Havale'
when cha_evrak_tip=67 then 'Çek Çýkýþ'
when cha_evrak_tip =0 then 'Alýþ Faturasý'
when cha_evrak_tip=34 then 'Gelen Havale'
end as Evrak_Tip,
case
when cha_d_cins=0 then 'TL'
when cha_d_cins=1 then 'USD'
WHEN cha_d_cins=2 then 'EURO' END as Doviz_Cinsi,
sum(
case
	when cha_tip=0  then cha_meblag
	when cha_tip=1 then -1*cha_meblag
	end )as Bakiye 
	from CARI_HESAP_HAREKETLERI chh
join CARI_HESAPLAR ch on chh.cha_kod=ch.cari_kod
group by cha_kod,cha_d_cins,ch.cari_muh_kod,cha_evrak_tip,cha_tip order by cha_kod,cha_tip
--**************

select 
case
when cha_evrak_tip=65 then 'Kasa Tediye Fiþi'
when cha_evrak_tip=35 then 'Gonderilen Havale'
when cha_evrak_tip=67 then 'Çek Çýkýþ'
when cha_evrak_tip =0 then 'Alýþ Faturasý'
when cha_evrak_tip=34 then 'Gelen Havale'
end as Evrak_Tip,
case
when cha_d_cins=0 then 'TL'
when cha_d_cins=1 then 'USD'
WHEN cha_d_cins=2 then 'EURO' END as Doviz_Cinsi,
sum(cha_meblag)as Bakiye 
	from CARI_HESAP_HAREKETLERI chh
join CARI_HESAPLAR ch on chh.cha_kod=ch.cari_kod
group by cha_d_cins,cha_evrak_tip



select cha_evrakno_sira,* from PERIYODIK_EVRAKLAR




 sp_helptext msp_EVRAK_ONAYLAMA_EVRAK_LISTESI
select * from sys.objects where name LIKE '%TIP%'OR name LIKE '%EVRAK%'
select * from sys.objects where name LIKE '%TIP%'
SELECT * FROM HIZMET_MASRAF_TIPLERI

select cha_evrak_tip,cha_tip,cha_kod,cha_meblag,cha_d_cins,* from CARI_HESAP_HAREKETLERI where cha_tip=1

select * from 	EVRAK_ACIKLAMALARI























