alter database default tablespace users;
SELECT *
FROM database_properties
WHERE property_name = 'DEFAULT_PERMANENT_TABLESPACE';
SELECT *
FROM database_properties
WHERE property_name = 'DEFAULT_TEMP_TABLESPACE';
select name, value
from v$parameter
where name in ('undo_management','undo_tablespace');
select
tablespace_name
,extent_management
,segment_space_management
from dba_tablespaces;