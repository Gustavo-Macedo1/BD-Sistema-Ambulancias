CREATE DATABASE GestaoAmbulancias;
/*Descomente se não tiver carregado o banco de dados*/

USE GestaoAmbulancias;

DROP TABLE IF EXISTS Rastreamento;
DROP TABLE IF EXISTS Equipe;
DROP TABLE IF EXISTS Atendimento;
DROP TABLE IF EXISTS Hospital;
DROP TABLE IF EXISTS Paciente;
DROP TABLE IF EXISTS Despacho;
DROP TABLE IF EXISTS Ambulancia;
DROP TABLE IF EXISTS Chamado;
DROP TABLE IF EXISTS TipoAmbulancia;
DROP TABLE IF EXISTS StatusAmbulancia;
DROP TABLE IF EXISTS Administrador;
DROP PROCEDURE IF EXISTS sp_EncerrarChamado;
DROP TRIGGER IF EXISTS trg_AtualizaStatusAposDespacho;

CREATE TABLE TipoAmbulancia (
    id_tipo INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(100),
    equipamentos_padrao TEXT
);

CREATE TABLE StatusAmbulancia (
    id_status INT AUTO_INCREMENT PRIMARY KEY,
    descricao VARCHAR(50) 
);

CREATE TABLE Administrador (
    id_admin INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    login VARCHAR(50) UNIQUE,
    senha VARCHAR(255) 
);

CREATE TABLE Hospital (
    id_hospital INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    endereco VARCHAR(200),
    telefone VARCHAR(20)
);

CREATE TABLE Paciente (
    id_paciente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cpf VARCHAR(14) UNIQUE,
    data_nascimento DATE,
    sexo CHAR(1) 
);

CREATE TABLE Ambulancia (
    id_ambulancia INT AUTO_INCREMENT PRIMARY KEY,
    placa VARCHAR(10),
    modelo VARCHAR(50),
    ano_fabricacao INT,
    foto LONGBLOB, 
    id_tipo INT,
    id_status INT,
    FOREIGN KEY (id_tipo) REFERENCES TipoAmbulancia(id_tipo),
    FOREIGN KEY (id_status) REFERENCES StatusAmbulancia(id_status)
);

CREATE TABLE Rastreamento (
    id_rastreio INT AUTO_INCREMENT PRIMARY KEY,
    latitude DECIMAL(10, 8),
    longitude DECIMAL(11, 8),
    data_hora_registro DATETIME,
    id_ambulancia INT,
    FOREIGN KEY (id_ambulancia) REFERENCES Ambulancia(id_ambulancia)
);

CREATE TABLE Chamado (
    id_chamado INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_abertura DATETIME,
    descricao_ocorrencia TEXT,
    endereco_ocorrencia VARCHAR(200),
    prioridade VARCHAR(20),
    status_chamado VARCHAR(20),
    id_admin INT, 
    FOREIGN KEY (id_admin) REFERENCES Administrador(id_admin)
);

CREATE TABLE Despacho (
    id_despacho INT AUTO_INCREMENT PRIMARY KEY,
    data_hora_saida DATETIME,
    data_hora_chegada DATETIME,
    id_chamado INT,
    id_ambulancia INT,
    FOREIGN KEY (id_chamado) REFERENCES Chamado(id_chamado),
    FOREIGN KEY (id_ambulancia) REFERENCES Ambulancia(id_ambulancia)
);

CREATE TABLE Equipe (
    id_equipe INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    cpf VARCHAR(14),
    cargo VARCHAR(50), 
    registro_profissional VARCHAR(20), 
    id_ambulancia INT,
    FOREIGN KEY (id_ambulancia) REFERENCES Ambulancia(id_ambulancia)
);

CREATE TABLE Atendimento (
    id_atendimento INT AUTO_INCREMENT PRIMARY KEY,
    relatorio_medico TEXT,
    procedimentos_realizados TEXT,
    id_despacho INT,
    id_paciente INT, 
    id_hospital INT,
    FOREIGN KEY (id_despacho) REFERENCES Despacho(id_despacho),
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_hospital) REFERENCES Hospital(id_hospital)
);

USE GestaoAmbulancias;

INSERT INTO TipoAmbulancia (descricao, equipamentos_padrao) VALUES
('Suporte Básico (USB)', 'Oxigênio, Maca, Tala, Colar Cervical'),
('Suporte Avançado (USA)', 'Respirador, Monitor Cardíaco, Desfibrilador'),
('Resgate Aéreo', 'Equipamento UTI, Maca de Resgate, Kit Trauma'),
('Motolância', 'Kit Primeiros Socorros, DEA, Oxigênio Portátil'),
('Transporte Simples', 'Maca Simples, Cadeira de Rodas');

INSERT INTO StatusAmbulancia (descricao) VALUES
('Disponível'),
('Em Atendimento'),
('Em Manutenção'),
('Em Limpeza/Desinfecção'),
('Fora de Serviço');

INSERT INTO Administrador (nome, login, senha) VALUES
('Carlos', 'admin.carlos', 'senha123hash'),
('Ana', 'admin.ana', 'senha456hash'),
('Roberto', 'admin.roberto', 'senha789hash'),
('Julia', 'admin.julia', 'senhaabchash'),
('Marcos', 'admin.marcos', 'senhaxyzhash');

INSERT INTO Hospital (nome, endereco, telefone) VALUES
('Hospital de Base', 'Asa Sul, Brasília', '(61) 3333-0001'),
('Hospital Regional da Asa Norte', 'Asa Norte, Brasília', '(61) 3333-0002'),
('Hospital Santa Lúcia', 'Asa Sul, Setor Hospitalar', '(61) 3333-0003'),
('Hospital Materno Infantil', 'Asa Sul, L2 Sul', '(61) 3333-0004'),
('UPA do Núcleo Bandeirante', 'Núcleo Bandeirante', '(61) 3333-0005');

INSERT INTO Paciente (nome, cpf, data_nascimento, sexo) VALUES
('João Pereira', '111.111.111-11', '1980-05-12', 'M'),
('Maria Fernandes', '222.222.222-22', '1995-08-23', 'F'),
('Pedro Henrique', '333.333.333-33', '2010-01-15', 'M'),
('Lucas Gabriel', '444.444.444-44', '1955-11-30', 'M'),
('Fernanda Lima', '555.555.555-55', '2000-03-10', 'F');


INSERT INTO Ambulancia (placa, modelo, ano_fabricacao, id_tipo, id_status) VALUES
('JKA-1234', 'Mercedes Sprinter', 2020, 2, 1), 
('PLB-5678', 'Renault Master', 2019, 1, 2),    
('XYZ-9012', 'Helicóptero Águia', 2018, 3, 1), 
('MOT-3456', 'Honda XRE 300', 2022, 4, 1),     
('ABC-1111', 'Fiat Ducato', 2021, 1, 1);       

INSERT INTO Rastreamento (latitude, longitude, data_hora_registro, id_ambulancia) VALUES
(-15.7942, -47.8822, '2023-11-20 08:00:00', 1),
(-15.7950, -47.8830, '2023-11-20 08:05:00', 1),
(-15.7801, -47.9292, '2023-11-20 09:00:00', 2),
(-15.8267, -47.9218, '2023-11-20 09:15:00', 3),
(-15.8000, -47.9000, '2023-11-20 10:00:00', 4);

INSERT INTO Chamado (data_hora_abertura, descricao_ocorrencia, endereco_ocorrencia, prioridade, status_chamado, id_admin) VALUES
('2023-11-20 08:30:00', 'Acidente de moto com vítima', 'Eixo Monumental', 'Alta', 'Encerrado', 1),
('2023-11-20 09:00:00', 'Paciente com dor no peito', 'SQS 105', 'Alta', 'Em Andamento', 2),
('2023-11-20 09:15:00', 'Queda de idoso', 'SQN 202', 'Média', 'Aberto', 1),
('2023-11-20 10:00:00', 'Transferência inter-hospitalar', 'Hospital de Base', 'Baixa', 'Aberto', 3),
('2023-11-20 10:30:00', 'Atropelamento', 'W3 Norte', 'Alta', 'Aberto', 2);

INSERT INTO Despacho (data_hora_saida, data_hora_chegada, id_chamado, id_ambulancia) VALUES
('2023-11-20 08:35:00', '2023-11-20 08:45:00', 1, 2), -- Amb 2 atendeu chamado 1
('2023-11-20 09:05:00', NULL, 2, 1),                 -- Amb 1 atendendo chamado 2
(NULL, NULL, 3, NULL),                               -- Chamado 3 ainda sem despacho
(NULL, NULL, 4, NULL),                               
(NULL, NULL, 5, NULL);                               

INSERT INTO Equipe (nome, cpf, cargo, registro_profissional, id_ambulancia) VALUES
('Roberto', '123.456.789-00', 'Médico', 'CRM-DF 1234', 1),
('Carla', '987.654.321-11', 'Enfermeira', 'COREN-DF 5678', 1),
('João', '111.222.333-44', 'Motorista', 'CNH-D', 1),
('Marcos', '555.666.777-88', 'Técnico Enfermagem', 'COREN-TEC 999', 2),
('Paulo', '444.333.222-11', 'Motorista', 'CNH-D', 2);

INSERT INTO Atendimento (relatorio_medico, procedimentos_realizados, id_despacho, id_paciente, id_hospital) VALUES
('Paciente com fratura exposta na perna direita.', 'Imobilização, Analgesia', 1, 1, 1), 
(NULL, NULL, 2, 2, NULL), -- Atendimento 2 ainda em curso (sem relatório)
(NULL, NULL, NULL, 3, NULL), -- Sem despacho ainda
(NULL, NULL, NULL, 4, NULL), 
(NULL, NULL, NULL, 5, NULL); 


/* View para saber quais ambulâncias estão ocupadas e em qual chamado*/

CREATE OR REPLACE VIEW vw_AmbulanciasEmUso AS
SELECT 
    a.placa AS Placa_Ambulancia,
    a.modelo AS Modelo,
    c.id_chamado AS Codigo_Chamado,
    c.endereco_ocorrencia AS Localizacao,
    c.prioridade AS Prioridade,
    d.data_hora_saida AS Horario_Saida
FROM Ambulancia a
JOIN Despacho d ON a.id_ambulancia = d.id_ambulancia
JOIN Chamado c ON d.id_chamado = c.id_chamado
WHERE c.status_chamado != 'Encerrado'; -- Mostra apenas chamados ativos

/* Mostrar qual Hospital recebeu qual paciente, trazido por
 qual tipo de ambulância e vindo de onde.*/
 
CREATE OR REPLACE VIEW vw_RelatorioTransporteHospital AS
SELECT 
    h.nome AS Hospital_Destino,
    t.descricao AS Tipo_Ambulancia,
    c.endereco_ocorrencia AS Local_Origem,
    c.data_hora_abertura AS Data_Ocorrencia,
    p.nome AS Nome_Paciente
FROM Atendimento atd
JOIN Hospital h ON atd.id_hospital = h.id_hospital
JOIN Despacho d ON atd.id_despacho = d.id_despacho
JOIN Ambulancia a ON d.id_ambulancia = a.id_ambulancia
JOIN TipoAmbulancia t ON a.id_tipo = t.id_tipo
JOIN Chamado c ON d.id_chamado = c.id_chamado
JOIN Paciente p ON atd.id_paciente = p.id_paciente;

/* Rastrear quais profissionais (Médicos, Motoristas, etc.)
-- foram despachados para quais ocorrências.
*/
CREATE OR REPLACE VIEW vw_HistoricoDespachoEquipe AS
SELECT 
    e.nome AS Nome_Profissional,
    e.cargo AS Cargo,
    e.registro_profissional AS Registro,
    a.placa AS Ambulancia_Utilizada,
    d.data_hora_saida AS Data_Despacho,
    c.endereco_ocorrencia AS Local_Ocorrencia,
    c.descricao_ocorrencia AS Motivo
FROM Equipe e
JOIN Ambulancia a ON e.id_ambulancia = a.id_ambulancia
JOIN Despacho d ON a.id_ambulancia = d.id_ambulancia
JOIN Chamado c ON d.id_chamado = c.id_chamado;

/* Fechar um chamado e liberar a ambulância automaticamente.*/

DELIMITER //
CREATE PROCEDURE sp_EncerrarChamado(IN p_id_chamado INT, IN p_relatorio TEXT)
BEGIN
    DECLARE v_id_ambulancia INT;
    DECLARE v_id_despacho INT;

    -- 1. Descobrir qual ambulância e qual despacho estão ligados a esse chamado
    SELECT d.id_ambulancia, d.id_despacho INTO v_id_ambulancia, v_id_despacho
    FROM Despacho d
    WHERE d.id_chamado = p_id_chamado
    LIMIT 1;

    -- 2. Atualizar o Chamado para Encerrado
    UPDATE Chamado 
    SET status_chamado = 'Encerrado' 
    WHERE id_chamado = p_id_chamado;

    -- 3. Atualizar o Status da Ambulância para Disponível (ID 1 = Disponível)
    UPDATE Ambulancia 
    SET id_status = 1 
    WHERE id_ambulancia = v_id_ambulancia;

    -- 4. Registrar um esboço de atendimento
    INSERT INTO Atendimento (relatorio_medico, id_despacho)
    VALUES (p_relatorio, v_id_despacho);

END //
DELIMITER ;

/* Quando criar um Despacho, mudar o status da ambulância
 para "Em Atendimento" automaticamente. */
DELIMITER //
CREATE TRIGGER trg_AtualizaStatusAposDespacho
AFTER INSERT ON Despacho
FOR EACH ROW
BEGIN
    -- Atualiza a ambulância despachada para o status 2 (Em Atendimento)
    UPDATE Ambulancia
    SET id_status = 2
    WHERE id_ambulancia = NEW.id_ambulancia;
END //
DELIMITER ;
