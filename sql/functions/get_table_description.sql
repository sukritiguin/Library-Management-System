CREATE OR REPLACE FUNCTION public.get_table_description(tablename character varying)
 RETURNS TABLE(column_name information_schema.sql_identifier, data_type character varying, is_nullable character varying)
 LANGUAGE plpgsql
AS $function$
BEGIN
  RETURN QUERY EXECUTE '
    SELECT column_name::information_schema.sql_identifier, data_type, is_nullable
    FROM information_schema.columns
    WHERE table_name = $1
    ORDER BY ordinal_position
  ' USING tablename;
END;
$function$
