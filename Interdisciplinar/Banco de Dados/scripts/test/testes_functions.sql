use db_loteria;

-- testes function Vendas_Sorteio
select count(*) from Bilhete where id_modalidade = 1 and numero_sorteio = 1; -- ver total de sorteios
select Vendas_Sorteio(1,1);

-- testes function Media_Bilhetes
select Media_Bilhetes(1);