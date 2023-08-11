/*
  Возвращает узлы от корня до указанного элемента.
*/
set term ^ ;

alter procedure selectFromSt(
  aSt varchar(32))
returns(
  oSt varchar(32))
as
  declare variable i integer;
  declare variable z integer;
begin
  z=char_length(aSt)-2;
  i=2;

  while (i <=z) do begin
    oSt=left(aSt,i);
    i=i+2;
    suspend;
  end
end^

alter procedure getPathToNode(
  aId integer,
  aSt varchar(32))
returns(
  oId integer,
  oSt varchar(32),
  oLvl integer,
  oName varchar(50))
as
begin
  for
    select Id,St,char_length(St)/2,Name
    from Tree tr
    join selectFromSt(:aSt) sel on tr.St=sel.oSt
    into :oId,:oSt,:oLvl,:oName
  do
    suspend;
end^

set term ; ^
