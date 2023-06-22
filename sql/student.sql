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
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
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


ALTER TABLE public.student OWNER TO postgres;

--
-- Name: student_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.student_id_seq OWNER TO postgres;

--
-- Name: student_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_id_seq OWNED BY public.student.id;


--
-- Name: student id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student ALTER COLUMN id SET DEFAULT nextval('public.student_id_seq'::regclass);


--
-- Name: student student_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pkey PRIMARY KEY (username);


--
-- Name: student student_email_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER student_email_trigger BEFORE INSERT ON public.student FOR EACH ROW EXECUTE FUNCTION public.generate_student_email();


--
-- Name: student student_username_trigger; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER student_username_trigger BEFORE INSERT ON public.student FOR EACH ROW EXECUTE FUNCTION public.generate_student_username();


--
-- PostgreSQL database dump complete
--

