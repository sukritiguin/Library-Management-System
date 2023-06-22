CREATE OR REPLACE FUNCTION public.generate_librarian_email()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  username VARCHAR(255);
BEGIN
  username := LOWER(NEW.first_name) || LOWER(COALESCE(NEW.middle_name,'')) || LOWER(NEW.last_name) || '-' ||
              LOWER('librarian') || '-' || TO_CHAR(NEW.hired_date, 'YYYY-MM-DD') || '-' ||
			  RIGHT(NEW.contact_number,4);
  NEW.college_email := REPLACE(username,'-','.') || '@nsec.ac.in';
  RETURN NEW;
END;
$function$
