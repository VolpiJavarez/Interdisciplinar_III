use db_loteria;
-- fiz para evitar não ter que declarar as funções como deterministic
set global log_bin_trust_function_creators = 1;

-- Funcao para retornar o valor arrecadado com a vende de bilhetes de um sorteio
delimiter $
drop function if exists Vendas_Sorteio$
create function Vendas_Sorteio(modalidade int, sorteio int)
returns decimal(11,2)
begin
	declare total_vendas decimal(11,2);
    declare bilhetes_vendidos int;
    
    select count(*) into bilhetes_vendidos from Bilhete where id_modalidade = modalidade and numero_sorteio = sorteio;
    select preco_bilhete * bilhetes_vendidos into total_vendas from Modalidade_Sorteio where id_modalidade = modalidade;
    
	return total_vendas;
end$
delimiter ;

-- funcao retornar a média de bilhetes vendidos em todos os sorteios de uma modalidade -- 
delimiter $
drop function if exists Media_Bilhetes$
create function Media_Bilhetes(modalidade int)
returns decimal(9,2)
begin
	declare total_bilhetes_vendidos, total_sorteios int;
    
    select count(*) into total_bilhetes_vendidos from Bilhete where id_modalidade = modalidade;
    select count(*) into total_sorteios from Sorteio where id_modalidade = modalidade;
    
	return total_bilhetes_vendidos / total_sorteios;
end$
delimiter ;