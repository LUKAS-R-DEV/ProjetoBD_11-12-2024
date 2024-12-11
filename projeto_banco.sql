use ifood_base;
SET FOREIGN_KEY_CHECKS = 1;

select * from promocao;
select * from promocao where id=3;

UPDATE feedback
SET comentario = 'Comida boa, mas o atendimento poderia melhorar.'
WHERE id = 1;

select acompanhamento.nome as acompanhamento_nome,valor,descricao,restaurante.nome as restaurante_nome from acompanhamento inner join restaurante on acompanhamento.id_restaurante=restaurante.id;

select produto.nome,sum(produto_pedido.id_produto) as quantidade_vendida
from produto inner join produto_pedido on produto.id=produto_pedido.id_produto
group by produto.id order by quantidade_vendida desc limit 1;

select produto.nome,sum(produto_pedido.id_produto) as quantidade_vendida
from produto inner join produto_pedido on produto.id=produto_pedido.id_produto
group by produto.id order by quantidade_vendida asc limit 1;

select year (pedido.dataPedido) as ano,month(pedido.dataPedido) as mes,sum(produto_pedido.quantidade) as total_vendas
from pedido
join produto_pedido on pedido.id=produto_pedido.id_pedido
group by year (pedido.dataPedido),month(pedido.dataPedido) order by
total_vendas desc limit 1;

select formaDePagamento.descricao as forma_pagamento,count(pedido.id) as total_pedidos
from pedido
join formaDePagamento on pedido.id_formaDePagamento=formaDePagamento.id
group by formaDePagamento.id
order by total_pedidos desc limit 1;

select endereco.bairro,endereco.cidade,endereco.estado,count(pedido.id) as total_entregas
from pedido
join restaurante on pedido.id_restaurante=restaurante.id
join endereco on restaurante.id_endereco=endereco.id
group by endereco.id
order by total_entregas desc
limit 1;

select pedido.id as id_pedido,sum(produto_pedido.quantidade) as total_produtos
from pedido
join produto_pedido on pedido.id=produto_pedido.id_pedido
group by pedido.id
order by total_produtos desc
limit 1;

SELECT formaDePagamento.descricao AS forma_pagamento, SUM(pedido.total) AS total_vendas
FROM pedido
JOIN formaDePagamento ON pedido.id_formaDePagamento = formaDePagamento.id
WHERE YEAR(pedido.dataPedido) = YEAR(CURDATE()) AND MONTH(pedido.dataPedido) = MONTH(CURDATE())
GROUP BY formaDePagamento.id;

SELECT formaDePagamento.descricao AS forma_pagamento, SUM(pedido.total) AS total_vendas
FROM pedido
JOIN formaDePagamento ON pedido.id_formaDePagamento = formaDePagamento.id
WHERE YEAR(pedido.dataPedido) = YEAR(CURDATE()) AND MONTH(pedido.dataPedido) = MONTH(CURDATE()) - 1
GROUP BY formaDePagamento.id;

CREATE TABLE categoria (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    tipo VARCHAR(60),
    descricao VARCHAR(200)
);

CREATE TABLE endereco (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero VARCHAR(60) NOT NULL,
    complemento VARCHAR(60),
    bairro VARCHAR(60),
    cidade VARCHAR(60),
    estado VARCHAR(60),
    cep VARCHAR(20)
);

CREATE TABLE restaurante (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(60) NOT NULL,
    horario_funcionamento varchar(20),
    aceitaRetirada BOOLEAN,
    id_categoria INT,
    id_endereco INT,
    telefone VARCHAR(20),
    ativo BOOLEAN,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id),
    FOREIGN KEY (id_endereco) REFERENCES endereco(id)
);

CREATE TABLE produto (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_restaurante INT,
    id_categoria INT,
    nome VARCHAR(60) NOT NULL,
    descricao VARCHAR(200),
    valor FLOAT,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id),
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id)
);

CREATE TABLE promocao (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_produto INT,
    nome VARCHAR(60) NOT NULL,
    descricao VARCHAR(200) NOT NULL,
    codigo VARCHAR(30),
    data_inicio DATETIME,
    data_fim DATETIME,
    FOREIGN KEY (id_produto) REFERENCES produto(id)
);

CREATE TABLE acompanhamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_restaurante INT,
    nome VARCHAR(60) NOT NULL,
    valor FLOAT,
    descricao VARCHAR(200) NOT NULL,
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id)
);

CREATE TABLE produto_acompanhamento (
    id_produto INT,
    id_acompanhamento INT,
    PRIMARY KEY (id_produto, id_acompanhamento),
    FOREIGN KEY (id_produto) REFERENCES produto(id),
    FOREIGN KEY (id_acompanhamento) REFERENCES acompanhamento(id)
);

CREATE TABLE formaDePagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao ENUM('Cartão', 'Pix', 'Dinheiro')
);

CREATE TABLE statusDaEntrega (
    id INT AUTO_INCREMENT PRIMARY KEY,
    descricao ENUM('Preparando', 'A Caminho', 'Entregue')
);

CREATE TABLE pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    observacao VARCHAR(200),
    troco FLOAT,
    id_restaurante INT,
    id_formaDePagamento INT,
    id_status INT,
    dataPedido DATETIME,
    total FLOAT,
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id),
    FOREIGN KEY (id_formaDePagamento) REFERENCES formaDePagamento(id),
    FOREIGN KEY (id_status) REFERENCES statusDaEntrega(id)
);

CREATE TABLE produto_pedido (
    id INT AUTO_INCREMENT PRIMARY KEY,
    quantidade FLOAT,
    id_pedido INT,
    id_produto INT,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id),
    FOREIGN KEY (id_produto) REFERENCES produto(id)
);

CREATE TABLE historicoDePagamento (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    dataDePagamento DATETIME,
    valorPago FLOAT,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id)
);

CREATE TABLE historicoEntrega (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT,
    id_status INT,
    dataEntrega DATE,
    FOREIGN KEY (id_pedido) REFERENCES pedido(id),
    FOREIGN KEY (id_status) REFERENCES statusDaEntrega(id)
);

CREATE TABLE restaurante_pagamento (
    id_restaurante INT,
    id_formaPagamento INT,
    PRIMARY KEY (id_restaurante, id_formaPagamento),
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id),
    FOREIGN KEY (id_formaPagamento) REFERENCES formaDePagamento(id)
);

CREATE TABLE pedido_produto_acompanhamento (
    id_pedido_produto INT,
    id_acompanhamento INT,
    FOREIGN KEY (id_pedido_produto) REFERENCES produto_pedido(id),
    FOREIGN KEY (id_acompanhamento) REFERENCES acompanhamento(id)
);

CREATE TABLE feedback (
    id INT AUTO_INCREMENT PRIMARY KEY,
    id_restaurante INT,
    comentario VARCHAR(200),
    dataComentario DATE,
    FOREIGN KEY (id_restaurante) REFERENCES restaurante(id)
);

INSERT INTO categoria (nome, tipo, descricao) VALUES
('Comida Italiana', 'Almoço', 'Pratos típicos da culinária italiana'),
('Comida Brasileira', 'Almoço', 'Pratos tradicionais brasileiros'),
('Sushi', 'Jantar', 'Comida japonesa, incluindo sushi e sashimi'),
('Hamburgueria', 'Jantar', 'Pratos com hambúrgueres gourmet'),
('Sorveteria', 'Sobremesa', 'Variedade de sorvetes e sobremesas geladas'),
('Churrascaria', 'Almoço', 'Carnes grelhadas típicas do Brasil'),
('Pizza', 'Jantar', 'Pizzas de diversos sabores'),
('Comida Vegana', 'Almoço', 'Pratos sem ingredientes de origem animal'),
('Comida Mexicana', 'Almoço', 'Pratos típicos da culinária mexicana'),
('Comida Árabe', 'Almoço', 'Pratos típicos da culinária árabe'),
('Lanches', 'Lanche', 'Lanches rápidos e práticos'),
('Frutos do Mar', 'Jantar', 'Pratos preparados com frutos do mar'),
('Pastelaria', 'Lanche', 'Pastéis fritos e recheados'),
('Comida Fast Food', 'Jantar', 'Pratos rápidos e tradicionais de fast food'),
('Comida de Rua', 'Lanche', 'Pratos típicos de comida de rua');

INSERT INTO endereco (numero, complemento, bairro, cidade, estado, cep) VALUES
('100', 'Apto 101', 'Centro', 'São Paulo', 'SP', '01000-000'),
('200', 'Casa 202', 'Jardim Paulista', 'São Paulo', 'SP', '01010-010'),
('300', 'Casa 303', 'Vila Progredior', 'Rio de Janeiro', 'RJ', '20000-200'),
('400', 'Apto 404', 'Barra', 'Rio de Janeiro', 'RJ', '22000-220'),
('500', 'Casa 505', 'Pinheiros', 'São Paulo', 'SP', '05400-400'),
('600', 'Apto 606', 'Itaim Bibi', 'São Paulo', 'SP', '04500-500'),
('700', 'Casa 707', 'Copacabana', 'Rio de Janeiro', 'RJ', '22010-220'),
('800', 'Apto 808', 'Leblon', 'Rio de Janeiro', 'RJ', '22430-230'),
('900', 'Casa 909', 'Alto da Boa Vista', 'São Paulo', 'SP', '05500-550'),
('1000', 'Casa 1010', 'Bela Vista', 'São Paulo', 'SP', '01310-010'),
('1100', 'Apto 1111', 'Moema', 'São Paulo', 'SP', '04510-000'),
('1200', 'Casa 1212', 'Lagoa', 'Rio de Janeiro', 'RJ', '22470-001'),
('1300', 'Apto 1313', 'São Conrado', 'Rio de Janeiro', 'RJ', '22610-100'),
('1400', 'Casa 1414', 'Vila Madalena', 'São Paulo', 'SP', '05460-100');

INSERT INTO restaurante (nome, horario_funcionamento, aceitaRetirada, id_categoria, id_endereco, telefone, ativo) VALUES
('Pasta & Basta', '11:00-23:00', TRUE, 1, 1, '11 1234-5678', TRUE),
('Churrasco Grill', '10:00-22:00', TRUE, 6, 2, '21 2345-6789', TRUE),
('Sushi House', '17:00-23:00', TRUE, 3, 3, '21 3456-7890', TRUE),
('Burger King', '11:00-23:00', TRUE, 4, 4, '11 4567-8901', TRUE),
('Sorveteria Delícia', '14:00-22:00', TRUE, 5, 5, '11 5678-9012', TRUE),
('Rodízio Grill', '12:00-23:00', TRUE, 6, 6, '21 6789-0123', TRUE),
('Pizza Hut', '11:00-23:00', TRUE, 7, 7, '11 7890-1234', TRUE),
('Vegan Love', '11:00-22:00', TRUE, 8, 8, '11 8901-2345', TRUE),
('Taco Bell', '11:00-23:00', TRUE, 9, 9, '21 9012-3456', TRUE),
('Café Árabe', '10:00-22:00', TRUE, 10, 10, '21 0123-4567', TRUE),
('Lanches Rapidos', '08:00-20:00', TRUE, 11, 11, '11 1234-5678', TRUE),
('Seafood Express', '11:00-23:00', TRUE, 12, 12, '21 2345-6789', TRUE),
('Pastel Mania', '08:00-18:00', TRUE, 13, 13, '11 3456-7890', TRUE),
('McDonald s', '11:00-23:00', TRUE, 14, 14, '11 4567-8901', TRUE),
('Comida de Rua SP', '10:00-22:00', TRUE, 15, 15, '11 5678-9012', TRUE);

INSERT INTO produto (id_restaurante, id_categoria, nome, descricao, valor) VALUES
(1, 1, 'Lasagna', 'Lasagna de carne com molho de tomate', 30.00),
(2, 6, 'Espetinho de Carne', 'Espetinho de picanha no espeto', 25.00),
(3, 3, 'Sushi de Salmão', 'Sushi de salmão fresco', 35.00),
(4, 4, 'Hambúrguer Gourmet', 'Hambúrguer com queijo cheddar e bacon', 20.00),
(5, 5, 'Sorvete de Chocolate', 'Sorvete artesanal de chocolate', 15.00),
(6, 6, 'Picanha no Espeto', 'Picanha grelhada na brasa', 40.00),
(7, 7, 'Pizza de Mussarela', 'Pizza de mussarela com molho de tomate', 22.00),
(8, 8, 'Hambúrguer Vegano', 'Hambúrguer à base de grão de bico', 18.00),
(9, 9, 'Tacos', 'Tacos com carne de frango e guacamole', 28.00),
(10, 10, 'Falafel', 'Bolinho de grão de bico com especiarias', 12.00),
(11, 11, 'Cachorro Quente', 'Cachorro quente com salsicha e ketchup', 10.00),
(12, 12, 'Camarão Frito', 'Camarões fritos com molho especial', 45.00),
(13, 13, 'Pastel de Carne', 'Pastel de carne moída e queijo', 8.00),
(14, 14, 'Big Mac', 'Sanduíche tradicional da casa', 25.00),
(15, 15, 'Pastel de Feijão', 'Pastel de feijão com queijo', 6.00);

INSERT INTO produto_pedido (quantidade, id_pedido, id_produto) VALUES
(2, 1, 1),
(1, 2, 2),
(3, 3, 3),
(1, 4, 4),
(2, 5, 5),
(4, 6, 6),
(1, 7, 7),
(2, 8, 8),
(3, 9, 9),
(2, 10, 10),
(5, 11, 11),
(4, 12, 12),
(2, 13, 13),
(1, 14, 14),
(3, 15, 15);

INSERT INTO historicoDePagamento (id_pedido, dataDePagamento, valorPago) VALUES
(1, '2024-01-10 13:00:00', 55.00),
(2, '2024-02-14 13:30:00', 80.00),
(3, '2024-03-20 19:00:00', 60.00),
(4, '2024-04-25 20:30:00', 70.00),
(5, '2024-05-15 14:30:00', 50.00),
(6, '2024-06-01 18:00:00', 120.00),
(7, '2024-07-10 17:30:00', 90.00),
(8, '2024-08-05 14:30:00', 45.00),
(9, '2024-09-11 20:00:00', 65.00),
(10, '2024-10-21 21:00:00', 30.00),
(11, '2024-11-03 15:30:00', 20.00),
(12, '2024-12-10 14:00:00', 100.00),
(13, '2024-12-20 20:00:00', 75.00),
(14, '2024-12-31 22:30:00', 120.00),
(15, '2024-12-31 23:30:00', 80.00);


-- Janeiro
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Janeiro 1', 5.00, 1, 1, 1, '2024-01-10 12:30:00', 55.00),
('Pedido de Janeiro 2', 3.00, 2, 2, 2, '2024-01-15 14:30:00', 40.00),
('Pedido de Janeiro 3', 1.50, 3, 3, 3, '2024-01-20 17:00:00', 70.00),
('Pedido de Janeiro 4', 0.00, 4, 1, 1, '2024-01-22 13:00:00', 50.00),
('Pedido de Janeiro 5', 2.00, 5, 2, 2, '2024-01-25 19:00:00', 60.00),
('Pedido de Janeiro 6', 0.00, 6, 3, 1, '2024-01-28 20:00:00', 80.00),
('Pedido de Janeiro 7', 3.50, 7, 1, 3, '2024-01-30 18:00:00', 65.00),
('Pedido de Janeiro 8', 5.00, 8, 2, 1, '2024-01-05 14:00:00', 50.00),
('Pedido de Janeiro 9', 1.00, 9, 3, 2, '2024-01-18 13:30:00', 55.00),
('Pedido de Janeiro 10', 4.00, 10, 1, 3, '2024-01-12 16:30:00', 75.00);

-- Fevereiro
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Fevereiro 1', 2.50, 2, 1, 1, '2024-02-02 12:00:00', 45.00),
('Pedido de Fevereiro 2', 0.00, 3, 2, 2, '2024-02-05 14:30:00', 60.00),
('Pedido de Fevereiro 3', 3.00, 4, 3, 1, '2024-02-08 17:30:00', 55.00),
('Pedido de Fevereiro 4', 4.00, 5, 1, 3, '2024-02-10 12:00:00', 70.00),
('Pedido de Fevereiro 5', 1.00, 6, 2, 1, '2024-02-12 18:00:00', 50.00),
('Pedido de Fevereiro 6', 3.50, 7, 3, 2, '2024-02-15 19:00:00', 80.00),
('Pedido de Fevereiro 7', 2.00, 8, 1, 3, '2024-02-18 20:30:00', 65.00),
('Pedido de Fevereiro 8', 1.50, 9, 2, 1, '2024-02-20 13:00:00', 75.00),
('Pedido de Fevereiro 9', 2.00, 10, 3, 2, '2024-02-22 14:00:00', 55.00),
('Pedido de Fevereiro 10', 0.00, 11, 1, 3, '2024-02-25 16:30:00', 50.00);

-- Março
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Março 1', 3.00, 12, 2, 1, '2024-03-02 14:00:00', 70.00),
('Pedido de Março 2', 4.00, 13, 3, 2, '2024-03-04 18:00:00', 60.00),
('Pedido de Março 3', 1.00, 14, 1, 1, '2024-03-06 19:00:00', 55.00),
('Pedido de Março 4', 2.50, 15, 2, 3, '2024-03-08 13:00:00', 80.00),
('Pedido de Março 5', 3.50, 1, 3, 1, '2024-03-10 14:30:00', 45.00),
('Pedido de Março 6', 0.00, 2, 1, 2, '2024-03-12 20:00:00', 90.00),
('Pedido de Março 7', 5.00, 3, 2, 1, '2024-03-15 17:30:00', 75.00),
('Pedido de Março 8', 1.50, 4, 3, 3, '2024-03-17 18:30:00', 50.00),
('Pedido de Março 9', 2.00, 5, 1, 2, '2024-03-20 13:30:00', 60.00),
('Pedido de Março 10', 4.00, 6, 2, 1, '2024-03-25 19:00:00', 70.00);

-- Abril
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Abril 1', 1.50, 7, 1, 1, '2024-04-02 12:00:00', 50.00),
('Pedido de Abril 2', 2.00, 8, 2, 2, '2024-04-04 13:30:00', 60.00),
('Pedido de Abril 3', 3.00, 9, 3, 1, '2024-04-06 15:00:00', 70.00),
('Pedido de Abril 4', 0.00, 10, 1, 2, '2024-04-08 14:00:00', 55.00),
('Pedido de Abril 5', 2.50, 11, 2, 3, '2024-04-10 17:00:00', 80.00),
('Pedido de Abril 6', 1.00, 12, 3, 1, '2024-04-12 19:30:00', 90.00),
('Pedido de Abril 7', 4.00, 13, 1, 2, '2024-04-14 12:30:00', 75.00),
('Pedido de Abril 8', 0.00, 14, 2, 3, '2024-04-16 13:00:00', 50.00),
('Pedido de Abril 9', 3.50, 15, 3, 1, '2024-04-18 16:00:00', 60.00),
('Pedido de Abril 10', 2.00, 1, 1, 2, '2024-04-20 14:30:00', 55.00);

-- Maio
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Maio 1', 0.00, 2, 3, 1, '2024-05-02 13:00:00', 70.00),
('Pedido de Maio 2', 3.00, 3, 1, 2, '2024-05-04 14:30:00', 80.00),
('Pedido de Maio 3', 2.00, 4, 2, 1, '2024-05-06 17:00:00', 50.00),
('Pedido de Maio 4', 1.50, 5, 3, 3, '2024-05-08 19:30:00', 60.00),
('Pedido de Maio 5', 4.00, 6, 1, 2, '2024-05-10 15:00:00', 75.00),
('Pedido de Maio 6', 0.00, 7, 2, 1, '2024-05-12 16:30:00', 85.00),
('Pedido de Maio 7', 3.50, 8, 3, 1, '2024-05-14 18:00:00', 95.00),
('Pedido de Maio 8', 1.00, 9, 1, 2, '2024-05-16 13:00:00', 50.00),
('Pedido de Maio 9', 5.00, 10, 2, 3, '2024-05-18 14:00:00', 70.00),
('Pedido de Maio 10', 0.00, 11, 1, 1, '2024-05-20 12:30:00', 60.00);

-- Junho
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Junho 1', 2.00, 12, 1, 2, '2024-06-01 14:00:00', 80.00),
('Pedido de Junho 2', 3.00, 13, 3, 1, '2024-06-03 15:00:00', 75.00),
('Pedido de Junho 3', 0.00, 14, 2, 2, '2024-06-05 17:30:00', 60.00),
('Pedido de Junho 4', 2.50, 15, 1, 3, '2024-06-07 14:30:00', 55.00),
('Pedido de Junho 5', 4.00, 1, 2, 1, '2024-06-09 18:00:00', 70.00),
('Pedido de Junho 6', 0.00, 2, 3, 2, '2024-06-11 16:00:00', 80.00),
('Pedido de Junho 7', 1.50, 3, 1, 1, '2024-06-13 14:30:00', 85.00),
('Pedido de Junho 8', 3.50, 4, 2, 3, '2024-06-15 19:00:00', 65.00),
('Pedido de Junho 9', 0.00, 5, 1, 1, '2024-06-17 12:00:00', 55.00),
('Pedido de Junho 10', 1.00, 6, 3, 2, '2024-06-19 13:00:00', 60.00);

-- Julho
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Julho 1', 1.50, 7, 1, 1, '2024-07-01 12:30:00', 60.00),
('Pedido de Julho 2', 3.00, 8, 2, 2, '2024-07-04 14:00:00', 70.00),
('Pedido de Julho 3', 2.00, 9, 3, 3, '2024-07-06 16:00:00', 55.00),
('Pedido de Julho 4', 4.00, 10, 1, 2, '2024-07-08 19:00:00', 85.00),
('Pedido de Julho 5', 0.00, 11, 2, 1, '2024-07-10 15:30:00', 65.00),
('Pedido de Julho 6', 1.00, 12, 3, 1, '2024-07-12 18:00:00', 60.00),
('Pedido de Julho 7', 5.00, 13, 1, 2, '2024-07-14 14:30:00', 80.00),
('Pedido de Julho 8', 2.50, 14, 2, 3, '2024-07-16 13:00:00', 75.00),
('Pedido de Julho 9', 3.00, 15, 1, 1, '2024-07-18 20:30:00', 50.00),
('Pedido de Julho 10', 4.50, 1, 3, 2, '2024-07-20 12:00:00', 90.00);

-- Agosto
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Agosto 1', 0.00, 2, 1, 1, '2024-08-01 14:00:00', 70.00),
('Pedido de Agosto 2', 3.00, 3, 2, 2, '2024-08-03 15:30:00', 75.00),
('Pedido de Agosto 3', 1.50, 4, 3, 1, '2024-08-05 18:00:00', 80.00),
('Pedido de Agosto 4', 4.00, 5, 1, 2, '2024-08-07 19:00:00', 85.00),
('Pedido de Agosto 5', 2.50, 6, 2, 1, '2024-08-09 13:30:00', 60.00),
('Pedido de Agosto 6', 0.00, 7, 3, 3, '2024-08-11 14:00:00', 90.00),
('Pedido de Agosto 7', 3.00, 8, 1, 2, '2024-08-13 17:30:00', 70.00),
('Pedido de Agosto 8', 1.00, 9, 2, 1, '2024-08-15 18:30:00', 65.00),
('Pedido de Agosto 9', 2.00, 10, 3, 3, '2024-08-17 20:00:00', 55.00),
('Pedido de Agosto 10', 0.00, 11, 1, 2, '2024-08-19 12:00:00', 75.00);

-- Setembro
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Setembro 1', 2.00, 12, 2, 1, '2024-09-01 13:00:00', 60.00),
('Pedido de Setembro 2', 3.50, 13, 1, 2, '2024-09-03 14:30:00', 75.00),
('Pedido de Setembro 3', 1.00, 14, 3, 1, '2024-09-05 15:00:00', 65.00),
('Pedido de Setembro 4', 4.00, 15, 1, 3, '2024-09-07 16:30:00', 90.00),
('Pedido de Setembro 5', 2.50, 1, 2, 1, '2024-09-09 13:30:00', 80.00),
('Pedido de Setembro 6', 1.50, 2, 3, 2, '2024-09-11 19:00:00', 55.00),
('Pedido de Setembro 7', 3.00, 3, 1, 1, '2024-09-13 14:00:00', 70.00),
('Pedido de Setembro 8', 0.00, 4, 2, 3, '2024-09-15 20:00:00', 75.00),
('Pedido de Setembro 9', 2.00, 5, 3, 1, '2024-09-17 18:30:00', 60.00),
('Pedido de Setembro 10', 3.50, 6, 1, 2, '2024-09-19 12:00:00', 80.00);

-- Outubro
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Outubro 1', 1.00, 7, 2, 3, '2024-10-01 12:30:00', 55.00),
('Pedido de Outubro 2', 3.00, 8, 3, 1, '2024-10-03 14:00:00', 70.00),
('Pedido de Outubro 3', 2.50, 9, 1, 2, '2024-10-05 16:30:00', 65.00),
('Pedido de Outubro 4', 4.00, 10, 2, 3, '2024-10-07 17:30:00', 80.00),
('Pedido de Outubro 5', 1.50, 11, 3, 1, '2024-10-09 18:00:00', 75.00),
('Pedido de Outubro 6', 2.00, 12, 1, 2, '2024-10-11 19:30:00', 85.00),
('Pedido de Outubro 7', 3.50, 13, 2, 3, '2024-10-13 14:30:00', 90.00),
('Pedido de Outubro 8', 0.00, 14, 3, 1, '2024-10-15 12:00:00', 55.00),
('Pedido de Outubro 9', 2.00, 15, 1, 2, '2024-10-17 13:00:00', 70.00),
('Pedido de Outubro 10', 1.00, 1, 2, 3, '2024-10-19 14:30:00', 60.00);

-- Novembro
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Novembro 1', 3.00, 2, 1, 1, '2024-11-01 12:00:00', 75.00),
('Pedido de Novembro 2', 0.00, 3, 2, 2, '2024-11-03 13:30:00', 60.00),
('Pedido de Novembro 3', 1.50, 4, 3, 1, '2024-11-05 14:30:00', 65.00),
('Pedido de Novembro 4', 4.00, 5, 1, 2, '2024-11-07 15:00:00', 85.00),
('Pedido de Novembro 5', 3.00, 6, 2, 3, '2024-11-09 16:00:00', 70.00),
('Pedido de Novembro 6', 1.00, 7, 3, 1, '2024-11-11 17:30:00', 55.00),
('Pedido de Novembro 7', 2.50, 8, 1, 2, '2024-11-13 18:00:00', 75.00),
('Pedido de Novembro 8', 0.00, 9, 2, 3, '2024-11-15 19:00:00', 60.00),
('Pedido de Novembro 9', 1.50, 10, 3, 1, '2024-11-17 14:00:00', 80.00),
('Pedido de Novembro 10', 4.00, 11, 1, 2, '2024-11-19 16:30:00', 70.00);

-- Dezembro
INSERT INTO pedido (observacao, troco, id_restaurante, id_formaDePagamento, id_status, dataPedido, total) VALUES
('Pedido de Dezembro 1', 0.00, 12, 3, 2, '2024-12-01 13:30:00', 80.00),
('Pedido de Dezembro 2', 2.00, 13, 1, 1, '2024-12-03 14:30:00', 75.00),
('Pedido de Dezembro 3', 1.00, 14, 2, 3, '2024-12-05 15:00:00', 70.00),
('Pedido de Dezembro 4', 3.50, 15, 1, 2, '2024-12-07 16:30:00', 90.00),
('Pedido de Dezembro 5', 4.00, 1, 3, 1, '2024-12-09 13:00:00', 60.00),
('Pedido de Dezembro 6', 2.00, 2, 1, 2, '2024-12-11 14:00:00', 65.00),
('Pedido de Dezembro 7', 1.50, 3, 2, 1, '2024-12-13 15:30:00', 75.00),
('Pedido de Dezembro 8', 3.00, 4, 3, 2, '2024-12-15 16:00:00', 80.00),
('Pedido de Dezembro 9', 0.00, 5, 1, 3, '2024-12-17 17:00:00', 85.00),
('Pedido de Dezembro 10', 2.50, 6, 2, 1, '2024-12-19 18:00:00', 70.00);

INSERT INTO promocao (id_produto, nome, descricao, codigo, data_inicio, data_fim) VALUES
(1, 'Desconto Lasagna', '10% de desconto na lasanha de carne com molho de tomate', 'LASAGNA10', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(2, 'Desconto Espetinho', '15% de desconto no espetinho de picanha no espeto', 'ESPETINHO15', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(3, 'Desconto Sushi de Salmão', '10% de desconto no sushi de salmão fresco', 'SUSHI10', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(4, 'Promoção Hambúrguer Gourmet', 'Hambúrguer gourmet com 20% de desconto', 'HAMBURGUER20', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(5, 'Desconto Sorvete de Chocolate', 'Desconto de R$ 5 no sorvete artesanal de chocolate', 'SORVETE05', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(6, 'Promoção Picanha no Espeto', 'Picanha no espeto com 10% de desconto', 'PICA10', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(7, 'Promoção Pizza de Mussarela', 'Pizza de mussarela com 15% de desconto', 'PIZZA15', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(8, 'Desconto Hambúrguer Vegano', '15% de desconto no hambúrguer vegano', 'VEGANO15', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(9, 'Promoção Tacos', 'Tacos com 10% de desconto', 'TACOS10', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(10, 'Desconto Falafel', 'Falafel com 10% de desconto', 'FALAFEL10', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(11, 'Promoção Cachorro Quente', 'Cachorro quente com 10% de desconto', 'CACHORRO10', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(12, 'Promoção Camarão Frito', 'Camarão frito com 15% de desconto', 'CAMARAO15', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(13, 'Desconto Pastel de Carne', 'Pastel de carne com 10% de desconto', 'PASTELCARNE10', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(14, 'Promoção Big Mac', 'Big Mac com 20% de desconto', 'BIGMAC20', '2024-12-10 00:00:00', '2024-12-20 23:59:59'),
(15, 'Desconto Pastel de Feijão', 'Pastel de feijão com 5% de desconto', 'PASTELFEIJAO05', '2024-12-10 00:00:00', '2024-12-20 23:59:59');


INSERT INTO acompanhamento (id_restaurante, nome, valor, descricao) VALUES
(1, 'Batata Frita', 5.00, 'Batatas fritas crocantes'), 
(2, 'Farofa', 3.00, 'Farofa caseira para acompanhar feijoada'),
(3, 'Refrigerante', 4.00, 'Refrigerante de cola gelado'),
(4, 'Molho de Soja', 2.00, 'Molho de soja para acompanhar sushi'),
(5, 'Vinagrete', 3.00, 'Vinagrete fresco para acompanhar churrasco'),
(6, 'Suco de Laranja', 6.00, 'Suco de laranja natural'),
(7, 'Bacon', 3.50, 'Bacon crocante para o hambúrguer'),
(8, 'Guacamole', 7.00, 'Guacamole fresca para tacos e burritos'),
(9, 'Sorvete', 5.00, 'Sorvete de chocolate cremoso'),
(10, 'Maionese', 2.50, 'Maionese caseira para hambúrgueres'),
(11, 'Molho de Alho', 2.00, 'Molho de alho para camarões'),
(12, 'Arroz', 4.00, 'Arroz branco para acompanhar prato internacional'),
(13, 'Café', 3.00, 'Café forte para acompanhar o almoço'),
(14, 'Granola', 2.00, 'Granola crocante para o açaí'),
(15, 'Molho Picante', 2.00, 'Molho picante para quem gosta de pimenta');

INSERT INTO produto_acompanhamento (id_produto, id_acompanhamento) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15);

INSERT INTO formaDePagamento (descricao) VALUES
('Cartão'), 
('Pix'), 
('Dinheiro');

INSERT INTO statusDaEntrega (descricao) VALUES
('Preparando'),
('A Caminho'),
('Entregue');

INSERT INTO produto_pedido (quantidade, id_pedido, id_produto) VALUES
(2, 1, 1), (3, 1, 2), (1, 2, 3), (2, 2, 4), (3, 3, 5),
(1, 3, 6), (2, 3, 7), (1, 4, 8), (2, 4, 9), (1, 5, 10),
(3, 5, 11), (2, 6, 12), (1, 6, 13), (3, 7, 14), (2, 7, 15);

INSERT INTO historicoDePagamento (id_pedido, dataDePagamento, valorPago) VALUES
(1, '2024-01-10 14:30:00', 50.00),
(2, '2024-02-10 15:00:00', 60.00),
(3, '2024-03-10 16:00:00', 75.00),
(4, '2024-04-10 17:30:00', 45.00),
(5, '2024-05-10 18:00:00', 80.00),
(6, '2024-06-10 19:00:00', 40.00),
(7, '2024-07-10 20:00:00', 55.00),
(8, '2024-08-10 21:00:00', 65.00),
(9, '2024-09-10 22:00:00', 50.00),
(10, '2024-10-10 23:00:00', 60.00),
(11, '2024-11-10 14:30:00', 70.00),
(12, '2024-12-10 15:00:00', 45.00),
(13, '2024-01-20 16:30:00', 50.00),
(14, '2024-02-20 17:00:00', 55.00),
(15, '2024-03-20 18:00:00', 65.00);

INSERT INTO historicoEntrega (id_pedido, id_status, dataEntrega) VALUES
(1, 1, '2024-01-10'), (2, 2, '2024-02-10'), (3, 3, '2024-03-10'),
(4, 1, '2024-04-10'), (5, 2, '2024-05-10'), (6, 3, '2024-06-10'),
(7, 1, '2024-07-10'), (8, 2, '2024-08-10'), (9, 3, '2024-09-10'),
(10, 1, '2024-10-10'), (11, 2, '2024-11-10'), (12, 3, '2024-12-10'),
(13, 1, '2024-01-20'), (14, 2, '2024-02-20'), (15, 3, '2024-03-20');

INSERT INTO restaurante_pagamento (id_restaurante, id_formaPagamento) VALUES
(1, 1), (2, 2), (3, 3), (4, 1), (5, 2),
(6, 3), (7, 1), (8, 2), (9, 3), (10, 1),
(11, 2), (12, 3), (13, 1), (14, 2), (15, 3);

INSERT INTO pedido_produto_acompanhamento (id_pedido_produto, id_acompanhamento) VALUES
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5),
(6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15);

INSERT INTO feedback (id_restaurante, comentario, dataComentario) VALUES
(1, 'Ótimo serviço e comida deliciosa!', '2024-01-15'),
(2, 'A feijoada estava excelente!', '2024-02-15'),
(3, 'Pizza maravilhosa, atendimento rápido.', '2024-03-15'),
(4, 'Sushi de ótima qualidade, voltarei mais vezes.', '2024-04-15'),
(5, 'Churrasco perfeito, carnes bem preparadas.', '2024-05-15'),
(6, 'A salada vegana estava incrível, saborosa e fresca.', '2024-06-15'),
(7, 'Hamburguer delicioso, recomendo!', '2024-07-15'),
(8, 'Taco muito bom, atendimento excelente.', '2024-08-15'),
(9, 'A torta de morango estava espetacular.', '2024-09-15'),
(10, 'O sanduíche de frango é o melhor!', '2024-10-15'),
(11, 'Os camarões estavam frescos e bem temperados.', '2024-11-15'),
(12, 'Prato internacional saboroso e bem servido.', '2024-12-15'),
(13, 'Buffet bem variado, uma ótima opção!', '2024-01-25'),
(14, 'O café expresso é perfeito para começar o dia.', '2024-02-25'),
(15, 'Açaí de excelente qualidade, muito bem servido.', '2024-03-25');






