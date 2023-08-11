/*
  ќбъ€вление хранимых процедур
*/
set term ^ ;

create procedure incChar(
  aCh char(1))
returns(
  oCh char(1))
as begin
  suspend;
end^

create procedure incStruct(
  aSt char(2))
returns(
  oSt char(2),
  err integer,
  msg varchar(32))
as begin
  suspend;
end^

create procedure getSubTree(
  aSt varchar(32),
  aToLvl integer)
returns(
  oId integer,
  oSt varchar(32),
  oLvl integer,
  oHasChildren integer,
  oName varchar(50))
as begin
  suspend;
end^

create procedure getNode(
  aId integer)
returns(
  oId integer,
  oSt varchar(32),
  oLvl integer,
  oHasChildren integer,
  oName varchar(50))
as begin
  suspend;
end^

create procedure selectFromSt(
  aSt varchar(32))
returns(
  oSt varchar(32))
as begin
end^

create procedure getPathToNode(
  aId integer,
  aSt varchar(32))
returns(
  oId integer,
  oSt varchar(32),
  oLvl integer,
  oName varchar(50))
as begin
end^

create procedure delNode(
  aId integer,
  aSt varchar(32))
as begin
  suspend;
end^

create procedure addNode(
  aParentId integer,
  aParentSt varchar(32),
  aName varchar(50))
returns(
  oId integer,
  oSt varchar(32),
-- ---
  err integer,
  msg varchar(250))
as begin
end^

set term ; ^

commit;
