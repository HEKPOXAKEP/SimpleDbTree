/*
 ���������� �� ������ ����� � �������� ����
*/
connect 'SimpleDbTree.fdb';
drop database;

/* �������� ����� �� */
create database 'SimpleDbTree.fdb'
--user 'SYSDBA' password 'masterkey'
page_size 8192
default character set Win1251 collation Win1251;

/* ���������� � ������� �� */
connect "SimpleDbTree.fdb";

/* ���������� ��������� �� */
commit;
