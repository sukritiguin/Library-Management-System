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
-- Name: fines_collected; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.fines_collected (
    id integer NOT NULL,
    transaction_id character varying(255) NOT NULL,
    over_due_days integer NOT NULL,
    amount numeric(10,2) NOT NULL,
    collected_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.fines_collected OWNER TO postgres;

--
-- Name: fines_collected_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.fines_collected_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.fines_collected_id_seq OWNER TO postgres;

--
-- Name: fines_collected_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.fines_collected_id_seq OWNED BY public.fines_collected.id;


--
-- Name: fines_collected id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fines_collected ALTER COLUMN id SET DEFAULT nextval('public.fines_collected_id_seq'::regclass);


--
-- Name: fines_collected fines_collected_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fines_collected
    ADD CONSTRAINT fines_collected_pkey PRIMARY KEY (transaction_id);


--
-- Name: fines_collected fines_collected_transaction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.fines_collected
    ADD CONSTRAINT fines_collected_transaction_id_fkey FOREIGN KEY (transaction_id) REFERENCES public.transactions(transaction_id);


--
-- PostgreSQL database dump complete
--

