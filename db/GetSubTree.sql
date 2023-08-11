/*
  ����� �������� ���� ��� ���� aSt.

  ����� �������� ������ (�����) ������:
    select ... from getSubTree('',1)

  ����� �������� ���� ���������������� ����� ��������:
    select ... from getSubTree(<St ��������>,<������� ��������+1>
*/
set term ^ ;

alter procedure getSubTree(
  aSt varchar(32),
  aToLvl integer)
returns(
  oId integer,
  oSt varchar(32),
  oLvl integer,
  oHasChildren integer,
  oName varchar(50))
as
  declare variable aLvl integer;
begin
  aLvl=char_length(aSt)/2;  -- ������� ��������

  for
    select
      Id,St,char_length(St)/2,Name
    from Tree
    where (St starting :aSt) and (char_length(St)/2 > :aLvl) and (char_length(St)/2 <= :aToLvl)
    order by St
    into
      :oId,:oSt,:oLvl,:oName
  do begin
    select count(*) from Tree where (St starting :oSt) and (char_length(St)/2 = :oLvl+1)
    into :oHasChildren;

    suspend;
  end
end^

set term ; ^
