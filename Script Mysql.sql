/* LOGIN PELO USUÁRIO ROOT*/
mysql -u root -p
computacao@raiz

/* criando o usuário lucas */
CREATE USER 'lucas'@'localhost' IDENTIFIED BY '123456';

/* concedendo priivilegios ao meu usuário criado */
GRANT ALL PRIVILEGES ON . TO 'lucas'@'localhost' WITH GRANT OPTION;

/* criação do banco de dados uvv */
CREATE DATABASE uvv;

/* usar o banco de dados uvv */
USE uvv

CREATE TABLE funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(30),
                sexo CHAR(1),
                salario DECIMAL(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INT NOT NULL,
                PRIMARY KEY (cpf)
);


CREATE TABLE departamento (
                numero_departamento INT NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                PRIMARY KEY (numero_departamento)
);


CREATE UNIQUE INDEX departamento_idx
 ON departamento
 ( nome_departamento );

CREATE TABLE projeto (
                numero_projeto INT NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INT NOT NULL,
                PRIMARY KEY (numero_projeto)
);


CREATE UNIQUE INDEX projeto_idx
 ON projeto
 ( nome_projeto );

CREATE TABLE trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INT NOT NULL,
                horas DECIMAL(3,1) NOT NULL,
                PRIMARY KEY (cpf_funcionario, numero_projeto)
);


CREATE TABLE localizacoes_departamento (
                numero_departamento INT NOT NULL,
                local VARCHAR(15) NOT NULL,
                PRIMARY KEY (numero_departamento, local)
);


CREATE TABLE dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15),
                PRIMARY KEY (cpf_funcionario, nome_dependente)
);


ALTER TABLE dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

INSERT INTO funcionario VALUES
(88866555576, 'Jorge', 'E', 'Brito', '1937-11-10', 'Rua do Horto, 35, São Paulo, SP', 'M', 55000, 88866555576, 1),
(33344555587, 'Fernando', 'T', 'Wong', '1955-12-08', 'Rua da Lapa, 34, São Paulo, SP', 'M', 40000, 88866555576, 5),
(98765432168, 'Jennifer', 'S', 'Souza', '1941-06-20', 'Av. Arthur de Lima, 54, Santo André, SP', 'F', 43000, 88866555576, 4),
(12345678966, 'João', 'B', 'Silva', '1965-01-09', 'Rua das Flores, 751, São Paulo, SP', 'M', 30000, 33344555587, 5),
(66688444476, 'Ronaldo', 'K', 'Lima', '1962-09-15', 'Rua Rebouças, 65, Piracicaba, SP', 'M', 38000, 33344555587, 5),
(45345345376, 'Joice', 'A', 'Leite', '1972-07-31', 'Av. Lucas Obes, 74, São Paulo, SP', 'F', 25000, 33344555587, 5),
(99988777767, 'Alice', 'J', 'Zelaya', '1968-01-19', 'Rua Souza Lima, 35, Curitiba, PR', 'F', 25000, 98765432168, 4),
(98798798733, 'André', 'V', 'Pereira', '1969-03-29', 'Rua Timbira, 35, São Paulo, SP', 'M', 25000, 98765432168, 4);


insert into departamento VALUES
(1, 'Matriz', 88866555576, '1981-06-19'),
(5, 'Pesqusia', 33344555587, '1988-05-22'),
(4, 'Administração', 98765432168, '1995-01-01');


INSERT INTO localizacoes_departamento VALUES
(1, 'São Paulo'),
(4, 'Mauá'),
(5, 'Santo André'),
(5, 'Itu'),
(5, 'São Paulo');

INSERT INTO projeto VALUES
(1, 'ProdutoX', 'Santo André', 5),
(2, 'ProdutoY', 'Itu', 5),
(3, 'ProdutoZ', 'São Paulo', 5),
(10, 'Informatização', 'Mauá', 4),
(20, 'Reorganiazãço', 'São Paulo', 1),
(30, 'Novosbenefícios', 'Mauá', 4);


INSERT INTO dependente VALUES
(33344555587, 'Alicia', 'F', '1986-04-05', 'Filha'),
(33344555587, 'Tiago', 'M', '1983-10-25', 'Filho'),
(33344555587, 'Janaína', 'F', '1958-05-03', 'Esposa'),
(98765432168, 'Antonio', 'M', '1942-02-28', 'Marido'),
(12345678966, 'Michael', 'M', '1988-01-04', 'Filho'),
(12345678966, 'Alicia', 'F', '1988-12-30', 'Filha'),
(12345678966, 'Elizabeth', 'F', '1967-05-05', 'Esposa');


INSERT INTO trabalha_em VALUES
(12345678966, 1, 32.5),
(12345678966, 2, 7.5),
(66688444476, 3, 40),
(45345345376, 1, 20),
(45345345376, 2, 20),
(33344555587, 2, 10),
(33344555587, 3, 10),
(33344555587, 10, 10),
(33344555587, 20, 10),
(99988777767, 30, 30),
(99988777767, 10, 10),
(98798798733, 10, 35),
(98798798733, 30, 5),
(98765432168, 30, 20),
(98765432168, 20, 15),
(88866555576, 20, 0);

ALTER TABLE uvv.funcionario COMMENT='tabela funcionário';
ALTER TABLE funcionario MODIFY COLUMN cpf CHAR(11) COMMENT ' coluna do cpf do funcionário';
ALTER TABLE funcionario MODIFY COLUMN primeiro_nome VARCHAR(15) COMMENT ' coluna do primeiro nome do funcionário';
ALTER TABLE funcionario MODIFY COLUMN nome_meio CHAR(1) COMMENT ' coluna do nome do meio do funcionário';
ALTER TABLE funcionario MODIFY COLUMN ultimo_nome VARCHAR(15) COMMENT ' coluna do último nome do funcionário';
ALTER TABLE funcionario MODIFY COLUMN data_nascimento DATE COMMENT ' coluna da data de nascimento do funcionário';
ALTER TABLE funcionario MODIFY COLUMN endereco VARCHAR(90) COMMENT ' coluna do endereço do funcionário';
ALTER TABLE funcionario MODIFY COLUMN sexo CHAR(1) COMMENT ' coluna do sexo do funcionário';
ALTER TABLE funcionario MODIFY COLUMN salario DECIMAL(10,2) COMMENT ' coluna do salário do funcionário';
ALTER TABLE funcionario MODIFY COLUMN cpf_supervisor CHAR(11) COMMENT ' coluna do cpf do supervisor';
ALTER TABLE funcionario MODIFY COLUMN numero_departamento INT COMMENT ' coluna do número do departamento';


ALTER TABLE uvv.departamento COMMENT='Essa é a tabela departamento';
ALTER TABLE departamento MODIFY COLUMN numero_departamento INT COMMENT ' coluna do número do departamento';
ALTER TABLE departamento MODIFY COLUMN nome_departamento VARCHAR(15) COMMENT 'coluna do nome do departamento';
ALTER TABLE departamento MODIFY COLUMN cpf_gerente CHAR(11) COMMENT 'coluna do cpf do gerente';
ALTER TABLE departamento MODIFY COLUMN data_inicio_gerente DATE COMMENT 'coluna da data de inicio do gerente';


ALTER TABLE uvv.projeto COMMENT='tabela projeto.';
ALTER TABLE projeto MODIFY COLUMN numero_projeto INT COMMENT ' coluna do número do projeto';
ALTER TABLE projeto MODIFY COLUMN nome_projeto VARCHAR(15) COMMENT ' coluna do nome do projeto';
ALTER TABLE projeto MODIFY COLUMN local_projeto VARCHAR(15) COMMENT ' coluna do local do projeto';
ALTER TABLE projeto MODIFY COLUMN numero_departamento INT COMMENT ' coluna do número do departamento';


ALTER TABLE uvv.trabalha_em COMMENT=' tabela que indica onde o funcionário trabalha';
ALTER TABLE trabalha_em MODIFY COLUMN cpf_funcionario CHAR(11) COMMENT 'coluna do cpf do funcionário';
ALTER TABLE trabalha_em MODIFY COLUMN numero_projeto INT COMMENT ' coluna do número do projeto';
ALTER TABLE trabalha_em MODIFY COLUMN horas DECIMAL(3,1) COMMENT ' coluna do total de horas que o funcionário trabalha';


ALTER TABLE uvv.localizacoes_departamento COMMENT=' tabela que indica a localização do departamento';
ALTER TABLE localizacoes_departamento MODIFY COLUMN numero_departamento INT COMMENT ' coluna do número do departamento';
ALTER TABLE localizacoes_departamento MODIFY COLUMN local VARCHAR(15) COMMENT ' coluna do local do departamento';


ALTER TABLE uvv.dependente COMMENT=' tabela que indica o dependente do funcionário';
ALTER TABLE dependente MODIFY COLUMN cpf_funcionario CHAR(11) COMMENT ' coluna do cpf do funcionário';
ALTER TABLE dependente MODIFY COLUMN nome_dependente VARCHAR(15) COMMENT ' coluna do nome do dependente';
ALTER TABLE dependente MODIFY COLUMN sexo CHAR(1) COMMENT ' coluna do sexo do dependente';
ALTER TABLE dependente MODIFY COLUMN data_nascimento DATE COMMENT ' coluna da data de nascimento do dependente';
ALTER TABLE dependente MODIFY COLUMN parentesco VARCHAR(15) COMMENT ' coluna do parentesco entre dependente e funcionário';
