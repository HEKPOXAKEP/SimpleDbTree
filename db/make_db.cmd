@echo off
@del rez
"C:\Program Files (x86)\Firebird_2_5\bin\isql.exe" -i Main.sql -o rez -q -m -u SYSDBA -p masterkey
@ren simpledbtree.fdb SimpleDbTree.fdb