/*
  Таблица-дерево
*/
create table Tree(
  Id integer not null,
  St varchar(32) not null,
  Name varchar(50),
--
  constraint pk_Tree primary key(Id),
  constraint ix_Tree_St_Asc unique (St)
);

create desc index ix_Tree_St_Desc on Tree(St);

create generator gen_Tree_Id;
set generator gen_Tree_Id to 0;

set term ^ ;

create trigger bi_Tree for Tree
active before insert position 0
as
begin
  if (new.Id is null) then
    new.Id=gen_id(gen_Tree_Id,1);
end^

set term ; ^
