select MSTR.pandas_080_lync.autodiscovery('apisa365.onmicrosoft.com') from dual
--union All
--select MSTR.pandas_080_lync.autodiscovery('pandasbi.onmicrosoft.com') from dual
--UNION ALL
--select MSTR.pandas_080_lync.autodiscovery('eurostrategy.onmicrosoft.com') from dual;
/
--select MSTR.pandas_080_lync.autodiscovery('lync.hjrjd.local') from dual;
/
select MSTR.pandas_080_lync.authentication(MSTR.pandas_080_lync.autodiscovery('apisa365.onmicrosoft.com') ) from dual;