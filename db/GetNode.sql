/*
  Возвращает один узел по его Id
*/
set term ^ ;

alter procedure getNode(
  aId integer)
returns(
  oId integer,
  oSt varchar(32),
  oLvl integer,
  oHasChildren integer,
  oName varchar(50))
as
begin
  select Id,St,char_length(St)/2,Name
  from Tree
  where Id=:aId
  into :oId,:oSt,:oLvl,:oName;

  select count(*) from Tree where (St starting :oSt) and (char_length(St)/2 = :oLvl+1)
  into :oHasChildren;

  suspend;
end^

set term ; ^
