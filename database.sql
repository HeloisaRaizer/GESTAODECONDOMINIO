
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
    mes_ano DATE NOT NULL,
    valor FLOAT NOT NULL,
    vencimento DATE NOT NULL,
    FOREIGN KEY (apartamento_id) REFERENCES Apartamento(idapartamento),
    FOREIGN KEY (morador_id) REFERENCES Morador(idmorador)
);ALTER TABLE Pagamento
DROP COLUMN cpf,
DROP COLUMN telefone;

-- tabela manutenção
CREATE TABLE Manutencao (
    idmanutencao INT AUTO_INCREMENT PRIMARY KEY,
    tipoManutencao VARCHAR(100) NOT NULL,
    data DATE NOT NULL,
    local VARCHAR(255)
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

INSERT INTO Morador (cpf, nome, apt_id, bloco_id, telefone)
VALUES 
('123.456.789-00', 'João Silva', 3, 1, '(47) 99999-1111'),
('987.654.321-00', 'Maria Souza', 10, 2, '(47) 98888-2222'),
('456.789.123-00', 'Carlos Oliveira', 7, 1, '(47) 97777-3333');
-- ------------------

select * from bloco;
select * from Apartamento;
select * from morador;
select * from veiculo;
SELECT idmorador, cpf, nome, apt_id, telefone FROM Morador WHERE apt_id = 3;


DELETE FROM Apartamento where idapartamento = 9;

DELETE FROM pagamento;
DELETE FROM morador;

SELECT * FROM bloco where descricao = "Bloco A";




 SELECT a.idapartamento, a.numeroApt, b.descricao AS Bloco
  FROM Apartamento a
  JOIN Bloco b ON a.bloco_id = b.idbloco
  WHERE a.numeroApt = "101";
  
  SELECT  b.descricao, a.numeroApt FROM Apartamento a JOIN Bloco b ON a.bloco_id = b.idbloco;
  
SELECT  b.descricao FROM Apartamento a JOIN Bloco b ON a.bloco_id = b.idbloco;

SELECT Morador.idmorador AS id, Morador.cpf, Morador.nome, Apartamento.numeroApt AS apartamento, Bloco.descricao AS bloco FROM Morador JOIN Apartamento ON Morador.apt_id = Apartamento.idapartamento JOIN Bloco ON Morador.bloco_id = Bloco.idbloco ORDER BY bloco;



CREATE TABLE Apartamento (
    idapartamento INT AUTO_INCREMENT PRIMARY KEY,
    bloco_id INT NOT NULL,
    numeroApt VARCHAR(10) NOT NULL,
    FOREIGN KEY (bloco_id) REFERENCES Bloco(idbloco)
);
ALTER TABLE Apartamento
ADD CONSTRAINT unico_numero_por_bloco UNIQUE (bloco_id, numeroApt);