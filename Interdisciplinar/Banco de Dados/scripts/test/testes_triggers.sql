use db_loteria;

-- testes Finalizar_Operacao --
select max(data_taxa) into @data_taxa_atual from Taxas_Atuais where codigo_moeda = "USD";  
insert into Operacao values(curdate(), @data_taxa_atual, "USD", "amanda.reis@aluno.ifsp.edu.br", 100.00,0);
select max(data_taxa) into @data_taxa_atual from Taxas_Atuais where codigo_moeda = "CNY";  
insert into Operacao values(curdate(), @data_taxa_atual, "CNY", "amanda.reis@aluno.ifsp.edu.br", 100.00,0);
select max(data_taxa) into @data_taxa_atual from Taxas_Atuais where codigo_moeda = "BRL";  
insert into Operacao values(curdate(), @data_taxa_atual, "BRL", "amanda.reis@aluno.ifsp.edu.br", 100.00,0);
-- (data da operação, chave de taxa(data_taxa, codigo_moeda), chave de ususario(email), valor em moeda selecionada, tipo de operação)


select @data_taxa_atual;

select * from Operacao;
select * from Usuario;

-- testes Nova_Modalidade --
insert into Modalidade_Sorteio values(default, 6, 0, 60, 1000.00, 5.00, now(), "0000-00-01 00:00:00", 5,"teste", "sorteio para testes", "carlos.diaz@.ifsp.edu.br", "10000000900001");
-- (chave auto incrementavel, quantidade de numeros para sortear, menor numero sorteavel, maior numero sorteavel, premio, preco do bilhete, data de inicio do primeiro sorteio, duração de cada sorteio, nome, descrição, chave do Organizador(email, CNPJ))
insert into Modalidade_Incremental values(1, 100.00, 2);  -- definir sorteio como incremental --
-- (chave da modalidade(id_modalidade), valor incrementado no premio, condição de incremento(quantidade de bilhetes vendidos))

select * from Modalidade_Sorteio;
select * from Sorteio;

-- testes Verificar_Incremental, fazer antes e apos criar os os bilhetes no sorteio --
select * from Modalidade_Incremental;

-- testes Debitar_Novo_Sorteio (verificarção junto do anterior) --
select * from Usuario where email = "carlos.diaz@.ifsp.edu.br";

-- testes Debitar_Novo_Bilhete--
insert into Bilhete values(default, 1, 1, now(), "arthur.nacimento@aluno.ifsp.edu.br", "10000000901");
insert into Bilhete values(default, 1, 1, now(), "amanda.reis@aluno.ifsp.edu.br", "10000000902");
-- (chave auto incrementavel, chave de soretio(id_modalidade, numero_sorteio), chave de Apostador(email, CFP))

select * from Bilhete where id_modalidade = 1 and numero_sorteio = 1;
select * from Usuario;
select * from Sorteio;

-- testes Fim_de_Sorteio
update sorteio set ativo = false where id_Modalidade = 1 and numero_sorteio = 1;

select * from Sorteio;
select * from Usuario;
select * from Notificacao;

