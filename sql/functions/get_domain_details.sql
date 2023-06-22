CREATE OR REPLACE FUNCTION public.get_domain_details(p_domain_name character varying)
 RETURNS TABLE(domain_id integer, domain_name character varying, data_type character varying, character_maximum_length integer)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT d.domain_id, d.domain_name, d.data_type, d.character_maximum_length
    FROM information_schema.domains d
    WHERE d.domain_name = p_domain_name;
END;
$function$
