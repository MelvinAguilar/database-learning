use master 
go
alter database [database_name] set single_user with rollback immediate

drop database [database_name]
