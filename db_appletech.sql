create database appletech;

use appletech;

create table empresa (
id		int primary key auto_increment,
nome	varchar(50) not null,
cnpj	char(14) not null unique,
cep		char(08) not null
);
insert into empresa(nome, cnpj, cep)
values('Carrefour', '12345678000101', '01310100'),
('Extra ', '98765432000111', '20040002'),
('Walmart Brasil', '11222333000122', '30140010'),
('Pão de Açúcar Hiper', '44555666000133', '80020010'),
('Hipermercado Big', '77888999000144', '70040020');

-- //////////////////////////////////////////////////////////////

create table cliente (
	id				int primary key auto_increment,
    nome			varchar(60) not null,
    email			varchar(64) not null unique,
    telefone		char(11) not null unique,
    id_empresa	int not null,
    data_cadastro	datetime default current_timestamp,
    situacao		varchar(10) not null default 'Ativo',
    constraint ck_cliente check(situacao in ('Ativo', 'Inativo'))
);
insert into cliente (nome, email, telefone, id_empresa) 
values
('Carlos Alberto Silva', 'carlos.silva@email.com', '11988887777', 1),
('Mariana Souza Oliveira', 'mariana.souza@provedor.net', '21977776666', 2),
('Ricardo Pereira Santos', 'ricardo.santos@tech.com.br', '31966665555', 3);

-- //////////////////////////////////////////////////////////////

create table usuario (
id	int primary key auto_increment,
id_cliente	int not null,
nome	varchar(60) not null,
email	varchar(60) not null unique,
senha	varchar(25) not null,
tipo	varchar(10) not null,
constraint ck_usuario check(tipo in ('Admin','Tecnico', 'Visitante'))
);

insert into  usuario (id_cliente, nome, email, senha, tipo)
values (1, 'Carlos Silva', 'admin.carlos@empresa.com', 'SenhaForte@2024', 'Admin'),
(2, 'Mariana', 'tecnico.mariana@servico.com', 'Suporte#123', 'Tecnico'),
(2, 'Ricardo', 'visitante.ricardo@gmail.com', 'Visita@321', 'Visitante'),
(3, 'Fernanda Lima', 'fernanda.admin@hiper.com.br', 'Fernanda@8899', 'Admin'),
(3, 'Juliana', 'juliana.mendes@suporte.com', 'Mendes_Tech!', 'Tecnico');

-- //////////////////////////////////////////////////////////////

create table sensor (
id		int primary key auto_increment,
id_cliente	int not null,
modelo	varchar(60) not null,
num_serie	varchar(60) not null unique,
local_instalacao	varchar(60) not null,
data_instalacao		datetime not null,
situacao	varchar(10) not null default 'Ativo'
constraint ck_sensor check(situacao in ('Ativo', 'Inativo'))
);
insert into sensor (id_cliente, modelo, num_serie, local_instalacao, data_instalacao, situacao)
values(1, 'F-900 Ethylene Analyzer', 'SN-2024-TG01', 'Armazem 1', '2024-01-15 08:30:00', 'Ativo'),
(1, 'F-900 Ethylene Analyzer', 'SN-2024-FO02', 'Armazem 1', '2024-02-10 10:00:00', 'Intivo'),
(2, 'Vaisala CARBOCAP®', 'SN-2024-UM03', 'Armazem 2', '2024-03-05 14:20:00', 'Ativo'),
(2, 'F-900 Ethylene Analyzer', 'SN-2024-TG04', 'Armazem 3', '2024-03-12 09:15:00', 'Inativo'),
(3, 'Senseair K30', 'SN-2024-SC05', 'Armazem 4', '2024-04-01 16:45:00', 'Ativo');

create index ix_sensor on sensor(num_serie, local_instalacao);

-- //////////////////////////////////////////////////////////////

create table leitor (
id	int primary key auto_increment,
id_sensor int not null,
ppb	int,
data_hora datetime default current_timestamp
);
insert into leitor (id_sensor, ppb, data_hora) 
values (1, 9, '2024-05-10 10:00:00'),
(2, 9, '2024-05-10 10:01:00'),
(4, null, '2024-05-10 10:02:00'),
(3, 90, '2024-05-10 10:03:00'), 
(1, 8, '2024-05-10 10:05:00'),
(2, 11, '2024-05-10 10:06:00'),
(4, null, '2024-05-10 10:07:00'),
(3, 110, '2024-05-10 10:08:00'),
(1, 7, '2024-05-10 10:10:00'),
(2, 13, '2024-05-10 10:11:00'),
(4, null, '2024-05-10 10:12:00'),
(3, 115, '2024-05-10 10:13:00'), 
(1, 6, '2024-05-10 10:15:00'),
(2, 11, '2024-05-10 10:16:00'),
(4, null, '2024-05-10 10:17:00'),
(3, 97, '2024-05-10 10:18:00'),
(1, 7, '2024-05-10 10:20:00'),
(2, 9, '2024-05-10 10:21:00'),
(4, null, '2024-05-10 10:22:00'),
(3, 101, '2024-05-10 10:23:00'), 
(1, 9, '2024-05-10 10:25:00'),
(2, 10, '2024-05-10 10:26:00'),
(4, null, '2024-05-10 10:27:00'),
(3, 108, '2024-05-10 10:28:00'); 

create index ix_leitor on leitor(valor, data_hora);

-- //////////////////////////////////////////////////////////////

select* from empresa;
select nome, cnpj, cep from empresa
where nome = 'Walmart Brasil';

select *from cliente;
select nome, email, telefone from cliente 
where id_empresa = 1 ;

select*from usuario;
select id, nome, tipo,
concat(id_cliente, ' - ', nome, '(',tipo, ')') as 'estado do usuario' 
from usuario
where id_cliente between 2 and 3;

select*from leitor;
select id_sensor, data_hora, ppb,
case
	when ppb <= 10 then "Ideal "
	when ppb <= 100 then "Bom "
    when ppb is null then "Falha"
	else "Arriscado "
end as 'Nivel de Etileno'
from leitor
order by id_sensor;

select*from sensor;
select id_cliente, modelo, local_instalacao, data_instalacao, situacao from sensor
where situacao!= 'Ativo';