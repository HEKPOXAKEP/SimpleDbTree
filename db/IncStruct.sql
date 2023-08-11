/*
  ����������� ������� ���������.
  ������� ��������:
  ! (33)  .. ~ (126)
  � (192) .. � (255)

*/
set term ^ ;

alter procedure incChar(
  aCh char(1))
returns(
  oCh char(1))
as
begin
  if (aCh ='�') then
    oCh=' ';  -- '�' ��� ��������� ������ � �������
  else
    if (aCh ='~') then
      -- ����� ������ ������, ��������� �� ������
      oCh='�';  -- ������� '�' �������� ������ ������
    else
      -- ��������� ������
      oCh=ascii_char(ascii_val(aCh)+1);

  suspend;
end^

alter procedure incStruct(
  aSt char(2))
returns(
  oSt char(2),
-- ---
  err integer,
  msg varchar(32))
as
  declare variable c1 char(1);
  declare variable c2 char(1);
begin
  err=0; msg='Ok';

  execute procedure incChar(right(aSt,1))
  returning_values(c2);

  if (c2 =' ') then begin
    -- ���� �������� ������, ������ ������ ������ ��� '�'
    execute procedure incChar(left(aSt,1))
    returning_values(c1);

    if (c1 =' ') then begin
      -- ������ ������ ���� '�' - ��������� ���������!
      err=-1971; msg='��������� ���������!';
      oSt='  ';  -- ���������� ������, � ��� ��� ����������-��? :-|
    end
    else
      oSt=c1||'!';
  end
  else
    -- ������ ������ ����������, ������ ������ �������
    oSt=left(aSt,1)||c2;

  suspend;
end^

set term ; ^
