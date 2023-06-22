CREATE OR REPLACE FUNCTION public.generate_faculty_username()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE
  username VARCHAR(255);
BEGIN
  -- Generate the username based on the provided logic
  username := LOWER(NEW.first_name || COALESCE(NEW.middle_name, '') || NEW.last_name || '-' ||
					LOWER(REPLACE(NEW.designation,' ','')) || '-' || NEW.department || '-' || TO_CHAR(NEW.hired_date, 'YYYY-MM-DD')
					|| '-' || RIGHT(NEW.contact_number, 4));
  
  NEW.username := username; -- Set the generated username to the NEW row
  
  RETURN NEW;
END;
$function$

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

CREATE OR REPLACE FUNCTION public.update_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$function$

CREATE OR REPLACE FUNCTION public.generate_student_username()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
DECLARE username VARCHAR(255);
BEGIN
	username := LOWER(NEW.first_name) || LOWER(COALESCE(NEW.middle_name,'')) || LOWER(NEW.last_name) || '-' ||
	LOWER('student') || '-' || LOWER(NEW.department) || '-' || CAST(NEW.addmission_year AS VARCHAR) || '-' ||
	CAST(NEW.graduation_year AS VARCHAR) ||'-' || RIGHT(NEW.contact_number,4);
	NEW.username = username;
	NEW.college_email = REPLACE(username,'-','.') || '@nsec.ac.in';
	RETURN NEW;
END;
$function$

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

CREATE OR REPLACE FUNCTION public.generate_transaction_id()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
	NEW.transaction_id := TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD-HH-MI-SS') || '-' || NEW.username || '-' || NEW.isbn;
	RETURN NEW;
END;
$function$

CREATE OR REPLACE FUNCTION public.update_updated_at()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$function$
