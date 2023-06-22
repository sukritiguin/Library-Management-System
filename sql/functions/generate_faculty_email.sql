CREATE OR REPLACE FUNCTION public.generate_faculty_email()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  username VARCHAR(255);
BEGIN
  -- Generate the username based on the provided logic
    -- Generate the username based on the provided logic
  username := LOWER(NEW.first_name || COALESCE(NEW.middle_name, '') || NEW.last_name || '-' ||
					LOWER(REPLACE(NEW.designation,' ','')) || '-' || NEW.department || '-' || TO_CHAR(NEW.hired_date, 'YYYY-MM-DD')
					|| '-' || RIGHT(NEW.contact_number, 4));
  NEW.college_email := REPLACE(username,'-','.') || '@nsec.ac.in';
  
  RETURN NEW;
END;
$function$
