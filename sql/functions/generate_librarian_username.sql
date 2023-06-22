CREATE OR REPLACE FUNCTION public.generate_librarian_username()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  username VARCHAR(255);
BEGIN
  username := LOWER(NEW.first_name) || LOWER(COALESCE(NEW.middle_name,'')) || LOWER(NEW.last_name) || '-' ||
              LOWER('librarian') || '-' || TO_CHAR(NEW.hired_date, 'YYYY-MM-DD') || '-' ||
			  RIGHT(NEW.contact_number,4);
  NEW.username := username;
  RETURN NEW;
END;
$function$
