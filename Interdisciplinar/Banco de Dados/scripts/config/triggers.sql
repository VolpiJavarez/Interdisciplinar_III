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
	else -- !0 para saque
		update Usuario set saldo = saldo - new.valor_convertido * taxa_conversao  where Usuario.email = new.email;
	end if;
end$
delimiter ;

-- trigger para iniciar o primeiro sorteio da modalidade --
delimiter $
drop trigger if exists Nova_Modalidade$
create trigger Nova_Modalidade 
after insert on Modalidade_Sorteio
for each row
begin
	insert into Sorteio values(new.id_modalidade, 1, new.inicio_sorteios, new.inicio_sorteios + new.duracao_sorteios, new.premio_inicial, true);
end$
delimiter ;

-- trigger para retirar o premio do saldo do organizador --
delimiter $
drop trigger if exists Debita_Sorteio$
create trigger Debitar_Sorteio
after insert on Sorteio
for each row
begin
	declare email varchar(50);
    select m.email into email from Modalidade_Sorteio as m where m.id_modalidade = new.id_modalidade;
    
    update usuario set saldo = saldo - new.premio where usuario.email = email;
end$
delimiter ;

 -- trigger para transferir o preço do bilhete do Apostador para o Organizador(possiveis taxas seriam incluidas aqui)
delimiter $
drop trigger if exists Debitar_Bilhete$
create trigger Debitar_Bilhete 
after insert on Bilhete
for each row
begin
	declare email_organizador varchar(50);
    declare preco_bilhete decimal(5,2);
    select m.email, m.preco_bilhete into email_organizador, preco_bilhete from Modalidade_Sorteio as m where m.id_modalidade = new.id_modalidade;
    
    update Usuario set saldo = saldo - preco_bilhete where usuario.email = new.email;
    update Usuario set saldo = saldo + preco_bilhete where usuario.email = email_organizador;
    
end$
delimiter ;

 -- trigger para para verificar se, em um sorteio incremental, a quandidade de bilhetes vendidos atingiu a condicao de incremento
delimiter $
drop trigger if exists Verificar_Incremental$
create trigger Verificar_Incremental 
after insert on Bilhete
for each row follows Debitar_Bilhete
begin
	declare vendidos, condicao int;
    declare incremento decimal(11,2);
    
	if((select count(*) from Modalidade_Incremental where id_modalidade = new.id_modalidade) > 0) then
		select count(id_bilhete) into vendidos from bilhete where id_modalidade = new.id_modalidade and bilhete.numero_sorteio = new.numero_sorteio;
        select valor_incrementado, bilhetes_para_incrementar into incremento, condicao from Modalidade_Incremental where id_modalidade = new.id_modalidade;
		if(condicao = vendidos) then
			update sorteio set premio = premio + incremento where id_modalidade = new.id_modalidade and sorteio.numero_sorteio = numero_sorteio;
			update usuario set saldo = saldo - incremento where usuario.email = (select email from Modalidade_Sorteio where id_modalidade =  new.id_modalidade);
        end if;
    end if;
end$
delimiter ;

-- triger para distribuicao dos premios e para dar as notificações no fim de um sorteio --
delimiter $
drop trigger if exists Fim_de_Sorteio$
create trigger Fim_de_Sorteio 
after update on Sorteio
for each row
begin
	if(new.ativo = false) then
		-- distribuir os premios aos vencedores
        -- por fazer
        -- notificar Apostadores e Organizador
        call Notificar_Participantes(new.id_modalidade, new.numero_sorteio);
    end if;
end$
delimiter ;
