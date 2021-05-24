DROP TABLE profissionais;
DROP TABLE pacientes;
DROP TABLE especialidades;
DROP TABLE consultas;
DROP TABLE obitos;

create table  pacientes(
  id serial PRIMARY KEY,
  nome varchar(40) not null,
  sexo varchar(20),
  obito boolean
);

create table profissionais(
  id serial PRIMARY KEY,
  nome varchar(50)
);

create table especialidades(
  id serial,
  nome varchar(50)
);

create table consultas(
  id serial PRIMARY KEY,
  especialidade_id integer,
  profiss_id integer
);

create table  obitos(
  id serial PRIMARY KEY,
  bs text
);

--ALTERANDO TABELAS ADICIONANDO CONSULTAS
ALTER TABLE consultas ADD CONSTRAINT FkEspecialidadeDaConsulta FOREIGN KEY
    (especialidade_id)
REFERENCES especialidades(id);

ALTER TABLE consultas ADD CONSTRAINT FkProfissionalDaConsulta FOREIGN KEY   
    (profiss_id)
REFERENCES profissionais(id);

--CRINDO A FUNÇÃO DA TRIGGER
CREATE OR REPLACE FUNCTION trgValidaDadosConsulta()  RETURNS trigger AS $trgValidaDadosConsulta$ --$ = ASPAS
DECLARE
  id_pac int;
  dados_do_paciente record;
  dados_do_especialidade record;
  BEGIN
     -- caso seja um registro novo ele mostra antes de addicionar na tabela
     RAISE NOTICE 'NOVO REGISTRO: id = ', NEW.id;
     RAISE NOTICE 'NOVO REGISTRO: especialidade_id = %', NEW.especialidade_id;
     RAISE NOTICE 'NOVO REGISTRO: profiss_id = ', NEW.profiss_id;

        --IF NEW.especialidade_id = 2 AND THEN 
        --RAISE EXCEPTION 'Nao estamos aceitando INSERT id = 2';
        --END IF;

     IF pacientes_row.sexo = 'm' AND especialidades_row.nome = 'ginecologista' THEN
       RAISE EXCEPTION 'Ginecologista poder ser agendado apenas para pacientes do sexo feminino';
    ELSE  pacientes_row.sexo = 'f' AND especialidade_row.nome = 'urologista' THEN
       RAISE EXCEPTION 'Urologista poder ser agendado apenas para pacientes do sexo masculino';

    RETURN NEW;
END;

$trgValidaDadosConsulta$ LANGUAGE plpgsql; 

CREATE TRIGGER ValidaDadosConsulta
BEFORE INSERT OR UPDATE ON consultas
FOR EACH ROW --FOR EACH STATEMENT
 EXECUTE PROCEDURE trgValidaDadosConsulta();
 --colocanr drop table, create table

 --conexão do bd pelo cmd : heroku pg:psql -a ptgbd
 
