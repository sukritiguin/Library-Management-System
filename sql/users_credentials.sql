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
-- Name: users_credentials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users_credentials (
    id integer NOT NULL,
    username character varying(255) NOT NULL,
    password bytea
);


ALTER TABLE public.users_credentials OWNER TO postgres;

--
-- Name: users_credentials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_credentials_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_credentials_id_seq OWNER TO postgres;

--
-- Name: users_credentials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_credentials_id_seq OWNED BY public.users_credentials.id;


--
-- Name: users_credentials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_credentials ALTER COLUMN id SET DEFAULT nextval('public.users_credentials_id_seq'::regclass);


--
-- Name: users_credentials users_credentials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users_credentials
    ADD CONSTRAINT users_credentials_pkey PRIMARY KEY (username);


--
-- PostgreSQL database dump complete
--

