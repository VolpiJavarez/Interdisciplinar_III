use db_loteria;

-- procedimento para sortear os numeros de um sorteio -- 
delimiter $
drop procedure if exists Sortear$
create procedure Sortear(modalidade int, numero_sorteio int)
begin
	declare qtd_numeros, inicio, fim, sorteado int;
    declare continuar bool;
    select quantidade_numeros_sorteados, inicio_intervalo, fim_intervalo into qtd_numeros, inicio, fim
    from Modalidade_Sorteio where id_modalidade = modalidade;
    
    start transaction;
    while(qtd_numeros > 0) do
		set continuar = true;
        while(continuar) do
			select (rand()* (1 + fim - inicio) + inicio) into sorteado;
            if not((select count(*) from Numeros_Sorteio as nm where id_modalidade = modalidade
					and nm.numero_sorteio = numero_sorteio and nm.sorteado = sorteado) > 0) then
				set continuar = false;
			end if;
        end while;
        
		insert into Numeros_Sorteio values(modalidade, numero_sorteio, sorteado);
		set qtd_numeros = qtd_numeros - 1;
	commit;
        
    end while;
end$
delimiter ;

-- testes --
call Sortear(2, 2);
select * from Sorteio;
select * from Numeros_Sorteio where id_modalidade = 2 and numero_sorteio = 2;

-- procedimento para notificar todos os envoltidoes em um sorteio quando finalizado --
-- obs: nao finalizado --
delimiter $
drop procedure if exists Notificar_Participantes$
create procedure Notificar_Usuarios(modalidade int, numero_sorteio int)
begin
	declare email varchar(50);
    declare bilhetes_comprados, vencedores int;
    
	declare cursorApostadores cursor for
	select email, count(id_bilhete) from Bilhete 
    where id_modalidade = modalidade and Bilhete.numero_sorteio = numero_sorteio
    group by email;

	declare continue handler for not found set continuar = false;

	open cursorApostadores;
    fetch cursorApostadores into email, bilhetes_comprados;
    while(continuar) do
		set total = total + preco * quantidade;
        fetch cursorCompra into preco, quantidade;
    end while;
	
	close cursorCompra;

	select(total);
			
end$
delimiter ;

/* procedure para verificar se, em um sorteio incremental 
a quandidade de bilhetes vendidos atingiu a condicao de invremento. 
Fiz soment para diminuir a bagunca/excesso de codigo no triger Novo_Bilhete */
delimiter $
drop procedure if exists Verificar_Incremental$
create procedure Verificar_Incremental(modalidade int, numero_sorteio int)
begin
	declare vendidos, condicao int;
    declare incremento decimal(11,2);
    
	if((select count(*) from Modalidade_Incremental where id_modalidade = modalidade) > 0) then
		select count(id_bilhete) into vendidos from bilhete where id_modalidade = modalidade and bilhete.numero_sorteio = numero_sorteio;
        select valor_incrementado, bilhetes_para_incrementar into incremento, condicao from Modalidade_Incremental where id_modalidade = modalidade;
		if(condicao = vendidos) then
			update sorteio set premio = premio + incremento where id_modalidade = modalidade and sorteio.numero_sorteio = numero_sorteio;
			update usuario set saldo = saldo - incremento where usuario.email = (select email from Modalidade_Sorteio where id_modalidade = modalidade);
        end if;
    end if;
end$
delimiter ;