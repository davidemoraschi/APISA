/* Formatted on 11/06/2013 10:08:33 (QP5 v5.163.1008.3004) */
CREATE OR REPLACE FUNCTION encrypt (p_val IN VARCHAR2)
   RETURN RAW
AS
   v_key       VARCHAR2 (2000) := 'VidhyavasiniDevi';
   v_encoded   RAW (2000);
   encryption_type PLS_INTEGER := -- total encryption type
DBMS_CRYPTO.ENCRYPT_AES256
+ DBMS_CRYPTO.CHAIN_CBC
+ DBMS_CRYPTO.PAD_PKCS5; 
BEGIN
   v_encoded :=
      DBMS_CRYPTO.encrypt (UTL_I18N.STRING_TO_RAW (p_val, 'AL32UTF8'),
                           DBMS_CRYPTO.AES_CBC_PKCS5,
                           UTL_I18N.STRING_TO_RAW (v_key, 'AL32UTF8'));
   RETURN v_encoded;
END encrypt;