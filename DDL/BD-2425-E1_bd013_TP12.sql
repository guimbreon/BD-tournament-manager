-- BD 2024/25 - etapa E1 - bd013 

-- Duarte Soares fc62371 TP12(25%) | Diogo Almeida fc60064 TP12 (25%)

-- Guilherme Soares 62372 TP12(25%) | Vitoria Correia fc62211 TP12 (25%)

--DROP TABLES em ordem para que se possa rodar todos seguidos se necessario eliminar todas as tabelas

DROP TABLE IF EXISTS PapelPorRonda;
DROP TABLE IF EXISTS BilheteOnline;
DROP TABLE IF EXISTS BilhetePresencial;
DROP TABLE IF EXISTS Bilhete;
DROP TABLE IF EXISTS Espectador;
DROP TABLE IF EXISTS Zona;
DROP TABLE IF EXISTS Recinto;
DROP TABLE IF EXISTS PlataformaOnline;
DROP TABLE IF EXISTS Encontro;
DROP TABLE IF EXISTS Fase;
DROP TABLE IF EXISTS Jogo;
DROP TABLE IF EXISTS Edicao;
DROP TABLE IF EXISTS Torneio;
DROP TABLE IF EXISTS Ronda;
DROP TABLE IF EXISTS ArenaVirtual;
DROP TABLE IF EXISTS Treinador;
DROP TABLE IF EXISTS Jogador;
DROP TABLE IF EXISTS MembroEquipa;
DROP TABLE IF EXISTS Especialidade;
DROP TABLE IF EXISTS Equipa;

--CREATE TABLES

--Tabela para Equipa 
CREATE TABLE Equipa(
	nome VARCHAR(255) PRIMARY KEY,
	pais VARCHAR(100) NOT NULL
);


--Tabela para Membro de Equipa
CREATE TABLE MembroEquipa(
	nif_vat VARCHAR(15) NOT NULL PRIMARY KEY, --o maior VAT tem 15 caracteres -- IS-A "pai" de MembroEquipa
	num_passaporte VARCHAR(50) ,
	tipo VARCHAR(20) NOT NULL CHECK (tipo IN ('Treinador','Jogador')),
	nome VARCHAR(255) NOT NULL,
	data_nascimento DATE NOT NULL,
	pais_origem VARCHAR(100) NOT NULL,
	inicio_atividade DATE NOT NULL,
	equipa_nome VARCHAR(255), --FK para Equipa
	CONSTRAINT fk_membro_equipa FOREIGN KEY (equipa_nome) REFERENCES Equipa(nome)
);


-- Tabela para Especialidade
CREATE TABLE Especialidade (
	id INT PRIMARY KEY,
	papel VARCHAR(255) NOT NULL,
	pontuacao INT NOT NULL
);

--Tabela para Jogador
CREATE TABLE Jogador(
	nif_vat VARCHAR(15) NOT NULL PRIMARY KEY,-- Relacionamento IS-A "filho" de MembroEquipa
	nickname VARCHAR(50) NOT NULL
	CONSTRAINT fk_jogador FOREIGN KEY (nif_vat) REFERENCES MembroEquipa(nif_vat)
);




-- Tabela para Treinador

CREATE TABLE Treinador (
	nif_vat VARCHAR(15) NOT NULL PRIMARY KEY,-- Relacionamento IS-A "filho" de MembroEquipa
	estrategia TEXT,
	CONSTRAINT fk_treinador FOREIGN KEY (nif_vat) REFERENCES MembroEquipa(nif_vat)
);



-- Tabela para Arena Virtual

CREATE TABLE ArenaVirtual (
	codigo VARCHAR(50) PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
	tipo VARCHAR(25)
);

-- Tabela para Ronda
CREATE TABLE Ronda(
	numero_ordem INT PRIMARY KEY,
	pontuacao_primeira_equipa INT NOT NULL,
	pontuacao_segunda_equipa INT NOT NULL,
	arena_codigo VARCHAR(50), --FK para ArenaVirtual
	CONSTRAINT fk_encontro_arena FOREIGN KEY (arena_codigo) REFERENCES ArenaVirtual (codigo)
);


-- Tabela para Torneio
CREATE TABLE Torneio (
    codigo VARCHAR(50) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL
);

-- Tabela para Edicao
CREATE TABLE Edicao(
	ano_edicao INT PRIMARY KEY,
	periodo VARCHAR(100) NOT NULL,
	valor_total_premios DECIMAL(10,2) NOT NULL,
	max_equipas INT NOT NULL,
	torneio_codigo VARCHAR(50), --FK para Torneio
	CONSTRAINT fk_edicao_torneio FOREIGN KEY (torneio_codigo) REFERENCES Torneio(codigo),
);

-- Tabela para Jogo
CREATE TABLE Jogo (
    codigo VARCHAR(50) NOT NULL PRIMARY KEY,
    nome VARCHAR(255),
	tipo VARCHAR(100)
	
);

-- Tabela para Fase
CREATE TABLE Fase(
	id INT PRIMARY KEY,
	sigla VARCHAR(2) NOT NULL CHECK (sigla IN ('EP','OF','QF','SF')),
	data_inicio DATE NOT NULL,
	data_fim DATE NOT NULL,
    formato VARCHAR(50) NOT NULL,
	edicao_codigo INT ,
	jogo_codigo  VARCHAR(50),
	CONSTRAINT fk_fase_edicao FOREIGN KEY (edicao_codigo) REFERENCES Edicao(ano_edicao),
	CONSTRAINT fk_fase_jogo FOREIGN KEY (jogo_codigo) REFERENCES Jogo(codigo)

);


-- Tabela para Encontro
CREATE TABLE Encontro (
	num_sequencial INT PRIMARY KEY,
	data_hora DATETIME NOT NULL,
	formato VARCHAR(50) NOT NULL CHECK (formato IN ('M3','M5','M7')),
	ronda_codigo INT, --FK para Ronda
	codigo_fase INT,
	CONSTRAINT fk_ronda_encontro FOREIGN KEY(ronda_codigo) REFERENCES Ronda (numero_ordem),
	CONSTRAINT fk_encontro_fase FOREIGN KEY(codigo_fase) REFERENCES Fase(id)
);





-- Tabela para Plataforma Online
CREATE TABLE PlataformaOnline (
    url_plataforma VARCHAR(255) PRIMARY KEY,
    max_espectadores INT NOT NULL
);


-- Tabela para Recinto
CREATE TABLE Recinto (
    codigo VARCHAR(50) PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    localizacao VARCHAR(255) NOT NULL,
    tipo VARCHAR(50) NOT NULL,
    lotacao INT NOT NULL,
    horario_funcionamento VARCHAR(255) NOT NULL
);


-- Tabela para Zona (presencial)
CREATE TABLE Zona (
    fila VARCHAR(50) NOT NULL PRIMARY KEY,
    recinto_codigo VARCHAR(50), -- FK para Recinto
    CONSTRAINT fk_zona_recinto FOREIGN KEY (recinto_codigo) REFERENCES Recinto(codigo)
);

-- Tabela para Espectador
CREATE TABLE Espectador (
    email VARCHAR(255) NOT NULL PRIMARY KEY,
    nome VARCHAR(255) NOT NULL ,
    telefone VARCHAR(20),
    nif_vat VARCHAR(50),
    pais_origem VARCHAR(100),
    creditos DECIMAL(10, 2),
    recomendador_id VARCHAR(255) NULL, -- FK para outro Espectador
    CONSTRAINT fk_espectador_recomendador FOREIGN KEY (recomendador_id) REFERENCES Espectador(email)
);


-- Tabela para Bilhete
CREATE TABLE Bilhete (
	id INT PRIMARY KEY NOT NULL,-- Relacionamento IS-A "pai" de Bilhete
    nome_espectador VARCHAR(255) NOT NULL,
    preco DECIMAL(10, 2) NOT NULL,
    data_compra DATE NOT NULL,
    espectador_id VARCHAR(255) NOT NULL, -- FK para Espectador
	tipo VARCHAR(11) NOT NULL CHECK (tipo IN ('Online', 'Presencial')),  -- IS-A
    CONSTRAINT fk_bilhete_espectador FOREIGN KEY (espectador_id) REFERENCES Espectador(email)
);


-- Tabela para Bilhete Online 
CREATE TABLE BilheteOnline (
	id INT PRIMARY KEY,-- Relacionamento IS-A "filho" de Bilhete
    numero_sequencial INT,
    senha_acesso VARCHAR(255) NOT NULL,
    url_plataforma VARCHAR(255) NOT NULL, -- FK para PlataformaOnline
    CONSTRAINT fk_bilhete_online FOREIGN KEY (id) REFERENCES Bilhete(id),
    CONSTRAINT fk_bilhete_url FOREIGN KEY (url_plataforma) REFERENCES PlataformaOnline(url_plataforma)
);

-- Tabela para Bilhete Presencial
CREATE TABLE BilhetePresencial (
	id INT PRIMARY KEY NOT NULL,-- Relacionamento IS-A "filho" de Bilhete
	lugar VARCHAR(50) NOT NULL,
    fila VARCHAR(50) NOT NULL, -- FK para Zona
    CONSTRAINT fk_bilhete_presencial FOREIGN KEY (id) REFERENCES Bilhete(id),
    CONSTRAINT fk_bilhete_presencial_zona FOREIGN KEY (fila) REFERENCES Zona(fila)
);

-- Tabela para Papel Por Ronda:
-- Um jogador pode desempenhar multiplos papeis em edicoes diferentes, mas
-- tendo em conta cada encontro, ele so pode desempenhar um papel por ronda
CREATE TABLE PapelPorRonda (
    jogador_id VARCHAR(15),
    encontro_id INT,
    ronda_id INT,
    especialidade_id INT,
    PRIMARY KEY (jogador_id, encontro_id, ronda_id),
    CONSTRAINT fk_jogador_RIA1 FOREIGN KEY (jogador_id) REFERENCES Jogador(nif_vat),
    CONSTRAINT fk_encontro_RIA1 FOREIGN KEY (encontro_id) REFERENCES Encontro(num_sequencial),
    CONSTRAINT fk_ronda_RIA1 FOREIGN KEY (ronda_id) REFERENCES Ronda(numero_ordem),
	CONSTRAINT fk_papel_RIA1 FOREIGN KEY (especialidade_id) REFERENCES Especialidade(id),
    CONSTRAINT unico_papel_por_ronda UNIQUE (jogador_id, encontro_id, ronda_id)
);



--INSERT INTO TABLES
-- Equipas
INSERT INTO Equipa (nome, pais) 
VALUES
('Equipa A', 'Portugal'),
('Equipa B', 'Brasil');

-- Jogadores da Equipa A
INSERT INTO MembroEquipa (nif_vat, num_passaporte, tipo, nome, data_nascimento, pais_origem, inicio_atividade, equipa_nome)
VALUES
('123456789012345', 'A1234567', 'Jogador', 'Jogador A1', '1995-01-01', 'Portugal', '2015-01-01', 'Equipa A'),
('234567890123456', 'B1234567', 'Jogador', 'Jogador A2', '1996-02-02', 'Portugal', '2016-01-01', 'Equipa A'),
('345678901234567', 'C1234567', 'Jogador', 'Jogador A3', '1997-03-03', 'Portugal', '2017-01-01', 'Equipa A');

INSERT INTO Jogador(nickname, nif_vat)
VALUES
('joaozinhoGameplays','123456789012345'),
('Usmies','234567890123456'),
('Xublas','345678901234567');

-- Treinador da Equipa A
INSERT INTO MembroEquipa (nif_vat, num_passaporte, tipo, nome, data_nascimento, pais_origem, inicio_atividade, equipa_nome)
VALUES ('456789012345678', 'D1234567', 'Treinador', 'Treinador A', '1980-05-05', 'Portugal', '2010-01-01', 'Equipa A');

INSERT INTO Treinador (nif_vat, estrategia)
VALUES ('456789012345678','Ofensiva');

-- Jogadores da Equipa B
INSERT INTO MembroEquipa (nif_vat, num_passaporte, tipo, nome, data_nascimento, pais_origem, inicio_atividade, equipa_nome)
VALUES
('567890123456789', 'E1234567', 'Jogador', 'Jogador B1', '1998-06-06', 'Brasil', '2017-01-01', 'Equipa B'),
('678901234567890', 'F1234567', 'Jogador', 'Jogador B2', '1999-07-07', 'Brasil', '2018-01-01', 'Equipa B'),
('789012345678901', 'G1234567', 'Jogador', 'Jogador B3', '2000-08-08', 'Brasil', '2019-01-01', 'Equipa B');

INSERT INTO Jogador(nickname, nif_vat)
VALUES
('Ruehen','567890123456789'),
('Dibeul','678901234567890'),
('Gefufi','789012345678901');

-- Treinador da Equipa B
INSERT INTO MembroEquipa (nif_vat, num_passaporte, tipo, nome, data_nascimento, pais_origem, inicio_atividade, equipa_nome)
VALUES ('890123456789012', 'H1234567', 'Treinador', 'Treinador B', '1985-09-09', 'Brasil', '2012-01-01', 'Equipa B');

INSERT INTO Treinador (nif_vat, estrategia)
VALUES ('890123456789012','Defensiva');

--Especialidade
INSERT INTO Especialidade (id, papel, pontuacao) 
VALUES (1, 'Atacante', 10),
       (2, 'Meio-campo', 7),
       (3, 'Defensor', 5);


--ArenaVirtual
INSERT INTO ArenaVirtual (codigo, nome, tipo)
VALUES ('AR001', 'Arena Virtual A', 'Virtual');

--Ronda
INSERT INTO Ronda (numero_ordem, pontuacao_primeira_equipa, pontuacao_segunda_equipa, arena_codigo)
VALUES (1, 3, 2, 'AR001');
INSERT INTO Ronda (numero_ordem, pontuacao_primeira_equipa, pontuacao_segunda_equipa, arena_codigo)
VALUES (2, 33, 21, 'AR001');

-- Torneio
INSERT INTO Torneio (codigo, nome) VALUES
('T1', 'Mini Torneio 2024');

-- Inserir edicoes
INSERT INTO Edicao (ano_edicao, periodo, valor_total_premios, max_equipas, torneio_codigo) VALUES
(2024, '2024-11-20 a 2024-11-22', 5000.00, 2, 'T1');

--Jogo
INSERT INTO Jogo (codigo, nome, tipo) VALUES
('J1', 'Jogo 1', 'Competicao');

-- Fase
INSERT INTO Fase (id, sigla, data_inicio, data_fim, formato, edicao_codigo, jogo_codigo) VALUES
(1, 'OF', '2024-11-20', '2024-11-21', 'Eliminatoria', 2024, 'J1');


--Encontro
INSERT INTO Encontro (num_sequencial, data_hora, formato, ronda_codigo, codigo_fase) VALUES
(1, '2024-11-20 18:00:00', 'M3', 1, 1),
(2, '2024-11-21 18:00:00', 'M3', 2, 1);



-- PAPEL POR RONDA
-- Jogador A1
INSERT INTO PapelPorRonda (jogador_id, encontro_id, ronda_id, especialidade_id)
VALUES ('123456789012345', 1, 1, 1);

-- Jogador A2
INSERT INTO PapelPorRonda (jogador_id, encontro_id, ronda_id, especialidade_id)
VALUES ('234567890123456', 1, 1, 2);

-- Jogador A3
INSERT INTO PapelPorRonda (jogador_id, encontro_id, ronda_id, especialidade_id)
VALUES ('345678901234567', 1, 1, 3);

-- Jogador B1
INSERT INTO PapelPorRonda (jogador_id, encontro_id, ronda_id, especialidade_id)
VALUES ('567890123456789', 1, 1, 1);

-- Jogador B2
INSERT INTO PapelPorRonda (jogador_id, encontro_id, ronda_id, especialidade_id)
VALUES ('678901234567890', 1, 1, 2);

-- Jogador B3
INSERT INTO PapelPorRonda (jogador_id, encontro_id, ronda_id, especialidade_id)
VALUES ('789012345678901', 1, 1, 3);


-- PlataformaOnline
INSERT INTO PlataformaOnline (url_plataforma, max_espectadores)
VALUES ('https://plataforma.com', 5000);

-- Recinto
INSERT INTO Recinto (codigo, nome, localizacao, tipo, lotacao, horario_funcionamento)
VALUES ('RC001', 'Recinto A', 'Lisboa', 'Presencial', 200, '09:00-18:00');

-- Zona
INSERT INTO Zona (fila, recinto_codigo)
VALUES ('F1', 'RC001');

-- Espectadores presenciais
INSERT INTO Espectador (email, nome, telefone, nif_vat, pais_origem, creditos, recomendador_id)
VALUES ('espectador1@dominio.com', 'Espectador 1', '123456789', 'A123456789012', 'Portugal', 50.00, NULL);

-- Espectadores online
INSERT INTO Espectador (email, nome, telefone, nif_vat, pais_origem, creditos, recomendador_id)
VALUES ('espectador2@dominio.com', 'Espectador 2', '987654321', 'B987654321654', 'Brasil', 30.00, 'espectador1@dominio.com');

-- Bilhete presencial
INSERT INTO Bilhete (id, nome_espectador, preco, data_compra, espectador_id, tipo)
VALUES (1, 'Espectador 1', 20.00, '2024-11-20', 'espectador1@dominio.com', 'Presencial');

INSERT INTO BilhetePresencial (id, lugar, fila)
VALUES (1, '12B', 'F1')

-- Bilhete online
INSERT INTO Bilhete (id, nome_espectador, preco, data_compra, espectador_id, tipo)
VALUES (2, 'Espectador 2', 10.00, '2024-11-20', 'espectador2@dominio.com', 'Online');

INSERT INTO BilheteOnline(id, numero_sequencial, senha_acesso, url_plataforma)
VALUES(2, '1', 'XCKA12', 'https://plataforma.com')

