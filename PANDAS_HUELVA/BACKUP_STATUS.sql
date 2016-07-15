/* Formatted on 12/03/2013 7:54:53 (QP5 v5.163.1008.3004) */
  SELECT sofar Blocks_Processed,
         totalwork Total_Work,
         ROUND ( (sofar / totalwork) * 100, 2) Percentage_Completed,
         totalwork - sofar Total_Work_Left,
         start_time Start_Time,
         ROUND ( (elapsed_seconds / 60), 0) Elapsed_Minutes,
         SUBSTR (MESSAGE, 1, 33) MESSAGE,
         username
    FROM v$session_longops
   WHERE username = 'SYS' AND MESSAGE LIKE '%RMAN%'
ORDER BY Start_Time DESC;

--and message not like '%0 Blocks done';

  SELECT sid,
         start_time,
         totalwork sofar,
         opname,
         (sofar / totalwork) * 100 pct_done
    FROM v$session_longops
   WHERE username = 'SYS' AND MESSAGE LIKE '%RMAN%'
ORDER BY start_time DESC;  --WHERE totalwork > sofar AND opname NOT LIKE '%aggregate%' AND opname LIKE 'RMAN%';

SELECT * FROM v$rman_status;
select *
from v$rman_status
--where session_recid = (select max(session_recid) from v$rman_status)
order by recid;

select *
from v$rman_output
where session_recid = (select max(session_recid) from v$rman_status)
order by recid ;