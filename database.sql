
-- Criação da tabela Bloco
CREATE TABLE Bloco (
    idbloco INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100) UNIQUE NOT NULL,
    qtdApt INT DEFAULT 0
);


-- Criação da tabela Apartamento
CREATE TABLE Apartamento (
    idapartamento INT AUTO_INCREMENT PRIMARY KEY,
    bloco_id INT NOT NULL,
    numeroApt VARCHAR(10) NOT NULL,
    FOREIGN KEY (bloco_id) REFERENCES Bloco(idbloco)
);
ALTER TABLE Apartamento
ADD CONSTRAINT unico_numero_por_bloco UNIQUE (bloco_id, numeroApt);

-- tabela morador
CREATE TABLE Morador (
    idmorador INT AUTO_INCREMENT PRIMARY KEY,
    cpf VARCHAR(14) NOT NULL,
    nome VARCHAR(100) NOT NULL,
    apt_id INT NOT NULL,
    bloco_id INT NOT NULL,
    telefone VARCHAR(20),
    FOREIGN KEY (apt_id) REFERENCES Apartamento(idapartamento),
    FOREIGN KEY (bloco_id) REFERENCES Bloco(idbloco)
);
ALTER TABLE Morador
ADD responsavel_apt TINYINT(1) NOT NULL DEFAULT 2, -- 1 = true, 2 = false
ADD proprietario_apt TINYINT(1) NOT NULL DEFAULT 2,
ADD possui_veiculo TINYINT(1) NOT NULL DEFAULT 2,
ADD qtd_vagas INT DEFAULT NULL,
ADD num_vaga INT DEFAULT NULL;
ALTER TABLE morador
ADD CONSTRAINT unique_cpf UNIQUE (cpf);
ALTER TABLE Morador
ADD CONSTRAINT unico_proprietario_por_apt UNIQUE (apt_id, proprietario_apt);


-- tabela pagamento

CREATE TABLE Pagamento (
    idpagamento INT AUTO_INCREMENT PRIMARY KEY,
    apartamento_id INT NOT NULL,
    morador_id INT NOT NULL,
    FOREIGN KEY (apartamento_id) REFERENCES Apartamento(idapartamento),
    FOREIGN KEY (morador_id) REFERENCES Morador(idmorador)
);ALTER TABLE Pagamento
ADD COLUMN referencia_id INT NOT NULL,
ADD CONSTRAINT fk_referencia
FOREIGN KEY (referencia_id) REFERENCES Referencia(idreferencia);
-- tabela manutenção
CREATE TABLE Manutencao (
    idmanutencao INT AUTO_INCREMENT PRIMARY KEY,
    tipoManutencao VARCHAR(100) NOT NULL,
	tipo_id INT NOT NULL,
    data DATE NOT NULL,
    local VARCHAR(255)
);ALTER TABLE manutencao
ADD COLUMN tipo_id INT NOT NULL,
ADD CONSTRAINT fk_tipoManitencao
FOREIGN KEY (tipo_id) REFERENCES tipoManutencao(idtipo);

ALTER TABLE manutencao
MODIFY COLUMN data VARCHAR(10);

ALTER TABLE manutencao
DROP COLUMN tipoManutencao;



CREATE TABLE tipoManutencao (
idtipo INT AUTO_INCREMENT PRIMARY KEY,
nome varchar(255)
);

-- tabela veiculo
CREATE TABLE Veiculo (
    idveiculo INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10) NOT NULL,
    marca VARCHAR(50),
    modelo VARCHAR(50),
    morador_id INT NOT NULL,
    FOREIGN KEY (morador_id) REFERENCES Morador(idmorador)
);

-- tabela referencia
CREATE TABLE Referencia (
    idreferencia INT AUTO_INCREMENT PRIMARY KEY,
    mes INT NOT NULL,            
    ano INT NOT NULL,            
    vencimento DATE NOT NULL,    
    valor DECIMAL(10,2) NOT NULL 
);


-- trigger 
DELIMITER //

CREATE TRIGGER trg_atualiza_qtdApt_after_insert
AFTER INSERT ON Apartamento
FOR EACH ROW
BEGIN
    UPDATE Bloco
    SET qtdApt = (
        SELECT COUNT(*) FROM Apartamento WHERE bloco_id = NEW.bloco_id
    )
    WHERE idbloco = NEW.bloco_id;
END //

DELIMITER ;


DELIMITER //

CREATE TRIGGER trg_atualiza_qtdApt_after_delete
AFTER DELETE ON Apartamento
FOR EACH ROW
BEGIN
    UPDATE Bloco
    SET qtdApt = (
        SELECT COUNT(*) FROM Apartamento WHERE bloco_id = OLD.bloco_id
    )
    WHERE idbloco = OLD.bloco_id;
END //

DELIMITER ;


-- inserindo teste

insert into Apartamento(bloco_id, numeroApt) values (1, "101");
insert into Apartamento(bloco_id, numeroApt) values (2, "101");
insert into Apartamento(bloco_id, numeroApt) values (1, "102");

insert into tipomanutencao(nome) value ("Pintura");

INSERT INTO Morador (cpf, nome, apt_id, bloco_id, telefone)
VALUES 
('123.456.789-00', 'João Silva', 3, 1, '(47) 99999-1111'),
('987.654.321-00', 'Maria Souza', 10, 2, '(47) 98888-2222'),
('456.789.123-00', 'Carlos Oliveira', 7, 1, '(47) 97777-3333');

INSERT INTO Referencia (mes, ano, vencimento, valor) VALUES
(1, 2025, '2025-02-10', 550.00),
(2, 2025, '2025-03-10', 550.00),
(3, 2025, '2025-04-10', 550.00),
(4, 2025, '2025-05-10', 550.00),
(5, 2025, '2025-06-10', 550.00),
(6, 2025, '2025-07-10', 550.00),
(7, 2025, '2025-08-10', 550.00),
(8, 2025, '2025-09-10', 550.00),
(9, 2025, '2025-10-10', 550.00),
(10, 2025, '2025-11-10', 550.00),
(11, 2025, '2025-12-10', 550.00),
(12, 2025, '2026-01-10', 550.00);
-- ------------------

-- select
select * from bloco;
select * from Apartamento;
select * from morador;
select * from veiculo;
select * from referencia;
select * from pagamento;
select * from manutencao;
select * from tipoManutencao;
SELECT idmorador, cpf, nome, apt_id, telefone FROM Morador WHERE apt_id = 3;
SELECT * FROM bloco where descricao = "Bloco A";
SELECT * FROM referencia WHERE mes = 5 AND ano = 2025;

SELECT COUNT(idmorador) FROM morador;
SELECT COUNT(idapartamento) FROM apartamento;
SELECT COUNT(idbloco) FROM bloco;
SELECT COUNT(idmanutencao) FROM manutencao;

SELECT idmorador, bloco_id FROM morador;



-- delete
DELETE FROM Apartamento where idapartamento = 9;

DELETE FROM pagamento;
DELETE FROM morador;
DELETE FROM manutencao;



-- JOIN

 SELECT a.idapartamento, a.numeroApt, b.descricao AS Bloco
  FROM Apartamento a
  JOIN Bloco b ON a.bloco_id = b.idbloco
  WHERE a.numeroApt = "101";
  
  SELECT  b.descricao, a.numeroApt FROM Apartamento a JOIN Bloco b ON a.bloco_id = b.idbloco;
  
SELECT  b.descricao FROM Apartamento a JOIN Bloco b ON a.bloco_id = b.idbloco;

SELECT Morador.idmorador AS id, Morador.cpf, Morador.nome, Apartamento.numeroApt AS apartamento, Bloco.descricao AS bloco FROM Morador JOIN Apartamento ON Morador.apt_id = Apartamento.idapartamento JOIN Bloco ON Morador.bloco_id = Bloco.idbloco ORDER BY bloco;


SELECT m.idmanutencao,tm.nome AS tipoManutencaoNome, tm.idtipo FROM Manutencao m JOIN TipoManutencao tm ON m.tipo_id = tm.idtipo;
SELECT m.idmorador, b.descricao AS nome_bloco
FROM morador m
JOIN bloco b ON m.bloco_id = b.idbloco;


