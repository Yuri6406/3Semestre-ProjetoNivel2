CREATE DATABASE loja;

USE loja;

CREATE TABLE
    Pessoa (
        idPessoa INTEGER NOT NULL PRIMARY KEY,
        nome VARCHAR(255) NOT NULL,
        rua VARCHAR(255) NOT NULL,
        cidade VARCHAR(255) NOT NULL,
        estado CHAR(2) NOT NULL,
        telefone VARCHAR(11) NOT NULL,
        email VARCHAR(255) NOT NULL
    );

CREATE TABLE
    PessoaJuridica (
        idPessoa INTEGER NOT NULL PRIMARY KEY,
        cnpj VARCHAR(14) NOT NULL,
        CONSTRAINT fk_PessoaJuridica_Pessoa FOREIGN KEY (idPessoa) REFERENCES Pessoa (idPessoa)
    );

CREATE TABLE
	PessoaFisica (
		idPessoa INTEGER NOT NULL PRIMARY KEY,
		cpf VARCHAR(11) NOT NULL,
		constraint fk_PessoaFisica_Pessoa foreign key (idPessoa) references Pessoa (idPessoa)
	);

CREATE TABLE
	Produto (
		idProduto INTEGER NOT NULL PRIMARY KEY,
		nome VARCHAR(255) NOT NULL,
		quantidade INTEGER NOT NULL,
		precoVenda double NOT NULL
	);

CREATE TABLE
	Usuario (
		idUsuario INTEGER NOT NULL PRIMARY KEY,
		login VARCHAR(50) NOT NULL,
		senha VARCHAR(50) NOT NULL
	);

CREATE TABLE
	Movimento (
		idMovimento INTEGER NOT NULL PRIMARY KEY,
		idUsuario INTEGER NOT NULL,
		idPessoa INTEGER NOT NULL,
		idProduto INTEGER NOT NULL,
		quantidade INTEGER NOT NULL,
		tipo CHAR(1) NOT NULL,
		valorUnitario FLOAT NOT NULL,
		constraint fk_Movimento_Produto foreign key (idProduto) references Produto (idProduto),
		constraint fk_Movimento_Usuario foreign key (idUsuario) references Usuario (idUsuario),
		constraint fk_Movimento_Pessoa foreign key (idPessoa) references Pessoa (idPessoa)
	);
