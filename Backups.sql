USE TurismoCabrera_DB
GO

--COPIA DE SEGUIRADAD COMPLETA
BACKUP DATABASE [TurismoCabrera_DB]
TO DISK = N'C:\Backup_TurismoCabrera\WWIDW.bak'
WITH NAME = 'BackupCompleto'
Go

--COPIA DE SEGURIDAD DIFERENCIAL
BACKUP DATABASE [TurismoCabrera_DB]
TO DISK = N'C:\Backup_TurismoCabrera\WWIDW_d.bak'
WITH DIFFERENTIAL, NAME = 'BackupDiferencial'
Go

BACKUP DATABASE [TurismoCabrera_DB]
TO DISK = N'C:\Backup_TurismoCabrera\WWIDW_d2.bak'
WITH DIFFERENTIAL, NAME = 'BackupDiferencial'
Go 

--COPIA DE SEGURIDAD DEL LOG
BACKUP LOG [TurismoCabrera_DB]
TO DISK = N'C:\Backup_TurismoCabrera\WWIDW_LT.bak'
WITH NAME = 'Backup del log de transacciones'
GO


SELECT TOP 5 *
FROM msdb.dbo.backupset
ORDER BY backup_finish_date DESC

SELECT
database_name,
count (*) AS [TOTAL COPIAS DE SEGURIDAD]
FROM msdb.dbo.backupset
GROUP BY database_name

