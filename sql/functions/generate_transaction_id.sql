CREATE OR REPLACE FUNCTION public.generate_transaction_id()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
	NEW.transaction_id := TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD-HH-MI-SS') || '-' || NEW.username || '-' || NEW.isbn;
	RETURN NEW;
END;
$function$
