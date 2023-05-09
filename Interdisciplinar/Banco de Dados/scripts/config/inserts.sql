-- incersao dos usuarios de teste --
insert into Usuario values 
("arthur.nacimento@aluno.ifsp.edu.br", "Arthur Nacimento", "123456", "", 1000.0),
("amanda.reis@aluno.ifsp.edu.br", "Amanda Reis", "123456", "", 1000.0),
("joão.guilherme@aluno.ifsp.edu.br", "João Guilherme", "123456", "", 1000.0),
("carlos.diaz@.ifsp.edu.br", "Crlos Diaz", "123456", "", 10000.0);
-- (email, nome, senha, saldo) --

-- incersao de taxas de cambio (não necessario)--
insert into Taxa values
("2022-11-01", "USD", 5.17),
("2022-11-01", "CNY", 0.70),
("2022-11-01", "BRL", 1.0);
-- (data da taxa, codigo da moeda, valor de conversao) --

-- deficições das taxas atuais para teste --
insert into Taxa values
(curdate(), "USD", 5.36),
(curdate(), "CNY", 0.75),
(curdate(), "BRL", 1.0);
-- (data da taxa, codigo da moeda, valor de conversao) --

-- definicoes de apostadores --
insert into Apostador values
("arthur.nacimento@aluno.ifsp.edu.br", "10000000901"),
("amanda.reis@aluno.ifsp.edu.br", "10000000902"),
("joão.guilherme@aluno.ifsp.edu.br",  "10000000903");
-- (chave do ususario(email), CPF) --

-- definicoes de organizadores --
insert into Organizador values
("carlos.diaz@.ifsp.edu.br", "10000000900001");
-- (chave do ususario(email), CNPJ) --

-- exemplo criacao modalidade --
-- insert into Modalidade_Sorteio values(default, 6, 0, 60, 1000.00, 5.00, now(), "0000-00-01 00:00:00", 5,"teste", "sorteio para testes", "carlos.diaz@.ifsp.edu.br", "10000000900001"); 
-- (chave auto incrementavel, quantidade de numeros para sortear, menor numero sorteavel, maior numero sorteavel, premio, preco do bilhete, data de inicio do primeiro sorteio, duração de cada sorteio, nome, descrição, chave do Organizador(email, CNPJ))

-- exemplo definição de modalidade como incremental --
-- insert into Modalidade_Incremental values(1, 100.00, 1);
-- (chave da modalidade(id_modalidade), valor incrementado no premio, condição de incremento(quantidade de bilhetes vendidos))

-- exemplo definição de modalidade como Acumulavel --
-- insert into Modalidade_Acumulavel values(1, 10.0);
-- (chave da modalidade(id_modalidade), porcentagem do premio do sorteio para acumuladar) obs: um sorteio acumula quando nao hoverem ganhadores

-- exemplo criacao de sorteio --
-- insert into Sorteio values(1, 1, now(), now() + "0000-00-01 00:00:00", 1000.00, true);
-- (chave da modalidade(id_modalidade), numero do sorteio, data de inicio, data de termino, premio, ativo)

-- exemplo compra bilhete --
-- insert into Bilhete values(default, 1, 1, now(), "arthur.nacimento@aluno.ifsp.edu.br", "10000000901");
-- (chave auto incrementavel, chave de soretio(id_modalidade, numero_sorteio), chave de Apostador(email, CFP))

-- exemplo criação de notificação --
-- insert into Notificacao values(now(),"arthur.nacimento@aluno.ifsp.edu.br", "você ganhau um premio no sorteio X!")
-- (data de criação, chave de ususario(email), mensagem)

-- exemplo resgistro de operação
-- insert into Operacao values(now(), curdate(), "BRL", "carlos.diaz@.ifsp.edu.br", 10000, 0);
-- (data da operação, chave de taxa(data_taxa, codigo_moeda), chave de ususario(email), valor em moeda selecionada, tipo de operação)

-- exemplo numeros sorteados/apostados
-- muito simples, n fiz