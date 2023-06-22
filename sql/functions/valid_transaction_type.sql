CREATE OR REPLACE FUNCTION public.valid_transaction_type(transaction_type character varying)
 RETURNS boolean
 LANGUAGE plpgsql
AS $function$
BEGIN
  IF transaction_type NOT IN ('borrowed','returned') THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END;
$function$
