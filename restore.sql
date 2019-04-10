-- dest data folder
declare @data_folder nvarchar(256) = N'D:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\';
-- folder with bak files
declare @bak_folder nvarchar(256) = N'c:\db_bak\'

declare @MyList TABLE (DbName NVARCHAR(50))
-- database names to restore
insert into @MyList VALUES
('db1')
,('db2')
,('db3')
,('db4')

declare @db_name nvarchar(50)

DECLARE db_cursor CURSOR FOR
	select [Dbname] from @MyList

	open db_cursor
	FETCH NEXT FROM db_cursor into @db_name

	while @@FETCH_STATUS = 0
	BEGIN
	    print @db_name
		declare @db_logname nvarchar(256) = @db_name + '_log'

		declare @filename nvarchar(256) = @bak_folder + @db_name + '.bak'

		declare @db_mdf_location nvarchar(256) = @data_folder + @db_name + '_Primary.mdf';
		declare @db_ldf_location nvarchar(256) = @data_folder + @db_name + '_Primary.ldf';

		USE [master]
		RESTORE DATABASE
			@db_name
		FROM
			DISK = @filename
		WITH
			FILE = 1,
			MOVE @db_name TO @db_mdf_location,
			MOVE @db_logname TO @db_ldf_location,
			NOUNLOAD,
			STATS = 5

		FETCH NEXT FROM db_cursor into @db_name
	END

	CLOSE db_cursor
	deallocate db_cursor
