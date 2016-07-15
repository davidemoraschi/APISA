CREATE OR REPLACE package body apex_util_pkg
as
 
  /*
 
  Purpose:      package provides general apex utilities
 
  Remarks:
 
  Who     Date        Description
  ------  ----------  --------------------------------
  FDL     12.06.2008  Created
 
  */

function get_page_name (p_application_id in number,
                        p_page_id in number) return varchar2
as
  l_returnvalue string_util_pkg.t_max_db_varchar2;
begin
 
  /*
 
  Purpose:      purpose
 
  Remarks:
 
  Who     Date        Description
  ------  ----------  --------------------------------
  FDL     12.06.2008  Created
 
  */
  
  begin
    select page_name
    into l_returnvalue 
    from apex_application_pages
    where application_id = p_application_id
    and page_id = p_page_id;
  exception
    when no_data_found then
      l_returnvalue := null;
  end;
 
  return l_returnvalue;
 
end get_page_name;


function get_item_name (p_page_id in number,
                        p_item_name in varchar2) return varchar2
as
  l_returnvalue string_util_pkg.t_max_db_varchar2;
begin
 
  /*
 
  Purpose:      get item name for page and item
 
  Remarks:
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     10.01.2009  Created
 
  */
  
  l_returnvalue := upper('P' || p_page_id || '_' || p_item_name);
 
  return l_returnvalue;
 
end get_item_name;


function get_page_help_text (p_application_id in number,
                             p_page_id in number) return varchar2
as
  l_returnvalue string_util_pkg.t_max_db_varchar2;
begin
 
  /*
 
  Purpose:      purpose
 
  Remarks:
 
  Who     Date        Description
  ------  ----------  --------------------------------
  FDL     12.06.2008  Created
 
  */
  
  begin
    select help_text
    into l_returnvalue 
    from apex_application_pages
    where application_id = p_application_id
    and page_id = p_page_id;
  exception
    when no_data_found then
      l_returnvalue := null;
  end;
 
  return l_returnvalue;
 
end get_page_help_text;


function get_apex_url (p_page_id in varchar2,
                       p_request in varchar2 := null,
                       p_item_names in varchar2 := null,
                       p_item_values in varchar2 := null,
                       p_debug in varchar2 := null,
                       p_application_id in varchar2 := null,
                       p_session_id in number := null,
                       p_clear_cache in varchar2 := null) return varchar2
as
  l_returnvalue                  string_util_pkg.t_max_db_varchar2;
begin
 
  /*
 
  Purpose:      return apex url
 
  Remarks:      url format: f?p=App:Page:Session:Request:Debug:ClearCache:itemNames:itemValues:PrinterFriendly
                App: Application Id
                Page: Page Id
                Session: Session ID
                Request: GET Request (button pressed)
                Debug: Whether show debug or not (YES/NO)
                ClearCache: Comma delimited string for page(s) for which cache is to be cleared
                itemNames: Used to set session state for page items, comma delimited
                itemValues: Partner to itemNames, actual session value
                PrinterFriendly: Set to YES if page is to be rendered printer friendly
 
  Who     Date        Description
  ------  ----------  --------------------------------
  FDL     26.03.2008  Created
  MBR     12.07.2011  Added clear cache parameter
 
  */
  
  l_returnvalue := 'f?p=' || nvl(p_application_id, v('APP_ID')) 
                          || ':'|| p_page_id 
                          || ':' || nvl(p_session_id, v('APP_SESSION'))
                          || ':' || p_request
                          || ':' || nvl(p_debug, 'NO')
                          || ':' || p_clear_cache
                          || ':' || p_item_names
                          || ':' || utl_url.escape(p_item_values)
                          || ':';
 
  return l_returnvalue;
 
end get_apex_url;


function get_apex_url_simple (p_page_id in varchar2,
                              p_item_name in varchar2 := null,
                              p_item_value in varchar2 := null,
                              p_request in varchar2 := null) return varchar2
as
  l_returnvalue                  string_util_pkg.t_max_db_varchar2;
begin
 
  /*
 
  Purpose:      return apex url (simple syntax)
 
  Remarks:      assumes only one parameter, and prefixes the parameter name with page number
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     03.08.2010  Created
 
  */
  
  l_returnvalue := 'f?p=' || v('APP_ID') 
                          || ':'|| p_page_id 
                          || ':' || v('APP_SESSION')
                          || ':' || p_request
                          || ':' || 'NO'
                          || ':'
                          || ':' || case when p_item_name is not null then 'P' || p_page_id || '_' || p_item_name else null end
                          || ':' || utl_url.escape(p_item_value)
                          || ':';
 
  return l_returnvalue;
 
end get_apex_url_simple;


function get_apex_url_item_names (p_page_id in number,
                                  p_item_name_array in t_str_array) return varchar2
as
  l_returnvalue                  string_util_pkg.t_max_db_varchar2;
  l_str                          string_util_pkg.t_max_db_varchar2;
begin
 
  /*
 
  Purpose:      get item name
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  THH     28.05.2008  Created
 
  */
  
  for i in 1..p_item_name_array.count loop
  
    l_str := 'P' || p_page_id || '_' || p_item_name_array(i);
    l_returnvalue := string_util_pkg.add_item_to_list(l_str, l_returnvalue, ',');
  end loop;
 
  return l_returnvalue;
 
end get_apex_url_item_names;


function get_apex_url_item_values (p_item_value_array in t_str_array) return varchar2
as
  l_returnvalue                  string_util_pkg.t_max_db_varchar2;
  l_str                          string_util_pkg.t_max_db_varchar2;
begin
 
  /*
 
  Purpose:      get item values
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  THH     28.05.2008  Created
 
  */
  
  for i in 1..p_item_value_array.count loop

    l_str := p_item_value_array(i);
    l_returnvalue := string_util_pkg.add_item_to_list(l_str, l_returnvalue, ',');
    
  end loop;
 
  return l_returnvalue;                          

end get_apex_url_item_values;


function get_dynamic_lov_query (p_application_id in number,
                                p_lov_name in varchar2) return varchar2
as
  l_returnvalue string_util_pkg.t_max_pl_varchar2;
begin

  /*
 
  Purpose:      get query of dynamic lov
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  FDL     08.07.2008  Created
 
  */

  begin
  
    select list_of_values_query
    into l_returnvalue
    from apex_application_lovs
    where application_id = p_application_id
    and list_of_values_name = p_lov_name;
    
  exception
    when no_data_found then
      l_returnvalue := null;
  end;
  
  return l_returnvalue;
  
end get_dynamic_lov_query;


procedure set_apex_security_context (p_schema in varchar2)
as
begin

  /*

  Purpose:    set Apex security context

  Remarks:    to be able to run Apex APIs that require a context (security group ID) to be set

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     04.12.2009  Created

  */
  
  wwv_flow_api.set_security_group_id(apex_util.find_security_group_id(p_schema));


end set_apex_security_context;


procedure setup_apex_session_context (p_application_id in number)
as
  l_security_group_id            number;
begin

  /*
  
  Purpose:      setup Apex session context
  
  Remarks:      required before calling packages via the URL, outside the Apex framework
  
  Who      Date        Description
  ------  ----------  --------------------------------
  MBR     20.10.2009  Created
  
  */

  apex_application.g_flow_id := p_application_id;
  
  if wwv_flow_custom_auth_std.is_session_valid then

    apex_custom_auth.set_session_id(apex_custom_auth.get_session_id_from_cookie);
    apex_custom_auth.set_user(apex_custom_auth.get_username);
 
    l_security_group_id := apex_application.get_current_flow_sgid(apex_application.g_flow_id);
    wwv_flow_api.set_security_group_id(l_security_group_id);
    
  else
    raise_application_error (-20000, 'Session not valid.');
  end if;

end setup_apex_session_context;

 
function get_str_value (p_str in varchar2) return varchar2
as
  l_returnvalue string_util_pkg.t_max_pl_varchar2;
begin

  /*

  Purpose:    get string value

  Remarks:    

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     03.05.2010  Created

  */
  
  if p_str in (g_apex_null_str, g_apex_undefined_str) then
    l_returnvalue := null;
  else
    l_returnvalue := p_str;
  end if;
  
  return l_returnvalue;

end get_str_value;


function get_num_value (p_str in varchar2) return number
as
  l_returnvalue number;
begin

  /*

  Purpose:    get number value

  Remarks:    

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     03.05.2010  Created

  */
  
  if p_str in (g_apex_null_str, g_apex_undefined_str) then
    l_returnvalue := null;
  else
    -- assuming the NLS parameters are set correctly, we do NOT specify decimal or thousand separator
    l_returnvalue := string_util_pkg.str_to_num (p_str, null, null);
  end if;
  
  return l_returnvalue;

end get_num_value;


function get_date_value (p_str in varchar2) return date
as
  l_returnvalue date;
begin

  /*

  Purpose:    get date value

  Remarks:    

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     03.05.2010  Created

  */
  
  if p_str in (g_apex_null_str, g_apex_undefined_str) then
    l_returnvalue := null;
  else
    l_returnvalue := string_util_pkg.parse_date (p_str);
  end if;
  
  return l_returnvalue;

end get_date_value;


procedure set_item (p_page_id in varchar2,
                    p_item_name in varchar2,
                    p_value in varchar2) 
as
begin
 
  /*
 
  Purpose:      set Apex item value (string)
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     02.11.2010  Created
 
  */
 
  apex_util.set_session_state ('P' || p_page_id || '_' || upper(p_item_name), p_value);
 
end set_item;
 

procedure set_date_item (p_page_id in varchar2,
                         p_item_name in varchar2,
                         p_value in date,
                         p_date_format in varchar2 := null) 
as
begin
 
  /*
 
  Purpose:      set Apex item value (date)
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     02.11.2010  Created
 
  */
 
  apex_util.set_session_state ('P' || p_page_id || '_' || upper(p_item_name), to_char(p_value, nvl(p_date_format, date_util_pkg.g_date_fmt_date_hour_min)));
 
end set_date_item;

 
function get_item (p_page_id in varchar2,
                   p_item_name in varchar2,
                   p_max_length in number := null) return varchar2
as
  l_returnvalue string_util_pkg.t_max_pl_varchar2;
begin
 
  /*
 
  Purpose:      get Apex item value (string)
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     02.11.2010  Created
  MBR     01.12.2010  Added parameter for max length
 
  */
 
  l_returnvalue := get_str_value (apex_util.get_session_state ('P' || p_page_id || '_' || upper(p_item_name)));
  
  if p_max_length is not null then
    l_returnvalue := substr(l_returnvalue, 1, p_max_length);
  end if;

  return l_returnvalue;
 
end get_item;
 
 
function get_num_item (p_page_id in varchar2,
                       p_item_name in varchar2) return number
as
  l_returnvalue number;
begin
 
  /*
 
  Purpose:      get Apex item value (number)
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     02.11.2010  Created
 
  */

  l_returnvalue := get_num_value (apex_util.get_session_state ('P' || p_page_id || '_' || upper(p_item_name)));
 
  return l_returnvalue;
 
end get_num_item;


function get_date_item (p_page_id in varchar2,
                        p_item_name in varchar2) return date
as
  l_returnvalue date;
begin
 
  /*
 
  Purpose:      get Apex item value (date)
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     02.11.2010  Created
 
  */

  l_returnvalue := get_date_value (apex_util.get_session_state ('P' || p_page_id || '_' || upper(p_item_name)));
 
  return l_returnvalue;
 
end get_date_item;


procedure get_items (p_app_id in number,
                     p_page_id in number,
                     p_target in varchar2,
                     p_exclude_items in t_str_array := null) 
as

  cursor l_item_cursor
  is
  select item_name, substr(lower(item_name), length('p' || p_page_id || '_') +1 ) as field_name,
    display_as
  from apex_application_page_items
  where application_id = p_app_id
  and page_id = p_page_id
  and item_name not in (select upper(column_value) from table(p_exclude_items))
  and display_as not like '%does not save state%'
  order by item_name;

  l_sql                          string_util_pkg.t_max_pl_varchar2;
  l_cursor                       pls_integer;
  l_rows                         pls_integer;

begin
 
  /*
 
  Purpose:      get multiple item values from page into custom record type
 
  Remarks:      this procedure grabs all the values from a page, so we don't have to write code to retrieve each item separately
                since a PL/SQL function cannot return a dynamic type (%ROWTYPE and PL/SQL records are not supported by ANYDATA/ANYTYPE),
                  we must populate a global package variable as a workaround
                the global package variable (specified using the p_target parameter) must have fields matching the item names on the page
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     15.02.2011  Created
 
  */
 
  for l_rec in l_item_cursor loop
    l_sql := l_sql || '  ' || p_target || '.' || l_rec.field_name || ' := :b' || l_item_cursor%rowcount || ';' || chr(10);
  end loop;
  
  l_sql := 'begin' || chr(10) || l_sql || 'end;';
  
  --debug_pkg.printf('sql = %1', l_sql);
  
  begin
    l_cursor := dbms_sql.open_cursor;
    dbms_sql.parse (l_cursor, l_sql, dbms_sql.native);
    
    for l_rec in l_item_cursor loop
      if l_rec.display_as like '%Date Picker%' then
        dbms_sql.bind_variable (l_cursor, ':b' || l_item_cursor%rowcount, get_date_value(apex_util.get_session_state(l_rec.item_name)));
      else
        dbms_sql.bind_variable (l_cursor, ':b' || l_item_cursor%rowcount, get_str_value(apex_util.get_session_state(l_rec.item_name)));
      end if;
    end loop;
    
    l_rows := dbms_sql.execute (l_cursor);
    dbms_sql.close_cursor (l_cursor);
  exception
    when others then
      if dbms_sql.is_open (l_cursor) then
        dbms_sql.close_cursor (l_cursor);
      end if;
      raise;
  end;
 
end get_items;
 
 
procedure set_items (p_app_id in number,
                     p_page_id in number,
                     p_source in varchar2,
                     p_exclude_items in t_str_array := null) 
as

  cursor l_item_cursor
  is
  select item_name, substr(lower(item_name), length('p' || p_page_id || '_') +1 ) as field_name,
    display_as
  from apex_application_page_items
  where application_id = p_app_id
  and page_id = p_page_id
  and item_name not in (select upper(column_value) from table(p_exclude_items))
  and display_as not like '%does not save state%'
  order by item_name;

  l_sql                          string_util_pkg.t_max_pl_varchar2;

begin
 
  /*
 
  Purpose:      set multiple item values on page based on custom record type
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     15.02.2011  Created
 
  */
 
  for l_rec in l_item_cursor loop
    l_sql := l_sql || '  apex_util.set_session_state(''' || l_rec.item_name || ''', ' || p_source || '.' || l_rec.field_name || ');' || chr(10);
  end loop;
  
  l_sql := 'begin' || chr(10) || l_sql || 'end;';
  
  execute immediate l_sql;
 
end set_items;


function is_item_in_list (p_item in varchar2,
                          p_list in apex_application_global.vc_arr2) return boolean
as
  l_index       binary_integer;
  l_returnvalue boolean := false;
begin

  /*
 
  Purpose:      return true if specified item exists in list 
 
  Remarks:      
 
  Who     Date        Description
  ------  ----------  --------------------------------
  MBR     09.07.2011  Created
 
  */
  
  l_index := p_list.first;
  while (l_index is not null) loop
    if p_list(l_index) = p_item then
      l_returnvalue := true;
      exit;
    end if;
    l_index := p_list.next(l_index);
  end loop;

  return l_returnvalue; 

end is_item_in_list;


function get_apex_session_value (p_value_name in varchar2) return varchar2
as
  l_returnvalue string_util_pkg.t_max_pl_varchar2;
begin

  /*
  
  Purpose:      get Apex session value
  
  Remarks:      if a package is called outside the Apex framework (but in a valid session -- see setup_apex_session_context),
                the session values are not available via apex_util.get_session_state or the V function, see http://forums.oracle.com/forums/thread.jspa?threadID=916301
                a workaround is to use the "do_substitutions" function, see http://apex-smb.blogspot.com/2009/07/apexapplicationdosubstitutions.html
  
  Who      Date        Description
  ------  ----------  --------------------------------
  MBR     26.01.2010  Created
  
  */

  l_returnvalue := apex_application.do_substitutions(chr(38) || upper(p_value_name) || '.');
  
  return l_returnvalue;

end get_apex_session_value;



end apex_util_pkg;
/
CREATE OR REPLACE package body amazon_aws_auth_pkg
as

  /*

  Purpose:   PL/SQL wrapper package for Amazon AWS authentication API

  Remarks:   inspired by the whitepaper "Building an Amazon S3 Client with Application Express 4.0" by Jason Straub
             see http://jastraub.blogspot.com/2011/01/building-amazon-s3-client-with.html

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */

  g_aws_id                 varchar2(20) := 'my_aws_id'; -- AWS access key ID
  g_aws_key                varchar2(40) := 'my_aws_key'; -- AWS secret key

  g_gmt_offset             number := 0; -- your timezone GMT adjustment 


function get_auth_string (p_string in varchar2) return varchar2
as
 l_returnvalue      varchar2(32000);
 l_encrypted_raw    raw (2000);             -- stores encrypted binary text 
 l_decrypted_raw    raw (2000);             -- stores decrypted binary text 
 l_key_bytes_raw    raw (64);               -- stores 256-bit encryption key 
begin

  /*

  Purpose:   get authentication string 

  Remarks:   see http://docs.amazonwebservices.com/AmazonS3/latest/dev/RESTAuthentication.html#ConstructingTheAuthenticationHeader

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */

  l_key_bytes_raw := utl_i18n.string_to_raw (g_aws_key,  'AL32UTF8'); 
  l_decrypted_raw := utl_i18n.string_to_raw (p_string, 'AL32UTF8'); 
 
  l_encrypted_raw := dbms_crypto.mac (src => l_decrypted_raw, typ => dbms_crypto.hmac_sh1, key => l_key_bytes_raw);
  
  l_returnvalue := utl_i18n.raw_to_char (utl_encode.base64_encode(l_encrypted_raw), 'AL32UTF8'); 
 
  l_returnvalue := 'AWS ' || g_aws_id || ':' || l_returnvalue;
  
  return l_returnvalue;

end get_auth_string;


function get_signature (p_string in varchar2) return varchar2
as
  
begin

  /*

  Purpose:   get signature part of authentication string

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */
  
  return substr(get_auth_string(p_string),26);   

end get_signature;


function get_aws_id return varchar2
as
begin

  /*

  Purpose:   get AWS access key ID

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */

  return g_aws_id;

end get_aws_id;


function get_date_string (p_date in date := sysdate) return varchar2
as
  l_returnvalue varchar2(255);
begin

  /*

  Purpose:   get AWS access key ID

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */
  
  l_returnvalue := to_char(p_date + g_gmt_offset/24, 'Dy, DD Mon YYYY HH24:MI:SS', 'NLS_DATE_LANGUAGE = AMERICAN') || ' GMT'; 

  return l_returnvalue;

end get_date_string;


function get_epoch (p_date in date) return number
as
  l_returnvalue number;
begin

  /*

  Purpose:   get epoch (number of seconds since January 1, 1970)

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */

  l_returnvalue := trunc((p_date - to_date('01-01-1970','MM-DD-YYYY')) * 24 * 60 * 60);

  return l_returnvalue;

end get_epoch;


procedure set_aws_id (p_aws_id in varchar2)
as
begin

  /*

  Purpose:   set AWS access key id

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     18.01.2011  Created
  
  */
  
  g_aws_id := p_aws_id;


end set_aws_id;
  

procedure set_aws_key (p_aws_key in varchar2)
as
begin

  /*

  Purpose:   set AWS secret key

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     18.01.2011  Created
  
  */

  g_aws_key := p_aws_key;

end set_aws_key;


procedure set_gmt_offset (p_gmt_offset in number)
as
begin

  /*

  Purpose:   set GMT offset

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     03.03.2011  Created
  
  */
  
  g_gmt_offset := p_gmt_offset;

end set_gmt_offset;


procedure init (p_aws_id in varchar2,
                p_aws_key in varchar2,
                p_gmt_offset in number)
as
begin

  /*

  Purpose:   initialize package for use

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     03.03.2011  Created
  
  */

  g_aws_id := p_aws_id;
  g_aws_key := p_aws_key;
  g_gmt_offset := nvl(p_gmt_offset, g_gmt_offset);

end init;

end amazon_aws_auth_pkg;
/
CREATE OR REPLACE package body amazon_aws_s3_pkg
as

  /*

  Purpose:   PL/SQL wrapper package for Amazon AWS S3 API

  Remarks:   inspired by the whitepaper "Building an Amazon S3 Client with Application Express 4.0" by Jason Straub
             see http://jastraub.blogspot.com/2011/01/building-amazon-s3-client-with.html

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */

  g_aws_url_s3             constant varchar2(255) := 'http://s3.amazonaws.com/';
  g_aws_host_s3            constant varchar2(255) := 's3.amazonaws.com';
  g_aws_namespace_s3       constant varchar2(255) := 'http://s3.amazonaws.com/doc/2006-03-01/';
  g_aws_namespace_s3_full  constant varchar2(255) := 'xmlns="' || g_aws_namespace_s3 || '"';
  
  g_date_format_xml        constant varchar2(30) := 'YYYY-MM-DD"T"HH24:MI:SS".000Z"';


procedure raise_error (p_error_message in varchar2)
as
begin

  /*

  Purpose:   raise error

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     15.01.2011  Created
  
  */
  
  raise_application_error (-20000, p_error_message);

end raise_error;


procedure check_for_errors (p_clob in clob)
as
  l_xml xmltype;
begin

  /*

  Purpose:   check for errors (clob)

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     15.01.2011  Created
  
  */

  if (p_clob is not null) and (length(p_clob) > 0) then

    l_xml := xmltype (p_clob);

    if l_xml.existsnode('/Error') = 1 then
      debug_pkg.print (l_xml);
      raise_error (l_xml.extract('/Error/Message/text()').getstringval());
    end if;
    
  end if;

end check_for_errors;


procedure check_for_errors (p_xml in xmltype)
as
begin

  /*

  Purpose:   check for errors (XMLType)

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     15.01.2011  Created
  
  */

  if p_xml.existsnode('/Error') = 1 then
    debug_pkg.print (p_xml);
    raise_error (p_xml.extract('/Error/Message/text()').getstringval());
  end if;

end check_for_errors;


function make_request (p_url in varchar2,
                       p_http_method in varchar2,
                       p_header_names in t_str_array,
                       p_header_values in t_str_array,
                       p_request_blob in blob := null,
                       p_request_clob in clob := null) return clob
as
  l_http_req     utl_http.req;
  l_http_resp    utl_http.resp;

  l_amount       binary_integer := 32000;
  l_offset       integer := 1;
  l_buffer       varchar2(32000);
  l_buffer_raw   raw(32000);

  l_response     varchar2(2000);
  l_returnvalue  clob;

begin

  /*

  Purpose:   make HTTP request

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     15.01.2011  Created
  
  */
  
  debug_pkg.printf('%1 %2', p_http_method, p_url);

  l_http_req := utl_http.begin_request(p_url, p_http_method);
  
  if p_header_names.count > 0 then
    for i in p_header_names.first .. p_header_names.last loop
      --debug_pkg.printf('%1: %2', p_header_names(i), p_header_values(i));
      utl_http.set_header(l_http_req, p_header_names(i), p_header_values(i));
    end loop;
  end if;
  
  if p_request_blob is not null then

    begin
      loop
        dbms_lob.read (p_request_blob, l_amount, l_offset, l_buffer_raw);
        utl_http.write_raw (l_http_req, l_buffer_raw);
        l_offset := l_offset + l_amount;
        l_amount := 32000;
      end loop;
    exception
      when no_data_found then
        null;
    end;

  elsif p_request_clob is not null then
  
    begin
      loop
        dbms_lob.read (p_request_clob, l_amount, l_offset, l_buffer);
        utl_http.write_text (l_http_req, l_buffer);
        l_offset := l_offset + l_amount;
        l_amount := 32000;
      end loop;
    exception
      when no_data_found then
        null;
    end;

  end if;

  l_http_resp := utl_http.get_response(l_http_req);

  dbms_lob.createtemporary (l_returnvalue, false);
  dbms_lob.open (l_returnvalue, dbms_lob.lob_readwrite);

  begin
    loop
      utl_http.read_text (l_http_resp, l_buffer);
      dbms_lob.writeappend (l_returnvalue, length(l_buffer), l_buffer);
    end loop;
  exception
    when others then
      if sqlcode <> -29266 then
        raise;
      end if;
  end;

  utl_http.end_response (l_http_resp);
  
  return l_returnvalue;

end make_request;


function get_url (p_bucket_name in varchar2,
                  p_key in varchar2 := null) return varchar2
as
  l_returnvalue varchar2(4000);
begin

  /*

  Purpose:   construct a valid URL

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     03.03.2011  Created
  
  */

  l_returnvalue := 'http://' || p_bucket_name || '.' || g_aws_host_s3 || '/' || p_key;
  
  return l_returnvalue;
  
end get_url;


function get_host (p_bucket_name in varchar2) return varchar2
as
  l_returnvalue varchar2(4000);
begin

  /*

  Purpose:   construct a valid host string

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     03.03.2011  Created
  
  */

  l_returnvalue := p_bucket_name || '.' || g_aws_host_s3;
  
  return l_returnvalue;
  
end get_host;


function get_bucket_list return t_bucket_list
as
  l_clob                         clob;
  l_xml                          xmltype;

  l_date_str                     varchar2(255);
  l_auth_str                     varchar2(255);
  
  l_header_names                 t_str_array := t_str_array();
  l_header_values                t_str_array := t_str_array();

  l_count                        pls_integer := 0;
  l_returnvalue                  t_bucket_list;
  
begin

  /*

  Purpose:   get buckets

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */

  l_date_str := amazon_aws_auth_pkg.get_date_string;
  l_auth_str := amazon_aws_auth_pkg.get_auth_string ('GET' || chr(10) || chr(10) || chr(10) || l_date_str || chr(10) || '/');

  l_header_names.extend;
  l_header_names(1) := 'Host';
  l_header_values.extend;
  l_header_values(1) := g_aws_host_s3;

  l_header_names.extend;
  l_header_names(2) := 'Date';
  l_header_values.extend;
  l_header_values(2) := l_date_str;

  l_header_names.extend;
  l_header_names(3) := 'Authorization';
  l_header_values.extend;
  l_header_values(3) := l_auth_str;

  l_clob := make_request (g_aws_url_s3, 'GET', l_header_names, l_header_values, null);

  if (l_clob is not null) and (length(l_clob) > 0) then
  
    l_xml := xmltype (l_clob);
    
    check_for_errors (l_xml);

    for l_rec in (
      select extractValue(value(t), '*/Name', g_aws_namespace_s3_full) as bucket_name,
        extractValue(value(t), '*/CreationDate', g_aws_namespace_s3_full) as creation_date
      from table(xmlsequence(l_xml.extract('//ListAllMyBucketsResult/Buckets/Bucket', g_aws_namespace_s3_full))) t
      ) loop
      l_count := l_count + 1;
      l_returnvalue(l_count).bucket_name := l_rec.bucket_name;
      l_returnvalue(l_count).creation_date := to_date(l_rec.creation_date, g_date_format_xml);
    end loop;
    
  end if;

  return l_returnvalue;

end get_bucket_list;


function get_bucket_tab return t_bucket_tab pipelined
as
  l_bucket_list                  t_bucket_list;
begin

  /*

  Purpose:   get buckets

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     19.01.2011  Created
  
  */
  
  l_bucket_list := get_bucket_list;
  
  for i in 1 .. l_bucket_list.count loop
    pipe row (l_bucket_list(i));
  end loop;
  
  return;

end get_bucket_tab;


procedure new_bucket (p_bucket_name in varchar2,
                      p_region in varchar2 := null)
as

  l_request_body                 clob;
  l_clob                         clob;
  l_xml                          xmltype;

  l_date_str                     varchar2(255);
  l_auth_str                     varchar2(255);
  
  l_header_names                 t_str_array := t_str_array();
  l_header_values                t_str_array := t_str_array();

begin

  /*

  Purpose:   create bucket

  Remarks:   *** bucket names must be unique across all of Amazon S3 ***
  
             see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketPUT.html

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     15.01.2011  Created
  
  */
  
  l_date_str := amazon_aws_auth_pkg.get_date_string;

  if p_region is not null then
    l_auth_str := amazon_aws_auth_pkg.get_auth_string ('PUT' || chr(10) || chr(10) || 'text/plain' || chr(10) || l_date_str || chr(10) || '/' || p_bucket_name || '/');
  else
    l_auth_str := amazon_aws_auth_pkg.get_auth_string ('PUT' || chr(10) || chr(10) || chr(10) || l_date_str || chr(10) || '/' || p_bucket_name || '/');
  end if;

  l_header_names.extend;
  l_header_names(1) := 'Host';
  l_header_values.extend;
  l_header_values(1) := get_host(p_bucket_name);

  l_header_names.extend;
  l_header_names(2) := 'Date';
  l_header_values.extend;
  l_header_values(2) := l_date_str;

  l_header_names.extend;
  l_header_names(3) := 'Authorization';
  l_header_values.extend;
  l_header_values(3) := l_auth_str;
  
  if p_region is not null then

    l_request_body := '<CreateBucketConfiguration ' || g_aws_namespace_s3_full || '><LocationConstraint>' || p_region || '</LocationConstraint></CreateBucketConfiguration>';

    l_header_names.extend;
    l_header_names(4) := 'Content-Type';
    l_header_values.extend;
    l_header_values(4) := 'text/plain';

    l_header_names.extend;
    l_header_names(5) := 'Content-Length';
    l_header_values.extend;
    l_header_values(5) := length(l_request_body);

  end if;

  l_clob := make_request (get_url (p_bucket_name), 'PUT', l_header_names, l_header_values, null, l_request_body);
  
  check_for_errors (l_clob);

end new_bucket;


function get_bucket_region (p_bucket_name in varchar2) return varchar2
as

  l_clob                         clob;
  l_xml                          xmltype;

  l_date_str                     varchar2(255);
  l_auth_str                     varchar2(255);
  
  l_header_names                 t_str_array := t_str_array();
  l_header_values                t_str_array := t_str_array();
  
  l_returnvalue                  varchar2(255);

begin

  /*

  Purpose:   get bucket region

  Remarks:   see http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTBucketGETlocation.html
  
             note that the region will be NULL for buckets in the default region (US)

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     03.03.2011  Created
  
  */

  l_date_str := amazon_aws_auth_pkg.get_date_string;
  l_auth_str := amazon_aws_auth_pkg.get_auth_string ('GET' || chr(10) || chr(10) || chr(10) || l_date_str || chr(10) || '/' || p_bucket_name || '/?location');

  l_header_names.extend;
  l_header_names(1) := 'Host';
  l_header_values.extend;
  l_header_values(1) := get_host(p_bucket_name);

  l_header_names.extend;
  l_header_names(2) := 'Date';
  l_header_values.extend;
  l_header_values(2) := l_date_str;

  l_header_names.extend;
  l_header_names(3) := 'Authorization';
  l_header_values.extend;
  l_header_values(3) := l_auth_str;

  l_clob := make_request (get_url(p_bucket_name) || '?location', 'GET', l_header_names, l_header_values);

  if (l_clob is not null) and (length(l_clob) > 0) then
  
    l_xml := xmltype (l_clob);
    
    check_for_errors (l_xml);
    
    if l_xml.existsnode('/LocationConstraint', g_aws_namespace_s3_full) = 1 then
      -- see http://pbarut.blogspot.com/2006/11/ora-30625-and-xmltype.html
      if l_xml.extract('/LocationConstraint/text()', g_aws_namespace_s3_full) is not null then
        l_returnvalue := l_xml.extract('/LocationConstraint/text()', g_aws_namespace_s3_full).getstringval();
      else
        l_returnvalue := null;
      end if;
    end if;
    
  end if;

  return l_returnvalue;

end get_bucket_region;


function get_object_list (p_bucket_name in varchar2,
                          p_prefix in varchar2 := null,
                          p_max_keys in number := null) return t_object_list
as
  l_clob                         clob;
  l_xml                          xmltype;

  l_date_str                     varchar2(255);
  l_auth_str                     varchar2(255);
  
  l_header_names                 t_str_array := t_str_array();
  l_header_values                t_str_array := t_str_array();

  l_count                        pls_integer := 0;
  l_returnvalue                  t_object_list;
  
begin

  /*

  Purpose:   get objects

  Remarks:   see http://docs.amazonwebservices.com/AmazonS3/latest/API/index.html?RESTObjectGET.html

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     15.01.2011  Created
  
  */

  l_date_str := amazon_aws_auth_pkg.get_date_string;
  l_auth_str := amazon_aws_auth_pkg.get_auth_string ('GET' || chr(10) || chr(10) || chr(10) || l_date_str || chr(10) || '/' || p_bucket_name || '/');

  l_header_names.extend;
  l_header_names(1) := 'Host';
  l_header_values.extend;
  l_header_values(1) := get_host (p_bucket_name);

  l_header_names.extend;
  l_header_names(2) := 'Date';
  l_header_values.extend;
  l_header_values(2) := l_date_str;

  l_header_names.extend;
  l_header_names(3) := 'Authorization';
  l_header_values.extend;
  l_header_values(3) := l_auth_str;

  l_clob := make_request (get_url(p_bucket_name) || '?prefix=' || utl_url.escape(p_prefix) || '&max-keys=' || p_max_keys, 'GET', l_header_names, l_header_values, null);

  if (l_clob is not null) and (length(l_clob) > 0) then
  
    l_xml := xmltype (l_clob);

    check_for_errors (l_xml);

    for l_rec in (
      select extractValue(value(t), '*/Key', g_aws_namespace_s3_full) as key,
        extractValue(value(t), '*/Size', g_aws_namespace_s3_full) as size_bytes,
        extractValue(value(t), '*/LastModified', g_aws_namespace_s3_full) as last_modified
      from table(xmlsequence(l_xml.extract('//ListBucketResult/Contents', g_aws_namespace_s3_full))) t
      ) loop
      l_count := l_count + 1;
      l_returnvalue(l_count).key := l_rec.key;
      l_returnvalue(l_count).size_bytes := l_rec.size_bytes;
      l_returnvalue(l_count).last_modified := to_date(l_rec.last_modified, g_date_format_xml);
    end loop;
    
  end if;

  return l_returnvalue;

end get_object_list;


function get_object_tab (p_bucket_name in varchar2,
                         p_prefix in varchar2 := null,
                         p_max_keys in number := null) return t_object_tab pipelined
as
  l_object_list                  t_object_list;
begin

  /*

  Purpose:   get objects

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     19.01.2011  Created
  
  */
  
  l_object_list := get_object_list (p_bucket_name, p_prefix, p_max_keys);
  
  for i in 1 .. l_object_list.count loop
    pipe row (l_object_list(i));
  end loop;
  
  return;

end get_object_tab;


function get_download_url (p_bucket_name in varchar2,
                           p_key in varchar2,
                           p_expiry_date in date) return varchar2
as
  l_returnvalue                  varchar2(4000);
  l_key                          varchar2(4000) := utl_url.escape (p_key);
  l_epoch                        number;
  l_signature                    varchar2(4000);
begin

  /*

  Purpose:   get download URL

  Remarks:   see http://s3.amazonaws.com/doc/s3-developer-guide/RESTAuthentication.html   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     15.01.2011  Created
  
  */
  
  l_epoch := amazon_aws_auth_pkg.get_epoch (p_expiry_date);
  l_signature := amazon_aws_auth_pkg.get_signature ('GET' || chr(10) || chr(10) || chr(10) || l_epoch || chr(10) || '/' || p_bucket_name || '/' || l_key);
  
  l_returnvalue := get_url (p_bucket_name, l_key)
    || '?AWSAccessKeyId=' || amazon_aws_auth_pkg.get_aws_id
    || '&Expires=' || l_epoch
    || '&Signature=' || wwv_flow_utilities.url_encode2 (l_signature);

  return l_returnvalue;

end get_download_url;


procedure new_object (p_bucket_name in varchar2,
                      p_key in varchar2,
                      p_object in blob,
                      p_content_type in varchar2,
                      p_acl in varchar2 := null)
as

  l_key                          varchar2(4000) := utl_url.escape (p_key);

  l_clob                         clob;
  l_xml                          xmltype;

  l_date_str                     varchar2(255);
  l_auth_str                     varchar2(255);
  
  l_header_names                 t_str_array := t_str_array();
  l_header_values                t_str_array := t_str_array();

begin

  /*

  Purpose:   upload new object

  Remarks:   see  http://docs.amazonwebservices.com/AmazonS3/latest/API/RESTObjectPUT.html

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     16.01.2011  Created
  
  */

  l_date_str := amazon_aws_auth_pkg.get_date_string;
  
  if p_acl is not null then
    l_auth_str := amazon_aws_auth_pkg.get_auth_string ('PUT' || chr(10) || chr(10) || p_content_type || chr(10) || l_date_str || chr(10) || 'x-amz-acl:' || p_acl || chr(10) || '/' || p_bucket_name || '/' || l_key);
  else
    l_auth_str := amazon_aws_auth_pkg.get_auth_string ('PUT' || chr(10) || chr(10) || p_content_type || chr(10) || l_date_str || chr(10) || '/' || p_bucket_name || '/' || l_key);
  end if;

  l_header_names.extend;
  l_header_names(1) := 'Host';
  l_header_values.extend;
  l_header_values(1) := get_host(p_bucket_name);

  l_header_names.extend;
  l_header_names(2) := 'Date';
  l_header_values.extend;
  l_header_values(2) := l_date_str;

  l_header_names.extend;
  l_header_names(3) := 'Authorization';
  l_header_values.extend;
  l_header_values(3) := l_auth_str;

  l_header_names.extend;
  l_header_names(4) := 'Content-Type';
  l_header_values.extend;
  l_header_values(4) := nvl(p_content_type, 'application/octet-stream');

  l_header_names.extend;
  l_header_names(5) := 'Content-Length';
  l_header_values.extend;
  l_header_values(5) := dbms_lob.getlength(p_object);
  
  if p_acl is not null then
    l_header_names.extend;
    l_header_names(6) := 'x-amz-acl';
    l_header_values.extend;
    l_header_values(6) := p_acl;
  end if;
  
  l_clob := make_request (get_url (p_bucket_name, l_key), 'PUT', l_header_names, l_header_values, p_object);

  check_for_errors (l_clob);

end new_object;


procedure delete_object (p_bucket_name in varchar2,
                         p_key in varchar2)
as

  l_key                          varchar2(4000) := utl_url.escape (p_key);

  l_clob                         clob;
  l_xml                          xmltype;

  l_date_str                     varchar2(255);
  l_auth_str                     varchar2(255);
  
  l_header_names                 t_str_array := t_str_array();
  l_header_values                t_str_array := t_str_array();

begin

  /*

  Purpose:   delete object

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     18.01.2011  Created
  
  */
  
  l_date_str := amazon_aws_auth_pkg.get_date_string;
  l_auth_str := amazon_aws_auth_pkg.get_auth_string ('DELETE' || chr(10) || chr(10) || chr(10) || l_date_str || chr(10) || '/' || p_bucket_name || '/' || l_key);
  
  l_header_names.extend;
  l_header_names(1) := 'Host';
  l_header_values.extend;
  l_header_values(1) := get_host(p_bucket_name);

  l_header_names.extend;
  l_header_names(2) := 'Date';
  l_header_values.extend;
  l_header_values(2) := l_date_str;

  l_header_names.extend;
  l_header_names(3) := 'Authorization';
  l_header_values.extend;
  l_header_values(3) := l_auth_str;
  
  l_clob := make_request (get_url(p_bucket_name, l_key), 'DELETE', l_header_names, l_header_values);
  
  check_for_errors (l_clob);

end delete_object;


function get_object (p_bucket_name in varchar2,
                     p_key in varchar2) return blob
as
  l_returnvalue blob;
begin

  /*

  Purpose:   get object

  Remarks:   

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     20.01.2011  Created
  
  */

  l_returnvalue := http_util_pkg.get_blob_from_url (get_download_url (p_bucket_name, p_key, sysdate + 1));

  return l_returnvalue;

end get_object;


end amazon_aws_s3_pkg;
/
