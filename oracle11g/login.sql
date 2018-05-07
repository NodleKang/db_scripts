define_editor=notepad 
#define_editor="C:\Program Files\UltraEdit\uedit32.exe"  
set appinfo ON
set appinfo "SQL*Plus"
set arraysize 30
set autocommit OFF
set autoprint OFF
set autorecovery OFF
set autotrace OFF
set blockterminator "."
set cmdsep OFF
set colsep " "
set compatibility NATIVE
set concat "."
set copycommit 0
set copytypecheck ON
set define "&"
set describe DEPTH 1 LINENUM OFF INDENT ON
set markup HTML OFF SPOOL OFF ENTMAP ON PRE OFF
set echo OFF
set editfile "tmp.buf"
set embedded OFF
set endbuftoken ""
set escape OFF
set feedback OFF
set flagger OFF
set flush ON
set heading ON
set headsep "|"
set linesize 2000
set logsource ""
set long 1000000
set longchunksize 80
set newpage 1
set null ""
set numformat ""
set numwidth 10
set pagesize 50
set pause OFF
set recsep WRAP
set recsepchar " "
set serveroutput ON
set shiftinout invisible
set showmode OFF
set sqlblanklines OFF
set sqlcase MIXED
set sqlcontinue "> "
set sqlnumber ON
set sqlprefix "#"
set sqlprompt "SQL > "
set sqlterminator ";"
set suffix "sql"
set tab ON
set termout OFF
set time OFF
set timing OFF
--set trimout off
set trimspool OFF
set underline "-"
set verify OFF
set wrap ON
col pr new_v pr noprint
select host_name||':'||instance_name  ||':'||user|| ' > '||chr(10)||'  1  ' as pr from v$instance ;
SET SQLPROMPT  '&pr'
set feedback   ON
set timing ON

SET TERM ON
