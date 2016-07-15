--select PANDAS_090_POST_TO_SHAREPOINT2.BinarySecurityToken ('davidem@eurostrategy.onmicrosoft.com',
--                                                'Lepanto1571',
--                                                'eurostrategy') from dual;
--
--/* Formatted on 14/03/2013 15:44:43 (QP5 v5.163.1008.3004) */
--SELECT PANDAS_090_POST_TO_SHAREPOINT2.get_list ('https://eurostrategy.sharepoint.com/_vti_bin/ListData.svc',
--                                                'davidem@eurostrategy.onmicrosoft.com',
--                                                'Lepanto1571',
--                                                'eurostrategy')
--  FROM DUAL;
--  
 declare
  ret_char CLOB;
  begin
  ret_char:= PANDAS_090_POST_TO_SHAREPOINT2.get_list ('https://eurostrategy.sharepoint.com/_vti_bin/ListData.svc',
                                                'davidem@eurostrategy.onmicrosoft.com',
                                                'Lepanto1571',
                                                'eurostrategy');
                                                DBMS_OUTPUT.put_line (ret_char);
  end;