/*
  ��������� ���� SimpleDbTree
*/
set sql dialect 3;
set names Win1251;

input 'Connect.sql';
input 'StoredProcs.decl.sql';  -- ���������� �������� (create)
input 'Tables.sql';            -- �������, ����������, ��������
input 'StoredProcs.impl.sql';  -- �������� ��������� (alter)

commit;

/* ������� ��������� ������ */
input 'InitialData.sql';

commit work;
