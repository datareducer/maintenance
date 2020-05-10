/*Создание сеанса для получения фактического плана исполнения запроса*/

/*DROP EVENT SESSION [query_post_execution_capture_2] ON SERVER 
GO*/
CREATE EVENT SESSION [query_post_execution_capture_2] ON SERVER 
ADD EVENT sqlserver.query_post_execution_showplan(
    ACTION(sqlserver.sql_text)
    WHERE ([sqlserver].[equal_i_sql_unicode_string]([sqlserver].[database_name],N'erpwork_1c') AND [sqlserver].[like_i_sql_unicode_string]([sqlserver].[sql_text],N'%LEFT OUTER JOIN dbo._Document761 T2%')))
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=OFF,STARTUP_STATE=OFF)
GO
