select cha_kod as Cari_Kodu,ch.cari_muh_kod as Cari_Muh_kod,
yit_isim2,
dbo.fn_DovizIsmi(cha_d_cins),
sum(cha_meblag)as Bakiye 
	from CARI_HESAP_HAREKETLERI chh
join CARI_HESAPLAR ch on chh.cha_kod=ch.cari_kod
join YARDIMCI_ISIM_TABLOSU_VIEW yit on yit_sub_id=chh.cha_evrak_tip where yit_language='T' and yit_tip_no=0
group by cha_kod,cha_d_cins,ch.cari_muh_kod,cha_evrak_tip,cha_tip,yit_isim2 order by cha_kod,cha_tip



