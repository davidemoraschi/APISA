SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM sys.all_mviews@SYG WHERE OWNER = 'REP_PRO_SIGLO')

/

--A.H. Torrecárdenas
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@ALE42DAE WHERE OWNER = 'REP_HIS_OWN');
--A.H. Puerta del Mar
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@CAE42DAE WHERE OWNER = 'REP_HIS_OWN');
--Puerto Real
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@CAE43DAE WHERE OWNER = 'REP_HIS_OWN');
--Infanta Margarita (Cabra)
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@COE40DAE WHERE OWNER = 'REP_HIS_OWN');
--Valle de los Pedroches (Pozoblanco)
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@COE42DAE WHERE OWNER = 'REP_HIS_OWN');
--Baza
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@GRE40DAE WHERE OWNER = 'REP_HIS_OWN');
--San Cecilio
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@GRE41DAE WHERE OWNER = 'REP_HIS_OWN');
--Virgen de las Nieves
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@GRE43DAE WHERE OWNER = 'REP_HIS_OWN');
--Juan Ramon jimenez
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@HUE40DAE WHERE OWNER = 'REP_HIS_OWN');
--Riotinto
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@HUE42DAE WHERE OWNER = 'REP_HIS_OWN');
--Virgen de la Victoria
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@MAE41DAE WHERE OWNER = 'REP_HIS_OWN');
-- La serrania  (Ronda)
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@MAE42DAE WHERE OWNER = 'REP_HIS_OWN');
--Axarquia
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@MAE43DAE WHERE OWNER = 'REP_HIS_OWN');
--Antequera
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@MAE44DAE WHERE OWNER = 'REP_HIS_OWN');
-- Merced (Osuna)
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@SEE40DAE WHERE OWNER = 'REP_HIS_OWN');
--Virgen del Rocío
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@SEE41DAE WHERE OWNER = 'REP_HIS_OWN');
--Macarena
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@SEE42DAE WHERE OWNER = 'REP_HIS_OWN');
--Valme
SELECT epoch2 (last_refresh_date) last_refresh_epoch FROM (  SELECT MIN (last_refresh_date) last_refresh_date FROM SYS.ALL_MVIEWS@SEE43DAE WHERE OWNER = 'REP_HIS_OWN');
