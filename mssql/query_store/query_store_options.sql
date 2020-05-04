USE erpwork_1c;
/*�������� Query Store*/
ALTER DATABASE CURRENT SET QUERY_STORE = ON (OPERATION_MODE = READ_WRITE);
/*�������������� ������ ������� � �������� ���������� > 1 ��� � ����������� ������ 3-� ��� (� 2016 �� ��������� ALL - ��� �������)*/
ALTER DATABASE CURRENT SET QUERY_STORE (QUERY_CAPTURE_MODE = AUTO);
/*�������������� �� ������ 20 ������ ��� ������� ������� (�� ��������� - 200)*/
ALTER DATABASE CURRENT SET QUERY_STORE (MAX_PLANS_PER_QUERY = 20);
/*������������ ������ ��������� � �� (� 2016 �� ��������� - 100 ��)*/
ALTER DATABASE CURRENT SET QUERY_STORE (MAX_STORAGE_SIZE_MB = 1000);
