--
-- PostgreSQL database dump
--

\restrict FAhSPZ5Yamc5vHB66dKVhhB0VP6PpVnKgdOpPaaQGzQVX1t6hslYPAUf4cz2wwf

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
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
-- Name: master_sessions; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.master_sessions (
    id integer NOT NULL,
    test_type_id integer NOT NULL,
    session_order integer NOT NULL,
    session_name character varying(100),
    duration integer DEFAULT 30
);


--
-- Name: master_sessions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.master_sessions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: master_sessions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.master_sessions_id_seq OWNED BY public.master_sessions.id;


--
-- Name: session_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.session_details (
    id integer NOT NULL,
    session_id integer NOT NULL,
    image_name character varying(255) NOT NULL,
    label character(1) NOT NULL
);


--
-- Name: session_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.session_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: session_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.session_details_id_seq OWNED BY public.session_details.id;


--
-- Name: test_log_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_log_details (
    id integer NOT NULL,
    log_id integer,
    session_id integer,
    correct integer NOT NULL,
    wrong integer NOT NULL
);


--
-- Name: test_log_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.test_log_details_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_log_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.test_log_details_id_seq OWNED BY public.test_log_details.id;


--
-- Name: test_logs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_logs (
    id integer NOT NULL,
    username character varying(100) NOT NULL,
    test_type_id integer,
    total_correct integer NOT NULL,
    total_wrong integer NOT NULL,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


--
-- Name: test_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.test_logs_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.test_logs_id_seq OWNED BY public.test_logs.id;


--
-- Name: test_types; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.test_types (
    id integer NOT NULL,
    test_name character varying(100) NOT NULL,
    is_active boolean DEFAULT true
);


--
-- Name: test_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.test_types_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: test_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.test_types_id_seq OWNED BY public.test_types.id;


--
-- Name: master_sessions id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_sessions ALTER COLUMN id SET DEFAULT nextval('public.master_sessions_id_seq'::regclass);


--
-- Name: session_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_details ALTER COLUMN id SET DEFAULT nextval('public.session_details_id_seq'::regclass);


--
-- Name: test_log_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_log_details ALTER COLUMN id SET DEFAULT nextval('public.test_log_details_id_seq'::regclass);


--
-- Name: test_logs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_logs ALTER COLUMN id SET DEFAULT nextval('public.test_logs_id_seq'::regclass);


--
-- Name: test_types id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_types ALTER COLUMN id SET DEFAULT nextval('public.test_types_id_seq'::regclass);


--
-- Data for Name: master_sessions; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.master_sessions (id, test_type_id, session_order, session_name, duration) FROM stdin;
1	1	1	Kolom 1	30
2	1	2	Kolom 2	30
3	1	3	Kolom 3	30
4	1	4	Kolom 4	30
\.


--
-- Data for Name: session_details; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.session_details (id, session_id, image_name, label) FROM stdin;
1	1	s1_1.png	A
2	1	s1_2.png	B
3	1	s1_3.png	C
4	1	s1_4.png	D
5	1	s1_5.png	E
6	2	s2_1.png	A
7	2	s2_2.png	B
8	2	s2_3.png	C
9	2	s2_4.png	D
10	2	s2_5.png	E
11	3	s3_1.png	A
12	3	s3_2.png	B
13	3	s3_3.png	C
14	3	s3_4.png	D
15	3	s3_5.png	E
16	4	s4_1.png	A
17	4	s4_2.png	B
18	4	s4_3.png	C
19	4	s4_4.png	D
20	4	s4_5.png	E
\.


--
-- Data for Name: test_log_details; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.test_log_details (id, log_id, session_id, correct, wrong) FROM stdin;
\.


--
-- Data for Name: test_logs; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.test_logs (id, username, test_type_id, total_correct, total_wrong, created_at) FROM stdin;
\.


--
-- Data for Name: test_types; Type: TABLE DATA; Schema: public; Owner: -
--

COPY public.test_types (id, test_name, is_active) FROM stdin;
1	Tes Kecermatan	t
\.


--
-- Name: master_sessions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.master_sessions_id_seq', 4, true);


--
-- Name: session_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.session_details_id_seq', 20, true);


--
-- Name: test_log_details_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.test_log_details_id_seq', 1, false);


--
-- Name: test_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.test_logs_id_seq', 2, true);


--
-- Name: test_types_id_seq; Type: SEQUENCE SET; Schema: public; Owner: -
--

SELECT pg_catalog.setval('public.test_types_id_seq', 1, false);


--
-- Name: master_sessions master_sessions_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_sessions
    ADD CONSTRAINT master_sessions_pkey PRIMARY KEY (id);


--
-- Name: session_details session_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_details
    ADD CONSTRAINT session_details_pkey PRIMARY KEY (id);


--
-- Name: test_log_details test_log_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_log_details
    ADD CONSTRAINT test_log_details_pkey PRIMARY KEY (id);


--
-- Name: test_logs test_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_logs
    ADD CONSTRAINT test_logs_pkey PRIMARY KEY (id);


--
-- Name: test_types test_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_types
    ADD CONSTRAINT test_types_pkey PRIMARY KEY (id);


--
-- Name: session_details fk_session; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.session_details
    ADD CONSTRAINT fk_session FOREIGN KEY (session_id) REFERENCES public.master_sessions(id) ON DELETE CASCADE;


--
-- Name: master_sessions fk_test_type; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.master_sessions
    ADD CONSTRAINT fk_test_type FOREIGN KEY (test_type_id) REFERENCES public.test_types(id) ON DELETE CASCADE;


--
-- Name: test_log_details test_log_details_log_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_log_details
    ADD CONSTRAINT test_log_details_log_id_fkey FOREIGN KEY (log_id) REFERENCES public.test_logs(id) ON DELETE CASCADE;


--
-- Name: test_log_details test_log_details_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_log_details
    ADD CONSTRAINT test_log_details_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.master_sessions(id);


--
-- Name: test_logs test_logs_test_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.test_logs
    ADD CONSTRAINT test_logs_test_type_id_fkey FOREIGN KEY (test_type_id) REFERENCES public.test_types(id);


--
-- PostgreSQL database dump complete
--

\unrestrict FAhSPZ5Yamc5vHB66dKVhhB0VP6PpVnKgdOpPaaQGzQVX1t6hslYPAUf4cz2wwf

