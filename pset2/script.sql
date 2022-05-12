use uvv;



-- 1 COMANDO PARA SABER QUANTO É A MÉDIA SALARIAL DE CADA DEPARTAMENTO
select avg(funcionario.salario) as media_salario, departamento.nome_departamento 
from funcionario 
inner join departamento 
on departamento.numero_departamento = funcionario.numero_departamento 
group by departamento.nome_departamento;


-- 2 COMANDO PARA SABER A MÉDIA SALARIAL POR SEXO
select avg(funcionario.salario) as media_salario, funcionario.sexo
from funcionario
group by funcionario.sexo;

-- 3 COMANDO PARA TER O RELATORIO QUE LISTA O NOME DOS DEPARTAMENTOS E AS INFORMAÇÕES EM CADA 
select nome_departamento, concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo, data_nascimento,
floor(DATEDIFF(CURDATE(),data_nascimento)/365.25) as idade, 
salario
from funcionario inner join departamento 
where funcionario.numero_departamento = departamento.numero_departamento order by nome_departamento;

-- 4 COMANDO PARA VER UM RELATÓRIO QUE MOSTRA INFORMAÇÕES DOS FUNCIONARIOS E O SALÁRIO COM UM REAJUSTE
select concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo, floor(datediff(curdate(), data_nascimento)/365.25) as idade, 
salario, cast((salario*1.2) as decimal(10,2)) as salario_reajuste from funcionario 
where salario < 35000
union
select concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome, floor(datediff(curdate(), data_nascimento)/365.25) as idade, 
salario as salario, cast((salario*1.15) as decimal(10,2)) as salario_reajuste from funcionario 
where salario >= 35000;

-- 5 COMANDO PARA TER UM RELATÓRIO QUE LISTE PARA CADA DEPARTAMENTO O NOME DO GERENTE E DOS FUNCIONÁRIOS
select nome_departamento, a.primeiro_nome as gerente, funcionario.primeiro_nome, salario
from departamento inner join funcionario, 
(select primeiro_nome, cpf from funcionario inner join departamento where funcionario.cpf = departamento.cpf_gerente) as a
where departamento.numero_departamento = funcionario.numero_departamento and a.cpf = departamento.cpf_gerente 
order by departamento.nome_departamento asc, funcionario.salario desc;

-- 6 COMANDO PARA TER UM RELATÓRIO QUE MOSTRE O NOME COMPLETO DOS FUNCIONÁRIOS QUE TÊM DEPENDENTES
select concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo, departamento.nome_departamento,
dependente.nome_dependente, floor(datediff(curdate(), dependente.data_nascimento)/365.25) as idade_dependente,
case when dependente.sexo = 'M' then 'Masculino' when dependente.sexo = 'm' then 'Masculino'
when dependente.sexo = 'F' then 'Feminino' when dependente.sexo = 'f' then 'Feminino' end as sexo_dependente
from funcionario 
inner join departamento on funcionario.numero_departamento = departamento.numero_departamento 
inner join dependente ON dependente.cpf_funcionario = funcionario.cpf;

-- 7 COMANDO PARA TER UM RELATÓRIO QUE MOSTRE ALGUMAS INFORMAÇÕES PARA CADA FUNCIONÁRIO QUE NÃO TEM  DEPENDENTE
select distinct concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo, departamento.nome_departamento,
cast((funcionario.salario) as decimal(10,2)) as salario from funcionario
inner join departamento  inner join dependente 
where departamento.numero_departamento = funcionario.numero_departamento and
funcionario.cpf not in (select dependente.cpf_funcionario from dependente);


-- 8 COMANDO PARA TER UM RELATÓRIO QUE MOSTRE PARA CADA DEPARTAMENTO, OS PROJETOS DESSE DEPARTAMENTO E O NOME COMPLETO DOS FUNCIONARIOS
select departamento.nome_departamento, projeto.nome_projeto,
concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo, trabalha_em.horas
from funcionario inner join departamento inner join projeto inner join trabalha_em
where departamento.numero_departamento = funcionario.numero_departamento and
projeto.numero_projeto = trabalha_em.numero_projeto and funcionario.cpf = trabalha_em.cpf_funcionario order by projeto.numero_projeto;

-- 9 COMANDO PARA TER UM RELATÓRIO QUE MOSTRA A SOMA TOTAL DAS HORASD E CADA PROJETO EM CADA DEPARTAMENTO
select departamento.nome_departamento, projeto.nome_projeto, sum(trabalha_em.horas) as total_horas
from departamento inner join projeto inner join trabalha_em
where departamento.numero_departamento = projeto.numero_departamento AND projeto.numero_projeto = trabalha_em.numero_projeto group by projeto.nome_projeto;

-- 10 COMANDO PARA SABER QUANTO É A MÉDIA SALARIAL DE CADA DEPARTAMENTO (IGUAL A 1)
select avg(funcionario.salario) as media_salario, departamento.nome_departamento 
from funcionario 
inner join departamento 
on departamento.numero_departamento = funcionario.numero_departamento 
group by departamento.nome_departamento;


-- 11 COMANDO PARA SABER O VALOR PAGO POR HORA TRABALHADA EM UM PROJETO, CONTENDO O NOME COMPLETO DO FUNCIONÁRIO, NOME DO PROJETO E O VALOR TOTAL QUE O FUNCIONÁRIO RECEBERÁ
select concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo, projeto.nome_projeto,
cast((trabalha_em.horas*50) as decimal(10,2)) as salario_atualizado
from funcionario inner join projeto inner join trabalha_em 
where funcionario.cpf = trabalha_em.cpf_funcionario and projeto.numero_projeto = trabalha_em.numero_projeto group by funcionario.primeiro_nome;

-- 12 COMANDO PARA SABER QUEM ESTÁ COM NENHUMA HORA TRABALHADA
select departamento.nome_departamento, projeto.nome_projeto,
concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo, trabalha_em.horas
from funcionario inner join departamento inner join projeto inner join trabalha_em 
where funcionario.cpf = trabalha_em.cpf_funcionario and projeto.numero_projeto = trabalha_em.numero_projeto 
and (trabalha_em.horas = 0) group by funcionario.primeiro_nome;

-- 13 COMANDO PARA TER O RELATÓRIO QUE LISTASSE O NOME COMPLETO DAS PESSOAS A SEREM PRESENTEADAS, O SEXO E A IDADE EM ANOS COMPLETOS
select concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo,
case when sexo = 'M' then 'Masculino' when sexo = 'm' then 'Masculino'
when sexo = 'f' then 'Feminino' when sexo = 'f' then 'Feminino' end,
floor(datediff(curdate(), funcionario.data_nascimento)/365.25) as idade
from funcionario 
union
select dependente.nome_dependente,
case when sexo = 'M' then 'Masculino' when sexo = 'm' then 'Masculino'
when sexo = 'F' then 'Feminino' when sexo = 'f' then 'Feminino' end,
floor(datediff(curdate(), dependente.data_nascimento)/365.25) as idade
from dependente order by idade;

-- 14 COMANDO PARA SABER QUANTOS FUNCIONÁRIOS CADA DEPARTAMENTO TEM
select d.nome_departamento as departamento, count(f.numero_departamento) as numero_funcionario
from funcionario f inner join departamento d
where f.numero_departamento = d.numero_departamento group by d.nome_departamento;


-- 15 COMANDO PARA TER O RELATÓRIO QUE EXIBA O NOME COMPLETO DO FUNCIONÁRIO, O DEPARTAMENTO E O NOME DO PROJETO
select distinct concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo,
departamento.nome_departamento, 
projeto.nome_projeto
from departamento inner join projeto inner join trabalha_em inner join funcionario 
where departamento.numero_departamento = funcionario.numero_departamento and projeto.numero_projeto = trabalha_em.numero_projeto and
trabalha_em.cpf_funcionario = funcionario.cpf
union
select distinct concat(funcionario.primeiro_nome, ' ', funcionario.nome_meio, ' ', funcionario.ultimo_nome) as nome_completo,
departamento.nome_departamento, 
'Nenhum projeto' as projeto
from departamento inner join projeto inner join trabalha_em inner join funcionario 
where departamento.numero_departamento = funcionario.numero_departamento and projeto.numero_projeto = trabalha_em.numero_projeto and
(funcionario.cpf not in (select trabalha_em.cpf_funcionario from trabalha_em));
