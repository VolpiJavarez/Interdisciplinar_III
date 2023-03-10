use db_loteria;

-- trigger para aplicar a aperaco no saldo da conta --
delimiter $
drop trigger if exists Finalizar_Operacao$
create trigger Finalizar_Operacao 
after insert on Operacao
for each row
begin

	declare taxa_conversao decimal(11,2);
    select Taxa.taxa_conversao into taxa_conversao from Taxa
    where data_taxa = new.data_taxa and codigo_moeda = new.codigo_moeda;
    
    if(new.tipo_operacao = 0) then -- 0 para deposito
    	update Usuario set saldo = saldo + new.valor_convertido * taxa_conversao where Usuario.email = new.email;
	else 
		update Usuario set saldo = saldo - new.valor_convertido * taxa_conversao  where Usuario.email = new.email;
	end if;
    
end$
delimiter ;

-- testes --
insert into Operacao values(curdate(), "2022-11-24", "USD", "amanda.reis@aluno.ifsp.edu.br", 100.00,0);
insert into Operacao values(curdate(), "2022-11-24", "CNY", "amanda.reis@aluno.ifsp.edu.br", 100.00,0);
insert into Operacao values(curdate(), "2022-11-24", "BRL", "amanda.reis@aluno.ifsp.edu.br", 100.00,0);

select * from Operacao;
select * from Usuario;

-- trigger para iniciar o primeiro sorteio da modalidade --
delimiter $
drop trigger if exists Nova_Modalidade$
create trigger Nova_Modalidade 
after insert on Modalidade_Sorteio
for each row
begin
	insert into Sorteio values(new.id_modalidade, default, new.inicio_sorteios, new.inicio_sorteios + new.duracao_sorteios, new.premio_inicial);
end$
delimiter ;

-- testes --
insert into Modalidade_Sorteio values(default, 6, 0, 60, 1000.00, 5.00, now(), "0000-00-01 00:00:00", 5, "teste", "carlos.diaz@.ifsp.edu.br", "10000000900001");
insert into Modalidade_Sorteio values(default, 6, 0, 6, 00.00, 0.00, now(), "0000-00-01 00:00:00", 5, "teste", "carlos.diaz@.ifsp.edu.br", "10000000900001"); -- usar para testar numeros sorteados, nao devem ser repitidos --

select * from Modalidade_Sorteio;
select * from Sorteio;

-- trigger para retirar o premio do saldo do organizador --
delimiter $
drop trigger if exists Novo_Sorteio$
create trigger Novo_Sorteio 
after insert on Sorteio
for each row
begin
	declare email varchar(50);
    select m.email into email from Modalidade_Sorteio as m where m.id_modalidade = new.id_modalidade;
    
    update usuario set saldo = saldo - new.premio where usuario.email = email;
end$
delimiter ;

-- teste junto dos anterior --
select * from Usuario;


 -- trigger para 
delimiter $
drop trigger if exists Novo_Bilhete$
create trigger Novo_Bilhete 
after insert on Bilhete
for each row
begin
	declare email_organizador varchar(50);
    declare preco_bilhete decimal(5,2);
    select m.email, m.preco_bilhete into email_organizador, preco_bilhete from Modalidade_Sorteio as m where m.id_modalidade = new.id_modalidade;
    
    update Usuario set saldo = saldo - preco_bilhete where usuario.email = new.email;
    update Usuario set saldo = saldo + preco_bilhete where usuario.email = email_organizador;
    
    call verificar_incremental(new.id_modalidade, new.numero_sorteio);
    
end$
delimiter ;

-- teste para sorteios incrementais verificar_incremental --
insert into Modalidade_Incremental values(1, 100.00, 2);  -- (id_sorteio, valor_incrementado, nro_bilhetes vendidos/condicao) --
-- testes --
insert into Bilhete values(default, 1, 1, now(), "arthur.nacimento@aluno.ifsp.edu.br", "10000000901");
insert into Bilhete values(default, 1, 1, now(), "amanda.reis@aluno.ifsp.edu.br", "10000000902");

select * from Bilhete;
select * from Sorteio;
select * from Usuario;

-- triger para distribuicao dos premios no fim de um sortio --
-- por fazer --