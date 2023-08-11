/*
 Соединение со старой базой и удаление оной
*/
connect 'SimpleDbTree.fdb';
drop database;

/* создание новой БД */
create database 'SimpleDbTree.fdb'
--user 'SYSDBA' password 'masterkey'
page_size 8192
default character set Win1251 collation Win1251;

/* соединение с созаной БД */
connect "SimpleDbTree.fdb";

/* запоминаем изменения БД */
commit;
