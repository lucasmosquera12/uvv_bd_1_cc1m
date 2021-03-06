/* logando no usuário postgres */
su - postgres
postgres

/* CRIAÇÃO DO USUÁRIO lucas */
createuser lucas -dPs
123456 -- senha do usuário lucas
123456 -- repetição da senha do usuário lucas
computacao@raiz -- senha administrativa

/* Entrando no terminal postgresql */

psql -U postgres -W
computacao@raiz -- senha do usuário lucas


/* CRIAÇÃO DO BANCO DE DADOS uvv */

create database uvv with
owner = 'lucas'
template = template0
encoding = 'UTF8'
lc_collate = 'pt_BR.UTF-8'
lc_ctype = 'pt_BR.UTF-8'
allow_connections = true;

/* ACESSANDO O BANCO DE DADOS uvv COM O USUÁRIO lucas */

\c uvv lucas;
123456 -- Senha do usuário

/* criando o esquema elmasri como usuário lucas */

create schema elmasri
authorization "lucas";

/* definindo o esquema "elmasri" como padrão */

alter user "lucas"
set search_path to elmasri, "\user", public;

/* Criando as tabelas */


CREATE TABLE elmasri.funcionario (
                cpf CHAR(11) NOT NULL,
                primeiro_nome VARCHAR(15) NOT NULL,
                nome_meio CHAR(1),
                ultimo_nome VARCHAR(15) NOT NULL,
                data_nascimento DATE,
                endereco VARCHAR(30),
                sexo CHAR(1),
                salario NUMERIC(10,2),
                cpf_supervisor CHAR(11) NOT NULL,
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT funcionario_pk PRIMARY KEY (cpf)
);
COMMENT ON TABLE elmasri.funcionario IS 'Tabela funcionário.';
COMMENT ON COLUMN elmasri.funcionario.cpf IS 'Cpf; Chave primária da tablea funcionária. Importante';
COMMENT ON COLUMN elmasri.funcionario.primeiro_nome IS 'Primeiro nome do funcionário
';
COMMENT ON COLUMN elmasri.funcionario.nome_meio IS 'Nome do meio do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.ultimo_nome IS 'Último nome do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.data_nascimento IS 'Data de nascimento do funcionário.
';
COMMENT ON COLUMN elmasri.funcionario.endereco IS 'Endereço do funcionário.
';
COMMENT ON COLUMN elmasri.funcionario.sexo IS 'Sexo do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.salario IS 'Salário do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.cpf_supervisor IS 'Cpf do supervisor do funcionário.';
COMMENT ON COLUMN elmasri.funcionario.numero_departamento IS 'Número do departamento do funcionário.';


CREATE TABLE elmasri.dependente (
                cpf_funcionario CHAR(11) NOT NULL,
                nome_dependente VARCHAR(15) NOT NULL,
                sexo CHAR(1),
                data_nascimento DATE,
                parentesco VARCHAR(15) NOT NULL,
                CONSTRAINT dependente_pk PRIMARY KEY (cpf_funcionario, nome_dependente)
);
COMMENT ON COLUMN elmasri.dependente.cpf_funcionario IS 'Cpf do funcionário do dependente.';
COMMENT ON COLUMN elmasri.dependente.nome_dependente IS 'Nome do dependente do funcionário.';
COMMENT ON COLUMN elmasri.dependente.sexo IS 'Sexo do dependente.';
COMMENT ON COLUMN elmasri.dependente.data_nascimento IS 'Data de nascimento do dependente.';
COMMENT ON COLUMN elmasri.dependente.parentesco IS 'Parentesco do dependente do funcionário.';


CREATE TABLE elmasri.departamento (
                numero_departamento INTEGER NOT NULL,
                nome_departamento VARCHAR(15) NOT NULL,
                cpf_gerente CHAR(11) NOT NULL,
                data_inicio_gerente DATE,
                CONSTRAINT departamento_pk PRIMARY KEY (numero_departamento)
);
COMMENT ON COLUMN elmasri.departamento.numero_departamento IS 'Número do departamento.';
COMMENT ON COLUMN elmasri.departamento.nome_departamento IS 'Nome do departamento.
';
COMMENT ON COLUMN elmasri.departamento.cpf_gerente IS 'Cpf do gerente do departamento.
';
COMMENT ON COLUMN elmasri.departamento.data_inicio_gerente IS 'Data do início do gerente do departamento.';


CREATE UNIQUE INDEX departamento_idx
 ON elmasri.departamento
 ( nome_departamento );

CREATE TABLE elmasri.localizacoes_departamento (
                local VARCHAR(15) NOT NULL,
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT localizacoes_departamento_pk PRIMARY KEY (local, numero_departamento)
);
COMMENT ON COLUMN elmasri.localizacoes_departamento.local IS 'Local do departamento.';
COMMENT ON COLUMN elmasri.localizacoes_departamento.numero_departamento IS 'Número do departamento.';


CREATE TABLE elmasri.projeto (
                numero_projeto INTEGER NOT NULL,
                nome_projeto VARCHAR(15) NOT NULL,
                local_projeto VARCHAR(15),
                numero_departamento INTEGER NOT NULL,
                CONSTRAINT projeto_pk PRIMARY KEY (numero_projeto)
);
COMMENT ON COLUMN elmasri.projeto.numero_projeto IS 'Número do projeto.';
COMMENT ON COLUMN elmasri.projeto.nome_projeto IS 'Nome do projeto.';
COMMENT ON COLUMN elmasri.projeto.local_projeto IS 'Local do projeto.';
COMMENT ON COLUMN elmasri.projeto.numero_departamento IS 'Número do departamento do projeto.';


CREATE UNIQUE INDEX projeto_idx
 ON elmasri.projeto
 ( nome_projeto );

CREATE TABLE elmasri.trabalha_em (
                cpf_funcionario CHAR(11) NOT NULL,
                numero_projeto INTEGER NOT NULL,
                horas NUMERIC(3,1) NOT NULL,
                CONSTRAINT trabalha_em_pk PRIMARY KEY (cpf_funcionario, numero_projeto)
);
COMMENT ON COLUMN elmasri.trabalha_em.cpf_funcionario IS 'Cpf do funcionário.';
COMMENT ON COLUMN elmasri.trabalha_em.numero_projeto IS 'Número do projeto.';
COMMENT ON COLUMN elmasri.trabalha_em.horas IS 'Horas do projeto.';


ALTER TABLE elmasri.departamento ADD CONSTRAINT funcionario_departamento_fk
FOREIGN KEY (cpf_gerente)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.funcionario ADD CONSTRAINT funcionario_funcionario_fk
FOREIGN KEY (cpf_supervisor)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT funcionario_trabalha_em_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.dependente ADD CONSTRAINT funcionario_dependente_fk
FOREIGN KEY (cpf_funcionario)
REFERENCES elmasri.funcionario (cpf)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.projeto ADD CONSTRAINT departamento_projeto_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.localizacoes_departamento ADD CONSTRAINT departamento_localizacoes_departamento_fk
FOREIGN KEY (numero_departamento)
REFERENCES elmasri.departamento (numero_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE elmasri.trabalha_em ADD CONSTRAINT projeto_trabalha_em_fk
FOREIGN KEY (numero_projeto)
REFERENCES elmasri.projeto (numero_projeto)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

INSERT INTO elmasri.funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES('12345678966', 'João', 'B', 'SIlva', '1965-01-09', 'Rua das Flores, 751', 'M', 30.00, '33344555587', 5);
INSERT INTO elmasri.funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES('33344555587', 'Fernando', 'T', 'Wong', '1955-08-12', 'RUa da Lapa, 34', 'M', 40.00, '88866555576', 5);
INSERT INTO elmasri.funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES('99988777767', 'Alice', 'J', 'Zelaya', '1968-01-19', 'Rua Souza Lima, 35', 'F', 25.00, '98765432168', 4);
INSERT INTO elmasri.funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES('98765432168', 'Jenifer', 'S', 'Souza', '1941-06-20', 'Av Arthur de Lima, 54', 'F', 43.00, '88866555576', 4);
INSERT INTO elmasri.funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES('66688444476', 'Ronaldo', 'K', 'Lima', '1962-09-15', 'Rua Rebouças, 65', 'M', 38.00, '33344555587', 5);
INSERT INTO elmasri.funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES('4534534576 ', 'Joice', 'A', 'Leite', '1972-07-31', 'Av Lucas Obes, 74', 'F', 25.00, '33344555587', 5);
INSERT INTO elmasri.funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES('98798798733', 'André', 'V', 'Pereira', '1969-03-29', 'Rua Timbira, 35', 'M', 25.00, '98765432168', 4);
INSERT INTO elmasri.funcionario
(cpf, primeiro_nome, nome_meio, ultimo_nome, data_nascimento, endereco, sexo, salario, cpf_supervisor, numero_departamento)
VALUES('88866555576', 'Jorge', 'E', 'Brito', '1937-11-10', 'Rua do Horto, 35', 'M', 55.00, NULL, 1);

INSERT INTO elmasri.dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('33344555587', 'Alicia', 'F', '1986-04-05', 'Filha');
INSERT INTO elmasri.dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('33344555587', 'Tiago', 'M', '1983-10-25', 'Filho');
INSERT INTO elmasri.dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('33344555587', 'Janaina', 'F', '1958-05-03', 'Esposa');
INSERT INTO elmasri.dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('98765432168', 'Antonio', 'M', '1942-02-28', 'Marido');
INSERT INTO elmasri.dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('12345678966', 'Michael', 'M', '1988-01-04', 'Filho');
INSERT INTO elmasri.dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('12345678966', 'Alicia', 'F', '1988-12-30', 'Filha');
INSERT INTO elmasri.dependente
(cpf_funcionario, nome_dependente, sexo, data_nascimento, parentesco)
VALUES('12345678966', 'Elizabeth', 'F', '1967-05-05', 'Esposa');


INSERT INTO elmasri.departamento
(numero_departamento, nome_departamento, cpf_gerente, data_inicio_gerente)
VALUES(5, 'Pesquisa', '33344555587', '1988-05-22');
INSERT INTO elmasri.departamento
(numero_departamento, nome_departamento, cpf_gerente, data_inicio_gerente)
VALUES(4, 'Administração', '98765432168', '1995-01-01');
INSERT INTO elmasri.departamento
(numero_departamento, nome_departamento, cpf_gerente, data_inicio_gerente)
VALUES(1, 'Matriz', '88866555576', '1981-06-19');


INSERT INTO elmasri.localizacoes_departamento
("local", numero_departamento)
VALUES('São Paulo', 1);
INSERT INTO elmasri.localizacoes_departamento
("local", numero_departamento)
VALUES('Mauá', 4);
INSERT INTO elmasri.localizacoes_departamento
("local", numero_departamento)
VALUES('Santo André', 5);
INSERT INTO elmasri.localizacoes_departamento
("local", numero_departamento)
VALUES('Itu', 5);
INSERT INTO elmasri.localizacoes_departamento
("local", numero_departamento)
VALUES('São Paulo', 5);


INSERT INTO elmasri.projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(1, 'ProdutoX', 'Santo André', 5);
INSERT INTO elmasri.projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(2, 'ProdutoY', 'Itu', 5);
INSERT INTO elmasri.projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(3, 'ProdutoZ', 'São Paulo', 5);
INSERT INTO elmasri.projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(10, 'Informatização', 'Mauá', 4);
INSERT INTO elmasri.projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(20, 'Reorganização', 'São Paulo', 1);
INSERT INTO elmasri.projeto
(numero_projeto, nome_projeto, local_projeto, numero_departamento)
VALUES(30, 'NovosBeneficios', 'Mauá', 4);


INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('12345678966', 1, 32.5);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('12345678966', 2, 7.5);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('66688444476', 3, 40.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('45345345376', 1, 20.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('45345345376', 2, 20.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('33344555587', 2, 10.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('33344555587', 3, 10.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('33344555587', 10, 10.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('33344555587', 20, 10.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('99988777767', 30, 30.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('99988777767', 10, 10.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('98798798733', 10, 35.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('98798798733', 30, 5.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('98765432168', 30, 20.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('98765432168', 20, 15.0);
INSERT INTO elmasri.trabalha_em
(cpf_funcionario, numero_projeto, horas)
VALUES('88866555576', 20, NULL);
