drop database if exists db_loteria;
create database db_loteria;

use db_loteria;

-- resgistro das taxas de transacao entre as diferentes moedas para a moeda do sistema -- 
create table if not exists Taxa(
	data_taxa date,
    codigo_moeda varchar(3),
    taxa_conversao decimal(11,2) not null,
    primary key (data_taxa, codigo_moeda) 
);

-- registro dos dados das contas dos usuarios --
create table if not exists Usuario(
	email varchar(50),
    nome varchar(30) not null,
    senha varchar(20) not null,
    telefone varchar(14),
    saldo decimal(11,2) not null,
    primary key (email) 
)engine = 'InnoDB';

-- resgistro das operacoes de saque/deposito no saldo da conta --
create table if not exists Operacao(
	data_operacao datetime,
    data_taxa date,
    codigo_moeda varchar(3),
    email varchar(50),
    valor_convertido decimal(11,2) not null,
    tipo_operacao int not null, -- 1 para saque, 0 para deposito --
    primary key (data_operacao, data_taxa, codigo_moeda, email),
    foreign key(email) references Usuario(email),
    foreign key(data_taxa, codigo_moeda) references Taxa(data_taxa, codigo_moeda)
)engine = 'InnoDB';

-- registro de notificacoes --
create table if not exists Notificacao(
	data_criacao datetime,
	email varchar(50),
    mensagem varchar(300) not null,
    primary key (data_criacao, email),
    foreign key(email) references Usuario(email)
)engine = 'InnoDB';

-- registro de CNPJs cadastrados --
create table if not exists Organizador(
	email varchar(50),
    cnpj varchar(14),
    primary key (email, cnpj),
    foreign key(email) references Usuario(email)
    on update cascade
);

-- registro de CPFs cadastrados --
create table if not exists Apostador(
	email varchar(50),
    cpf varchar(11),
    primary key (email, cpf),
    foreign key(email) references Usuario(email)
    on update cascade
);

-- registro de dados das modalidades criadas pelo Organizador --
create table if not exists Modalidade_Sorteio(
	id_modalidade int auto_increment,
    quantidade_numeros_sorteados int not null,
    inicio_intervalo int not null,
    fim_intervalo int not null,
    premio_inicial decimal(11,2) not null,
    preco_bilhete decimal(5,2) not null,
    inicio_sorteios datetime not null,
    duracao_sorteios datetime not null,
    numero_sorteios int not null,
    descricao varchar(300),
    email varchar(50),
    cnpj varchar(14),
    primary key (id_modalidade),
    foreign key(email, cnpj) references Organizador(email, cnpj)
    on update cascade
);

 -- registro de modalidades com comportamento de premio incrementavel --
create table if not exists Modalidade_Incremental(
	id_modalidade int,
    valor_incrementado decimal(11,2) not null,
    bilhetes_para_incrementar int not null,
    primary key (id_modalidade),
    foreign key(id_modalidade) references Modalidade_Sorteio(id_modalidade)
);

 -- registro de modalidades com comportamento de premio acumulavel --
create table if not exists Modalidade_Acumulavel(
	id_modalidade int,
    porcentagem_acumulavel decimal(5,2) not null,
    primary key (id_modalidade),
    foreign key(id_modalidade) references Modalidade_Sorteio(id_modalidade)
);

-- registro de sorteios --
create table if not exists Sorteio(
	id_modalidade int,
    numero_sorteio int auto_increment,
    inicio datetime not null,
    fim datetime not null,
    premio decimal(11,2) not null,
    primary key (numero_sorteio, id_modalidade),
    foreign key(id_modalidade) references Modalidade_Sorteio(id_modalidade)
)engine = 'InnoDB';

-- registro de bilhetes --
create table if not exists Bilhete(
	id_bilhete int auto_increment,
	id_modalidade int,
    numero_sorteio int,
    data_compra datetime not null,
    email varchar(50),
    cpf varchar(11),
    primary key (id_bilhete, id_modalidade, numero_sorteio),
    foreign key(id_modalidade, numero_sorteio) references Sorteio(id_modalidade, numero_sorteio),
	foreign key(email, cpf) references Apostador(email, cpf)
)engine = 'InnoDB';

-- guarda os numeros sorteados nos sorteios --
create table if not exists Numeros_Sorteio(
	id_modalidade int,
	numero_sorteio int,
    sorteado int not null,
    primary key (id_modalidade, numero_sorteio, sorteado),
    foreign key(id_modalidade, numero_sorteio) references Sorteio(id_modalidade, numero_sorteio)
)engine = 'InnoDB';

-- guarda os numeros apostados nos bilhetes --
create table if not exists Numeros_Bilhete(
	id_bilhete int,
	id_modalidade int,
    numero_sorteio int,
	apostado int not null,
    primary key (id_bilhete, id_modalidade, numero_sorteio, apostado),
    foreign key(id_bilhete, id_modalidade, numero_sorteio) references Bilhete(id_bilhete, id_modalidade, numero_sorteio)
)engine = 'InnoDB';

-- incerco dos ususraios de teste --
insert into Usuario values 
("arthur.nacimento@aluno.ifsp.edu.br", "Arthur Nacimento", "123456", "", 1000.0),
("amanda.reis@aluno.ifsp.edu.br", "Amanda Reis", "123456", "", 1000.0),
("joão.guilherme@aluno.ifsp.edu.br", "João Guilherme", "123456", "", 1000.0),
("carlos.diaz@.ifsp.edu.br", "Crlos Diaz", "123456", "", 10000.0);

-- definicoes das taxas de cambio--
insert into Taxa values
("2022-11-01", "USD", 5.17),
("2022-11-01", "CNY", 0.70),
("2022-11-01", "BRL", 1.0);

insert into Taxa values
(curdate(), "USD", 5.36),
(curdate(), "CNY", 0.75),
(curdate(), "BRL", 1.0);

-- definicoes de clientes --
insert into Apostador values
("arthur.nacimento@aluno.ifsp.edu.br", "10000000901"),
("amanda.reis@aluno.ifsp.edu.br", "10000000902"),
("joão.guilherme@aluno.ifsp.edu.br",  "10000000903");

-- definicoes de organizadores --
insert into Organizador values
("carlos.diaz@.ifsp.edu.br", "10000000900001");

-- exemplo criacao modalidade(nao usar) --
insert into Modalidade_Sorteio values(default, 6, 0, 60, 1000.00,5.00, now(), "0000-00-01 00:00:00", 5, "teste", "carlos.diaz@.ifsp.edu.br", "10000000900001");

-- exemplo criacao modalidade incremental(nao usar) --
insert into Modalidade_Incremental values(1, 100.00, 1);

-- exemplo criacao bilhete(nao usar) --
insert into Bilhete values(default, 1, 1, now(), "arthur.nacimento@aluno.ifsp.edu.br", "10000000901");

select * from Usuario;
select * from Taxa;
select * from Operacao;
select * from Cliente;
select * from Organizador;
select * from Modalidade_Sorteio;
select * from Modalidade_Incremental;
select * from Modalidade_Acumulavel;
select * from Sorteio;
select * from Bilhete;