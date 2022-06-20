----USE [ESTOQUE]
----GO
----/****** Object:  StoredProcedure [dbo].[sp_movto]    Script Date: 17/05/2022 19:33:34 ******/
----SET ANSI_NULLS ON
----GO
----SET QUOTED_IDENTIFIER ON
----GO
----create procedure sp_insere
----  @nome varchar(50),
----  @saldo int
----as
----begin
----	insert into TBL_PRODUTOS (NM_PRODUTO, SALDO) 
----	       values (@nome, @saldo)
----end

----exec sp_insere 'Batata', 400

----select * from TBL_PRODUTOS


ALTER procedure [dbo].[sp_movto]
  @idprod int,
  @tipo   nchar(1),
  @saldo  int
as
begin
	if not exists (select 1 from TBL_PRODUTOS where ID_PRODUTO = @idprod)
	begin
		print 'Produto não encontrado'
	end
	else
	begin
		if @tipo = 'I'
		begin
			update TBL_PRODUTOS set SALDO = @saldo where ID_PRODUTO = @idprod
			insert into TBL_MOVIMENTO (ID_PRODUTO, TIPO, SALDO) values
			                          (@idprod, @tipo, @saldo)
		end
		if @tipo = 'E'
		begin
			update TBL_PRODUTOS set SALDO = saldo + @saldo where ID_PRODUTO = @idprod
			insert into TBL_MOVIMENTO (ID_PRODUTO, TIPO, SALDO) values
			                          (@idprod, @tipo, @saldo)
		end
		if @tipo = 'S'
		begin
			declare @s int
			select @s = saldo from TBL_PRODUTOS where ID_PRODUTO = @idprod
			if @s >= @saldo 
			begin
				update TBL_PRODUTOS set SALDO = saldo - @saldo where ID_PRODUTO = @idprod
				insert into TBL_MOVIMENTO (ID_PRODUTO, TIPO, SALDO) values
			                              (@idprod, @tipo, @saldo)

			end
			else
			begin
				print 'Saldo indisponivel'
			end
		end
	end
end