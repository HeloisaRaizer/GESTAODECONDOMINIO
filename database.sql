
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

-- tabela pagamento

CREATE TABLE Pagamento (
    idpagamento INT AUTO_INCREMENT PRIMARY KEY,
    apartamento_id INT NOT NULL,
    cpf VARCHAR(14) NOT NULL,
    morador_id INT NOT NULL,
    telefone VARCHAR(20),
    mes_ano DATE NOT NULL,
    valor FLOAT NOT NULL,
    vencimento DATE NOT NULL,
    FOREIGN KEY (apartamento_id) REFERENCES Apartamento(idapartamento),
    FOREIGN KEY (morador_id) REFERENCES Morador(idmorador)
);

-- tabela manutençã
CREATE TABLE Manutencao (
    idmanutencao INT AUTO_INCREMENT PRIMARY KEY,
    tipoManutencao VARCHAR(100) NOT NULL,
    data DATE NOT NULL,
    local VARCHAR(255)
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


select * from bloco;

SELECT * FROM bloco where descricao = "Bloco A";




 SELECT a.idapartamento, a.numeroApt, b.descricao AS Bloco
  FROM Apartamento a
  JOIN Bloco b ON a.bloco_id = b.idbloco
  WHERE a.numeroApt = "101";
  
  SELECT  b.descricao, a.numeroApt FROM Apartamento a JOIN Bloco b ON a.bloco_id = b.idbloco;
  
SELECT  descricao FROM Bloco JOIN Bloco ON idbloco;


CREATE TABLE Apartamento (
    idapartamento INT AUTO_INCREMENT PRIMARY KEY,
    bloco_id INT NOT NULL,
    numeroApt VARCHAR(10) NOT NULL,
    FOREIGN KEY (bloco_id) REFERENCES Bloco(idbloco)
);
ALTER TABLE Apartamento
ADD CONSTRAINT unico_numero_por_bloco UNIQUE (bloco_id, numeroApt);