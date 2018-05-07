set linesize 700
set pagesize 1000
set recsep off
set verify off
set feedback on
clear column

col username1         heading "UserName"   format a8
col sid1              heading "SID"        format 99999
col sid2              heading "SID/SER#"   format a12
col status1           heading "S"          format a1
col sql_trace1        heading "TR/w/b"     format a6
col blocking1         heading "BLOCKING"   format a11
col wait_event1       heading "WAIT_EVENT" format a25
col lce1              heading "LCET"       format 9999999
col module1           heading "MODULE"     format a30
col pgm1              heading "PGM"        format a4
col sql_text1         heading "SQL "       format a45
col seconds_in_wait1  heading "W_T"        format 99999
col osuser1           heading "OSUSER"     format a13 
col terminal          heading "Terminal"   format a15
col spid1             heading "SPID"       format a9
col cpid1             heading "CPID"       format a9
col logon1            heading "LOGON"      format a18
col machine1          heading "MACHINE"    format a25 
col form_user         heading "Form_User"  format a50
col kill1             heading "KILL_OS"    format a20
col kill2             heading "KILL_DB"    format a50
col commits   format 999,999
col rollbacks format 999,999
col pga_alloc  heading "PGA" format a5 
col erp_user   heading "ERP_User" format a12
col sql_id format a13
col p1text format a30
col p2text format a30
col p3text format a30
col STATE2 heading "STATE"  format a7
col STATE1 format a18
col wait_detail  format a80

 
SELECT  /*+ leading(s p sst1 sst2) */
        substr(s.username,1,8 )                   as  username1
       ,s.sid                                     as  sid1
       ,substr(status,1,1)                        as  status1
       ,decode(substr(s.action,1,4),'FRM:',s.module||'(Form)','Onli',s.module||'(Form)','Conc',s.module||'(Conc)',s.module )         as module1
       ,substr(decode(sign(lengthb(s.program)-13),1,substr(s.program,1,13)||'..',s.program),1,4)                                     as pgm1
       ,s.seq#
       ,decode(s.STATE,'WAITING','WAITING')        as STATE2
       ,s.seconds_in_wait                         as  seconds_in_wait1
       ,substr(s.event,1,25)                      as wait_event1
       ,s.sql_id
       ,last_call_et                              as lce1
       ,trim((select substr(sql_text,1,45) from v$sql sq where sq.sql_id  = s.sql_id and rownum= 1 ))                                as sql_text1
       ,lpad(trim(to_char(round(p.pga_alloc_mem /1024/1024),'999,999'))||'M',5,' ')    as pga_alloc 
       ,to_char(logon_time,'yyyymmdd HH24:MI:SS') as logon1
       ,decode(substr(s.action,1,4),'FRM:', substr(substr(s.action,5,100),1, instr(substr(s.action,5,100),':',1)-1 )) erp_user
       ,s.machine                                 as machine1
       ,s.osuser                                  as osuser1
       ,to_char(s.sid)||','||to_char(s.serial# )  as  sid2
       ,s.process                                 as cpid1
       ,p.spid                                    as spid1
       ,s.sql_hash_value
       ,substr(s.STATE,1,18)  as STATE1
       ,s.WAIT_TIME
       ,s.audsid
       ,s.SQL_CHILD_NUMBER 
       ,'kill -9 '||p.spid                        as kill1
       ,'alter system kill session '||''''||s.sid||','||s.serial#||''''||' ; ' as kill2
       ,substr(s.terminal,1,15)                         as terminal
       ,'(p1,p2,p3)=('||s.p1text||','||s.p2text||','||s.p3text||')=('||s.p1||','||s.p2||','||s.p3||')' as wait_detail    
FROM    v$session         s                              
       ,v$process         p  
WHERE  s.paddr   = p.addr  
  AND  s.status  = 'ACTIVE'
  --AND  s.username is not null
  AND  s.event  not in ('queue messages'
                        ,'pipe get'
                        ,'jobq slave wait'
                        ,'Streams AQ: waiting for messages in the queue' 
                        ,'gcs remote message'
                        ,'rdbms ipc message'  
                       )
order by status1 desc,username1 desc , substr(s.action,1,3) desc, module1,lce1
/
