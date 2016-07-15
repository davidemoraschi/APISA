CREATE OR REPLACE package apex_util_pkg
as
 
  /*
 
  Purpose:      package provides general Apex utilities
 
  Remarks:
 
  Who     Date        Description
  ------  ----------  --------------------------------
  FDL     12.06.2008  Created
 
  */
 

  g_apex_null_str                constant varchar2(6) := chr(37) || 'null' || chr(37);
  g_apex_undefined_str           constant varchar2(9) := 'undefined';
  g_apex_list_separator          constant varchar2(1) := ':';
  
  -- use these in combination with apex_util.ir_filter
  g_ir_filter_equals             constant varchar2(10) := 'EQ';
  g_ir_filter_less_than          constant varchar2(10) := 'LT';
  g_ir_filter_less_than_or_eq    constant varchar2(10) := 'LTE';
  g_ir_filter_greater_than       constant varchar2(10) := 'GT';
  g_ir_filter_greater_than_or_eq constant varchar2(10) := 'GTE';
  g_ir_filter_like               constant varchar2(10) := 'LIKE';
  g_ir_filter_null               constant varchar2(10) := 'N';
  g_ir_filter_not_null           constant varchar2(10) := 'NN';

  g_ir_reset                     constant varchar2(10) := 'RIR';

  -- get page name
  function get_page_name (p_application_id in number,
                          p_page_id in number) return varchar2;

  -- get item name for page and item
  function get_item_name (p_page_id in number,
                          p_item_name in varchar2) return varchar2;

  -- get page help text
  function get_page_help_text (p_application_id in number,
                               p_page_id in number) return varchar2;
 
   -- return apex url
  function get_apex_url (p_page_id in varchar2,
                         p_request in varchar2 := null,
                         p_item_names in varchar2 := null,
                         p_item_values in varchar2 := null,
                         p_debug in varchar2 := null,
                         p_application_id in varchar2 := null,
                         p_session_id in number := null,
                         p_clear_cache in varchar2 := null) return varchar2;
                         
   -- return apex url (simple syntax)
  function get_apex_url_simple (p_page_id in varchar2,
                                p_item_name in varchar2 := null,
                                p_item_value in varchar2 := null,
                                p_request in varchar2 := null) return varchar2;

    -- get apex url item names
  function get_apex_url_item_names (p_page_id in number,
                                    p_item_name_array in t_str_array) return varchar2;

  -- get item values
  function get_apex_url_item_values (p_item_value_array in t_str_array) return varchar2;
  
  -- get query of dynamic lov
  function get_dynamic_lov_query (p_application_id in number,
                                  p_lov_name in varchar2) return varchar2;
                                  
  -- set Apex security context
  procedure set_apex_security_context (p_schema in varchar2);
  
  -- setup Apex session context
  procedure setup_apex_session_context (p_application_id in number);
  
  -- get string value
  function get_str_value (p_str in varchar2) return varchar2;
 
  -- get number value
  function get_num_value (p_str in varchar2) return number;

  -- get date value
  function get_date_value (p_str in varchar2) return date;

  -- set Apex item value (string)
  procedure set_item (p_page_id in varchar2,
                      p_item_name in varchar2,
                      p_value in varchar2);
 
  -- set Apex item value (date)
  procedure set_date_item (p_page_id in varchar2,
                           p_item_name in varchar2,
                           p_value in date,
                           p_date_format in varchar2 := null);

  -- get Apex item value (string)
  function get_item (p_page_id in varchar2,
                     p_item_name in varchar2,
                     p_max_length in number := null) return varchar2;
 
  -- get Apex item value (number)
  function get_num_item (p_page_id in varchar2,
                         p_item_name in varchar2) return number;

  -- get Apex item value (date)
  function get_date_item (p_page_id in varchar2,
                          p_item_name in varchar2) return date;

  -- get multiple item values from page into custom record type
  procedure get_items (p_app_id in number,
                       p_page_id in number,
                       p_target in varchar2,
                       p_exclude_items in t_str_array := null);
 
  -- set multiple item values on page based on custom record type
  procedure set_items (p_app_id in number,
                       p_page_id in number,
                       p_source in varchar2,
                       p_exclude_items in t_str_array := null);

  -- return true if item is in list
  function is_item_in_list (p_item in varchar2,
                            p_list in apex_application_global.vc_arr2) return boolean;

  -- get Apex session value
  function get_apex_session_value (p_value_name in varchar2) return varchar2;


end apex_util_pkg;
/
CREATE OR REPLACE package amazon_aws_auth_pkg
as

  /*

  Purpose:   PL/SQL wrapper package for Amazon AWS authentication API

  Remarks:   inspired by the whitepaper "Building an Amazon S3 Client with Application Express 4.0" by Jason Straub
             see http://jastraub.blogspot.com/2011/01/building-amazon-s3-client-with.html
             
             dependencies: owner of this package needs execute on dbms_crypto 

  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */
  
  -- get "Authorization" (actually authentication) header string
  function get_auth_string (p_string in varchar2) return varchar2;

  -- get signature string
  function get_signature (p_string in varchar2) return varchar2;

  -- get AWS access key ID
  function get_aws_id return varchar2;
  
  -- get date string
  function get_date_string (p_date in date := sysdate) return varchar2;
  
  -- get epoch (number of seconds since January 1, 1970)
  function get_epoch (p_date in date) return number;
  
  -- set AWS access key id
  procedure set_aws_id (p_aws_id in varchar2);
  
  -- set AWS secret key
  procedure set_aws_key (p_aws_key in varchar2);

  -- set GMT offset
  procedure set_gmt_offset (p_gmt_offset in number);

  -- initialize package for use
  procedure init (p_aws_id in varchar2,
                  p_aws_key in varchar2,
                  p_gmt_offset in number := null);

end amazon_aws_auth_pkg;
/
CREATE OR REPLACE package amazon_aws_s3_pkg
as

  /*

  Purpose:   PL/SQL wrapper package for Amazon AWS S3 API

  Remarks:   inspired by the whitepaper "Building an Amazon S3 Client with Application Express 4.0" by Jason Straub
             see http://jastraub.blogspot.com/2011/01/building-amazon-s3-client-with.html
             
  Who     Date        Description
  ------  ----------  -------------------------------------
  MBR     09.01.2011  Created
  
  */

  type t_bucket is record (
    bucket_name varchar2(255),
    creation_date date
  );

  type t_bucket_list is table of t_bucket index by binary_integer;
  type t_bucket_tab is table of t_bucket;
  
  type t_object is record (
    key varchar2(4000),
    size_bytes number,
    last_modified date
  );

  type t_object_list is table of t_object index by binary_integer;
  type t_object_tab is table of t_object;
  
  
  -- bucket regions (see http://aws.amazon.com/articles/3912?_encoding=UTF8&jiveRedirect=1#s3)

  g_region_us_standard           constant varchar2(255) := null;
  g_region_eu                    constant varchar2(255) := 'EU';
  g_region_us_west_1             constant varchar2(255) := 'us-west-1';
  g_region_asia_pacific_1        constant varchar2(255) := 'ap-southeast-1';
  
  -- predefined access policies (see http://docs.amazonwebservices.com/AmazonS3/latest/dev/index.html?RESTAccessPolicy.html )

  g_acl_private                  constant varchar2(255) := 'private';
  g_acl_public_read              constant varchar2(255) := 'public-read';
  g_acl_public_read_write        constant varchar2(255) := 'public-read-write';
  g_acl_authenticated_read       constant varchar2(255) := 'authenticated-read';
  g_acl_bucket_owner_read        constant varchar2(255) := 'bucket-owner-read';
  g_acl_bucket_owner_full_ctrl   constant varchar2(255) := 'bucket-owner-full-control';

  -- get buckets
  function get_bucket_list return t_bucket_list;

  -- get buckets
  function get_bucket_tab return t_bucket_tab pipelined;
  
  -- create bucket
  procedure new_bucket (p_bucket_name in varchar2,
                        p_region in varchar2 := null);

  -- get bucket region
  function get_bucket_region (p_bucket_name in varchar2) return varchar2;

  -- get objects
  function get_object_list (p_bucket_name in varchar2,
                            p_prefix in varchar2 := null,
                            p_max_keys in number := null) return t_object_list;

  -- get objects
  function get_object_tab (p_bucket_name in varchar2,
                           p_prefix in varchar2 := null,
                           p_max_keys in number := null) return t_object_tab pipelined;

  -- get download URL
  function get_download_url (p_bucket_name in varchar2,
                             p_key in varchar2,
                             p_expiry_date in date) return varchar2;

  -- new object
  procedure new_object (p_bucket_name in varchar2,
                        p_key in varchar2,
                        p_object in blob,
                        p_content_type in varchar2,
                        p_acl in varchar2 := null);
                        
  -- delete object
  procedure delete_object (p_bucket_name in varchar2,
                           p_key in varchar2);

  -- get object
  function get_object (p_bucket_name in varchar2,
                       p_key in varchar2) return blob;

end amazon_aws_s3_pkg;
/
