-- Criação do Banco de Dados para o cenário de E-Commerce.
CREATE DATABASE IF NOT EXISTS ecommerce;
USE ecommerce;
SHOW TABLES;

DROP DATABASE ecommerce;

-- Criando as tabelas das entidades.
CREATE TABLE cliente(
	idCliente INT AUTO_INCREMENT PRIMARY KEY,
    pNome VARCHAR(15) NOT NULL,
    nMeio VARCHAR(3),
    Sobrenome VARCHAR(20) NOT NULL,
    CPF CHAR(11) NOT NULL,
    Tipo ENUM('PJ','PF') DEFAULT('PJ'),
    Endereco VARCHAR(45),
    dataNascimento DATE,
    CONSTRAINT unique_cpf_cliente UNIQUE(CPF)
);
DESC cliente;

CREATE TABLE produto(
	idProduto INT AUTO_INCREMENT PRIMARY KEY,
    nomeProduto VARCHAR(15) NOT NULL,
    Classificacao BOOL DEFAULT(FALSE),
    Categoria ENUM('Eletronicos','Vestuarios','Brinquedos','Alimentos','Outros') DEFAULT('Outros'),
    Avaliacao FLOAT DEFAULT(0),
    Tamanho VARCHAR(10)    
);
DESC produto;

CREATE TABLE vendedor(
	idVendedor INT AUTO_INCREMENT PRIMARY KEY,
    razaoSocial VARCHAR(45),
    Endereco VARCHAR(45),
    nomeFantasia VARCHAR(45),
    CNPJ CHAR(15),
    CPF CHAR(11),
    CONSTRAINT unique_razaoSocial UNIQUE(razaoSocial),
    CONSTRAINT unique_cpf_vendedor UNIQUE(CPF),
    CONSTRAINT unique_cnpj_vendedor UNIQUE(CNPJ)
);
DESC vendedor;

CREATE TABLE pagamento(
	idPagamento INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT NOT NULL,
    tipoPagamento ENUM('Cartão Débito','Cartão Crédito','PIX','Outros') NOT NULL DEFAULT('Outros'),
    Limite FLOAT,
    CONSTRAINT fk_pagamento_cliente FOREIGN KEY(idCliente) REFERENCES cliente(idCliente)      
);
DESC pagamento;

CREATE TABLE pedido(
	idPedido INT AUTO_INCREMENT PRIMARY KEY,
    idCliente INT,
    Descricao VARCHAR(255),
    Frete FLOAT DEFAULT (10),
    statusPedido ENUM('Cancelado','Confirmado','Em processamento') NOT NULL DEFAULT ('Em processamento'),
    idPagamento INT,
    CONSTRAINT fk_pedido_cliente FOREIGN KEY(idCliente) REFERENCES cliente(idCliente),
    CONSTRAINT fk_pedido_pagamento FOREIGN KEY(idPagamento) REFERENCES pagamento(idPagamento)
);
DESC pedido;

CREATE TABLE fornecedor(
	idFornecedor INT AUTO_INCREMENT PRIMARY KEY,
    razaoSocial VARCHAR(255) NOT NULL,
    CNPJ CHAR(15) NOT NULL,
    Contato VARCHAR(45) NOT NULL,
    CONSTRAINT unique_cnpj UNIQUE(CNPJ)
);
DESC fornecedor;

CREATE TABLE estoque(
	idEstoque INT AUTO_INCREMENT PRIMARY KEY,
    localEstoque VARCHAR(45) NOT NULL UNIQUE    
);
DESC estoque;

CREATE TABLE entrega(
	idEntrega INT AUTO_INCREMENT PRIMARY KEY,
    idPedido INT NOT NULL,
    Codigo VARCHAR(20) NOT NULL,
    statusEntrega ENUM('Processando','Liberado','Em Transito','Entregue','Cancelado') DEFAULT('Processando'),
    CONSTRAINT unique_codigo_entrega UNIQUE(Codigo),
    CONSTRAINT fk_entrega_pedido FOREIGN KEY(idPedido) REFERENCES pedido(idPedido)
);

-- Criando as tabelas de relações
CREATE TABLE produto_pedido(
	idPedido INT,
    idProduto INT,
    Quantidade INT NOT NULL,
    CONSTRAINT pk_produto_pedido PRIMARY KEY(idPedido,idProduto),
    CONSTRAINT fk_prod_ped_pedido FOREIGN KEY(idPedido) REFERENCES pedido(idPedido),
    CONSTRAINT fk_prod_ped_produto FOREIGN KEY(idProduto) REFERENCES produto(idProduto)
);
DESC produto_pedido;

CREATE TABLE produto_estoque(
	idEstoque INT,
    idProduto INT,
    Quantidade INT NOT NULL,
    CONSTRAINT pk_produto_estoque PRIMARY KEY(idEstoque,idProduto),
    CONSTRAINT fk_prod_est_estoque FOREIGN KEY(idEstoque) REFERENCES estoque(idEstoque),
    CONSTRAINT fk_prod_est_produto FOREIGN KEY(idProduto) REFERENCES produto(idProduto)
);
DESC produto_estoque;

CREATE TABLE produto_fornecedor(
	idFornecedor INT,
    idProduto INT,
    Quantidade INT NOT NULL,
    CONSTRAINT pk_produto_fornecedor PRIMARY KEY(idFornecedor,idProduto),
    CONSTRAINT fk_prod_forn_fornecedor FOREIGN KEY(idFornecedor) REFERENCES fornecedor(idFornecedor),
    CONSTRAINT fk_prod_forn_produto FOREIGN KEY(idProduto) REFERENCES produto(idProduto)
);
DESC produto_fornecedor;

CREATE TABLE produto_vendedor(
	idVendedor INT,
    idProduto INT,
    Quantidade INT NOT NULL,
    CONSTRAINT pk_produto_vendedor PRIMARY KEY(idVendedor,idProduto),
    CONSTRAINT fk_prod_vend_vendedor FOREIGN KEY(idVendedor) REFERENCES vendedor(idVendedor),
    CONSTRAINT fk_prod_vend_produto FOREIGN KEY(idProduto) REFERENCES produto(idProduto)
);
DESC produto_vendedor;

SELECT * FROM pedido;

-- Inserindo dados nas Tabelas

INSERT INTO cliente (pNome, nMeio, Sobrenome, CPF, Endereco, dataNascimento) VALUES ('Jonathan','W','Lino','14725836912','Rua Nenhuma','1994-04-19'),
																					('Vinicius','S','Silva','78945612336','Rua Nenhuma 2','1994-08-19'),
                                                                                    ('Milena','T','Chata','14569872358','Rua Nenhuma 3','1999-02-28'),
                                                                                    ('Clarisse','A','Cunha','14564872358','Rua Nenhuma 4','2011-02-28');
																				
INSERT INTO produto (nomeProduto, Classificacao, Categoria, Avaliacao, Tamanho) VALUES ('Boneco',TRUE,'Brinquedos',5,'PP'),
																					   ('Televisão',TRUE,'Eletronicos',5,'G'),
                                                                                       ('Camisa',TRUE,'Vestuarios',5,'M');

INSERT INTO vendedor (razaoSocial, Endereco, nomeFantasia, CNPJ, CPF) VALUES ('RicardoStore','Rua Vendedor 1','RicardãoBrinquedos','147852369745891','14785269854'),
																			 ('RoupaNova','Rua Vendedor 2','SuperRoupa','541236987589514','14785423691');

INSERT INTO pagamento (idCliente, tipoPagamento, Limite) VALUES ('1','Cartão Débito', 1000.00),
																('2','Cartão Crédito', 5000.00),
                                                                ('3','PIX',0.0),
                                                                ('4','Cartão Débito', 400.00);

INSERT INTO pedido (idCliente, Descricao, Frete, statusPedido, idPagamento) VALUES ('1','Pedido de um produto',20.00,'Confirmado','1'),
																				   ('2','Pedido de um produto',30.00,'Cancelado','2'),
                                                                                   ('1','Compras',30.00,'Confirmado','1'),
                                                                                   ('4','Compras',0.00,'Confirmado','4');

INSERT INTO fornecedor (razaoSocial, CNPJ, Contato) VALUES ('MundoBrinquedos','489657812549785','mundbrinq@gmail.com'),
														   ('Alfaiataria','789456123852147','011998745125');

INSERT INTO estoque (localEstoque) VALUES ('Andar 12');

INSERT INTO entrega(idPedido, Codigo, statusEntrega) VALUES ('1','458795645','Processando');

SELECT * FROM fornecedor;
-- Inserindo relacionamentos

INSERT INTO produto_estoque (idEstoque, idProduto, Quantidade) VALUES ('1','4', 200);

INSERT INTO produto_fornecedor (idFornecedor, idProduto, Quantidade) VALUES ('2','6', 1200);

INSERT INTO produto_pedido (idPedido, idProduto, Quantidade) VALUES ('4','6', 5);

INSERT INTO produto_vendedor (idVendedor, idProduto, Quantidade) VALUES ('3','4', 200);

-- DESAFIO

-- Recuperação simples com SELECT STATEMENT
SELECT * FROM cliente;

-- Filtro com WHERE STATEMENT
SELECT * FROM cliente
	WHERE Sobrenome = 'Silva';

-- Expressão para gerar atributos derivados
SELECT concat(pNome, ' ', Sobrenome) AS Nome FROM cliente;

-- Definindo ordenação dos dados com ORDER BY
SELECT * FROM cliente
	ORDER BY dataNascimento DESC;

-- Condições de filtro aos grupos usando HAVING STATEMENT
SELECT idPedido, COUNT(*) AS Produtos_Comprados, SUM(Quantidade) AS Quantidade_Produtos FROM produto_pedido
	GROUP BY idPedido
    HAVING Quantidade_Produtos > 100;

-- Criar junções entre tabelas.
SELECT concat(c.pNome,' ',c.Sobrenome) AS Nome, nomeProduto AS Produto, pe.statusPedido AS Situação, pa.tipoPagamento AS Pagamento
	FROM cliente c, pagamento pa, pedido pe, produto_pedido pp, produto pro
    WHERE c.idCliente = pa.idCliente AND c.idCliente = pe.idCliente AND pe.idPedido = pp.idPedido and pp.idProduto = pro.idProduto;


-- Relação de Fornecedor-Produto    
SELECT f.razaoSocial, p.nomeProduto FROM produto p, fornecedor f, produto_fornecedor pf
	WHERE p.idProduto = pf.idProduto AND f.idFornecedor = pf.idFornecedor;




