CREATE OR REPLACE FUNCTION public.get_information_schema()
 RETURNS TABLE(table_catalog text, table_schema text, table_name text, column_name text, data_type text, character_maximum_length integer, column_default text, is_nullable text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY SELECT c.table_catalog, c.table_schema, c.table_name, c.column_name, c.data_type, c.character_maximum_length, c.column_default, c.is_nullable
                 FROM information_schema.columns c;
END;
$function$
