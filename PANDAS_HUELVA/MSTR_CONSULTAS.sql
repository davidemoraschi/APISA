SET DEFINE OFF
create user MSTR_CONSULTAS identified by PSEGsolarplan;
grant connect, resource, create view, create job to MSTR_CONSULTAS;
grant create procedure to MSTR_CONSULTAS;
alter user MSTR_CONSULTAS identified by PSEGsolarplan;

grant create external job to MSTR_CONSULTAS;