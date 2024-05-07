use loja;

insert into `loja`.`usuario`(`idUsuario`,`login`,`senha`) values (1,'op1','op1');
insert into `loja`.`usuario`(`idUsuario`,`login`,`senha`) values (2,'op2','op2');

select * from usuario;

insert into `loja`.`produto`(`idProduto`,`nome`,`quantidade`,`precoVenda`) values (1,'Banana',100,5.00);
insert into `loja`.`produto`(`idProduto`,`nome`,`quantidade`,`precoVenda`) values (3,'Laranja',500,2.00);
insert into `loja`.`produto`(`idProduto`,`nome`,`quantidade`,`precoVenda`) values (4,'Manga',800,4.00);

select * from produto;

insert into `loja`.`pessoa`(`idPessoa`,`nome`,`rua`,`cidade`,`estado`,`telefone`,`email`) values (7,'Joao','Rua 12.casa 3.Quitanda','Riacho do Sul','PA','1111-1111','joao@riacho.com');
insert into `loja`.`pessoafisica`(`idPessoa`,`cpf`) values (7,'1111111111');


insert into `loja`.`pessoa`(`idPessoa`,`nome`,`rua`,`cidade`,`estado`,`telefone`,`email`) values (15,'JJC','Rua 11.Centro','Riacho do Norte','PA','1212-1212','jcc@riacho.com');
insert into `loja`.`pessoajuridica`(`idPessoa`,`cnpj`) values (15,'22222222222222');

insert into `loja`.`movimento`(`idMovimento`,`idUsuario`,`idPessoa`,`idProduto`,`quantidade`,`tipo`,`valorUnitario`) values (1,1,7,1,20,'S',4.00);
insert into `loja`.`movimento`(`idMovimento`,`idUsuario`,`idPessoa`,`idProduto`,`quantidade`,`tipo`,`valorUnitario`) values (4,1,7,3,15,'S',2.00);
insert into `loja`.`movimento`(`idMovimento`,`idUsuario`,`idPessoa`,`idProduto`,`quantidade`,`tipo`,`valorUnitario`) values (5,2,7,3,10,'S',3.00);
insert into `loja`.`movimento`(`idMovimento`,`idUsuario`,`idPessoa`,`idProduto`,`quantidade`,`tipo`,`valorUnitario`) values (7,1,'15',3,15,'E',5.00);
insert into `loja`.`movimento`(`idMovimento`,`idUsuario`,`idPessoa`,`idProduto`,`quantidade`,`tipo`,`valorUnitario`) values (8,1,15,4,20,'E',4.00);

-- Dados completos de pessoas físicas
select
pessoa.*,
pessoafisica.*
from pessoa
inner join pessoafisica on
pessoafisica.idPessoa = pessoa.idPessoa;

-- Dados completos de pessoas jurídicas
select
pessoa.*,
pessoajuridica.*
from pessoa
inner join pessoajuridica on
pessoajuridica.idPessoa = pessoa.idPessoa;

-- Movimentações de entrada, com produto, fornecedor, quantidade, preço unitário e valor total.
select
P.nome,
fornecedor.nome as fornecedor,
M.quantidade,
M.valorUnitario,
M.quantidade * M.valorUnitario as valorTotal
from produto P
inner join movimento M on P.idProduto = M.idProduto,
(select
pessoa.nome,
pessoajuridica.*
from pessoa
inner join pessoajuridica on
pessoajuridica.idPessoa = pessoa.idPessoa
)fornecedor
where tipo = 'E';

-- Movimentações de saída, com produto, comprador, quantidade, preço unitário e valor total.
select
P.nome,
comprador.nome as comprador,
M.quantidade,
M.valorUnitario,
M.quantidade * M.valorUnitario as valorTotal
from produto P
inner join movimento M on P.idProduto = M.idProduto,
(select
P.nome,
pessoaFisica.*
from pessoa P
inner join pessoaFisica on
pessoaFisica.idPessoa = P.idPessoa
)comprador
where tipo = 'S';

-- Valor total das entradas agrupadas por produto
select 
P.nome,
M.quantidade * M.valorUnitario as valorTotal
from produto P
inner join movimento M on P.idProduto = M.idProduto
where tipo = 'E';

-- Valor total das saídas agrupadas por produto
select 
P.nome,
M.quantidade * P.precoVenda as valorTotal
from produto P
inner join movimento M on P.idProduto = M.idProduto
where tipo = 'S';

-- Operadores que não efetuaram movimentações de entrada(compra)
select
U.login as operador
from usuario U
inner join movimento M on U.idUsuario = M.idUsuario
where tipo = 'E' and quantidade = 0;

-- Valor total de entrada por operador
select U.login as operador, SUM(M.valorUnitario) as valor_total_entradas
from usuario U
left join movimento M on U.idUsuario = M.idUsuario
where M.tipo = 'E'
group by U.login;

-- Valor total de saída por operador
select U.login as operador, SUM(M.valorUnitario) as valor_total_saida
from usuario U
left join movimento M on U.idUsuario = M.idUsuario
where M.tipo = 'S'
group by U.login;

-- Valor médio de venda por produto, utilizando média ponderada
select  P.nome, format(SUM(M.valorUnitario * M.quantidade) / SUM(M.quantidade),2) AS valor_medio_venda
from movimento M
inner join produto P on M.idProduto = P.idProduto
where tipo = 'S'
group by P.nome;