DECLARE
  l_attr_names   DBMS_EPG.varchar2_table;
  l_attr_values  DBMS_EPG.varchar2_table;
BEGIN
  DBMS_OUTPUT.put_line('Attributes');
  DBMS_OUTPUT.put_line('==========');

  DBMS_EPG.get_all_dad_attributes (
    dad_name    => 'mstr',
    attr_names  => l_attr_names,                       
    attr_values => l_attr_values);

  FOR i IN 1 .. l_attr_names.count LOOP
    DBMS_OUTPUT.put_line(l_attr_names(i) || '=' || l_attr_values(i));
  END LOOP;
END;
/