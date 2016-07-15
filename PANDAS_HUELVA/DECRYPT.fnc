/* Formatted on 11/06/2013 10:08:09 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FUNCTION decrypt (p_val IN RAW)
   RETURN VARCHAR2
AS
   v_key          VARCHAR2 (2000) := 'VidhyavasiniDevi';
   v_decode_raw   RAW (2000);
BEGIN
   v_decode_raw := DBMS_CRYPTO.decrypt (p_val, DBMS_CRYPTO.AES_CBC_PKCS5, UTL_I18N.STRING_TO_RAW (v_key, 'AL32UTF8'));
   RETURN UTL_I18N.raw_to_char (v_decode_raw, 'AL32UTF8');
END decrypt;