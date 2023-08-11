/*
  Увеличивает элемент структуры.
  Таблица символов:
  ! (33)  .. ~ (126)
  А (192) .. я (255)

*/
set term ^ ;

alter procedure incChar(
  aCh char(1))
returns(
  oCh char(1))
as
begin
  if (aCh ='я') then
    oCh=' ';  -- 'я' был последний символ в таблице
  else
    if (aCh ='~') then
      -- конец первой группы, переходим на вторую
      oCh='А';  -- русская 'А' начинает вторую группу
    else
      -- следующий символ
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
    -- если вернулся ПРОБЕЛ, значит второй символ был 'я'
    execute procedure incChar(left(aSt,1))
    returning_values(c1);

    if (c1 =' ') then begin
      -- первый символ тоже 'я' - структура заполнена!
      err=-1971; msg='Структура заполнена!';
      oSt='  ';  -- возвращаем пробел, а что ещё возвращать-то? :-|
    end
    else
      oSt=c1||'!';
  end
  else
    -- второй символ увеличился, первый остётся прежним
    oSt=left(aSt,1)||c2;

  suspend;
end^

set term ; ^
