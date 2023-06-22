CREATE OR REPLACE FUNCTION public.generate_student_email()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE username VARCHAR(255);
BEGIN
	username := LOWER(NEW.first_name) || LOWER(COALESCE(NEW.middle_name,'')) || LOWER(NEW.last_name) || '-' ||
	LOWER('student') || '-' || LOWER(NEW.department) || '-' || CAST(NEW.addmission_year AS VARCHAR) || '-' ||
	CAST(NEW.graduation_year AS VARCHAR) ||'-' || RIGHT(NEW.contact_number,4);
	NEW.college_email = REPLACE(username,'-','.') || '@nsec.ac.in';
	RETURN NEW;
END;
$function$
