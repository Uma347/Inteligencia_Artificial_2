--drop procedure cadena
--drop table nombre;
--EXEC cadena 'juan','juana'
--select * from nombre

CREATE or ALTER PROCEDURE cadena @nombre1 varchar(20),@nombre2 varchar(20)
as
begin
declare 
		@aux		varchar(20),
		@longaux	int,
		@longitud1  int,
		@longitud2  int,
		@letra		varchar(1),
		@contador	int,
		@sql		nvarchar(2000),
		@columna	varchar(10),
		@mayor		int
	
	set @contador=1
	set @sql='DROP TABLE IF EXISTS dbo.nombre'
	execute sp_executesql @sql 
	select @longitud1=LEN(@nombre1)
	select @longitud2=LEN(@nombre2)
	if @longitud2>@longitud1
	begin
		set @aux=@nombre1
		set @nombre1=@nombre2
		set @nombre2=@aux
		set @longaux=@longitud1
		set @longitud1=@longitud2
		set @longitud2=@longaux
	end

	set @sql='create table nombre( '
	while @contador<=@longitud1
	begin
		set @letra=LEFT(@nombre1,1)
		set @nombre1=RIGHT(@nombre1,LEN(@nombre1)-1)
		set @sql=@sql+@letra+cast(@contador as varchar(1))+' int, '
		set @contador=@contador+1
	end
	set @sql=LEFT(@sql,LEN(@sql)-1)
	set @sql=@sql+')'
	EXECUTE sp_executesql @sql
	set @contador=1
	while @contador<=@longitud2
	begin
		print @contador
		set @letra=LEFT(@nombre2,1)
		print @letra
		set @nombre2=RIGHT(@nombre2,LEN(@nombre2)-1)
		print @nombre2
		set @columna='no'
		select top 1 @columna=COLUMN_NAME 
		from INFORMATION_SCHEMA.COLUMNS
		where TABLE_NAME='nombre'
		and LEFT(COLUMN_NAME,1) like @letra
		and ORDINAL_POSITION>=@contador
		print @columna
		if @columna!='no'
		begin
			set @sql='insert into nombre('+@columna+') values(1)'
			EXECUTE sp_executesql @sql
			print @sql
		end
		set @contador=@contador+1
	end
	set @sql=''
	select @mayor=max(ORDINAL_POSITION)
	from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='nombre'

	set @contador=1
	while @contador<=@mayor
	begin
		select @columna=COLUMN_NAME 
		from INFORMATION_SCHEMA.COLUMNS
		where TABLE_NAME='nombre'
		and ORDINAL_POSITION=@contador
		set @sql=@sql+'ISNULL(sum('+@columna+'),0)+'
		set @contador=@contador+1
	end
	set @sql=LEFT(@sql,LEN(@sql)-1)
	set @sql='select cast(('+@sql+') as float)/'+cast(@mayor as varchar(20))+' as porcentaje from nombre'
	print @sql
	EXECUTE sp_executesql @sql
end