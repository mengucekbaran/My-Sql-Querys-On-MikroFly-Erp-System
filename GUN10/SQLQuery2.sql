	select 
	case 
	when cha_tip=1 then (chh.cha_kod,
	(select cari_unvan1 from CARI_HESAPLAR where chh.cha_kod=cari_kod),
	sum(cha_meblag)
	when cha_tip=0 then sum(cha_meblag)
	end
	from CARI_HESAP_HAREKETLERI chh 
	group by cha_kod,cha_tip
	order by cha_kod





	create table #BM_Cari_Bilgileri(
	cari_kod nvarchar(25),
	cari_ad nvarchar(50),
	cari_alacak float,
	cari_borc float,
	cari_kalan float,
	)
	insert into #BM_Cari_Bilgileri(cari_kod,cari_ad,cari_alacak,cari_borc,cari_kalan)values()


	select * from #BM_Cari_Bilgileri


	select cha_kod,
	isim,
	miktar
	 from (
	select  chh.cha_kod,
	(select cari_unvan1 from CARI_HESAPLAR where chh.cha_kod=cari_kod) as isim,
	sum(cha_meblag) as miktar
	from CARI_HESAP_HAREKETLERI chh
	group by cha_kod
	) as chd
	order by cha_kod
	



	
	select  chh.cha_kod,
	(select cari_unvan1 from CARI_HESAPLAR where chh.cha_kod=cari_kod),
	case when cha_tip=1 then sum(cha_meblag) end as alacak,
	case when cha_tip=0 then sum(cha_meblag) end as borc
	from CARI_HESAP_HAREKETLERI chh 
	group by cha_kod,cha_tip
	order by cha_kod
	
	
	select * from CARI_HESAP_HAREKETLERI

	
	select 
cha_kod,
(select cari_unvan1 from CARI_HESAPLAR where chh.cha_kod=cari_kod) isim,
sum(case  when cha_tip=1 then cha_meblag  end) as alacak,
sum(case when cha_tip=0 then cha_meblag  end) as borc,
sum(case cha_tip when 1 then cha_meblag else cha_meblag*-1 end) as kalan
from CARI_HESAP_HAREKETLERI chh
group by cha_kod











	select  chh.cha_kod,
	
	sum(case cha_tip when 1 then cha_meblag end)
	from CARI_HESAP_HAREKETLERI chh 
	group by cha_kod,cha_tip
	order by cha_kod
	