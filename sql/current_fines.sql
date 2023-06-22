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
-- Name: current_fines; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.current_fines (
    id integer NOT NULL,
    transaction_id character varying(255) NOT NULL,
    fine_amount numeric(10,2) NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.current_fines OWNER TO postgres;

--
-- Name: current_fines_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.current_fines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.current_fines_id_seq OWNER TO postgres;

--
-- Name: current_fines_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.current_fines_id_seq OWNED BY public.current_fines.id;


--
-- Name: current_fines id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_fines ALTER COLUMN id SET DEFAULT nextval('public.current_fines_id_seq'::regclass);


--
-- Name: current_fines current_fines_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_fines
    ADD CONSTRAINT current_fines_pkey PRIMARY KEY (transaction_id);


--
-- Name: current_fines current_fines_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.current_fines
    ADD CONSTRAINT current_fines_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id);


--
-- PostgreSQL database dump complete
--

