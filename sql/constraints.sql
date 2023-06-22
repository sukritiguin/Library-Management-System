--
-- PostgreSQL database dump
--

-- Dumped from database version 15.2
-- Dumped by pg_dump version 15.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: public; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA public;


--
-- Name: department_enum; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.department_enum AS character varying(255)
	CONSTRAINT department_enum_check CHECK (((VALUE)::text = ANY ((ARRAY['ECE'::character varying, 'CSE'::character varying, 'IT'::character varying, 'EE'::character varying, 'ME'::character varying, 'CE'::character varying, 'DS'::character varying, 'AIML'::character varying, 'BCA'::character varying, 'MCA'::character varying])::text[])));


--
-- Name: designation_enum; Type: DOMAIN; Schema: public; Owner: -
--

CREATE DOMAIN public.designation_enum AS character varying(255)
	CONSTRAINT designation_enum_check CHECK (((VALUE)::text = ANY ((ARRAY['HOD'::character varying, 'Assistant Professor'::character varying, 'Lab Assistant'::character varying, 'Professor'::character varying, 'Associate Professor'::character varying, 'Visiting Faculty'::character varying, 'Lecturer'::character varying, 'Researcher'::character varying])::text[])));


--
-- Name: generate_faculty_email(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_faculty_email() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


--
-- Name: generate_faculty_username(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_faculty_username() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
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
$$;


--
-- Name: generate_librarian_email(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_librarian_email() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  username VARCHAR(255);
BEGIN
  username := LOWER(NEW.first_name) || LOWER(COALESCE(NEW.middle_name,'')) || LOWER(NEW.last_name) || '-' ||
              LOWER('librarian') || '-' || TO_CHAR(NEW.hired_date, 'YYYY-MM-DD') || '-' ||
			  RIGHT(NEW.contact_number,4);
  NEW.college_email := REPLACE(username,'-','.') || '@nsec.ac.in';
  RETURN NEW;
END;
$$;


--
-- Name: generate_librarian_username(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_librarian_username() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  username VARCHAR(255);
BEGIN
  username := LOWER(NEW.first_name) || LOWER(COALESCE(NEW.middle_name,'')) || LOWER(NEW.last_name) || '-' ||
              LOWER('librarian') || '-' || TO_CHAR(NEW.hired_date, 'YYYY-MM-DD') || '-' ||
			  RIGHT(NEW.contact_number,4);
  NEW.username := username;
  RETURN NEW;
END;
$$;


--
-- Name: generate_student_email(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_student_email() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE username VARCHAR(255);
BEGIN
	username := LOWER(NEW.first_name) || LOWER(COALESCE(NEW.middle_name,'')) || LOWER(NEW.last_name) || '-' ||
	LOWER('student') || '-' || LOWER(NEW.department) || '-' || CAST(NEW.addmission_year AS VARCHAR) || '-' ||
	CAST(NEW.graduation_year AS VARCHAR) ||'-' || RIGHT(NEW.contact_number,4);
	NEW.college_email = REPLACE(username,'-','.') || '@nsec.ac.in';
	RETURN NEW;
END;
$$;


--
-- Name: generate_student_username(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_student_username() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
DECLARE username VARCHAR(255);
BEGIN
	username := LOWER(NEW.first_name) || LOWER(COALESCE(NEW.middle_name,'')) || LOWER(NEW.last_name) || '-' ||
	LOWER('student') || '-' || LOWER(NEW.department) || '-' || CAST(NEW.addmission_year AS VARCHAR) || '-' ||
	CAST(NEW.graduation_year AS VARCHAR) ||'-' || RIGHT(NEW.contact_number,4);
	NEW.username = username;
	NEW.college_email = REPLACE(username,'-','.') || '@nsec.ac.in';
	RETURN NEW;
END;
$$;


--
-- Name: generate_transaction_id(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.generate_transaction_id() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
	NEW.transaction_id := TO_CHAR(CURRENT_TIMESTAMP, 'YYYY-MM-DD-HH-MI-SS') || '-' || NEW.username || '-' || NEW.isbn;
	RETURN NEW;
END;
$$;


--
-- Name: get_domain_details(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_domain_details(p_domain_name character varying) RETURNS TABLE(domain_id integer, domain_name character varying, data_type character varying, character_maximum_length integer)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY
    SELECT d.domain_id, d.domain_name, d.data_type, d.character_maximum_length
    FROM information_schema.domains d
    WHERE d.domain_name = p_domain_name;
END;
$$;


--
-- Name: get_information_schema(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_information_schema() RETURNS TABLE(table_catalog text, table_schema text, table_name text, column_name text, data_type text, character_maximum_length integer, column_default text, is_nullable text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    RETURN QUERY SELECT c.table_catalog, c.table_schema, c.table_name, c.column_name, c.data_type, c.character_maximum_length, c.column_default, c.is_nullable
                 FROM information_schema.columns c;
END;
$$;


--
-- Name: get_table_description(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.get_table_description(tablename character varying) RETURNS TABLE(column_name information_schema.sql_identifier, data_type character varying, is_nullable character varying)
    LANGUAGE plpgsql
    AS $_$
BEGIN
  RETURN QUERY EXECUTE '
    SELECT column_name::information_schema.sql_identifier, data_type, is_nullable
    FROM information_schema.columns
    WHERE table_name = $1
    ORDER BY ordinal_position
  ' USING tablename;
END;
$_$;


--
-- Name: update_updated_at(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.update_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
  NEW.updated_at := CURRENT_TIMESTAMP;
  RETURN NEW;
END;
$$;


--
-- Name: valid_role(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.valid_role(role_value character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF role_value NOT IN ('faculty', 'student', 'librarian') THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END;
$$;


--
-- Name: valid_transaction_type(character varying); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.valid_transaction_type(transaction_type character varying) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
BEGIN
  IF transaction_type NOT IN ('borrowed','returned') THEN
    RETURN FALSE;
  ELSE
    RETURN TRUE;
  END IF;
END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: books; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.books (
    id integer NOT NULL,
    title character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    isbn character varying(255) NOT NULL,
    publication_year integer NOT NULL,
    edition character varying(255),
    description text,
    total_copies integer NOT NULL,
    available_copies integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT books_available_copies_check CHECK ((available_copies >= 0)),
    CONSTRAINT books_total_copies_check CHECK ((total_copies >= 1))
);


--
-- Name: books_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.books_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: books_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.books_id_seq OWNED BY public.books.id;


--
-- Name: current_fines; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.current_fines (
    id integer NOT NULL,
    transaction_id character varying(255) NOT NULL,
    fine_amount numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: current_fines_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.current_fines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: current_fines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.current_fines_id_seq OWNED BY public.current_fines.id;


--
-- Name: email; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.email (
    id integer NOT NULL,
    email_address character varying(255) NOT NULL
);


--
-- Name: email_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.email_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: email_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.email_id_seq OWNED BY public.email.id;


--
-- Name: faculty; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.faculty (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    middle_name character varying(255),
    last_name character varying(255) NOT NULL,
    contact_number character varying(15) NOT NULL,
    personal_email character varying(255) NOT NULL,
    college_email character varying(255) NOT NULL,
    department public.department_enum NOT NULL,
    designation public.designation_enum NOT NULL,
    hired_date date NOT NULL,
    current_address character varying(255) NOT NULL,
    address character varying(255) NOT NULL
);


--
-- Name: faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.faculty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.faculty_id_seq OWNED BY public.faculty.id;


--
-- Name: fines_collected; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.fines_collected (
    id integer NOT NULL,
    transaction_id character varying(255) NOT NULL,
    over_due_days integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    collected_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


--
-- Name: fines_collected_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.fines_collected_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: fines_collected_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.fines_collected_id_seq OWNED BY public.fines_collected.id;


--
-- Name: librarian; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.librarian (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    middle_name character varying(255),
    last_name character varying(255) NOT NULL,
    contact_number character varying(15) NOT NULL,
    personal_email character varying(255) NOT NULL,
    college_email character varying(255) NOT NULL,
    hired_date date NOT NULL,
    current_address character varying(255) NOT NULL,
    address character varying(255) NOT NULL
);


--
-- Name: librarian_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.librarian_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: librarian_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.librarian_id_seq OWNED BY public.librarian.id;


--
-- Name: mobile; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mobile (
    id integer NOT NULL,
    mobile_number character varying(15) NOT NULL
);


--
-- Name: mobile_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mobile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mobile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mobile_id_seq OWNED BY public.mobile.id;


--
-- Name: role_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.role_types (
    id integer NOT NULL,
    role character varying(255) NOT NULL
);


--
-- Name: role_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.role_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: role_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.role_types_id_seq OWNED BY public.role_types.id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.student (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    first_name character varying(255) NOT NULL,
    middle_name character varying(255),
    last_name character varying(255) NOT NULL,
    contact_number character varying(15) NOT NULL,
    parent_number character varying(15) NOT NULL,
    personal_email character varying(255) NOT NULL,
    college_email character varying(255) NOT NULL,
    department public.department_enum NOT NULL,
    addmission_year integer NOT NULL,
    graduation_year integer NOT NULL,
    current_address character varying(255) NOT NULL,
    address character varying(255) NOT NULL
);


--
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.student_id_seq OWNED BY public.student.id;


--
-- Name: transaction_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transaction_types (
    id integer NOT NULL,
    status character varying(255) NOT NULL
);


--
-- Name: transaction_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transaction_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transaction_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transaction_types_id_seq OWNED BY public.transaction_types.id;


--
-- Name: transactions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.transactions (
    id integer NOT NULL,
    transaction_id character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    isbn character varying(255) NOT NULL,
    transaction_status character varying(255) NOT NULL,
    borrowed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    returned_at timestamp without time zone,
    issued_by character varying(255) NOT NULL,
    returned_by character varying(255),
    CONSTRAINT valid_transaction_type CHECK (public.valid_transaction_type(transaction_status))
);


--
-- Name: transactions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.transactions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: transactions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.transactions_id_seq OWNED BY public.transactions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id integer NOT NULL,
    first_name character varying(255) NOT NULL,
    last_name character varying(255) NOT NULL,
    username character varying(255) NOT NULL,
    email character varying(255) NOT NULL,
    role character varying(255) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT valid_role CHECK (public.valid_role(role))
);


--
-- Name: users_credentials; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users_credentials (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    password bytea
);


--
-- Name: users_credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_credentials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_credentials_id_seq OWNED BY public.users_credentials.id;


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: books id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books ALTER COLUMN id SET DEFAULT nextval('public.books_id_seq'::regclass);


--
-- Name: current_fines id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.current_fines ALTER COLUMN id SET DEFAULT nextval('public.current_fines_id_seq'::regclass);


--
-- Name: email id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email ALTER COLUMN id SET DEFAULT nextval('public.email_id_seq'::regclass);


--
-- Name: faculty id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty ALTER COLUMN id SET DEFAULT nextval('public.faculty_id_seq'::regclass);


--
-- Name: fines_collected id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fines_collected ALTER COLUMN id SET DEFAULT nextval('public.fines_collected_id_seq'::regclass);


--
-- Name: librarian id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.librarian ALTER COLUMN id SET DEFAULT nextval('public.librarian_id_seq'::regclass);


--
-- Name: mobile id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile ALTER COLUMN id SET DEFAULT nextval('public.mobile_id_seq'::regclass);


--
-- Name: role_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_types ALTER COLUMN id SET DEFAULT nextval('public.role_types_id_seq'::regclass);


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_id_seq'::regclass);


--
-- Name: transaction_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_types ALTER COLUMN id SET DEFAULT nextval('public.transaction_types_id_seq'::regclass);


--
-- Name: transactions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions ALTER COLUMN id SET DEFAULT nextval('public.transactions_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: users_credentials id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_credentials ALTER COLUMN id SET DEFAULT nextval('public.users_credentials_id_seq'::regclass);


--
-- Name: books books_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.books
    ADD CONSTRAINT books_pkey PRIMARY KEY (isbn);


--
-- Name: current_fines current_fines_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.current_fines
    ADD CONSTRAINT current_fines_pkey PRIMARY KEY (transaction_id);


--
-- Name: email email_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.email
    ADD CONSTRAINT email_pkey PRIMARY KEY (email_address);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (username);


--
-- Name: fines_collected fines_collected_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fines_collected
    ADD CONSTRAINT fines_collected_pkey PRIMARY KEY (transaction_id);


--
-- Name: librarian librarian_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.librarian
    ADD CONSTRAINT librarian_pkey PRIMARY KEY (username);


--
-- Name: mobile mobile_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mobile
    ADD CONSTRAINT mobile_pkey PRIMARY KEY (mobile_number);


--
-- Name: role_types role_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.role_types
    ADD CONSTRAINT role_types_pkey PRIMARY KEY (id);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (username);


--
-- Name: transaction_types transaction_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transaction_types
    ADD CONSTRAINT transaction_types_pkey PRIMARY KEY (id);


--
-- Name: transactions transactions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_pkey PRIMARY KEY (transaction_id);


--
-- Name: transactions unique_user_isbn; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT unique_user_isbn UNIQUE (username, isbn);


--
-- Name: users_credentials users_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users_credentials
    ADD CONSTRAINT users_credentials_pkey PRIMARY KEY (username);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (username);


--
-- Name: books books_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER books_updated_at_trigger BEFORE UPDATE ON public.books FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();


--
-- Name: faculty faculty_email_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER faculty_email_trigger BEFORE INSERT ON public.faculty FOR EACH ROW EXECUTE FUNCTION public.generate_faculty_email();


--
-- Name: faculty faculty_username_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER faculty_username_trigger BEFORE INSERT ON public.faculty FOR EACH ROW EXECUTE FUNCTION public.generate_faculty_username();


--
-- Name: librarian librarian_email_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER librarian_email_trigger BEFORE INSERT ON public.librarian FOR EACH ROW EXECUTE FUNCTION public.generate_librarian_email();


--
-- Name: librarian librarian_username_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER librarian_username_trigger BEFORE INSERT ON public.librarian FOR EACH ROW EXECUTE FUNCTION public.generate_librarian_username();


--
-- Name: student student_email_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER student_email_trigger BEFORE INSERT ON public.student FOR EACH ROW EXECUTE FUNCTION public.generate_student_email();


--
-- Name: student student_username_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER student_username_trigger BEFORE INSERT ON public.student FOR EACH ROW EXECUTE FUNCTION public.generate_student_username();


--
-- Name: transactions transactions_generate_id; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER transactions_generate_id BEFORE INSERT ON public.transactions FOR EACH ROW EXECUTE FUNCTION public.generate_transaction_id();

ALTER TABLE public.transactions DISABLE TRIGGER transactions_generate_id;


--
-- Name: users users_updated_at_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER users_updated_at_trigger BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.update_updated_at();

ALTER TABLE public.users DISABLE TRIGGER users_updated_at_trigger;


--
-- Name: current_fines current_fines_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.current_fines
    ADD CONSTRAINT current_fines_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id);


--
-- Name: fines_collected fines_collected_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.fines_collected
    ADD CONSTRAINT fines_collected_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id);


--
-- Name: transactions transactions_isbn_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_isbn_fkey FOREIGN KEY (isbn) REFERENCES public.books(isbn);


--
-- Name: transactions transactions_username_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.transactions
    ADD CONSTRAINT transactions_username_fkey FOREIGN KEY (username) REFERENCES public.users(username);


--
-- PostgreSQL database dump complete
--

