use db_loteria;

-- procedure para retornar informacoes para a tela do Apostador --
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

call Sobre_Apostador("arthur.nacimento@aluno.ifsp.edu.br", "10000000901");