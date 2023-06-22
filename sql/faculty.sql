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

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: faculty; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.faculty OWNER TO postgres;

--
-- Name: faculty_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.faculty_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.faculty_id_seq OWNER TO postgres;

--
-- Name: faculty_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.faculty_id_seq OWNED BY public.faculty.id;


--
-- Name: faculty id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty ALTER COLUMN id SET DEFAULT nextval('public.faculty_id_seq'::regclass);


--
-- Name: faculty faculty_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.faculty
    ADD CONSTRAINT faculty_pkey PRIMARY KEY (username);


--
-- Name: faculty faculty_email_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER faculty_email_trigger BEFORE INSERT ON public.faculty FOR EACH ROW EXECUTE FUNCTION public.generate_faculty_email();


--
-- Name: faculty faculty_username_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER faculty_username_trigger BEFORE INSERT ON public.faculty FOR EACH ROW EXECUTE FUNCTION public.generate_faculty_username();


--
-- PostgreSQL database dump complete
--

