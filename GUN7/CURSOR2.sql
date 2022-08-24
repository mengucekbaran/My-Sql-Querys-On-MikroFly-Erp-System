
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
		)FROM   dbo.STOK_HAREKETLERI 
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

create table #BM_Depo_Bilgileri(
	stok_kod nvarchar(25)
)
--******************************************************************************************************************************************************************************
declare 
@depoAdi nvarchar(50),
@depoNo int,
@stokKod nvarchar(25),
@depoAdi_status int,
@stokKod_status int,
@columnDepo nvarchar(50), 
@stokMiktar float,
@UpdateStatement as nvarchar(1000),
 @addColumn nvarchar(max)
 -- declare cursor_depo

declare cursor_depo cursor
for select 
dep.dep_adi,dep.dep_no
from DEPOLAR dep

--scroll cursor tanýmlayýnca cursor ü tekrar baþa getirebiliyorum
declare cursor_stok scroll cursor
for select 
sto_kod
from STOKLAR
where sto_cins='1'

--open cursor
open cursor_depo
open cursor_stok

--fetch next and set status
fetch next from cursor_depo into @depoAdi,@depoNo
set @depoAdi_status = @@FETCH_STATUS
fetch next from cursor_stok into @stokKod
set @stokKod_status = @@FETCH_STATUS
--*************************************************************************************************
--insert into stok_kod while
while @stokKod_status=0
	begin
		insert into  #BM_Depo_Bilgileri(stok_kod)values(@stokKod)
		fetch next from cursor_stok into @stokKod
		set @stokKod_status = @@FETCH_STATUS
	end
--**************************************************************************************************
	--cursor_stok 'u ilk kayýta geri getirme
fetch first from cursor_stok into @stokKod
set @stokKod_status = @@fetch_status

--adding columns and update table while
--*******************************************************************************************************************************
while @depoAdi_status=0
	begin
	--depo adlarýndan column oluþturma
		set @columnDepo = replace(@depoAdi,' ','_')
		set @addColumn= 'alter table #BM_Depo_Bilgileri ADD '+@columnDepo+' float'
		exec(@addColumn)

		while @stokKod_status=0
			begin
			--miktar atama 
				set @stokMiktar = dbo.Depodaki_Miktarlar(@stokKod,@depoNo)
				set @UpdateStatement = 'update #BM_Depo_Bilgileri set ' +@columnDepo+ '='+convert(nvarchar,@stokMiktar )+ 'where stok_kod ='+''''+@stokKod+''''
				exec(@UpdateStatement)
				--update #BM_Depo_Bilgileri set  @columnDepo = @stokMiktar
				fetch next from cursor_stok into @stokKod
				set @stokKod_status = @@FETCH_STATUS
			end
		--go back to first record of second_cursor to start
		fetch first from cursor_stok into @stokKod
		set @stokKod_status = @@fetch_status
		--index arttýrma
		fetch next from cursor_depo into @depoAdi,@depoNo
		set @depoAdi_status = @@FETCH_STATUS
	end
--******************************************************************************************************************************
 close cursor_depo
 deallocate cursor_depo
 close cursor_stok
 deallocate cursor_stok
--*********************************************************************************************************************************************************************************

select * from #BM_Depo_Bilgileri
drop table #BM_Depo_Bilgileri



