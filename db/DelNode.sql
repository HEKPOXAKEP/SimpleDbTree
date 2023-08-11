/*
  Удаляем узел и всех его детей
*/
set term ^ ;

alter procedure delNode(
  aId integer,
  aSt varchar(32))
as
begin
  delete from Tree
  where St starting :aSt;
end^

set term ; ^
