--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: apikey; Type: TABLE; Schema: public; Owner: europeana; Tablespace: 
--

CREATE TABLE apikey (
    apikey character varying(30) NOT NULL,
    appname character varying(255),
    privatekey character varying(30) NOT NULL,
    usagelimit bigint,
    userid bigint
);


ALTER TABLE public.apikey OWNER TO europeana;

--
-- Name: hibernate_sequence; Type: SEQUENCE; Schema: public; Owner: europeana
--

CREATE SEQUENCE hibernate_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hibernate_sequence OWNER TO europeana;

--
-- Name: saveditem; Type: TABLE; Schema: public; Owner: europeana; Tablespace: 
--

CREATE TABLE saveditem (
    id bigint NOT NULL,
    datesaved timestamp without time zone,
    doctype character varying(10),
    europeanaobject character varying(256),
    europeanauri character varying(256),
    title character varying(120),
    author character varying(80),
    userid bigint
);


ALTER TABLE public.saveditem OWNER TO europeana;

--
-- Name: savedsearch; Type: TABLE; Schema: public; Owner: europeana; Tablespace: 
--

CREATE TABLE savedsearch (
    id bigint NOT NULL,
    datesaved timestamp without time zone,
    query character varying(200),
    querystring character varying(200),
    userid bigint
);


ALTER TABLE public.savedsearch OWNER TO europeana;

--
-- Name: socialtag; Type: TABLE; Schema: public; Owner: europeana; Tablespace: 
--

CREATE TABLE socialtag (
    id bigint NOT NULL,
    datesaved timestamp without time zone,
    doctype character varying(10),
    europeanaobject character varying(256),
    europeanauri character varying(256),
    title character varying(120),
    tag character varying(60),
    userid bigint
);


ALTER TABLE public.socialtag OWNER TO europeana;

--
-- Name: token; Type: TABLE; Schema: public; Owner: europeana; Tablespace: 
--

CREATE TABLE token (
    token character varying(32) NOT NULL,
    created bigint NOT NULL,
    email character varying(100) NOT NULL
);


ALTER TABLE public.token OWNER TO europeana;

--
-- Name: users; Type: TABLE; Schema: public; Owner: europeana; Tablespace: 
--

CREATE TABLE users (
    id bigint NOT NULL,
    address character varying(250),
    apikey character varying(30),
    company character varying(100),
    country character varying(30),
    email character varying(100) NOT NULL,
    fieldofwork character varying(50),
    firstname character varying(30),
    languageitem character varying(20),
    languageportal character varying(20),
    languagesearch character varying(20),
    lastlogin timestamp without time zone,
    lastname character varying(50),
    password character varying(64),
    phone character varying(15),
    registrationdate date,
    role character varying(25),
    username character varying(60),
    website character varying(100),
    languagesearchapplied boolean
);


ALTER TABLE public.users OWNER TO europeana;

--
-- Data for Name: apikey; Type: TABLE DATA; Schema: public; Owner: europeana
--

COPY apikey (apikey, appname, privatekey, usagelimit, userid) FROM stdin;
api2demo	anythingsomethingsilly	verysecret	200000	11
\.


--
-- Name: hibernate_sequence; Type: SEQUENCE SET; Schema: public; Owner: europeana
--

SELECT pg_catalog.setval('hibernate_sequence', 1, true);


--
-- Data for Name: saveditem; Type: TABLE DATA; Schema: public; Owner: europeana
--

COPY saveditem (id, datesaved, doctype, europeanaobject, europeanauri, title, author, userid) FROM stdin;
\.


--
-- Data for Name: savedsearch; Type: TABLE DATA; Schema: public; Owner: europeana
--

COPY savedsearch (id, datesaved, query, querystring, userid) FROM stdin;
\.


--
-- Data for Name: socialtag; Type: TABLE DATA; Schema: public; Owner: europeana
--

COPY socialtag (id, datesaved, doctype, europeanaobject, europeanauri, title, tag, userid) FROM stdin;
\.


--
-- Data for Name: token; Type: TABLE DATA; Schema: public; Owner: europeana
--

COPY token (token, created, email) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: europeana
--

COPY users (id, address, apikey, company, country, email, fieldofwork, firstname, languageitem, languageportal, languagesearch, lastlogin, lastname, password, phone, registrationdate, role, username, website, languagesearchapplied) FROM stdin;
11	\N	\N	\N	Netherlands	development@europeana.eu	Non profit organization/Government	Development	\N	\N	\N	\N	\N	3ea68ed693321b405636672fb1c2bf30a7e7fec8	Europeana	2012-10-29	ROLE_USER	development	\N	\N
\.


--
-- Name: apikey_pkey; Type: CONSTRAINT; Schema: public; Owner: europeana; Tablespace: 
--

ALTER TABLE ONLY apikey
    ADD CONSTRAINT apikey_pkey PRIMARY KEY (apikey);


--
-- Name: saveditem_pkey; Type: CONSTRAINT; Schema: public; Owner: europeana; Tablespace: 
--

ALTER TABLE ONLY saveditem
    ADD CONSTRAINT saveditem_pkey PRIMARY KEY (id);


--
-- Name: savedsearch_pkey; Type: CONSTRAINT; Schema: public; Owner: europeana; Tablespace: 
--

ALTER TABLE ONLY savedsearch
    ADD CONSTRAINT savedsearch_pkey PRIMARY KEY (id);


--
-- Name: socialtag_pkey; Type: CONSTRAINT; Schema: public; Owner: europeana; Tablespace: 
--

ALTER TABLE ONLY socialtag
    ADD CONSTRAINT socialtag_pkey PRIMARY KEY (id);


--
-- Name: token_pkey; Type: CONSTRAINT; Schema: public; Owner: europeana; Tablespace: 
--

ALTER TABLE ONLY token
    ADD CONSTRAINT token_pkey PRIMARY KEY (token);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: europeana; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: europeana; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: apikey_index; Type: INDEX; Schema: public; Owner: europeana; Tablespace: 
--

CREATE INDEX apikey_index ON users USING btree (apikey);


--
-- Name: email_index; Type: INDEX; Schema: public; Owner: europeana; Tablespace: 
--

CREATE INDEX email_index ON users USING btree (email);


--
-- Name: username_index; Type: INDEX; Schema: public; Owner: europeana; Tablespace: 
--

CREATE INDEX username_index ON users USING btree (username);


--
-- Name: fk4a917ccd7b0beffb; Type: FK CONSTRAINT; Schema: public; Owner: europeana
--

ALTER TABLE ONLY socialtag
    ADD CONSTRAINT fk4a917ccd7b0beffb FOREIGN KEY (userid) REFERENCES users(id);


--
-- Name: fk66aa26ef7b0beffb; Type: FK CONSTRAINT; Schema: public; Owner: europeana
--

ALTER TABLE ONLY savedsearch
    ADD CONSTRAINT fk66aa26ef7b0beffb FOREIGN KEY (userid) REFERENCES users(id);


--
-- Name: fk829ee21a7b0beffb; Type: FK CONSTRAINT; Schema: public; Owner: europeana
--

ALTER TABLE ONLY saveditem
    ADD CONSTRAINT fk829ee21a7b0beffb FOREIGN KEY (userid) REFERENCES users(id);


--
-- Name: fkabe1b6057b0beffb; Type: FK CONSTRAINT; Schema: public; Owner: europeana
--

ALTER TABLE ONLY apikey
    ADD CONSTRAINT fkabe1b6057b0beffb FOREIGN KEY (userid) REFERENCES users(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

