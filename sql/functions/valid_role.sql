CREATE OR REPLACE FUNCTION public.valid_role(role_value character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF role_value NOT IN ('faculty', 'student', 'librarian') THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END;
$function$
