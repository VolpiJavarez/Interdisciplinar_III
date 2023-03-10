use db_loteria;

-- view das taxas mais recentes --
drop view if exists Taxas_Atuais;
create view Taxas_Atuais as 
select codigo_moeda as "Codigo da Moeda", taxa_conversao as "Taxa de Conversao(por lotis)", data_taxa as "Data de Registro da Taxa"
from Taxa inner join (select max(data_taxa) from Taxa group by codigo_moeda) as max_datas
group by taxa.codigo_moeda;

select * from Taxas_Atuais;

-- nao usaveis, pois nao permitem insercao. teria que recrialas a cada sorteio que inicia ou termina--
-- view sorteios ativos --
drop view if exists Sorteios_Ativos;
create view Sorteios_Ativos as 
select Sorteio.id_modalidade, Sorteio.numero_sorteio, premio, preco_bilhete, count(id_bilhete)
from Sorteio left join Bilhete using(id_modalidade, numero_sorteio)
inner join Modalidade_Sorteio using(id_modalidade)
where inicio < now() and fim > now() group by Sorteio.id_modalidade, Sorteio.numero_sorteio;

select * from Sorteios_Ativos;

drop view if exists Sorteios_Finalizados;
create view Sorteios_Finalizados as 
select Sorteio.id_modalidade, Sorteio.numero_sorteio, premio, preco_bilhete, count(id_bilhete)
from Sorteio left join Bilhete using(id_modalidade, numero_sorteio)
inner join Modalidade_Sorteio using(id_modalidade)
where fim < now() group by Sorteio.id_modalidade, Sorteio.numero_sorteio;

-- view sorteios ativos finalizados--
select * from Sorteios_Finalizados;

insert into Sorteios_Ativos values(1, 1, 0.0, 0.0, 0);
update Sorteios_Ativos set numero_sorteio = 1, id_modalidade = 1 where numero_sorteio = 2;
delete from Sorteios_Ativos where numero_sorteio = 1 and id_modalidade = 1;