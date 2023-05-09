use db_loteria;

/*PROCEDURES LOGICOS*/

-- procedimento para sortear os numeros de um sorteio -- 
delimiter $
drop procedure if exists Sortear$
create procedure Sortear(modalidade int, numero_sorteio int)
begin
	declare por_sortear, inicio, fim, sorteado int;
    declare continuar bool;
    select quantidade_numeros_sorteados, inicio_intervalo, fim_intervalo into por_sortear, inicio, fim
    from Modalidade_Sorteio where id_modalidade = modalidade;
    
    while(por_sortear > 0) do
		set continuar = true;        
        while(continuar) do
			select (rand()* (1 + fim - inicio) + inicio) into sorteado;
            if not((select count(*) from Numeros_Sorteio as nm where id_modalidade = modalidade
					and nm.numero_sorteio = numero_sorteio and nm.sorteado = sorteado) > 0) then
				set continuar = false;
			end if;
        end while;
        
		insert into Numeros_Sorteio values(modalidade, numero_sorteio, sorteado);
		set por_sortear = por_sortear - 1;
    end while;
end$
delimiter ;

-- procedimento para notificar todos os envolvidos de um sorteio quando finalizado --
delimiter $
drop procedure if exists Notificar_Participantes$
create procedure Notificar_Participantes(modalidade int, numero_sorteio int)
begin
	declare email varchar(50);
    declare mensagem varchar(300);
    declare bilhetes_comprados int;
    declare nome varchar(20);
    declare continuar boolean;
        
	declare cursorApostadores cursor for
	select Bilhete.email, count(*) from Bilhete 
    where id_modalidade = modalidade and Bilhete.numero_sorteio = numero_sorteio
    group by Bilhete.email;
    
	declare continue handler for not found set continuar = false;

	select Modalidade_Sorteio.nome into nome from Modalidade_Sorteio where id_modalidade = modalidade;
	set continuar = true;
    
	-- criar mensagem
	open cursorApostadores;
	fetch cursorApostadores into email, bilhetes_comprados;
	while(continuar) do
		set mensagem = concat("O ultimo sorteio de ", nome, " terminou, voce tem ", cast(bilhetes_comprados as char(100)), " bilhetes para conferir!");
		insert into Notificacao values(now(), email, mensagem);
		fetch cursorApostadores into email, bilhetes_comprados;
	end while;
		close cursorApostadores;
end$
delimiter ;

/*PROCEDURES RETORNAVES*/

-- procedure para retornar informacoes para a tela do Apostador --
-- nao terminado
delimiter $
drop procedure if exists Sobre_Apostador$
create procedure Sobre_Apostador(email varchar(50), CPF varchar(50))
begin
	declare bilhetes_comprados, vencidos int;
    declare total_premios decimal (11.2);

	select email, CPF, telefone, saldo, bilhetes_comprados, vencidos, total_premios 
    from Usuario where Usuario.email = email;
    
end$
delimiter ;

-- call Sobre_Apostador("arthur.nacimento@aluno.ifsp.edu.br", "10000000901");