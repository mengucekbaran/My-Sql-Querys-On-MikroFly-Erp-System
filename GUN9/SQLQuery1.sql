

select cha_kod,
cariAd,
[1]  as alacak,
[0] as borc,
[1]-[0] as kalan
 from(
	select chh.cha_kod,cha_tip,
	(select cari_unvan1 from CARI_HESAPLAR where chh.cha_kod=cari_kod) as cariAd,
	sum(cha_meblag) as miktar from CARI_HESAP_HAREKETLERI chh
	group by chh.cha_kod,cha_tip 

) cariTablo
pivot
(
sum(miktar) for [cha_tip] in (
[0],[1])
) as pivotCariTablo order by cha_kod


select cha_kod,sum(cha_meblag) as fiyat from CARI_HESAP_HAREKETLERI group by cha_kod,cha_tip order by cha_kod




