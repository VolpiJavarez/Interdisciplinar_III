use db_loteria;

-- testes procedure Soretear --
call Sortear(1, 1);
select * from Sorteio;
select * from Numeros_Sorteio where id_modalidade = 1 and numero_sorteio = 1;

 -- testar Sortear sem repetir numeros(sortear seis numeros diferentes entre 1 e 6) --
insert into Modalidade_Sorteio values(default, 6, 1, 6, 00.00, 0.00, now(), "0000-00-01 00:00:00", 5, "teste2", "pera testar a procedure Sortear", "carlos.diaz@.ifsp.edu.br", "10000000900001");
-- (chave auto incrementavel, quantidade de numeros para sortear, menor numero sorteavel, maior numero sorteavel, premio, preco do bilhete, data de inicio do primeiro sorteio, duração de cada sorteio, nome, descrição, chave do Organizador(email, CNPJ))
call Sortear(2, 1);
select * from Sorteio;
select * from Numeros_Sorteio where id_modalidade = 2 and numero_sorteio = 1;

-- testes procedure Notificar_Participantes --
call Notificar_Participantes(1,1);
select * from Notificacao;