/*
  ��������� ���� �������� � ���������� ��������.

  ����� Id � St ���������� ����, ��� ��������� �� ������.
*/
set term ^ ;

alter procedure addNode(
  aParentId integer,
  aParentSt varchar(32),
  aName varchar(50))
returns(
  oId integer,
  oSt varchar(32),
-- ---
  err integer,
  msg varchar(250))
as
  declare variable lvlParent integer;
  declare variable lastSt varchar(32);
  declare variable cc char(2);
begin
  err=0; msg='Ok';

  lvlParent=char_length(aParentSt);

  -- ���� ��������� ���������� ��������� ��������
  select first 1 St from Tree
  where (St starting :aParentSt) and (char_length(St) =:lvlParent+2)
  order by St desc
  into :lastSt;

  if (lastSt is null) then begin
    -- ����� ���, ���� ����� ������
    oId=gen_id(gen_Tree_Id,1);
    oSt=aParentSt||'!!';

    insert into Tree(Id,St,Name)
    values(:oId,:oSt,:aName);
  end
  else begin
    -- ����� ���������� �����, ����� ��������� ������ �� ���
    execute procedure incStruct(right(lastSt,2))
    returning_values(cc,err,msg);

    if (err =0) then begin
      oSt=aParentSt||cc;
      oId=gen_id(gen_Tree_Id,1);

      insert into Tree(Id,St,Name)
      values(:oId,:oSt,:aName);
    end
  end

  suspend;
end^

set term ; ^
