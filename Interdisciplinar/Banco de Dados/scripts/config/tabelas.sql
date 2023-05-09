drop database if exists db_loteria;
create database db_loteria;

use db_loteria;

-- resgistro das taxas de transacao entre as diferentes moedas para a moeda do sistema -- 
drop table if exists Taxa;
create table if not exists Taxa(
	data_taxa date,
    codigo_moeda varchar(3),
    taxa_conversao decimal(11,2) not null,
    primary key (data_taxa, codigo_moeda) 
);

-- registro dos dados das contas dos usuarios --
drop table if exists Usuario;
create table if not exists Usuario(
	email varchar(50),
    nome varchar(30) not null,
    senha varchar(20) not null,
    telefone varchar(14),
    saldo decimal(11,2) not null,
    primary key (email) 
)engine = 'InnoDB';

-- resgistro das operacoes de saque/deposito no saldo da conta --
drop table if exists Operacao;
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
drop table if exists Notificacao;
create table if not exists Notificacao(
	data_criacao datetime,
	email varchar(50),
    mensagem varchar(300) not null,
    primary key (data_criacao, email),
    foreign key(email) references Usuario(email)
)engine = 'InnoDB';

-- registro de CNPJs cadastrados --
drop table if exists Organizador;
create table if not exists Organizador(
	email varchar(50),
    cnpj varchar(14),
    primary key (email, cnpj),
    foreign key(email) references Usuario(email)
    on update cascade
);

-- registro de CPFs cadastrados --
drop table if exists Apostador;
create table if not exists Apostador(
	email varchar(50),
    cpf varchar(11),
    primary key (email, cpf),
    foreign key(email) references Usuario(email)
    on update cascade
);

-- registro de dados das modalidades criadas pelo Organizador --
drop table if exists Modalidade_Sorteio;
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
    nome varchar(20),
    descricao varchar(300),
    email varchar(50),
    cnpj varchar(14),
    primary key (id_modalidade),
    foreign key(email, cnpj) references Organizador(email, cnpj)
    on update cascade
);

 -- registro de modalidades com comportamento de premio incrementavel --
 drop table if exists Modalidade_Incremental;
create table if not exists Modalidade_Incremental(
	id_modalidade int,
    valor_incrementado decimal(11,2) not null,
    bilhetes_para_incrementar int not null,
    primary key (id_modalidade),
    foreign key(id_modalidade) references Modalidade_Sorteio(id_modalidade)
);

 -- registro de modalidades com comportamento de premio acumulavel --
 drop table if exists Modalidade_Acumulavel;
create table if not exists Modalidade_Acumulavel(
	id_modalidade int,
    porcentagem_acumulavel decimal(5,2) not null,
    primary key (id_modalidade),
    foreign key(id_modalidade) references Modalidade_Sorteio(id_modalidade)
);

-- registro de sorteios --
drop table if exists Sorteio;
create table if not exists Sorteio(
	id_modalidade int,
    numero_sorteio int,
    inicio datetime not null,
    fim datetime not null,
    premio decimal(11,2) not null,
    ativo boolean,
    primary key (numero_sorteio, id_modalidade),
    foreign key(id_modalidade) references Modalidade_Sorteio(id_modalidade)
)engine = 'InnoDB';

-- registro de bilhetes --
drop table if exists Bilhete;
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
drop table if exists Numeros_Sorteio;
create table if not exists Numeros_Sorteio(
	id_modalidade int,
	numero_sorteio int,
    sorteado int not null,
    primary key (id_modalidade, numero_sorteio, sorteado),
    foreign key(id_modalidade, numero_sorteio) references Sorteio(id_modalidade, numero_sorteio)
)engine = 'InnoDB';

-- guarda os numeros apostados nos bilhetes --
drop table if exists Numeros_Bilhete;
create table if not exists Numeros_Bilhete(
	id_bilhete int,
	id_modalidade int,
    numero_sorteio int,
	apostado int not null,
    primary key (id_bilhete, id_modalidade, numero_sorteio, apostado),
    foreign key(id_bilhete, id_modalidade, numero_sorteio) references Bilhete(id_bilhete, id_modalidade, numero_sorteio)
)engine = 'InnoDB';

/*select * from Usuario;
select * from Taxa;
select * from Operacao;
select * from Apostador;
select * from Organizador;
select * from Modalidade_Sorteio;
select * from Modalidade_Incremental;
select * from Modalidade_Acumulavel;
select * from Sorteio;
select * from Bilhete;*/