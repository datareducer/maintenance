USE erpwork_1c;
/*Включает Query Store*/
ALTER DATABASE CURRENT SET QUERY_STORE = ON (OPERATION_MODE = READ_WRITE);
/*Регистрируются только запросы с временем выполнения > 1 сек и выполненные больше 3-х раз (В 2016 по умолчанию ALL - все запросы)*/
ALTER DATABASE CURRENT SET QUERY_STORE (QUERY_CAPTURE_MODE = AUTO);
/*Регистрируется не больше 20 планов для каждого запроса (По умолчанию - 200)*/
ALTER DATABASE CURRENT SET QUERY_STORE (MAX_PLANS_PER_QUERY = 20);
/*Максимальный размер хранилища в Мб (В 2016 по умолчанию - 100 Мб)*/
ALTER DATABASE CURRENT SET QUERY_STORE (MAX_STORAGE_SIZE_MB = 1000);
