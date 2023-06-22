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
-- Name: mobile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mobile (
    id integer NOT NULL,
    mobile_number character varying(15) NOT NULL
);


ALTER TABLE public.mobile OWNER TO postgres;

--
-- Name: mobile_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mobile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.mobile_id_seq OWNER TO postgres;

--
-- Name: mobile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mobile_id_seq OWNED BY public.mobile.id;


--
-- Name: mobile id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mobile ALTER COLUMN id SET DEFAULT nextval('public.mobile_id_seq'::regclass);


--
-- Name: mobile mobile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mobile
    ADD CONSTRAINT mobile_pkey PRIMARY KEY (mobile_number);


--
-- PostgreSQL database dump complete
--

