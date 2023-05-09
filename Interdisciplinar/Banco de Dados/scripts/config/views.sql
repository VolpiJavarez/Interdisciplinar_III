use db_loteria;

-- view dos sorteios incrementados
drop view if exists Sorteios_Incrementados;
create view Sorteios_Incrementados as 
select Sorteio.* from Sorteio
inner join Modalidade_Sorteio using(id_modalidade)
inner join Modalidade_Incremental where
premio >= premio_inicial + valor_incrementado;

-- view dos bilhetes vencedores
-- nao terminada
/*drop view if exists Bilhetes_Vencedores;
create view Bilhetes_Vencedores as 
select Bilhete.*, Numeros_bilhete.apostado from Numeros_bilhete inner join Bilhete using(id_modalidade, numero_sorteio, id_bilhete)
							inner join Numeros_Sorteio on Numeros_bilhete.apostado = Numeros_Sorteio.sorteado where count(apostado) = (select quantidade_numeros_sorteados from Modalidade_Sorteio where id_modalidade = 1);

/*(select count(distinct apostado) from Numeros_bilhete inner join Numeros_Sorteio using(id_modalidade, numero_sorteio)) = 
(select quantidade_numeros_sorteados from Modalidade_Sorteio where id_modalidade = 1);*/

-- view das taxas mais recentes --
-- @Deprecated(consulta muito simples)
drop view if exists Taxas_Atuais;
create view Taxas_Atuais as 
select codigo_moeda as "Codigo da Moeda", taxa_conversao as "Taxa de Conversao(por lotes)", data_taxa as "Data de Registro da Taxa"
from Taxa inner join (select max(data_taxa) from Taxa group by codigo_moeda) as max_datas
group by taxa.codigo_moeda;

-- select * from Taxas_Atuais;
-- select * from Taxa;

-- view sorteios ativos --
-- @Deprecated(sorteios ativos sao identificados atarvez de uma variavel de estado)
drop view if exists Sorteios_Ativos;
create view Sorteios_Ativos as 
select Sorteio.id_modalidade, Sorteio.numero_sorteio, premio, preco_bilhete, count(id_bilhete)
from Sorteio left join Bilhete using(id_modalidade, numero_sorteio)
inner join Modalidade_Sorteio using(id_modalidade)
where inicio < now() and fim > now() group by Sorteio.id_modalidade, Sorteio.numero_sorteio;

-- view sorteios finalizados --
-- @Deprecated(sorteios ativos sao identificados atarvez de uma variavel de estado)
drop view if exists Sorteios_Finalizados;
create view Sorteios_Finalizados as 
select Sorteio.id_modalidade, Sorteio.numero_sorteio, premio, preco_bilhete, count(id_bilhete)
from Sorteio left join Bilhete using(id_modalidade, numero_sorteio)
inner join Modalidade_Sorteio using(id_modalidade)
where fim < now() group by Sorteio.id_modalidade, Sorteio.numero_sorteio;
