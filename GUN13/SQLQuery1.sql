

CREATE FUNCTION BM_fn_EvrakIsmi(@evrak_tip tinyint) 
returns varchar(MAX)
as
begin
declare @name varchar(MAX)
select @name=yit_isim2 from YARDIMCI_ISIM_TABLOSU_VIEW yit where yit_sub_id=@evrak_tip and yit_language='T' and yit_tip_no=0
return @name
end

CREATE FUNCTION BM_fn_CekNo(@refNo nvarchar(25))
returns nvarchar(25)
as 
begin
declare @cekNo nvarchar(25)
select @cekNo=om.sck_no from ODEME_EMIRLERI om where om.sck_refno=@refNo
return @cekNo
end

select cha_kod as Cari_Kodu,
ch.cari_muh_kod as Cari_Muh_kod,
chh.cha_trefno,
dbo.BM_fn_CekNo(cha_trefno)as Cek_No,
dbo.BM_fn_EvrakIsmi(cha_evrak_tip) AS Evrak_Tipi,
dbo.fn_DovizIsmi(cha_d_cins),
sum(cha_meblag)as Bakiye 
	from CARI_HESAP_HAREKETLERI chh
join CARI_HESAPLAR ch on chh.cha_kod=ch.cari_kod
group by cha_kod,cha_d_cins,ch.cari_muh_kod,cha_evrakno_sira,cha_evrak_tip,cha_tip,cha_trefno order by cha_kod,cha_tip,cha_evrakno_sira



