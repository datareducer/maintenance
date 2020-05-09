ALTER DATABASE erpwork_1c SET QUERY_STORE = ON
GO
ALTER DATABASE erpwork_1c SET QUERY_STORE (OPERATION_MODE = READ_WRITE,
    /*Регистрируются только запросы с временем выполнения > 1 сек и выполненные больше 3-х раз (В 2016 по умолчанию ALL)*/
    QUERY_CAPTURE_MODE = AUTO, 
    /*Максимальный размер хранилища в Мб (В 2016 по умолчанию - 100 Мб)*/
    MAX_STORAGE_SIZE_MB = 1000)
GO


