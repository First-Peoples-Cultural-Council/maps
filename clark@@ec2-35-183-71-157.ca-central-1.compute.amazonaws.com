--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2 (Debian 11.2-1.pgdg90+1)
-- Dumped by pg_dump version 11.2 (Debian 11.2-1.pgdg90+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: tiger; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger;


ALTER SCHEMA tiger OWNER TO postgres;

--
-- Name: tiger_data; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA tiger_data;


ALTER SCHEMA tiger_data OWNER TO postgres;

--
-- Name: topology; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA topology;


ALTER SCHEMA topology OWNER TO postgres;

--
-- Name: SCHEMA topology; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON SCHEMA topology IS 'PostGIS Topology schema';


--
-- Name: fuzzystrmatch; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS fuzzystrmatch WITH SCHEMA public;


--
-- Name: EXTENSION fuzzystrmatch; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION fuzzystrmatch IS 'determine similarities and distance between strings';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


--
-- Name: postgis_tiger_geocoder; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_tiger_geocoder WITH SCHEMA tiger;


--
-- Name: EXTENSION postgis_tiger_geocoder; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_tiger_geocoder IS 'PostGIS tiger geocoder and reverse geocoder';


--
-- Name: postgis_topology; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS postgis_topology WITH SCHEMA topology;


--
-- Name: EXTENSION postgis_topology; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION postgis_topology IS 'PostGIS topology spatial types and functions';


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: auth_group; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group (
    id integer NOT NULL,
    name character varying(150) NOT NULL
);


ALTER TABLE public.auth_group OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_id_seq OWNER TO postgres;

--
-- Name: auth_group_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_id_seq OWNED BY public.auth_group.id;


--
-- Name: auth_group_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_group_permissions (
    id integer NOT NULL,
    group_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_group_permissions OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_group_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_group_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_group_permissions_id_seq OWNED BY public.auth_group_permissions.id;


--
-- Name: auth_permission; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_permission (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    content_type_id integer NOT NULL,
    codename character varying(100) NOT NULL
);


ALTER TABLE public.auth_permission OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_permission_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_permission_id_seq OWNER TO postgres;

--
-- Name: auth_permission_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_permission_id_seq OWNED BY public.auth_permission.id;


--
-- Name: auth_user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user (
    id integer NOT NULL,
    password character varying(128) NOT NULL,
    last_login timestamp with time zone,
    is_superuser boolean NOT NULL,
    username character varying(150) NOT NULL,
    first_name character varying(30) NOT NULL,
    last_name character varying(150) NOT NULL,
    email character varying(254) NOT NULL,
    is_staff boolean NOT NULL,
    is_active boolean NOT NULL,
    date_joined timestamp with time zone NOT NULL
);


ALTER TABLE public.auth_user OWNER TO postgres;

--
-- Name: auth_user_groups; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_groups (
    id integer NOT NULL,
    user_id integer NOT NULL,
    group_id integer NOT NULL
);


ALTER TABLE public.auth_user_groups OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_groups_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_groups_id_seq OWNER TO postgres;

--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_groups_id_seq OWNED BY public.auth_user_groups.id;


--
-- Name: auth_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_id_seq OWNER TO postgres;

--
-- Name: auth_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_id_seq OWNED BY public.auth_user.id;


--
-- Name: auth_user_user_permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auth_user_user_permissions (
    id integer NOT NULL,
    user_id integer NOT NULL,
    permission_id integer NOT NULL
);


ALTER TABLE public.auth_user_user_permissions OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.auth_user_user_permissions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.auth_user_user_permissions_id_seq OWNER TO postgres;

--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.auth_user_user_permissions_id_seq OWNED BY public.auth_user_user_permissions.id;


--
-- Name: django_admin_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_admin_log (
    id integer NOT NULL,
    action_time timestamp with time zone NOT NULL,
    object_id text,
    object_repr character varying(200) NOT NULL,
    action_flag smallint NOT NULL,
    change_message text NOT NULL,
    content_type_id integer,
    user_id integer NOT NULL,
    CONSTRAINT django_admin_log_action_flag_check CHECK ((action_flag >= 0))
);


ALTER TABLE public.django_admin_log OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_admin_log_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_admin_log_id_seq OWNER TO postgres;

--
-- Name: django_admin_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_admin_log_id_seq OWNED BY public.django_admin_log.id;


--
-- Name: django_content_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_content_type (
    id integer NOT NULL,
    app_label character varying(100) NOT NULL,
    model character varying(100) NOT NULL
);


ALTER TABLE public.django_content_type OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_content_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_content_type_id_seq OWNER TO postgres;

--
-- Name: django_content_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_content_type_id_seq OWNED BY public.django_content_type.id;


--
-- Name: django_migrations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_migrations (
    id integer NOT NULL,
    app character varying(255) NOT NULL,
    name character varying(255) NOT NULL,
    applied timestamp with time zone NOT NULL
);


ALTER TABLE public.django_migrations OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.django_migrations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.django_migrations_id_seq OWNER TO postgres;

--
-- Name: django_migrations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.django_migrations_id_seq OWNED BY public.django_migrations.id;


--
-- Name: django_session; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.django_session (
    session_key character varying(40) NOT NULL,
    session_data text NOT NULL,
    expire_date timestamp with time zone NOT NULL
);


ALTER TABLE public.django_session OWNER TO postgres;

--
-- Name: language_champion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_champion (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    bio text NOT NULL,
    community_id integer,
    job character varying(255) NOT NULL,
    language_id integer
);


ALTER TABLE public.language_champion OWNER TO postgres;

--
-- Name: language_champion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_champion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_champion_id_seq OWNER TO postgres;

--
-- Name: language_champion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_champion_id_seq OWNED BY public.language_champion.id;


--
-- Name: language_community; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_community (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    point public.geometry(Point,4326),
    population integer NOT NULL,
    email character varying(255),
    website character varying(255),
    english_name character varying(255) NOT NULL,
    internet_speed character varying(255) NOT NULL,
    alt_phone character varying(255) NOT NULL,
    fax character varying(255) NOT NULL,
    other_names character varying(255) NOT NULL,
    phone character varying(255) NOT NULL,
    notes text NOT NULL,
    regions character varying(255) NOT NULL
);


ALTER TABLE public.language_community OWNER TO postgres;

--
-- Name: language_community_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_community_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_community_id_seq OWNER TO postgres;

--
-- Name: language_community_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_community_id_seq OWNED BY public.language_community.id;


--
-- Name: language_community_languages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_community_languages (
    id integer NOT NULL,
    community_id integer NOT NULL,
    language_id integer NOT NULL
);


ALTER TABLE public.language_community_languages OWNER TO postgres;

--
-- Name: language_community_language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_community_language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_community_language_id_seq OWNER TO postgres;

--
-- Name: language_community_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_community_language_id_seq OWNED BY public.language_community_languages.id;


--
-- Name: language_communitylink; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_communitylink (
    id integer NOT NULL,
    url character varying(255),
    title character varying(255) NOT NULL,
    community_id integer
);


ALTER TABLE public.language_communitylink OWNER TO postgres;

--
-- Name: language_communitylink_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_communitylink_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_communitylink_id_seq OWNER TO postgres;

--
-- Name: language_communitylink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_communitylink_id_seq OWNED BY public.language_communitylink.id;


--
-- Name: language_dialect; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_dialect (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    language_id integer
);


ALTER TABLE public.language_dialect OWNER TO postgres;

--
-- Name: language_dialect_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_dialect_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_dialect_id_seq OWNER TO postgres;

--
-- Name: language_dialect_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_dialect_id_seq OWNED BY public.language_dialect.id;


--
-- Name: language_language; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_language (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    color character varying(31) NOT NULL,
    fv_archive_link character varying(255) NOT NULL,
    other_names text NOT NULL,
    sub_family_id integer,
    notes text NOT NULL,
    geom public.geometry(Polygon,4326),
    fluent_speakers integer NOT NULL,
    learners integer NOT NULL,
    pop_total_value integer NOT NULL,
    some_speakers integer NOT NULL,
    bbox public.geometry(Polygon,4326),
    regions character varying(255) NOT NULL
);


ALTER TABLE public.language_language OWNER TO postgres;

--
-- Name: language_language_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_language_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_language_id_seq OWNER TO postgres;

--
-- Name: language_language_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_language_id_seq OWNED BY public.language_language.id;


--
-- Name: language_languagefamily; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_languagefamily (
    id integer NOT NULL,
    name character varying(255) NOT NULL
);


ALTER TABLE public.language_languagefamily OWNER TO postgres;

--
-- Name: language_languagefamily_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_languagefamily_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_languagefamily_id_seq OWNER TO postgres;

--
-- Name: language_languagefamily_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_languagefamily_id_seq OWNED BY public.language_languagefamily.id;


--
-- Name: language_languagelink; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_languagelink (
    id integer NOT NULL,
    url character varying(255),
    title character varying(255) NOT NULL,
    language_id integer
);


ALTER TABLE public.language_languagelink OWNER TO postgres;

--
-- Name: language_languagelink_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_languagelink_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_languagelink_id_seq OWNER TO postgres;

--
-- Name: language_languagelink_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_languagelink_id_seq OWNED BY public.language_languagelink.id;


--
-- Name: language_languagemember; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_languagemember (
    id integer NOT NULL,
    user_id integer NOT NULL
);


ALTER TABLE public.language_languagemember OWNER TO postgres;

--
-- Name: language_languagemember_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_languagemember_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_languagemember_id_seq OWNER TO postgres;

--
-- Name: language_languagemember_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_languagemember_id_seq OWNED BY public.language_languagemember.id;


--
-- Name: language_languagesubfamily; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_languagesubfamily (
    id integer NOT NULL,
    name character varying(255) NOT NULL,
    family_id integer
);


ALTER TABLE public.language_languagesubfamily OWNER TO postgres;

--
-- Name: language_languagesubfamily_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_languagesubfamily_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_languagesubfamily_id_seq OWNER TO postgres;

--
-- Name: language_languagesubfamily_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_languagesubfamily_id_seq OWNED BY public.language_languagesubfamily.id;


--
-- Name: language_lna; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_lna (
    id integer NOT NULL,
    language_id integer,
    name character varying(255) NOT NULL,
    year integer NOT NULL
);


ALTER TABLE public.language_lna OWNER TO postgres;

--
-- Name: language_lna_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_lna_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_lna_id_seq OWNER TO postgres;

--
-- Name: language_lna_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_lna_id_seq OWNED BY public.language_lna.id;


--
-- Name: language_lnadata; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_lnadata (
    id integer NOT NULL,
    fluent_speakers integer NOT NULL,
    some_speakers integer NOT NULL,
    learners integer NOT NULL,
    pop_off_res integer NOT NULL,
    pop_on_res integer NOT NULL,
    pop_total_value integer NOT NULL,
    lna_id integer,
    community_id integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.language_lnadata OWNER TO postgres;

--
-- Name: language_lnadata_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_lnadata_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_lnadata_id_seq OWNER TO postgres;

--
-- Name: language_lnadata_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_lnadata_id_seq OWNED BY public.language_lnadata.id;


--
-- Name: language_placename; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.language_placename (
    id integer NOT NULL,
    point public.geometry(Point,4326),
    name character varying(255) NOT NULL,
    other_name character varying(255) NOT NULL,
    kind character varying(15) NOT NULL
);


ALTER TABLE public.language_placename OWNER TO postgres;

--
-- Name: language_placename_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.language_placename_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.language_placename_id_seq OWNER TO postgres;

--
-- Name: language_placename_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.language_placename_id_seq OWNED BY public.language_placename.id;


--
-- Name: auth_group id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group ALTER COLUMN id SET DEFAULT nextval('public.auth_group_id_seq'::regclass);


--
-- Name: auth_group_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_group_permissions_id_seq'::regclass);


--
-- Name: auth_permission id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission ALTER COLUMN id SET DEFAULT nextval('public.auth_permission_id_seq'::regclass);


--
-- Name: auth_user id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user ALTER COLUMN id SET DEFAULT nextval('public.auth_user_id_seq'::regclass);


--
-- Name: auth_user_groups id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups ALTER COLUMN id SET DEFAULT nextval('public.auth_user_groups_id_seq'::regclass);


--
-- Name: auth_user_user_permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions ALTER COLUMN id SET DEFAULT nextval('public.auth_user_user_permissions_id_seq'::regclass);


--
-- Name: django_admin_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log ALTER COLUMN id SET DEFAULT nextval('public.django_admin_log_id_seq'::regclass);


--
-- Name: django_content_type id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type ALTER COLUMN id SET DEFAULT nextval('public.django_content_type_id_seq'::regclass);


--
-- Name: django_migrations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations ALTER COLUMN id SET DEFAULT nextval('public.django_migrations_id_seq'::regclass);


--
-- Name: language_champion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_champion ALTER COLUMN id SET DEFAULT nextval('public.language_champion_id_seq'::regclass);


--
-- Name: language_community id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_community ALTER COLUMN id SET DEFAULT nextval('public.language_community_id_seq'::regclass);


--
-- Name: language_community_languages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_community_languages ALTER COLUMN id SET DEFAULT nextval('public.language_community_language_id_seq'::regclass);


--
-- Name: language_communitylink id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_communitylink ALTER COLUMN id SET DEFAULT nextval('public.language_communitylink_id_seq'::regclass);


--
-- Name: language_dialect id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_dialect ALTER COLUMN id SET DEFAULT nextval('public.language_dialect_id_seq'::regclass);


--
-- Name: language_language id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_language ALTER COLUMN id SET DEFAULT nextval('public.language_language_id_seq'::regclass);


--
-- Name: language_languagefamily id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagefamily ALTER COLUMN id SET DEFAULT nextval('public.language_languagefamily_id_seq'::regclass);


--
-- Name: language_languagelink id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagelink ALTER COLUMN id SET DEFAULT nextval('public.language_languagelink_id_seq'::regclass);


--
-- Name: language_languagemember id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagemember ALTER COLUMN id SET DEFAULT nextval('public.language_languagemember_id_seq'::regclass);


--
-- Name: language_languagesubfamily id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagesubfamily ALTER COLUMN id SET DEFAULT nextval('public.language_languagesubfamily_id_seq'::regclass);


--
-- Name: language_lna id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_lna ALTER COLUMN id SET DEFAULT nextval('public.language_lna_id_seq'::regclass);


--
-- Name: language_lnadata id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_lnadata ALTER COLUMN id SET DEFAULT nextval('public.language_lnadata_id_seq'::regclass);


--
-- Name: language_placename id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_placename ALTER COLUMN id SET DEFAULT nextval('public.language_placename_id_seq'::regclass);


--
-- Data for Name: auth_group; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group (id, name) FROM stdin;
\.


--
-- Data for Name: auth_group_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_group_permissions (id, group_id, permission_id) FROM stdin;
\.


--
-- Data for Name: auth_permission; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_permission (id, name, content_type_id, codename) FROM stdin;
1	Can add log entry	1	add_logentry
2	Can change log entry	1	change_logentry
3	Can delete log entry	1	delete_logentry
4	Can view log entry	1	view_logentry
5	Can add permission	2	add_permission
6	Can change permission	2	change_permission
7	Can delete permission	2	delete_permission
8	Can view permission	2	view_permission
9	Can add group	3	add_group
10	Can change group	3	change_group
11	Can delete group	3	delete_group
12	Can view group	3	view_group
13	Can add user	4	add_user
14	Can change user	4	change_user
15	Can delete user	4	delete_user
16	Can view user	4	view_user
17	Can add content type	5	add_contenttype
18	Can change content type	5	change_contenttype
19	Can delete content type	5	delete_contenttype
20	Can view content type	5	view_contenttype
21	Can add session	6	add_session
22	Can change session	6	change_session
23	Can delete session	6	delete_session
24	Can view session	6	view_session
25	Can add community	7	add_community
26	Can change community	7	change_community
27	Can delete community	7	delete_community
28	Can view community	7	view_community
29	Can add language	8	add_language
30	Can change language	8	change_language
31	Can delete language	8	delete_language
32	Can view language	8	view_language
33	Can add place name	9	add_placename
34	Can change place name	9	change_placename
35	Can delete place name	9	delete_placename
36	Can view place name	9	view_placename
37	Can add language member	10	add_languagemember
38	Can change language member	10	change_languagemember
39	Can delete language member	10	delete_languagemember
40	Can view language member	10	view_languagemember
41	Can add champion	11	add_champion
42	Can change champion	11	change_champion
43	Can delete champion	11	delete_champion
44	Can view champion	11	view_champion
45	Can add dialect	12	add_dialect
46	Can change dialect	12	change_dialect
47	Can delete dialect	12	delete_dialect
48	Can view dialect	12	view_dialect
49	Can add language family	13	add_languagefamily
50	Can change language family	13	change_languagefamily
51	Can delete language family	13	delete_languagefamily
52	Can view language family	13	view_languagefamily
53	Can add language sub family	14	add_languagesubfamily
54	Can change language sub family	14	change_languagesubfamily
55	Can delete language sub family	14	delete_languagesubfamily
56	Can view language sub family	14	view_languagesubfamily
57	Can add community link	15	add_communitylink
58	Can change community link	15	change_communitylink
59	Can delete community link	15	delete_communitylink
60	Can view community link	15	view_communitylink
61	Can add language link	16	add_languagelink
62	Can change language link	16	change_languagelink
63	Can delete language link	16	delete_languagelink
64	Can view language link	16	view_languagelink
65	Can add lna data	17	add_lnadata
66	Can change lna data	17	change_lnadata
67	Can delete lna data	17	delete_lnadata
68	Can view lna data	17	view_lnadata
69	Can add lna	18	add_lna
70	Can change lna	18	change_lna
71	Can delete lna	18	delete_lna
72	Can view lna	18	view_lna
\.


--
-- Data for Name: auth_user; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined) FROM stdin;
1	pbkdf2_sha256$150000$ZaGFt9BcQzA9$ZN8eqzkY+aj1qP3PyZwZognZAgTWIME0I/kaesi7P7M=	2019-07-14 05:57:40.075025+00	t	admin			admin@example.com	t	t	2019-07-02 04:40:39.312335+00
\.


--
-- Data for Name: auth_user_groups; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_groups (id, user_id, group_id) FROM stdin;
\.


--
-- Data for Name: auth_user_user_permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auth_user_user_permissions (id, user_id, permission_id) FROM stdin;
\.


--
-- Data for Name: django_admin_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_admin_log (id, action_time, object_id, object_repr, action_flag, change_message, content_type_id, user_id) FROM stdin;
1	2019-07-02 04:59:36.818447+00	1	Language object (1)	1	[{"added": {}}]	8	1
\.


--
-- Data for Name: django_content_type; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_content_type (id, app_label, model) FROM stdin;
1	admin	logentry
2	auth	permission
3	auth	group
4	auth	user
5	contenttypes	contenttype
6	sessions	session
7	language	community
8	language	language
9	language	placename
10	language	languagemember
11	language	champion
12	language	dialect
13	language	languagefamily
14	language	languagesubfamily
15	language	communitylink
16	language	languagelink
17	language	lnadata
18	language	lna
\.


--
-- Data for Name: django_migrations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_migrations (id, app, name, applied) FROM stdin;
1	contenttypes	0001_initial	2019-07-02 04:30:19.463188+00
2	auth	0001_initial	2019-07-02 04:30:19.507964+00
3	admin	0001_initial	2019-07-02 04:30:19.570702+00
4	admin	0002_logentry_remove_auto_add	2019-07-02 04:30:19.587989+00
5	admin	0003_logentry_add_action_flag_choices	2019-07-02 04:30:19.597554+00
6	contenttypes	0002_remove_content_type_name	2019-07-02 04:30:19.61691+00
7	auth	0002_alter_permission_name_max_length	2019-07-02 04:30:19.622343+00
8	auth	0003_alter_user_email_max_length	2019-07-02 04:30:19.631694+00
9	auth	0004_alter_user_username_opts	2019-07-02 04:30:19.640502+00
10	auth	0005_alter_user_last_login_null	2019-07-02 04:30:19.649869+00
11	auth	0006_require_contenttypes_0002	2019-07-02 04:30:19.652296+00
12	auth	0007_alter_validators_add_error_messages	2019-07-02 04:30:19.66124+00
13	auth	0008_alter_user_username_max_length	2019-07-02 04:30:19.674219+00
14	auth	0009_alter_user_last_name_max_length	2019-07-02 04:30:19.686155+00
15	auth	0010_alter_group_name_max_length	2019-07-02 04:30:19.695908+00
16	auth	0011_update_proxy_permissions	2019-07-02 04:30:19.705429+00
17	language	0001_initial	2019-07-02 04:30:19.773367+00
18	sessions	0001_initial	2019-07-02 04:30:19.796414+00
19	language	0002_auto_20190705_1925	2019-07-11 04:19:00.44741+00
20	language	0003_languagesubfamily_family	2019-07-11 04:19:00.453874+00
21	language	0004_language_sub_family	2019-07-11 04:19:00.473553+00
22	language	0005_language_notes	2019-07-11 04:19:00.485713+00
23	language	0006_auto_20190705_2122	2019-07-11 04:19:00.5086+00
24	language	0007_community_english_name	2019-07-11 04:19:00.521338+00
25	language	0008_community_internet_speed	2019-07-11 04:19:00.529837+00
26	language	0009_auto_20190705_2125	2019-07-11 04:19:00.537775+00
27	language	0010_auto_20190705_2133	2019-07-11 04:19:00.588375+00
28	language	0011_auto_20190705_2139	2019-07-11 04:19:00.618663+00
29	language	0012_dialect_language	2019-07-11 04:19:00.641788+00
30	language	0013_auto_20190705_2155	2019-07-11 04:19:00.759187+00
31	language	0014_remove_champion_point	2019-07-11 04:19:00.769378+00
32	language	0015_placename_kind	2019-07-11 04:19:00.775051+00
33	language	0016_auto_20190712_0701	2019-07-12 07:01:59.292589+00
34	language	0017_communitylink	2019-07-12 07:06:11.975157+00
35	language	0018_languagelink	2019-07-12 07:12:21.518528+00
36	language	0019_community_notes	2019-07-12 07:14:06.147307+00
37	language	0020_auto_20190712_0715	2019-07-12 07:15:41.483597+00
38	language	0021_auto_20190712_0727	2019-07-12 07:27:26.362005+00
39	language	0022_auto_20190714_0515	2019-07-14 05:16:04.16937+00
40	language	0023_auto_20190714_0519	2019-07-14 05:19:08.716333+00
41	language	0024_auto_20190714_0534	2019-07-14 05:34:08.722941+00
42	language	0025_auto_20190714_0535	2019-07-14 05:35:25.802159+00
43	language	0026_auto_20190714_0536	2019-07-14 05:36:41.038745+00
44	language	0027_auto_20190714_0547	2019-07-14 05:47:11.573459+00
45	language	0028_lna_year	2019-07-14 05:52:10.835259+00
46	language	0029_language_bbox	2019-07-16 19:28:49.23427+00
47	language	0030_auto_20190716_1929	2019-07-16 19:29:55.005109+00
48	language	0031_auto_20190716_1932	2019-07-16 19:32:26.618202+00
49	language	0032_auto_20190716_1934	2019-07-16 19:34:11.520267+00
50	language	0033_auto_20190722_2033	2019-07-22 20:33:07.50941+00
\.


--
-- Data for Name: django_session; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.django_session (session_key, session_data, expire_date) FROM stdin;
1yy8by3lpoxzm2j54bmqebzgbqu1hsfv	ZGY3YTFkODJkMzFmMTY0NjA0NzkwMzhiOWE3NGIwNzQ3Y2NjNzJiNDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI3ODU4MDkxZGI3ZjZkM2QzODI1MzFmYjI5MDBiMWVkYjMyMDM0MTM0In0=	2019-07-16 04:41:48.404699+00
k1hee371zxkj07k04i744nze34iwycju	ZGY3YTFkODJkMzFmMTY0NjA0NzkwMzhiOWE3NGIwNzQ3Y2NjNzJiNDp7Il9hdXRoX3VzZXJfaWQiOiIxIiwiX2F1dGhfdXNlcl9iYWNrZW5kIjoiZGphbmdvLmNvbnRyaWIuYXV0aC5iYWNrZW5kcy5Nb2RlbEJhY2tlbmQiLCJfYXV0aF91c2VyX2hhc2giOiI3ODU4MDkxZGI3ZjZkM2QzODI1MzFmYjI5MDBiMWVkYjMyMDM0MTM0In0=	2019-07-28 05:57:40.077538+00
\.


--
-- Data for Name: language_champion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_champion (id, name, bio, community_id, job, language_id) FROM stdin;
8	Russell Adolph	Russell Adolph is a member of the Xaxl’ip First Nation near Lillooet and has been carving in stone since 2002. Though largely self-taught, he has had the opportunity to study jade carving with Deborah Wilson of Evergreen Carvings in Vernon. Mr. Adolph is in the process of expanding his artistic practice to include creating animal regalia for theater, ceremony and display. Some of his most recent pieces include cougar, coyote, wolverine and bear regalia.\r\n\r\nIn the spring of 2008, Mr. Adolph received an Aboriginal Arts Development Award from the First Peoples’ Heritage, Language and Culture Council. This award is helping him fund his project to study animal hide tanning and head mounting with mentor, Dan Ediger.\r\n	\N	Carving and Regalia	13
2	Chris Paul	“I think that both our weakest element and our greatest strength come from our humanity. Through my art I try to find the purest form of beauty and simplicity… At best, I believe we begin to understand this through art.”\r\n\r\nIn celebration of the art and culture of his people, Coast Salish artist Chris Paul is constantly learning and creating work in various media. His limited edition prints, carvings and jewelry are influenced by his growing understanding of language, songs, stories and ceremonies. In addition to mentors Floyd Joseph and Roy Henry Vickers, the artist acknowledges Charles Elliott and Susan Point as significant influences; Chris’s commitment and passion have led him to become the extraordinary artist that he is today.	377	printmaker, jeweller, carver, logos	15
3	Elizabeth "Liz" Carter 	<h1>Kwicksutaineuk-Ah-Kwa-Ah-Mish</h1>\r\n\r\n“The struggles of a late immersion can be seen in my artwork and sometimes with a political social twist. My work is a biographical document of my journey, in search for answers to my cultural identity.”\r\n\r\nIntrigued by the process of art making Liz Carter enjoys the exploration of different mediums. Her creative energy is spent full-time on painting and black & white photography. Liz strives to practice new ways of exploring, improvising and expressing her work in order to communicate her message clearly.\r\n\r\nAs most First Nations people feel when they are raised outside of their culture, Liz felt disconnected with her cultural heritage but re-introduction took place after the birth of her children and since then her work has turned to an integration of identity with many facets.	\N	painter, photographer	\N
4	Laurence Knowles	“My philosophy as an artist is to always be learning new techniques and push old ones to the limit. I believe traditional art is to be respected. I am trying to bring back the traditional stone carvings of the Haida.”\r\n\r\nWhile Laurence’s work demonstrates a deep respect for traditional Haida art forms, the artist continues to explore and experiment. An artist since childhood, Laurence won his first art contest while in school and in 1994 was accepted to the Gitamax School of Native Art (K’san) in Hazelton, BC. Laurence’s talent is celebrated in the creations of his stunning and unique argillite marionettes; one piece was recently selected as a gift for the Governor General of Canada, Adrienne Clarkson.	\N	carver, puppet maker	24
6	Leonard A. George Jr.	"Mother Earth is my first priority in any art piece that I do. I have a spiritual connection to natural materials, which keeps my priorities in line. The history of First Nations People is marked in artistic ways, basketry, rock wall painting and face painting, this keeps us deeply rooted to the past."\r\n\r\nLeonard A. George Jr. grew up amidst the smell of bone dust, cottonwood and shoe polish as he watched his father and grandfather at work as carvers. His life as an artist began at the age of seven when he created his first "real art piece" based on a memory of his past.\r\n\r\nLeonard attributes his artistic talents, primarily as a painter, to his first art instructor stating, "If it wasn't for Mary Longman, I wouldn't be the artist I am today."	\N	painter	12
10	Vera Manuel	Vera Manuel is from the Secwepemc and Ktunaxa First Nations and grew up on the Neskonlith reserve in interior BC. Currently living in Vancouver, Vera is a writer, poet and playwright who has toured and performed her work for the past 20 years. She is also a founding member of Storyteller Productions Aboriginal Theater Company.  In 2006, she was honoured with a World Poetry Lifetime Achievement Award. \r\n\r\nIn the spring of 2008, Vera received an Aboriginal Arts Development Award to help fund the production of her spoken-word CD, entitled “When I First Came to Know Myself.”  \r\n	\N	Writing, Poetry, Spoken Word	33
12	Mary Swanson	Nonnie Mary is very respected in her community of Old Massett for her great dedication to teaching X̱aad Kil. She is a fluent speaker with university training to write her language. She has worked teaching X̱aad Kil for 26 years in Tahayghen (Daxiigang) Elementary School and another local school. In 2008 she turned 85 years old and is still teaching her language.	315	Language Teacher	24
5	Marianne Nicolson	“Located in Kingcome Inlet this painting was completed in 1998. It was created to recognize the connection of the Dzawada'enuxw People to their home territory. The painting depicts a large copper.\r\nWithin the upper shield portion is the wolf Kawadilikala, the original ancestor of the Dzawada'enuxw. He brings a treasure box down with him from the mountains.\r\n\r\n…The box rests on his back and on the front of the box is the image of the sun. The sun appears to be rising up from behind Kawadilikala's back and signifies hope for the future. The four stars on the lower portion of the copper symbolize the four tribes of the Musgamagw Dzawada'euxw Nations.”	232	painter	29
7	Arnie Charlie	“This project will allow me to continue practicing my art making skills and provide a way to distribute my work throughout the community. I would like young people to think about making art for people and not just the money.”\r\n\r\nA logger for most of his life, Arnie Charlie is now retired and raising his grandchildren, He began to realize his natural artistic talents later in life, while participating in the Musqueam Visual Arts Program. There he began to create sculpture, carvings, jewelry pieces, prints, garments and fabric for gifts, donations and community events. Arnie says that in addition to keeping his mind and spirit healthy and active in the culture and community, making his art keeps him close to his grandchildren.\r\n	299	sculptor, carver, jeweller, printmaker, designer 	9
41	Stephen Brown	Stephen Brown is a Haida Elder who has been teaching Haida/Xaad Kil for over 20 years. His first language is Haida, learning English when he was 10 years old.  He never attended residential school so spent a lot of time with the Elders in the village at the time.  \r\n\r\nAt 88 years of age, Stephen still works at George M. Dawson Secondary School and at the Language Nest as a teacher/translator.  \r\n\r\nHe has been involved in many projects for language, including a CBC Radio language preservation project called Legends of the Old Massett Haida/ Gaaw Xaadee Gyaahlaangaay.  \r\n\r\nAnother important project was a National Film Board project called Our World where youth made their own films and included Stephen's voice in most of the projects.  \r\n\r\nToday, he splits his time between the high school and the Language Nest. The Language Nest was started to encourage toddlers and their parents to learn basic Haida. At the Language Nest, they spend an hour each day translating and recording. \r\n\r\nHe has also worked with a language teacher from Chief Matthews School every morning for two years on language curriculum. \r\n\r\nIn his off time, Stephen spends time with some intermediate students who learn and record with him.  \r\n\r\nHis greatest desire is to see some of his students reach fluency while he is still alive. He is not only a teacher of language but shares his knowledge of the islands, the history, the old ways and Haida values. \r\n\r\nI feel this great man should be recognized for his great commitment to saving a language that is at great risk of becoming extinct. His whole life is about teaching the language and that is the kind of person who should be commended. \r\n\r\nNominator: Lisa White\r\n	315		24
17	Katherine Fraser	Home:    Port Alberni\r\nYears Working Towards Language Revitalization:   Many\r\n\r\n \r\nKatherine is an Elder who went to university to complete her undergraduate degree in Linguistics and her Masters in Education.\r\n \r\nShe taught the Nuu-chah-nulth language 2 nights a week for a full year, voluntarily, for a group of eager learners at North Island College. She has helped create learning tools for the Nuu-chah-nulth language from books, CDs, a new website and flash cards. She has transcribed an endless number of previously recorded audio resources. \r\n\r\nThe Nuu-chah-nulth people started a school where she taught as a Language Instructor for 5 years. \r\n\r\nKatherine recognized the struggle that first time speakers had with pronunciation and developed an exercise to help them. This exercise has been very helpful in keeping the purity of the language. She helped organize a 7-week Language Camp, which she committed to teaching the entire time. She is very supportive of the Taking Back Our Culture Association, which is a group of all ages and learning levels. \r\n\r\nShe is always willing to help in anyway she can and we are very fortunate to have a dedicated and knowledgeable teacher.  \r\n\r\nNominated by:   Evangaline Prevost	\N		25
19	Sm'ooygit Gitxoon 	Home:    Prince Rupert\r\nYears Working Towards Language Revitalization:   Many\r\n\r\n \r\nAlex Campbell, whose traditional name is Sm'ooygit Gitxoon, is involved leading a Rediscovery Program for students that uses language, historic events of First Nations peoples, stories, songs, traditional foods, and the teaching of toomsk, or "respect."\r\n \r\nHe has been teaching the language for years with little ones and high school students.  He also works with university students learning the Sm’algyax language.  He is a great role model to all and he is fun to learn from.  \r\n\r\nKnowledgeable about music, stories, and traditional law, he gives a great deal of his time to the service of the communities, allied tribes, political events, land claims, and the Canoe Journey.  He has been the Tsimshian speaker for the outlying villages.  \r\n\r\nHe is a great language teacher.\r\n\r\nNominated by Lorraine Green	\N		34
27	Gertrude Ned	Home:    Lillooet\r\nYears Working Towards Language Revitalization:   30+\r\n\r\n \r\nGertrude started a St'at'imc language program in the three public schools in Lillooet when no such programs were happening in the province.  She volunteered her St'at'imc language teaching for a number of years and then was hired by the school district to teach at a very nominal fee for her services.\r\n\r\nShe has been involved with language revitalization for many years, teaching leaders, young people and all of those who wanted to learn the language.  She has worked tirelessly to promote language learning - even to the town's pharmacist!\r\n\r\nGertie has been a curriculum developer and language immersion camp instructor for six years in the Lillooet area.  She champions language immersion as a means of teaching and learning the language.\r\n\r\nAs part of the language authority, she has edited St'at'imc publications, has been involved in the development of two St'at'imc dictionaries, and has done countless activities relating to St'at'imc language.\r\n\r\nShe is a respected Elder in St'at'imc territory and known in linguistic circles as a fluent St'at'imc speaker and valued language advisor.  \r\n\r\nNominated by Nora Greenway	\N		13
20	Celestine (Filly) Brigham	Home:    Stone First Nation\r\nYears Working Towards Language Revitalization:   Very many\r\n\r\n \r\nCelestine (Filly) has taught at  Yunesit'in ?Esgul (Stone School) and she always speaks fluently to the children. She teaches plants, animals, colours and song and dance.  She also brings Elders in to teach stories and songs to the children.  \r\n\r\nCelestine has published and produced language materials for the school.  She does hands-on activities with the children.  We've also had some non-natives here at our school and they really gained first-hand knowledge of the culture and language.\r\n  \r\nShe is always trying to learn new ways to teach the language to our students by going to workshops.  If there is a dvd, video or tape, she plays it to the children just to offer them more exposure to the language.\r\n\r\nNominated by Scott Allen and Yunesit'in ?Esgul (Stone School)	\N		5
22	Delphine Derickson	Home:    Westbank\r\nYears Working Towards Language Revitalization:   Lifetime\r\n\r\n \r\nDelphine Derickson has devoted her entire life to the preservation and continuance of her traditional language and to teaching the language.  \r\n\r\nShe is a member of the BC College of Teachers and was part of a project that created an alphabet for her language so it could be written.  \r\n\r\nHer language is her life.\r\n\r\n\r\nNominated by Marla Baptiste	\N		36
23	Betty Wilson	Home:    Powell River\r\nYears Working Towards Language Revitalization:   Many\r\n\r\n \r\nBetty Wilson goes above and beyond her position to keep our language and culture alive in our community and within School District #47.  She has been the mentor behind all of the language teachers and the inspiration to many.\r\n  \r\nBetty’s career started as a language teacher and has continued to flourish as an all-around language and cultural advocate.  Our language has come a long way and it is now being offered as a second language within School District #47 and within the University of Victoria as well as Simon Fraser University.  \r\n\r\nBetty's passion for the Sliammon Language is evident and commendable!\r\n\r\nNominated by Dana Gustafson\r\n	\N		8
24	Faye Seymour	Home:    Fort Ware\r\nYears Working Towards Language Revitalization:   25+\r\n\r\n \r\nFaye Seymour is a Language Champion because of her passion to sustain the Tsek'ene language among the children and adults of Kwadacha Nation.  \r\n\r\nShe has worked over 25 years at Aatse Davie School.  She teaches Language and Culture and is in charge of the Language Revitalization Program.\r\n  \r\nFaye is involved in almost every aspect of the community and she brings her passion for language and culture education into the school.  Faye not only "talks the talk," she lives what she teaches to the community.  \r\n\r\nShe spends part of her summers running a Tsek'ene Culture and Science Camp for the youth of Fort Ware.  She has also extended her efforts towards the revitalization of traditional medicine for the community.\r\n\r\nNominated by Andreas Rohrbach	\N		3
11	Nisga’a Spirit Lava Dancers 	Established in 2004, The Nisga’a Spirit Lava Dancers is a group of approximately 20-30 people of all ages based out of New Aiyansh, B.C. Geared toward the spiritual and cultural growth of the children and youth of the Nisga’a Nation, the Nisga’a Spirit Lava Dancers hold the core beliefs of balance and education. They also aim to practice Sayt Kil’im Goot, which is the practice of being of one heart and mind. \r\n\r\nIn the spring of 2008, the Nisga’a Spirit Lava Dancers received an Aboriginal Arts Development Award to hold a drum and regalia making workshop for their members. \r\n\r\n“The children learned all aspects of the Nisga'a culture.  We had the opportunity to learn from Peter McKay, (our dance director and Nisga'a Language and Cultural teacher)  how to draw designs, make drums, make simple regalia, weave with cedar, learn some Nisga'a songs and dances, and to celebrate our successes with our community.\r\nThe children were encouraged to join us when we had our "Gathering of Many Nations" in New Aiyansh.  It was very exciting to see the students join in and their parents, family members, friends feeling very proud of their accomplishments.”\r\n-Teresa McMillan\r\n	309	Dance group 	\N
30	Selina Myers	Home:    Nemiah Valley\r\nYears Working Towards Language Revitalization:   22+\r\n\r\n \r\nSelina Myers is a language champion for the Xeni Gwet'in Chilcotin language. \r\n\r\nShe is an Elder who has placed herself on the front-line by building her knowledge by attending workshops and training and networking with other immersion teachers, in order to provide our community school with training and education tools. She dedicates her time, energy, traditional and cultural knowledge, love and caring to the children. \r\n\r\nSelina has worked in language immersion for twenty-two years. She has developed language materials and she teaches the Chilcotin immersion language.  She is one of our Elders in the Xeni Gwet'in community who has knowledge of our traditions and culture, and she shares that knowledge with the youth and children in our community. \r\n\r\nWe appreciate the opportunity provided by the First Nations Education Steering Committee and First Peoples’ Heritage, Language & Cultural Council to recognize our Language Champion. \r\n\r\nOn Behalf Of Eniyud Health Services and Xeni Gwet'in First Nations we recognize and support Selina Myers as our Chilcotin Language Champion.\r\n	\N		5
32	Pewi Alfred	Home:    Alert Bay\r\nYears Working Towards Language Revitalization:   Lifetime\r\n\r\n \r\nPewi is a champion of the Kwak’wala language and her passion for keeping the nation strong stems from the teachings and language of the ‘Namgis Nation. Pewi is determined that those teachings will continue, so she practices them daily and raises her son in those teachings.\r\n\r\nPewi has made major contributions to the culture and language by documenting the history of the ‘Namgis at our local museum and creating education resources for language studies, including activity books and dictionaries. Pewi’s dedication to language retention and revitalization can be seen in the language classes she facilitates and the cultural activities in which she participates.\r\n\r\nPewi is an ambassador for the ‘Namgis and she has travelled internationally sharing the ‘Namgis culture and traditions. \r\n\r\nPewi is truly a champion and mentor of the Kwak’wala language and an inspiration to the young and old of the ‘Namgis First Nation.\r\n\r\nNominated by Georgia Cook	\N		29
31	William (Billy) Attachie 	Home:    Doig River First Nation\r\nYears Working Towards Language Revitalization:   30+ \r\n\r\n \r\nWilliam (Billy) Attachie has worked on revitalizing the language for more than 30 years.  \r\n\r\nHe helped linguist Marshall Holdstock to develop the written language from 1960 to the present. Together, they produced many books and videos and translated many of the Elders' stories into English so that today all of us can understand them.  \r\n\r\nHe has helped our Nation by translating videos that document our history for court cases and for learning of our Nation. \r\n \r\nHe did the translation for a virtual exhibit on Dane Wajich - the website is www.virtualmuseum.ca/exhibitions/Danewajich.  \r\n\r\nMost of all, he has helped our people to read and write the language.\r\n\r\nNominated by: Doig River First Nation- Madeline Oker	\N		22
33	Louise Lacerte	Home:    Burns Lake\r\nYears Working Towards Language Revitalization:   Many\r\n\r\n \r\nLanguage is Louise Lacerte’s passion and she does everything she can to teach the language.  \r\n\r\nHer knowledge of language and culture was taught to her by her grandparents, and she sees it as a gift that has been given to her to share with all.  She was born into Nedut'en and was raised in Wetsuwet'en, so she can speak, understand and teach both dialects.\r\n\r\nLouise teaches in a regular classroom and always tells her students that the most important teaching she has to share is the language and culture. Her goal is that her students gain a sense of pride in who they are.  \r\n\r\nLouise completed her Masters in storytelling and she talks about the importance of language and culture and how it has shaped her as a proud Nedut'en and Wetsuwet'en person.    \r\n\r\nShe is well-respected by all the students who have had the privilege of working with her.\r\n\r\nNominated by Jackie Williams	\N		16
29	Mandy Jimmie	Home:    Merritt\r\nYears Working Towards Language Revitalization:   26\r\n\r\n \r\nMandy Jimmie is a Language Champion who provides vision and hope to all of our communities.  \r\n\r\nMandy is fully committed to ensuring that we will always have fluent Nle'kepmx language speakers.  She worked in language programs even before she became a practicing teacher.  She is currently the Language Coordinator at Nicola Valley Institute of Technology (NVIT), and in this role she has successfully implemented the Developmental Standard Term Certificate program in partnership with Thompson Rivers University. \r\n\r\nWith NVIT, Mandy has worked with 9 linguistic groups in the province and NVIT is in talks with 5 more to accredit language courses.  Currently, 200 students in more than 20 language courses are being served.\r\n\r\nMandy is a true lover of language.  Every person in our communities knows that her purpose is to continually develop and build upon the knowledge of our Elders.  \r\n\r\nMandy has sat on the local school district First Nations Education Council and been an advocate for young language students in both K-12 and post-secondary settings.\r\n\r\nIn terms of her vision and hope, Mandy is committed to working with other language groups in the province and throughout the Indigenous world to assist each other in developing our languages.  \r\n\r\nMandy Jimmie is a catalyst for growth and development in First Nations languages and we all hold our hands up to her.     \r\n\r\nNominated by John Chenoweth \r\n	\N		12
37	Catherine Coldwell	Home:    Fort St James\r\nYears Working Towards Language Revitalization:   50\r\n \r\n\r\n \r\nCatherine Coldwell is a language champion because she has the determination to help restore, revitalize and maintain the Dak'elh language in the Carrier communities of central British Columbia.\r\n\r\nAfter her husband's death in 1969, Catherine began work to support and raise her family. After holding down several jobs in the community, she decided to focus on teaching her language and culture.\r\n\r\nIn the late 1980s, Catherine enrolled in and graduated from the Yukon Native Language Instructors Program. Then she dedicated her time and energy to developing an adult language learning module, teaching the teachers, teaching language and culture In her community, advising on curriculum development, and editing many children's books about Dak'elh legends and culture. She carries this knowledge to the Daycare Centre, where she strongly believes the notion that education is a lifelong endeavour and it is a tool that ought to be accessible to all people, especially our children. \r\n\r\nHer community service includes involvement in various committees, such as the Carrier Linguistic Committee, teaching in the school district elementary schools, teaching the teachers through the Yinka Dene Language Institute, and later through the University of Northern British Columbia. She recently finished a post-retirement contract with UNBC. \r\n\r\nCatherine is a role model who displays the determination and the motivation to accomplish the survival of the Dak’elh peoples' basic right to their mother tongue. Her genuine work ethic and her ability to maintain a sense of humility should be acknowledged.\r\n\r\nNominated by Margaret Mattress	\N		18
9	Qwul’thilum (Dylan Thomas)	Born in Victoria, Qwul’thilum (Dylan Thomas) is a Coast Salish artist from the Lyackson First Nation. He was exposed to the arts at a young age, as his family continues to participate in their culture and traditions. Qwul’thilum has trained in the art of jewelry work with mentor, Seletze (Delmar Johnnie), and has experimented with various other media, including limited edition prints, sand blasted wood panels, as well as paddle and drum painting. Currently working with his mentor, Rande Cook, Qwul’thilum also acknowledges the influence of the late Art Thompson, as well as Susan Point and Robert Davidson. \r\n\r\nQwul’thilum received a 2007/08 Aboriginal Arts Development Award to carve a two-dimensional wood panel under the mentorship of artist, Rande Cook. \r\n\r\n"I believe that it is important to understand as many mediums of First Nations art as possible, especially the traditional forms. And thanks to the Aboriginal Arts Development Award, I have been able to honour my ancestors by moving into the medium of wood carving."\r\n	\N	Carving, Printmaking, Jewelry	\N
36	Elsie Archie	Home:    Canim Lake\r\nYears Working Towards Language Revitalization:   25+\r\n\r\n \r\nElsie Archie is a highly respected Elder in the Canim Lake community.  She is one of the few fluent speakers and writers of the Shuswap language.  \r\n\r\nElsie has been involved with language in the community through many activities, including language immersion summer camps for the children in the community and the development of learning resources and teaching units for School District #27.   She is developing units for instruction on a continual basis and the culture of the Shuswap people is integrated into the activities.  She has taught adult classes and has been instrumental in developing tapes that will be digitized onto CD's and delivered to each home within the community. \r\n\r\nElsie works with the language committee for the Northern Shuswap Bands.  The language committee meets to review what has been happening with the language in each of the communities and to brainstorm ideas of how to incorporate the language into the communities.  The language committee has set a goal for each of the communities to be fluent in the language in 5 years.\r\n \r\nElsie has received her B. Ed. from Gonzaga University and her B.A. in Linguistics from Simon Fraser University.  \r\n\r\nIn her retirement, Elsie is teaching at 100 Mile Junior Secondary and Peter Skene Ogden Secondary.  She teaches full Shuswap classes to grade 8 - 12 students.  \r\n\r\nShe is now being encouraged to develop the Mac Books of cultural activities and Elder stories in the Shuswap Language with the children.  The first example will be presented at the Language Conference (workshop sessions 1A and 2A) when we bring the pictures and the language from our Gustafson Lake cultural fishing day.  We have applied for a Literacy Now grant to produce 40 books for our community.\r\n\r\nNominated by Barb MacLeod	\N		33
38	Amy Charlie	Home:    Lytton\r\nYears Working Towards Language Revitalization:   11\r\n\r\n \r\nCurrently, Amy is 72 years old but she doesn’t let her age slow her down.  Amy Charlie, together with her late husband Edward Charlie, would always speak at meetings and gatherings in our language. Not only would they promote the language at the community level, but they would record the language and work with a language committee to develop a reader-friendly alphabet. \r\n\r\nIn cooperation with a local Band school, Amy has been instrumental in the development of three levels of language curricula to assist with revitalization efforts.  \r\n\r\nOne of Amy's biggest accomplishments was to teach herself about computer technology and the ways it could assist her in her language efforts. She was quickly scanning photos to go with words that were being used for picture word association. She is a role model in the respect that you are never too old to learn new technology.  She texts on her cell phone and finds this an amazing advantage to keep in touch with her children who live in communities away from her.  \r\n\r\nSince being widowed two years ago, Amy does more walking and dancing whenever the opportunity arises. She doesn’t turn down the opportunity to attend any meeting where language is going to be discussed or promoted and she recently attended a language conference at the University of Victoria.  This June, Amy helped organize a Nlaka'pamux language gathering where storytelling in the language was a main feature. \r\n\r\nAlthough Amy attended residential school, her grandmother taught her to never turn her back on her prayers, and Amy is now one of the most respected Elders who offers prayers in the language at countless community functions. \r\n\r\nAmy is truly a language champion within our nation.\r\n\r\nNominated by John Haugen and Lytton First Nation Education Committee	\N		12
44	Evelyn Windsor	Nuwaqawa (Evelyn Windsor) is a high-ranking woman from Oweekeno. She was taken away to residential school at the young age of 5 to age 12. She married Marshall Windsor of the Hailhzaqv Nation (Bella Bella); together they were blessed with 5 children, 8 grandchildren, 5 great grandchildren and 2 great, great grandchildren. \r\n\r\nEvelyn survived 7 years of residential school and as a young mother had to leave all 5 of her children home while she was hospitilized with tuberculosis for 5 1/2 years. \r\n\r\nEvelyn has worked for the Bella Bella Community School for 34 years assisting in the revitalization and revival of Hailhzaqvla (speaking Hailhzaqv). \r\n\r\nThrough her many works and affiliation with the University of Victoria, University of British Columbia and Simon Fraser University, she has helped to produce a Hailhzaqv dictionary, volumes 1 & 2, a root and suffix book, and curriculum and audio and visual aides. Over time, language switched from an oral to a written system, which she mastered; she also teaches the written format. \r\n\r\nAffiliated with SFU, Evelyn also played an integral role in five second language learners obtaining their Language Proficency Certificates, which qualifies them to teach Hailhzaqvla; two more trainees are near completion. \r\n\r\nEvelyn attributes her success to the fact that she loved to read; her determination started at a very young age.\r\n\r\nToday, Evelyn continues to work for the Bella Bella Community School as a resource person. Her wealth of cultural knowledge and history and expertise in the Wakashan Language family, wisdom and linguistics are an asset to the community as a whole. \r\n\r\nAt the age of 82, Evelyn’s work ethic epitomizes what commitment, dedication and hardwork truly are. She arrives at school every day a 1/2 hour early, working diligently all day long. When she isn't busy she asks: "what can I do?" or, "is there anything you need me to do?" And there are days that we literally have to send her home when she is sick. Evelyn’s perseverance has planted seeds in the generations who follow and it is our belief that our language will survive.\r\n\r\nIt is my honour and privilege to nominate: Nuwaqawa as a "Language Champion" for 2011.\r\n\r\nNominator: Frances D. Brown\r\n	\N		27
45	Kathy Robinson 	Kathy Gallic was born on a windy day in the Broken Group Islands of Barclay Sound, home to many tribes of nuuchahnulth. She lived in a longhouse where everyone spoke their language, worked hard all day and taught all the tradiitonal practices needed to keep their living culture intact. Their summer and winter homes provided shelter when travelling with food resources called “Seasonal Rounds.” Potlatches were schooling for songs, dances and tradition. \r\n\r\nHer family moved to Port Alberni when a law passed that all First Nations’ children must attend a system called the residential school. Despite punishment for speaking her language, Kathy kept her fluency and remained culturally rooted. She married Doug Robinson at 16 and they had 12 children together, eventually adding 22 grandchildren and 25 great grandchildren. \r\n\r\nIn the early 60s, she began picking up the Elders from her community and taking them to her home. Her daughters cooked, baked and fed the Elders, who in turn, taught her and her children the protocols of dancing and singing along with many traditions. \r\n\r\nWhere most people were looking at their retirement years, at 50, Kathy began working at the brand new ḥaaḥuupay̓ak Elementary School with Carrie Little (ʕaaḥuusʔatḥ). She:\r\n•\tCo-developed the foundation for the school's curriculum\r\n•\tWorked tirelessly to keep the language department operating  \r\n•\tFundraised for materials/supplies by holding bake sales and lahal tournaments, working 12 hour days and many weekends \r\n•\tModifed the international phonetic writing system to suit nuuchahnulth, which did not have a writing system \r\n•\tEnsured language integrity and culture were upheld\r\n•\tInstilled passion/love of culture and language into many generations\r\n•\tTook many courses to ensure her best acheivements, including  a computer class. Today, she still works proficently in her own dialect  translating documents on the computer. \r\n\r\nKathy worked at the school for over 18 years, leaving a rich curriculum, protocols for traditional use and also composed prayers for the children. She is always just one call away for the Nuuchahnulth Studies teachers and is the first to say, "I'm not sure, I will ask my Elders."\r\n\r\nIn her late 60s, Kathy formed a company called nuučaanʼuł iic c̓ic̓iqii  “Language belonging to the nuuchahnulth,” documenting the language with Carrie Little. They typed language using a special typewriter ball with unique phonetic symbols. Kathy and Carrie published:\r\n•\tAlphabet Books/Cassettes\r\n•\tWord and Phrase Books/CDs\r\n•\tChristmas Carol Books/CDs\r\n•\tnuučaanʼuł dictionary\r\n•\tCompiled a collection of language documents and language tapes\r\n\r\nAnd assisted in:\r\n•\tNTC websites\r\n•\tFirstVoices\r\n\r\nKathy, an extremly active Elder has contributed to:\r\n•\tTranslated anthropology field notes\r\n•\tTranslated 2 books “ Family Origin Histories: The Whaling Indians” and \r\n“ The Origin Of The Wolf Ritual”\r\n•\tParticipated in over 30 language programs\r\n•\tHolds loonie/toonies for the band’s patient travel budget\r\n•\tWorks for the betterment of the ones who have less\r\n\r\nKathy was instrumental in the success of a children's dance group called the Animal Kingdom. It was her teachings and knowledge of the protocols needed that empowered the children’s performance. \r\n\r\nShe will never take credit for what she knows—she always thanks her late teachers, including her parents, Jimmy and Jessie Gallic, Cecelia Williams, Weenuck, Bessie Dick, Chief Adam and Margaret Shewish, Mable Taylor, Mable Yukum, Billy Yukum, George Clutesi, Jacob Gallic and many more. \r\n\r\nKathy is always reminding people: "Don't bring flowers when we're dead, bring them to us while we are alive!" \r\n\r\nNominator: Lena Ross\r\n	\N		26
1	Charles Elliott	On June 29, 2005, Temoseng Charles Elliott was one of 15 British Columbians honoured with the Order of BC. Family and friends of the recipients gathered at Government House in Victoria for the ceremony, where Lieutenant Governor Iona Campagnolo handed out the medals. The Order of BC, the highest form of recognition the province can extend, is awarded to outstanding British Columbians who have contributed to the province in exceptional ways.\r\n\r\nCharles Elliott has always lived in W̱SANEĆ (Saanich) on southern Vancouver Island, and was inspired by his father, mother and other family members to become an artist. Saanich is a territory surrounded by industrialization and urbanization, where Coast Salish language, culture and arts have been overshadowed for generations. Through his outstanding 2-D and sculptural works Charles has expressed an unwavering commitment to the designs and visual language of his own people. At the beginning of his practice he was required to conduct extensive personal research, in order to locate images and information that he could bring back to life through his work. For almost 3 decades, he has worked to reawaken Coast Salish visual arts, and to share that cultural gift with his community, other artists and the general population. He has done this in a way that is quiet and remains close to home, where he has history, family and connections to a cultural community. During this time he has produced an enormous volume of work, while at the same time acting as a mentor to countless young and emerging artists.\r\n\r\nCharles Elliott’s expression of Coast Salish identity has been motivated by a sense of responsibility to his ancestors and community rather than a desire for personal gain. As a volunteer on the Parent Advisory Committee of the L̵ÁU,WELṈEW̱ Tribal School and as one of the primary organizers and curators of the annual Coast Salish art exhibition in Saanich, Charles is a leader in his community. This sense of leadership is also expressed through his contribution to international ambassadorial works, such as the Queen’s Baton for the 15th Commonwealth Games in 1994, and the creation of a Talking Stick for Nelson Mandela.\r\n\r\nIt has been an inspiration to witness the devotion, generosity and work of Charles Elliott and to see the achievements of the many younger artists who have benefited from their contact with him. It is extremely fitting that Charles Elliott be appointed to the Order of British Columbia as someone who has enriched the lives of not only his contemporaries but those who came before and those who will come after. 	377	Artist	15
15	Lawrence Michel	Home:    Adams Lake\r\nYears Working Towards Language Revitalization:   15\r\n\r\n \r\nLawrence Michel is a fluent Secwepemc speaker who lives on the Adams Lake Reserve. He is a gentle, patient language teacher. \r\n\r\nHe currently teaches language to 4 and 5-year-old children at Chief Atahm School and he teaches traditional skills to adults on the weekend. \r\n\r\nHe has taught language for 15 years, using his traditional knowledge and his carpentry experience. His students have ranged from nursery to elementary and high school age. \r\n\r\nEach summer, Lawrence revisits the ancestral home of the Adams Lake Secwepemc and records traditional place names and stories which are used for language curriculum development and then archived for future generations. This is a highlight of my year. \r\n\r\nLawrence is a storyteller. He continues to share traditional and community stories in Secwepemctsin in our community and at our annual Secwepemc Gathering. Lawrence shows that anything worth learning, can be learned through a story in our language, Secwepemctsin.   \r\n\r\nI am honoured to nominate Lawrence Michel as a Language Champion.\r\n\r\nNominated by Robert Matthew	\N		33
16	Siyamiyateliot 	Home:    Chehalis\r\nYears Working Towards Language Revitalization:   50\r\n\r\n \r\nSiyamiyateliot is a Language Champion because she is the last fluent native speaker of our Upriver Halq’emeylem language.\r\n\r\nAs a residential school survivor, she was one of those who deliberately struggled to keep her language. Today she is still completely fluent, and she has worked for more than 50 years with community language programs to develop books and lessons. She also works every week as a language mentor for her family and for her community.\r\n\r\nShe is one of the first Elders to learn to do language mentoring in-person and on video chat and in chat rooms.  She does this every week with her family and community members. She is one of only a few Elders who has learned to record herself using the high quality First Voices recording kit; she even makes her own mp3s for the young people to listen to.  She shares this audio with all the learners in our communities.\r\n\r\nEvery week Siyamiyateliot is available to share her language on time, on schedule, and working professionally with advanced technical equipment.\r\n\r\nSiyam Siyamiyateliot is always patient, kind, and encouraging, and at the same time challenges us by teaching us the language in the language.  She is a true champion for our language.\r\n\r\nNominated by Sto:lo Shxweli Staff	\N		9
34	June Johnson	Language:    Liq'wala\r\nHome:    Campbell River\r\nYears Working Towards Language Revitalization:   5+\r\n\r\n \r\nJune went back to school as a mature adult.  She has earned her First Nations Traditional Plant and Medicine Certification, completed her Developmental Standard Term Certificate, and ishe s working towards her Bachelor of Education while running her full-time First Nation Accredited Catering Business.  \r\n\r\nJune is a mother of two and a grandmother of five.  She is always there as both Elder and Teacher for anyone wanting to know about traditional plants, language, protocol, or anything else she can help her community with.  \r\n\r\nShe teaches in our HeadStart and preschool programs within the school district, and she was part of the School District #72 Science Fair and took many of the children out to look for traditional plants in preparation for this event.  All of the children love her.  \r\n\r\nShe truly is a champion of our language.\r\n\r\nNominated by Pamela Lee Lewis	\N		29
39	Cecilia DeRose	In spite of attending residential school as a child where speaking her language was discouraged, Cecilia maintained her language.  \r\n\r\nShe worked in all areas of the kindergarten to grade 12 public school system teaching her language and culture to children for 17 years.  \r\n\r\nAfter she retired from the Cariboo Chilcotin School District and raising six children she began working for universities to develop their Aboriginal language programs.  \r\n\r\nCecilia has worked tirelessly in writing and developing curriculum to teach our language and culture in an effort to ensure that the language does not die.\r\n\r\nIn recent years, she has devoted her energy to Head Start programs and enjoys working with young children. Also, she has devoted her time to teaching our language at the Elder’s College in Williams Lake.  \r\n\r\nBesides being a “teacher” in every sense of the word, Cecilia has also taken courses to work as a translator for the RCMP, hospital and the court system.\r\n\r\nShe has attained countless certificates from institutions.\r\n \r\nBesides learning, teaching and translating, Cecilia is also the Elder who is asked most often asked to make buckskin moccasins and gloves; birch bark and pine needle baskets; beaded necklaces, earrings, and hat bands; and beaded eagle feathers—because her work is outstanding. Because of this, her crafts have been sent everywhere across Canada, Australia, England, Japan, Switzerland, Germany and the USA. \r\n\r\nIt’s for these reasons that Cecilia is worthy of being recognized as a Language Champion in BC!\r\n\r\n Nominator: DeDe DeRose\r\n	\N		33
35	Kwosel (Star) Pettis	Home:    Seabird Island Band\r\nYears Working Towards Language Revitalization:   30+ \r\n\r\n \r\nKwosel is a language champion because of her passion for the language and preservation of culture. \r\n \r\nA petite Stó:lō woman who has dedicated her life to the preservation and promotion of the Halq'emeylem language,  Kwosel creates a classroom that embraces Halq'emyelem.  \r\n\r\nStar's love for the language came from her work with the early Coquileetza Elders Group, where she cultivated a dictionary of linguistic techniques and tools.  \r\n\r\nEach day, Kwosel works with everyone from Elders to preschool children.  Her sensitivity to others and patience with learners exemplifies a safe and caring environment that is conducive to learning.  \r\n\r\nShe has a talent for making each student of the language feel as though he or she is the only person in the room.  \r\n\r\nKwosel encouraged, hosted and assisted with development of the Halq'emeylem Integrated Resource Package.\r\n\r\nKwosel assists local families with naming their children and loved ones by translating and spelling out the names, thus touching generations. She facilitated and encouraged the "traditional" naming ceremony at Seabird Island Community School.\r\n\r\nKwosel is truly a Halq’emeylem Champion. \r\n\r\nNominated by Dianna Kay	\N		9
18	Daisy Major	Home:    Coldwater IR #1\r\nYears Working Towards Language Revitalization:   77\r\n\r\n \r\nDaisy Major is a Coldwater Indian Band Elder, mother of 6 adult children, grandmother to her own and many others, eldest sister to 6 brothers and sisters, aunt and cousin to many, and an active community participant. She is also a dependable Elder of the Nicola Valley Institute of Technology (NVIT) Elder Group Advisor Committee, and she gives support and encouragement to the students and staff alike. She still enjoys driving her car and thoroughly enjoys being out in the mountains and gathering her berries and medicines.\r\n\r\nDaisy Major is one the first to be called upon for any Nlakap’mauxcin planning team to help other language learners to read, write and say the words correctly. Through her active participation and generous support she has made many significant contributions to all Nlakap’maux / Scw'exmx language projects through the gathering of Nlakap’mauxcin words/phrases, stories or any traditional and cultural knowledge gathering information.\r\n\r\nEven though she has little formal education, she is very highly educated in her language and traditional ways. She is a very patient, valuable coach who gives positive, constructive feedback to encourage better language speaking and improved writing skills. Although she does not read nor write in the language, she expects the learner to get the word / phrase written down correctly! Learners of all ages look to her to give them positive feedback and to look for new challenges to help themselves to grow even better. \r\n\r\nWith her calm patience, quiet sense of humour, positive attitude, practical knowledge, positive expression, traditional and cultural knowledge, Daisy is truly a respected Nlakap’mauxcin Champion!\r\n\r\nNominated by Bernice Garcia\r\n	\N		12
26	Antoinette Archie	Home:    Canim Lake\r\nYears Working Towards Language Revitalization:   25+\r\n\r\n \r\nAntoinette Archie is a highly respected Elder in the Canim Lake community, and one of the few individuals who is fluent in speaking and writing the Shuswap Language.  Toni is a forward-thinker and she is always planning ways to interest the community in learning their language.\r\n\r\nToni has been involved in many activities, including the language immersion summer camps for the children in the community, the production of the Legends DVD, and the development of learning resources and teaching units for School District #27.  She is developing new education units on a continual basis and the culture of the Shuswap people is integrated into all of the activities.  She has taught adult classes within the community and has been instrumental in developing tapes that will be digitized onto CD's and delivered to each family in the community. \r\n\r\nToni's delightful sense of fun and humour make her elementary school classroom a warm, welcoming place to be.  She works with the language committee for the Northern Shuswap Bands to monitor and plan language revitalization efforts.  \r\n\r\nAntoinette has her Bachelor of Education Degree from Gonzaga University and her B.A. in Linguistics from Simon Fraser University.   \r\n\r\nShe is currently being encouraged to develop the Mac Books of cultural activities and Elder stories in the Shuswap Language with the children.  The first example will be shared at the Languages Conference (workshop sessions 1A and 2A) when we bring the pictures and the language from our Gustafson Lake cultural fishing day.  We have applied for a Literacy Now grant to produce 40 books for our community.\r\n\r\nNominated by Barb MacLeod	\N		33
40	Gracie John	Gracie John grew up with the language, taught and promoted the language throughout her adult life and began teaching in the schools in 1975. \r\n\r\nShe has learned to read and write the language and is invaluable in our efforts to develop curriculum materials for both preschool and K–12 as well as for adults.\r\n\r\nGracie is very careful about getting everything she develops in Dakelh right and will spend many hours making sure what she is contributing is without error. \r\n\r\nPresently Gracie is working with our Carrier Language teacher, Karen Thomas, to develop curriculum materials for both FirstVoices and for the classroom. They have gone over reams of material correcting any errors and then formatting the material for both print and audio recordings. \r\n\r\nWe are also looking at establishing a DSTC language program in Saik'uz to pass on Gracie knowledge as well as that of our other Elders that are knowledgeable about the language. Gracie wants very much to be a part of this process and will most likely be responsible for much of the teaching and mentoring of the students who enroll in this program should we be fortunate enough to mount the program.\r\n\r\nNominator: Deborah Page\r\n	\N		18
14	Brett Waterfall	Home:    Bella Bella\r\nYears Working Towards Language Revitalization:   7\r\n\r\n \r\nBrett Waterfall has taken it upon himself to mentor our young people in cultural singing, language speaking, and public speaking using our language.  He will be developing a language nest program with our health center to target newborns to toddler age children whose parents work at the health center. The nest will be housed within that building.  Brett is also mentoring and supervising language trainees who are enrolled in linguistic courses, as well as in conversational classes and mentorships with fluent speakers.\r\n\r\nBrett wasn't born into the language, whereas I, his mother, was.  I lost my ability to speak my language after having it strapped out when I attended day and residential schools.  Brett, through his patient and gentle nurturing, has inspired me to regain my language speaking skills.  I am so inspired by his example and realize that if someone like him can master our language, then I have no reason or excuse to dwell in the past.  He speaks to little children, including his own, ages 1 and 3 years.  He conducts a weekly cultural-language-singing-dancing program with young children who are very engaged and enjoy the experiences.  He is passionate about keeping our language alive, with its near-extinction status.  He records fluent speakers while completing a library of CD-readers that include real-time local photos shown in the context of speaking the language.  \r\n\r\nHe is 31 years old and has youth on his side--so, I am confident that by his example and with his investment, our language will remain strong and one day, I will speak it fluently, as I did before attending formal school.  He is my language hero.  \r\n\r\nNominated by Pauline Waterfall\r\n	\N		27
21	Ticwtkwa 	Home:    Lil'wat, Mount Currie\r\nYears Working Towards Language Revitalization:   30+ years\r\n\r\n \r\nTicwtkwa Georgina Nelson speaks fluently to her many grand and great-grandchildren. She is always available by telephone, email and in person to help with language speaking.\r\n\r\nTicwtkwa Georgina has been working on reviving our language and culture since 1971.  In 1971 she realized that the public school was not working for some of our Lil'wat children. She believed that the children needed to be immersed in their own traditional language and culture.  She started lobbying for funding to build a new school and to train our own teachers. \r\n\r\nGeorgina always stated, "Without our language and culture we would no longer be a Lil'wat People." She has striven to keep the language and culture alive for over 30 years. \r\n\r\nOver the years she has been involved in any activity that had to do with education, language or culture. She was a big part of the Band taking over our own education and the development of the new school. She served on the Board of Education for years and still does today, and she pushed to start an immersion school, which continues to flourish. She is recently working with a team to develop a Language Authority to include 11 Bands. Georgina is a language champion for her family, her community, and her province. \r\n\r\nShe is a language champion at the international level, as well.  Dr. Budd L Hall, former Dean of Education at the University of Victoria, adds, “Georgina Nelson was invited as a ‘Mother Tongue’ language specialist to work with the staff of the Mpambo Afrikan Multiversity in Busoga, Kingdom, Uganda. She spoke to them of her work in Mt. Currie and the importance of keeping Mother Tongue languages alive. Her words and experience had a powerful impact on the staff and community in the village of Isegero.”  \r\n\r\nNominated by Lois Joseph	\N		13
46	Dr. Earl Claxton Sr. 	Dr. Earl Claxton Sr. was born and raised in TSAWOUT. He was born on May 12, 1931, to Elsie (nee Pelkey) and Johnny Claxton, and was the eldest of six children.  \r\n\r\nEarl’s first language as a child was SENĆOŦEN, and he learned to speak English when he was 16 years old. Earl was one of the last fluent speakers in the SENĆOŦEN Language and was recognized for his work (curriculum development) through the University of Victoria in November 2006, with a Doctorate of Laws.  \r\n\r\nIn the early 1980s Earl began his work with the LAU,WELNEW Tribal School on language curriculum as a Researcher/Curriculum Developer. His work on the SENĆOŦEN Language became valuable to the WSÁNEĆ and Lummi First Nations for its importance to having the language written.  \r\n\r\nEarl had much knowledge of the WSÁNEĆ place names. With the assistance of Earl’s Mother Elsie Claxton, and his first cousin Manson Pelkey, Earl was instrumental in the development of the Territorial Map, which uses WSÁNEĆ place names. This map was used at the trial for Saanichton Marina vs Claxton (1989). \r\n\r\nJohn Elliott (the late Dave Elliott Sr.’s son) and Earl co-authored many books for the students at LAU,WELNEW, which include Moons, Tides, and The Reef Net, to name a few.\r\n\r\nEarl worked on the language curriculum tirelessly until his illness in February 2007. Through language curriculum development, Earl completed his lifelong dream, to assist the late Dave Elliott Sr. and John Elliott, to ensure the continuation of the SENĆOŦEN Language for the WSÁNEĆ people.  \r\n\r\nThere are many WSÁNEĆ Elders who have contributed to the conservation of the SENĆOŦEN Language, and many young apprentices that will aide to ensure the continuation of the language.\r\n\r\nNominator: Kendra Underwood\r\n	\N		15
43	Verna Williams	The name Verna Williams is synonymous with the revitalization of the Nisga'a Language. She has been instrumental and in some cases, one may say, has single-handedly ensured through her hard work and dedication that the Nisga'a Language will "not" be lost. \r\n\r\nFor the past 35 years she has been directly involved in the following:\r\n•\tthe establishment of the Nisga'a Language program in our schools, \r\n•\tour locally owned university/college first nation studies program, \r\n•\tlocal community language programs—travelling throughout the Nass Valley teaching the language,\r\n•\tthe writing of our language, \r\n•\tthe standardization of the written language, \r\n•\tthe Nisga'a alphabet, \r\n•\tthe designing of the Nisga'a Language Curriculum for all age groups from four year olds to adult learners,  \r\n•\ta pilot project on Nisga'a immersion, \r\n•\tthe transformation of our language from written to digital format,  \r\n•\tthe formation of the Nisga'a Language Preservation Society\r\n\r\nVerna has been further involved in teaching the culture and traditions of the Nisga'a Nation, which include:\r\n•\tOur feast system\r\n•\tOur Nisga'a Laws\r\n•\tNisga'a traditional protocol\r\n•\tRole of chiefs & matriarchs\r\n•\tNisga'a traditional foods\r\n•\tNisga'a traditional medicines\r\n\r\nThroughout her work with the Nisga'a Language, Culture and Traditions, she has taught many students. She has trained many former students to become language champions within their communities so that the teaching of the Nisga'a Language will never be lost.  \r\n\r\nTruly her most successful students are those who could not speak the language when they began the course and today, many of these students are "fluent" Nisga'a Language speakers and teachers.\r\n\r\nIn May 2010, Verna was bestowed the greatest honour of her career from the University of Northern B.C. and Wilp Wilxo'oskwl Nisga'a Institute (our local university/college) — a Doctorate Degree, "Professor Emeritus," for her lifetime dedication and service for the Nisga'a Language Program. On June 1, 2010, the community of Gitlaxt'aamiks hosted a recognition dinner in honour of her award.\r\n\r\nVerna has tried to retire many times but is continually called upon by various Nisga'a institutions to assist with language programs and initiatives. So, today she continues to carry the torch for the revitalization of the Nisga'a Language with no end in sight for her to retire.\r\n\r\nIn February, 2011, as the Nisga'a Nation began the preparation of the opening of the Museum, located in Laxgalts'ap, Verna was once again called upon by Nisga'a Lisims Government to assist with the writing and translation of the Nisga'a Artifacts returned to the Nisga'a Nation for display in our museum.\r\n\r\nOne of Verna's greatest concerns as she has tried to prepare for retirement was the preservation of the Nisga'a Language. To move this initiative forward, she began talking to elders and fluent Nisga'a Language speakers. In March 2011, she assisted with the formation of a Nisga'a Language Preservation Society and on June 8, 2011 they had their inaugural meeting for the preservation of the Nisga'a Language.\r\n\r\nThe Gitlaxt'aamiks Village Government, the community of Gitlaxt'aamiks and the Nisga'a Nation are very proud to submit Verna Williams’ name as our nomination for Language Champion.\r\n\r\nNominator: Darlene Morgan\r\n	\N		32
42	Clara Camille	Clara Camille is a Secwepemc Elder from the Canoe Creek Band. Clara enjoys teaching the Secwepemc Language and Culture to anyone who is willing to learn and she uses any opportunity to speak the language with the Secwepemc Elders throughout the territory.  \r\n\r\nClara has worked as the Language and Culture Instructor intermittently for three years for the Dog Creek Elementary School and most recently she was also one of two mentors for the First Peoples’ Heritage, Language and Culture Council’s Master-Apprentice Program and was one of the instructors for the language immersion course in the community.   \r\n\r\nIn addition to the classroom setting, Clara is one of the community Elders who are very often called on to assist members to go out into the territory to collect medicines, build sweathouses, provide Secwepemc place names, etc.     \r\n\r\nAlthough Clara has been teaching for many years, she readily admits that one of her goals is to work on learning to write the language, as this is one of the areas she finds challenging when she is trying to assist students who have begun learning the language in the school.   \r\n\r\nClara continues to be an avid learner who willingly participates in courses and workshops to increase her own knowledge and teaching skills to instruct and promote Secwepemcstin. This summer she will be participating as a student and assisting in the Secwepemc Language Programs being coordinated by the Weekend University Program in the territory.  \r\n  \r\nClara is our Language Champion because she is a role model who readily gives much of her life to promoting and teaching the Secwepemc Language and Culture. \r\n\r\nNominator: Marilyn Camille\r\n	220		33
13	Bev Phillips	Home:    Lytton\r\nYears Working Towards Language Revitalization:   16+\r\n\r\n \r\nBev Phillips is a language champion and an inspiration.  Since the inception of Stein Valley Nlakapamux School (then it was called Mestanta Technical Institute) in 1993, she has been teaching Nlha.kapmhhchEEn to students from Kindergarten to Grade 7. She is the sole language teacher who has persevered through many challenges and frustrations. \r\n\r\nBev's passion for the language is evident and her work embraces the practices of our traditional teachings.  With the guidance of her Elders, she taught herself how to teach, and through the active play and hands-on activities she has designed, the children are learning our language.  \r\n\r\nBev developed the phonetic alphabet for the school and she creates her own teaching resources.  When requested, she teaches Nlha.kapmhhchEEn to community members.  Bev consults with the Elders and she is part of the Nlha.kapmhhchEEn Language Committee.  Within our community, she is probably the youngest person who speaks our language fluently on a daily basis and we value her work to teach and promote the language.  \r\n\r\nBev Phillips is a well-respected community member whose passion to save Nla.kapmyhchEEn has made a positive difference in our community and in our school.\r\n\r\n<i>Nominated by: Carol Homes</i>	\N		12
25	Nancy Camille	Home:    Canoe Creek\r\nYears Working Towards Language Revitalization:   Many\r\n\r\n \r\nNancy Camille is an Elder from the Canoe Creek reserve and a fluent Secwpemc speaker. Nancy is the mother of eleven, grand-mother of fifteen, great-grand-mother of sixteen. Nancy is very proud of her family and can still be seen babysitting her great-grandchildren when needed. \r\n\r\nShe has always worked hard to preserve our Secwpemc language. She is also very knowledgeable in the culture and traditions of the Secwepemc people and has shared her knowledge with all who are willing to learn. \r\n\r\nNancy has taught the language for the past fifteen years in a classroom setting, but has always taught it in everyday life as long as she had students willing to learn. She has taught at Rosie Seymour Elementary School, Canoe Creek Head Start and the Canoe Creek Health Centre.  She speaks the language on a regular basis and she encourages the whole community to learn our language.\r\n\r\nShe has taught all age groups; the preschool age students, elementary school children, youth and adults. She is a very patient teacher who is willing to do lessons over and over.\r\n\r\nShe is an excellent role model for our community who graduated from Simon Fraser University at the age of 71 with a Certificate in First Nations Language Proficiency. \r\n\r\nAt present, Nancy is a Mentor for the Master Apprentice Program sponsored by the First Peoples’ Heritage Language and Culture Council. This is a mixed group starting right from beginners to semi-fluent speakers. \r\n\r\nNancy is always willing to learn new ways of preserving the language, from recording on cassettes tapes to learning how to record on the computer.  She attended a training program called ACORNS and wasn’t intimidated at all about working with computers. \r\n\r\nNancy is loved and respected by the whole community because of the work she does to keep Secwepmctsin alive in Canoe Creek and I am very proud to nominate her as our Language Champion.\r\n\r\nNominated by Darlene Louie	\N		33
28	Violet Johnson	Home:    Gold River\r\nYears Working Towards Language Revitalization:   15\r\n\r\nViolet Johnson is affectionately known to all the children on the Mowachaht/Muchalaht village of Tsaxana, and in the town of Gold River as "Nan." \r\n \r\nShe has been the language Elder at Ray Watkins Elementary School for two mornings a week since 2004.  She teaches Nuu-chah-nulth to all the children from Kindergarten to grade four.  The Aboriginal children from grade five to grade seven attend sessions with her once a week. In addition, Nan teaches at Agnes George Preschool on the reserve two afternoons a week.\r\n  \r\nThis year Nan has been attending Gold River Secondary School one hour a week to expose the senior students in First Nations Studies 12 to the local language and culture.  \r\n\r\nShe works tirelessly with the youth to revitalize the language she has retained, despite spending 10 years of her life in the residential school system.  \r\n\r\nIn addition to her work with youth, Nan has been an advocate for language revitalization within the community.  She has participated in a language research project in the culture and heritage department of the Mowachaht/Muchalaht First Nation sponsored by the University of British Columbia.  She regularly attends Elder meetings and is a strong advocate within her peer group for the intergenerational transfer of the Nuu-chah-nulth language. \r\n\r\nShe was a contributing member of the group which articulated the Aboriginal Enhancement Agreement with School District #84 and the BC Ministry of Education.  \r\n\r\nLastly, Nan's work with one of the local teachers was recognized in the BC legislature this spring, when that teacher received the Premier's Award for Teaching Excellence in Aboriginal Education.  Nan is an inspiration to all around Tsaxana and Gold River.  \r\n\r\nWe know she is OUR language champion.\r\n\r\n\r\nNominated by Rosamund Latvala	\N		25
\.


--
-- Data for Name: language_community; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_community (id, name, point, population, email, website, english_name, internet_speed, alt_phone, fax, other_names, phone, notes, regions) FROM stdin;
218	Wei Wai Kum First Nation	0101000020E6100000AE65321CCF4F5FC0215A2BDA1C054940	658	crband@telus.net				1-877-286-6949	(250) 287-8838	Campbell River First Nation			
226	Stz'uminus First Nation	0101000020E6100000225514AFB2F65EC0D82B2CB81F824840	0	\N	\N			(250) 245-7155	(250) 245-3012	Chemainus First Nation			
221	We Wai Kai First Nation	0101000020E6100000D95E0B7A6F4D5FC0481630815B054940	917	\N				(250) 285-3316	(250) 285-2400	Cape Mudge			
210	Scia'new (Beecher Bay)	0101000020E6100000E6CE4C309CE65EC05F43705CC62B4840	0	\N				(250) 478-3535	(250) 478-3585	Beecher Bay First Nations		\n\nThe Scia'new First Nations' main community is on Beecher Bay, in East Sooke, 30 km southwest of Victoria.\n\nThe Scia'new First Nations' main community is on Beecher Bay, in East Sooke, 30 km southwest of Victoria.\n\nThe Scia'new First Nations' main community is on Beecher Bay, in East Sooke, 30 km southwest of Victoria.\n\nThe Scia'new First Nations' main community is on Beecher Bay, in East Sooke, 30 km southwest of Victoria.\n\nThe Scia'new First Nations' main community is on Beecher Bay, in East Sooke, 30 km southwest of Victoria.\n\nThe Scia'new First Nations' main community is on Beecher Bay, in East Sooke, 30 km southwest of Victoria.	
211	Blueberry River First Nations	0101000020E61000008F52094FE8485EC0C1A7397991614C40	401	lblue@blueberryfn.ca				(250) 630-2584	(250) 630-2588	Blueberry River Indian Band	1-800-988-3533	\n\nThe Blueberry River First Nations is a member of the Treaty 8 Tribal Association in Northeastern BC.\n\nThe Blueberry River First Nations is a member of the Treaty 8 Tribal Association in Northeastern BC.\n\nThe Blueberry River First Nations is a member of the Treaty 8 Tribal Association in Northeastern BC.\n\nThe Blueberry River First Nations is a member of the Treaty 8 Tribal Association in Northeastern BC.\n\nThe Blueberry River First Nations is a member of the Treaty 8 Tribal Association in Northeastern BC.\n\nThe Blueberry River First Nations is a member of the Treaty 8 Tribal Association in Northeastern BC.	
227	Cheslatta Carrier Nation	0101000020E6100000B80721205F715FC06058FE7C5B024B40	319	ccn@lakescom.net	\N		Dial-in[[93]]	(250) 694-3334	(250) 694-3632			...\n\nNeed introductory text...	
212	St'uxwtéws (Bonaparte)	0101000020E6100000F853E3A59B545EC05E4BC8073D634940	0	bonaparteindianband@goldtrail.com	http://www.shuswapnation.org/bonaparte			(250) 457-9624	(250) 457-9550	Bonaparte Indian Band			
231	Cowichan Tribes	0101000020E6100000139A249694ED5EC0A8C821E2E6624840	0	\N	http://www.cowichantribes.com			(250) 748-3196	(250) 748-1233			\n\nCowichan Tribes are on Vancouver Island...\n\nCowichan Tribes are on Vancouver Island...\n\nCowichan Tribes are on Vancouver Island...\n\nCowichan Tribes are on Vancouver Island...\n\nCowichan Tribes are on Vancouver Island...\n\nCowichan Tribes are on Vancouver Island...	
213	Boothroyd Band	0101000020E6100000959A3DD00A5F5EC00685419946FB4840	263	boothroyd@uniserve.com	\N			(604) 867-9211	(604) 867-9747	Boothroyd Band			
214	Boston Bar First Nation 	0101000020E61000001E166A4DF35C5EC0FA2AF9D85DF04840	0	bbarbandd@uniserve.com	\N			(604) 867-8844		Boston Bar First Nation			
215	Nxwísten (Bridge River)	0101000020E6100000D4D4B2B5BE7D5EC001158E2095624940	0	xwisten@uniserve.ca	http://www.xwisten.ca			(250) 256-7423	(250) 256-7999	Bridge River Indian Band		Our main community is on the Bridge River reserve where we have our band offices, community hall, and operate a number of businesses.\n\nXwísten is located approximately 11km outside of Lillooet along the Bridge River.	
217	Tsleil-Waututh Nation	0101000020E6100000FFCA4A9352BF5EC0569FABADD8A74840	0	\N	http://www.burrardband.com			(604) 929-3454	(604) 929-4714	Burrard Indian Band	1-866-929-3454		
223	Chawathil First Nation	0101000020E61000000C93A982515C5EC068CC24EA05B14840	0	chawath@hughes.ca				(604) 869-9994	(604) 869-7614	Chawathil First Nation			
224	Cheam First Nation	0101000020E61000002A58E36C3A705EC00133DFC14F984840	473	cheamband@uniserve.com			High-Speed[[93]]	(604) 794-7924	(604) 794-7456			In addition to the health clinic and adminstration offices, Cheam has recently build a large "smoke house".\n\nThe Cheam First Nation's main community is now on the Cheam Reserve near Chilliwack. Their traditional territory spans the Fraser River and includes many rich fishing, hunting and other food gathering areas.	
233	Daylu Dena Council	0101000020E610000033C2DB83900F60C0D9EA724A40F64D40	0	dayludena@lincsat.com				(250) 779-3161	(250) 779-3371				
234	Dease River First Nation	0101000020E6100000096CCEC1B34660C070ECD973991A4D40	0	\N				(250) 239-3000	(250) 239-3003	Dease River First Nation			
207	Aitchelitz First Nation 	0101000020E6100000349C3237DF7F5EC0335184D4ED924840	0	\N						Aitchelitz First Nation 			
208	Tsi Del Del	0101000020E61000000A83328D26045FC0CD76853E580E4A40	624	acfn@alexiscreekfirstnation.com	http://www.alexiscreekfirstnation.com			(250) 481-3335	(250) 481-1197	Alexis Creek Indian Band		\n\nTsi Del Del is a Tsilhqot'in community that the Canadian government has called Alexis Creek Band.\n\nTsi Del Del is a Tsilhqot'in community that the Canadian government has called Alexis Creek Band.\n\nTsi Del Del is a Tsilhqot'in community that the Canadian government has called Alexis Creek Band.\n\nTsi Del Del is a Tsilhqot'in community that the Canadian government has called Alexis Creek Band.\n\nTsi Del Del is a Tsilhqot'in community that the Canadian government has called Alexis Creek Band.\n\nTsi Del Del is a Tsilhqot'in community that the Canadian government has called Alexis Creek Band.	
235	Ditidaht First Nation	0101000020E61000004CDE0033DF2A5FC0E415889E94674840	0	ditidaht@islandnet.com				(250) 745-3333	(250) 745-3332		1-888-745-3366		
236	Doig  River First Nation	0101000020E61000003604C765DC325EC03B014D840D3F4C40	249	\N				(250) 827-3776	(250) 827-3778	Doig River First Nation 	1-888-344-9997		
244	Gitsegukla Band Council	0101000020E6100000A39410ACAAEA5FC0EE0912DBDD9D4B40	0	\N	http://www.gitsegukla.org/			(250) 849-5490	(250) 849-5492	Gitsegukla Band 			
239	Esketemc	0101000020E610000021C8410933895EC02DD0EE9062104A40	0	alib5@wlake.com	http://www.nativejourneys.ca			(250) 440-5611	(250) 440-5721	Alkali Lake Indian Band	1-866-440-5611	\n\nThe Esketemc traditional territory is in in the Cariboo region and includes Akali Lake.\n\nThe Esketemc traditional territory is in in the Cariboo region and includes Akali Lake.\n\nThe Esketemc traditional territory is in in the Cariboo region and includes Akali Lake.\n\nThe Esketemc traditional territory is in in the Cariboo region and includes Akali Lake.\n\nThe Esketemc traditional territory is in in the Cariboo region and includes Akali Lake.\n\nThe Esketemc traditional territory is in in the Cariboo region and includes Akali Lake.	
255	Heiltsuk Nation	0101000020E6100000CE1C925AA80460C0853E58C686144A40	0	mslett@bellabella.net	http://www.bellabella.net			(250) 957-2381	(250) 957-2544	Heiltsuk Band			
256	Hesquiaht	0101000020E61000004128EFE368915FC07218CC5F21AF4840	660	\N			Dial-in[[93]]	(250) 670-1100	(250) 670-1102	ḥiškʷi		The community at Hot Springs Cove has about 40 households and the majority of Hesquiaht people live in Port Alberni and other urban centres.\n\nThe Hesquiaht First Nation is on the west coast of Vancouver island where their traditional territory stretches from roughly Nootka Sound to  Clayoquot Sound. Their largest community is at Hot Springs Cove (former known as Refuge Cove) and can be reached by boat or float plane.  	
261	Iskut First Nation	0101000020E61000007B82C476773F60C0BBD6DEA7AAEA4C40	599	iskutfirstnations@yahoo.ca	http://www.iskutfn.ca			(250) 234-3331	(250) 234-3200	Iskut First Nation		"Iskut is located at the 407 km mark on Highway 37 and is approximately 5.5 hours from both Terrace and Smithers and within 7 hours drive from Whitehorse, Y.T."[[http://en.wikipedia.org/wiki/Iskut,_British_Columbia]]	
240	SXIMEȽEȽ (Esquimalt)	0101000020E61000001DE4F56052DB5EC02619390B7B384840	255	\N			 High-Speed[[93]]	(250) 381-7861	(250) 384-9309	Esquimalt Nation		The SXIMEȽEȽ people...\n\nSXIMEȽEȽ (Esquimalt) people's main reserve is in the municapality that bears an anglicised version of their name - Esquimalt. Their traditional territory is on the southern tip of Vancouver Island and surrounding waterways and islands. 	
242	Gitanmaax Band Council	0101000020E6100000A051BAF42FEB5FC05264ADA1D4A04B40	0	info@gitanmaax.com	http://www.gitanmaax.com			(250) 842-5297	(250) 842-6364	Gitanmaax Band	1-800-663-4590	\n\nThe Gitanmaax people call their language Gitsanimx̱.\n\nThe Gitanmaax people call their language Gitsanimx̱.\n\nThe Gitanmaax people call their language Gitsanimx̱.\n\nThe Gitanmaax people call their language Gitsanimx̱.\n\nThe Gitanmaax people call their language Gitsanimx̱.\n\nThe Gitanmaax people call their language Gitsanimx̱.	
243	Gitanyow Band Council	0101000020E6100000BD00FBE8D40060C0F31C91EF528E4B40	0	gitanyow_band537@yahoo.ca	http://www.band.gitanyow.com/			(250) 849-5222	(250) 849-5787	Kitwancool			
245	Gitwangak Band Council	0101000020E61000004F20EC142B0260C022A64412BD8C4B40	0	gitwangak@navigata.net	http://www.gitwangak.ca/			(250) 849-5591	(250) 849-5353	Gitwangax̱	1-877-688-5580		
247	Sik-edakh (Glen Vowell)	0101000020E61000002BA391CF2BEB5FC0BABBCE86FCA74B40	0	glenv@uniserve.net	http://www.sik-e-dakh.com/			(250) 842-5241	(250) 842-5601	Glen Vowell Band,Sik-adox,Sik-e-dakh	1-877-653-8833		
249	Gwawaʼenux̱w	0101000020E61000003E0801F912D85FC04D9F1D705D574940	38	gwawas@island.net 				(250) 949-8732	(250) 949-8732	Gwawaenuk Tribe		\n\nThe Gwawaʼenux̱w (Gwawaenuk Tribe) speak the Kwak'wala language. \n\nThe Gwawaʼenux̱w (Gwawaenuk Tribe) speak the Kwak'wala language. \n\nThe Gwawaʼenux̱w (Gwawaenuk Tribe) speak the Kwak'wala language. \n\nThe Gwawaʼenux̱w (Gwawaenuk Tribe) speak the Kwak'wala language. \n\nThe Gwawaʼenux̱w (Gwawaenuk Tribe) speak the Kwak'wala language. \n\nThe Gwawaʼenux̱w (Gwawaenuk Tribe) speak the Kwak'wala language. 	
251	Halalt First Nation	0101000020E61000006DE525FF93EC5EC04D69FD2D01704840	0	\N				(250) 246-4736	(250) 246-2330	Halalt First Nation 			
257	Llenlleney'ten (High Bar)	0101000020E61000001EA9BEF38B655EC0691B7FA2B28B4940	73	highbar@bcwireless.com				(250) 459-2117	(250) 459-2119	High Bar First Nation		\n\nThe Llenlleney'ten have been known as High Bar.\n\nThe Llenlleney'ten have been known as High Bar.\n\nThe Llenlleney'ten have been known as High Bar.\n\nThe Llenlleney'ten have been known as High Bar.\n\nThe Llenlleney'ten have been known as High Bar.\n\nThe Llenlleney'ten have been known as High Bar.	
253	Halfway River First Nations	0101000020E6100000B874CC79C6735EC0094E7D20795D4C40	242	admin@hrfn.ca	http://www.hrfn.ca			(250) 772-5058	(250) 772-5200				
258	Homalco First Nation	0101000020E61000001EFAEE56964F5FC008E57D1CCDF94840	0	homalcofn@hotmail.com	http://www.homalco.com			(250) 923-4979	(250) 923-4987				
238	ʔiiḥatis (Ehattesaht)	0101000020E6100000CBBE2B82FFB65FC00D501A6A14FE4840	317	ehatis@telus.net			 Dial-in[[93]]	(250) 761-4155	(250) 761-4156	Ehattesaht First Nation,Ehattesaht Tribe		??\n\nEhattesaht is part of the Nuu-Chah-Nulth Tribal Council. We are a comparatively small tribe (despite owning 66,000 hectares) with 305 members located in the Zeballos inlet which is a part of the Esperanza inlet and that is on Vancouver island. To get there you would need to pass a logging road or take a plane boat or helicopter.[[Text copied from the Ehattesaht homepage: http://ehattesaht.com/index.html]]	
289	Lyackson First Nation	0101000020E6100000AA2B9FE579EC5EC09E0AB8E7F96F4840	0	lyackson@shawcable.com	http://www.lyackson.bc.ca			(250) 246-5019	(250) 246-5049	Lyackson First Nation	1-888-592-5766		
265	Katzie First Nation	0101000020E6100000874F3A9160AB5EC082531F48DE994840	0	\N	http://www.katzie.ca			(604) 465-8961	(604) 465-5949	Katzie First Nation			
270	Klahoose First Nation	0101000020E6100000A39410ACAA3A5FC0DFC2BAF1EE0E4940	0	info@klahoose.org	http://www.klahoose.com			(250) 935-6536	(250) 935-6997				
273	Kwakiutl Band Council	0101000020E61000004834812216DA5FC0A35C1ABFF0584940	0	manager@kwakiutl.bc.ca	http://www.kwakiutl.bc.ca			(250) 949-6012	(250) 949-6066	Kwakiutl Band Council 			
278	Kwikwetlem First Nation	0101000020E6100000E466B8019FB35EC03197546D379F4840	61	kwikwetlem@shaw.ca	http://www.kwikwetlem.com			(604) 540-0680	(604) 525-0772	Kwikwetlem First Nation 			
279	Lake Babine Nation	0101000020E6100000C6DFF60489705FC03909A52F841E4B40	0	\N	http://www.lakebabine.com			(250) 692-4700	(250) 692-4790	Lake Babine Nation	1-888-692-3214		
280	Lake Cowichan First Nation	0101000020E61000007061DD7877035FC0927A4FE5B4694840	15	lcfndoug@telus.net	http://www.hulquminum.bc.ca			(250) 749-3301	(250) 749-4286	Lake Cowichan First Nation 		\n\nThe main community of the Lake Cowichan First Nation is locaed on the north shore of Cowichan Lake.\n\nThe main community of the Lake Cowichan First Nation is locaed on the north shore of Cowichan Lake.\n\nThe main community of the Lake Cowichan First Nation is locaed on the north shore of Cowichan Lake.\n\nThe main community of the Lake Cowichan First Nation is locaed on the north shore of Cowichan Lake.\n\nThe main community of the Lake Cowichan First Nation is locaed on the north shore of Cowichan Lake.\n\nThe main community of the Lake Cowichan First Nation is locaed on the north shore of Cowichan Lake.	
281	Lax Kw'alaams Band	0101000020E61000002FDCB930D24D60C008008E3D7B464B40	0	council@citytel.net 	http://www.laxkwalaams.ca			(250) 625-3293	(250) 625-3246	Lax Kw'alaams Band	1-877-725-3293		
282	Leq'á:mel First Nation	0101000020E610000061191BBAD9815EC0D3BF2495299A4840	342	info@lakahahmen.com	http://www.lakahahmen.com			(604) 826-7976	(604) 826-0362	Lakahahmen First Nation		Leq'á:mel First Nation utilizes three reserves for residential uses, two as cemeteries, and as for the other five, are either under a Certificate of Possession to members, leased for agricultural use, or future sites for Economic Development.\n\nLeq'á:mel First Nation, formerly known as Lakahahmen First Nation, is located 22 kilometres east of Mission, British Columbia.	
286	yaqan nuʔkiy (Lower Kootenay)	0101000020E6100000206118B0E41F5DC047E4BB94BA844840	210	\N				(250) 428-4428	(250) 428-7686	Lower Kootenay Band 		\n\nyaqan nuʔkiy (Lower Kootenay Band) have their main community in Creston, BC. The name yaqan nuʔkiy literally means "where the rock stands"[[291]].\n\nyaqan nuʔkiy (Lower Kootenay Band) have their main community in Creston, BC. The name yaqan nuʔkiy literally means "where the rock stands"[[291]].\n\nyaqan nuʔkiy (Lower Kootenay Band) have their main community in Creston, BC. The name yaqan nuʔkiy literally means "where the rock stands"[[291]].\n\nyaqan nuʔkiy (Lower Kootenay Band) have their main community in Creston, BC. The name yaqan nuʔkiy literally means "where the rock stands"[[291]].\n\nyaqan nuʔkiy (Lower Kootenay Band) have their main community in Creston, BC. The name yaqan nuʔkiy literally means "where the rock stands"[[291]].\n\nyaqan nuʔkiy (Lower Kootenay Band) have their main community in Creston, BC. The name yaqan nuʔkiy literally means "where the rock stands"[[291]].	
288	Lower Similkameen Indian Band	0101000020E6100000B1A371A8DFF45DC0CE70033E3F9A4840	0	\N	http://www.lsib.org			(250) 499-5528	(250) 499-5538	Lower Similkameen Indian Band 			
290	Lytton First Nation	0101000020E610000076F9D687F5645EC05BECF659651E4940	0	\N	http://www.lyttonfirstnation.ca			(250) 455-2304	(250) 455-2291	Lytton First Nation			
266	Anspa yaxw (Kispiox)	0101000020E6100000B344679945EC5FC037894160E5AC4B40	0	kbc@uniserve.com	http://www.kispioxband.com/			(250) 842-5248	(250) 842-5604	Kispiox Band Council	1-877-842-5911		
268	Kitselas First Nation	0101000020E6100000B24B546F8D0560C01DAED51EF6F64A40	537	\N	http://www.kitselas.bc.ca			(250) 635-5084	(250) 635-5335	Gitselasu	1-888-777-2837		
271	Lhoosk'uz Dene Nation	0101000020E6100000E4BA29E5B5A05EC0D619DF17977C4A40	199	admin@lhooskuz.com	http://www.lhooskuz.com		 High-Speed[[93]]	(250) 747-3293	(250) 747-3294	Kluskus First Nation,Lhoosk'us Dene Nation		The Lhoosk'uz Dene Nation reserve community and offices are located near Quesnel. The First Nation is a member of the Carrier-Chilcotin Tribal Council, which includes both Dakelh (Carrier) and Tsilhqot'in communities.	
274	Kwantlen First Nation	0101000020E610000036CEA62380A55EC06BF46A80D2944840	0	\N				(604) 888-2488	(604) 888-2442	Kwantlen First Nation			
206	Ahousaht	0101000020E61000003C2EAA4544845FC05470784144A44840	1857	\N	http://www.ahousaht.com		Dial-in[[93]]	(250) 670-9563	(250) 670-9696	Ahousat		Maaqtisiis has a population of over 600[[Statistics Canada (2006)community profile for Marktosis 15: http://www12.statcan.ca/english/census06/data/profiles/community/Details/Page.cfm?Lang=E&Geo1=CSD&Code1=5923808&Geo2=PR&Code2=59&Data=Count&SearchText=MARKTOSIS&SearchType=Begins&SearchPR=01&B1=All&Custom=with ]] a health centre, school, and recreation centre.\n\nThe Ahousaht First Nation has the largest population of all Nuučaan̓uɫ First Nations and their main village is at Maaqtisiis (Marktosis)[[Wikipedia Marktosis entry: http://en.wikipedia.org/wiki/Marktosis%2C_British_Columbia]] on Flores Island on the west coast of Vancouver Island. Ahousaht traditional territory encompasses Flores Island and areas in and around Clayoquot Sound as well as neighbouring valleys and mountains.	
269	Kitsumkalum Band Council	0101000020E6100000C4CC3E8FD11260C08B19E1ED41424B40	0	\N	http://www.kitsumkalum.bc.ca			(250) 635-6177	(250) 635-4622	Kitsumkalum Band Council 			
275	Kwaw-kwaw-apilt First Nation	0101000020E61000003DF20703CF7C5EC01AC40776FC954840	41	\N				(604) 858-3366	(604) 824-5326	Kwaw-kwaw-apilt First Nation 			
276	Kwiakah First Nation	0101000020E610000041B7973446505FC0A4DE5339ED034940	19	kwiakah@hotmail.com				(250) 286-1295	(250) 286-1285	Kwiakah First Nation			
250	Hagwilget Village	0101000020E61000001EC2F869DCE55FC06B8313D1AF9F4B40	235	vernon@hagwilget.com	http://www.hagwilget.com			(250) 842-6258	(250) 842-6924	Hagwilget Village Council,Tse-kya		\n\n"The village name of Tse-kya signifies base of rock in the Wet'suwet'en language.  It has also been call Hagwilget as its is known in Gitksan, meaning place of the quiet people.  Tse-kya is located in central British Columbia about two hundred miles or three hundred twenty five kilometers inland from the coast.  It and the area to the east and south comprise the territories of the Wet'suwet'en."[[quoted from http://www.hagwilget.com/history.htm]]\n\n"The village name of Tse-kya signifies base of rock in the Wet'suwet'en language.  It has also been call Hagwilget as its is known in Gitksan, meaning place of the quiet people.  Tse-kya is located in central British Columbia about two hundred miles or three hundred twenty five kilometers inland from the coast.  It and the area to the east and south comprise the territories of the Wet'suwet'en."[[quoted from http://www.hagwilget.com/history.htm]]\n\n"The village name of Tse-kya signifies base of rock in the Wet'suwet'en language.  It has also been call Hagwilget as its is known in Gitksan, meaning place of the quiet people.  Tse-kya is located in central British Columbia about two hundred miles or three hundred twenty five kilometers inland from the coast.  It and the area to the east and south comprise the territories of the Wet'suwet'en."[[quoted from http://www.hagwilget.com/history.htm]]\n\n"The village name of Tse-kya signifies base of rock in the Wet'suwet'en language.  It has also been call Hagwilget as its is known in Gitksan, meaning place of the quiet people.  Tse-kya is located in central British Columbia about two hundred miles or three hundred twenty five kilometers inland from the coast.  It and the area to the east and south comprise the territories of the Wet'suwet'en."[[quoted from http://www.hagwilget.com/history.htm]]\n\n"The village name of Tse-kya signifies base of rock in the Wet'suwet'en language.  It has also been call Hagwilget as its is known in Gitksan, meaning place of the quiet people.  Tse-kya is located in central British Columbia about two hundred miles or three hundred twenty five kilometers inland from the coast.  It and the area to the east and south comprise the territories of the Wet'suwet'en."[[quoted from http://www.hagwilget.com/history.htm]]\n\n"The village name of Tse-kya signifies base of rock in the Wet'suwet'en language.  It has also been call Hagwilget as its is known in Gitksan, meaning place of the quiet people.  Tse-kya is located in central British Columbia about two hundred miles or three hundred twenty five kilometers inland from the coast.  It and the area to the east and south comprise the territories of the Wet'suwet'en."[[quoted from http://www.hagwilget.com/history.htm]]	
293	Matsqui First Nation	0101000020E610000022FAB5F5D3925EC0919C4CDC2A8E4840	234	matsquiband@shaw.ca	http://www.angelfire.com/empire2/matsquifirstnation			(604) 826- 6145	(604) 826-7009	Matsqui First Nation			
296	Witset First Nation	0101000020E61000003C2EAA4544D15FC08E23D6E253724B40	0	info@moricetown.ca	http://www.moricetown.ca			(250) 847-2133	(250) 847-9291	Moricetown Band Office	1-800-881-1218		
302	ʼNa̱mǥis First Nation	0101000020E6100000C3499A3FA6BA5FC0FB57569A944A4940	0	\N	http://www.namgis.bc.ca			(250) 974-5556	(250) 974-5900	Nimpkish		\n\nThe ʼNa̱mǥis originally lived at a site called Xwa̱lkw (Cheslakees) but they now live in Alert Bay.\n\nThe ʼNa̱mǥis originally lived at a site called Xwa̱lkw (Cheslakees) but they now live in Alert Bay.\n\nThe ʼNa̱mǥis originally lived at a site called Xwa̱lkw (Cheslakees) but they now live in Alert Bay.\n\nThe ʼNa̱mǥis originally lived at a site called Xwa̱lkw (Cheslakees) but they now live in Alert Bay.\n\nThe ʼNa̱mǥis originally lived at a site called Xwa̱lkw (Cheslakees) but they now live in Alert Bay.\n\nThe ʼNa̱mǥis originally lived at a site called Xwa̱lkw (Cheslakees) but they now live in Alert Bay.	
305	Nicomen Indian Band	0101000020E6100000B0726891ED645EC0CDCCCCCCCC1C4940	0	nicomen@telus.net				(250) 455-2514	(250) 455-2517	Nicomen Indian Band			
306	Gingolx Village Government	0101000020E610000046088F368E3E60C065DEAAEB507F4B40	0	\N	http://www.gingolx.ca			(250) 326-4212	(250) 326-4208	Kincolith (Gingolx) Village Government  			
307	Nisga'a Village of Gitwinksihlkw 	0101000020E6100000C66F0A2B152760C077F4BF5C8B984B40	0	nvgrcptn@telus.net	\N			(250) 633-2294	(250) 633-2539	Nisg̱a'a Village Of Gitwinksihlkw 			
308	Laxgalts'ap Village Government	0101000020E610000076C3B645993260C008B0C8AF1F844B40	0	\N	http://www.geocities.com/laxgaltsap2004			(250) 621-3212	(250) 621-3320	Laxgalts'ap Village Government	1-877-447-0077		
310	Nooaitch	0101000020E61000009D11A5BDC1325EC08F17D2E121104940	203	adm.noo@telus.net			High-Speed[[93]]	(250) 378-6141	(250) 378-3699		1-877-301-6161	Nooaitch...\n\nNooaitch is on the Nicola River about 10km west of the Canford C.P. railway station.	
312	Nuchatlaht First Nation	0101000020E6100000FDA36FD234D85FC05F9A22C0E9034940	172	nuchatlaht@hotmail.com			Dial-in‘‘93’’	(250) 332-5908	(250) 332-5907	nuča-łʔtḥ,Oclucje		?\n\nThe Nuchatlaht First Nation is a member of the Nuu-chah-nulth Tribal Council on the northwest coast of Vancouver Island. Their territory includes much of Nootka Island, Nuchatlitz Inlet, and a portion of Esperanza Inlet. 	
317	Osoyoos Indian Band	0101000020E610000007EA944737E35DC07F6B274A42964840	0	osoyoosband@oib.ca	http://www.oib.ca			(250) 498-6935	(250) 498-6965	Osoyoos Indian Band	1-888-565-2711		
318	Wuikinuxv Nation	0101000020E61000003E07962364CE5FC0DD7D8E8F16D74940	280	admin@oweekeno.bc.ca	http://www.oweekeno.bc.ca			(250) 949-8625	(250) 949-7105	Oweekeno Nation,Wuikinuxv Nation	1-866-881-0355	Their main community is on the Wannock (also Wanook, Wanuk) River, between Rivers Inlet and Owikeno Lake, approximately 80 km from Bella Bella, on B.C.'s Central Coast.\n\nThe traditional territory of the Wuikinuxv people spans the Central Coast, south of Bella Coola.	
323	Peters Band	0101000020E61000009770E82D1E6A5EC0AC8DB1135EA64840	121	\N				(604) 794-7059	(604) 794-7885	Peters Band			
327	Qualicum First Nation	0101000020E6100000C4EC65DB69275FC0103CBEBD6BB24840	106	council.qualicum@shaw.ca	http://www.qualicumfirstnation.com			(250) 757-9337	(250) 757-9898	Qualicum First Nation			
328	G̱usgimukw (Quatsino First Nation)	0101000020E610000025ECDB4944E55FC0E23B31EBC54C4940	0	qbc.general@hughes.net				(250) 949-6245	(250) 949-6249	Quatsino First Nation		\n\nThe G̱usgimukw people (Quatsino First Nation) live at X̱wa̱tis (Quatsino). \n\nThe G̱usgimukw people (Quatsino First Nation) live at X̱wa̱tis (Quatsino). \n\nThe G̱usgimukw people (Quatsino First Nation) live at X̱wa̱tis (Quatsino). \n\nThe G̱usgimukw people (Quatsino First Nation) live at X̱wa̱tis (Quatsino). \n\nThe G̱usgimukw people (Quatsino First Nation) live at X̱wa̱tis (Quatsino). \n\nThe G̱usgimukw people (Quatsino First Nation) live at X̱wa̱tis (Quatsino). 	
330	Saik'uz First Nation	0101000020E6100000D7A19A92AC005FC084BBB376DB014B40	872	saikuzemploy@uniserve.com			Dial-in[[93]]	(250) 567-9293	(250) 567-2998	Stoney Creek	1-866-567-9293	\n\nThe Saik’uz First Nation has its main office located on the Saik’uz Reserve located south of Vanderhoof.\n\nThe Saik’uz First Nation has its main office located on the Saik’uz Reserve located south of Vanderhoof.\n\nThe Saik’uz First Nation has its main office located on the Saik’uz Reserve located south of Vanderhoof.\n\nThe Saik’uz First Nation has its main office located on the Saik’uz Reserve located south of Vanderhoof.\n\nThe Saik’uz First Nation has its main office located on the Saik’uz Reserve located south of Vanderhoof.\n\nThe Saik’uz First Nation has its main office located on the Saik’uz Reserve located south of Vanderhoof.	
332	Saulteau First Nations	0101000020E6100000F86EF3C649685EC070253B3602D94B40	840	\N	http://www.saulteau.com		Dial-in[[93]]	(250) 788-3955	(250) 788-7261			The main community is at the east end of Moberly Lake.\n\nIn the 1870s one group of Anishnaubemowin (Saulteau) migrated westward from Manitoba following their leader's vision. Their journey ended at Moberly Lake, where they settled and later intermarried with the Nēhiyawēwin (Cree) and Dane-Zaa (Beaver) who were already living in the area[[source:http://www.ydli.org/bcother/bclist.htm]]. 	
333	Scowlitz First Nation	0101000020E610000065E3C116BB815EC0081F4AB4E4A14840	0	\N				(604) 826-5813	(604) 826-6222	Scowlitz First Nation			
337	Tsal'álh (Seton Lake)	0101000020E610000073DBBE47FD835EC078279F1EDB5E4940	0	slib_receptionist_2004@yahoo.ca	\N			(250) 259-8227	(250) 259-8384	Seton Lake Band,Chalath		Our community has its own pre-school, elementary school, high school, and an elders complex. We also have a community store, restaurant, sawmill, and produce many fine arts and crafts.\n\nThe Tsal'álh traditional territory is on the shores of Seton Lake and Anderson Lake, where about half of their members live on seven reserves that are over 1800 hectares in size. 	
338	Shackan	0101000020E6100000A20BEA5BE6315EC067614F3BFC0D4940	120	shackan@mail.ocis.net	\N		none[[93]]	(250) 378-5410	(250) 378-5219			Shackan...\n\nThe main community for the Shackan is on the Nicola River about 20km from the mouth of the Thompson River.	
314	Okanagan Indian Band	0101000020E610000030293E3E21D65DC0F38DE89E75214940	1760	\N	http://www.okib.ca			(250) 542-4328	(250) 542-4990	Okanagan Indian Band			
319	Pacheedaht First Nation	0101000020E61000008B8862F2061B5FC064E60297C7464840	0	\N				(250) 647-5521	(250) 647-5561		1-888-231-1110		
321	Penelakut Tribe	0101000020E6100000F0C2D66CE5ED5EC0228B34F10E764840	0	\N	http://www.penelakut.ca			(250) 246-2321	(250) 246-2725	Penelakut Tribe			
324	Popkum First Nation	0101000020E6100000D26D895C707D5EC0DE1FEF552B914840	8	\N						Popkum First Nation			
325	Prophet River First Nation	0101000020E61000006A183E22A6AD5EC02C9D0FCF120E4D40	235	\N	\N			(250) 773-6555	(250) 773-6556				
326	Qayqayt First Nation	0101000020E61000009D9D0C8E92C15EC000E2AE5E459E4840	9	qayqayt@shaw.ca	\N			(604) 451-0531	(604) 451-9231	New Westminster First Nation		\n\nQayqayt First Nation was previously known as the New Westminster First Nation.\n\nQayqayt First Nation was previously known as the New Westminster First Nation.\n\nQayqayt First Nation was previously known as the New Westminster First Nation.\n\nQayqayt First Nation was previously known as the New Westminster First Nation.\n\nQayqayt First Nation was previously known as the New Westminster First Nation.\n\nQayqayt First Nation was previously known as the New Westminster First Nation.	
335	Sechelt Indian Band	0101000020E6100000F06C8FDE70F05EC02B16BF29ACBC4840	0	sib@secheltnation.net				(604) 885-2273 	(604) 885-3490	Sechelt Indian Nation 	1-866-885-2275		
316	Oregon Jack Creek Band	0101000020E610000052B81E85EB515EC04D158C4AEA5C4940	0	ojcb@nntc.ca				(250) 453-9098	(250) 453-9097	Oregon Jack Creek Band			
322	Penticton Indian Band	0101000020E6100000257497C459E65DC08E3BA583F5B94840	0	\N	http://www.pib.ca			(250) 493-0048	(250) 493-2882	Pentiction Indian Band			
340	Skway First Nation	0101000020E6100000A27E17B6667F5EC0FD67CD8FBF964840	0	recept@skway.com	http://www.skway.com			(604) 792-9316	(604) 792-9317	Skway First Nation	1-877-792-9316		
351	Sliammon First Nation	0101000020E6100000C03E3A75E5265FC079C9FFE4EFF24840	959	sfnchief@shaw.ca 	http://www.sliammon.bc.ca			(604) 483-9646	(604) 483-9769	Sliammon First Nation,Kla Ah Men	1-877-483-9646	The Sliammon reserve lies on a portion of land between Powell River and Lund directly opposite Harwood Island (also reserve land). The community has over 1000 members with the majority living on the reserve.\n\nThe Sliammon Community today, resides just north of Powell River in British Columbia, on the Sliammon reserve. The Sliammon (ɬaʔaʔmɛn) First Nation is one of the 20 Coast Salish native tribes inhabiting the coastal regions of western Canada. The Sliammon people stem from a culture rich heritage with a history stretching back over 2000 years into the past.[[Text copied from the Sliammon First Nation homepage: http://www.sliammonfirstnation.com/pages/community.php]]	
352	Snaw-Naw-As First Nation 	0101000020E6100000AC1BEF8E8C055FC0E5603601869F4840	223	\N	http://www.nanoose.org			(250) 390-3661	(250) 390-3365	 Nanoose First Nation		The main community of the Snaw-Naw-As (Nanoose) First Nation is on the east coast of Vancouver Island, adjacent to Lantzville, approximately 10 km north of Nanaimo.	
353	Snuneymuxw First Nation	0101000020E61000001C2444F982FB5EC0255D33F966934840	0	\N	http://www.snuneymuxw.ca/			(250) 740-2300	(250) 753-3492	Snuneymuxw First Nation	1-888-636-8789		
356	Soowahlie Indian Band	0101000020E6100000F04E3E3DB67D5EC0EC6CC83F338A4840	352	reception@soowahlie.ca	http://www.soowahlie.ca			(604) 858-4631	(604) 824-6751	Soowahlie Indian Band			
358	Spuzzum First Nation	0101000020E6100000F816D68D775B5EC0A1832EE1D0C74840	0	spuzzum@uniserve.com				(604) 863-2395	(604) 863-2218	Spuzzum First Nation			
359	Squamish Nation	0101000020E6100000FE63213A04C55EC0336B2920EDA74840	3698	\N	http://www.squamish.net			(604) 980-4553	(604) 980-4523	Squamish Band	1-877-628-2288	"After contact with European settlers, 16 tribes united as the Squamish Band on July 23, 1923."[[Text copied from www.squamish.net]]\n\n"The Squamish Nation is comprised of descendants of the Coast Salish Aboriginal peoples who lived in the present day Greater Vancouver area; Gibson’s landing and Squamish River watershed."[[Text copied from www.squamish.net]]	
360	Squiala First Nation	0101000020E6100000A0FEB3E6C77E5EC00116F9F543944840	0	squiala6@shaw.ca				(604) 792-8300	(604) 792-4522	Squiala First Nation			
362	Stellat'en First Nation	0101000020E6100000CF49EF1B5F365FC0EC866D8B32074B40	0	stellaten@hotmail.com	http://www.stellaten.com		High-Speed[[93]]	(250) 699-8747	(250) 699-6430	Stellat'en		\n\nThe main community of the Stellaten First Nation is at the mouth of the Stellaquo River. They are a member of the Carrier Sekani Tribal Council.\n\nThe main community of the Stellaten First Nation is at the mouth of the Stellaquo River. They are a member of the Carrier Sekani Tribal Council.\n\nThe main community of the Stellaten First Nation is at the mouth of the Stellaquo River. They are a member of the Carrier Sekani Tribal Council.\n\nThe main community of the Stellaten First Nation is at the mouth of the Stellaquo River. They are a member of the Carrier Sekani Tribal Council.\n\nThe main community of the Stellaten First Nation is at the mouth of the Stellaquo River. They are a member of the Carrier Sekani Tribal Council.\n\nThe main community of the Stellaten First Nation is at the mouth of the Stellaquo River. They are a member of the Carrier Sekani Tribal Council.	
364	Sumas First Nation	0101000020E61000006DAE9AE7888C5EC0BDFC4E9319874840	0	\N				(604) 852-4040	(604) 852-3834	Sumas First Nation			
341	Shxw'owhamel First Nation	0101000020E6100000E7E104A6D3665EC013656F29E7AB4840	0	sturgeon@uniserve.com	\N			(604) 869-2627	(604) 869-9903	Shxw'owhamel First Nation 			
343	Siska Indian Band	0101000020E6100000121615713A655EC01D5A643BDF1D4940	0	siskaib@hughes.net				(250) 455-2219	(250) 455-2539	Siska Indian Band			
346	Skidegate Band Council	0101000020E61000007041B62C5F8060C0A29A92ACC39F4A40	0	bandmanager@skidegate.ca	\N			(250) 559-4496	(250) 559-8247	Skidegate Band Council		Skidegate was originally called HLG̱AAGILDA and later became known as SG̱IIDAGIDS.\r\r\n\n\nThe village of Skidegate is on X̱AAYDAG̱A GWAAY.YAAY IINAG̱WAAY (Graham Island) off the north coast of British Columbia.	
347	Skin Tyee Nation	0101000020E610000009FB761211715FC012F6ED2422024B40	0	\N	http://www.skintyeenation.ca			(250) 694-3517	(250) 694-3268	Skin Tyee Nation			
365	Tahltan Nation	0101000020E6100000CADE52CE176560C0E449D23593F34C40	1686	tahltanadmin@tahltan.ca	http://www.tahltan.ca			(250) 235-3151	(250) 235-3244	Tahltan Band			
367	Taku River Tlingit First Nation	0101000020E6100000D4B9A29410B660C00E164ED2FCC94D40	0	trtfn@gov.trtfn.com	http://www.trtfn.com			(250) 651-7900	(250) 651-7909	Taku River Tlingit First Nation 			
348	Skowkale First Nation	0101000020E61000000F46EC1340805EC0F1F109D9798F4840	0	skowkale@shawcable.com				(604) 792-0730	(604) 792-1153	Skowkale First Nation			
368	T’ít’q’et First Nation	0101000020E610000079CBD58F4D7C5EC086200725CC564940	0	susann@titqet.org	\N			(250) 256-4118	(250) 256-4544	T'it'q'et ,Tl'itl'ikt ,Lillooet Indian Band		\n\nThe T’ít’q’et (Lillooet) First Nation's offices are located at Lillooet, British Columbia. \n\nThe T’ít’q’et (Lillooet) First Nation's offices are located at Lillooet, British Columbia. \n\nThe T’ít’q’et (Lillooet) First Nation's offices are located at Lillooet, British Columbia. \n\nThe T’ít’q’et (Lillooet) First Nation's offices are located at Lillooet, British Columbia. \n\nThe T’ít’q’et (Lillooet) First Nation's offices are located at Lillooet, British Columbia. \n\nThe T’ít’q’et (Lillooet) First Nation's offices are located at Lillooet, British Columbia. 	
349	Skuppah Indian Band	0101000020E6100000B37A87DBA1645EC00F9BC8CC05184940	0	fcia@fcia.net				(250) 455-2279	(250) 455-2772	Skuppah Indian Band			
350	Skwah First Nation	0101000020E6100000711E4E603A7E5EC036CAFACDC4964840	477	\N	http://www.skwahnation.net			(604) 792-9204	(604) 792-1093	Skwah First Nation			
381	Tsay Keh Dene	0101000020E6100000C8957A1684AF5EC015E3FC4D28F44A40	398	\N			High-Speed[[93]]	(250) 562-8882	(250) 562-8899	Ingenika Indian Band		The main community has about 50 houses, an administration office, health centre, school, fire hall, and recreation centre.[[93]]\n\nThe Tsay Keh Dene speak Tsek'ene and have their main community at the northern end of the Williston Lake reservoir. The Tsay Keh's traditional territory spans north to Mt. Trace, west to South Pass Peak, south to the Nation River, and east to Mount Laurier.[[Territorial information copied from BC Treaty Commission website: http://www.bctreaty.net/nations/tsaykeh.php]]	
384	Ts'kw'aylaxw	0101000020E6100000605969520A755EC0B37C5D86FF704940	0	reception@tskwaylaxw.com	http://www.tskwaylaxw.com			(250) 256-4204	(250) 256-4058	Tsk’wáylacw,Pavilion		There are currently seven reserves that make up Ts'kw'aylaxw (Pavilion) with a total of 2127.9 hectares of land. \n\nThe community of Ts'kw'aylaxw (Pavilion) is located near Cache Creek. 	
385	T'Sou-ke Nation	0101000020E6100000855FEAE74DED5EC03CA2427573314840	0	admin1@tsoukenation.com	http://www.tsoukenation.com			(250) 642-3957	(250) 642-7808	T'Sou-ke Nation			
386	Tzeachten First Nation	0101000020E610000060EAE74D457D5EC0FC8C0B07428E4840	0	\N				(604) 858-3888	(604) 858-3382	Tzeachten First Nation 			
390	Union Bar Band	0101000020E61000009738F240645C5EC05915E126A3B04840	118	\N				(604) 869-9930	(604) 869-9934	Union Bar Band 			
391	Upper Nicola Band	0101000020E61000008FE046CA16125EC078978BF84E124940	0	unb@uppernicolaband.com	http://www.uppernicolaband.com			(250) 350-3342	(250) 350-3311	Upper Nicola Band			
392	Upper Similkameen Indian Band	0101000020E610000078D32D3BC4F45DC0E751F17F479A4840	0	usib@img.net				(250) 499-2221	(250) 499-5117	Upper Similkameen Indian Band			
252	Haisla	0101000020E6100000A92F4B3BB51460C009168733BFFC4A40	1615	kv_council@uniserve.com	\N		Dial-in[[93]]	(250) 639-9361	(250) 632-2840	Kitamaat Village Council	1-888-842-4752	\n\n"At this point in time the primary residence of the Haisla people is Kitamaat Village located at the head of the Douglas Channel on British Columbia's North Coast. For hundreds of years, however, the Haisla people have occupied many village sites throughout their Territory. Currently, Kitamaat Village is home to 700 Haisla people, but in total there are close to 1500 Haisla members."[[173]]\n\n"At this point in time the primary residence of the Haisla people is Kitamaat Village located at the head of the Douglas Channel on British Columbia's North Coast. For hundreds of years, however, the Haisla people have occupied many village sites throughout their Territory. Currently, Kitamaat Village is home to 700 Haisla people, but in total there are close to 1500 Haisla members."[[173]]\n\n"At this point in time the primary residence of the Haisla people is Kitamaat Village located at the head of the Douglas Channel on British Columbia's North Coast. For hundreds of years, however, the Haisla people have occupied many village sites throughout their Territory. Currently, Kitamaat Village is home to 700 Haisla people, but in total there are close to 1500 Haisla members."[[173]]\n\n"At this point in time the primary residence of the Haisla people is Kitamaat Village located at the head of the Douglas Channel on British Columbia's North Coast. For hundreds of years, however, the Haisla people have occupied many village sites throughout their Territory. Currently, Kitamaat Village is home to 700 Haisla people, but in total there are close to 1500 Haisla members."[[173]]\n\n"At this point in time the primary residence of the Haisla people is Kitamaat Village located at the head of the Douglas Channel on British Columbia's North Coast. For hundreds of years, however, the Haisla people have occupied many village sites throughout their Territory. Currently, Kitamaat Village is home to 700 Haisla people, but in total there are close to 1500 Haisla members."[[173]]\n\n"At this point in time the primary residence of the Haisla people is Kitamaat Village located at the head of the Douglas Channel on British Columbia's North Coast. For hundreds of years, however, the Haisla people have occupied many village sites throughout their Territory. Currently, Kitamaat Village is home to 700 Haisla people, but in total there are close to 1500 Haisla members."[[173]]	
264	Kanaka Bar Indian Band	0101000020E6100000081EDFDE35655EC0D158FB3BDB1D4940	0	\N				(250) 455-2279	(250) 455-2772	Kanaka Bar Indian Band			
376	Toquaht First Nation	0101000020E6100000F299EC9FA7635FC01689096AF8784840	133	toquaht@ukeecable.net	http://www.toquahtnation.org		 High-Speed[[93]]	(250) 726-4230	(250) 726-4403	Toquart		The Toquaht First Nation is part of the Maa-nulth Treaty Society and has ratified the treaty. \n\nThe Toquaht First Nation occupies seven reserves, their main settlement being Macoah on the North Shore of Barkley Sound. The Toquaht operate a logging and sawmill operation, an art gallery, and various other individual and tribal businesses.[[Copied from: http://www.centralregionboard.com/communities.html]]	
394	Westbank First Nation	0101000020E6100000B859BC5818E25DC0A304FD851EF14840	0	mail@wfn.ca	http://www.wfn.ca			(250) 769-4999	(250) 769-4377	Westbank First Nation			
378	Dzawada̱ʼenux̱w (Tsawataineuk)	0101000020E6100000B7EC10FFB08B5FC08FE046CA167D4940	0	\N	http://www.kingcome.net			(250) 974-3013	(250) 974-3005	Tsawataineuk First Nation,Tsadzis'nukwa̱me'		\n\nThe Dzawada̱ʼenux̱w (Tsawataineuk) are originally from Gwaʼyi (Kincome Inlet).\n\nThe Dzawada̱ʼenux̱w (Tsawataineuk) are originally from Gwaʼyi (Kincome Inlet).\n\nThe Dzawada̱ʼenux̱w (Tsawataineuk) are originally from Gwaʼyi (Kincome Inlet).\n\nThe Dzawada̱ʼenux̱w (Tsawataineuk) are originally from Gwaʼyi (Kincome Inlet).\n\nThe Dzawada̱ʼenux̱w (Tsawataineuk) are originally from Gwaʼyi (Kincome Inlet).\n\nThe Dzawada̱ʼenux̱w (Tsawataineuk) are originally from Gwaʼyi (Kincome Inlet).	
380	Tsawwassen First Nation	0101000020E610000070ED444948C65EC0064CE0D6DD844840	0	 receptiontfn@dccnet.com	http://www.tsawwassenfirstnation.com			(604) 943-2112	(604) 943-9226	Tsawwassen First Nation 			
232	Da̱'naxda̱'xw / A̱waetla̱la̱	0101000020E6100000C0E95DBC1FBC5FC0E353008C674C4940	174	info@danaxdaxw.com	http://www.danaxdaxw.com		Dial-in[[93]]̕	(250) 974-2179	(250) 974-2109			\n\nThe Da'naxda'xw First Nation is an amalgamation of the Da'naxda'xw and Awaetlala tribes of Knight Inlet. The main village of the Da'naxda'xw, Tsatsisnukwomi, is situated at Dead Point on Harbledown Island. This village is in Indian Channel and approximately 25 kilometers east of Alert Bay on the west coast of British Columbia, Canada.[[Copied from http://www.danaxdaxw.com/about_us.htm]]\n\nThe Da'naxda'xw First Nation is an amalgamation of the Da'naxda'xw and Awaetlala tribes of Knight Inlet. The main village of the Da'naxda'xw, Tsatsisnukwomi, is situated at Dead Point on Harbledown Island. This village is in Indian Channel and approximately 25 kilometers east of Alert Bay on the west coast of British Columbia, Canada.[[Copied from http://www.danaxdaxw.com/about_us.htm]]\n\nThe Da'naxda'xw First Nation is an amalgamation of the Da'naxda'xw and Awaetlala tribes of Knight Inlet. The main village of the Da'naxda'xw, Tsatsisnukwomi, is situated at Dead Point on Harbledown Island. This village is in Indian Channel and approximately 25 kilometers east of Alert Bay on the west coast of British Columbia, Canada.[[Copied from http://www.danaxdaxw.com/about_us.htm]]\n\nThe Da'naxda'xw First Nation is an amalgamation of the Da'naxda'xw and Awaetlala tribes of Knight Inlet. The main village of the Da'naxda'xw, Tsatsisnukwomi, is situated at Dead Point on Harbledown Island. This village is in Indian Channel and approximately 25 kilometers east of Alert Bay on the west coast of British Columbia, Canada.[[Copied from http://www.danaxdaxw.com/about_us.htm]]\n\nThe Da'naxda'xw First Nation is an amalgamation of the Da'naxda'xw and Awaetlala tribes of Knight Inlet. The main village of the Da'naxda'xw, Tsatsisnukwomi, is situated at Dead Point on Harbledown Island. This village is in Indian Channel and approximately 25 kilometers east of Alert Bay on the west coast of British Columbia, Canada.[[Copied from http://www.danaxdaxw.com/about_us.htm]]\n\nThe Da'naxda'xw First Nation is an amalgamation of the Da'naxda'xw and Awaetlala tribes of Knight Inlet. The main village of the Da'naxda'xw, Tsatsisnukwomi, is situated at Dead Point on Harbledown Island. This village is in Indian Channel and approximately 25 kilometers east of Alert Bay on the west coast of British Columbia, Canada.[[Copied from http://www.danaxdaxw.com/about_us.htm]]	
225	Chehalis Indian Band	0101000020E61000004241295AB9725EC037DE1D19AB9F4840	973	\N	\N			(604) 796-2116	(604) 796-3946	Chehalis Indian Band 		\n\nChehalis Indian Band's main community is located on the Harrison River between the town of Harrison and the Fraser River. They are known for their spiritual traditions.\n\nChehalis Indian Band's main community is located on the Harrison River between the town of Harrison and the Fraser River. They are known for their spiritual traditions.\n\nChehalis Indian Band's main community is located on the Harrison River between the town of Harrison and the Fraser River. They are known for their spiritual traditions.\n\nChehalis Indian Band's main community is located on the Harrison River between the town of Harrison and the Fraser River. They are known for their spiritual traditions.\n\nChehalis Indian Band's main community is located on the Harrison River between the town of Harrison and the Fraser River. They are known for their spiritual traditions.\n\nChehalis Indian Band's main community is located on the Harrison River between the town of Harrison and the Fraser River. They are known for their spiritual traditions.	
400	Yakweakwioose Band	0101000020E6100000452BF702B3805EC0C6FA0626378A4840	0	\N				(604) 824-0826	(604) 858-1775	Yakweakwioose Band			
401	Skawahlook First Nation	0101000020E6100000B35E0CE5445B5EC0F9BD4D7FF6C74840	0	skawahlook@aol.com 	http://www.skawahlook.com			(604) 796-9129	(604) 796-9289	Skawahlook First Nation 			
403	Yale First Nation	\N	150	yaleband@uniserve.com	\N			(604) 863-2443	(604) 863-2467	Yale First Nation		\n\nThe main community of the Yale First Nation is located on the Fraser River at Yale, approximately 20 km north of Hope, BC. \n\nThe main community of the Yale First Nation is located on the Fraser River at Yale, approximately 20 km north of Hope, BC. \n\nThe main community of the Yale First Nation is located on the Fraser River at Yale, approximately 20 km north of Hope, BC. \n\nThe main community of the Yale First Nation is located on the Fraser River at Yale, approximately 20 km north of Hope, BC. \n\nThe main community of the Yale First Nation is located on the Fraser River at Yale, approximately 20 km north of Hope, BC. \n\nThe main community of the Yale First Nation is located on the Fraser River at Yale, approximately 20 km north of Hope, BC. 	
404	Nee-Tahi-Buhn Indian Band	0101000020E61000007B14AE47E16A5FC0D7A3703D0AF74A40	0	\N	\N					Nee-Tahi-Buhn Indian Band			
405	ʔakisq̓nuk First Nation	\N	0	\N	\N					Columbia Lake,Akisqnuk First Nation		\n\nʔakisq̓nuk First Nation (Columbia Lake Band) has their main community in Windermere, BC. Their name, ʔakisq̓nuk, literally means "place of two lakes".\n\nʔakisq̓nuk First Nation (Columbia Lake Band) has their main community in Windermere, BC. Their name, ʔakisq̓nuk, literally means "place of two lakes".\n\nʔakisq̓nuk First Nation (Columbia Lake Band) has their main community in Windermere, BC. Their name, ʔakisq̓nuk, literally means "place of two lakes".\n\nʔakisq̓nuk First Nation (Columbia Lake Band) has their main community in Windermere, BC. Their name, ʔakisq̓nuk, literally means "place of two lakes".\n\nʔakisq̓nuk First Nation (Columbia Lake Band) has their main community in Windermere, BC. Their name, ʔakisq̓nuk, literally means "place of two lakes".\n\nʔakisq̓nuk First Nation (Columbia Lake Band) has their main community in Windermere, BC. Their name, ʔakisq̓nuk, literally means "place of two lakes".	
406	Kitamaat Village Council	0101000020E610000014AE47E17A1460C05C8FC2F528FC4A40	0	kv_council@uniserve.com	\N			(250) 639-9361	(250) 632-2840	Kitamaat Village Council			
254	Gitga'at Nation	0101000020E6100000B0E600C11C2860C0969350FA42B64A40	165	hbvc@gitgaat.net	http://www.gitgaat.net			(250) 841-2500	(250) 841-2541	Hartley Bay Village Council ,Hartley Bay Band		"The ancestors of the present Gitga’at people lived at their ancestral home Laxgal’tsap (Old Town) in Kitkiata Inlet, on the northwest side of the Douglas Channel."[[quoted from http://www.gitgaat.net]]\n\n"From the beginning of time, the Gitga’at people have existed in their Territory on what is now British Columbia's northwest coast. The wellbeing of their people is intricately related to the health of their lands, waters, and resources, and the community continues to work to sustain their abundance and richness. Gitga’at culture is strengthening, and traditional practices continue to shape day to day life in the village."[[quoted from http://www.gitgaat.net]]	
313	Nuxalk Nation	0101000020E6100000BD546CCCEBAF5FC0D6E5948098464A40	1479	government@nuxalk.org	http://www.nuxalk.net/index.html			(250) 799-5613	(250) 799-5426	Bella Coola Indian Band	1-877-799-5959	Bella Coola is approximately 430 km northwest of Vancouver BC at the mouth of the Bella Coola River.  Until 1953, Bella Coola was linked to the rest of BC only by trail, air or water. In August 1953, the residents of Bella Coola finished construction of the "freedom road" which required two years of donated time, equipment and money. The new road connected the road system of the Bella Coola valley to the provincial highway system. Today, there are three main transportation methods to get to/from Bella Coola: Highway 20 from Williams Lake, a one hour flight from Vancouver or a ferry from Port Hardy.\r\n\r\n\r\n\r\nThe majority of the people in the Bella Coola valley are either Nuxalk or of Norwegian descent. The Nuxalk have lived in the Bella Coola region for thousands of years, while the Norwegians established a settlement of Hagensborg 16km east of Bella Coola in the 1890s.\r\n\r\n \r\n\r\nThe Nuxalk Village of Q'umk'uts' lies next to the non-Nuxalk townsite of Bella Coola. The Nuxalk Hall hosts the Nuxalk Basketball Association (NBA), a very popular pastime of Nuxalk young and old. Potlatches, feasts, dances and celebrations are also held at the Nuxalk Hall, which remains busy throughout the winter and summer months. There are several Nuxalk businesses in the valley, including convenience stores, art galleries, gas stations and clothing outlets, as well as a Volunteer Fire Department. The Bella Coola town site includes a hospital, post-office, government agent office, RCMP station, grocery store and retail stores [[This community information was copied from http://www.nuxalknation.org/content/blogcategory/18/47/ ]] . \n\nThe Nuxalk Nation is an indigenous and sovereign Nation located in Bella Coola on the central coast of what is now known as British Columbia.	
272	Kwadacha	0101000020E61000002194F77134B25EC0E415889E94F54A40	425	money@netbistro.com	http://www.kwadacha.com		 High-Speed[[93]]	(250) 563-4161	(250) 563-2668	Fort Ware Indian Band		In 1992 a logging road from Mackenzie was extended as far as Fort Ware. The travel time from Fort Ware to Prince George by road is from eight to ten hours depending on road and weather conditions. This makes Fort Ware one of the most isolated communities in British Columbia.[[copied from Kwadacha Nation website: http://www.kwadacha.com/nation/54/community]]\n\nThe Kwadacha Nation (home of the Tsek'ene people) is located at Fort Ware, approximately 570 km north of Prince George in British Columbia, Canada. The village lies at the confluence of the Fox, the Kwadacha, and Finlay rivers in the Rocky Mountain Trench.[[copied from Kwadacha Nation website: http://www.kwadacha.com/nation/53/kwadacha+nation]]	
295	Metlakatla Band Council	0101000020E6100000151E34BB6E4A60C098874CF910284B40	801	mbc@citytel.net	http://www.metlakatla.com			(250) 628-3234	(250) 628-9205	Metlakahtla	1-877-628-3234	\n\nMetlakatla is situated at Metlakatla Pass near Prince Rupert, BC.\n\nMetlakatla is situated at Metlakatla Pass near Prince Rupert, BC.\n\nMetlakatla is situated at Metlakatla Pass near Prince Rupert, BC.\n\nMetlakatla is situated at Metlakatla Pass near Prince Rupert, BC.\n\nMetlakatla is situated at Metlakatla Pass near Prince Rupert, BC.\n\nMetlakatla is situated at Metlakatla Pass near Prince Rupert, BC.	
379	SȾÁUTW̱ (Tsawout)	0101000020E610000066DD3F16A2DA5EC09204E10A284C4840	757	\N	http://www.tsawout.ca		High-Speed[[93]]	(250) 652-9101	(250) 652-9114	Tsawout First Nation	1-888-652-9101	"East Saanich IR No. 2, the Tsawout First Nation main village, is about 15 minutes north of the City of Victoria and lies on the east side of the Saanich Peninsula. The village (“reserve”)  can be accessed via Highway 17 - Pat Bay Highway. We have a population of 1600 people living in Tsawout (year 2006 est.) with approximately 1/3 of the population being registered band members, and others being residents who are leasing lands from landowners.\r\r\n\r\r\nEast Saanich IR No. 2 is approximately 241ha (595 acres) total area. There are single family residential,  and leased pre-manufactured homes, band community and commercial developments. There are a variety of commercial developments that include motels, restaurants, offices, and gas stations.  We have full municipal services, and our own capital structure for sewer services which allows for good future development potential.  Tsawout has other property on the Gulf Islands:  Saturna, Pender and the Saltspring Islands."[[copied from: http://www.tsawout.ca/]]\n\nSȾÁUTW̱ (Tsawout) is part of the W̱SÁNEĆ (Saanich) First Nation with territory centred on the Saanich Peninsula and southern Gulf Islands. The W̱SÁNEĆ (Saanich) First Nation is a single Nation that was historically split into four First Nations according to village site by the Canadian government[[218]]. The SȾÁUTW̱ (Tsawout) First Nation main village is 20km north of Victoria.	
398	Xaxli'p First Nation	0101000020E6100000BF0F070951775EC0F5A276BF0A5E4940	0	reception@xaxlip.ca	\N			(250) 256-4800	(250) 256-4803	Xaxli'p Band,Fountain Indian Band 		Slightly under half of our members live on our seventeen reserves that cover almost 1600 hectares. Our community has a number of services which include a nursery school, health centre, community centre, outdoor ice rink, and adult education centre.\n\nThe Xaxli'p (Fountain) First Nation is about 15km north of Lillooet on the Fraser River.	
291	MÁLEXEȽ (Malahat)	0101000020E610000075779D0DF9E25EC0FB3DB14E95514840	258	mfnadmin@shaw.ca			High-Speed	(250) 743-3231	(250) 743-3251	Malahat First Nation,Malahat Indian Band		The main MÁLEXEȽ community is on the Malahat 11 reserve land south of Mill Bay, BC.\n\nThe MÁLEXEȽ (Malahat) are a First Nation on the southern end of Vancouver Island. Their territory is centred on the western side of Saanich Inlet between the cities of Victoria and Duncan.	
299	xʷməθkʷəy̓əm (Musqueam)	0101000020E61000001EFD2FD7A2CC5EC0DA73999A049D4840	1203	webinfo@musqueam.bc.ca	http://www.musqueam.bc.ca		High-Speed[[93]]	(604) 263-3261	(604) 263-4212	Musqueam	1-866-282-3261	Our main village is located at the mouth of the Fraser River, one of Canada's most important salmon-producing systems of the Northwest Coast. Musqueam culture is intimately tied to the lands and waters within our traditional territory. We continue to maintain a viable culture and hold a special relationship to the land in the heart of a modern city.[[copied from Muqueam homepage: http://www.musqueam.bc.ca/History.html]] \n\nThe xʷməθkʷəy̓əm (Musqueam) people have lived in our present location for thousands of years. Our traditional territory once occupied much of what is now Vancouver and surrounding areas. The name xʷməθkʷəy̓əm (Musqueam) relates back to the River Grass, the name of the grass is məθkʷay̓.[[copied from Muqueam homepage: http://www.musqueam.bc.ca/Home.html]]	
304	Neskonlith	0101000020E6100000F81BEDB8E1ED5DC07616BD5301634940	0	\N	http://www.neskonlithband.com and http://www.neskonlith.com			(250) 679-3295	(250) 679-5306	Neskonlith Indian Band		\n\n"The Neskonlith Indian Band belongs to the Secwepemc Nation, a nation whose traditional territory spans approximately 180,000 square kilometers in South-Central British Columbia. Occupying this territory, at one point, was 30 Bands. Today, however, only 17 of these bands remain. The Neskonlith Band is situated on 3 reserves centering around the area of Chase BC. The main administrative offices are on IR2 just south of Chase along the Thompson River and Trans-Canada highway."[[quoted from http://neskonlith.org/]]\n\n"The Neskonlith Indian Band belongs to the Secwepemc Nation, a nation whose traditional territory spans approximately 180,000 square kilometers in South-Central British Columbia. Occupying this territory, at one point, was 30 Bands. Today, however, only 17 of these bands remain. The Neskonlith Band is situated on 3 reserves centering around the area of Chase BC. The main administrative offices are on IR2 just south of Chase along the Thompson River and Trans-Canada highway."[[quoted from http://neskonlith.org/]]\n\n"The Neskonlith Indian Band belongs to the Secwepemc Nation, a nation whose traditional territory spans approximately 180,000 square kilometers in South-Central British Columbia. Occupying this territory, at one point, was 30 Bands. Today, however, only 17 of these bands remain. The Neskonlith Band is situated on 3 reserves centering around the area of Chase BC. The main administrative offices are on IR2 just south of Chase along the Thompson River and Trans-Canada highway."[[quoted from http://neskonlith.org/]]\n\n"The Neskonlith Indian Band belongs to the Secwepemc Nation, a nation whose traditional territory spans approximately 180,000 square kilometers in South-Central British Columbia. Occupying this territory, at one point, was 30 Bands. Today, however, only 17 of these bands remain. The Neskonlith Band is situated on 3 reserves centering around the area of Chase BC. The main administrative offices are on IR2 just south of Chase along the Thompson River and Trans-Canada highway."[[quoted from http://neskonlith.org/]]\n\n"The Neskonlith Indian Band belongs to the Secwepemc Nation, a nation whose traditional territory spans approximately 180,000 square kilometers in South-Central British Columbia. Occupying this territory, at one point, was 30 Bands. Today, however, only 17 of these bands remain. The Neskonlith Band is situated on 3 reserves centering around the area of Chase BC. The main administrative offices are on IR2 just south of Chase along the Thompson River and Trans-Canada highway."[[quoted from http://neskonlith.org/]]\n\n"The Neskonlith Indian Band belongs to the Secwepemc Nation, a nation whose traditional territory spans approximately 180,000 square kilometers in South-Central British Columbia. Occupying this territory, at one point, was 30 Bands. Today, however, only 17 of these bands remain. The Neskonlith Band is situated on 3 reserves centering around the area of Chase BC. The main administrative offices are on IR2 just south of Chase along the Thompson River and Trans-Canada highway."[[quoted from http://neskonlith.org/]]	
219	Tsq'escenemc (Canim Lake)	0101000020E6100000E1B721C66B665EC0749A05DA1DD64940	570	clb-cc@uniserve.com	http://www.canimlakeband.com			(250) 397-2227	(250) 397-2769	Canim Lake Band		\n\nThe Tsq'escenemc (People of Broken Rock) as they are known in their language are members of the Shuswap Nation.[[see http://www.canimlakeband.com/aboutus.htm]]\n\nThe Tsq'escenemc (People of Broken Rock) as they are known in their language are members of the Shuswap Nation.[[see http://www.canimlakeband.com/aboutus.htm]]\n\nThe Tsq'escenemc (People of Broken Rock) as they are known in their language are members of the Shuswap Nation.[[see http://www.canimlakeband.com/aboutus.htm]]\n\nThe Tsq'escenemc (People of Broken Rock) as they are known in their language are members of the Shuswap Nation.[[see http://www.canimlakeband.com/aboutus.htm]]\n\nThe Tsq'escenemc (People of Broken Rock) as they are known in their language are members of the Shuswap Nation.[[see http://www.canimlakeband.com/aboutus.htm]]\n\nThe Tsq'escenemc (People of Broken Rock) as they are known in their language are members of the Shuswap Nation.[[see http://www.canimlakeband.com/aboutus.htm]]	
222	Sekw’el’wás (Cayoose Creek)	0101000020E6100000C3D4963AC87B5EC031B77BB94F564940	0	cayoosecreekband@yahoo.ca 	\N			(250) 256-4136	(250) 256-4138	Cayoose Creek Band		\n\nSek’wel’wás is located near the town of Lillooet, BC. The literal translation of the name Sek’wel’wás is "broken in half" and it refers to a big rock.[[1364]]\n\nSek’wel’wás is located near the town of Lillooet, BC. The literal translation of the name Sek’wel’wás is "broken in half" and it refers to a big rock.[[1364]]\n\nSek’wel’wás is located near the town of Lillooet, BC. The literal translation of the name Sek’wel’wás is "broken in half" and it refers to a big rock.[[1364]]\n\nSek’wel’wás is located near the town of Lillooet, BC. The literal translation of the name Sek’wel’wás is "broken in half" and it refers to a big rock.[[1364]]\n\nSek’wel’wás is located near the town of Lillooet, BC. The literal translation of the name Sek’wel’wás is "broken in half" and it refers to a big rock.[[1364]]\n\nSek’wel’wás is located near the town of Lillooet, BC. The literal translation of the name Sek’wel’wás is "broken in half" and it refers to a big rock.[[1364]]	
402	Yekooche First Nation	0101000020E6100000289B728577B05EC076887FD8D2F54A40	217	\N	http://www.yekoochenativeart.com		High-Speed[[93]]	(250) 612-4365	(250) 612-4366	Portage Reserve		\n\nYekooche First Nation is based 75 kilometers northwest of Fort St. James, British Columbia at the north end of Stuart Lake on Yekooche reserves (about 380 hectares in size).\r\nThe Yekooche First Nation was one of the 5 bands that made up the Stuart Trembleur band which is presently known as Tl'azt'en Nation. Yekooche had been known as the Portage Reserve until the bands separated in 1994.\n\nYekooche First Nation is based 75 kilometers northwest of Fort St. James, British Columbia at the north end of Stuart Lake on Yekooche reserves (about 380 hectares in size).\r\nThe Yekooche First Nation was one of the 5 bands that made up the Stuart Trembleur band which is presently known as Tl'azt'en Nation. Yekooche had been known as the Portage Reserve until the bands separated in 1994.\n\nYekooche First Nation is based 75 kilometers northwest of Fort St. James, British Columbia at the north end of Stuart Lake on Yekooche reserves (about 380 hectares in size).\r\nThe Yekooche First Nation was one of the 5 bands that made up the Stuart Trembleur band which is presently known as Tl'azt'en Nation. Yekooche had been known as the Portage Reserve until the bands separated in 1994.\n\nYekooche First Nation is based 75 kilometers northwest of Fort St. James, British Columbia at the north end of Stuart Lake on Yekooche reserves (about 380 hectares in size).\r\nThe Yekooche First Nation was one of the 5 bands that made up the Stuart Trembleur band which is presently known as Tl'azt'en Nation. Yekooche had been known as the Portage Reserve until the bands separated in 1994.\n\nYekooche First Nation is based 75 kilometers northwest of Fort St. James, British Columbia at the north end of Stuart Lake on Yekooche reserves (about 380 hectares in size).\r\nThe Yekooche First Nation was one of the 5 bands that made up the Stuart Trembleur band which is presently known as Tl'azt'en Nation. Yekooche had been known as the Portage Reserve until the bands separated in 1994.\n\nYekooche First Nation is based 75 kilometers northwest of Fort St. James, British Columbia at the north end of Stuart Lake on Yekooche reserves (about 380 hectares in size).\r\nThe Yekooche First Nation was one of the 5 bands that made up the Stuart Trembleur band which is presently known as Tl'azt'en Nation. Yekooche had been known as the Portage Reserve until the bands separated in 1994.	
241	Fort Nelson First Nation	0101000020E6100000F50F221972AA5EC06D0377A04E634D40	787	\N	http://www.fortnelsonfirstnation.org/			(250) 774-7257	(250) 774-7260	Fort Nelson Slavey Band,Fort Nelson Indian Band		"Facilities available on the reserve include an administration office, band hall, Chalo school, daycare/headstart building, lands building, adult learning centre, and capital works."[[1031]]\n\nThe Fort Nelson First Nation is "...comprised of 14 major families. Historical Chief, Jimmie Badine, and Headman, Tommy Whitehead, signed an adhesion to Treaty 8 in August 1910.\r\n\r\nThere are 10 reserves, including Fort Nelson IR #2, Maxhamish Lake, Francois, Moose Lake, Fontas River, Kahntah River, and Snake River. The total land base for the FNFN Reserves is 9556.5 hectares. The Fort Nelson First Nation is located 7km south of the Town of Fort Nelson in the northeastern corner of British Columbia. The community is located at Mile 293-295 on the Alaska Highway."[[1031]]\r\n\r\n\r\n\r\n	
342	Simpcw	0101000020E610000087F9F202EC085EC0755AB741ED974940	0	ntibadmin@simpcw.com	http://www.simpcw.com			(250) 672-9995	(250) 672-5858	North Thompson Indian Band		"Today about half of the over six hundred Simpcw people live on the Simpcw First Nation Indian Reserve at Chu Chua just north of Barriere and on the Louis Creek Reserve.  Many band members are employed in the forest industry as mill workers and loggers.  The band owns a small sawmill.  The Simpcw First Nation employs many members in various capacities."[[quoted from http://www.simpcw.com]]\n\n"The Simpcw are a division of the Secwepemc, or Shuswap, who occupied the drainage of the North Thompson River upstream from McLure to the headwaters of Fraser River from McBride to Tete Jeune Cache, over to Jasper and south to the headwaters of the Athabasca River.  The Simpcw speak the Secwepemc language, a Salishan language, shared among many of the First Nations in the Fraser and Thompson River drainage."[[quoted from http://www.simpcw.com]]	
284	Liard First Nation	0101000020E61000006B2920ED7F1660C0228AC91B60084E40	1072	lfn_reception@kaska.ca	http://www.kaskadenacouncil.com/kaska-nations/liard-first-nation			(867) 536-5200	(867) 536-2332		1-866-736-2131		
363	Yunesit'in	0101000020E6100000E109BDFE24C55EC0A20A7F8637E74940	393	\N				(250) 394-4295	(250) 394-4407	Stone First Nation,Stone Band		Yunesit'in is a Tsilhqot'in community that the Canadian government has historically called the "Stone Band".	
366	Takla Lake First Nation	0101000020E6100000B05582C5E1AE5EC0711FB935E9F44A40	663	\N			Dial-in[[93]]	(250) 996-0381 	(250) 996-0350 or (250) 564-9521 (Takla Development Corp.)	North Takla Lake Indian Band,Fort Connolly Indian Band,Sustutenne		...\n\nThe Takla Lake First Nation's main community is 400km north of Prince George at the north end of Nadleh Bun (Takla Lake), but the band services 17 reserves totaling 809 hectares. The Takla Lake First Nation was created by the amalgamation of the Takla Lake and Fort Connelly bands in 1959.	
375	Tl’esqox	0101000020E61000008AB0E1E995A05EC08A3BDEE4B7FA4940	286	\N	\N		Dial-in[[93]]	(250) 659-5655	(250) 659-5601	Toosey Indian Band		The Tsilhqot'in name for Riske Creek is Tl’esqox which means "muddy creek". With the snow melt in the spring, the creek gets very muddy.[[245]]\n\nThe Tl'esqox Indian Band's main community and offices are located at Riske Creek between the Chilcoten and Fraser Rivers just west of Williams Lake, BC. The Tl'esqox have three reserves, two at Riske Creek and one fishing station on the Fraser River. They are a member of the Carrier-Chilcotin Tribal Council, which includes both Tsilhqot'in and Dakelh communities.	
377	W̱JOȽEȽP (Tsartlip)	0101000020E6100000DD09F65FE7D95EC0FB5A971AA1494840	784	general@tsartlip.com	http://www.tsartlip.com		High-Speed[[93]]	(250) 652-3988	(250) 652-3788	Tsartlip First Nation		In addition to the band office and a number of community facilities, the W̱JOȽEȽP are home to the <a href="http://www.sisb.bc.ca/index3.html">LÁU,WELNEW Tribal School</a> and the offices of the <a href="http://www.fphlcc.ca">First Peoples' Heritage, Langauge, and Culture Council</a>.\n\nW̱JOȽEȽP (Tsartlip) is part of the W̱SÁNEĆ (Saanich) First Nation with territory centred on the Saanich Peninsula and southern Gulf Islands. The W̱SÁNEĆ (Saanich) First Nation is a single Nation that was historically split into four First Nations according to village site by the Canadian government[[218]]. Most W̱JOȽEȽP (Tsartlip) members live on the South Saanich 1 reserve in Brentwood Bay, BC.	
277	Ḵwikwa̱sutinux̱  / Ha̱'xwa-mis	0101000020E6100000A59F70766BA65FC06C3EAE0D15594940	0	\N	\N			(250) 974-3004	(250) 974-3007	Kwicksutaineuk-ah-kwaw-ah-mish,Ak-Kwa-Mish,Kwicksutaineuk/Ak-Kwa-Mish		\n\nThe Ḵwikwa̱sutinux̱̓ (Kwicksutaineuk) people are from G̱waʼyasda̱ms (Gilford Island) and the Ha̱'xwa-mis (Ah-kwaw-ah-mish) are from Wakeman Sound. The Ḵwikwa̱sutinux and Ha̱̓xwa-mis peoples now have their main community together on the west shore of Gilford Island on Retreat Pass.\n\nThe Ḵwikwa̱sutinux̱̓ (Kwicksutaineuk) people are from G̱waʼyasda̱ms (Gilford Island) and the Ha̱'xwa-mis (Ah-kwaw-ah-mish) are from Wakeman Sound. The Ḵwikwa̱sutinux and Ha̱̓xwa-mis peoples now have their main community together on the west shore of Gilford Island on Retreat Pass.\n\nThe Ḵwikwa̱sutinux̱̓ (Kwicksutaineuk) people are from G̱waʼyasda̱ms (Gilford Island) and the Ha̱'xwa-mis (Ah-kwaw-ah-mish) are from Wakeman Sound. The Ḵwikwa̱sutinux and Ha̱̓xwa-mis peoples now have their main community together on the west shore of Gilford Island on Retreat Pass.\n\nThe Ḵwikwa̱sutinux̱̓ (Kwicksutaineuk) people are from G̱waʼyasda̱ms (Gilford Island) and the Ha̱'xwa-mis (Ah-kwaw-ah-mish) are from Wakeman Sound. The Ḵwikwa̱sutinux and Ha̱̓xwa-mis peoples now have their main community together on the west shore of Gilford Island on Retreat Pass.\n\nThe Ḵwikwa̱sutinux̱̓ (Kwicksutaineuk) people are from G̱waʼyasda̱ms (Gilford Island) and the Ha̱'xwa-mis (Ah-kwaw-ah-mish) are from Wakeman Sound. The Ḵwikwa̱sutinux and Ha̱̓xwa-mis peoples now have their main community together on the west shore of Gilford Island on Retreat Pass.\n\nThe Ḵwikwa̱sutinux̱̓ (Kwicksutaineuk) people are from G̱waʼyasda̱ms (Gilford Island) and the Ha̱'xwa-mis (Ah-kwaw-ah-mish) are from Wakeman Sound. The Ḵwikwa̱sutinux and Ha̱̓xwa-mis peoples now have their main community together on the west shore of Gilford Island on Retreat Pass.	
260	Huu-ay-aht	0101000020E610000078094E7D20495FC096CCB1BCAB6A4840	646	huuayaht@island.net	http://www.huuayaht.ca		Dial-in[[93]]	(250) 728-3414	(250) 728-1222	Ohiaht,huʕiʔatḥ		The main community in Anacla on Pachena Bay has a band office, recreation centre, health centre and the new House of Huu-ay-aht.\n\nThe main community of the Huu-ay-aht First Nation, Pachena Bay (Anacla Reserve), is located approximately 12km from Bamfield on the west coast of Vancouver Island. The Huu-ay-aht have a long and proud history in their traditional territories. Their histories extend back to the beginning of time, and tell of many great people, adventures, traditions and deeds. For more information see the <a href="http://huuayaht.org">Huu-ay-aht website</a>.\r\r\nThe Huu-ay-aht First Nation is a member of the Nuu-chah-nulth Tribal Council and is a member of the <a href="http://www.maanulth.ca">Maa-nulth First Nations</a>. They have recently completed and ratified their community constitution and have successfully ratified the Maa-nulth Treaty on July 28th, 2007.	
292	Mama̱liliḵa̱la / Qwe'Qwa'Sot'Em	0101000020E6100000768D96033D505FC093A7ACA6EB034940	386	viband@telus.net	\N			(250) 287-2955	(250) 287-4655	Mamalilkulla-Qwe'Qwa'Sot'Em Band 	1-888-287-2955	\n\nThe Mama̱liliḵa̱la are originally from ʼMimkwamlis (Village Island). \n\nThe Mama̱liliḵa̱la are originally from ʼMimkwamlis (Village Island). \n\nThe Mama̱liliḵa̱la are originally from ʼMimkwamlis (Village Island). \n\nThe Mama̱liliḵa̱la are originally from ʼMimkwamlis (Village Island). \n\nThe Mama̱liliḵa̱la are originally from ʼMimkwamlis (Village Island). \n\nThe Mama̱liliḵa̱la are originally from ʼMimkwamlis (Village Island). 	
388	Ucluelet First Nation	0101000020E61000002506819543625FC043E6CAA0DA784840	618	enquiries@ufn.ca	http://www.ufn.ca		 Dial-in[[93]]	(250) 726-7342	(250) 726-7552	yu-łuʔiłʔatḥ,Yu-cluth-aht	1-877-726-7342	The organizational structure of the UFN begins and coincides with the Tyee Hawiih (traditional leader), the First Nation membership, the Chief and Council, standing committees, and the administration.\r\r\nThe village has facilities such as the Ucluelet First Nation Administration Office, Health Centre, treaty office, a fire hall, the Ucluth Development Corporation Building, and Marina.[[Ucluelet First Nation website: http://ufn.ca]]\n\nLocated on the West Coast of Vancouver Island, British Columbia, Canada the Ucluelet First Nation (UFN) traditional territory is spanned out over nine reservations. The main village of the UFN, Ittatsoo Reserve No. 1 (IR1) holds a population of approximately 200 residents and is located 28 kms from the rural community of Ucluelet.[[copied from UFN website: http://ufn.ca/index.php?option=com_content&task=view&id=22&Itemid=37]]	
396	Pellt'iq't (Whispering Pines/Clinton)	0101000020E6100000467EFD101B105EC08B89CDC7B57B4940	0	wpcib@telus.net	http://www.wpcib.com			(250) 579-5772	(250) 579-8367	Whispering Pines / Clinton Indian Band,Clinton Band		\n\nThe Pellt'iq't people, which means "people of the white earth", are one of the smallest indian bands in the Shuswap nation.[[http://www.shuswapnation.org/bands/member-bands/whisperingpines.html]] \n\nThe Pellt'iq't people, which means "people of the white earth", are one of the smallest indian bands in the Shuswap nation.[[http://www.shuswapnation.org/bands/member-bands/whisperingpines.html]] \n\nThe Pellt'iq't people, which means "people of the white earth", are one of the smallest indian bands in the Shuswap nation.[[http://www.shuswapnation.org/bands/member-bands/whisperingpines.html]] \n\nThe Pellt'iq't people, which means "people of the white earth", are one of the smallest indian bands in the Shuswap nation.[[http://www.shuswapnation.org/bands/member-bands/whisperingpines.html]] \n\nThe Pellt'iq't people, which means "people of the white earth", are one of the smallest indian bands in the Shuswap nation.[[http://www.shuswapnation.org/bands/member-bands/whisperingpines.html]] \n\nThe Pellt'iq't people, which means "people of the white earth", are one of the smallest indian bands in the Shuswap nation.[[http://www.shuswapnation.org/bands/member-bands/whisperingpines.html]] 	
294	McLeod Lake	0101000020E61000005B0BB3D0CEC25EC0D3BCE3141D7F4B40	464	\N	http://www.mlib.com		High-Speed[[93]]	(250) 750-4415	(250) 750-4420	McLeod Lake Indian Band	1-888-822-1143	McLeod Lake Band Membership totals 464 members (as defined under the Indian Act) with approximately 86 members living in McLeod Lake, 15 members living in Bear Lake, 150 members living in Mackenzie and Prince George, and the rest throughout North America. New Indian Reserves are being established in Mackenzie and Bear Lake as provisions of the Treaty 8 Adhesion Agreement. As these reserves are developed and housing constructed, it is expected that more band members will move back to Indian Reserve lands."[[copied from McLeod Lake Indian Band website - About Us http://www.mlib.ca/about_us.htm]]\n\n"The main community of McLeod Lake Band is located on McLeod Lake Indian Band Indian Reserves #1 and #5 near the unincorporated village of McLeod Lake, approximately 150 kilometres north of Prince George on Highway 97."[[copied from McLeod Lake Indian Band website - About Us http://www.mlib.ca/about_us.htm]]	
345	Skeetchestn	0101000020E610000080D3BB783F365EC01BF1643733604940	0	info@skeetchestn.ca	http://www.skeetchestn.ca			(250) 373-2493	(250) 373-2494	Skeetchestn Indian Band	1-866-373-2493	"Many Skeetchestn band members are involved in the annual rodeos, pow wows, and other social and sporting events. Skeetchestn hosts healing gatherings and living skills workshops as well. The large attendance at these events attest to the organizational skills and dedication of the community. Both social and spiritual well being is promoted by such gatherings."[[quoted from http://www.shuswapnation.org/bands/member-bands/skeetchestn.html]]\n\n"The Skeetchestn Indian Band has nearly 500 members, and 7969 hectares of land that is sectioned into 3 areas in the Deadman's Creek and Thompson River area."[[quoted from http://www.shuswapnation.org/bands/member-bands/skeetchestn.html]]	
372	Tl'etinqox-T'in Government Office	0101000020E61000002D23F59ECAD15EC04F0306499F0A4A40	0	\N	\N			(250) 394-4212	(250) 394-4275	Tl'etinqox-T'in Government Office	1-888-224-3322		
374	ʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band)	0101000020E6100000E202D0285DC55CC047C7D5C8AE8C4840	165	administration@tobaccoplains.org				(250) 887-3461	(250) 887-3424	Tobacco Plains Indian Band		\n\nʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) has their main community in Grasmere, BC. The name ʔakink̓umǂasnuqǂiʔit literally translates as "place of the flying head".\n\nʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) has their main community in Grasmere, BC. The name ʔakink̓umǂasnuqǂiʔit literally translates as "place of the flying head".\n\nʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) has their main community in Grasmere, BC. The name ʔakink̓umǂasnuqǂiʔit literally translates as "place of the flying head".\n\nʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) has their main community in Grasmere, BC. The name ʔakink̓umǂasnuqǂiʔit literally translates as "place of the flying head".\n\nʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) has their main community in Grasmere, BC. The name ʔakink̓umǂasnuqǂiʔit literally translates as "place of the flying head".\n\nʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) has their main community in Grasmere, BC. The name ʔakink̓umǂasnuqǂiʔit literally translates as "place of the flying head".	
397	T'exelcemc (Williams Lake)	0101000020E6100000499C1551137D5EC0568330B77B0B4A40	564	officeassistant@williamslakeband.ca	http://www.williamslakeband.ca			(250) 296-3507	(250) 296-4750	Williams Lake Band		"Today we have 469 band members and our population is growing. 188 members currently live on reserve, 281 live off reserve. Our band members include teachers, lawyers, social workers, artists, loggers, ranchers, and entrepreneurs. We honour our Elders and treasure our children. Our families are deeply important to us. We value our past and look towards our future."[[quoted from http://www.williamslakeband.ca/]]\n\n"The T'exelcemc (Williams Lake Band people) are members of the Secwepemc Nation (Shuswap people). Secwepemc lands extend from Shuswap Lake in the south to Quesnel Lake in the north, and from Columbia-Kootenay Range in the east to Alexis Creek Area in the west. We know, and archaeology has shown, that Northern Secwepemc culture stretches back for 4000 years in the Cariboo Region. For thousands of years we lived in semi-permanent villages in the winter and moved around on the land in the summer to collect fish, game and plant resources. We enjoyed a rich environment and a rich ceremonial life. Our chiefs led a strong people. They do so today."[[quoted from http://www.williamslakeband.ca]]	
339	Kenpesq't (Shuswap)	0101000020E610000012DDB3AED1015DC0C3F5285C8F404940	230	\N	http://www.shuswapnation.org/shuswap.html			(250) 342-6361	(250) 342-2948	Shuswap Indian Band		\n\nKenpesq't (Shuswap Indian Band) "...is separated into two sections, makes up 1,246 hectares, and has approximately 230 memebers".[[quoted from http://www.shuswapnation.org/bands/member-bands/shuswap.html]]\n\nKenpesq't (Shuswap Indian Band) "...is separated into two sections, makes up 1,246 hectares, and has approximately 230 memebers".[[quoted from http://www.shuswapnation.org/bands/member-bands/shuswap.html]]\n\nKenpesq't (Shuswap Indian Band) "...is separated into two sections, makes up 1,246 hectares, and has approximately 230 memebers".[[quoted from http://www.shuswapnation.org/bands/member-bands/shuswap.html]]\n\nKenpesq't (Shuswap Indian Band) "...is separated into two sections, makes up 1,246 hectares, and has approximately 230 memebers".[[quoted from http://www.shuswapnation.org/bands/member-bands/shuswap.html]]\n\nKenpesq't (Shuswap Indian Band) "...is separated into two sections, makes up 1,246 hectares, and has approximately 230 memebers".[[quoted from http://www.shuswapnation.org/bands/member-bands/shuswap.html]]\n\nKenpesq't (Shuswap Indian Band) "...is separated into two sections, makes up 1,246 hectares, and has approximately 230 memebers".[[quoted from http://www.shuswapnation.org/bands/member-bands/shuswap.html]]	
285	Skwlax (Little Shuswap)	0101000020E61000009A5C8C8175EC5DC03BDF4F8D97684940	0	lsibreceptionist@littleshuswaplake.com	http://www.shuswapnation.org/littleshuswap			(250) 679-3203	(250) 679-3220 or (250) 679-4422	Little Shuswap Indian Band,Squilax		"The Little Shuswap Lake Indian Band is located along the eastern end of the Little Shuswap Lake and along the western and northern end of the Big Shuswap Lake and follows along the Adams River and Little River. The Band has five parcels of land encompassing 3,112.7 hectares."[[quoted from http://www.littleshuswaplake.com/]]\n\nThe people of the Little Shuswap are known in their language as Skwlax. "The settlers could not say the Shuswap name so it is known today as Squilax. Skwlax in the Shuswap language is known as black bear."[[quoted from http://www.littleshuswaplake.com/]]	
393	West Moberly First Nations	0101000020E6100000F70489EDEE6E5EC0BBD6DEA7AAEA4B40	205	eassistant@westmo.org 	http://treaty8.bc.ca/communities/west-moberly-first-nations/			(250) 788-3663	(250) 788-9792	West Moberly First Nations 		The community is located at the west end of Moberly Lake, approximately 90km southwest of Fort St. John. It has one reserve situated on 2033.6 hectares. Facilities available on the reserve include the band office and a community centre.[[1031]]\n\nThe West Moberly First Nations was originally part of the Hudson Hope Band, which split into West Moberly and Halfway River Bands in 1977. West Moberly First Nations is covered by Treaty 8. [[1031]]	
287	Lower Nicola Indian Band	0101000020E6100000467BBC900E345EC0F08AE07F2B0F4940	1007	reception@lnib.net	http://www.lnib.net		Dial-in[[93]]	(250) 378-5157	(250) 378-6188			"The Lower Nicola Indian Band is responsible for operating a number of entities (a band school, child development centre, community (health) services centre, adult education centre and firehall) as well as two band owned enterprises: Shulus Cattle Co. Ltd.; and Lower Nicola Band Enterprises, a holding company for 63 acres of undeveloped land on the Coquihalla Highway."[[160]] \n\n"The Lower Nicola Indian Band belongs to the Scw’́exmx (“People of the Creeks”) branch of the Nłeʔkepmx Nation of the Interior Salish peoples of British Columbia. The Band has ten reserves (totaling 17,500+ acres) surrounding the town of Merritt."[[160]]	
336	SEMYOME (Semiahmoo)	0101000020E6100000AC5626FC52B15EC09B70AFCC5B814840	80	mail@semiahmoofirstnation.org	http://www.semiahmoofirstnation.org		High-Speed[[93]]	(604) 536-3101	(604) 536-6116	Semiahmoo First Nation		\n\nThe SEMYOME traditional territory is centered in the Lower Mainland in and around White Rock, BC. Their teritory extends out from the mainland into the Strait of Georgia where it overlaps with the closely related W̱SÁNEĆ (Saanich) peoples.\n\nThe SEMYOME traditional territory is centered in the Lower Mainland in and around White Rock, BC. Their teritory extends out from the mainland into the Strait of Georgia where it overlaps with the closely related W̱SÁNEĆ (Saanich) peoples.\n\nThe SEMYOME traditional territory is centered in the Lower Mainland in and around White Rock, BC. Their teritory extends out from the mainland into the Strait of Georgia where it overlaps with the closely related W̱SÁNEĆ (Saanich) peoples.\n\nThe SEMYOME traditional territory is centered in the Lower Mainland in and around White Rock, BC. Their teritory extends out from the mainland into the Strait of Georgia where it overlaps with the closely related W̱SÁNEĆ (Saanich) peoples.\n\nThe SEMYOME traditional territory is centered in the Lower Mainland in and around White Rock, BC. Their teritory extends out from the mainland into the Strait of Georgia where it overlaps with the closely related W̱SÁNEĆ (Saanich) peoples.\n\nThe SEMYOME traditional territory is centered in the Lower Mainland in and around White Rock, BC. Their teritory extends out from the mainland into the Strait of Georgia where it overlaps with the closely related W̱SÁNEĆ (Saanich) peoples.	
334	Seabird Island Indian Band	0101000020E6100000350D8AE601715EC0E1B6B6F0BC9E4840	0	reception@seabirdisland.ca	http://www.seabirdisland.ca			(604) 796-2177	(604) 796-3729	Seabird Island Band	1-800-788-0322	Seabird Island Indian Band has a large health care facility and the Seabird Island Community School: <a href="http://www.seabirdisland.ca/page/lalme-iwesawtexw-elementary-and-secondary-school">Lalme' Iwesawtexw</a>. The Band operates a restaurant, gas bar, and convenience store. It also has a hazelnut orchard, a sheep farm, a cottonwood plantation and leases of cultivated land.\n\nLocated in Agassiz, Brigish Columiba, the community of Seabird Island Band is located on a 1,820 hectare island bordered by the channels of the Fraser River.	
355	Songhees Nation	0101000020E610000094DDCCE847DB5EC0D313967840394840	490	songhees@pacificcoast.net	http://www.songheesnation.com		High-Speed[[93]]	(250) 386-1043	(250) 386-4161	Songhees First Nation,Songish,Lekwungen	1-888-386-1043	\n\nThe territory of the Songhees Nation includes the current city of Victoria and surrounding areas. The main community was moved from the west side of the Victoria harbour to lands that adjoin the SXIMEȽEȽ (Esquimalt) Nation's main reserve.\n\nThe territory of the Songhees Nation includes the current city of Victoria and surrounding areas. The main community was moved from the west side of the Victoria harbour to lands that adjoin the SXIMEȽEȽ (Esquimalt) Nation's main reserve.\n\nThe territory of the Songhees Nation includes the current city of Victoria and surrounding areas. The main community was moved from the west side of the Victoria harbour to lands that adjoin the SXIMEȽEȽ (Esquimalt) Nation's main reserve.\n\nThe territory of the Songhees Nation includes the current city of Victoria and surrounding areas. The main community was moved from the west side of the Victoria harbour to lands that adjoin the SXIMEȽEȽ (Esquimalt) Nation's main reserve.\n\nThe territory of the Songhees Nation includes the current city of Victoria and surrounding areas. The main community was moved from the west side of the Victoria harbour to lands that adjoin the SXIMEȽEȽ (Esquimalt) Nation's main reserve.\n\nThe territory of the Songhees Nation includes the current city of Victoria and surrounding areas. The main community was moved from the west side of the Victoria harbour to lands that adjoin the SXIMEȽEȽ (Esquimalt) Nation's main reserve.	
361	ʔaq̓am (St. Mary's Band)	0101000020E6100000AA99B51490F05CC003081F4AB4C84840	0	stmarysreception@cyberlink.bc.ca	\N			(250) 426-5717	(250) 426-8935	St. Mary's Indian Band		\n\nʔaq̓am (St. Mary's Band) has their main community in Cranbrook, BC. The name ʔaq̓am literally translates as "deep dense woods"[[291]].\n\nʔaq̓am (St. Mary's Band) has their main community in Cranbrook, BC. The name ʔaq̓am literally translates as "deep dense woods"[[291]].\n\nʔaq̓am (St. Mary's Band) has their main community in Cranbrook, BC. The name ʔaq̓am literally translates as "deep dense woods"[[291]].\n\nʔaq̓am (St. Mary's Band) has their main community in Cranbrook, BC. The name ʔaq̓am literally translates as "deep dense woods"[[291]].\n\nʔaq̓am (St. Mary's Band) has their main community in Cranbrook, BC. The name ʔaq̓am literally translates as "deep dense woods"[[291]].\n\nʔaq̓am (St. Mary's Band) has their main community in Cranbrook, BC. The name ʔaq̓am literally translates as "deep dense woods"[[291]].	
204	ʔEsdilagh	0101000020E6100000F19F6EA0C09F5EC001A3CB9BC3574A40	177	\N						Alexandria Indian Band,Esdilagh		\n\nʔEsdilagh is a Tsilhqot'in community that the Canadian government has previously called Alexandria Band.\n\nʔEsdilagh is a Tsilhqot'in community that the Canadian government has previously called Alexandria Band.\n\nʔEsdilagh is a Tsilhqot'in community that the Canadian government has previously called Alexandria Band.\n\nʔEsdilagh is a Tsilhqot'in community that the Canadian government has previously called Alexandria Band.\n\nʔEsdilagh is a Tsilhqot'in community that the Canadian government has previously called Alexandria Band.\n\nʔEsdilagh is a Tsilhqot'in community that the Canadian government has previously called Alexandria Band.	
331	Samahquam Nation	0101000020E6100000C3F0113125855EC03387A4164A964840	0	\N				(604) 894-3355		Samakwa Band		The village of Samahquam at southeast end of Little Lillooet Lake dates back centuries and perhaps even millennia. In historic times, the town of 29-Mile House was built beside the eastern arm of the village and it served as the end of the first portage along the Harrison-Lillooet route and a point of embarkment for steamships. In the 1950s, the Samahquam Nation dispersed to other reserves where better economic opportunities could be found. In recent times, new houses have been built at Samahquam and families have moved back to the village.\r\r\n"The majority of schoolchildren from this community attend the Xit'olacw community school in Mount Currie, and Pemberton Elementary. The majority of high school students living on reserve attend the Mount Currie School, Pemberton Secondary, or Mission Secondary."[[1363]]\n\n"The recently re-constructed community of Baptiste-Smith, located at the southwest end of Little Lillooet Lake on the Lillooet River system, is the newest of those along the Lillooet River. It is the current residence of members of the Samahquam [shah-MAH-kwum] Nation, who had previously lived on the Samahquam Reserve (I.R. 1) about 5 kilometres south of Baptiste-Smith (I.R. 1b)."[[1363]]	
383	W̱SIḴEM (Tseycum)	0101000020E61000004371C79BFCDC5EC0F1F274AE28554840	155	accounting@tseycum.ca	\N		High-Speed[[93]]	(250) 656-0858	(250) 656-0868	Tseycum First Nation	1-877-656-0858	W̱SIḴEM (Tseycum) is self governed and offers assistance to its members and guests by way of Health, Youth, Elder, Community, Employment and Financial support[[220]]. \n\nW̱SIḴEM (Tseycum) is part of the W̱SÁNEĆ (Saanich) First Nation with territory centred on the Saanich Peninsula and southern Gulf Islands. The W̱SÁNEĆ (Saanich) First Nation is a single Nation that was historically split into four First Nations according to village site by the Canadian government[[218]]. Most W̱SIḴEM (Tseycum) members live on the Union Bay Indian Reserve No.4 reserve at the centre of Patricia Bay on the Saanich Peninsula. In SENĆOŦEN, the name W̱SIḴEM means "land of clay"[[220]].	
237	Douglas First Nation	0101000020E6100000231631EC30855EC047AB5AD251964840	0	\N	\N					Douglas First Nation,Xa'xtsa Nation		"The name 'Port Douglas' originates from the colonial period, when the town, one of the earliest to be established in British Columbia, was erected adjacent to the present First Nations community in 1858. It was the starting point on the famed Harrison-Lillooet wagon road, also known in historic times as the Douglas Portage... Thousands of miners from all over the world stopped in Port Douglas before undertaking on this less than comfortable trail, which led to the Fraser River and on to the Cariboo gold fields. The town reached its economic peak between 1859 and 1860, but after the completion of the Cariboo wagon road through the Fraser River Canyon, traffic through Port Douglas was re-routed, and the town was virtually abandoned by 1865. The lot on which the town of Port Douglas stood eventually became a logging camp for a number of different logging companies. The community of Douglas reached its economic peak in the 1950's when residents from the communities up the Lillooet River stayed at Douglas during the summer months, working in the logging industry. Port Douglas was also used as a launch point for travel down Harrison Lake to New Westminster. Many members of the communities of Douglas, Skatin (Skookumchuck), and Samahquam traveled to Agassiz and Hammersley to pick hops and berries. Although they began hop-picking in the early 1900's, this activity did not reach its peak until the 1940's and 1950's... The forestry companies have since moved out of Port Douglas... [and] a mining company now inhabits the logging camp at Port Douglas... Only a few families presently inhabit the Douglas community, but many hope to return to it, once the treaty is completed. It is hoped that the treaty will allow members to build new homes and create the kinds of economic opportunities that were once so attainable in their cherished community."[[1363]]\n\n"The community of Douglas is situated at the northern end of Little Harrison Lake, which is connected by the Douglas Channel to the much larger Harrison Lake. This is the southern most of the In-SHUCK-ch community and also of the entire Lillooet [St̓át̓imcets] linguistic group. Another community on the west side of the Lillooet River, commonly known as Tipella, is affiliated with the community of Douglas, since most of the members of Xa'xtsa [HAHK-cha] Nation (commonly known as the Douglas Band) presently live here."[[1363]]	
395	Wet'suwet'en First Nation	0101000020E61000000A67B796C9CA5FC0596E693524644B40	0	\N						Broman Lake Indian Band		\n\n"The Wet’suwet’en First Nation located outside of Burns Lake in the central interior of British Columbia. It was formerly known as the Broman Lake Indian Band and is still usually referred to as Broman Lake although this is no longer its official name. Its members speak the Witsuwit’en dialect of Babine-Witsuwit’en, a Northern Athabaskan language. The main community is on Palling Indian Reserve No. 1."[[quoted from http://www.cstc.bc.ca/cstc/44/wetsuweten+first+nation]]\n\n"The Wet’suwet’en First Nation located outside of Burns Lake in the central interior of British Columbia. It was formerly known as the Broman Lake Indian Band and is still usually referred to as Broman Lake although this is no longer its official name. Its members speak the Witsuwit’en dialect of Babine-Witsuwit’en, a Northern Athabaskan language. The main community is on Palling Indian Reserve No. 1."[[quoted from http://www.cstc.bc.ca/cstc/44/wetsuweten+first+nation]]\n\n"The Wet’suwet’en First Nation located outside of Burns Lake in the central interior of British Columbia. It was formerly known as the Broman Lake Indian Band and is still usually referred to as Broman Lake although this is no longer its official name. Its members speak the Witsuwit’en dialect of Babine-Witsuwit’en, a Northern Athabaskan language. The main community is on Palling Indian Reserve No. 1."[[quoted from http://www.cstc.bc.ca/cstc/44/wetsuweten+first+nation]]\n\n"The Wet’suwet’en First Nation located outside of Burns Lake in the central interior of British Columbia. It was formerly known as the Broman Lake Indian Band and is still usually referred to as Broman Lake although this is no longer its official name. Its members speak the Witsuwit’en dialect of Babine-Witsuwit’en, a Northern Athabaskan language. The main community is on Palling Indian Reserve No. 1."[[quoted from http://www.cstc.bc.ca/cstc/44/wetsuweten+first+nation]]\n\n"The Wet’suwet’en First Nation located outside of Burns Lake in the central interior of British Columbia. It was formerly known as the Broman Lake Indian Band and is still usually referred to as Broman Lake although this is no longer its official name. Its members speak the Witsuwit’en dialect of Babine-Witsuwit’en, a Northern Athabaskan language. The main community is on Palling Indian Reserve No. 1."[[quoted from http://www.cstc.bc.ca/cstc/44/wetsuweten+first+nation]]\n\n"The Wet’suwet’en First Nation located outside of Burns Lake in the central interior of British Columbia. It was formerly known as the Broman Lake Indian Band and is still usually referred to as Broman Lake although this is no longer its official name. Its members speak the Witsuwit’en dialect of Babine-Witsuwit’en, a Northern Athabaskan language. The main community is on Palling Indian Reserve No. 1."[[quoted from http://www.cstc.bc.ca/cstc/44/wetsuweten+first+nation]]	
301	Nak'azdli Band	0101000020E61000003677F4BF5C105FC0CC9A58E02B384B40	0	nakazdli@nakazdli.ca	http://www.nakazdli.ca		High-Speed[[93]]	(250) 996-7171	(250) 996-8010	Nak'azdli First Nation,Nak'azdli Whut'en,Necoslie,Necausley		Much of our activities revolve around forestry, some trapping, hunting, fishing and year round youth activities.  Nak'azdli has its own Elementary School (known as Nak'albun Elementary), Youth Center, Church, Gas Station, Gymnasium, Band office, Sawmill and are one of three partners in Sustat Holdings Ltd.  There are future developments towards a Recreation Center, Community Pool and Shopping Center.[[Text copied from the Nak'azdli website: http://www.nakazdli.ca/aboutus.htm]]\n\nNak'azdli is located on Necoslie I.R. No. 1 in Fort St. James; 60km (37m) of Vanderhoof or 153km (94m) from Prince George (closest city). There is some dispersed housing on I.R. No 1A. Nak'azdli First Nation services 16 reserves totaling 1,458 hectares.[[Text copied from the Nak'azdli website: http://www.nakazdli.ca/aboutus.htm]]	
370	T̕łat̕łasiḵ̕wala	0101000020E61000002E573F36C9FB5FC088F546AD30754940	49	\N				(250) 949-5751	(250) 949-5741	Tlatlasikwala First Nation		\n\nThe T̕łat̕łasiḵ̕wala (Tlatlasikwala) First Nation) have their main village on Xwa̱mdasbeʼ (Hope Island).\n\nThe T̕łat̕łasiḵ̕wala (Tlatlasikwala) First Nation) have their main village on Xwa̱mdasbeʼ (Hope Island).\n\nThe T̕łat̕łasiḵ̕wala (Tlatlasikwala) First Nation) have their main village on Xwa̱mdasbeʼ (Hope Island).\n\nThe T̕łat̕łasiḵ̕wala (Tlatlasikwala) First Nation) have their main village on Xwa̱mdasbeʼ (Hope Island).\n\nThe T̕łat̕łasiḵ̕wala (Tlatlasikwala) First Nation) have their main village on Xwa̱mdasbeʼ (Hope Island).\n\nThe T̕łat̕łasiḵ̕wala (Tlatlasikwala) First Nation) have their main village on Xwa̱mdasbeʼ (Hope Island).	
209	Ashcroft Indian Band	0101000020E6100000FB40F2CEA1545EC05587DC0C375C4940	246	aib@telus.net			 No Access[[93]]	(250) 453-9154				\n\nThe Ashcroft First Nation is a member of the Nlaka'pamux Nation Tribal Council and their main community is located near the town of Ashcroft.\n\nThe Ashcroft First Nation is a member of the Nlaka'pamux Nation Tribal Council and their main community is located near the town of Ashcroft.\n\nThe Ashcroft First Nation is a member of the Nlaka'pamux Nation Tribal Council and their main community is located near the town of Ashcroft.\n\nThe Ashcroft First Nation is a member of the Nlaka'pamux Nation Tribal Council and their main community is located near the town of Ashcroft.\n\nThe Ashcroft First Nation is a member of the Nlaka'pamux Nation Tribal Council and their main community is located near the town of Ashcroft.\n\nThe Ashcroft First Nation is a member of the Nlaka'pamux Nation Tribal Council and their main community is located near the town of Ashcroft.	
259	Hupacasath	0101000020E6100000849ECDAACF345FC001344A97FEA14840	257	reception@hupacasath.ca	http://www.hupacasath.ca			(250) 724-4041	(250) 724-1232	Opetchesaht		\n\nFor thousands of years the Hupacasath people have owned, used, and occupied their traditional territory on Central Vancouver Island. The Hupacasath are comprised of three distinct tribes, the Muh-uulth-aht, Kleh-koot-aht and Cuu-ma-as-aht (Ahahswinis).  The territory is approximately 229,000 hectares, which engulfs the whole Alberni Valley. The boundaries for this territory are basically the mountain peaks from the Alberni Valley, which start from the north at Mt. Chief Frank, from the south at 5040 Peak and Hannah Mountain, from the east at Mt. Arrowsmith and Mt Spencer, and from the west from Big Interior Mountain.[[Introduction text copied from the Hupacasath "Treaty - Background" webpage: http://www.hupacasath.ca/treaty/background.html]]\n\nFor thousands of years the Hupacasath people have owned, used, and occupied their traditional territory on Central Vancouver Island. The Hupacasath are comprised of three distinct tribes, the Muh-uulth-aht, Kleh-koot-aht and Cuu-ma-as-aht (Ahahswinis).  The territory is approximately 229,000 hectares, which engulfs the whole Alberni Valley. The boundaries for this territory are basically the mountain peaks from the Alberni Valley, which start from the north at Mt. Chief Frank, from the south at 5040 Peak and Hannah Mountain, from the east at Mt. Arrowsmith and Mt Spencer, and from the west from Big Interior Mountain.[[Introduction text copied from the Hupacasath "Treaty - Background" webpage: http://www.hupacasath.ca/treaty/background.html]]\n\nFor thousands of years the Hupacasath people have owned, used, and occupied their traditional territory on Central Vancouver Island. The Hupacasath are comprised of three distinct tribes, the Muh-uulth-aht, Kleh-koot-aht and Cuu-ma-as-aht (Ahahswinis).  The territory is approximately 229,000 hectares, which engulfs the whole Alberni Valley. The boundaries for this territory are basically the mountain peaks from the Alberni Valley, which start from the north at Mt. Chief Frank, from the south at 5040 Peak and Hannah Mountain, from the east at Mt. Arrowsmith and Mt Spencer, and from the west from Big Interior Mountain.[[Introduction text copied from the Hupacasath "Treaty - Background" webpage: http://www.hupacasath.ca/treaty/background.html]]\n\nFor thousands of years the Hupacasath people have owned, used, and occupied their traditional territory on Central Vancouver Island. The Hupacasath are comprised of three distinct tribes, the Muh-uulth-aht, Kleh-koot-aht and Cuu-ma-as-aht (Ahahswinis).  The territory is approximately 229,000 hectares, which engulfs the whole Alberni Valley. The boundaries for this territory are basically the mountain peaks from the Alberni Valley, which start from the north at Mt. Chief Frank, from the south at 5040 Peak and Hannah Mountain, from the east at Mt. Arrowsmith and Mt Spencer, and from the west from Big Interior Mountain.[[Introduction text copied from the Hupacasath "Treaty - Background" webpage: http://www.hupacasath.ca/treaty/background.html]]\n\nFor thousands of years the Hupacasath people have owned, used, and occupied their traditional territory on Central Vancouver Island. The Hupacasath are comprised of three distinct tribes, the Muh-uulth-aht, Kleh-koot-aht and Cuu-ma-as-aht (Ahahswinis).  The territory is approximately 229,000 hectares, which engulfs the whole Alberni Valley. The boundaries for this territory are basically the mountain peaks from the Alberni Valley, which start from the north at Mt. Chief Frank, from the south at 5040 Peak and Hannah Mountain, from the east at Mt. Arrowsmith and Mt Spencer, and from the west from Big Interior Mountain.[[Introduction text copied from the Hupacasath "Treaty - Background" webpage: http://www.hupacasath.ca/treaty/background.html]]\n\nFor thousands of years the Hupacasath people have owned, used, and occupied their traditional territory on Central Vancouver Island. The Hupacasath are comprised of three distinct tribes, the Muh-uulth-aht, Kleh-koot-aht and Cuu-ma-as-aht (Ahahswinis).  The territory is approximately 229,000 hectares, which engulfs the whole Alberni Valley. The boundaries for this territory are basically the mountain peaks from the Alberni Valley, which start from the north at Mt. Chief Frank, from the south at 5040 Peak and Hannah Mountain, from the east at Mt. Arrowsmith and Mt Spencer, and from the west from Big Interior Mountain.[[Introduction text copied from the Hupacasath "Treaty - Background" webpage: http://www.hupacasath.ca/treaty/background.html]]	
216	Ts'il Kaz Koh (Burns Lake)	0101000020E610000015C616821C715FC058C6866EF61D4B40	104	blb100@telus.net	http://www.burnslakeband.com		High-Speed[[93]]	(250) 692-7717	(250) 692-4214	Burns Lake Band		\n\nThe Ts’il Kaz Koh people speak Dakelh and have their adminnistration office located in Burns Lake. \n\nThe Ts’il Kaz Koh people speak Dakelh and have their adminnistration office located in Burns Lake. \n\nThe Ts’il Kaz Koh people speak Dakelh and have their adminnistration office located in Burns Lake. \n\nThe Ts’il Kaz Koh people speak Dakelh and have their adminnistration office located in Burns Lake. \n\nThe Ts’il Kaz Koh people speak Dakelh and have their adminnistration office located in Burns Lake. \n\nThe Ts’il Kaz Koh people speak Dakelh and have their adminnistration office located in Burns Lake. 	
320	BOḰEĆEN (Pauquachin)	0101000020E6100000CAA31B6151DD5EC012876C205D504840	367	pauquachinband@shawcable.com			 High-Speed[[93]] 	(250) 656-0191	(250) 656-6134	Pauquachin First Nation		\n\nThe BOḰEĆEN (Pauquachin) are one of the W̱SÁNEĆ (Saanich) peoples with a territory that is centred on the Saanich Penninsula, Goldstream, and neighbouring islands. Most community members live at the Pauquachin main reserve on Coles Bay. The families of BOḰEĆEN speak two languages: SENĆOŦEN and Hul’q’umi’num’ [[Deanna Daniels, Pauquachin Councillor, personal communication to Towagh Behr, April 16, 2008.]].\n\nThe BOḰEĆEN (Pauquachin) are one of the W̱SÁNEĆ (Saanich) peoples with a territory that is centred on the Saanich Penninsula, Goldstream, and neighbouring islands. Most community members live at the Pauquachin main reserve on Coles Bay. The families of BOḰEĆEN speak two languages: SENĆOŦEN and Hul’q’umi’num’ [[Deanna Daniels, Pauquachin Councillor, personal communication to Towagh Behr, April 16, 2008.]].\n\nThe BOḰEĆEN (Pauquachin) are one of the W̱SÁNEĆ (Saanich) peoples with a territory that is centred on the Saanich Penninsula, Goldstream, and neighbouring islands. Most community members live at the Pauquachin main reserve on Coles Bay. The families of BOḰEĆEN speak two languages: SENĆOŦEN and Hul’q’umi’num’ [[Deanna Daniels, Pauquachin Councillor, personal communication to Towagh Behr, April 16, 2008.]].\n\nThe BOḰEĆEN (Pauquachin) are one of the W̱SÁNEĆ (Saanich) peoples with a territory that is centred on the Saanich Penninsula, Goldstream, and neighbouring islands. Most community members live at the Pauquachin main reserve on Coles Bay. The families of BOḰEĆEN speak two languages: SENĆOŦEN and Hul’q’umi’num’ [[Deanna Daniels, Pauquachin Councillor, personal communication to Towagh Behr, April 16, 2008.]].\n\nThe BOḰEĆEN (Pauquachin) are one of the W̱SÁNEĆ (Saanich) peoples with a territory that is centred on the Saanich Penninsula, Goldstream, and neighbouring islands. Most community members live at the Pauquachin main reserve on Coles Bay. The families of BOḰEĆEN speak two languages: SENĆOŦEN and Hul’q’umi’num’ [[Deanna Daniels, Pauquachin Councillor, personal communication to Towagh Behr, April 16, 2008.]].\n\nThe BOḰEĆEN (Pauquachin) are one of the W̱SÁNEĆ (Saanich) peoples with a territory that is centred on the Saanich Penninsula, Goldstream, and neighbouring islands. Most community members live at the Pauquachin main reserve on Coles Bay. The families of BOḰEĆEN speak two languages: SENĆOŦEN and Hul’q’umi’num’ [[Deanna Daniels, Pauquachin Councillor, personal communication to Towagh Behr, April 16, 2008.]].	
228	Coldwater	0101000020E610000060E4654D2C325EC03067B62BF40D4940	761	\N	http://www.coldwaterband.com		Dial-in[[93]]	(250) 378-6174	(250) 378-5351	nc̓́əł́etkʷu (cold water)		\n\nThe Coldwater Indian Band's main community is about 10km southwest of Merritt.\n\nThe Coldwater Indian Band's main community is about 10km southwest of Merritt.\n\nThe Coldwater Indian Band's main community is about 10km southwest of Merritt.\n\nThe Coldwater Indian Band's main community is about 10km southwest of Merritt.\n\nThe Coldwater Indian Band's main community is about 10km southwest of Merritt.\n\nThe Coldwater Indian Band's main community is about 10km southwest of Merritt.	
248	Gwa'sala-'Nakwaxda'xw First Nation	0101000020E610000098BF42E6CADF5FC03F36C98FF85D4940	782	gwanak@telus.net			High-Speed[[93]]	(250) 949-8343	(250) 949-7402			\n\nThe Gwaʼsa̱la are from Takʼus (Smiths Inlet) and the ʼNakʼwaxdaʼx̱w are from Baʼas (Blunden Harbour). These groups now live together at on the west shore of Hardy Bay, just north of Port Hardy.\n\nThe Gwaʼsa̱la are from Takʼus (Smiths Inlet) and the ʼNakʼwaxdaʼx̱w are from Baʼas (Blunden Harbour). These groups now live together at on the west shore of Hardy Bay, just north of Port Hardy.\n\nThe Gwaʼsa̱la are from Takʼus (Smiths Inlet) and the ʼNakʼwaxdaʼx̱w are from Baʼas (Blunden Harbour). These groups now live together at on the west shore of Hardy Bay, just north of Port Hardy.\n\nThe Gwaʼsa̱la are from Takʼus (Smiths Inlet) and the ʼNakʼwaxdaʼx̱w are from Baʼas (Blunden Harbour). These groups now live together at on the west shore of Hardy Bay, just north of Port Hardy.\n\nThe Gwaʼsa̱la are from Takʼus (Smiths Inlet) and the ʼNakʼwaxdaʼx̱w are from Baʼas (Blunden Harbour). These groups now live together at on the west shore of Hardy Bay, just north of Port Hardy.\n\nThe Gwaʼsa̱la are from Takʼus (Smiths Inlet) and the ʼNakʼwaxdaʼx̱w are from Baʼas (Blunden Harbour). These groups now live together at on the west shore of Hardy Bay, just north of Port Hardy.	
262	Ka:'yu:'k't'h' / Che:k:tles7et'h'	0101000020E61000005C035B2558D65FC0D593F947DF084940	499	\N			Dial-in[[93]]	(250) 332-5259	(250) 332-5210	Kyuquot,Checleseht,Chickliset,Checlesaht,Cheklesahht		The Kyuquot/Checleseht region is accessible only by air or water.\n\n"We are the Ka:'yu:'k't'h'/Che:k:tles7et'h' (pronounced Kie-YOU-cut and TSHEH-kleh-szet) First Nations. Our home is on the Pacific west coast of Vancouver Island. Our territory stretches from Porritt Creek, north of Nootka Sound, to Solander Island at the tip of Brooks Peninsula; inland to the height of land and seaward to the point where you can no longer see land while standing in a canoe.\r\r\nOur two Nations came together in the early 1960s. Together, we are the northern most of 14 Nuu-chah-nulth First Nations occupying approximately 300 acres of Vancouver Island’s Pacific coast.  Like the other Nuu-chah-nulth Nations, the Ka:'yu:'k't'h'/Che:k:tles7et'h' First Nations are confederacies, comprised of several chiefly families.\r\r\nEach of our chiefly families’ names is associated with a stream, inlet, island or other natural feature. Family names carry the suffix –aht, which means “people of.” For example, Ka:'yu:'k't'h' (Kyuquot), are “the people of Ka:'yu:'k.” In this way, our connection to the lands and waters of this region is evident even in our own tribal names."[[Text copied from the Ka:'yu:'k't'h'/Che:k:tles7et'h' website: http://www.kyuquot.ca/people.html]] 	
357	Splats'in	0101000020E6100000E8667FA0DCC85DC0096EA46C91464940	0	\N	http://www.spallumcheen.org			(250) 838-6496	(250) 838-2131	Spallumcheen Indian Band		\n\n"The Splats'in First Nations people reside on Indian reserve lands adjacent to the City of Enderby to the south and across the Shuswap river to the east. The Splats'in are the most southern tribe of the Shuswap [Secwepemc] Nation, the largest Interior Salish speaking First Nation in Canada whose aboriginal territory stretches from the BC/Alberta border near the Yellowhead Pass to the plateau west of the Fraser River, southeast to the Arrow Lakes and to the upper reaches of the Columbia River."[[quoted from http://www.splatsin.ca]]\n\n"The Splats'in First Nations people reside on Indian reserve lands adjacent to the City of Enderby to the south and across the Shuswap river to the east. The Splats'in are the most southern tribe of the Shuswap [Secwepemc] Nation, the largest Interior Salish speaking First Nation in Canada whose aboriginal territory stretches from the BC/Alberta border near the Yellowhead Pass to the plateau west of the Fraser River, southeast to the Arrow Lakes and to the upper reaches of the Columbia River."[[quoted from http://www.splatsin.ca]]\n\n"The Splats'in First Nations people reside on Indian reserve lands adjacent to the City of Enderby to the south and across the Shuswap river to the east. The Splats'in are the most southern tribe of the Shuswap [Secwepemc] Nation, the largest Interior Salish speaking First Nation in Canada whose aboriginal territory stretches from the BC/Alberta border near the Yellowhead Pass to the plateau west of the Fraser River, southeast to the Arrow Lakes and to the upper reaches of the Columbia River."[[quoted from http://www.splatsin.ca]]\n\n"The Splats'in First Nations people reside on Indian reserve lands adjacent to the City of Enderby to the south and across the Shuswap river to the east. The Splats'in are the most southern tribe of the Shuswap [Secwepemc] Nation, the largest Interior Salish speaking First Nation in Canada whose aboriginal territory stretches from the BC/Alberta border near the Yellowhead Pass to the plateau west of the Fraser River, southeast to the Arrow Lakes and to the upper reaches of the Columbia River."[[quoted from http://www.splatsin.ca]]\n\n"The Splats'in First Nations people reside on Indian reserve lands adjacent to the City of Enderby to the south and across the Shuswap river to the east. The Splats'in are the most southern tribe of the Shuswap [Secwepemc] Nation, the largest Interior Salish speaking First Nation in Canada whose aboriginal territory stretches from the BC/Alberta border near the Yellowhead Pass to the plateau west of the Fraser River, southeast to the Arrow Lakes and to the upper reaches of the Columbia River."[[quoted from http://www.splatsin.ca]]\n\n"The Splats'in First Nations people reside on Indian reserve lands adjacent to the City of Enderby to the south and across the Shuswap river to the east. The Splats'in are the most southern tribe of the Shuswap [Secwepemc] Nation, the largest Interior Salish speaking First Nation in Canada whose aboriginal territory stretches from the BC/Alberta border near the Yellowhead Pass to the plateau west of the Fraser River, southeast to the Arrow Lakes and to the upper reaches of the Columbia River."[[quoted from http://www.splatsin.ca]]	
399	Xeni Gwet'in	0101000020E61000001EC539EAE8F55EC04451A04FE4BD4940	393	xeni_nitsilin_1991@yahoo.ca	http://www.xenigwetin.com			(250) 394-7023	(250) 394-7043	Nemiah Valley Indian Band		\n\nXeni Gwet'in is located 145 miles north west of Williams Lake and the last 75 miles from Lee's Corner to Xeni (Nemiah Valley) is gravel road. \r\r\n\r\r\nThe Nemiah Aboriginal Wilderness Preserve is our spiritual and economic homeland: from the lakes of Chilko, Taseko and Tatlayoko, where we fish for salmon and trout; to the mountains where we gather wild potatoes and berries; to the pristine forests where we hunt, gather medicinal plants and practice our sacred and spiritual ways.[[Text copied from Xeni Gwet'in homepage: http://www.xenigwetin.com]]\r\r\n\n\nXeni Gwet'in is located 145 miles north west of Williams Lake and the last 75 miles from Lee's Corner to Xeni (Nemiah Valley) is gravel road. \r\r\n\r\r\nThe Nemiah Aboriginal Wilderness Preserve is our spiritual and economic homeland: from the lakes of Chilko, Taseko and Tatlayoko, where we fish for salmon and trout; to the mountains where we gather wild potatoes and berries; to the pristine forests where we hunt, gather medicinal plants and practice our sacred and spiritual ways.[[Text copied from Xeni Gwet'in homepage: http://www.xenigwetin.com]]\r\r\n\n\nXeni Gwet'in is located 145 miles north west of Williams Lake and the last 75 miles from Lee's Corner to Xeni (Nemiah Valley) is gravel road. \r\r\n\r\r\nThe Nemiah Aboriginal Wilderness Preserve is our spiritual and economic homeland: from the lakes of Chilko, Taseko and Tatlayoko, where we fish for salmon and trout; to the mountains where we gather wild potatoes and berries; to the pristine forests where we hunt, gather medicinal plants and practice our sacred and spiritual ways.[[Text copied from Xeni Gwet'in homepage: http://www.xenigwetin.com]]\r\r\n\n\nXeni Gwet'in is located 145 miles north west of Williams Lake and the last 75 miles from Lee's Corner to Xeni (Nemiah Valley) is gravel road. \r\r\n\r\r\nThe Nemiah Aboriginal Wilderness Preserve is our spiritual and economic homeland: from the lakes of Chilko, Taseko and Tatlayoko, where we fish for salmon and trout; to the mountains where we gather wild potatoes and berries; to the pristine forests where we hunt, gather medicinal plants and practice our sacred and spiritual ways.[[Text copied from Xeni Gwet'in homepage: http://www.xenigwetin.com]]\r\r\n\n\nXeni Gwet'in is located 145 miles north west of Williams Lake and the last 75 miles from Lee's Corner to Xeni (Nemiah Valley) is gravel road. \r\r\n\r\r\nThe Nemiah Aboriginal Wilderness Preserve is our spiritual and economic homeland: from the lakes of Chilko, Taseko and Tatlayoko, where we fish for salmon and trout; to the mountains where we gather wild potatoes and berries; to the pristine forests where we hunt, gather medicinal plants and practice our sacred and spiritual ways.[[Text copied from Xeni Gwet'in homepage: http://www.xenigwetin.com]]\r\r\n\n\nXeni Gwet'in is located 145 miles north west of Williams Lake and the last 75 miles from Lee's Corner to Xeni (Nemiah Valley) is gravel road. \r\r\n\r\r\nThe Nemiah Aboriginal Wilderness Preserve is our spiritual and economic homeland: from the lakes of Chilko, Taseko and Tatlayoko, where we fish for salmon and trout; to the mountains where we gather wild potatoes and berries; to the pristine forests where we hunt, gather medicinal plants and practice our sacred and spiritual ways.[[Text copied from Xeni Gwet'in homepage: http://www.xenigwetin.com]]\r\r\n	
205	Sexqeltqín (Adams Lake)	0101000020E610000023DC645419ED5DC04703780B246A4940	726	receptionist@alib.ca				(250) 679-8841	(250) 679-8813	Adams Lake Indian Band		"ALIB provides an extensive array of services to its membership, including a domestic water system and sewer system on Sahhaltkum I.R. 4. Adams Lake Band is home to a well-known language immersion school, Chief Atahm School (www.chiefatahm.com). The majority of the administrative offices are located on I.R. 4, adjacent to the Village of Chase and overlooking Little Shuswap Lake. The Nexe7yélst/Pierre Moyese Centre on Switsemalph I.R. 6, near Salmon Arm, along with administrative functions, provides health and social services."[[quoted from http://www.adamslakeband.org/]]\n\n"The Adams Lake Indian Band (ALIB) belongs to the Secwepemc Nation. Historically there were as many as 35 Secwepemc Communities, but today there are 17 communities or Bands recognized within the Secwepemc Territory. Adams Lake Indian Band is a member of the Shuswap Nation Tribal Council (SNTC) , which consists of 10 Secwepemc Bands."[[quoted from http://www.adamslakeband.org/]]	
263	Tk'emlups (Kamloops)	0101000020E6100000C40AB77C24135EC09B3C65355D574940	1002	info@kib.ca	http://www.kib.ca			(250) 828-9700	(250) 372-8833	Kamloops Indian Band,Tk’umlups Indian Band		"Despite the effects of small pox epidemics in the 1800s and early 1900s, Tk'emlups remains the largest of the Secwepemc bands. Today we have more than 1,000 members living on and off the reserve. Our 33,000-acre reserve, supports a variety of uses including residential, industrial, commercial and agricultural. In recent years, Tk'emlups purchased the former Harper Ranch which added 20,000 acres of land and crown leases for resource development and other economic opportunities. Tk'emlups manages the operation of the Sk'elep School of Excellence, the Tk'emlups Gas Bar and holds the Kamloopa Pow Wow annually."[[quoted from http://www.shuswapnation.org/bands/member-bands/kib.html]]\n\n"Tk'emlups te Secwepemc formerly known as Kamloops Indian Band land base was established in 1862 under the direction of Governor James Douglas. It is located east of the North Thompson River and north of the South Thompson River, adjacent to the City of Kamloops. The word "Kamloops" is the English translation of the Shuswap word Tk'emlups, meaning where the rivers meet and for centuries has been the home of the Tk'emlupsemc, people of the confluence."[[quoted from http://www.shuswapnation.org/bands/member-bands/kib.html]]	
354	Xats'ull (Soda Creek)	0101000020E6100000E3C62DE6E7875EC0D8BCAAB35A224A40	0	education@xatsull.com	http://www.xatsull.com			(250) 989-2323	(250) 989-2300	Soda Creek Indian Band,Hat'sull		\n\n"The Xat'súll First Nation is a member of the Great Secwepemc Nation, once known as the people of Xat'súll (on the cliff where the bubbling water comes out). Xat'súll (Hat'sull) is the northern most Shuswap tribe of the Secwepemc Nation, which is the largest Nation within the interior of BC.  The Xat'súll have stewarded territory ranging from the Coast Mountains to the west, east to the Rocky Mountains."[[quoted from http://www.xatsull.com/Community/History/tabid/71/Default.aspx]]\n\n"The Xat'súll First Nation is a member of the Great Secwepemc Nation, once known as the people of Xat'súll (on the cliff where the bubbling water comes out). Xat'súll (Hat'sull) is the northern most Shuswap tribe of the Secwepemc Nation, which is the largest Nation within the interior of BC.  The Xat'súll have stewarded territory ranging from the Coast Mountains to the west, east to the Rocky Mountains."[[quoted from http://www.xatsull.com/Community/History/tabid/71/Default.aspx]]\n\n"The Xat'súll First Nation is a member of the Great Secwepemc Nation, once known as the people of Xat'súll (on the cliff where the bubbling water comes out). Xat'súll (Hat'sull) is the northern most Shuswap tribe of the Secwepemc Nation, which is the largest Nation within the interior of BC.  The Xat'súll have stewarded territory ranging from the Coast Mountains to the west, east to the Rocky Mountains."[[quoted from http://www.xatsull.com/Community/History/tabid/71/Default.aspx]]\n\n"The Xat'súll First Nation is a member of the Great Secwepemc Nation, once known as the people of Xat'súll (on the cliff where the bubbling water comes out). Xat'súll (Hat'sull) is the northern most Shuswap tribe of the Secwepemc Nation, which is the largest Nation within the interior of BC.  The Xat'súll have stewarded territory ranging from the Coast Mountains to the west, east to the Rocky Mountains."[[quoted from http://www.xatsull.com/Community/History/tabid/71/Default.aspx]]\n\n"The Xat'súll First Nation is a member of the Great Secwepemc Nation, once known as the people of Xat'súll (on the cliff where the bubbling water comes out). Xat'súll (Hat'sull) is the northern most Shuswap tribe of the Secwepemc Nation, which is the largest Nation within the interior of BC.  The Xat'súll have stewarded territory ranging from the Coast Mountains to the west, east to the Rocky Mountains."[[quoted from http://www.xatsull.com/Community/History/tabid/71/Default.aspx]]\n\n"The Xat'súll First Nation is a member of the Great Secwepemc Nation, once known as the people of Xat'súll (on the cliff where the bubbling water comes out). Xat'súll (Hat'sull) is the northern most Shuswap tribe of the Secwepemc Nation, which is the largest Nation within the interior of BC.  The Xat'súll have stewarded territory ranging from the Coast Mountains to the west, east to the Rocky Mountains."[[quoted from http://www.xatsull.com/Community/History/tabid/71/Default.aspx]]	
246	Gitxaala Nation	0101000020E610000030A017EEDC4D60C0BDA94885B1E54A40	0	\N				(250) 848-2214	(250) 848-2238	Kitkatla Band		\n\n"The Gitxaala Nation is a First Nations government located at Kitkatla, British Columbia, Canada in the province's North Coast region. It is one of the longest continually inhabited communities in all of "Turtle Island" which is a reference to all of North America. The ancestry of the people living here dates back to 10,000 years! It is a beautiful and peaceful community that values and respects the ideal location and resources on which the people and animals have lived for centuries."[[Text copied from http://gitxaalanation.com]]\n\n"The Gitxaala Nation is a First Nations government located at Kitkatla, British Columbia, Canada in the province's North Coast region. It is one of the longest continually inhabited communities in all of "Turtle Island" which is a reference to all of North America. The ancestry of the people living here dates back to 10,000 years! It is a beautiful and peaceful community that values and respects the ideal location and resources on which the people and animals have lived for centuries."[[Text copied from http://gitxaalanation.com]]\n\n"The Gitxaala Nation is a First Nations government located at Kitkatla, British Columbia, Canada in the province's North Coast region. It is one of the longest continually inhabited communities in all of "Turtle Island" which is a reference to all of North America. The ancestry of the people living here dates back to 10,000 years! It is a beautiful and peaceful community that values and respects the ideal location and resources on which the people and animals have lived for centuries."[[Text copied from http://gitxaalanation.com]]\n\n"The Gitxaala Nation is a First Nations government located at Kitkatla, British Columbia, Canada in the province's North Coast region. It is one of the longest continually inhabited communities in all of "Turtle Island" which is a reference to all of North America. The ancestry of the people living here dates back to 10,000 years! It is a beautiful and peaceful community that values and respects the ideal location and resources on which the people and animals have lived for centuries."[[Text copied from http://gitxaalanation.com]]\n\n"The Gitxaala Nation is a First Nations government located at Kitkatla, British Columbia, Canada in the province's North Coast region. It is one of the longest continually inhabited communities in all of "Turtle Island" which is a reference to all of North America. The ancestry of the people living here dates back to 10,000 years! It is a beautiful and peaceful community that values and respects the ideal location and resources on which the people and animals have lived for centuries."[[Text copied from http://gitxaalanation.com]]\n\n"The Gitxaala Nation is a First Nations government located at Kitkatla, British Columbia, Canada in the province's North Coast region. It is one of the longest continually inhabited communities in all of "Turtle Island" which is a reference to all of North America. The ancestry of the people living here dates back to 10,000 years! It is a beautiful and peaceful community that values and respects the ideal location and resources on which the people and animals have lived for centuries."[[Text copied from http://gitxaalanation.com]]	
283	Lheidli T'enneh Band	0101000020E6100000DD06B5DFDAA75EC01616DC0F78004B40	320	lheidli@shaw.ca			Dial-in[[93]]	(250) 963-8451	(250) 963-6954		1-877-963-8451	\n\nWe are Lheidli T’enneh – the people from the confluence of two rivers. Our main community is at confluence of the Fraser and Nechako Rivers, 16 km northeast of Prince George. Our community is on Fort George (Shelley) Indian Reserve #2, which is split by the Fraser River and referred to as North Shelley and South Shelley, 16 km northeast of Prince George.\n\nWe are Lheidli T’enneh – the people from the confluence of two rivers. Our main community is at confluence of the Fraser and Nechako Rivers, 16 km northeast of Prince George. Our community is on Fort George (Shelley) Indian Reserve #2, which is split by the Fraser River and referred to as North Shelley and South Shelley, 16 km northeast of Prince George.\n\nWe are Lheidli T’enneh – the people from the confluence of two rivers. Our main community is at confluence of the Fraser and Nechako Rivers, 16 km northeast of Prince George. Our community is on Fort George (Shelley) Indian Reserve #2, which is split by the Fraser River and referred to as North Shelley and South Shelley, 16 km northeast of Prince George.\n\nWe are Lheidli T’enneh – the people from the confluence of two rivers. Our main community is at confluence of the Fraser and Nechako Rivers, 16 km northeast of Prince George. Our community is on Fort George (Shelley) Indian Reserve #2, which is split by the Fraser River and referred to as North Shelley and South Shelley, 16 km northeast of Prince George.\n\nWe are Lheidli T’enneh – the people from the confluence of two rivers. Our main community is at confluence of the Fraser and Nechako Rivers, 16 km northeast of Prince George. Our community is on Fort George (Shelley) Indian Reserve #2, which is split by the Fraser River and referred to as North Shelley and South Shelley, 16 km northeast of Prince George.\n\nWe are Lheidli T’enneh – the people from the confluence of two rivers. Our main community is at confluence of the Fraser and Nechako Rivers, 16 km northeast of Prince George. Our community is on Fort George (Shelley) Indian Reserve #2, which is split by the Fraser River and referred to as North Shelley and South Shelley, 16 km northeast of Prince George.	
311	N'Quatqua	0101000020E610000010E7E104A69E5EC03198BF42E6464940	0	\N	\N			(604) 452-3221	(604) 452-3295	N'Quatqua First Nations,N'quatqua First Nation,Nequatque First Nation,Anderson Lake Indian Band	1-800-933-0323	\n\nN’Quatqua is located in the southern Coast Mountains at the community of D'Arcy where the British Columbia Railway meets the head of Anderson Lake and about midway between the towns of Pemberton and Lillooet.\n\nN’Quatqua is located in the southern Coast Mountains at the community of D'Arcy where the British Columbia Railway meets the head of Anderson Lake and about midway between the towns of Pemberton and Lillooet.\n\nN’Quatqua is located in the southern Coast Mountains at the community of D'Arcy where the British Columbia Railway meets the head of Anderson Lake and about midway between the towns of Pemberton and Lillooet.\n\nN’Quatqua is located in the southern Coast Mountains at the community of D'Arcy where the British Columbia Railway meets the head of Anderson Lake and about midway between the towns of Pemberton and Lillooet.\n\nN’Quatqua is located in the southern Coast Mountains at the community of D'Arcy where the British Columbia Railway meets the head of Anderson Lake and about midway between the towns of Pemberton and Lillooet.\n\nN’Quatqua is located in the southern Coast Mountains at the community of D'Arcy where the British Columbia Railway meets the head of Anderson Lake and about midway between the towns of Pemberton and Lillooet.	
298	Mowachaht / Muchalaht	0101000020E610000063B48EAA26835FC0B0592E1B9DE34840	540	\N	http://www.yuquot.ca		Dial-in[[93]]	(250) 283-2015	(250) 283-2335	Nootka Band (Mowachaht),Mowachaht	1-800-238-2933	\n\nThe Mowachaht/Muchalaht First Nations is the union of the Mowachaht and Muchalaht First Nations who joined to form one group in 1935[[133]]. The main community is now at Gold River but the largest Mowachaht village was formerly at Yuquot in Nootka Sound (Friendly Cove).\n\nThe Mowachaht/Muchalaht First Nations is the union of the Mowachaht and Muchalaht First Nations who joined to form one group in 1935[[133]]. The main community is now at Gold River but the largest Mowachaht village was formerly at Yuquot in Nootka Sound (Friendly Cove).\n\nThe Mowachaht/Muchalaht First Nations is the union of the Mowachaht and Muchalaht First Nations who joined to form one group in 1935[[133]]. The main community is now at Gold River but the largest Mowachaht village was formerly at Yuquot in Nootka Sound (Friendly Cove).\n\nThe Mowachaht/Muchalaht First Nations is the union of the Mowachaht and Muchalaht First Nations who joined to form one group in 1935[[133]]. The main community is now at Gold River but the largest Mowachaht village was formerly at Yuquot in Nootka Sound (Friendly Cove).\n\nThe Mowachaht/Muchalaht First Nations is the union of the Mowachaht and Muchalaht First Nations who joined to form one group in 1935[[133]]. The main community is now at Gold River but the largest Mowachaht village was formerly at Yuquot in Nootka Sound (Friendly Cove).\n\nThe Mowachaht/Muchalaht First Nations is the union of the Mowachaht and Muchalaht First Nations who joined to form one group in 1935[[133]]. The main community is now at Gold River but the largest Mowachaht village was formerly at Yuquot in Nootka Sound (Friendly Cove).	
300	Nadleh Whut'en	0101000020E61000000457790261235FC074266DAAEE074B40	419	nwib1@uniserve.com	\N		Dial-in[[93]]	(250) 690-7211	(250) 690-7316	Fraser Lake Indian Band		\n\nThe Nadleh Whut'en are located in the Central Interior of British Columbia at the east end of Fraser Lake. Most of the 419 members reside in Nadleh, the main community, while others live in Lejac. Nadleh is located along the banks of the Nadleh River between Fraser Lake and the Nechako River. Lejac is located on the south side of Fraser Lake, on the site of the former Lejac Residential School.\r\n\r\n\r\n\r\nThe Nadleh Whut'en speak a dialect of the Dakelh (Carrier) Language which is part of the Athapaskan language family. Carrier people refer to themselves as Dakelh, which means "people who travel by water."\r\n\r\n\r\n\r\nNadleh refers to where the salmon return every year. Whut'en refers to where you come from.\r\n\r\n\r\n\r\nThe Clans of the Nadleh Whut'en Band are Ultseh yoo (frog), Dumdehm yoo (bear), Luk sil yoo (caribou), Ulstah mus yoo (owl, grouse), and Tsah yoo (beaver).[[Introductory text provided by the Nadleh Whut'en First Nation to FirstVoices for their community portal page]]\n\nThe Nadleh Whut'en are located in the Central Interior of British Columbia at the east end of Fraser Lake. Most of the 419 members reside in Nadleh, the main community, while others live in Lejac. Nadleh is located along the banks of the Nadleh River between Fraser Lake and the Nechako River. Lejac is located on the south side of Fraser Lake, on the site of the former Lejac Residential School.\r\n\r\n\r\n\r\nThe Nadleh Whut'en speak a dialect of the Dakelh (Carrier) Language which is part of the Athapaskan language family. Carrier people refer to themselves as Dakelh, which means "people who travel by water."\r\n\r\n\r\n\r\nNadleh refers to where the salmon return every year. Whut'en refers to where you come from.\r\n\r\n\r\n\r\nThe Clans of the Nadleh Whut'en Band are Ultseh yoo (frog), Dumdehm yoo (bear), Luk sil yoo (caribou), Ulstah mus yoo (owl, grouse), and Tsah yoo (beaver).[[Introductory text provided by the Nadleh Whut'en First Nation to FirstVoices for their community portal page]]\n\nThe Nadleh Whut'en are located in the Central Interior of British Columbia at the east end of Fraser Lake. Most of the 419 members reside in Nadleh, the main community, while others live in Lejac. Nadleh is located along the banks of the Nadleh River between Fraser Lake and the Nechako River. Lejac is located on the south side of Fraser Lake, on the site of the former Lejac Residential School.\r\n\r\n\r\n\r\nThe Nadleh Whut'en speak a dialect of the Dakelh (Carrier) Language which is part of the Athapaskan language family. Carrier people refer to themselves as Dakelh, which means "people who travel by water."\r\n\r\n\r\n\r\nNadleh refers to where the salmon return every year. Whut'en refers to where you come from.\r\n\r\n\r\n\r\nThe Clans of the Nadleh Whut'en Band are Ultseh yoo (frog), Dumdehm yoo (bear), Luk sil yoo (caribou), Ulstah mus yoo (owl, grouse), and Tsah yoo (beaver).[[Introductory text provided by the Nadleh Whut'en First Nation to FirstVoices for their community portal page]]\n\nThe Nadleh Whut'en are located in the Central Interior of British Columbia at the east end of Fraser Lake. Most of the 419 members reside in Nadleh, the main community, while others live in Lejac. Nadleh is located along the banks of the Nadleh River between Fraser Lake and the Nechako River. Lejac is located on the south side of Fraser Lake, on the site of the former Lejac Residential School.\r\n\r\n\r\n\r\nThe Nadleh Whut'en speak a dialect of the Dakelh (Carrier) Language which is part of the Athapaskan language family. Carrier people refer to themselves as Dakelh, which means "people who travel by water."\r\n\r\n\r\n\r\nNadleh refers to where the salmon return every year. Whut'en refers to where you come from.\r\n\r\n\r\n\r\nThe Clans of the Nadleh Whut'en Band are Ultseh yoo (frog), Dumdehm yoo (bear), Luk sil yoo (caribou), Ulstah mus yoo (owl, grouse), and Tsah yoo (beaver).[[Introductory text provided by the Nadleh Whut'en First Nation to FirstVoices for their community portal page]]\n\nThe Nadleh Whut'en are located in the Central Interior of British Columbia at the east end of Fraser Lake. Most of the 419 members reside in Nadleh, the main community, while others live in Lejac. Nadleh is located along the banks of the Nadleh River between Fraser Lake and the Nechako River. Lejac is located on the south side of Fraser Lake, on the site of the former Lejac Residential School.\r\n\r\n\r\n\r\nThe Nadleh Whut'en speak a dialect of the Dakelh (Carrier) Language which is part of the Athapaskan language family. Carrier people refer to themselves as Dakelh, which means "people who travel by water."\r\n\r\n\r\n\r\nNadleh refers to where the salmon return every year. Whut'en refers to where you come from.\r\n\r\n\r\n\r\nThe Clans of the Nadleh Whut'en Band are Ultseh yoo (frog), Dumdehm yoo (bear), Luk sil yoo (caribou), Ulstah mus yoo (owl, grouse), and Tsah yoo (beaver).[[Introductory text provided by the Nadleh Whut'en First Nation to FirstVoices for their community portal page]]\n\nThe Nadleh Whut'en are located in the Central Interior of British Columbia at the east end of Fraser Lake. Most of the 419 members reside in Nadleh, the main community, while others live in Lejac. Nadleh is located along the banks of the Nadleh River between Fraser Lake and the Nechako River. Lejac is located on the south side of Fraser Lake, on the site of the former Lejac Residential School.\r\n\r\n\r\n\r\nThe Nadleh Whut'en speak a dialect of the Dakelh (Carrier) Language which is part of the Athapaskan language family. Carrier people refer to themselves as Dakelh, which means "people who travel by water."\r\n\r\n\r\n\r\nNadleh refers to where the salmon return every year. Whut'en refers to where you come from.\r\n\r\n\r\n\r\nThe Clans of the Nadleh Whut'en Band are Ultseh yoo (frog), Dumdehm yoo (bear), Luk sil yoo (caribou), Ulstah mus yoo (owl, grouse), and Tsah yoo (beaver).[[Introductory text provided by the Nadleh Whut'en First Nation to FirstVoices for their community portal page]]	
315	Old Masset Village Council	0101000020E610000000000000008460C0A9DDAF027C034B40	0	omvcadmin@mhtv.ca	\N			(250) 626-3337	(250) 626-5440	Old Massett Band, 	1-888-378-4422	\n\nThe village of Old Massett is on the northern shore of Graham Island, the largest and most northern island of X̱AAYDAG̱A GWAAY.YAAY (Queen Charlotte Islands). Old Massett was historically four seperate villages: aaw, iijaaw, jagwaal, and ḵ’yang.\r\n\r\n<br />\r\n\r\nListen to Nonnie Mary explain the historic village locations to Leona Clow:\n\nThe village of Old Massett is on the northern shore of Graham Island, the largest and most northern island of X̱AAYDAG̱A GWAAY.YAAY (Queen Charlotte Islands). Old Massett was historically four seperate villages: aaw, iijaaw, jagwaal, and ḵ’yang.\r\n\r\n<br />\r\n\r\nListen to Nonnie Mary explain the historic village locations to Leona Clow:\n\nThe village of Old Massett is on the northern shore of Graham Island, the largest and most northern island of X̱AAYDAG̱A GWAAY.YAAY (Queen Charlotte Islands). Old Massett was historically four seperate villages: aaw, iijaaw, jagwaal, and ḵ’yang.\r\n\r\n<br />\r\n\r\nListen to Nonnie Mary explain the historic village locations to Leona Clow:\n\nThe village of Old Massett is on the northern shore of Graham Island, the largest and most northern island of X̱AAYDAG̱A GWAAY.YAAY (Queen Charlotte Islands). Old Massett was historically four seperate villages: aaw, iijaaw, jagwaal, and ḵ’yang.\r\n\r\n<br />\r\n\r\nListen to Nonnie Mary explain the historic village locations to Leona Clow:\n\nThe village of Old Massett is on the northern shore of Graham Island, the largest and most northern island of X̱AAYDAG̱A GWAAY.YAAY (Queen Charlotte Islands). Old Massett was historically four seperate villages: aaw, iijaaw, jagwaal, and ḵ’yang.\r\n\r\n<br />\r\n\r\nListen to Nonnie Mary explain the historic village locations to Leona Clow:\n\nThe village of Old Massett is on the northern shore of Graham Island, the largest and most northern island of X̱AAYDAG̱A GWAAY.YAAY (Queen Charlotte Islands). Old Massett was historically four seperate villages: aaw, iijaaw, jagwaal, and ḵ’yang.\r\n\r\n<br />\r\n\r\nListen to Nonnie Mary explain the historic village locations to Leona Clow:	
220	Canoe Creek	0101000020E61000005C1E6B46068F5EC08E93C2BCC7D14940	695	canoecreek@midbc.com	\N			(250) 440-5645	(250) 440-5679	Canoe Creek Band		\n\n"Canoe Creek Band is made up of two communities, Dog Creek that is where the administration office is located and Canoe Creek. Both communities are located in a semi remote area southwest of Williams Lake on the east side of the Fraser River. The infamous Gang Ranch is located directly across the river from Canoe Creek IR #3. "[[quoted from http://www.nstq.org/Photo_Pages/nstc/Cariboo_Tribal_Council/Canoe_index.htm]]\n\n"Canoe Creek Band is made up of two communities, Dog Creek that is where the administration office is located and Canoe Creek. Both communities are located in a semi remote area southwest of Williams Lake on the east side of the Fraser River. The infamous Gang Ranch is located directly across the river from Canoe Creek IR #3. "[[quoted from http://www.nstq.org/Photo_Pages/nstc/Cariboo_Tribal_Council/Canoe_index.htm]]\n\n"Canoe Creek Band is made up of two communities, Dog Creek that is where the administration office is located and Canoe Creek. Both communities are located in a semi remote area southwest of Williams Lake on the east side of the Fraser River. The infamous Gang Ranch is located directly across the river from Canoe Creek IR #3. "[[quoted from http://www.nstq.org/Photo_Pages/nstc/Cariboo_Tribal_Council/Canoe_index.htm]]\n\n"Canoe Creek Band is made up of two communities, Dog Creek that is where the administration office is located and Canoe Creek. Both communities are located in a semi remote area southwest of Williams Lake on the east side of the Fraser River. The infamous Gang Ranch is located directly across the river from Canoe Creek IR #3. "[[quoted from http://www.nstq.org/Photo_Pages/nstc/Cariboo_Tribal_Council/Canoe_index.htm]]\n\n"Canoe Creek Band is made up of two communities, Dog Creek that is where the administration office is located and Canoe Creek. Both communities are located in a semi remote area southwest of Williams Lake on the east side of the Fraser River. The infamous Gang Ranch is located directly across the river from Canoe Creek IR #3. "[[quoted from http://www.nstq.org/Photo_Pages/nstc/Cariboo_Tribal_Council/Canoe_index.htm]]\n\n"Canoe Creek Band is made up of two communities, Dog Creek that is where the administration office is located and Canoe Creek. Both communities are located in a semi remote area southwest of Williams Lake on the east side of the Fraser River. The infamous Gang Ranch is located directly across the river from Canoe Creek IR #3. "[[quoted from http://www.nstq.org/Photo_Pages/nstc/Cariboo_Tribal_Council/Canoe_index.htm]]	
229	K'ómoks First Nation	0101000020E610000061C614AC713F5FC0FA0CA837A3D84840	273	\N				(250) 339-4545	(250) 339-7053	Comox First Nation,Komox Nation		\n\n"The people called K'ómoks today referred to themselves as Sathloot, Sasitla, Ieeksun, Puntledge, Cha'chae, and Tat'poos. They occupied sites in Kelsey Bay, Quinsum, Campbell River, Quadra Island, Kye Bay, and along the Puntledge estuary. As a cultural collective they called themselves, "Sathloot", according to the late Mary Clifton."[[source: http://www.comoxband.ca/index.php]]\n\n"The people called K'ómoks today referred to themselves as Sathloot, Sasitla, Ieeksun, Puntledge, Cha'chae, and Tat'poos. They occupied sites in Kelsey Bay, Quinsum, Campbell River, Quadra Island, Kye Bay, and along the Puntledge estuary. As a cultural collective they called themselves, "Sathloot", according to the late Mary Clifton."[[source: http://www.comoxband.ca/index.php]]\n\n"The people called K'ómoks today referred to themselves as Sathloot, Sasitla, Ieeksun, Puntledge, Cha'chae, and Tat'poos. They occupied sites in Kelsey Bay, Quinsum, Campbell River, Quadra Island, Kye Bay, and along the Puntledge estuary. As a cultural collective they called themselves, "Sathloot", according to the late Mary Clifton."[[source: http://www.comoxband.ca/index.php]]\n\n"The people called K'ómoks today referred to themselves as Sathloot, Sasitla, Ieeksun, Puntledge, Cha'chae, and Tat'poos. They occupied sites in Kelsey Bay, Quinsum, Campbell River, Quadra Island, Kye Bay, and along the Puntledge estuary. As a cultural collective they called themselves, "Sathloot", according to the late Mary Clifton."[[source: http://www.comoxband.ca/index.php]]\n\n"The people called K'ómoks today referred to themselves as Sathloot, Sasitla, Ieeksun, Puntledge, Cha'chae, and Tat'poos. They occupied sites in Kelsey Bay, Quinsum, Campbell River, Quadra Island, Kye Bay, and along the Puntledge estuary. As a cultural collective they called themselves, "Sathloot", according to the late Mary Clifton."[[source: http://www.comoxband.ca/index.php]]\n\n"The people called K'ómoks today referred to themselves as Sathloot, Sasitla, Ieeksun, Puntledge, Cha'chae, and Tat'poos. They occupied sites in Kelsey Bay, Quinsum, Campbell River, Quadra Island, Kye Bay, and along the Puntledge estuary. As a cultural collective they called themselves, "Sathloot", according to the late Mary Clifton."[[source: http://www.comoxband.ca/index.php]]	
230	Cook's Ferry	0101000020E61000002F52280B5F5E5EC011A62897C6374940	296	cfiband@netscape.net	\N		Dial-in[[93]]	(250) 458-2224	(250) 458-2312	Cook's Ferry Indian Band		\n\nThe Cook's Ferry Indian Band main community is on Kumcheon Indian Reserve #1 on the left bank of the Thompson River at the mouth of the Nicola River near Spences Bridge.\n\nThe Cook's Ferry Indian Band main community is on Kumcheon Indian Reserve #1 on the left bank of the Thompson River at the mouth of the Nicola River near Spences Bridge.\n\nThe Cook's Ferry Indian Band main community is on Kumcheon Indian Reserve #1 on the left bank of the Thompson River at the mouth of the Nicola River near Spences Bridge.\n\nThe Cook's Ferry Indian Band main community is on Kumcheon Indian Reserve #1 on the left bank of the Thompson River at the mouth of the Nicola River near Spences Bridge.\n\nThe Cook's Ferry Indian Band main community is on Kumcheon Indian Reserve #1 on the left bank of the Thompson River at the mouth of the Nicola River near Spences Bridge.\n\nThe Cook's Ferry Indian Band main community is on Kumcheon Indian Reserve #1 on the left bank of the Thompson River at the mouth of the Nicola River near Spences Bridge.	
267	Kitasoo/Xaixais Nation	0101000020E6100000776682E1DC1060C0334FAE29904B4A40	508	\N	http://www.kitasoo.org			(250) 839-1255	(250) 839-1256	Kitasoo Band Council,Kitasoo Indian Band		\n\n"Klemtu is a small village on Swindle Island, situated on the province's spectacularly beautiful central coast. Two distinct tribal organizations live here: the Kitasoo who were originally from Kitasu Bay and the Xai'xais of Kynoc Inlet. The Kitasoo/Xai'xais people are the only permanent residents within the traditional territories of the First Nation."[[Text copied from http://www.kitasoo.org]]\n\n"Klemtu is a small village on Swindle Island, situated on the province's spectacularly beautiful central coast. Two distinct tribal organizations live here: the Kitasoo who were originally from Kitasu Bay and the Xai'xais of Kynoc Inlet. The Kitasoo/Xai'xais people are the only permanent residents within the traditional territories of the First Nation."[[Text copied from http://www.kitasoo.org]]\n\n"Klemtu is a small village on Swindle Island, situated on the province's spectacularly beautiful central coast. Two distinct tribal organizations live here: the Kitasoo who were originally from Kitasu Bay and the Xai'xais of Kynoc Inlet. The Kitasoo/Xai'xais people are the only permanent residents within the traditional territories of the First Nation."[[Text copied from http://www.kitasoo.org]]\n\n"Klemtu is a small village on Swindle Island, situated on the province's spectacularly beautiful central coast. Two distinct tribal organizations live here: the Kitasoo who were originally from Kitasu Bay and the Xai'xais of Kynoc Inlet. The Kitasoo/Xai'xais people are the only permanent residents within the traditional territories of the First Nation."[[Text copied from http://www.kitasoo.org]]\n\n"Klemtu is a small village on Swindle Island, situated on the province's spectacularly beautiful central coast. Two distinct tribal organizations live here: the Kitasoo who were originally from Kitasu Bay and the Xai'xais of Kynoc Inlet. The Kitasoo/Xai'xais people are the only permanent residents within the traditional territories of the First Nation."[[Text copied from http://www.kitasoo.org]]\n\n"Klemtu is a small village on Swindle Island, situated on the province's spectacularly beautiful central coast. Two distinct tribal organizations live here: the Kitasoo who were originally from Kitasu Bay and the Xai'xais of Kynoc Inlet. The Kitasoo/Xai'xais people are the only permanent residents within the traditional territories of the First Nation."[[Text copied from http://www.kitasoo.org]]	
297	Lil'wat Nation	0101000020E6100000E41071732AAE5EC0AB75E272BC284940	0	\N	http://www.lilwatnation.com			(604) 894-6115	(604) 894-6841	Mount Currie Band,Lil’wat7ul		\n\nThe Lil'wat Nation's main community is at Mount Currie about 5km from Pemberton and 30km northeast of Whistler. This community is near the confluence of the Lillooet and Birkenhead rivers, about 70km southwest of Lillooet.\n\nThe Lil'wat Nation's main community is at Mount Currie about 5km from Pemberton and 30km northeast of Whistler. This community is near the confluence of the Lillooet and Birkenhead rivers, about 70km southwest of Lillooet.\n\nThe Lil'wat Nation's main community is at Mount Currie about 5km from Pemberton and 30km northeast of Whistler. This community is near the confluence of the Lillooet and Birkenhead rivers, about 70km southwest of Lillooet.\n\nThe Lil'wat Nation's main community is at Mount Currie about 5km from Pemberton and 30km northeast of Whistler. This community is near the confluence of the Lillooet and Birkenhead rivers, about 70km southwest of Lillooet.\n\nThe Lil'wat Nation's main community is at Mount Currie about 5km from Pemberton and 30km northeast of Whistler. This community is near the confluence of the Lillooet and Birkenhead rivers, about 70km southwest of Lillooet.\n\nThe Lil'wat Nation's main community is at Mount Currie about 5km from Pemberton and 30km northeast of Whistler. This community is near the confluence of the Lillooet and Birkenhead rivers, about 70km southwest of Lillooet.	
373	Ławitʼsis (Tlowitsis)	0101000020E61000009FCA694FC94F5FC0438CD7BCAAF94840	371	tlowi@island.net				(250) 830-1708	(250) 830-1709	Tlowitsis Tribe,Lawitsis		\n\nThe Ławitʼsis (Tlowitsis) Nation "...territories span the coastal area of Northern Vancouver Island, British Columbia from ancient history until the early 1960s. They occupied several village sites scattered across islands along Johnson Straight. Seasonal travel routes, food processing spots, burial and cultural sites and other named places extended across the entire territory. Qalagwis, now known as Turner Island, was their primary winter residence"[[copied from: http://tlowitsis.com/]].\r\r\n\r\r\n\r\r\nIn the 1960s, the British Columbia government closed down the monthly hospital ship and school on Qalagwis. With little prospect of schooling and access to health care, the Tlowitsis community left the island. In the ensuing diaspora, community members have become culturally, as well as physically, removed from their traditional territories. The Tlowitsis Nation (now administered out of offices on Vancouver Island) sits at the extreme edge of a continuum of settlement patterns of contemporary First Nations, with high levels of dislocation and dispersal"[[copied from: http://tlowitsis.com/]].\n\nThe Ławitʼsis (Tlowitsis) Nation "...territories span the coastal area of Northern Vancouver Island, British Columbia from ancient history until the early 1960s. They occupied several village sites scattered across islands along Johnson Straight. Seasonal travel routes, food processing spots, burial and cultural sites and other named places extended across the entire territory. Qalagwis, now known as Turner Island, was their primary winter residence"[[copied from: http://tlowitsis.com/]].\r\r\n\r\r\n\r\r\nIn the 1960s, the British Columbia government closed down the monthly hospital ship and school on Qalagwis. With little prospect of schooling and access to health care, the Tlowitsis community left the island. In the ensuing diaspora, community members have become culturally, as well as physically, removed from their traditional territories. The Tlowitsis Nation (now administered out of offices on Vancouver Island) sits at the extreme edge of a continuum of settlement patterns of contemporary First Nations, with high levels of dislocation and dispersal"[[copied from: http://tlowitsis.com/]].\n\nThe Ławitʼsis (Tlowitsis) Nation "...territories span the coastal area of Northern Vancouver Island, British Columbia from ancient history until the early 1960s. They occupied several village sites scattered across islands along Johnson Straight. Seasonal travel routes, food processing spots, burial and cultural sites and other named places extended across the entire territory. Qalagwis, now known as Turner Island, was their primary winter residence"[[copied from: http://tlowitsis.com/]].\r\r\n\r\r\n\r\r\nIn the 1960s, the British Columbia government closed down the monthly hospital ship and school on Qalagwis. With little prospect of schooling and access to health care, the Tlowitsis community left the island. In the ensuing diaspora, community members have become culturally, as well as physically, removed from their traditional territories. The Tlowitsis Nation (now administered out of offices on Vancouver Island) sits at the extreme edge of a continuum of settlement patterns of contemporary First Nations, with high levels of dislocation and dispersal"[[copied from: http://tlowitsis.com/]].\n\nThe Ławitʼsis (Tlowitsis) Nation "...territories span the coastal area of Northern Vancouver Island, British Columbia from ancient history until the early 1960s. They occupied several village sites scattered across islands along Johnson Straight. Seasonal travel routes, food processing spots, burial and cultural sites and other named places extended across the entire territory. Qalagwis, now known as Turner Island, was their primary winter residence"[[copied from: http://tlowitsis.com/]].\r\r\n\r\r\n\r\r\nIn the 1960s, the British Columbia government closed down the monthly hospital ship and school on Qalagwis. With little prospect of schooling and access to health care, the Tlowitsis community left the island. In the ensuing diaspora, community members have become culturally, as well as physically, removed from their traditional territories. The Tlowitsis Nation (now administered out of offices on Vancouver Island) sits at the extreme edge of a continuum of settlement patterns of contemporary First Nations, with high levels of dislocation and dispersal"[[copied from: http://tlowitsis.com/]].\n\nThe Ławitʼsis (Tlowitsis) Nation "...territories span the coastal area of Northern Vancouver Island, British Columbia from ancient history until the early 1960s. They occupied several village sites scattered across islands along Johnson Straight. Seasonal travel routes, food processing spots, burial and cultural sites and other named places extended across the entire territory. Qalagwis, now known as Turner Island, was their primary winter residence"[[copied from: http://tlowitsis.com/]].\r\r\n\r\r\n\r\r\nIn the 1960s, the British Columbia government closed down the monthly hospital ship and school on Qalagwis. With little prospect of schooling and access to health care, the Tlowitsis community left the island. In the ensuing diaspora, community members have become culturally, as well as physically, removed from their traditional territories. The Tlowitsis Nation (now administered out of offices on Vancouver Island) sits at the extreme edge of a continuum of settlement patterns of contemporary First Nations, with high levels of dislocation and dispersal"[[copied from: http://tlowitsis.com/]].\n\nThe Ławitʼsis (Tlowitsis) Nation "...territories span the coastal area of Northern Vancouver Island, British Columbia from ancient history until the early 1960s. They occupied several village sites scattered across islands along Johnson Straight. Seasonal travel routes, food processing spots, burial and cultural sites and other named places extended across the entire territory. Qalagwis, now known as Turner Island, was their primary winter residence"[[copied from: http://tlowitsis.com/]].\r\r\n\r\r\n\r\r\nIn the 1960s, the British Columbia government closed down the monthly hospital ship and school on Qalagwis. With little prospect of schooling and access to health care, the Tlowitsis community left the island. In the ensuing diaspora, community members have become culturally, as well as physically, removed from their traditional territories. The Tlowitsis Nation (now administered out of offices on Vancouver Island) sits at the extreme edge of a continuum of settlement patterns of contemporary First Nations, with high levels of dislocation and dispersal"[[copied from: http://tlowitsis.com/]].	
387	Uchucklesaht Tribe	0101000020E6100000B64DF1B8A8475FC0DEE7F86871664840	195	uchuklst@shaw.ca			High-Speed[[93]]	(250) 724-1832	(250) 724-1806	Uchucklesit		\n\nThe Uchucklesaht Tribe has two reserves that are situated approximately 24 miles down the Barkley Sound, southwest from Port Alberni. The first reserve is immediately past the Uchucklesaht Inlet on the West side of Barkley Sound, named “Cowishulth”. The second reserve is located at the head of Uchucklesaht Inlet and is named “Hilthatis”.[[copied from Maan-nulth website: http://www.maanulth.ca/about_fn_uchucklesaht.asp]]\n\nThe Uchucklesaht Tribe has two reserves that are situated approximately 24 miles down the Barkley Sound, southwest from Port Alberni. The first reserve is immediately past the Uchucklesaht Inlet on the West side of Barkley Sound, named “Cowishulth”. The second reserve is located at the head of Uchucklesaht Inlet and is named “Hilthatis”.[[copied from Maan-nulth website: http://www.maanulth.ca/about_fn_uchucklesaht.asp]]\n\nThe Uchucklesaht Tribe has two reserves that are situated approximately 24 miles down the Barkley Sound, southwest from Port Alberni. The first reserve is immediately past the Uchucklesaht Inlet on the West side of Barkley Sound, named “Cowishulth”. The second reserve is located at the head of Uchucklesaht Inlet and is named “Hilthatis”.[[copied from Maan-nulth website: http://www.maanulth.ca/about_fn_uchucklesaht.asp]]\n\nThe Uchucklesaht Tribe has two reserves that are situated approximately 24 miles down the Barkley Sound, southwest from Port Alberni. The first reserve is immediately past the Uchucklesaht Inlet on the West side of Barkley Sound, named “Cowishulth”. The second reserve is located at the head of Uchucklesaht Inlet and is named “Hilthatis”.[[copied from Maan-nulth website: http://www.maanulth.ca/about_fn_uchucklesaht.asp]]\n\nThe Uchucklesaht Tribe has two reserves that are situated approximately 24 miles down the Barkley Sound, southwest from Port Alberni. The first reserve is immediately past the Uchucklesaht Inlet on the West side of Barkley Sound, named “Cowishulth”. The second reserve is located at the head of Uchucklesaht Inlet and is named “Hilthatis”.[[copied from Maan-nulth website: http://www.maanulth.ca/about_fn_uchucklesaht.asp]]\n\nThe Uchucklesaht Tribe has two reserves that are situated approximately 24 miles down the Barkley Sound, southwest from Port Alberni. The first reserve is immediately past the Uchucklesaht Inlet on the West side of Barkley Sound, named “Cowishulth”. The second reserve is located at the head of Uchucklesaht Inlet and is named “Hilthatis”.[[copied from Maan-nulth website: http://www.maanulth.ca/about_fn_uchucklesaht.asp]]	
303	Nazko First Nation	0101000020E6100000C18D942D929F5EC0062E8F35237D4A40	334	admin@nazkoband.ca			High-Speed[[93]]	(250) 992-9085	(250) 992-7982	Nazko Indian Band		\n\nThe main community of the Nazko First Nation is approximately 120 km west of Quesnel on the Nazko River. Nazko means, "river flowing from the south". Nazko is the Gateway to the Nuxalk Carrier Grease-Alexander Mackenzie Heritage Trail. The Nazko area is well known for its Ranching history.\n\nThe main community of the Nazko First Nation is approximately 120 km west of Quesnel on the Nazko River. Nazko means, "river flowing from the south". Nazko is the Gateway to the Nuxalk Carrier Grease-Alexander Mackenzie Heritage Trail. The Nazko area is well known for its Ranching history.\n\nThe main community of the Nazko First Nation is approximately 120 km west of Quesnel on the Nazko River. Nazko means, "river flowing from the south". Nazko is the Gateway to the Nuxalk Carrier Grease-Alexander Mackenzie Heritage Trail. The Nazko area is well known for its Ranching history.\n\nThe main community of the Nazko First Nation is approximately 120 km west of Quesnel on the Nazko River. Nazko means, "river flowing from the south". Nazko is the Gateway to the Nuxalk Carrier Grease-Alexander Mackenzie Heritage Trail. The Nazko area is well known for its Ranching history.\n\nThe main community of the Nazko First Nation is approximately 120 km west of Quesnel on the Nazko River. Nazko means, "river flowing from the south". Nazko is the Gateway to the Nuxalk Carrier Grease-Alexander Mackenzie Heritage Trail. The Nazko area is well known for its Ranching history.\n\nThe main community of the Nazko First Nation is approximately 120 km west of Quesnel on the Nazko River. Nazko means, "river flowing from the south". Nazko is the Gateway to the Nuxalk Carrier Grease-Alexander Mackenzie Heritage Trail. The Nazko area is well known for its Ranching history.	
309	New Aiyansh Village	0101000020E61000007689EAAD812260C0DF15C1FF569A4B40	1762	na_reception@nisgaa.net				(250) 633-3100	(250) 633-2271	Gitlaxt’aamiks,Gitlakdamiks,Gitlardamiks,Kitlakdamix	1-877-588-2388	Gitlaxt’aamiks was a large and ancient village on the north bank of the Nass River on the edge of the historic Grease Trail. In 1883, a missionary established a Christian village about six kilometers downriver. There, Nisga’a craftsmen built a large village complete with Victorian style houses, a church, community hall, school, sawmill, and its own printing press. They called this new village Aiyansh (Fertile Valley). After a series of floods, the people of Aiyansh finally moved to higher ground on the other side of the river and established New Aiyansh. It was here, after seeking a settlement for 113 years, Nisga’a negotiators signed British Columbia’s first modern treaty, the Nisga’a Final Agreement.\r\r\n\r\r\n<b>A Remarkable Destination</b>\r\r\nNew Aiyansh offers an ideal launching point for discovery of Nisga’a Lands and culture. In 1977, the “Unity Pole” was raised here—the first new pts’aan (totem pole) in the Nass Valley in a century. It signaled a rebirth of Nisga’a art, culture, and language, as well as a renewed commitment to securing a fair and equitable treaty. Today, the Nisga’a Final Agreement is secure and signs of renewal reverberate throughout the Nisga’a Lands.\r\r\n\r\r\nNew Aiyansh is situated on the edge of Anhluut’ukwsim Laxmihl Angwinga’asanskwhl (Nisga’a Memorial Lava Bed Park), the site of Canada’s last volcanic eruption. Sport fishing, back country recreation, and cultural tours are available (in season). Visitors from around the world come to experience Wilp Si’ayuukhl Nisga’a, the legislative assembly of Nisga’a Lisims Government.\r\r\n\r\r\nLocal stores serve the community and Bed & Breakfast accommodation is available in New Aiyansh and other Nisga’a villages. Nisga’a Highway 113 paves the way for ease of access to New Aiyansh and the rest of the Nass Valley[[All text in this section on "Community Information" was copied from the Nisg̱a’a Lisims Government website: http://www.nisgaalisims.ca/visiting_nisgaa_lands/new_aiyansh_capital_of_the_nisgaa_nation]]\n\nNew Aiyansh is the capital of the Nisg̱a’a Nation and one of four Nisg̱a’a communities. New Aiyansh is located 97 kilometres northwest of Terrace, British Columbia and is home to approximately 1,800 residents. New Aiyansh offers rich cultural history, natural beauty, and a central location for exploring Nisga’a Lands.	
329	Lhtako Dene Nation	0101000020E610000070CE88D2DE9C5EC036069D103A7A4A40	152	\N			High-Speed[[93]]	(250) 747-2900	(250) 747-1341	Red Bluff Band		\n\nThe main community of the Lhtako Dene Nation is on the Quesnel Indian Reserve #1 on the left bank of the Fraser River just outside of Quesnel.\n\nThe main community of the Lhtako Dene Nation is on the Quesnel Indian Reserve #1 on the left bank of the Fraser River just outside of Quesnel.\n\nThe main community of the Lhtako Dene Nation is on the Quesnel Indian Reserve #1 on the left bank of the Fraser River just outside of Quesnel.\n\nThe main community of the Lhtako Dene Nation is on the Quesnel Indian Reserve #1 on the left bank of the Fraser River just outside of Quesnel.\n\nThe main community of the Lhtako Dene Nation is on the Quesnel Indian Reserve #1 on the left bank of the Fraser River just outside of Quesnel.\n\nThe main community of the Lhtako Dene Nation is on the Quesnel Indian Reserve #1 on the left bank of the Fraser River just outside of Quesnel.	
344	Skatin Nations	0101000020E6100000D009A1832E9A5EC075C8CD7003F84840	0	skatin_nation@mycoast.net				(604) 894-2490	(604) 894-2491	Skatin Nations Council,Skookumchuck	1-877-894-2490	"One distinctive feature of the community of Skookumchuck is their famed Holy Cross Catholic Church, which stands in the centre of the community. The church was built by members of the Douglas, Skatin and Samahquam  Bands between 1895 and 1906... The community of Skatin also supports an elementary and junior high school (grades K-9), known as the Head of the Lake School, for the children of In-SHUCK-ch members, the majority of which are from Skatin and Tipella. Forty-four students currently attend this school."[[1363]]\n\n"The community of Skatin (or Skookumchuck) is located on the east side of the Lillooet River, on the 19-Mile Post of the old Harrison-Lillooet wagon road (about 35 kilometres from the head of Harrison Lake). Before the arrival of European settlers, this community was considered to be the largest on the lower Lillooet River, comparable in size to the pre-contact village of present-day Mount Currie (or Lilwat'ul). A moderately sized waterfall on the Lillooet River, about 1 kilometre north of the community, had a significant effect on the size of the community in prehistoric times as well as today. The fall is now commonly known as Skookumchuck Rapids, but the Ucwalmicw [oo-kwal-MEWK] (Lower Lillooet dialect) word for this fall is qmemps (k-MEMP-sh). This site was and remains to be a very abundant fishery, the most abundant on the Lillooet River. Colonial settlers and ethnographers have noted it in historic documents as early as the late 1850's."[[1363]]	
369	Tla-o-qui-aht First Nation	0101000020E6100000B1169F02607A5FC0A62897C62F964840	929	\N			High-Speed[[93]]	(250) 725-3233	(250) 725-4233	Clayoquot First Nation		\n\nThe Tla-o-qui-aht First Nation is a Nuu-chah-nulth Nation with territory along the west coast of Vancouver Island in Clayoquot Sound and much of the Pacific Rim National Park. There are communities both at their Opitsat Reserve noth of Tofino in Clayoquot Sound and at Esowista inside Pacific Rim Park.\n\nThe Tla-o-qui-aht First Nation is a Nuu-chah-nulth Nation with territory along the west coast of Vancouver Island in Clayoquot Sound and much of the Pacific Rim National Park. There are communities both at their Opitsat Reserve noth of Tofino in Clayoquot Sound and at Esowista inside Pacific Rim Park.\n\nThe Tla-o-qui-aht First Nation is a Nuu-chah-nulth Nation with territory along the west coast of Vancouver Island in Clayoquot Sound and much of the Pacific Rim National Park. There are communities both at their Opitsat Reserve noth of Tofino in Clayoquot Sound and at Esowista inside Pacific Rim Park.\n\nThe Tla-o-qui-aht First Nation is a Nuu-chah-nulth Nation with territory along the west coast of Vancouver Island in Clayoquot Sound and much of the Pacific Rim National Park. There are communities both at their Opitsat Reserve noth of Tofino in Clayoquot Sound and at Esowista inside Pacific Rim Park.\n\nThe Tla-o-qui-aht First Nation is a Nuu-chah-nulth Nation with territory along the west coast of Vancouver Island in Clayoquot Sound and much of the Pacific Rim National Park. There are communities both at their Opitsat Reserve noth of Tofino in Clayoquot Sound and at Esowista inside Pacific Rim Park.\n\nThe Tla-o-qui-aht First Nation is a Nuu-chah-nulth Nation with territory along the west coast of Vancouver Island in Clayoquot Sound and much of the Pacific Rim National Park. There are communities both at their Opitsat Reserve noth of Tofino in Clayoquot Sound and at Esowista inside Pacific Rim Park.	
371	Tl’azt’en Nation 	0101000020E6100000CBBDC0AC502E5FC084F57F0EF3534B40	217	tlazten@tlazten.bc.ca	http://www.tlc.baremetal.com		High-Speed[[93]]	(250) 648-3212	(250) 648-3250	Stuart Trembleur	1-866-648-3212	\n\nTl’azt’en Nation, “people by the edge of the bay”, is a First Nation community situated in north -central British Columbia, Canada. We know ourselves as Dakelh (We travel by water) but Europeans called us “Carriers”. Our language, Dakelh, is part of the Athapaskan language group.\r\r\n\r\r\nPrior to contact, Tl’azt’en’s traditional territory covered a vast area along Stuart Lake running up the Tache River almost to Takla Lake to the north. The Keyoh (land) was managed by family units and the family head controlled the hunting, fishing and gathering in his Keyoh. It was not until the late 1800’s that Tl’azt’enne began to gather in central communities in response to the fur trade and the dictates of the Roman Catholic Church.\r\r\n\r\r\nThe population of Tl’azt’en Nation today is around 1300. Of these, approximately 800 live in one of the main communities of Tache, Binche and Dzitl’ainli, and K’uzche. Tache, the largest of the communities, is situated 65 km north of Fort St. James at the mouth of the Tache River on Stuart Lake. Binche is twenty-five km from Fort St. James and is at the mouth of the Binche river, that drains the Binche Lake into Stuart Lake. Dzitl'ainli is on Leo Creek road along side Trembleur Lake. K’uzche is on the Tache River.\r\r\n\r\r\nOur main administrative offices are in Tache as are our Elementary School, daycare, head start, health office and RCMP office.\r\r\n\r\r\nIt is our goal to have our culture and language integrated into all aspects of our education from daycare to high school. Over the years we have trained our people to work in our daycare, head start and our community based elementary school. We are presently working to preserve and digitize and promote our language, stories and cultural practices so that they will form our curriculum. Our elders are helping us in our effort to reinstate and perpetuate our language and culture before it is all lost.\r\r\n\r\r\nOur people still live off the land and we hunt for moose, deer, bear, caribou, mountain goats, and small fur bearing animals. We set nets for salmon, white fish, trout, kokanee, spring salmon, and lingcod. We still go to our camp grounds in the summer time and gather food for our winter storage.[[Text copied from the Stellat'en First Nation website: http://tlc.baremetal.com/About%20Us.htm]]  \n\nTl’azt’en Nation, “people by the edge of the bay”, is a First Nation community situated in north -central British Columbia, Canada. We know ourselves as Dakelh (We travel by water) but Europeans called us “Carriers”. Our language, Dakelh, is part of the Athapaskan language group.\r\r\n\r\r\nPrior to contact, Tl’azt’en’s traditional territory covered a vast area along Stuart Lake running up the Tache River almost to Takla Lake to the north. The Keyoh (land) was managed by family units and the family head controlled the hunting, fishing and gathering in his Keyoh. It was not until the late 1800’s that Tl’azt’enne began to gather in central communities in response to the fur trade and the dictates of the Roman Catholic Church.\r\r\n\r\r\nThe population of Tl’azt’en Nation today is around 1300. Of these, approximately 800 live in one of the main communities of Tache, Binche and Dzitl’ainli, and K’uzche. Tache, the largest of the communities, is situated 65 km north of Fort St. James at the mouth of the Tache River on Stuart Lake. Binche is twenty-five km from Fort St. James and is at the mouth of the Binche river, that drains the Binche Lake into Stuart Lake. Dzitl'ainli is on Leo Creek road along side Trembleur Lake. K’uzche is on the Tache River.\r\r\n\r\r\nOur main administrative offices are in Tache as are our Elementary School, daycare, head start, health office and RCMP office.\r\r\n\r\r\nIt is our goal to have our culture and language integrated into all aspects of our education from daycare to high school. Over the years we have trained our people to work in our daycare, head start and our community based elementary school. We are presently working to preserve and digitize and promote our language, stories and cultural practices so that they will form our curriculum. Our elders are helping us in our effort to reinstate and perpetuate our language and culture before it is all lost.\r\r\n\r\r\nOur people still live off the land and we hunt for moose, deer, bear, caribou, mountain goats, and small fur bearing animals. We set nets for salmon, white fish, trout, kokanee, spring salmon, and lingcod. We still go to our camp grounds in the summer time and gather food for our winter storage.[[Text copied from the Stellat'en First Nation website: http://tlc.baremetal.com/About%20Us.htm]]  \n\nTl’azt’en Nation, “people by the edge of the bay”, is a First Nation community situated in north -central British Columbia, Canada. We know ourselves as Dakelh (We travel by water) but Europeans called us “Carriers”. Our language, Dakelh, is part of the Athapaskan language group.\r\r\n\r\r\nPrior to contact, Tl’azt’en’s traditional territory covered a vast area along Stuart Lake running up the Tache River almost to Takla Lake to the north. The Keyoh (land) was managed by family units and the family head controlled the hunting, fishing and gathering in his Keyoh. It was not until the late 1800’s that Tl’azt’enne began to gather in central communities in response to the fur trade and the dictates of the Roman Catholic Church.\r\r\n\r\r\nThe population of Tl’azt’en Nation today is around 1300. Of these, approximately 800 live in one of the main communities of Tache, Binche and Dzitl’ainli, and K’uzche. Tache, the largest of the communities, is situated 65 km north of Fort St. James at the mouth of the Tache River on Stuart Lake. Binche is twenty-five km from Fort St. James and is at the mouth of the Binche river, that drains the Binche Lake into Stuart Lake. Dzitl'ainli is on Leo Creek road along side Trembleur Lake. K’uzche is on the Tache River.\r\r\n\r\r\nOur main administrative offices are in Tache as are our Elementary School, daycare, head start, health office and RCMP office.\r\r\n\r\r\nIt is our goal to have our culture and language integrated into all aspects of our education from daycare to high school. Over the years we have trained our people to work in our daycare, head start and our community based elementary school. We are presently working to preserve and digitize and promote our language, stories and cultural practices so that they will form our curriculum. Our elders are helping us in our effort to reinstate and perpetuate our language and culture before it is all lost.\r\r\n\r\r\nOur people still live off the land and we hunt for moose, deer, bear, caribou, mountain goats, and small fur bearing animals. We set nets for salmon, white fish, trout, kokanee, spring salmon, and lingcod. We still go to our camp grounds in the summer time and gather food for our winter storage.[[Text copied from the Stellat'en First Nation website: http://tlc.baremetal.com/About%20Us.htm]]  \n\nTl’azt’en Nation, “people by the edge of the bay”, is a First Nation community situated in north -central British Columbia, Canada. We know ourselves as Dakelh (We travel by water) but Europeans called us “Carriers”. Our language, Dakelh, is part of the Athapaskan language group.\r\r\n\r\r\nPrior to contact, Tl’azt’en’s traditional territory covered a vast area along Stuart Lake running up the Tache River almost to Takla Lake to the north. The Keyoh (land) was managed by family units and the family head controlled the hunting, fishing and gathering in his Keyoh. It was not until the late 1800’s that Tl’azt’enne began to gather in central communities in response to the fur trade and the dictates of the Roman Catholic Church.\r\r\n\r\r\nThe population of Tl’azt’en Nation today is around 1300. Of these, approximately 800 live in one of the main communities of Tache, Binche and Dzitl’ainli, and K’uzche. Tache, the largest of the communities, is situated 65 km north of Fort St. James at the mouth of the Tache River on Stuart Lake. Binche is twenty-five km from Fort St. James and is at the mouth of the Binche river, that drains the Binche Lake into Stuart Lake. Dzitl'ainli is on Leo Creek road along side Trembleur Lake. K’uzche is on the Tache River.\r\r\n\r\r\nOur main administrative offices are in Tache as are our Elementary School, daycare, head start, health office and RCMP office.\r\r\n\r\r\nIt is our goal to have our culture and language integrated into all aspects of our education from daycare to high school. Over the years we have trained our people to work in our daycare, head start and our community based elementary school. We are presently working to preserve and digitize and promote our language, stories and cultural practices so that they will form our curriculum. Our elders are helping us in our effort to reinstate and perpetuate our language and culture before it is all lost.\r\r\n\r\r\nOur people still live off the land and we hunt for moose, deer, bear, caribou, mountain goats, and small fur bearing animals. We set nets for salmon, white fish, trout, kokanee, spring salmon, and lingcod. We still go to our camp grounds in the summer time and gather food for our winter storage.[[Text copied from the Stellat'en First Nation website: http://tlc.baremetal.com/About%20Us.htm]]  \n\nTl’azt’en Nation, “people by the edge of the bay”, is a First Nation community situated in north -central British Columbia, Canada. We know ourselves as Dakelh (We travel by water) but Europeans called us “Carriers”. Our language, Dakelh, is part of the Athapaskan language group.\r\r\n\r\r\nPrior to contact, Tl’azt’en’s traditional territory covered a vast area along Stuart Lake running up the Tache River almost to Takla Lake to the north. The Keyoh (land) was managed by family units and the family head controlled the hunting, fishing and gathering in his Keyoh. It was not until the late 1800’s that Tl’azt’enne began to gather in central communities in response to the fur trade and the dictates of the Roman Catholic Church.\r\r\n\r\r\nThe population of Tl’azt’en Nation today is around 1300. Of these, approximately 800 live in one of the main communities of Tache, Binche and Dzitl’ainli, and K’uzche. Tache, the largest of the communities, is situated 65 km north of Fort St. James at the mouth of the Tache River on Stuart Lake. Binche is twenty-five km from Fort St. James and is at the mouth of the Binche river, that drains the Binche Lake into Stuart Lake. Dzitl'ainli is on Leo Creek road along side Trembleur Lake. K’uzche is on the Tache River.\r\r\n\r\r\nOur main administrative offices are in Tache as are our Elementary School, daycare, head start, health office and RCMP office.\r\r\n\r\r\nIt is our goal to have our culture and language integrated into all aspects of our education from daycare to high school. Over the years we have trained our people to work in our daycare, head start and our community based elementary school. We are presently working to preserve and digitize and promote our language, stories and cultural practices so that they will form our curriculum. Our elders are helping us in our effort to reinstate and perpetuate our language and culture before it is all lost.\r\r\n\r\r\nOur people still live off the land and we hunt for moose, deer, bear, caribou, mountain goats, and small fur bearing animals. We set nets for salmon, white fish, trout, kokanee, spring salmon, and lingcod. We still go to our camp grounds in the summer time and gather food for our winter storage.[[Text copied from the Stellat'en First Nation website: http://tlc.baremetal.com/About%20Us.htm]]  \n\nTl’azt’en Nation, “people by the edge of the bay”, is a First Nation community situated in north -central British Columbia, Canada. We know ourselves as Dakelh (We travel by water) but Europeans called us “Carriers”. Our language, Dakelh, is part of the Athapaskan language group.\r\r\n\r\r\nPrior to contact, Tl’azt’en’s traditional territory covered a vast area along Stuart Lake running up the Tache River almost to Takla Lake to the north. The Keyoh (land) was managed by family units and the family head controlled the hunting, fishing and gathering in his Keyoh. It was not until the late 1800’s that Tl’azt’enne began to gather in central communities in response to the fur trade and the dictates of the Roman Catholic Church.\r\r\n\r\r\nThe population of Tl’azt’en Nation today is around 1300. Of these, approximately 800 live in one of the main communities of Tache, Binche and Dzitl’ainli, and K’uzche. Tache, the largest of the communities, is situated 65 km north of Fort St. James at the mouth of the Tache River on Stuart Lake. Binche is twenty-five km from Fort St. James and is at the mouth of the Binche river, that drains the Binche Lake into Stuart Lake. Dzitl'ainli is on Leo Creek road along side Trembleur Lake. K’uzche is on the Tache River.\r\r\n\r\r\nOur main administrative offices are in Tache as are our Elementary School, daycare, head start, health office and RCMP office.\r\r\n\r\r\nIt is our goal to have our culture and language integrated into all aspects of our education from daycare to high school. Over the years we have trained our people to work in our daycare, head start and our community based elementary school. We are presently working to preserve and digitize and promote our language, stories and cultural practices so that they will form our curriculum. Our elders are helping us in our effort to reinstate and perpetuate our language and culture before it is all lost.\r\r\n\r\r\nOur people still live off the land and we hunt for moose, deer, bear, caribou, mountain goats, and small fur bearing animals. We set nets for salmon, white fish, trout, kokanee, spring salmon, and lingcod. We still go to our camp grounds in the summer time and gather food for our winter storage.[[Text copied from the Stellat'en First Nation website: http://tlc.baremetal.com/About%20Us.htm]]  	
382	Tseshaht First Nation	0101000020E6100000A3957B8159365FC0630CACE3F8A14840	0	reception@tseshaht.com	http://www.tseshaht.com		 \tHigh-Speed[[93]]	(250) 724-1225	(250) 724-4385	Sheshaht	1-888-724-1225	Both the <a href="http://nuuchahnulth.org">Nuu-chah-nulth Tribal Council</a> administration building and the First Nations operated <a href="http://www.haahuupayak.com">Haahuupayak School</a> are on Tseshaht reserve lands near Port Alberni.\n\n"The Tseshaht people live on the west Coast of Vancouver Island, British Columbia, Canada, one of the 14 Nations that make up the Nuu chah nulth Tribal Council. Tseshaht translates as “the people of c̓išaa” while Nuu chah nulth means “all along the mountains and sea” and is descriptive of a people living along the mountains that face the Pacific Ocean. c̓išaa is located on what is today known as Benson Island, one of the Broken Group Islands in Barclay Sound. The Tseshaht people were created at c̓išaa and came to own all of the Broken Group Islands and lands up the canal to Port Alberni. Historically, the Tseshaht people were whalers and fishermen and their lives revolved around their territories on both land and water."[[copied from the Tseshaht homepage: http://www.tseshaht.com/index_main.php]]	
389	Ulkatchot'en	0101000020E61000003C2EAA4544545FC0AC8F87BEBB3B4A40	0	\N	\N		Dial-in[[93]]	(250) 742-3260	(250) 742-3411	Ulkatcho First Nation,Ulkatchos,Ulkatcho people		\n\nThe Ulkatcho'en offices are located in Anahim Lake, British Columbia at the western edge of the Chilcotin District. The First Nation is a member of the Carrier Chilcotin Tribal Council and they are responsible for 22 reserves.\n\nThe Ulkatcho'en offices are located in Anahim Lake, British Columbia at the western edge of the Chilcotin District. The First Nation is a member of the Carrier Chilcotin Tribal Council and they are responsible for 22 reserves.\n\nThe Ulkatcho'en offices are located in Anahim Lake, British Columbia at the western edge of the Chilcotin District. The First Nation is a member of the Carrier Chilcotin Tribal Council and they are responsible for 22 reserves.\n\nThe Ulkatcho'en offices are located in Anahim Lake, British Columbia at the western edge of the Chilcotin District. The First Nation is a member of the Carrier Chilcotin Tribal Council and they are responsible for 22 reserves.\n\nThe Ulkatcho'en offices are located in Anahim Lake, British Columbia at the western edge of the Chilcotin District. The First Nation is a member of the Carrier Chilcotin Tribal Council and they are responsible for 22 reserves.\n\nThe Ulkatcho'en offices are located in Anahim Lake, British Columbia at the western edge of the Chilcotin District. The First Nation is a member of the Carrier Chilcotin Tribal Council and they are responsible for 22 reserves.	
\.


--
-- Data for Name: language_community_languages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_community_languages (id, community_id, language_id) FROM stdin;
224	204	5
225	205	33
226	206	25
227	207	9
228	208	5
229	209	12
230	210	9
231	210	14
232	210	15
233	211	21
234	211	22
235	212	33
236	213	12
237	214	12
238	215	13
239	216	18
240	216	16
241	217	9
242	217	11
243	218	29
244	219	33
245	220	33
246	221	29
247	222	13
248	223	9
249	224	9
250	225	9
251	226	9
252	227	16
253	227	18
254	228	12
255	229	8
256	229	29
257	229	42
258	230	12
259	231	9
260	232	29
261	233	17
262	234	17
263	235	26
264	236	22
265	237	13
266	238	25
267	239	33
268	240	15
269	241	21
270	241	20
271	242	31
272	243	31
273	244	31
274	245	31
275	246	34
276	247	31
277	248	29
278	249	29
279	250	16
280	250	31
281	251	9
282	252	7
283	253	22
284	254	34
285	255	27
286	256	25
287	257	33
288	258	8
289	259	25
290	260	25
291	261	4
292	262	25
293	263	33
294	264	12
295	265	9
296	266	31
297	267	27
298	267	38
299	268	34
300	269	34
301	270	8
302	271	18
303	272	3
304	273	29
305	274	9
306	275	9
307	276	29
308	277	29
309	278	9
310	279	16
311	280	9
312	280	26
313	281	34
314	282	9
315	283	18
316	284	17
317	285	33
318	286	35
319	287	12
320	288	36
321	289	9
322	290	12
323	291	9
324	291	15
325	292	29
326	293	9
327	294	3
328	295	34
329	296	16
330	297	13
331	298	25
332	299	9
333	300	18
334	301	18
335	302	29
336	303	18
337	304	33
338	305	12
339	306	32
340	307	32
341	308	32
342	309	32
343	310	12
344	311	13
345	312	25
346	313	6
347	314	36
348	315	24
349	316	12
350	317	36
351	318	28
352	319	26
353	320	9
354	320	15
355	321	9
356	322	36
357	323	9
358	324	9
359	325	22
360	326	9
361	327	9
362	328	29
363	329	18
364	330	18
365	331	13
366	332	21
367	332	37
368	332	22
369	333	9
370	334	9
371	335	10
372	336	15
373	337	13
374	338	12
375	339	33
376	340	9
377	341	9
378	342	33
379	343	12
380	344	13
381	345	33
382	346	24
383	347	16
384	348	9
385	349	12
386	350	9
387	351	8
388	352	9
389	353	9
390	354	33
391	355	15
392	356	9
393	357	33
394	358	12
395	359	11
396	360	9
397	361	35
398	362	18
399	363	5
400	364	9
401	365	4
402	366	18
403	366	16
404	367	23
405	368	13
406	369	25
407	370	29
408	371	18
409	372	5
410	373	29
411	374	35
412	375	5
413	376	25
414	377	15
415	378	29
416	379	15
417	380	9
418	381	3
419	382	25
420	383	15
421	384	13
422	385	15
423	386	9
424	387	25
425	388	25
426	389	5
427	389	18
428	390	9
429	391	36
430	392	36
431	393	21
432	393	22
433	394	36
434	395	18
435	395	16
436	396	33
437	397	33
438	398	13
439	399	5
440	400	9
441	401	9
442	402	18
443	403	9
444	404	16
445	405	35
446	406	7
\.


--
-- Data for Name: language_communitylink; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_communitylink (id, url, title, community_id) FROM stdin;
268	http://www.tsilhqotin.ca	Tsilhqot'in National Government	204
269	http://www.desniqi.org	Desniqi Services Society	204
270	http://www.adamslakeband.org/	Adams Lake Band	205
271	http://www.chiefatahm.com/	Chief Atahm School	205
272	http://spiritmap.ca/	Spiritmap: a website celebrating the Secwepemc First Nation	205
273	http://www.shuswapnation.org	Shuswap Nation Tribal Council	205
274	http://www.nuuchahnulth.org	Nuu-chah-nulth Tribal Council	206
275	http://en.wikipedia.org/wiki/Ahousaht_First_Nation	Wikipedia entry	206
276	http://www.stolonation.bc.ca/SNEMain/General/default.aspx	Stó:lô Nation	207
277	http://www.tsideldel.org	Tsi Del Del	208
278	http://www.gov.bc.ca/arr/firstnation/nlakapamux_nation/default.html	MARR: Nlaka'pamux Nation Tribal Council	209
279	http://www.treaty8.bc.ca/	Treaty 8 Tribal Association	211
280	http://www.bonaparteindianband.com/	Bonaparte Indian Band	212
281	http://www.shuswapnation.org	Shuswap Nation Tribal Council	212
282	http://www.statimc.net/	St̓át̓imc website	215
283	http://www.uslces.org/	Upper St'át'imc Language, Culture and Education Society	215
284	http://www.maltwood.uvic.ca/statimc/default.html	Glimpses into Upper St’át’imc History through Photographs	215
285	http://www.cstc.bc.ca/cstc/37/tsil+kaz+koh+first+nation	Carrier Sekani Tribal Council	216
286	http://en.wikipedia.org/wiki/Burns_Lake_Indian_Band	Wikipedia	216
287	http://www.canimlakeband.com	Canim Lake Band	219
288	http://www.shuswapnation.org	Shuswap Nation Tribal Council	219
289	http://www.nstq.org/Photo_Pages/nstc/Cariboo_Tribal_Council/Canoe_index.htm	Canoe Creek homepage	220
290	http://www.statimc.net/	St̓át̓imc website	222
291	http://www.uslces.org/	Upper St'át'imc Language, Culture and Education Society	222
292	http://www.maltwood.uvic.ca/statimc/default.html	Glimpses into Upper St’át’imc History through Photographs	222
293	http://www.stolotribalcouncil.ca	Sto:lo Tribal Council	224
294	http://www.gov.bc.ca/arr/firstnation/nicola_tribal_assoc/default.html	MARR: Nicola Tribal Association	228
295	http://www.comoxband.ca/index.php	K'ómoks First Nation	229
296	http://www.gov.bc.ca/arr/firstnation/nicola_tribal_assoc/default.html	MARR: Nicola Tribal Association	230
297	http://www.danaxdaxw.com	Da̱'naxda̱'xw/Awa̱etla̱la̱ First Nation	232
298	http://www.umista.org	U'mista Cultural Society	232
299	http://www.virtualmuseum.ca/Exhibitions/Danewajich/english/resources/language.php	Dane Wajich Dane-ẕaa Stories & Songs - Language page	236
300	http://www.treaty8.bc.ca	Treaty 8 Tribal Association	236
301	http://www.inshuckch.com/douglas.html	In-SHUCK-ch Nation: Douglas First Nation	237
302	http://ehattesaht.com	Ehattesaht First Nation	238
303	http://en.wikipedia.org/wiki/Nuu-chah-nulth	Nuu-chah-nulth Wikipedia entry	238
304	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	238
305	http://www.fnnation.ca	http://www.fnnation.ca	241
306	http://gitxaalanation.com/	Gitxaala Nation	246
307	http://en.wikipedia.org/wiki/Tsimshian	Wikipedia: Tsimshian	246
308	http://www.umista.org	U'mista Cultural Society	248
309	http://www.hagwilget.com	Hagwilget Village	250
310	http://www.haisla.ca	Haisla First Nation	252
311	http://www.gitgaat.net	Gitga'at Nation	254
312	http://en.wikipedia.org/wiki/Tsimshian	Wikipedia: Tsimshian	254
313	http://www.heiltsukdevco.com/	http://www.heiltsukdevco.com/	255
314	http://www.heiltsuk.com	http://www.heiltsuk.com	255
315	http://hesquiaht.org	Hesquiaht First Nation	256
316	http://www.nuuchahnulth.org	Nuu-chah-nulth Tribal Council	256
317	http://en.wikipedia.org/wiki/Hesquiat	Wikipedia entry	256
318	http://www.hupacasath.ca/index.html	Hupacasath First Nation	259
319	http://en.wikipedia.org/wiki/Hupacasath_First_Nation	Wikipedia entry	259
320	http://en.wikipedia.org/wiki/Nuu-chah-nulth	Nuu-chah-nulth Wikipedia entry	259
321	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	259
322	http://www.gov.bc.ca/arr/firstnation/hupacasath/default.html	Ministry of Aboriginal Relations and Reconciliation	259
323	http://huuayaht.org	Huu-ay-aht First Nation	260
324	http://www.maanulth.ca	Maanulth First Nations	260
325	http://en.wikipedia.org/wiki/Huu-ay-aht_First_Nation	Wikipedia entry	260
326	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	260
327	http://www.kyuquot.ca	Ka:'yu:'k't'h'/Che:k:tles7et'h' First Nations	262
328	http://en.wikipedia.org/wiki/Kyuquot/Cheklesahht_First_Nation	Wikipedia entry	262
329	http://www.maanulth.ca	Maanulth First Nations	262
330	http://en.wikipedia.org/wiki/Nuu-chah-nulth	Nuu-chah-nulth Wikipedia entry	262
331	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	262
332	http://www.kib.ca/	Tk'emlups Indian Band	263
333	http://www.shuswapnation.org	Shuswap Nation Tribal Council	263
334	http://www.kitasoo.org	Kitasoo/Xaixais Nation	267
335	http://en.wikipedia.org/wiki/Kitasoo	http://en.wikipedia.org/wiki/Kitasoo	267
336	http://www.kitselas.bc.ca/	Kitselas First Nation	268
337	http://en.wikipedia.org/wiki/Tsimshian	Wikipedia: Tsimshian	268
338	http://www.carrierchilcotin.org	Carrier Chilcotin Tribal Council	271
339	http://www.kwadacha.com	Kwadacha Nation	272
340	http://www.lakahahmen.com	Leq'á:mel First Nation	282
341	http://www.lheidli.ca	Lheidli T’enneh	283
342	http://www.littleshuswaplake.com/history.html	Little Shuswap Lake Indian Band	285
343	http://www.shuswapnation.org	Shuswap Nation Tribal Council	285
344	http://www.lnib.net/default.htm	Lower Nicola Indian Band	287
345	http://www.gov.bc.ca/arr/firstnation/nicola_tribal_assoc/default.html	MARR: Nicola Tribal Association	287
346	http://www.mlib.ca	McLeod Lake Indian Band	294
347	http://www.bctreaty.net/nations/mcleod.php	BC Treaty Commission	294
348	http://www.lilwat.ca	Lil'wat Nation	297
349	http://www.yuquot.ca	Mowachaht/Muchalaht First Nations	298
350	http://en.wikipedia.org/wiki/Mowachaht/Muchalaht_First_Nations	Wikipedia entry	298
351	http://en.wikipedia.org/wiki/Nuu-chah-nulth	Nuu-chah-nulth Wikipedia entry	298
352	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	298
353	http://www.musqueam.bc.ca	Musqueam	299
354	http://www.cstc.bc.ca/cstc/34/nadleh+whuten+first+nation	Carrier Sekani Tribal Council - Nadleh Whut'en page:	300
355	http://en.wikipedia.org/wiki/Nadleh_Whut'en_First_Nation	Wikipedia	300
356	https://www.firstvoices.com/explore/FV/sections/Data/Athabascan/Dakelh/Nadleh%20Whut'en	FirstVoices Archive	300
357	http://www.nakazdli.ca	Nak'azdli	301
358	http://www.cstc.bc.ca/cstc/35/nakazdli+band	Carrier Sekani Tribal Council - Nak'azdli	301
359	http://en.wikipedia.org/wiki/Nak'azdli	Wikipedia	301
360	http://www.gov.bc.ca/arr/firstnation/nazko/default.html	Aboriginal Relations and Reconciliation	303
361	http://neskonlith.org/	Neskonlith Indian Band	304
362	http://www.shuswapnation.org	Shuswap Nation Tribal Council	304
363	http://www.gov.bc.ca/arr/firstnation/nicola_tribal_assoc/default.html	MARR: Nicola Tribal Association	310
364	http://www.nquatqua.ca	N'Quatqua	311
365	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	312
366	http://en.wikipedia.org/wiki/Nuu-chah-nulth	Nuu-chah-nulth Wikipedia entry	312
367	http://en.wikipedia.org/wiki/Nuxalk	 Wikipedia entry	313
368	http://www.nuxalk.net/index.html	http://www.nuxalk.net/index.html	313
369	http://www3.nfb.ca/collection/films/fiche/?lg=en&id=51207	Short documentary film about the Qayqayt First NationHesquiaht First Nation	326
370	http://www.carrierchilcotin.org	Carrier Chilcotin Tribal Council	329
371	http://www.cstc.bc.ca/cstc/43/saikuz+first+nation	Carrier Sekani Tribal Council	330
372	http://en.wikipedia.org/wiki/Stoney_Creek,_British_Columbia	Wikipedia	330
373	http://www.inshuckch.com/samahquam.html	In-SHUCK-ch Nation: Samahquam Nation	331
374	http://www.saulteau.com/	Saulteau First Nations	332
375	http://www.treaty8.bc.ca/	Treaty 8 Tribal Association	332
376	http://www.ydli.org/biblios/saubib.htm	Yinka Déné Language Institute: Bibliography of Materials on the Saulteau Language	332
377	http://www.seabirdisland.ca/	Seabird Island Indian Band	334
378	http://www.statimc.net/	St̓át̓imc website	337
379	http://www.uslces.org/	Upper St'át'imc Language, Culture and Education Society	337
380	http://www.maltwood.uvic.ca/statimc/default.html	Glimpses into Upper St’át’imc History through Photographs	337
381	http://www.gov.bc.ca/arr/firstnation/nicola_tribal_assoc/default.html	MARR: Nicola Tribal Association	338
382	http://www.shuswapnation.org	Shuswap Nation Tribal Council	339
383	http://www.simpcw.com	Simpcw First Nation	342
384	http://www.inshuckch.com/skatin.html	In-SHUCK-ch Nation: Skatin First Nations	344
385	http://www.skeetchestn.ca/index.html	Skeetchestn Indian Band	345
386	http://www.shuswapnation.org	Shuswap Nation Tribal Council	345
387	http://www.skidegate.ca	Skidegate Band Council	346
388	http://www.xatsull.com	Xats'ull First Nation	354
389	http://www.songheesnation.com/	Songhees Nation	355
390	http://en.wikipedia.org/wiki/Songhees	Wikipedia	355
391	http://www.splatsin.ca	Splats'in First Nation	357
392	http://www.squamish.net	Squamish Nation	359
393	http://en.wikipedia.org/wiki/Squamish_Nation	Wikipedia: Squamish Nation	359
394	http://www.cstc.bc.ca/cstc/45/stellaten+first+nation	Carrier Sekani Tribal Council	362
395	http://en.wikipedia.org/wiki/Nak'azdli	Wikipedia	362
396	http://www.tsilhqotin.ca	Tsilhqot'in National Government	363
397	http://www.stikine.net/Tahltan/tahltan.html	Tahltan Nation	365
398	http://www.cstc.bc.ca/cstc/36/takla+lake+first+nation	Carrier Sekani Tribal Council - Takla Lake page	366
399	http://www.statimc.net/	St̓át̓imc website	368
400	http://www.uslces.org/	Upper St'át'imc Language, Culture and Education Society	368
401	http://www.maltwood.uvic.ca/statimc/default.html	Glimpses into Upper St’át’imc History through Photographs	368
402	http://en.wikipedia.org/wiki/Tla-o-qui-aht	Tla-o-qui-aht Wikipedia entry	369
403	http://en.wikipedia.org/wiki/Nuu-chah-nulth	Nuu-chah-nulth Wikipedia entry	369
404	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	369
405	http://tlc.baremetal.com/index.htm	Tl’azt’en Nation	371
406	http://www.cstc.bc.ca/cstc/45/stellaten+first+nation	Carrier Sekani Tribal Council	371
407	http://www.carrierchilcotin.org	Carrier Chilcotin Tribal Council	375
408	http://www.maanulth.ca	Maanulth First Nations	376
409	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	376
410	http://www.tsartlip.com/index.htm	Tsartlip First Nation	377
411	http://www.sisb.bc.ca/index3.html	LÁU,WELNEW Tribal School	377
412	http://www.tsawout.com	Tsawout First Nation	379
413	http://www.sisb.bc.ca/index3.html	LÁU,WELNEW Tribal School	379
414	http://www.bctreaty.net/nations/tsaykeh.php	BC Treaty Commission	381
415	http://www.tseshaht.com	Tseshaht First Nation	382
416	http://www.haahuupayak.com	Haahuupayak School	382
417	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	382
418	http://www.tseycum.ca	Tseycum First Nation	383
419	http://www.sisb.bc.ca/index3.html	LÁU,WELNEW Tribal School	383
420	http://www.tskwaylaxw.com/	Tsk’wáylacw website	384
421	http://www.statimc.net/	St̓át̓imc website	384
422	http://www.uslces.org/	Upper St'át'imc Language, Culture and Education Society	384
423	http://www.maltwood.uvic.ca/statimc/default.html	Glimpses into Upper St’át’imc History through Photographs	384
424	http://www.maanulth.ca	Maanulth First Nations	387
425	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	387
426	http://ufn.ca	Ucluelet First Nation	388
427	http://www.maanulth.ca	Maanulth First Nations	388
428	http://nuuchahnulth.org	Nuu-chah-nulth Tribal Council	388
429	http://www.carrierchilcotin.org	Carrier Chilcotin Tribal Council	389
430	http://www.cstc.bc.ca/cstc/44/wetsuweten+first+nation	Carrier Sekani Tribal Council: Wet'suwet'en First Nation	395
431	http://www.wpcib.com/	Whispering Pines / Clinton Indian Band	396
432	http://www.shuswapnation.org	Shuswap Nation Tribal Council	396
433	http://www.williamslakeband.ca	T'exelcemc homepage	397
434	http://www.xaxlip.ca	Xaxli'p website	398
435	http://www.statimc.net/	St̓át̓imc website	398
436	http://www.uslces.org/	Upper St'át'imc Language, Culture and Education Society	398
437	http://www.maltwood.uvic.ca/statimc/default.html	Glimpses into Upper St’át’imc History through Photographs	398
438	http://www.xenigwetin.com	Xeni Gwet'in	399
439	http://en.wikipedia.org/wiki/Xeni_Gwet'in_First_Nation	Wikipedia: Xeni Gwet'in	399
440	http://en.wikipedia.org/wiki/Yekooche	Wikipedia	402
\.


--
-- Data for Name: language_dialect; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_dialect (id, name, language_id) FROM stdin;
22	Xenaksialak̓ala 	7
23	Xa'’islak̓ala	7
24	Northern Łingít	23
25	Upper St̓át̓imcets	\N
26	Lower St̓át̓imcets	\N
27	Upper Ktunaxa	35
28	SENĆOŦEN	15
29	Qʼómox̣ʷs	8
30	Malchosen	15
31	ʔayʔaǰúθəm	8
32	Lekwungen	15
33	Semiahmoo	15
34	T’Sou-ke	15
35	Hul’q’umi’num’	9
36	Halq'eméylem	9
37	hən̓q̓əmin̓əm̓	9
38	Eastern/Gaanimx	31
39	Western/Geets'imx	31
40	Diitiidʔaatx̣	26
41	Northern Nuučaan̓uɫ	25
42	Bak’wamk’ala	29
43	Kwak̓wala	29
44	Gwawaenuk	29
45	Nak’wala	29
46	Central Nuučaan̓uɫ	25
47	G̱ut̕sala	29
48	T̕łat̕łasiḵ̕wala	29
49	Liq̓wala	29
50	Barkley	25
51	Southern Nuučaan̓uɫ	25
52	’Uik̓ala	28
53	Skidegate	24
54	Massett	24
1	Saulteau	37
2	Plains Cree	21
3	Eastern Secwepemc	33
4	Nak’albun-Dzinghubun/Stuart-Trembleur Lake 	18
5	Western Secwepemc	33
6	Northern Secwepemc	33
7	Fraser-Nechakoh	18
8	Blackwater 	18
9	Stellako	18
10	Blueberry River	22
11	Doig River	22
12	Halfway River	22
13	Prophet River	22
14	West Moberly Lake	22
15	Northern Nsyilxcən	36
16	South Slavey	20
17	Babine	16
18	Wet’suwet’en	16
19	Fort Ware 	3
20	McLeod Lake	3
21	Southern Tutchone	19
\.


--
-- Data for Name: language_language; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_language (id, name, color, fv_archive_link, other_names, sub_family_id, notes, geom, fluent_speakers, learners, pop_total_value, some_speakers, bbox, regions) FROM stdin;
38	Sgüüx̣s			Klemtu ,Southern Tsimshian,Ski:xs	\N		\N	1	4	519	4	\N	
40	Nicola				2	This language is currently a sleeping language.	\N	0	0	0	0	\N	
41	Lhéchelesem			Nooksack	4		\N	0	0	0	0	\N	
42	Pəntl’áč			Pentlatch	4	This language is considered a sleeping language.	\N	0	0	0	0	\N	
43	Chinuk Wawa				\N		\N	0	0	0	0	\N	
36	Nsyilxcən	RGB(255, 96, 96)	https://www.firstvoices.com/explore/FV/sections/Data/nsyilxc%C9%99n/nsyilxc%C9%99n/nsyilxc%C9%99n	Okanagan	5		0103000020E6100000010000004E05000019D728B2D63B5DC067B7D4A0AF394940F48B0EEBE13B5DC0E32A1EA5B3374940EFAE6B27DE3D5DC0009E45F9EF3549406580F692743E5DC07231244C72344940DCFEA98F523E5DC0B9ACC22DEC324940CF71C145333E5DC09EDCBB633B314940A32DD5859D3D5DC0CDCE3233A03049407810F5432D3D5DC087857D77C82F49402A9D6293E63C5DC090743E32742E494023509A590D3C5DC0F5BB39C55B2D49401204BBBCD43B5DC093A82FF1142B49400EE1950C453C5DC0E4D43A0743264940FE48E2A5783C5DC0E735431D0A214940F143ED6A103D5DC0C7094993EB1E49404B9F69BCC33D5DC04D7C1AEFA41C494034B7E838093E5DC0F2183FC3741B4940B1CFCD0A163E5DC06454BC11AA1A494033F291E5EA3D5DC0BDA379303A1A4940C625A487663D5DC0B74E0FA5211A49407D5542F66D3D5DC00ABB0B4CAC19494013B7F6937E3D5DC0AE049FFC03194940931F5BE4E33C5DC0409895F4AF164940E5FEE7C0983B5DC0E4702B0F3F0E494019F9DF9979395DC0E6277FE29006494090E9432288395DC020A97C5586FF4840B4E40BD65E395DC0D20E2DC873FD4840B21C08BEEC385DC0A620D91907F54840AA221F0578385DC0AF7BD89656EC48401260D19F38385DC0DE5D3478F9E34840BABEB5130F395DC0E8C9FD4A58DC484044EF0806163A5DC0FB8EA6593BD448406222732A023A5DC0A7CFF7CCCFD148406205A70AFF375DC0AC0F2939DFCE484058142E2B91385DC0EE5B0B4CF4CB4840C9B45A36F03A5DC06F31B9A1B1C748403E8A3469A63F5DC023B7E0C7F1C248405E5823DDB9435DC04118AF7999BD4840FC6E9D60AC455DC049F3BEDF6AB64840960FA3919F455DC0DC7B7FC071B24840E868FC6618445DC0A72FBA54E0AC484061FA64808B425DC03D2E402E4AA248405B0451362F425DC0DEF5CBF1FE9A4840606419E710425DC043C7B581DC9348408AA29FA380425DC0E8535AA4038B4840F835CDA825455DC0F02DD1BAB38448403223A9AA604B5DC0F819E64D537D4840117E26A9D5515DC071B133C1CD7348400F11CD1AB7525DC0405F37DA02724840F85AFA77EE555DC08D1097C5006B484092BA497E0F595DC0329647AD1E624840270197D5935F5DC0F212DEF6D44E4840C160338F8F655DC0CEC877891B3B4840BB4E5551D9685DC0253A6494D22F48400ACD0E1ACA6D5DC0A86CE930EB214840CE0EBED5AE715DC0BEFE5946BC164840269F0CB6EF745DC0E5D62A74FE0C484022792640E8785DC0081F6C5C54014840F4E05B5F697B5DC0719A4026F6FB4740DEE9C023D47D5DC047C2DB5075F6474080FCA86B0D825DC044DB0F3F28ED4740B4127FF00C845DC08A797C24FCE947400C978ACA1C875DC07B889462CCE44740BCAB23BD668C5DC04FA125A4E5DB4740B8841838CC915DC0667C872EE9D547407BBA7AF0BD975DC076EFAE9173CF47402813DF31C4A05DC098D846948FCA474038B3E7A105A45DC0AE64E8F2D3C847401D04DDDA0AAE5DC04531945F18C8474081AF95BA6BB65DC0A24CD53C6BC74740E0746F883DBB5DC05200F17356C747403F5B238814C45DC0AE1E67026CC74740F6B6695CF1C95DC0B28322877FC74740DE5127D8C6D15DC0C1ED59601FC8474035D3D2B6EADB5DC0478459A215C94740630272307BE35DC0E9D10BCB99C94740EBD5DF4DE9EA5DC049D75BE625CA4740B9677145ADEC5DC0196F136E84CA4740011B080F42F55DC09DBBC3B5C3CC474045C54501FAF85DC00FF9B3FCEDCD47409143BAE6D4FC5DC0242029601DCF474033C7B142DC045EC075C96E1EB9D14740CAD9FAF44F075EC03E47731921D347408D7F17A5100D5EC0033413C935D647406E7215C04B125EC0AEADBF1DEBD84740308CCFB7A9155EC0A2DB9F35E8DB4740716D00212B1B5EC046B07B1DA5E04740E1A37071A91E5EC0A99BF46249E54740394251D0AE255EC089EEB8BF99EE47401F88F5C1FC265EC01528CEF093F04740992DD023DB295EC01A65021D73F547406FC148A2652E5EC05B0C457FE1FC4740E4DFD24F302F5EC03F4E8B62E3FE47404DB1B5C2D5315EC0939D7F826605484045AACF4669345EC02CEE2DC1B10B484069F06A32B1365EC017A9D1D3A1114840F33B2BA82F3A5EC08357F2C86F184840E2CDBD59263F5EC06FEF94F6A3224840F8AF99429D425EC06A94273CCF294840F8B7C73378445EC027D0DA9A652D48402F05991D48455EC0978F10E01B314840A612C4226D475EC0BE36A4BD7A3B48401118D21F83485EC0DC1F0D7AC93F484023417F66C0495EC03DC9996C944448402010744EC34C5EC02EFDAA3791504840110144845F4E5EC0254A0C2E8F57484098D581EBC14F5EC0590CA8CCCB5D4840F694AE0C24515EC0E68D80F03E644840905E84A0BB515EC02EE58685C0694840265975C087525EC00B14C76A927148408DC424769C535EC055556C428A7948400E402BAF83545EC0405D156522804840CB090EFBC2545EC066B194CC138248406015FAE80D555EC0345B3CAC758448407127E15E2A555EC03EC96D42568648405AFE97422B555EC0B0744602CF8B4840F24F113819555EC0FFA414301E8E484004E5D67CE8545EC077E1B4BDF1904840C8CDDD9FB4545EC0DB4053F77D9448409F4740B819555EC0DFEF4B64499B48405D7AD3AB43555EC0091AD6EDD49D4840623ACB3123555EC0E006859CA3A0484019FE6DE932545EC00D8FBB2619A34840CE82DBEDED525EC0771E90BAB4A4484006689A90D2505EC0F4B2E17DE4A54840C609D20C4F4F5EC0BA454514EEA548401891208CC34C5EC094F4BF5A16A64840646EB414E34A5EC04207A9EEF1A54840E579969DD5485EC092EA4F7AD6A548408C887242D1465EC0EB73C562FCA54840CFDE88F4C1455EC0F3B3560E6EA648405169B70101455EC03DC6262D82A74840B1B5983FEE445EC040444261D1A848400841FBBD18455EC0DD8A80491DAA4840AF60BBAABA455EC081E698A0D7AC48403AD8A94A34465EC00FEB7C83E4AE484054F212FB7D465EC069CBB39B56B148403A1DD19B56465EC0560A2E0485B348405EEBEC5DCF455EC0C50FBD020EB648406FF59985B7445EC0F05CC01C0FB84840703CBA1BA2435EC0DF2232D75ABA4840B23DA32C2A435EC00C09114A2FBC4840C26317640B435EC058E4FFBE68BD484000872475DE435EC006AEAF945FBF48402881A11F0D445EC00B44CBA1ABC0484060906584D3435EC061DD983757C24840B58E7BB372435EC000D57E1CA9C3484053D73A84A6425EC0B72AA372BCC648401D008BED2A425EC0BAC7903200CA4840C87DEDA741425EC045618C06F6CB48407EC81E4BD6425EC07230B53160CD484008D623F11E445EC07BE713261BCE4840341CB1F4F8455EC05423229B3BCE4840B80CC17EF6475EC0F60E80BE41CD4840EF2B1C544A495EC07B55D25967CD484066A997230F4A5EC02950D22E48CE48404DD962BF5D4A5EC032BC5C74DACF4840CBD3DB4A2C4A5EC00AF1D69F98D14840936906B407495EC0778D52670DD44840ADC3C6EA9B485EC0D98B0AFDEED548406FCC6A7697485EC034482296AED74840AAC8912FF4485EC0CAA66EA142D948406B26F56E4A4A5EC0B849C1564BDB4840C2519638774B5EC090B7EA1939DC48401C2FE69DE64B5EC03D50C8277CDD4840460C6328B54B5EC07B407F813BDF484015BB0691E64A5EC0543028D1A9E04840817F0929CA485EC0FC8D0CD5A1E2484045960BBE6B465EC0CE8D064B33E548403870D35EC9445EC01B0F55CFB3E748407A9A91169E435EC02D195ED8DCE948409BE4C98B98425EC0EDD16A3741EC48401625BA89D7415EC08AED60E589F04840516BC17951415EC013D94D9714F74840997548BA0D415EC0844FA994FEFA48409DE47886A0405EC027AF8C41080049406AC93BCA61405EC0824F3BB7CB01494074FA37A9413F5EC0FC06D5A613074940B79501AE153E5EC0EB2A8641440C494009137510D33D5EC06CAB86DC770D4940F1A1F20A8C3B5EC09ECDE9CB99164940918172D2693B5EC08A3E6E9E66184940339F0A0E063B5EC056942B166B1B49409F03D45E483A5EC0A477C004DA23494058CD763EF4395EC0DD7B37DF4E294940057A3EE80F3A5EC0F413F67CD92D49406AF60FE3093A5EC06652DA28EB2E494095790EC3593A5EC03627143EB432494022F5550A783A5EC0A9AA4EB7E83749408DBFCEE6BE3A5EC0D49866AC2E3B49402B54A579FE3A5EC0F6EC5E47BA3E4940C3EF3247AA3B5EC0D98D627347444940D8D3D45ED23B5EC0CE26E238F6474940C9C7E121623B5EC075CD3DE2FC4B4940AF26F15C853A5EC0642264CF134F49408A411EDF4B395EC09A0BCF858C504940132DCCCD76375EC0C743CB0C585149401D476925AC355EC0DB478C0FFB5049404FF0311F2C335EC07DC768A4EF4F494063CF1130B5305EC013CD766A6A4E494081ECACCFF12E5EC0A7E23BC6EB4C49409787B3A1332E5EC042189F58324C494044456A9F372B5EC0CAF44E69164A494000EE03BDD3285EC0A397E2979048494017A193955D245EC0F6928532624649402092610ED0205EC0579CAA2BD6444940FC28ED6E871B5EC028E23B7E89434940B1072319751A5EC0C6AE13567D4349405FEE58E9BE175EC026617883304349401C233A1A12135EC022C223D0BC4249409B93CAFB7A0D5EC0D64C3349234249406D1DFD278F0B5EC0BFBF47D1064249401975CA4DE9085EC0952F0B73D74149401A3F9DF77F075EC04476A9DAC041494008D08E1BF7045EC076A40BDF584149408601202E76015EC01FA22A150A414940643516C32F005EC03633935C084149402A6D3892A1FE5DC088278F7CE5404940E59DDF3E13FD5DC0BE19E331C7404940EAE1355CA3FB5DC08FD1A650974049400107BFB309FB5DC077E402BDAB4049401DFEB02382FA5DC071FBE3A817414940D340FC2ED1F95DC0A3D5C42AD5404940BF3C149200F95DC0DB573D09CA404940AF8802242DF85DC0968B77561441494084B4CD8DBAF75DC0033903CF634149407D2763640EF75DC0CF6608517241494065083118C3F65DC0A836980886414940201F1BA24DF65DC0CE03FFEF2A42494079856217DEF55DC05D16668B8D424940F32639D97DF55DC0BA0F07497542494008345EB6FCF45DC0DAED5E3148424940B3C9B7225AF45DC08E90BEDBD04149405C091ED4A6F35DC0D98E114DD5414940FC91F1FF7AF25DC06A21AFB48B414940A6C38B3E42F15DC0E196173508414940A460171364F05DC0D56AB45C6840494048374EA40BF05DC03A6CFF4CB4404940DC99A3D603F05DC00CE614CC2A4149408E2DDBCF03F05DC035FA8D369841494065080D9B1AF05DC024510FF33943494034AEAB245DF05DC01B90ABC5264449402A18E839D9F05DC09B332BA354454940F14478B4A1F15DC0F0E621D0BF464940A669F37209F25DC0FA570AE0F4484940F829266911F25DC049E9704B2F4A49405717FAD0F0F15DC017AA40C8EB4A49408E07879118F15DC0EF191973484B4940DF51709858F05DC0C2DE322C484C4940ECBD87E7C3EF5DC07A309FAC074D4940A0CF3B3101F05DC06E465D5CB64D4940654F70D118F05DC006BCED6FC94E49400A7B2066D4EF5DC030FB75C0C14F49406B4A0231F1EE5DC009C2DAD103534940C0A46D7BE5ED5DC08AE4133212544940E587F6AEAEED5DC0C8233E7656544940B9EEC60282ED5DC03EB16F2E4F5449405CEE167508ED5DC02FB4F050AB53494080D4264E1EEB5DC0E2E2DE659251494027496691CCEA5DC092F8D820AE50494073DB70FAFBEA5DC008E87666934F494058E14E0AE5EA5DC07D3F54D6884E4940C298D7C67DEA5DC0A11354B4154E494059E279AEFFE95DC018FCCC9F1C4D49408084029FE5E95DC072B88F96444C4940CE9C82F878E95DC0F9AB4FCC674B494019BC2D0FFEE85DC05FCA794F704B494034BF4E007DE85DC0653CD37E514B49409ADD5DC824E75DC0FB91C6DE6A4A4940310C9D88FDE55DC0B8980AFC854B4940B30194EE91E45DC07967E178624C4940F6FCD5E711E45DC075AAE6AD9E4D49403F53623380E35DC0AD7DE205EC4D4940D812C343B3E25DC06F43860C8A4D4940D7BB59E910E15DC0BCECDFC5074D49408F8046DDDFDD5DC0BB967EC4F64C4940C546FEE8B1DC5DC06583BE94B44E49408BFE36F114DB5DC00E2E5A87A54D4940038362D444D95DC065C33569114E494018EB1F2CF9D75DC072ED6009484E494037E7560EC4D65DC0F3D69B98744F49401BB71B3E49D65DC04949DC9DC64F4940A7C4F19C56D45DC06BD2A2780B51494069568393BDD35DC0826512C601514940896A3F5DFDD25DC0589BF4EF975049400362695382D25DC0BD2E2FB8ED5049408BCB3897D8D15DC07AF5B50154514940A39D6F09C2D15DC0E22AD9ED57524940F8F8A28B96D15DC0C711F9C4B2524940382F6CA65DD15DC09B0B63D5B652494098E380F06FD05DC080C1A2438C524940941CC38070CF5DC04A081AE3505249402CDA2CC2FFCE5DC006FCA2DFEF51494083444D156BCE5DC0DA976D02795149405F45B0BF79CD5DC0E2847B7AC5504940DE763F29FACC5DC0AA9AE2C0A5504940674AFFC851CC5DC0D1EC5DA42A504940F1A1C5409DCB5DC09F7D24CF1E50494081DCE61E21CB5DC0440CD29041504940E046EB0EC5CA5DC0E877B26D8D5049408082ACAE6CCA5DC042B79EEBC9504940F541480149CA5DC0230CCF6644514940F51FBD4956CA5DC0D633F41CC2514940B11468617CCA5DC0681467A839524940624505F369CA5DC0954F2C95D0524940373A78D734CA5DC027C3E881325349404B9AC3ABE7C95DC0C3AAB765695449406BA9CC0EC7C95DC04F8230322E5549403C035D65C3C95DC007E6C4AD875549409426886FA6C95DC05B9F3DFEF2554940B216A2FCA5C95DC0C9EF6D7557564940E7FA2AC3DBC95DC08150725D12574940E18B730DFEC95DC02D80D849E7574940E3A46899F8C95DC072B318D34D594940DC7B5EC5FCC95DC018D6C32C5F5A494095461AC5DBC95DC084B845A1E15A4940490AEDA67CC95DC08FD4757B735B4940625F596CF3C85DC084320326395C4940E741BA1395C85DC01C35789F085D494067F0986AD4C85DC0342F0A7F065E494084B79AF902C95DC0E0DF483DDC5E494005A982124BC95DC08405D862E65F49403CCBCEFC59C95DC0539C405187604940A32080192EC95DC00C9CBCEFE5604940A03813E2A8C85DC0AB2AF54FFC60494063EE65381BC85DC0315D4D571361494081D217495EC75DC0E225ACAA31614940CE899154B1C65DC089AA396B41614940C417E8F6F1C55DC0FF0C89E74F614940722BD31B2DC55DC02075EB604E61494011D78EE4CFC45DC057A90E87AD6149406134E0713FC45DC0A29684EC3B6249400B3633AAF6C35DC031DA0EF6FD624940B339C0517DC35DC05F80D7574164494068EB36D609C35DC09D7BE6D57365494018FFDF9553C25DC07C983B1913664940C2C00F15BBC15DC07A8118A481664940E1A541798AC15DC0C3A5BAF60267494077C7EC7E4DC15DC0621B5E8FCD674940DA3A208C1AC15DC0462ADA54856849400AE34E5ACBC05DC0B375D8A60069494042C6293655C05DC041E2A1583C69494036153EB277BF5DC0875F5FEE34694940888A2A3FD0BE5DC0558D404806694940CB42E46B7EBE5DC0A6F7641A9F684940A89F4A07FDBD5DC0C56788BC57684940F87E58F64DBD5DC031334D9A4B684940EF3E8541DEBC5DC07190E05FA5684940228D061E4DBC5DC0727481393B694940182CF111FCBB5DC0DB471BE2506949404ADECC23B5BB5DC090B5F4C12C694940BA20CF7751BB5DC0CAD20FC8FE68494088B669B2E8BA5DC016B8F23FFF684940CCBA7E1DACBA5DC08914BA7FE768494022081D5358BA5DC0BA72B8E7AE68494063532B85BBB95DC0F85C1302EE684940B31F59BA75B95DC00D7010D01B6949406F4C34B31EB95DC05C521A162D694940746117076CB85DC08E632E6572694940C910615400B85DC0372AADE5B469494007B5CB22D5B75DC09AE767F6FB694940C868BCFFB2B75DC028C68558016A49409DEA73F532B75DC012E0AB4B6D6A49404FE82C38B9B65DC004C17DC7D56A4940C90E76417AB65DC06868332FAE6A4940220166DD04B65DC0848682326F6A4940B2E596C7ABB55DC0716127D6686A494028FA3D1331B55DC065DAF9285C6A49407F0A54A497B45DC02CC072BFAE6A4940DCE82290EAB35DC019E03CB9B96A4940CE7DEF2CA3B35DC0996A09A53B6A4940AEA9150F69B35DC01A877955ED694940A9A7E54BD7B25DC0A3904507026A4940E33B380417B25DC0BFC4325D616A49409AE4795331B15DC067C7B0A5C96A494030E93B7DE5AF5DC0519CE34A996B49405B3E72084FAE5DC0E42084EA596C4940C5F6453CB1AC5DC063AE4EE9EE6C49403C3E61CB07AB5DC055A192CA946D4940E027E0257DA95DC04D3E86A6206F494069EB3C5544A95DC06542C897027049406121A8E2C6A85DC084DF5634FC71494079C5ADE162A85DC0E2BA38F192724940F6F03AC33FA75DC0DBEC430932744940A64D44C59EA65DC0F6D9AACA057649407CB1BB7866A55DC048EA7FB74F764940B294655539A45DC07E3A9762937649403D720C6FD1A25DC09A6B461C3777494091CB911516A25DC0F327C1772278494087C1F59D4CA15DC046BD14A470784940F3D4D0323DA05DC086EADAF0C6784940B0C6D714BD9E5DC08F9282F2DB784940828B7297C19D5DC0ECFF1215747949403B18BE04F99C5DC05D574B03ED79494028E237D7B89C5DC037CF4283AC7A4940C9BDF4AC5D9C5DC02D74BAACC77B4940E7D5FA9A989C5DC081597679797C494024C05B54389D5DC004FCD4953A7E4940994391A22A9D5DC04B1E366D657E4940CBCCF301CC9C5DC0F3860D83287F4940514A5175A39C5DC0270DE6F6667F4940A6AA237AF19B5DC0EE4512462D804940F5A95CBE109C5DC060CE6F8DEB8049409A5B82A2F49B5DC027A4E1DD9D8149401E78E6506A9B5DC0E5595CE475824940D189CA1CC59B5DC09CA535C3928349401ED3A123339C5DC023DDBFA3FA84494031B73878289C5DC065378ED9848549404F2338A1199C5DC0689AFF238B864940A8A68D686C9C5DC06334B0A359874940345982CEA19C5DC0ECD4C748F287494097971A31179D5DC07E5295D877884940D61F612EED9D5DC02C43CB05A1894940A3DC289D5E9E5DC0350482EA1D8B4940F959C5447B9F5DC080E061F0708B494073CDF94CA59F5DC06154D1F8A48B4940FCEFF15B769F5DC0185732989C8C49400D9B14190CA05DC0AD39E540818D4940B176D56518A05DC0C58E819E628E49407ED2EB4B48A05DC01C1392A6358F4940EDBB312385A05DC04E1D1A754D9049402E6C057656A05DC04073B1BCEF90494074EF7EDD29A05DC009CB63C3B6914940F0252D42919F5DC0CF954A9370924940CF1CED9E299F5DC0D59D7C7CF8924940DCD91AA5B69E5DC0E0008FADBE934940665EFB5A829E5DC0759480A682944940723923686A9E5DC0372CD7F4069549407229D4C5739E5DC06FEE020F5D9549406771287FA49E5DC05A55D98B809549408CAB2C7B1A9F5DC0A1419BB4B0954940B6391919B29F5DC0AB4030D7FB9549401FA6090007A05DC099844F1BF6954940AFFAEB9406A15DC002E0CF6CDB9549408799219F07A25DC024E84F8BCA954940435394995BA25DC0DC7EB6E4BF95494096C8DDCAC4A25DC0D7BB0853E0954940EB304C2335A35DC0206C6D7B0D964940AD9CA9396EA35DC0BA6DD3D775964940E6099512AAA35DC020106955CD9649409197CC92F1A35DC0A52E140E7F974940B1F15309F7A35DC01CC1B748D7974940E93591864AA45DC0766FB1C6FF9749402D9792FC74A45DC0ADD9D6EE559849403F3A66E670A45DC0EC9122FFAA9849405D7FACC359A45DC0CA8599C32099494029D3C8E445A45DC0817FD97A52994940DFC23EB511A45DC00D62A68B759949406F0E8639DDA35DC0755D296F76994940714315F59CA35DC0727D8D54A299494075214B734AA35DC09F15D2E8DD994940F85044881BA35DC07AF6F595349A4940AA83213405A35DC0DC994CED9A9A49400A7049FB12A35DC0BE8E2598E79A4940F5356CE559A35DC0C39E20214C9B49400BB2E369B5A35DC0AC7B7BDCC09B4940B2CB105618A45DC056EA3F773D9C4940F38C468D6CA45DC084619155D19C4940A9C4684CACA45DC055161B92529D4940191E343FC5A45DC03287B869909D4940E12010CAF9A45DC0DF013B02E09D4940789066C127A55DC05D7336B6169E4940101120AC08A55DC0E1B2764B679E4940337122BAF6A45DC00F060329999E4940237A9C4D03A55DC0B8406E17D79E49403A79025020A55DC085B773C1029F49407483CB7F27A55DC0C11B72FD5F9F49407B56CA1947A55DC0D97DCBADA69F494079C790F821A55DC002BF091CE49F4940436DBAC4E4A45DC0A5BA515D48A049409FD97B80A6A45DC00BE7CA7CC2A0494052BFEF906AA45DC0EFF4C8FF0BA149403E5C898EF4A35DC0A51CC91F78A14940CB623404B6A35DC0457DDD1956A1494014DFF7E790A35DC08D880C2131A149409751AA9C50A35DC07A569B8D33A14940165E6ABE06A35DC09E96AACD32A1494058A4260BBEA25DC0C9F7B33D6AA1494044C364A9A6A25DC0B0C21964BBA149409FD609B8C3A25DC097C5BF1A0EA24940DF91C9DDF6A25DC07576B4652AA2494020FBA0B829A35DC0E8D3F70275A2494011E8ACC13AA35DC01087D81CE3A24940049CF8283DA35DC0E5A6D5082AA349409CBBA17F6CA35DC05C7BC60E6DA3494014999A1274A35DC05F15E1873AA44940D41A0B735DA35DC022C21123A4A44940395154EC23A35DC009B432150BA54940D3556B5FFDA25DC049EF12C353A54940D941DC8EE5A25DC0E43FC6AAD5A54940B3338FF7DFA25DC0751279DB20A64940004C7A0224A35DC0C2AC29209BA649406A95F4B75FA35DC046AC2D75D0A649406BEE99F795A35DC07BAB3D8EADA649409E5C7553D1A35DC03B76F5AC99A64940BF55316212A45DC0405615AA88A64940022521554AA45DC0C132C8C26AA6494051799A2CA6A45DC0EBE9D39712A64940304BA737DFA45DC0EC39DB57B5A54940984E15923FA55DC052EA9C5578A5494033FA719FB9A55DC0C9307BFE83A54940FC5D9B4DE2A55DC0671BAE87B0A549405A23B56215A65DC0DD53DEBB54A6494020BE29E837A65DC000EC761E88A64940F8E324BB6BA65DC078B82DB6E8A64940F6A76078A2A65DC0E48E458A0CA7494064BEF243D2A65DC0AB8D5AC51EA749406206E181F2A65DC052BE824B59A749403CB7F7E0FCA65DC0130AC6DDEEA74940A2019AA6D9A65DC0F1396D0744A84940AD42F293D9A65DC073A92FF596A84940F7E14488E5A65DC0F5BF4601BAA849403DF0C7140DA75DC0AE167ED5FEA849408DCBBAC749A75DC0F91175A920A9494058A07F6E7CA75DC043F5490C49A949405ED148C2ABA75DC0DED5EAE0BBA94940413853EEA7A75DC0C6A27B150CAA4940A41954F59FA75DC0C892F5528AAA4940702156E548A75DC0E5637969CFAA4940CB2461D271A75DC03DB1CE8820AB49400D26478A8FA75DC01471148790AB49402ADB791582A75DC0A2EB0A0A07AC494020DDC1E1A8A75DC02FF2B56933AC4940EF0D5554C1A75DC02EDCCE46C0AC4940A5D6350DA6A75DC0F870FCA13AAD4940E9975BED9FA75DC0C3B230FC91AD4940108D8EAEF1A75DC05A7EC6582EAE49407E04997C9EA75DC05621F0434AAE49407E7C55D64BA75DC035C0247D83AE49406361A24807A75DC08C58BB7F04AF49401854875CD1A65DC0E3B918B1F6AE49405A4C087A64A65DC0DB509FF1F0AE49407A85DC3523A65DC0B941FE6B04AF49401C8632DD08A65DC05F096CDB41AF49405B738696F9A55DC052122B528CAF49406CB77380F2A55DC055C52D24CFAF49404C36C7D101A65DC09720D6A09FB0494081601283D5A55DC05FB3C676E5B04940281E4BD59FA55DC0C9B5FB4523B1494043DE4ACEA9A55DC0DC2609A46FB14940C77D6DC1D2A55DC04A05A1C8C0B14940B170FC2924A65DC066B5294A1CB24940E3A6D6EB77A65DC047D98C2E47B2494096E74F8869A65DC0234F01ABA7B24940FD7142E791A65DC05D080D7DF0B24940465588DCFAA65DC032DAC75FF8B2494093F7E5A72FA75DC0B01C207C1EB34940395256B960A75DC05783075E92B34940BD7D80ABB1A75DC079BF0F11A7B34940D1FEE917E6A75DC0364011ECFDB349403341BFBDCBA75DC093B28C5E3BB449402284DB8DA0A75DC037596A6292B44940C5D903A882A75DC0F039373FC8B44940D8FD0D6338A75DC0F3346176F3B449404B94A72E2CA75DC0E0D84C3C4FB5494035220E953BA75DC0AFF5CF4B7CB54940B0AFDD176DA75DC09DF7B4F595B54940FA6F5DB9BAA75DC0BD9616AEC7B54940A794605273A75DC018E75B9ADFB5494077D65F905BA75DC049F1BC6612B6494021F51C846BA75DC018837CC55CB64940F84A2821A5A75DC06A06813099B64940AB5B5EC0BCA75DC088D47292E6B649407293F0259BA75DC08A8F91BE40B74940068BD9C780A75DC09FDD52307EB749409E58D29393A75DC0EE880AB9DEB749402EE5173DB2A75DC0B1EE8DC6EAB74940392697A110A85DC00E07E45905B84940CC8828FC46A85DC0384156DA0BB84940E4F70EEC74A85DC08E9D4ED970B849405F9606499BA85DC0372B5326D4B84940A2CD6B05BEA85DC05B15108D2EB94940CB6AA8BBC4A85DC0945A6E786EB94940DD08E61791A85DC00F38EF9180B94940C51AED4E80A85DC063E7BBA3EAB94940AD46784E64A85DC03740D01D4ABA4940A308BEE46DA85DC043ABC2BC76BA4940445D7050B1A85DC0C92008678ABA4940C578CD4CE6A85DC0D4C7AA0FAEBA49405DF3400018A95DC08837F6CF9BBA49403F03446286A95DC081F8D74D9CBA494075CC9706CCA95DC0436F764E58BA4940BE734FE62DAA5DC0F4C63AD77CBA494035BB0B5487AA5DC0634900725CBA494014E848CAC6AA5DC088117AD2F5B9494056029B4FFBAA5DC09E47F2A34CBA494072C4054232AB5DC08CE84B6970BA4940406A5F2A7EAB5DC075E8C80476BA494027A6FA67D5AB5DC05A26DBC583BA4940E7B33CC616AC5DC0FAAE1798ECBA4940451CE94F25AC5DC0590434152DBB4940EEB6069F42AC5DC065B88FBB7FBB49408F3EE8EE5FAC5DC0B20948EAA8BB4940F3D318C0A0AC5DC0E62AF4F3CABB494062DEA146DEAC5DC0EE9BB71F13BC49401BB0389815AD5DC04C2F95932FBC4940AA88164276AD5DC0A2C8E84C45BC4940BFAB9211C1AD5DC05A6FA119B6BC4940681FDD9417AE5DC075F1303751BD4940CFA0CC7428AE5DC098F65D7ADDBD4940FAF7B9FC2DAE5DC0820D8C9761BE49405BC0A872E8AD5DC04EA9CAC679BE4940EA23DB1F9FAD5DC09149423D8FBE49404C8E662540AD5DC0D5A165FCA7BE4940FF388B7C3CAD5DC03707D9C4F5BE4940938697BA14AD5DC0E953E9632DBF49401647A80CE1AC5DC028202C8C3FBF494094840B6AA7AC5DC0440BB7B453BF4940FD75AAD690AC5DC01D6BD4E693BF4940324956B798AC5DC091852D3DF5BF4940C541EF2EF8AC5DC0B194A9A578C049402756254160AD5DC018B1F4AB98C04940D90298BFB8AD5DC07C0E4702E1C04940DE01DC3C06AE5DC09E5B556FF0C0494065F549452BAE5DC06F49359B1CC14940D0CDFA0B39AE5DC01CF0821A6EC1494078CBD3A44FAE5DC01262C64AAAC14940B27AD4D78BAE5DC0F031D607DDC14940A511916CDEAE5DC0BF52D0CF50C24940509971E11AAF5DC053D2F824A8C249401EFB615466AF5DC006FD09D5B9C2494001282278D0AF5DC0643AB18E45C3494031E803DBEAAF5DC080308FFC5AC34940DD8EC1EAFEAF5DC00E872C3F50C3494030EC0DB804B05DC0C13989BDFDC249401BFCD29972B05DC0F113A63E78C24940201481B019B15DC01069C6B311C2494072CC436D42B15DC0532039FD42C24940E1940D8463B15DC0C074F1BE9AC249401F422C75A6B15DC01AE21CC60FC34940991E9128E7B15DC05C64646AB5C349405CC4377A01B25DC04A76D6B9F6C34940E3C224A32CB25DC010699C6B1EC4494092CE7CD758B25DC0EBB58FDEDAC34940EAF6CED181B25DC07E44677388C34940722F5701A7B25DC0F5DE025233C3494066D12F43E5B25DC0DB36BF66BBC24940E87C59902AB35DC09D13AE857EC2494020BCE68A76B35DC0AAB0B1815AC24940637367C4BAB35DC0FEB5A2645FC2494042FC65E3FDB35DC06BC9573827C2494032A4B9B40FB45DC041267C144DC24940DB0A089A23B45DC0E3158763A2C249406BBDF6BB2DB45DC03C5E5942C5C24940419590B58FB45DC0F44C6CF6EBC24940C030F2C5D2B45DC0E2774CACDFC249402125E4B941B55DC0613EB28DC0C2494039457D7341B55DC0F5F73C50F1C24940CDB99D8A4AB55DC0FE6B7CF555C349400400988A5CB55DC00E3335D9A2C34940E289BCC772B55DC01AF6ECB8E8C349408C00526963B55DC0CCEBF31D38C44940435A818560B55DC0B15B055377C44940E597825569B55DC0D9CBAD5DB7C449401DEBB10481B55DC00626BFA2DDC449407528A5117BB55DC0E8D7E40335C549403E0483077DB55DC02F08FC848AC549404422302153B55DC099AC42F4C6C549409CD3C83E3FB55DC07FB4851F4EC64940E94B02844BB55DC03799684020C74940DFB9A0C03CB55DC03C81A6F48CC749404AED28245CB55DC096203D36B6C749406EBA1C525DB55DC08D40C6BB1CC84940768971E04BB55DC09EBD786B6EC84940F249969968B55DC033E37605D2C849403EC29AD667B55DC0B12AFEC48DC94940C043DC7C53B55DC076681B4CC9C949401B6E8BC26DB55DC011688B040DCA4940BAE9D64E4EB55DC009BDFFA80FCA49401FD0DF4E5BB55DC0FA2D339574CA4940008CDD2E57B55DC0234C5FF8EFCA494030615C9B0CB55DC059368B84C8CA4940920AD207CFB45DC080A9889EB0CA4940A83FE5A598B45DC09893F153D1CA4940E5052C5D8AB45DC09B6EBD6708CB4940A6C1499194B45DC0B9C7DCBD54CB49406F1D630389B45DC085E0B74ED0CB49402785C7DC74B45DC01337BA545CCC49406F58346263B45DC005EDBD5F03CD4940F4D698198AB45DC00ECD4FD162CD4940E33E3D46A0B45DC04EDF7BD3B3CD4940B3AA057DA0B45DC0196416B159CE4940579F2CB9BCB45DC0A82CF28E9DCE49409A5A900F8DB45DC06806CF3BABCE49406F587A877BB45DC052AA2472D3CE4940A20405F76EB45DC0756D52860FCF4940B594F89B55B45DC00DE0F88A8CCF4940BA3AAA235DB45DC0E28F09DCBDCF494035649B8187B45DC01A2F4AFAF8CF4940E06307F2B5B45DC01925B4685BD049403F625AB8CCB45DC0D68F0F08C1D0494025EC4627F7B45DC0B85F423FD0D04940385AC3CC1FB55DC048C97EFEB0D049402872F51279B55DC0721F35139AD0494053990BA0DCB55DC0A9C9C394A3D049406A5CF33B29B65DC0983BBE28CBD04940EC12A1A45DB65DC02E9B716225D14940DFE61517A4B65DC0084B4D32A9D14940512D414EE0B65DC09E641DACE0D14940324AB68045B75DC0C7FD3993F1D1494087038EAC97B75DC0B4E209D520D24940D3C00E8BB6B75DC02960B0DC00D24940B52AC464B6B75DC026527EEDADD149401EDE370CB9B75DC0E30A829473D14940FEDAB908F8B75DC079DE63426ED14940C0ABBBE826B85DC06F3B72759DD149401815C4825BB85DC0D3B0AC65FBD149401E87D7FEBCB85DC0E8FDFA0533D2494071FDED9529B95DC0EF9DC8254ED249402AC1501C5DB95DC08E5D0163C4D24940A4CF38309BB95DC05DCA5A492AD34940E6E0B91805BA5DC05B48075F2AD34940571A86D00ABA5DC08659010385D34940D433DCCA26BA5DC0B4AF4E08FCD34940C790102E36BA5DC0014EFDF890D44940AC00B0E463BA5DC04AD0DDE3DAD44940690B112648BA5DC0ACAFCB1238D54940CEF4B2F07CBA5DC0811F25A767D549402319C74799BA5DC09A0FC97AABD5494077BE1454B8BA5DC015B703520AD64940002BC856EDBA5DC0DDD7A7EE60D649400A70E0F248BB5DC0FD8EA7849AD6494025A6EAEB70BB5DC015CBF47B0DD7494093BD725376BB5DC08C0D9D509BD74940E2ADE4CF70BB5DC0AD78146F19D84940418DCF4A6EBB5DC0419FDA407DD849405E8C55FC94BB5DC0F9CA5E98B5D84940F03083CD78BB5DC0627535831CD94940BC45940441BB5DC0D72C8A962ED94940D15D5D5BF4BA5DC00C87659330D9494034F5BABAF1BA5DC0C2D2A9ED6AD9494080DBF525D8BA5DC048AB3163C3D949404748752DC1BA5DC03E330F650DDA494020B77A0FEFBA5DC03346D1F928DA4940C5ABB49503BB5DC06DEA462798DA4940E4EC1A0717BB5DC0FBA4D6BEF3DA494034F6662811BB5DC0B3E7022293DB4940D944A9FAD5BA5DC01F1B83C598DB4940021632079FBA5DC0ACB57649C3DB494038BC5D854DBA5DC0FC62545604DC49406893FB72F7B95DC0048D5CCB27DC49406EA6D196D5B95DC0059244865DDC4940FE9A7F8798B95DC03275C2798CDC49408FEE5D3143B95DC0F4FDF2CBCADC4940B117EB1330B95DC0D7C036F740DD4940EAADFC232FB95DC0DC71A936ACDD49409582E53DFBB85DC00ECE9DCA3FDE49407B0603584EB95DC060C62BE689DE49402B08526322B95DC0FD1DEC981BDF49407CF7FFDC4CB95DC0A28D7C000BE04940F44164CB71B95DC062F5F22996E049401CB6EDF79CB95DC02896188BEEE049402A41E61698B95DC07320016A85E14940A7E616A579B95DC082F96C09F1E14940544100602BB95DC00F109C626AE24940F6DCACC628B95DC00545C019FAE2494030E6BBAE4AB95DC042EF368A71E349401E63892F54B95DC06D61D6BBE1E34940AC405F898FB95DC031067A9605E449404DEFF7C4EDB95DC027295EBA09E449403CCE6A9555BA5DC001C4C56713E449408263FBFAC5BA5DC067608E6564E44940DA9F701423BB5DC07861418404E54940AB289A5A51BB5DC03E047F9970E5494002918540A6BB5DC07F3DE5643EE549406E0D11C608BC5DC0EA7A67A9E3E449409893D9B8AEBC5DC0A22F1168A8E44940B417B8D9C3BC5DC026AB785137E54940FE0A88B6DBBC5DC07B038F58B5E54940D7E47565F1BC5DC057DF9E330CE64940532D35D419BD5DC014E7F4F54BE6494096BB11C544BD5DC0882546CC53E64940CB19C7559FBD5DC0D5F66A8992E64940FBB26C6FB7BD5DC045A79DB20BE74940734FD219C3BD5DC047F0AFD63AE7494019831397FABD5DC00E80065B5EE749400407DDC0C4BD5DC090F599F7C5E7494078E7BA87BFBD5DC09CD6D8C50EE84940273D0A30C2BD5DC0C1B4139574E8494055F1344CE5BD5DC0DD7DA5DF7BE849403AB4601E00BE5DC0623624598CE8494052AD49D925BE5DC057DC0015B1E84940E43E7C0928BE5DC0B60ABD40D8E84940B61C84F309BE5DC07EDA46B810E94940737CF2AABBBD5DC07413695D32E949404C16AF0F5BBD5DC00BB5212CB9E94940973053943FBD5DC0B7F5C447B7E9494059FFEA400ABD5DC0D98E4EECBAE949407AE45D69E4BC5DC0528CBE68F0E949409E820C48E5BC5DC05861D0C134EA4940C8D9E157FFBC5DC0B0C1214256EA4940A7F01EEB1BBD5DC0FA6E70A397EA4940840CDD4B2BBD5DC014A22FD0F7EA49407E13A2760ABD5DC0300DC72741EB4940FC70F4750ABD5DC0D473070E6DEB49403A943EEA15BD5DC0AE8B22F5CCEB49408437CA4426BD5DC098E513A95FEC49407DB5611C65BD5DC0506496FC63EC4940D864803AA1BD5DC00E27803179EC4940B3263422E3BD5DC00212EC21BDEC4940FCC2430A01BE5DC008D9A03A0DED4940F9AE3A2974BE5DC03842403226ED4940AFE1CCD99EBE5DC02778B21C8DED4940BB89376EAABE5DC0F25557AEBEED49409D57205ED2BE5DC0125E33C8B2ED4940F867173A17BF5DC010C63D0DB5ED4940768F559D4BBF5DC0A580ED43C7ED49400CD1F16290BF5DC0864CD6DBF7ED4940ABCA83E699BF5DC06B7B13B92BEE4940DE2E3A82BEBF5DC0B1064E1697EE4940B12A6DE7A3BF5DC0776E578FD9EE49407271C0FBA0BF5DC09044CD351BEF4940A1C0FCD660BF5DC079941896A5EF4940220FFB3F32BF5DC0A6450302EEEF4940C76A31B4DABE5DC02D674D6900F04940E8BF3B667BBE5DC0918B08D60FF04940778BE3C627BE5DC0B8F9FA7D22F04940439FD7751ABE5DC065B7E7B843F049408C0122B33FBE5DC0C443689D74F04940E49B74D02CBE5DC0C456B2258EF049402D9FFC5715BE5DC0EAC045FFB5F049409D9105DC11BE5DC0C9D80CCD03F149406718931A2FBE5DC04180E6CA41F14940718F0A0F39BE5DC01823BEBBC3F14940E99F195E5BBE5DC090F0774536F24940F3BB491F97BE5DC0A776341781F24940448AE93AA5BE5DC0234A5289D2F249403B6E276797BE5DC0945ECA85AFF349405C2D1753AABE5DC0081501B019F44940DBD1EEE7D0BE5DC09879394C59F449409E66EFD816BF5DC011389E7C9DF449400BB77D4912BF5DC047ACF99A03F54940FB931DF410BF5DC01E9824F050F54940AF6AD1E00FBF5DC0AC5DBD2695F54940753B1FBD7DBF5DC068C8C1C3FBF54940B998D84282BF5DC06754199373F649403DDDF49A4DBF5DC0E28B3206BEF64940E339CA3C0EBF5DC0A65C973F1BF74940A43007A8D2BE5DC0622BDF78F7F649407D89C44D68BE5DC09D361FA2F2F64940A541B7642DBE5DC053906C0E18F7494058CE07F112BE5DC0DB47D0DAFDF64940C4760B44D0BD5DC01763AF66F4F64940EC5FC3F57DBD5DC088B73188BBF6494023583AA048BD5DC0F5AE17D890F64940DADE5781DEBC5DC0FD1D05335BF649409D6418DDB9BC5DC0ECCED75AFBF54940A5214A5291BC5DC06812AC7CE7F54940F7D57C9944BC5DC0BDC433170EF6494018CD250F01BC5DC099395B0E18F649401A31C084C4BB5DC0D8D96A1D0AF64940F903D4157CBB5DC055924CE2D1F549404858A80537BB5DC0520058F9D1F5494032482561B1BA5DC0B391EB41C6F5494052F44A0A6EBA5DC0952E433BF7F549408A75EF922FBA5DC04E0095636AF64940EC9C944410BA5DC0F6C54121BBF649409DA85145EEB95DC01A43E1F4C4F649404D6BADB2DFB95DC054C0B5E900F74940C492DC0ED4B95DC0D407C60553F7494035D7664BCBB95DC0C3FECC578CF749404A850FAECAB95DC0FA6F0D4BF0F74940CC13B316C2B95DC03E496B2056F849409F351D2A91B95DC0C4909D32A3F8494003DDCA9251B95DC0EEA777C002F94940F2A2D9A726B95DC089183CCC4DF949408A04946525B95DC001310C7094F94940F4F1ACCE5CB95DC0D8E6D2E3BCF949403776B6CA99B95DC018D7C60BEDF94940718A2E729EB95DC073D02C1934FA49400CF3143706BA5DC0AFEAA78647FA49409B0D407034BA5DC02B9926E77BFA49407AE7F3393EBA5DC014872E62D4FA494030854A99A4BA5DC0A0855D80DBFA4940F2A8914AD3BA5DC02C85FDEFEAFA494087F4C768F4BA5DC0AFD5B77320FB4940D29D2DC531BB5DC0888B48641DFB49402CB4662EA4BB5DC0C1F19D7020FB4940D968CA2B2ABC5DC05BD0AF4327FB4940DF035EFE7ABC5DC0B1439D4D56FB4940E766A6D5C3BC5DC0A8D9743987FB4940B7DB839A11BD5DC09FBE856DCEFB49401EBFC14566BD5DC0D31A5B40D4FB4940EC52C900A2BD5DC0BCEE2F9FF5FB4940AA8C2B4127BE5DC083826B4B39FC4940EA4320AC7CBE5DC003AB224165FC494064BA971F61BE5DC0B54E3AF612FD4940D6FBF13A3EBE5DC0E4FEDD1288FD4940D9D9482611BE5DC07A2848E7D7FD4940261F465D19BE5DC0ADD2B2F228FE4940590BDE9902BE5DC0B0A99CAC6BFE4940005FACB3EDBD5DC0E220B5DDDCFE4940895B64C7FEBD5DC0F13F749118FF4940E8089F2DDDBD5DC00F25A39944FF49405ED90105B4BD5DC04EA82DE63CFF4940A1FF61B486BD5DC0EA64A5C939FF494083008FC44EBD5DC00EFD010447FF4940F75467EC10BD5DC0B8767CD553FF49409A31CDECFFBC5DC0781303D093FF494052C871D1BBBC5DC04398084FFFFF4940050BFB97BABC5DC0D5A80CD971004A406C9825CB9CBC5DC0B32E2478CC004A40E72F4F0095BC5DC07CAA7B4A21014A40F9A1DAB092BC5DC06BCED05854014A4050C0EAB997BC5DC0AE63833468014A40D99E0C00C9BC5DC0376C9E996B014A40C7DA2C18E0BC5DC0A5124848A5014A40DBC8A517E7BC5DC06570962CE5014A4008956404C5BC5DC08D1E9CD146024A4082F822F399BC5DC04224823BC0024A40B4325E424CBC5DC057CD64A44F034A401B0D2075E9BB5DC0F594C236E9034A40DFD525FDB2BB5DC0FB4EE62C2C044A40B07A920449BB5DC0EC6FF37170044A40F6C1F464F7BA5DC014D53DDC7B044A402C42570CD5BA5DC0774B3659E2044A4025C6E5BEA1BA5DC099F9ECAF0A054A40739647EA7DBA5DC071AADA830F054A40BE30F9865FBA5DC0C1CFF75F4A054A4060A6EEE35ABA5DC04E51A19584054A40267A06D3BEB95DC0427F5580AA054A40AA6C84998EB95DC011BDE4A6BA054A4018D0DEC21CB95DC012FE04C627064A4078FDDD37DFB85DC03815B3C839064A40A939F4496DB85DC06CC2AC6B7D064A4082725B0403B85DC03583BA74C6064A401B79D2ADB6B75DC0D968ABA05F074A40DFB603D7A1B75DC07052D1E9CB074A40F765E17BD1B75DC0F94FD4D6F3074A40B1FCAB69F7B75DC076857E8C4B084A400157341F0BB85DC0166B5130CE084A40F325C4A7F0B75DC054A73FAA5E094A4051423B45BBB75DC0C6AF30B8B2094A40DBE301C762B75DC09EBFD967E1094A4087F2DE2A3FB75DC0B066F171290A4A40F2EBFBECDCB65DC0222547C49E0A4A40F1DC414FCAB65DC00226B81ED40A4A406038518202B75DC0040D3186310B4A40F4A49CEB5EB75DC035F0D478910B4A40D9A51E2F77B75DC085503BA8E70B4A40DCDAE561ABB75DC05DB70FC5440C4A4023E866D8AEB75DC0734F8566A80C4A4007BAB2B564B75DC091B8166E1F0D4A40C45CDC564FB75DC017023939900D4A4055251D3D42B75DC0056A76A1FC0D4A40914D6B92F7B65DC0B35FDC31B20E4A40EB26CD59AFB65DC002CDE811560F4A4034102435ABB65DC03440D839AF0F4A40B09EF710CBB65DC0F3D15DE30F104A4095702A7DCAB65DC0817F403C73104A40019537D38CB65DC0C5488630E1104A40C5240A1350B65DC0F3A3F9523B114A4071F7ED8302B65DC073E9012EA3114A40675C8E6FAFB55DC0D0C615F9D3114A40CB80271EAAB55DC0BD5608E545124A40295BC949A9B55DC012258331AE124A40966AAEE5AEB55DC04861A6BB39134A4027DE1FDE91B55DC04B57C409A0134A40698F25D8A1B55DC0B3E51D9EFA134A4066C50F20D6B55DC0ACDD4E7A67144A4085D204AF76B55DC05D73F55C9C144A40B63402C215B55DC0DAD13E799A144A40575AEE9FE2B45DC0B0EF617BD2144A405E0DF3A183B45DC01B696B70FD144A40E332B36A5BB45DC0A14E25104F154A40F487553FFAB35DC0490CE21852154A40AA1430AFD0B35DC0EDC56719B5154A40C3B06EA75BB35DC04358EC3606164A40CABC565B33B35DC085B3535703164A4090E025D2EAB25DC04884252AFE154A409360E8799FB25DC05B687F6A34164A40D7E2D48051B25DC05F110EA84C164A40420B155FE1B15DC0DEC958B735164A403EC9F7E377B15DC0FD22340F3D164A403B12E7B312B15DC09A68913594164A40DA4861C39FB05DC047CCAB250D174A40C07851EB4EB05DC04C05A74A0C174A40D6C7AFCBF0AF5DC0095B77D6CE164A40200B437798AF5DC09E6B489B8E164A40D3A6EFED6FAF5DC0CE46D8293C164A4074A1A08540AF5DC05B6A765FD0154A408EA513AF1DAF5DC0FA78B48C5B154A40A3A39F3E2AAF5DC0B49EFE09FE144A40AE8EF7FD37AF5DC06B0995C387144A4052803BB60FAF5DC071D08B5D30144A40E967C574D9AE5DC072787639AB134A40796C01404CAE5DC0F9B73FF2A5134A40BD127E5E13AE5DC0EE20333C00144A40D9C03A6BB7AD5DC01A6DBD1E3F144A407CA4EA4483AD5DC0F48BD9D58A144A4078FF6D322EAD5DC0FC2AA3928E144A40E5C55B94F0AC5DC0EF9FD9ECA2144A40B0C293A2A6AC5DC019F89F57BB144A405D7CA78180AC5DC000CB41D48B144A407E1D084473AC5DC010EC90394F144A40D9BBFDD76EAC5DC072C964DFAF134A40E5D2F51648AC5DC04D146540E6124A407EE1221F1BAC5DC0033472629D124A4084FF3A2CA9AB5DC0EACFB4E1AD124A40E0A5C82046AB5DC0F794204FD8124A4058905CD01BAB5DC0D0B3FEECA5134A40A1DE5E4C1FAB5DC0B7D31C9B04144A4017B1C08FECAA5DC06A29619232144A40D2C4E0917FAA5DC074680A852F144A40CD1DFBE534AA5DC0267956BE56144A40DA3240E8D0A95DC0EF770F9975144A40CE8A3B62B9A95DC0BB86BB6FB9144A4048E6140A60A95DC0A3E365BEC1144A405A2A7A3D05A95DC058246CC0E7144A4008811381DBA85DC0B8BC9F7A02154A40AF033414D9A85DC05A81E1FE33154A40B42AA58AB2A85DC0982A555AB2154A40CCE35C8670A85DC0BC2813C31F164A40171F298A7BA85DC003C47AF188164A40686395924BA85DC0DBA8F4EDCF164A4065D1E841FFA75DC0D9AAD74AC5164A40B5034A7D91A75DC03ECEE501D1164A4025645E0E45A75DC050AD5FD51A174A4000AC896317A75DC0B01BB8C384174A4033DDCE1495A65DC09D8E6560E8174A40A007174DCDA55DC00851E9A5B6174A407A8E46FE40A55DC08DC7D7389D174A40E7F98BAB58A45DC023C4936C1E174A400A4E6D7112A45DC0BE30FFEC3B174A4041FEAF76ADA35DC01C19FC4739174A4080DF4B0611A35DC0C75AC6F5E8164A408677B6BAC3A25DC0DAC6C705F2164A4033DDA61985A15DC0748604C83F164A40F40A10DAD3A05DC09A9CA94932164A408A7BA97F36A05DC002B43F402B164A40B646D702CD9F5DC09BA0371932164A4095CF647CAB9E5DC0DCF16CF711164A402457B5D5299E5DC063C28C64C7154A40743D09AB369D5DC009CE02F482154A402B44F6EF719C5DC0470658E73C154A40DE70B625FD9B5DC0A6AE95DB33154A402B71FD9A9A9B5DC0DF995D913D164A40A841B86CFD9A5DC005022766D0164A40EA5792B228995DC00F1308D89C184A40EFB8F9907A975DC002D357CE50194A404C7154CA2F965DC0CE62D649251A4A40AB22A8381D955DC0E6101291B31A4A40008DD91D0D945DC09929FABE981B4A40F783119AE1935DC01B2BD714051D4A4043376D4358935DC02B055AEC3E1F4A40EFCC9E3F2C925DC02460BAED4C204A402466D4D144915DC0D83BBF121D214A40310F9C777E915DC04D803A336C234A40CE0B1CBED0915DC0D988B33E1E254A409942597559925DC041B0090879284A409B75A69930925DC0AD6C2386932A4A40F529AC08C5905DC04033AE4E192D4A4000B71C09288F5DC06253E1C8ED2D4A40F4FE74B5198E5DC0B93A259A892F4A4068EA1B0DE08B5DC00D00395E48334A40FE3EF111318B5DC06DF198616A334A40C05E6E179A895DC0B86297DCEF344A40376D3B8DB4885DC0FAF9939D45354A400E6419ADA3865DC069D53C23D8344A40213707D330865DC0DE54E6DE8A344A40465629B341845DC07415D760A8354A40BC690D54C6835DC0E11EAE2094374A40C0BF1B8178835DC06764FAFE943A4A4043630057B2835DC05DCE0E03243C4A40506D82902C825DC0F0484C7DE73D4A4038C31E6D1C815DC08EFB20BEDA3F4A4044BC560E2D805DC03613159C88404A400C5FD734EF7E5DC06EED2F01863F4A403E95B3B5BE7E5DC0C1DC331F9E3D4A4056986D90497C5DC015A8091E6D3A4A40752D0747C9795DC0756A5DE3C1364A40C078836E2F795DC01E9605FD13364A403C965A12A0765DC031AECD3BDC344A40387D8E7A88725DC053BA8ADFA2334A400E003D31EB715DC002F3F15B02344A40D93CC6724B715DC0EED2351D8F334A4081C392B3B06F5DC02650BE7DAB2F4A404C2B0CD28C6F5DC00386A7C22D2F4A404876F48E53705DC0C3A553FC6D2B4A40565F1505FA705DC0CF2BBDDCB52A4A4049782CF697735DC00B0855A27A294A40DAFCDA8F14755DC0A9EA97C211284A401947C86306765DC07EFC462157264A40FCF3E8305F765DC0EAA82D3FFE224A4044E43F00A9755DC03222D062B71F4A407414D2E80E745DC0B839739DD41B4A40388AC6E1CC735DC08D3B465C8E1B4A4095BF9912496E5DC0901E5CA3731A4A408F2082CF0F6D5DC09347561E321B4A4009E2F8AA956B5DC072F024DCB91A4A40F5020E8E92695DC05CD3A1DF4C164A405609D7AD9E675DC0C34EF1DD3B124A404C913C53E8665DC063303E7EC4114A408C208DF84E665DC0DDE783DD05124A40BF9519EC86635DC0F3833C83DB144A40D93248CEC25E5DC038ABE9E3F6134A402FEA2E09505B5DC00955C5601A144A40CB09144E0B5A5DC09F27CFFE5C144A40125EC1D4CF575DC04B32EE5F75164A40CEE8B5B0A7575DC045F832FF04174A40D2F3ADADD8575DC0333205FDA1194A4059CF1EB116575DC05AFC0243721A4A40DC0D4712BD565DC061C97C41271A4A4060BB26EEB1545DC0EA50E87FD5114A40F9B97CFCDE545DC0C54572A0A30D4A405DE411B402555DC095C20F205F0C4A40CFB748EBA8545DC0035817417F094A40B9AEDED781515DC01DB1086327064A40DFB35A7380505DC04A48AAC3ED044A40B43ABA97344E5DC022C10F7F30044A4005E3602EE24D5DC09B0A7D60AA034A4089A635E1974E5DC072D53A5C8E014A40E95EA849294E5DC0DE54215D4F004A404FB502AE644B5DC040EDED222FFD49405DAED188D24A5DC06CF315A050FD49405E8212289B485DC08ED439C24CFB4940B715B9DB2E485DC0D5A6D4FCDBF949409CF5235ED7455DC00066153E05F649406463917A88425DC068DDCA805DF34940AB429EB168425DC022508AE029F04940D3D1E0EF50405DC01D1DEEDEFBEB4940EB07E259BB3F5DC08C3D9B9C4BEB4940AD032A016A3E5DC0B87E2BE2E5E749404D104FCD1E3E5DC0D1BF4B3F52E64940DB01B0CABE3D5DC04D02429CF8E24940D43C895FEA3D5DC07A1A51E179E14940D8C61CB2BA3B5DC0B67D71E046DE4940A6AC8AC9543B5DC0547FBDA2CCDC4940CF2817A9FD3B5DC0A8FBD1042FDC4940AEB813FD423C5DC0FB125E9386DB4940D6DACCB5753C5DC0C602FF5187DB4940A6F8BA87AD3D5DC06E1728F851DB4940E214B19A8B3E5DC0E30D0B5E2ADB4940328F58FF543F5DC08F0A239243DB4940DBDC32EF68405DC07377DF72E2DB49408B2796AE34415DC028E9C971EADC49408FCA73B1BA425DC0C2EE37B304DD4940A4299C353E445DC04AB687BB08DE4940AD4BDAF8AB455DC0F39701B612DE49401B5E346D67475DC0C77890021CDF4940B68C6C39D9485DC033CF6F02B1DE4940CC1B67A078495DC063F0F69394DF49409E9C93532F4A5DC0803249C7DADF4940D7A1436DBE4A5DC06442F4EA19DF4940576D3B970B4B5DC0425AF4849ADE49406FB6B0E4A64B5DC057DE73E434DE49402643123E784C5DC0D6B7A099D4DD494085B37B3F4F4D5DC0B286B06E36DE49405A0BBD16604D5DC0438AA28BD9DD4940D16B9680954D5DC0C04FB6B306DD494005E28797074E5DC0C2D6BDDA42DC4940DAD9CF9A9A4E5DC05232805424DC4940D1DEDCD63A4F5DC06C290D70FDDA4940EF5A5A2B85505DC024C4799D2ED9494047B9886022515DC0CF752BA81DD84940F13304626C525DC0D3E9D283FFD84940C462D57B37535DC0B6AD20F31CDA49402136D4BDD5535DC049AAC2B010D94940069A820641545DC03C037C16EED84940DF10BC2C62555DC094EDEE38E2D9494083B7A67321565DC0BC9ADBADB5D94940533270A87E565DC0BEC111C076D84940F1E73F1B05585DC025DB7DD385D84940438848CBBE585DC03C0C201203D849400919815301595DC0D80A84428FD64940D5AEA578A9595DC0E38C47B88CD5494049D9893D8C5A5DC03C7F5BAE08D44940AB395E2E355B5DC007E0BCAC53D249405A6EFCC4B75B5DC0B6D1DD829ED14940DD17210AEF5B5DC0A583EBABDDD04940AE394ACE0C5C5DC0817E4361E4CF4940A25B44F6115C5DC05B173E461ACF4940B30CE96A015C5DC08EAD34FE63CD49405C3D12E09D5B5DC035ACFDEF0ACC4940E6C0F61B1D5A5DC03471897BD7C949406856E288B8585DC0C5D7922229C849405457028DC0585DC05E03E656A7C74940079CD2B9CE585DC0E3175DE8BFC64940D542908AAA585DC05C4353C361C549400FB6554F4E585DC045C9AD3F22C449401CD67B8D3B585DC071A0284E09C349409B4E11E1D5585DC021ED79F4B8C14940EC7A819402595DC023E16D1DB8C049409041E818CB585DC07252FBAFE3BF4940FA685B4F60585DC0A1512ADD56BF49404D86E25F4E575DC06C2E75B915BE494040685AF665565DC0C90F911A97BC49400526D6DC0D565DC049D53BE418BB4940D4BCFF7FF1545DC08AB73730EFB94940D419E11FA2545DC09BCA7B4F1AB94940434F4C7DA3535DC0D15643E1B5B84940B0D59F1704535DC0D82E864AE6B74940E581D21FDF525DC01EE5FF0697B749400601D9D141525DC0A93F278CC7B54940E82B7A154B515DC027BF4CDB9DB449404A8E932251515DC01A7E719235B24940625F81F269515DC0295604FD33B1494040848C58D3505DC020E3ABCB70B04940591E95A8C5505DC0E6573924D8AF4940C3EDF3F266505DC0BF34449A14AF49406B7E5EC138505DC005F07441E7AD4940404C4C1119505DC07B56D059FBAC49406CF4E3638D4E5DC05BEA6AB725AC494074DE3EB7BB4D5DC094EB88C273AA4940766A2734E44D5DC007790B15ACA94940E09DE741724D5DC0ECFCCA2FAEA849404C04A6A25C4E5DC05C9B3EB8F9A74940E2D1F5B0FA4E5DC0ABC088E3F7A74940C858F245344F5DC0A2D756A8DAA749408868F7462A4F5DC089ADA12908A74940AF324EE32C4F5DC0C3F570E1B6A549404D9274D8ED4E5DC077E2A4B74DA54940AA08F5D0584E5DC0AA009B4D50A3494006B541E02F4F5DC0146301DD59A249402E4407A7A8505DC07CBC544896A24940BA5419F982515DC06AB308CD48A249407070B7FFD5515DC014722EF250A249409C72E1CA92535DC083AA02464AA14940498E054C07545DC0ADCCBE3761A04940663B53A6A0545DC0733F68BC7B9F494079B7B14BB4545DC0F4186C933D9E49402DA2BE42C2535DC002A83E1D209D494051483EC6D1535DC002A9986D449B49401411545C2E535DC0E6B32AA14B9949400FACCADFEF525DC091C24A1A4D974940821880E1ED515DC026934DAF569649408248021701525DC0632A022B419449404235B0DD96515DC07DE4CD1BC8924940B3EFC0E18F505DC06E5A8914919149406C3B9D25D3505DC03CA7B459C89049409E703C3579505DC07BE5DD6DBF8F494016147B9E23505DC03AE15717718E49408C6695A958505DC038B3C7C8248D4940B46AA451B04F5DC0844AF8EC198C4940BC757C5EBD4F5DC08D16A10DFE8A49409FB3DEC3604F5DC0D4D528BDD789494046E5CE1F1E4F5DC0B029BE9262894940526E0ECC804E5DC02E163E7C66884940B9F9F516BB4D5DC07CE0AF080D8849401C928FEE8E4D5DC028EB533F318649405DE37DA8594D5DC0FFDD40DA0E8649409935258CD44C5DC0CEA2599B01864940A0CFE82A3E4C5DC07270A129E1854940440E1DB1D54B5DC079C4ED46C585494010773C00664B5DC017EFC1E63F854940931CFD5E644B5DC096B2070734844940C17621D8554B5DC0E912F290CF824940BF5767DE004B5DC02DB0BC25A482494098EAAD4F204A5DC04C551B7BD3824940009A478651495DC0DE021288C48249400E30FFC314495DC02FEC4C623E824940F44F8F7501495DC0408FE8BE70814940DE2A792387495DC08B835C0DE18049408B124DD0D1495DC09757F3BA018049405C700C47714A5DC0C731A809467F4940D0D9FC04D04A5DC04B4CA750D57E4940C2B70927BC4A5DC017D20A1C597E4940840D9E0BEE4A5DC09A1990EF407D49406FE1B0FB7F4A5DC04F550F69A47C49407D490C5CCE495DC0EF3CEC1F817C4940C611F0C31C495DC06522F240BF7C49408B02E9AF25485DC0AC692989A07C49404E279977AF475DC0AFB8E54C3D7C4940D55CE085C4465DC095064028F17B49406D23DCA05E465DC018E9CA4AF87B49407CE178DDC4455DC0195DC06D117C4940D3F2F9CEE8445DC07D2ADA37B57B49401546AC070E445DC0791009778D7B49403FD97660A8435DC0E81370E3487B4940ADC7C3FC27435DC039D03EEDF57A49403839AC21FD425DC0DB79A6A3EB794940A784DFB762435DC0D8B0CFE2587949406ECE225679435DC05878C283CF78494073663644EA435DC030C48BFC1A78494010973045B4445DC0252D1B43757649408988B2BC1C455DC033C83D8819754940268A96F7C0445DC06B1DDB01F3734940257D30166A445DC0360A48CFEF7149405ED9A41784455DC0D8CA4CF7BA704940BC35CA4A82455DC0DF1FD461467049409BCDE7C434455DC02527D2D5F26F494073925384A4445DC0BE9E5D627B6F494092AF6A01F2435DC0C4DDEDD4B46F4940A753C14E6D425DC0B52070901E70494069FD1071D6415DC0B3F2CA150F704940399B2323BB415DC0DA70DDC67A6F494096BD1B2730415DC065482D47586E4940BA3145FE73415DC0EE5F8534BC6C4940E09CD3F0B5415DC0001D81083D6B494076758B3A95415DC0DE92B2F76D6A4940156FB6FF4E415DC08930C557F2694940679C9498AD405DC0AC05E1D1DB684940CCF282FAF83F5DC0434856961A68494050C8BBBDCA3E5DC0CF28C04A7B6749406E2107BC513E5DC0D6065AD54B67494009C0853F7C3D5DC083287B5EDE66494032F58CB5583D5DC0BC49E2863D664940F51D2CB5403C5DC023C83AF9F46449406423D57F783B5DC05A98CC0FBD63494067835913153B5DC0099330D5896249402635E005AE3A5DC0D557171A1C624940748E61F3533A5DC09AEEA0340162494003AA6BA19B395DC0083EC520C5614940047ABB33D5385DC0D806C3D0BB604940B095186E78385DC026627FF3B15F4940DA6DD0AE22385DC0C30BE0584061494095E51C39FB375DC0F9210B4A3C6249402B49780E4C375DC0252D65C08C6249400167281E9C365DC086819AE5A262494063DEFC8A07365DC0CC6212107662494043AFFB38A0355DC0AA218B22C861494042DE97E050355DC012F8846EC56049406B572CBE9F355DC06B3AEE459B5F49408B1591BFC5345DC07F1FEE7A785F4940D310E4C758345DC017337138215F4940C8A5E4736B355DC053916407445D4940A5B26F7FCF345DC0E0CAFE882D5C4940F4B5FA3B65345DC09C6355AAF35B4940D5436EDAE6335DC0E2141FBED45B49409211700CBC335DC0C9E4EABD1B5B4940695D752227345DC0BF938C89785A4940A6661F040D345DC01E781799D859494073DB541A1E345DC097D2DD739C584940CE3A7FAC82345DC01BFF0BA61558494083663B82AF345DC0B4B784AC0E574940337948995D355DC04E1004DFC95649409A338A107A355DC020C71ABD2F56494028FC6ED6D5355DC00A5D3DFEE7554940C8F3A442A8365DC0F73758C1495449407E1E43F6B0365DC06C1CC4F57E53494048328A6967365DC0E3E45395255249400BEC7CFA4A365DC0A9552FCDD6504940522C9581CC365DC03DA4955E644F49401DA6D90F98375DC0C4CBD994284E4940ADFF1F99C9375DC087A5FCD1364D4940F9AF784A81385DC0FE908A13D44C494037A4EEB5C4395DC010DC7AF1AA4C4940B5F5DB06FC395DC041680250674D4940DF1B30F8563A5DC0E93CD532074E4940D2ED9D61643A5DC0C66EE729BF4E49408C77BE7C903A5DC0A3A4CF6F244F4940EF0132D82F3B5DC00DD38B21354F494029DDA4FADF3B5DC0D67D318D474F4940A0A809A3913C5DC0ADAFD17BC54F4940D771B51C413D5DC089B70E82E24F49405421A9DAD43D5DC05329BD6EA850494087B6DCEA2E3E5DC0FF888A2451504940457667263E3E5DC0F11C8457E74F494013F73E7AF23D5DC0F2BA289E5E4F49402956CC134F3E5DC01ECEB3C65B4E4940764D075EC23E5DC0703EC8C5794C4940985A57D2B73F5DC070FEC186664B4940395E868B96405DC063915D60324B49408529C1F916425DC008744901634A4940F38239A4BD415DC024BEEC6722494940B2E6AD8787405DC0DE56EFCCE7454940B7965CBE803F5DC0CB606AFF40434940CF4C38C4443D5DC034BB1DFB053D494019D728B2D63B5DC067B7D4A0AF394940	88	613	5404	85	0103000020E610000001000000050000005D7AD3AB43555EC05200F17356C747405D7AD3AB43555EC03613159C88404A409211700CBC335DC03613159C88404A409211700CBC335DC05200F17356C747405D7AD3AB43555EC05200F17356C74740	Thompson/Okanagan
37	Anishnaubemowin			Saulteau,Plains Ojibway,Ojibway	1	There are now only a few elders among the Saulteau First Nations of Moberly Lake that speak some Anishnaubemowin[[source:http://www.ydli.org/bcother/bclist.htm]]. The language is still spoken by First Nations people living in other provinces.	\N	0	0	0	0	\N	Northeastern BC
39	Wetalh			Tsetsaut,Ts'ets'aut	2	Wetalh is currently a sleeping language.	\N	0	0	0	0	\N	Nachako/Stikine
1	Dene				\N		\N	0	0	0	0	\N	
10	She shashishalhem	RGB(255, 88, 32)		Sechelt,sháshishálem	4		0103000020E6100000010000004C000000B9561E01B1E35EC0E48AE1F224E84840E3BE7D653FDF5EC06A125EC07EDE4840D3B9B527F8DE5EC0448F564028D8484024F3ADEF19DF5EC011E8FD0872D348406376ECC098DF5EC0E07E9DD1EFCF4840B36A0ABF68E05EC0A05A1E6A35CD4840D23ABF187EE15EC0CD56D3B3D6CA484071D545C7ECE55EC0463C07E04FC24840ADF70B9DFEE85EC0F141045363BF4840C65061D281ED5EC089201F5769BC48403A176BF07CEE5EC07B51B18E8DBB48403C17813433EF5EC09B864C6C15BB4840CCE3C503F4EF5EC03748899CB7BA484072DA7A4801F15EC0A0A04EDA41BA484055CEDFFCFAF25EC00B7254AE85B94840B070EDFEEEF85EC073995685DCB6484090D02C04E3FE5EC09FC67DAC92B44840DFF474625C045FC0F807015ECDB248400ABCFF5107095FC03B793336A9B148402F230237460C5FC0937E6584F6B248402358D231FD105FC044FE2BBC45B5484075DD9D975D155FC09BC294D1CDB7484020469A5851195FC0C82C71F276BA4840AAF8EA44C21C5FC0D5BB995329BD48406083DD109A1F5FC027F2F229CDBF4840C3C1095BC2215FC0A493B2A44AC2484031E16BB424235FC0A8FF95E589C4484050A992AAAA235FC0FEFAC8F572C64840AB3A63F5A7235FC06A46D76885C84840FE047BEF7B235FC01AD3B7A1CBCA484038B9A45C28235FC00E7EA5AA3BCD484034E63400AF225FC056644E8CCBCF4840D0D7D59D11225FC0428C204E71D24840A3AD42FA51215FC015D38FF622D54840E38DF1DB71205FC0FDDD558BD6D74840B049AD0B731F5FC0EE07AD1182DA4840FA641E55571E5FC0FF4B878E1BDD4840D09A4387201D5FC08C2DC20699DF48400BCC613E4E1B5FC0F8CD126ABEE24840CBDDFCEB97195FC02F79E6221DE548408384849CFC175FC0F7A10C64E4E64840C5D06E497B165FC09FC06E5F43E8484032295D2EC2135FC001240A4685EA48404440251088125FC0BE58748EC6EB4840F1ABCF4563115FC0378E244C5CED484093D25B8C52105FC07AFB87AF75EF4840129B1E9A540F5FC057CA60EC41F24840B8CAA77A840D5FC0D8356B5DB3F64840F40EBE1A7D0B5FC049A086C654F94840575920A060095FC069B28F2ACEFA48403425E70551075FC0FB1D2FABC7FB484064C3D30E70055FC078970081E9FC48400A685E4BDF035FC0769B40F7DBFE484051C22A33C0025FC03F5D5F6A4702494035E2CA5134025FC03D185148D4074940D9AA5A875D025FC0C1806D0F2B104940F4FA925E5E035FC0ED5E5146F41B49406BB3D0C05C035FC00F642381B41E4940B4836FCBC2025FC06A6D1F94FD2049409CFA2EE3A8015FC0083A6F2AE7224940780A437F27005FC0156381E98824494009F1AA2057FE5EC0704DE577FA254940BA250B4501F85EC02BB12CFA1A2A49400CD8000DEAF55EC0B558E6FEB82B4940992B81956AF35EC0DCA142342F2E49407D82ECB356F25EC0A2CED998D52A4940147EFDE014F25EC080B73D75482A49403298975D33F05EC0937D5E4D79214940BE78D4D2CBEE5EC00E466C7C62194940C171F3E43BEE5EC04DF2104A5A1549404546D231C1ED5EC0B51BCBBA3C1149404C1D93C4B6EC5EC032A5B6B56E064940211D19F319EB5EC044DF1AB9E9FD4840D93C0377D7E85EC0327DF635D2F5484069017C5A43E65EC02FBA347D76EE4840B9561E01B1E35EC0E48AE1F224E84840	4	0	1200	34	0103000020E6100000010000000500000050A992AAAA235FC03B793336A9B1484050A992AAAA235FC0DCA142342F2E4940D3B9B527F8DE5EC0DCA142342F2E4940D3B9B527F8DE5EC03B793336A9B1484050A992AAAA235FC03B793336A9B14840	South Coast
8	Éy7á7juuthem	RGB(255, 216, 96)		Mainland Comox,Comox Sliammon	4		0103000020E610000001000000A10000006B44216E9F3F5FC048206F625C4549408CBA66D3F93F5FC0288B7BB24049494011765F7612405FC065FD0C82044D4940B8B788FDF53F5FC0C37A4C08415449407FBFC1D8FC3F5FC0C44231F4C4574940ECE64CDF39405FC0DC03F2C93E5B494090E5798C8F405FC044F5E12B8D5D49402B200DAB13415FC0268E3635DB5F49400C4E9AF269415FC09303F19B026149404FB434985D465FC03723E60C9B70494090F96C13C9485FC094CBF7CD8878494051830E5F0B4B5FC04CB89F527780494085AE7B9A154C5FC00D44BAD3698449407BD9AF34ED4D5FC0CA3254443B8C49403530E588B44E5FC0BA7E262F1690494087F59C815F4F5FC048B7E438E593494034D30114EB4F5FC083FA705FA697494085D8533354505FC0A69C59A0579B4940CA691DD197505FC059B393F8F69E494059886EDDB2505FC0CDEE2E6482A2494096831E47A2505FC0C0C602DEF7A54940FD2814FC62505FC051FA545F55A949405445BFE9F14F5FC06A2807E098AC4940AA0E77FD4B4F5FC09A9C4F56C0AF494019B768246E4E5FC02A97E1B4C9B24940C79D374C554D5FC0F85344EBB2B54940B4CF6863FE4B5FC082015FE579B84940CB1949E51C4A5FC0DA6667E895BB4940D158233753485FC00590224DE2BB4940C586A96E92455FC08B20A877A2BC4940ED9E8DE814425FC0CA58EAD7D4BD4940B70E43E8663E5FC0F7D5E3BC42BF49400AF0DE6AFF3A5FC07CD8040541C1494086B164B3D1385FC0BB184B603DC249408E1A316044375FC0D51336ADB9C24940CD5365E1AD355FC0982DA7EACFC24940C365AE77EB345FC0C7FD047EDAC2494042C5966526345FC0FD8F0A5B79C24940DECF0611A8325FC0189574C0BCC14940B77F02062D315FC0C16565DAA0C04940DF62F265AF2F5FC029ACE6652CBF4940346A4752292E5FC0A080911D66BD49409B4745ED942C5FC043777CB954BB49400B3E0A173F255FC044F5D411A6B049400AD29C53A6205FC036BE46E639AA4940D8DD400A621E5FC012F6F585E7A64940DC31BB1D7A1C5FC0206FDEF87AA34940449EC22BBB1A5FC049B41B61E99F4940A4CF20591B195FC0F52DF8043A9C49403ECD19AE0E135FC07550E8BAE38C494074B5F22D77115FC0456419020C8949406450A504C40F5FC067FEB9CB41854940E7067072EB0D5FC00CE2E1408C814940F17C55BBE30B5FC0745B1585F27D49408870E42AA3095FC0E27F1DB37B7A49407E9D1D0F20075FC06972EDDB2E774940420AAAFE6B045FC054FE2084187449401294349218025FC0D1F465825A7049400E872C5515005FC01C3251798A6B4940AFBC71BC55FE5EC06308F1B1D9654940865BA2F757FD5EC0385ED3FFBA614940A701E927CDFC5EC059E4DB6A795F4940F2EDA8EC6EFB5EC0396361DA9A584940D412612FA0F65EC03B899F1C093C4940D952D6EE57F55EC05ED2D07394354940E4FCD34BEEF35EC00F0F8345C82F4940992B81956AF35EC0DCA142342F2E49400CD8000DEAF55EC0B558E6FEB82B4940BA250B4501F85EC02BB12CFA1A2A494009F1AA2057FE5EC0704DE577FA254940780A437F27005FC0156381E9882449409CFA2EE3A8015FC0083A6F2AE7224940B4836FCBC2025FC06A6D1F94FD2049406BB3D0C05C035FC00F642381B41E4940F4FA925E5E035FC0ED5E5146F41B4940D9AA5A875D025FC0C1806D0F2B10494035E2CA5134025FC03D185148D407494051C22A33C0025FC03F5D5F6A470249400A685E4BDF035FC0769B40F7DBFE484064C3D30E70055FC078970081E9FC48403425E70551075FC0FB1D2FABC7FB4840575920A060095FC069B28F2ACEFA4840F40EBE1A7D0B5FC049A086C654F94840B8CAA77A840D5FC0D8356B5DB3F64840129B1E9A540F5FC057CA60EC41F2484093D25B8C52105FC07AFB87AF75EF4840F1ABCF4563115FC0378E244C5CED48404440251088125FC0BE58748EC6EB484032295D2EC2135FC001240A4685EA4840C5D06E497B165FC09FC06E5F43E848408384849CFC175FC0F7A10C64E4E64840CBDDFCEB97195FC02F79E6221DE548400BCC613E4E1B5FC0F8CD126ABEE24840D09A4387201D5FC08C2DC20699DF4840FA641E55571E5FC0FF4B878E1BDD4840B049AD0B731F5FC0EE07AD1182DA4840E38DF1DB71205FC0FDDD558BD6D74840A3AD42FA51215FC015D38FF622D54840D0D7D59D11225FC0428C204E71D2484034E63400AF225FC056644E8CCBCF484038B9A45C28235FC00E7EA5AA3BCD4840FE047BEF7B235FC01AD3B7A1CBCA4840AB3A63F5A7235FC06A46D76885C8484050A992AAAA235FC0FEFAC8F572C6484031E16BB424235FC0A8FF95E589C44840C3C1095BC2215FC0A493B2A44AC248406083DD109A1F5FC027F2F229CDBF4840AAF8EA44C21C5FC0D5BB995329BD484020469A5851195FC0C82C71F276BA484075DD9D975D155FC09BC294D1CDB748402358D231FD105FC044FE2BBC45B548402F230237460C5FC0937E6584F6B248400ABCFF5107095FC03B793336A9B1484004FF901A3B0C5FC0687C157DFDAF48406130580E760E5FC0170C381F30AF48400E89D5357C105FC031BE1FD840AE4840390E5A5558125FC0F47422403AAD4840E76D6732FC185FC0863C329709A94840FC20F2F9A71A5FC0991FF65B2CA848408DE6E10F2C215FC07356E13B9FA548404253EB0799245FC0C8C61F9CDEA348400C2EF644FF255FC07DFE5A0501A34840E281C7A53B2B5FC039FEA53B639F484020D7B6C3672D5FC0148F31C3079E4840E5826BCEC4355FC092D26AEA59A84840085C71EDC23C5FC034700E465BB048401F51144B7C435FC0430FB68593B74840881716E1E4495FC03918546F0ABE48406ABDF7B4F04F5FC0B10569ECC7C3484061DB28DA93555FC04EA23902D4C84840FC2702C9F65B5FC0AA69808F2ECE4840EB124DD821575FC07939F7294AE44840DF15321A65555FC0A6EB661AB3F148407B295A66F4535FC0B37875C6FEF74840BFF3733BD4515FC06EC1953C1AFC484066A49F31CD4D5FC0842FACDC91FD484072A9FC23804B5FC0EC55EF2A4CFE48401D39BA42D0495FC07D2BE5615BFF4840C7F7F972DD485FC0D4FDD3856201494079947164B2485FC067D3B5D1DA02494013F75701E6485FC0B360AB43C5094940CC4C2F1F324A5FC01AC545C0A20F49407EA55965274A5FC0848D42A6DF1349402EA4F22B4F495FC0639599E90516494021D318E98D485FC0D0BCD3CE2319494081739D029C485FC0BFF4D0E79B1B494028F283AB7B495FC07D41009E611D4940CDBAC115EC4A5FC0214312B7F81E4940ED786E27304C5FC09D76CB88F5204940F32BA270944D5FC0DCD8C9B474254940264FDB3BF94C5FC0F6AAE8F64B284940DEC63155B24B5FC04D9AA4B13D2B4940D9AD14D5574A5FC0B95410BC8F2D49406983B4F8B9485FC073A9A8BF1B2F4940DEB0DE0CF0465FC0DF9C4B70353149403B792EF549455FC0A25DEB072A3449401A7094D3F1435FC0BD909260933B49409B825FF6BB435FC0503B7EB2923E4940CF0EF21733425FC07959F2D3E94049403328EC31A5405FC08CEF4FF4934249406B44216E9F3F5FC048206F625C454940	37	359	1984	127	0103000020E61000000100000005000000FC2702C9F65B5FC0148F31C3079E4840FC2702C9F65B5FC0C7FD047EDAC24940992B81956AF35EC0C7FD047EDAC24940992B81956AF35EC0148F31C3079E4840FC2702C9F65B5FC0148F31C3079E4840	
7	Xenaksialak̓ala / Xa'’islak̓ala	RGB(255, 0, 255)		Haisla,Kitimat,Kitlope,Northern Kwakiutl	\N		0103000020E6100000010000006A0000008DF960FFA6FE5FC0D15E524A07E64A401D08C06C38FD5FC06A41D40503DB4A40497933F17FFA5FC0864E7E3554D14A40CAD05A2BC2F65FC01781F38EDBC84A402476714C63F55FC0D8202C3D9CC64A40EEE6121743F25FC0E29D49DB79C14A407B24D03546ED5FC0AB17461710BB4A40A09748B30EE85FC089B87D867FB54A403BFBA381DFE25FC09257B8C8A9B04A405AFDDD85A4DA5FC02230D0A589A94A4040C5E62F8CD55FC0B5715046A0A44A40E785322984CE5FC0E8583C6E769D4A402F7D6C2938CC5FC08D32792A3F9B4A40E51944704CC85FC02944ACB8D0974A40373A77B2DFC75FC06584AAAE0B934A40B0BAEF3CD8C75FC05F2995252C8F4A40E3199FBB0DC85FC0602B89FD828B4A40196E22ED1DC95FC0B4AD91A573814A40C02FD48D49C95FC079B9A6E3497E4A40166E1F9B33C95FC02FBA4B7B297B4A405D1F95C593C85FC03AEFE4025C774A4051096EF5FBC65FC04B63919E46744A40E38944C09DC95FC01A5DEE8556744A400FA05EA324CC5FC0C69D7B24AA734A40EA1EA9AE05CF5FC047B2290C61724A40577198902DD25FC0F852789497704A40E2844E0289D55FC00BC020206A6E4A4026E92DCE04D95FC05C150E20F56B4A40B31A148ABAE65FC0DC842EC890614A40536F6B3CBBE95FC0869FDCF9625F4A40CB2F77006BEC5FC009E415A3995D4A4080AE5A67CAEE5FC0D8054EB24A5C4A40DFCEB28ECFEF5FC05131EFED9D5B4A4078267D528DF05FC0E248ECCAA75B4A4090A015ACDAF15FC0813B4807B95B4A40237F09EE27F25FC0CC06AF01BD5B4A40BD1B168B9EF25FC061A99A08A65C4A40174F0DDB39F35FC077575604D75D4A40CFDC5FB822F45FC00ABC4E4CFB5F4A403284A6AB4AF65FC0176E374FCC664A409463661495F75FC0B3C2C062CC694A40D50AA93DBFF95FC0976290807B6D4A4050A41D57E6FA5FC032C777973A6F4A40A40555DE0E0160C015F9E12350794A40BFEF87FD030660C00E5054FF60864A402A754F5C700D60C09873170714994A406478C188C80F60C05D50590F1D9F4A409546373FB81160C0FB7C2481D4A34A40E0813D4D991360C0B02270AD06A84A400F7739F06A1560C03A734DF3D1AB4A408D722D757C1A60C0BA31861EFAB54A409E2532C1091C60C0FF2FEA8D59B94A408E89AF80841D60C0A5EC40F9E9BC4A40665D3E2FEC1E60C0C580EFC0C9C04A40611F924F402060C0C74A644517C54A40EE9C976A802160C053A417E7F0C94A404FEEA10EAC2260C08CC69E0675CF4A404408AECEC22360C00B51D704C2D54A40588EC841C42460C09EA23543F6DC4A40D99BA702B02560C0A426462430E54A40D8EB93AF852660C067E67A0C8EEE4A402F632984222760C04EFFCE7544F74A40B148C0BC432760C0BF657A1677FC4A406EB0FE7E212760C0ADE48A2A75014B40EAF6C59A1C2660C091ADE7567D054B40F6FA63012A2560C046B312C4320A4B40106EF4DFD32460C035F99D001F0F4B407851FC144F2460C0947A209E11134B40488B71AF1E2360C03FB038EACD164B408563DFE7C52160C07C25D7E43D1A4B4025195D5C492060C08B83038E5D1D4B40D6BAC5B1AD1E60C02FCCF0E728204B406A543B93F71C60C001DB66F89B224B402A8798B12B1B60C0612BFCC9B2244B4043CDD1C24E1960C03BA9226D69264B400EA44881651760C0B18C0AF9BB274B406BE912AB741560C014355E8CA6284B40F1FF3801811360C0047CD94D25294B40AF1F2D1C700F60C0DDBC027219294B40BC41F32FD10C60C0047BCC4E76294B40341B0B65300A60C0C8B121C23D2A4B401112CE63E20860C0DD3303BFCB2A4B405BF0E6A0970760C0D8A92525772B4B4010A81259510660C0CFC207E4402C4B40428D3AC9100560C090C5D7EC292D4B4066E98A2ED70360C074CF6532332E4B4036128BC6A50260C0843F12A95D2F4B40C90237CF7D0160C09E39B846AA304B405B921A87600060C0224D94021A324B400881DC5A9EFE5FC0BD1E27D5AD334B40102185DBE4FC5FC0DB29E0F323354B400652976A7AFD5FC040465D5E7C334B40441994D54CFD5FC025D45C0A7B2E4B406B521CF5EDFB5FC04822FBB512294B40F6CDD8A8E7F95FC077CAFF1277234B40933BF53FC3F75FC0102D67FEDB1D4B4054812C6609F65FC01CB232A075184B400D9E4A2E42F55FC0FCD1EB5C78134B408E3226C818F65FC098B24411920E4B40718249A0E1F75FC0FEE962CF55094B405A58781E6AFB5FC054B7123C32004B40D6F3C986EEFC5FC01177CA25D1FB4A40D9A8DCFA20FE5FC0B181B9753FF74A4071C21709E4FE5FC00E90FB6B40F24A4057FC5D651AFF5FC0A7CF414A97EC4A408DF960FFA6FE5FC0D15E524A07E64A40	331	204	3548	21	0103000020E61000000100000005000000B148C0BC432760C05131EFED9D5B4A40B148C0BC432760C0DB29E0F323354B4051096EF5FBC65FC0DB29E0F323354B4051096EF5FBC65FC05131EFED9D5B4A40B148C0BC432760C05131EFED9D5B4A40	
26	diiɁdiitidq	RGB(255, 112, 255)		Ditidaht,Nitinat,Diitiidʔaatx̣	\N		0103000020E6100000010000003900000009336DFFCAFF5EC09E5F94A0BF324840F085C954C1FD5EC0BF0E9C33A2344840170E846401FC5EC05AF10D85CF3648408544DAC69FFA5EC0DF52CE177B394840B7EC10FFB0F95EC0D9976C3CD83C48406FB9FAB149F95EC004A9143B1A41484066868DB27EF95EC04145D5AF7446484059C0046EDDF95EC0C652245F0948484047C66AF3FFF95EC074417DCB9C484840B3CD8DE909FB5EC0317C444C894A48405708ABB184FC5EC0419DF2E8464C48400E66136058FE5EC0FDD8243FE24D484016DF50F86C005FC0605B3FFD674F484098FBE42840075FC053094FE8F5534840CBF78C4468095FC0E88711C2A355484097016729590B5FC00229B16B7B574840DFDFA0BDFA0C5FC0DD0720B5895948409D9B36E3340E5FC01348895DDB5B48408AE6012CF20E5FC0AB251DE5605E4840C153C8957A0E5FC016FC36C478614840376DC669880D5FC0A2B60DA3206448406C2F72F649065FC0B6DEFE4A7C6648404019E87C76045FC04A706C2BDF66484051D9A7E4C2025FC0705AE016E0664840B31D125456015FC0A35124671766484024552D78FDFF5EC0762F69066C6748407BE40CC320005FC0451D5F447269484043C9C3C615025FC083088C93036B484052A06EBE05035FC080645482686C4840E8D3E83C4E045FC0537DA34FEB6E484013A36897C7085FC003FD234CAD734840E55DBECFE50B5FC020EEB6295D754840E22724CEE80E5FC092787DE197754840438EAD67080F5FC020D3DA34B67548406806F1811D1A5FC02157EA591084484075914259F81A5FC0F0DDE68D9382484050C58D5BCC1B5FC049658A3908824840CA6E66F4A31C5FC02FDE8FDB2F8148408EC9E2FE231E5FC0D34ECDE5067F484033349E08E21F5FC00A0F9A5DF77C484021CA17B490225FC0910A630B417A4840902FA182C3245FC09AD18F8653784840FE99417C60275FC0E5B512BA4B7648405C3AE63C632A5FC067800BB265734840A837A3E6AB2D5FC0F10F5B7A346F484017BA1281EA315FC0F6F065A2086B48407349D57613345FC060048D99446748403AEAE8B81A375FC0F9307BD97662484058E4D70FB13A5FC078431A15385D4840C72E51BD353D5FC0E9D495CFF2584840BB9BA73AE4385FC068E6C93505564840DCBC7152982D5FC06806F1811D4B48407500C45DBD205FC0CF2D7425024548404A7CEE04FB1C5FC06F2D93E17842484008AA46AF06125FC0B612BA4BE23C48406DC9AA0837005FC0240F44166932484009336DFFCAFF5EC09E5F94A0BF324840	6	171	1075	8	0103000020E61000000100000005000000C72E51BD353D5FC0240F441669324840C72E51BD353D5FC02157EA59108448406FB9FAB149F95EC02157EA59108448406FB9FAB149F95EC0240F441669324840C72E51BD353D5FC0240F441669324840	
28	Oowekyala/’Uik̓ala	RGB(255, 0, 138)		Oweekeno,Oweek'ala,Heiltsuk-Oweek'ala	\N		0103000020E610000001000000590000000E9081B55AF35FC0DD838EB7F2AC4940141538880AF45FC0C768DFF257B04940A099D41969F45FC0DA676422B1B34940BF491DFB98F55FC0204A3B2DF1B64940ED07A2B385F65FC0A8B1DA6D79B84940F52311F6E1F65FC06A3C97FD48BE49407C3E6A8BC8F75FC0B0323B8FA3C24940FF3D03B459F85FC05AA2FA558EC74940DDC372C32FF85FC06FA8878481CA494090D37E6E28F85FC00A75ED238ACD4940A7960665C6F95FC049FC1EFDA8D54940A28AB3FF0DFA5FC015C64D59F0D84940483128B59CF95FC0CA45D46816DC4940C40F45417FF85FC01D285B091ADF4940A31C957504F75FC0EEE3F76D1CE14940FA8586BC0AF65FC0AFA9359918E349402AD0A47FB1F45FC06BB4F917BCE4494097DCA1DEE8F25FC059D855D41FE64940C0EA588600F15FC0EA6C5C3771E74940B0F2259D0DEF5FC03B9C2680ADE8494039EE314317EB5FC028D22FA5EFEA494042FCEFF9C0DF5FC021D29FFDA3F04940388B45858DDC5FC0168D28B26BF249408D4C6B8BD6D95FC05EE53E4042F4494032784A34B3D85FC0F9F568D238F549401EB25BD980D75FC06A2D0E5F75F64940F6D5E6B066D75FC0965E3AC030F64940EA7E7FB54ED55FC0B06CEA70C1F549400C81A2D436D25FC08E97656660F649407A7A7B1363CE5FC07CFEB2ABAFF749401D3A60D298C55FC075E06620E8FA49409118EB8C2BC15FC043ED507F16FC494036E3EAE914BD5FC04BAEA9A07FFC494083C52708D5B95FC0C526A6D9DFFB4940F659330D6FB75FC006CF9F177DFA4940DD83000D63B25FC02AD5C7A2AEF649407F391F7636AF5FC0CB8E7AB005F54940FAB1EBE040AB5FC05F6FCAB007F4494005974A7B3EA65FC03EF3063E15F449408D0D21DEEA9F5FC01C05285F8EF54940F23678B600985FC0D1AAB44CD2F8494011AE40FBDB915FC08A67CB60ADFB4940C1C87CB3108C5FC083B6D73B26FE4940D955F1BDB67B5FC0D3DC7A5997044A40CC10CC893F765FC01D380C52DA064A40627276B5CC735FC02AAB16E3F3074A4032D829729D6F5FC03312EAF1A3F24940182A618C7E6E5FC0A0C1E11013EC4940A8261C60BB6D5FC0D4B42C4578E64940EF2D8A31586D5FC0B0FC6D04A9E1494011DB5B5E596D5FC071EE81BD7ADD494086137789596D5FC086F6E24FE2DC4940B186CCD3706D5FC0AB1F586432DC4940C7FFA156C36D5FC036952FD7C2D949405A2DA82A526E5FC0264E62FE4CD74940422B4D959A6E5FC08546C7AE56D64940065A9E6FED6E5FC04C3C2449B3D549404CA57C8D7C6F5FC003B640AA0BD5494089B428CB43705FC0DAED671960D44940F680CE186A725FC003BA8A36FED24940A54C89423F755FC05F0D4DC18FD149409A8AA239A2785FC09B3D42D816D04940B3FA7BF7717C5FC0CCBB36A695CE49403AFBCEEB5E915FC0AE15AB2FE7C6494074F4C5CCB0965FC0AC3D78FCACC44940C1EC406C1E9A5FC062D54D1BF9C2494083AE6F3DEC9B5FC0B6DAC288F4C1494001EF28994C9F5FC0E4F42A1DD3BF49408804DE6779A25FC0B1365F1B97BD4940266BED29BCA85FC00859C285EAB849407BD86289E6AE5FC02DA9D7E66CB9494062BDEA6CC4B75FC07758C28949B94940FB26839A27C05FC046A51079DEB84940F141053CC3C35FC0E4F503DD9EB849403E8CED0EF9C85FC01795D7FDABB74940671500B94CCE5FC0BF811AFB39B44940A451D2C4EFD25FC050BFE8B01DB14940088F27635BD75FC0F2A8A31D74AE49404952EA3B6CDA5FC031955A6B59AD4940D51C7C3434DB5FC0DF327597B3AD4940B98BA29AD9DD5FC0B05D55C445AE49405875C298F2DF5FC09C65AE4280AE4940EC52030B58E25FC0BDB304B287AE4940FC848E1812E55FC09A1B239253AE49403EFF61DF28E85FC018931857DBAD4940D8A91672A4EB5FC00586426716AD4940CDCB67D58CEF5FC077692E19FCAB4940A07EF715BAF25FC04FAD8C24DEAA49400E9081B55AF35FC0DD838EB7F2AC4940	2	15	200	11	0103000020E61000000100000005000000A28AB3FF0DFA5FC04FAD8C24DEAA4940A28AB3FF0DFA5FC02AAB16E3F3074A40EF2D8A31586D5FC02AAB16E3F3074A40EF2D8A31586D5FC04FAD8C24DEAA4940A28AB3FF0DFA5FC04FAD8C24DEAA4940	
32	Nisg̱a’a 	RGB(144, 108, 0)	https://www.firstvoices.com/explore/FV/sections/Data/Nisga'a/Nisga'a/Nisga'a	Nisga’a,Nishga,Niska',Nisk'a'	\N		0103000020E610000001000000A500000015CEBAE7F2E45FC028C060F34DA04C402F331C7253ED5FC093B49526508E4C40AEA9B25997FB5FC01EA16520676B4C400E860436E30260C0EF50A6AEA5574C406EECA5052F0D60C0E2DC465DC03B4C40B3CA74D98A1260C052F07B465A214C406FFA04F2661560C0CE609EFB7E114C40E91E6188421860C0D88D3DA5D7F14B40C92EB4CAF71760C0304D7A8922D84B40432CCA799F1B60C0129462BA00C44B407F2B8695111C60C05941FF9B8DAC4B405C5EE917C11E60C02B72D6F56F9A4B40C6526850102160C09402F3C7E88A4B406683652E9F2160C0447714C694834B4020AE1C62DB2160C07E92D5AC17814B4025E35DC9252260C0CF4F00DC997E4B4018839A3E822260C02D7223EB297C4B40E40A4B9AF42260C0C10A5C6ED6794B40232CCFB3802360C0BC93B2F5AD774B40BE848B622A2460C09B16570CBF754B40BD55427FF52460C0ED1FBA3718744B40EDA7A5E5E52560C0469180F6C7724B4054142276FF2660C0BBB150BFDC714B40AF64E217462860C00DDA76FF64714B4000F70CBBBD2960C08D2A60196F714B4097BB3C5B6A2B60C0D285E96209724B4009E38D660A2D60C03F99693105734B40333F1652122E60C0B860C21A62734B40244DF1F5532F60C0A1AD644D2E734B40FCE5EAAF7A3060C0EF6C71ED3C714B40D07FD025463160C0B783EC84096E4B40D84D7D7BC53260C0DC0E14F012644B402B68BB580B3360C04F9C898D62614B404415920A933360C01D7BD31AA05C4B407C64AB200F3460C0F7FF3B0D855A4B40E1595DD4B93460C0F805A5B5255A4B401CD71CEFBC3560C02AC5DE2160594B406D2E43A1AD3760C03CA023FA20584B4065511F05DC3860C0945B3AA6A0574B4049A58850363A60C02FF5520164554B404F84CFF22B3B60C0846A40991D554B4056321AA1993B60C095766B14FE544B40B8A3298AF53B60C0D77AF41862554B4005FC96FAA03C60C04D695E861C564B40401CE9B5E53C60C0F8516A3767564B4024EAA1233C3D60C0028010DC37574B4087BDC7A2363F60C0482F0494FC5B4B40B1FE2C651B4060C090C88FA1C85D4B40630A1043354160C07F20A1EB8B5F4B40A6EAC31F924260C02CDAA12131614B401B9CC8DB3F4460C032F44BD6A2624B40958084B6F94760C00E2CB4289A624B40E5F456FEAD4C60C03413EB50F4634B40A817460E314F60C024BBD21FF66B4B40E708A5DFA54D60C086F3FCBED36F4B40092EC6B3444A60C0569F21F98A774B40FDDCC75D6C4660C0008DE62448874B40EB1DDE07424460C02F764335AB944B4053A96DEBB34260C0E7EB7C7F219B4B4071FA44A7854160C0DA0905F4E19E4B40070A80B4744060C0B4F0268CE4A04B403CB759E6AE3F60C016F8382BCAA34B404C5C2A9A6A3F60C060ED1E137FA64B40B7157F463E4060C0AAD4600BDCA94B40CFDF7A71DC4060C04A1BF28D9CAD4B40C4047832184160C06E7232DBC3B04B4092778732264160C0E18ED6AD94B54B40AB5B17EBB44160C0C1D95B1C15BA4B40AE3EC7BED34160C002557C0314BB4B40CE0225FB8A4260C0D98D470708BF4B4075A72118F94260C0A671FED25CC34B40A5F485892F4460C0B8788A2DE1C94B40A78A24CA184460C03411358CC9CE4B408F855631B44360C068674988A2D24B40C966CF43D24360C0351A688335D64B4028F27480264460C02A7F1CD56CD94B4069BB31A3A44460C09CE9D06CBADB4B40DA1144E2F94460C0644E676004DE4B404360AB67004560C01C73BC7689DF4B4040F50525BB4460C02482F7A617E14B402C70C7A17A4460C09CCF9D140EE34B40199FC2CF4B4460C0CDE0ACD089E44B4000DD3980BA4360C00295083AF7E54B407FAD8FAA714260C0675E0D4779EA4B40E38D2861A34160C0C0EB35C483ED4B40F54F6AFF3D4160C01013779BDEEF4B40EB13930BF74060C06E657E8352F14B409574DE9BBE4060C0777E6CEB04F34B4068BD9960AC4060C00012CDDF79F44B4054D73D09F34060C05AA19F58BFF64B40E92B00394D4160C007223E58B5F84B40BF211E92904160C054CBFBEE6AFB4B40AAD565D2164260C03887E29AA0FF4B40246BC43C9D4260C07119C25A53034C40DC123E6AA04360C0FA4B02BD46094C40BA9CFA22164460C0A4A2BF6E900B4C404CFC7B198C4460C05DCB818F7B0D4C40CCCC7AD5014560C0A151DD3C100F4C402F0AC9E5764560C032BB7AA656104C40A8156DDEEA4560C057328D0857114C40377D4D575D4660C0B3CDF4A719124C40763D38EBCD4660C0EFAA72CFA6124C40CCDE24373C4760C0229C91CD06134C4026294272104860C0BB65829160134C40E49BD2CCE04960C0FB138EC470134C40E4C3EB562F4A60C0A144E2C392134C40A386F53B784A60C08D705260D2134C405948A21DBB4A60C0C8EBBEE637144C40A345F09EF74A60C05316C3A6CB144C40C3E8D3642D4B60C057D57DF495154C4065F14B6DB64B60C07936D40CDA184C40EB43849C184C60C08F263FDCDC1A4C40A9C1D43A824C60C092998145AB1C4C40BB370CE2F24C60C0BC34D3FE481E4C40987F9A2E6A4D60C00AEC60C5B91F4C4051BBEEBEE74D60C09204935B01214C40511905336B4E60C0EBBEC88723224C40264A152CF44E60C06977651324234C4085A5DA36155060C003B24679CF244C403CE6045AEC5060C02ED257A5C3254C401DBA07C6A84F60C00FC68EB350264C40A34D38B1D04E60C059B79046D8264C40CEC3326CFC4D60C0AD725EA185274C40C22BE6BC2B4D60C044593BE056284C40533638695E4C60C019FC5D1E4A294C40B122F4EBCC4A60C0DB66BCFF8E2B4C40888DC84D084A60C028FDC9D3DC2C4C40F8D9662E864860C0003676B4C52F4C4035B54A050C4760C001F4C5C108334C40828E6CB7DF4460C077C451B974384C401E61B015BB4260C0431BC2C7543E4C40CE4645C6B63D60C07C3D1C59A74C4C40AA52F8D43E3C60C085B6653BA1504C40D6738FBABF3A60C029A4744771544C40B1BFE3C6373960C0120DEED607584C40CE682DF66F3860C060D3C2AAB8594C40292B8C9FD73660C0E0EC009EDB5C4C40B7EC6CB1063660C0436441D1495E4C4092EE174E5A3460C0D1890BDBD5604C4001BA29737E3360C0C01050C4EF614C4054AEF28E9E3260C06CEF3BA7E9624C407187AC6FBA3160C09F1F9D8CC1634C408F4208E4D13060C078FA107D75644C40D0A432BBE42F60C0FC17048103654C407367DBC4F22E60C04BBDCEA069654C40EA053AD1FB2D60C043D5A7E4A5654C40D72614B1FF2C60C05AB9A654B6654C40A7BEC435FE2B60C06213C6F898654C40A8CA4331F72A60C01AC8E6D84B654C40DBBE2E76EA2960C069EED2FCCC644C40059AD1D7D72860C0F1D5406C1A644C40F8B1302ABF2760C01628D62E32634C40620C80B3D02260C095435F529C6C4C40FD8854BB8D1C60C0EB5768E841784C40478630FDAA1660C038107C4FE5824C4096544A282D1160C096FC8D478E8C4C408E140CC2180C60C001F97CB944954C40F54624295A0660C0FAB965EBDF9E4C40149810EE67EF5FC016B6BE828CB64C401BFA24EAA4EB5FC0475F8789AEB94C406A7FF98DEEE85FC06BC2E2B81DBC4C400FD39917CAE85FC0B7B03364CFB74C408F1EBCD308E85FC0E99B1DAA20B14C4064656E28BAE65FC0AF0D549340A94C4015CEBAE7F2E45FC028C060F34DA04C40	331	294	1745	160	0103000020E610000001000000050000003CE6045AEC5060C095766B14FE544B403CE6045AEC5060C06BC2E2B81DBC4C4015CEBAE7F2E45FC06BC2E2B81DBC4C4015CEBAE7F2E45FC095766B14FE544B403CE6045AEC5060C095766B14FE544B40	
31	Gitsenimx̱	RGB(208, 156, 0)	https://www.firstvoices.com/explore/FV/sections/Data/Sim'algaxm%20-%20Gitksen/Gitsenimx%CC%B1/Gitsenimx%CC%B1	Gitsanimx̱  ,Gitxsan,Gitxsen,Gitksan,Hazelton	\N		0103000020E61000000100000063000000E25D76F239E85FC0BE6C4B945EA04B40FFE7EFDC6AE85FC072631D5AA79F4B40B87F44C3BAE75FC01AC50243F69C4B40EA3A8C72CAE55FC0E72E0080C5984B405FAC77D182E15FC092E94ED2E6914B407E9E90F632DE5FC0C593DC488F884B404948F9BDB1DE5FC0F81C7867E17A4B40AE9989F3B4DF5FC03C4B033D54724B4094EF86F9B4DF5FC023BA9A3B54724B4000650A4DFBE15FC04861491DCB714B40BB4DF21805E85FC07058AB701D704B40F946470524EB5FC047686FB2CB6E4B40EE52D7BD8AED5FC0BEE46427946D4B40490E47A678F55FC0C7E0DF8C39694B40ECAB034D90FD5FC05AF12499B7654B40B6D2F9BC290360C0E8A17F72CC654B40401ED209D00760C0FD6528A2896A4B40D7AAA414540A60C09E8A6B1FD16B4B408D2D4F2D030B60C081E5CFCEB0694B4060213308220B60C0379D9B7CDD664B4011512A20380B60C068F2401693624B4038C22B40C60B60C06E52F7AA5C5F4B408151626D1B0D60C08EFA25E165594B40DB3E1E7A240E60C0D2BE9198A0544B40CF542D45900E60C02438663473524B400A83555A0B0F60C01E572FB3D5504B4026E625A8FE0F60C09696C2D8F2504B400642FF7CBF1060C06CAE7E044A534B40164C48CACC1160C06F88621DD5554B40ABAE0AC5B51260C063E150B4A0584B408C0F2BB57F1360C0C96522A1965B4B40666EAB7EF91460C0A07B9FE0A1634B4000DADEDE571660C0F37E7BB4D5694B40ADE8EEEAD51660C0C32F14BBF66B4B401B82A7DEF91760C0CF00D06BC06F4B40491E9D61901960C0C4384555BC744B4045278810EC1A60C0B02E6441C9784B40E55EA0B30A1D60C03ACA4DCD9F7E4B404C14C6BB901F60C0AE2C920E01854B4036615030FB1F60C0C10AEDD646864B409D86D3425C2060C0EEE06815B0874B40C6526850102160C09402F3C7E88A4B405C5EE917C11E60C02B72D6F56F9A4B407F2B8695111C60C05941FF9B8DAC4B40432CCA799F1B60C0129462BA00C44B40C92EB4CAF71760C0304D7A8922D84B40E91E6188421860C0D88D3DA5D7F14B406FFA04F2661560C0CE609EFB7E114C40B3CA74D98A1260C052F07B465A214C406EECA5052F0D60C0E2DC465DC03B4C400E860436E30260C0EF50A6AEA5574C40AEA9B25997FB5FC01EA16520676B4C402F331C7253ED5FC093B49526508E4C4015CEBAE7F2E45FC028C060F34DA04C40F2A774AC28E15FC0887B00D5558F4C4047FC59D7D8D65FC0B9DA55A970634C40C79D84E932D25FC06B2BC5004E4E4C4087CDE22E1BD15FC01DBFB9DE564B4C40BE24960CECD95FC0220FB73B93494C40866ED0B5C8DE5FC0CB54CF62FC464C40635841A16DE15FC05B2E2B6588434C4087A450C94DE25FC030F103AF6D3F4C4065E44B51DCE15FC08B1C3CDEE13A4C40BDED46338CE05FC02964AB321A364C403127A8F019DD5FC0080FFE31AC2C4C40CB9735D34EDC5FC03A61551ED2294C40990D2A2CFEDB5FC0939C6028D1264C40AB374AFBD1DB5FC0847913560C234C40BFAC7504C2DB5FC01536933DE61E4C4079D68BECD5DB5FC0945E2A5700174C408EF6318EF8DB5FC0E5D7632B33124C40033D0F4551DE5FC07979A854450B4C40E7C87E2CACE15FC0B57CBA7949F84B40DACBB783B2E05FC08A060A5276E64B40980ECDABD3DC5FC0DF37E03F00D64B40B1D878CA78D75FC0F4DF4B171BC74B40AA86D6C805D25FC001EF1C3FFCB94B4031E40997DACD5FC0C979398FDBAE4B4043F45EDEFACD5FC089C0AD88C8A84B4072E00C9904D25FC02B4A2CDDF8A44B40919AD4431ADB5FC0F571A7F11CA34B40B805AC6B8FE15FC05C023F86B2A34B405B622B40F1E55FC00930B8F2F7A24B40FD0558EEE0E65FC03568F1777DA24B40A0EA4E36C8E65FC0D9D97602F1A14B40144CB649A9E65FC0D83EABA7B2A14B40671728D08EE65FC0115E16487CA14B401A7DF74599E65FC0B2430D2050A14B4023251DF7A6E65FC005175D4F36A14B40FE963781A5E65FC08DFAC6441DA14B40FDE8CFA9A3E65FC038D5F005D8A04B40ECC7C234B0E65FC0B8D256C3B3A04B408888A42BE6E65FC0C4A524C5A5A04B401F0D69A3F4E65FC0C63E171CACA04B40FF71E4A13AE75FC0317202C3E4A04B40AABDE7785CE75FC0EFDDD419DFA04B40A07AB4B2BBE75FC024EA6115A7A04B40858077F106E85FC096E566E57DA04B40E25D76F239E85FC0BE6C4B945EA04B40	272	117	4046	246	0103000020E61000000100000005000000C6526850102160C01E572FB3D5504B40C6526850102160C028C060F34DA04C4031E40997DACD5FC028C060F34DA04C4031E40997DACD5FC01E572FB3D5504B40C6526850102160C01E572FB3D5504B40	Interior
2	Den k’e	RGB(115, 192, 0)	https://www.firstvoices.com/explore/FV/sections/Data/Yukon/Tagish/Tagish	Tagish	2	The Carcross Tagish First Nation has some fluent speakers of Den k’e (Tagish). Although the traditional territory of the Carcross Tagish First Nation extends into British Columbia, most of their members live in the Yukon.	0103000020E61000000100000068000000409F8A6A37AA60C0A33CC0428D124E40C22F11BEAFAA60C01B7F8A3D270F4E40B4E75ABB3FAB60C0F8EECE35CE0B4E40131227FFE4AB60C06CDA0CFD84084E408E0A4A2C9DAC60C0411C02664E054E40C82627EB65AD60C0DE7BF1442D024E40D9183DE93CAE60C03343E06F24FF4D40C436C0D81FAF60C007BECABE36FC4D405CEE3E700CB060C0B69CCF0B67F94D4073CC4D6A00B160C0943D5233B8F64D40BE5AB882F5B260C065C0458FC8F14D405B7EC33BEDB460C09A5310E67EED4D40D52908DDD5B660C0D6CC6172F2E94D40C99C7F05BFB760C01B5866797AE84D408FC0F4FDA5BB60C0587C22D6EBE24D4078A8E404E9BC60C0900F11C9F2E04D4027826488FEBE60C0E523D37357DD4D408E02705095C060C033BC6A9027DA4D4094CA883EC9C160C0F6434CDA58D74D400E6BB8C0D0C360C011A3845EB7D14D4014C44E1085C460C074A9D05EE8CF4D4067384F1453C560C09CB98BC649CE4D40621A200C8BC560C034C67410D9CD4D40742CA457CCC560C0F5CEE02789CD4D40DE0C0899F4C660C0237DDE411ECC4D40805B4979AAC760C087A92F2471CB4D406A65796F7BC860C03A0376AAC7CA4D40BEF443FA6DCA60C0FB9AB78D82C94D403CCCCD44EEDC60C0EC13168749C14D402388B55D86DF60C03C0F7F34D2CA4D40B31149B50DE160C0D2EA309EDBCF4D4056820AF8A0E260C0420DE58DB5D44D40556FA0703EE460C0D88BF72A49D94D4094F5E94BE4E560C0FE53C8877FDD4D403AB7A08F90E760C0015DBCAE41E14D4010FB492441E960C0CE9F0D9778E44D401654C9D7F3EA60C007115F280DE74D409ECBF063A6EC60C0C8C14140E8E84D401672B57956EE60C0E81E3CBAF2E94D40106ACFA6D9EF60C053BF3EA41CEA4D40F3C5495311F060C013E885B50CEA4D40FE0FF21373F060C0181FDAB8F0EE4D404B419B42F9F060C053AF7059B2F34D40CE29420BA9F160C01D0373EE43F84D4080AD7F9C7AF260C0C57F79DFA8FC4D40EC66F32266F360C0983DF296E4004E40A36939CB63F460C04F82A383FA044E406753F6B7F9F760C0F971E3B64F124E4005253B5957F960C02047F5F3AA174E40C6C9B9BEA1F960C0227ADC2FCE184E409A54AA08BFF960C0537A96116B194E40DCB8E2010CFA60C0E9548F1C071B4E403CC3B02F83FA60C05B6F5763321E4E400B9FBA7ACBFA60C0E9DD18A759214E4016B59BCDDAFA60C0461A1B9404224E407288096BDBFA60C0CE127365EC224E4017DC827DDCFA60C00B7108EC7E244E40F681249CDDFA60C0F7F0701321264E40683E5EDCADFA60C07D1EB389A4274E404E91FB127CFA60C0FEC0924338294E40E1971D5D61FA60C05AD6A3BF102A4E4018FAFE3F37FA60C0A888D409CD2A4E402260887AD3F960C0CB93F9D78A2C4E40BB165CF59FF960C05881A2E6702D4E409E4A35AA4CF960C03F3BA53F5F2E4E4026EE7A10A8F860C02C4EA4E335304E4033D6290D58F860C032CDFD7D1A314E400599EC84E7F760C0F04BEEE00D324E4068AFF1DF0CF760C042F00A55E6334E4054A64CDF8DF660C080E60180F8344E40A8D1E0FA19F660C0D70D975EBE354E40658106DBF2F360C0D3DC6DB469394E40CBF66AA470F360C0538E3E3F473A4E409F714B58C2F260C0563EFE463B3B4E402FBE34C230F060C0B13D31FDD13E4E40868F176ED3EE60C02330807695404E406081141BF9EB60C0217C0C9208444E40B5F02DCE7EE760C0AB2900C6F7484E40767D3024F5E260C01C7203EF8A4D4E40E390E8A229DD60C06B559571F3524E40E5D3DA5313D560C022D57395095A4E40409A80F4A9D260C03955DBB53E5C4E406D9F3CB3E0CF60C0BB7991A9465F4E4046F33508D5C460C082F58E46DA6B4E4051F187434FC260C0AFECC419856E4E40E2B6DE1797BF60C08CF71C901C714E4055739A9E8DBE60C0E4C6AFDA3B724E40BA09EACCC0BC60C06D09F9A3486B4E406CB8F0EF55BA60C08FD5AC8610634E4033ADA53899B760C06B779F98655A4E40E02EE698F1B060C04AB87405B5454E402214BA4C63AE60C0508C62D6303D4E40D87CA649E8AC60C0069FBFA9CC374E403B8B4AAC40AC60C02CC6B10937354E40BBFD161425AB60C0AC167E6D4F304E40144DD93AB4AA60C09AC7D8B0012E4E40CBB44E4734AA60C09C943E5AB52A4E4088517E9EDDA960C02EC1A8FA61274E40B2CA6A5196A960C0F5094DC0EB234E40B45C997A73A960C0B03AEBF96E204E4067DF3BB474A960C0472F4820F11C4E4000D70A7097A960C0162EF60375194E40FF86BB2AD9A960C0C8B5E074FD154E40409F8A6A37AA60C0A33CC0428D124E40	0	0	0	0	0103000020E61000000100000005000000F681249CDDFA60C0EC13168749C14D40F681249CDDFA60C0E4C6AFDA3B724E40B45C997A73A960C0E4C6AFDA3B724E40B45C997A73A960C0EC13168749C14D40F681249CDDFA60C0EC13168749C14D40	Nachako/Stikine
6	Nuxalk	RGB(255, 244, 208)	https://www.firstvoices.com/explore/FV/sections/Data/Salish/Nuxalk/Nuxalk	Bella Coola,Nass	6	Though the number of fluent speakers has not increased, the language is now taught in both the Provincial school system and the Nuxalk Nation's school, Acwsalcta (which means "a place of learning). Nuxalk language classes, if taken to at least the Grade 11 level, are considered adequate second language qualifications for entry to the major B.C. universities.	0103000020E610000001000000700000009E94290E145E5FC084014CE081124A403A90E3C554605FC016341B4330114A4083E63457A1625FC0CE7AE18D18104A40F169BF1926675FC0FCFAAF7E220E4A40A8A0460C98705FC00F63EAB663094A40627276B5CC735FC02AAB16E3F3074A40CC10CC893F765FC01D380C52DA064A40D955F1BDB67B5FC0D3DC7A5997044A40C1C87CB3108C5FC0F7B5D73B26FE494011AE40FBDB915FC0FD66CB60ADFB4940F23678B600985FC0D1AAB44CD2F849408D0D21DEEA9F5FC01C05285F8EF5494005974A7B3EA65FC03EF3063E15F44940FAB1EBE040AB5FC05F6FCAB007F449407F391F7636AF5FC0CB8E7AB005F54940DD83000D63B25FC02AD5C7A2AEF64940F659330D6FB75FC006CF9F177DFA494083C52708D5B95FC0C526A6D9DFFB494036E3EAE914BD5FC04BAEA9A07FFC49409118EB8C2BC15FC043ED507F16FC49401D3A60D298C55FC075E06620E8FA49407A7A7B1363CE5FC07CFEB2ABAFF749400C81A2D436D25FC08E97656660F64940EA7E7FB54ED55FC0B06CEA70C1F54940F6D5E6B066D75FC0965E3AC030F649401EB25BD980D75FC06A2D0E5F75F6494089D79441CAD85FC02C0BF2E1D4F949408225C59EF6D95FC02ED686C2AD004A4044F1382F0CDA5FC01344354F5A064A40B6CEEBC050D95FC069B91433160B4A408018E59E0AD85FC0557B60FB1C0F4A40CC81B8D0F8D45FC04B48D08DF9154A40DBC26DD0BAD35FC0EB42D6BE46194A4057BE96640DD35FC081511FA1CD1C4A40E6AFE91206D35FC0801B7ABF301F4A4022756FC85DD45FC05C8EBBBEF3254A4074B7EA96C9D45FC0CA69FBD665284A407C5EA12723D55FC05E46EDA5342B4A40D09FAAD45CD55FC04DE17263712E4A401C436E3158D55FC0DE801307A8324A408F8950EAD1D45FC09D426A7E32364A403D07D261DFD35FC0188E4285BB384A40DE532C0C9FD25FC057B1A8187B3A4A40B91D35722FD15FC02D116439A93B4A4023D9D904CBCF5FC0700D1F5A183D4A40CA079CFE79CF5FC018C5FFF3BC3E4A40A90AA9A794CF5FC03720B9E2E5404A40396F0D8798CF5FC0F9D3887B27454A4020660D491CCE5FC0090D9EA9E7494A409DA98C6C7DCC5FC08D31769D134E4A407A3862B0ECC95FC0F0E1DAE0504F4A40E2B1FB186CC65FC04E653B12E44F4A4053808EE874C35FC0FC72A9744C524A408631458C56C05FC0B9253B1660554A40E3EE637509BF5FC037E5897487584A40C1D5E98136BD5FC0D3EE58E7FC5A4A4087C79728A5BC5FC090C68136575D4A4050A7F67EA4BC5FC034BBC897BC5E4A40AB64F53CDCBD5FC08D192A7850614A402389EE5048BE5FC0DE37BD82D6644A40AC76A2AEBDBF5FC00045FF19FD694A407A32447415C35FC0C6D795BD026F4A40776D6A9F2EC65FC0CEDCB391C0704A40EC4FF800DDC65FC00FE1A1DE57724A4051096EF5FBC65FC04B63919E46744A40C329023834C75FC015C7B695B3744A405D1F95C593C85FC03AEFE4025C774A40166E1F9B33C95FC02FBA4B7B297B4A40C02FD48D49C95FC079B9A6E3497E4A40196E22ED1DC95FC0B4AD91A573814A40E3199FBB0DC85FC0602B89FD828B4A40B0BAEF3CD8C75FC05F2995252C8F4A40373A77B2DFC75FC06584AAAE0B934A40E51944704CC85FC02944ACB8D0974A406DB74A0131C05FC06D3DECEFB8904A4054EDA385B0BA5FC048F882509A8B4A4006D82C7724B95FC032BDD4506C8A4A40820CB6A84AB75FC00CB8901675894A40A59ED1E95EAF5FC0F92D108909864A40300EC6AEA7A75FC0497EF78D81824A408F4D54291CA35FC05CC7635620814A4042F2CEB7719D5FC065B0627777804A40D804E79610975FC087D3FBB150804A4058EE06B7B48F5FC0BF59425885804A404E6396FE1D895FC00AC044C3EA834A40DDB58492FD835FC00859EF26A8854A400BBF01C6EC7D5FC0CA9E30C2D2864A4096659EA7CB755FC0D3A1E16E38874A4063E16E537A6E5FC0F60BDB2490874A40D5310A2917695FC0837EF568CE874A4089734B290B655FC0A02097E89D864A40B290F2E43E5F5FC0EE9F111F2F834A4094B9EEAF9B5A5FC04DB4EB725D7D4A40A030755A59585FC0F7579B8ECB784A40B097BE8033585FC0A34CE26C67734A40242A94AAA2595FC0B159E81E266B4A400D0C3DB42D5A5FC0158D9DE883614A4061999E46F2595FC0A8991D0517594A401883975A3D585FC05E4A8444BE4F4A405817484AD4555FC01624C65DF4494A40A628D02022535FC07CDADB395A454A40040C635DFE4C5FC01992442D2A3E4A402EA42F8F3F475FC067E114E456394A40EB90F1E1EF415FC08F5F0FD4BF354A4087E64A68553F5FC05752F181A4324A401D6B715A133F5FC0F7F30F80322E4A408E10D69E25405FC09133044720294A40559C72B499425FC0AE56EE2E75224A40A56D2BB4C8485FC0A703D1591B1D4A40DDDF45EEBA4E5FC0E8D18A7375194A4070348F8369555FC0F98F1C8463164A409E94290E145E5FC084014CE081124A40	11	621	1732	18	0103000020E6100000010000000500000044F1382F0CDA5FC05F6FCAB007F4494044F1382F0CDA5FC02944ACB8D0974A401D6B715A133F5FC02944ACB8D0974A401D6B715A133F5FC05F6FCAB007F4494044F1382F0CDA5FC05F6FCAB007F44940	
15	SENĆOŦEN / Malchosen / Lekwungen / Semiahmoo / T’Sou-ke	RGB(255, 128, 0)	https://www.firstvoices.com/explore/FV/sections/Data/THE%20SEN%C4%86O%C5%A6EN%20LANGUAGE/SEN%C4%86O%C5%A6EN/SEN%C4%86O%C5%A6EN	Northern Straits Salish	4	SENĆOŦEN is the dialect with the largest number of fluent speakers. The Lekwungen and Malchosen dialects do not currently have any fluent speakers and may be considered "sleeping"[[Deanna Daniels, personal communication to Towagh Behr, April 16, 2008.]].	0103000020E61000000100000051000000D7F0790737005FC0B5A7181869324840B000BBFFCAFF5EC09D54B19CBF32484072EE2953C1FD5EC060141732A234484034942D6601FC5EC0E4D9EB88CF3648406CB5E1C69FFA5EC08D32971B7B394840A4F68D00B1F95EC05CB6FF3DD83C48407FE27BB249F95EC0BDA5BC3E1A4148409CF6E8B17EF95EC0191ABEAE74464840BC0B636DDDF95EC0C0E05C5E094848402F69D03CEEF75EC03AEDAAA6D84748408CDA5CD7F3F55EC0A06FF67C334948405F22BA1C73F35EC05F0F9A64D24B4840678B5DBF85F05EC0C9E761527C4F484008014C19D5EB5EC0C63B53E7FC534840BEE8A6A112E75EC035B9F5351659484042914FC8CDE35EC0AE8AC45F8D5E4840A86BC1C2EBE35EC0DFB8010BA766484002DD417521DD5EC0667C25EA34734840ABAF987DA6D25EC07CC9C079BC7D4840A6087E54EDD15EC08CFB20079A7E48402A94B28F93D15EC0CC2EDAC0B17E4840FDF7C7B99ED05EC0FE0FA2B5BB7E4840A09C5DAA13CC5EC0D5F64B4D697E4840B8B152751DC95EC0D8C38FF2817E4840C96B7445FAC65EC09059E480DA7E48402B140CD7C1C25EC0E428E6E1E37F4840E4C89FE210BF5EC037A1453C76804840AC4C5D04AFBA5EC04B5B1A8B548248406EBA312FCFB65EC0385BF5D2D283484076CE77AE23B15EC055DDF44D2E844840F9B0B82AC2AB5EC0EEACFB4E578348400CCD03C530A65EC0708490B1FD81484023C0BE7E9BA15EC0070FC71B2A804840ACA2DCDD3D965EC05364D3CD3D7D484093A4C90CCA905EC0229C659D9E7B4840A90CFE88958B5EC072D5A622D97948409485E475B3865EC09ED209CFE8774840ED9AFD7237825EC02D6316ACCA754840B70A406D357E5EC0B0BBE2CE7C734840A1E5C78A7E7C5EC0511B393FB3724840190B485427795EC0DCD1AD3F4D7148409547A6A8DB755EC0ED0D12461C704840AE5DAF6585725EC09B81AE0B186F48400EDC62EB3F6D5EC0C6B5E524D46D48400A1175C166675EC088CBFFE1C86C48407B62AD4E7F615EC04F5128B8F36B4840DD698DB905655EC00E42B57C42694840EE876DDB32685EC07D0F0051A367484079FB225E276C5EC027ADE558016648404CBE8530C0705EC0BB199B545B644840A5A3C950DA755EC0CA2D253FB06248401A3F5328968C5EC0EC948F4DC25B48407BAA3F062C925EC04C44ED63F359484074EFD85B72975EC0BD27E6651B584840B233565B469C5EC0157A7052395648403200A92085A05EC03ECBE7C24B54484073B10DB10BA45EC041F508E650524840342BFC0AB7A65EC03AA3A6B946504840000E304D64A85EC09B3377A62B4E48407A41D76EAFA95EC01E80F03C3F4A4840A8DBBDD684AA5EC0131C72FE88484840DDBF603386AB5EC0E73F7B60ED4648403651710EACAC5EC00ECA32F4664548405EEA64F8EEAD5EC08F8F4B6CF04348404EDEFA21EEB45EC0A233AC61DA3C4840BFB274F143B65EC0B580C52F583B48406C6BD51683B75EC051757BE4C239484016BB1F44A4B85EC0F9CDDB0D163848409EA8B93EA0B95EC0507A2AB44D364840669894EB6FBA5EC063D263AD66344840235987610CBB5EC03A6BE9265F324840617D1B9D6DBB5EC069EBF9FD57304840C85B75F897BB5EC04045029AB92D4840D5F4DE5BBCBB5EC0EF184163382D4840A2C8D5A3F8CB5EC078DF3D116A2A48408440EE7262DB5EC02F9706406426484071547A32B2E15EC0C50B1E75BF2548401163F998A1E95EC0D7425957AB27484005A5B582DCFB5EC0F450E1C63D3048404EBF595018FF5EC0E62D1D77BF314840D7F0790737005FC0B5A7181869324840	6	509	3417	61	0103000020E61000000100000005000000D7F0790737005FC0C50B1E75BF254840D7F0790737005FC055DDF44D2E8448407B62AD4E7F615EC055DDF44D2E8448407B62AD4E7F615EC0C50B1E75BF254840D7F0790737005FC0C50B1E75BF254840	
4	Tāłtān	RGB(0, 224, 0)		Tahltan,Nahanni	2		0103000020E610000001000000ED000000B96B0F4CD11960C0AFFD4E9782654D4092ED5728221A60C08928379245654D400514C9C5191A60C0A084172449654D40CBFB5246A81860C0144302C56D664D40CAA2AD067A1760C03F71649BA8674D40A84D821AFA1260C0B260679EFA6A4D407CE6C2B0041060C0AA6CF392636E4D40CC0139EE750D60C09934FB873A704D40BF707EE66C0B60C087FF13235C714D40F20CC2DB3E0A60C0919CDAFEA4724D409F4F24F0630560C01C7A924E2E634D402AD64E1C9A0260C01F3D135FEE5A4D40100C3107B50160C08BDBC7E55E584D406C08A73C470160C0A963897853574D409613C71A860060C06B9AD3150C564D40ACD035D759FF5FC0D164164102554D4037B9A02788FC5FC042EB9FAFE2534D40D639E555C6F55FC0A87CE93A7B514D40A370CC4ED5F25FC0DEFB88893A504D40DAED4E82C1F05FC054000ECE344F4D4071BB4BB696EE5FC0569A66CFFF4D4D40E09C11A555EC5FC067C75EEA934C4D407659CDECCBE85FC0B1E24C6FFA494D403604638B0DE85FC00C33FF596E494D4041494CB493E75FC03CD259E3F8484D408E22347216E65FC09DAF0C1389474D4097B7B222A4E45FC0ED54741E81454D4066FDF43864E35FC09461DA2204434D40B4A8A84054E25FC0890436141A404D40F9F48ABE71E15FC071911DE4CA3C4D40E91F9831BAE05FC07691FD811E394D4017CB2E142BE05FC047974DDB1C354D4074F926DDC1DF5FC0A5C6C1DBCD304D40DFE2DB007CDF5FC0A075786D392C4D407CAE27F256DF5FC0C287237967274D4099DA4F2350DF5FC012762DE65F224D40E341E10665DF5FC09906DA9A2A1D4D40AFFF83B5D7DF5FC0C22F116F56124D40AD1F3BB49AE05FC0EDDBC9142A074D4070EB7BDE29E25FC03D946F2B4CF64C40509013BFFDE35FC08785D5720AE64C4056A91AC83FE85FC053036EFFFBC34C408B59F5A7C6E85FC0026265F8E9BE4C406A7FF98DEEE85FC06BC2E2B81DBC4C401BFA24EAA4EB5FC0475F8789AEB94C40149810EE67EF5FC016B6BE828CB64C40754C24295A0660C0D5B265EBDF9E4C402D1E0CC2180C60C09CE97CB944954C40755B4A282D1160C0F1EF8D478E8C4C40687F30FDAA1660C0C31B7C4FE5824C40FD8854BB8D1C60C0EB5768E841784C40E21180B3D02260C00A385F529C6C4C40F8B1302ABF2760C01628D62E32634C40059AD1D7D72860C07ED6406C1A644C40DBBE2E76EA2960C069EED2FCCC644C40A8CA4331F72A60C01AC8E6D84B654C40A7BEC435FE2B60C0EF13C6F898654C40D72614B1FF2C60C05AB9A654B6654C40EA053AD1FB2D60C043D5A7E4A5654C407367DBC4F22E60C04BBDCEA069654C40D0A432BBE42F60C0FC17048103654C408F4208E4D13060C078FA107D75644C407187AC6FBA3160C09F1F9D8CC1634C4054AEF28E9E3260C06CEF3BA7E9624C4001BA29737E3360C0C01050C4EF614C4092EE174E5A3460C0D1890BDBD5604C40B7EC6CB1063660C0436441D1495E4C40292B8C9FD73660C054EC009EDB5C4C40CE682DF66F3860C060D3C2AAB8594C4010C1E3C6373960C0F90BEED607584C40D6738FBABF3A60C029A4744771544C40AA52F8D43E3C60C0DFB4653BA1504C402D4845C6B63D60C0303A1C59A74C4C401E61B015BB4260C0E91CC2C7543E4C40828E6CB7DF4460C077C451B974384C4035B54A050C4760C08EF4C5C108334C40F8D9662E864860C0003676B4C52F4C40888DC84D084A60C028FDC9D3DC2C4C40B122F4EBCC4A60C0DB66BCFF8E2B4C40F33438695E4C60C019FC5D1E4A294C40C22BE6BC2B4D60C044593BE056284C40CEC3326CFC4D60C0AD725EA185274C40A34D38B1D04E60C059B79046D8264C401DBA07C6A84F60C00FC68EB350264C403CE6045AEC5060C02ED257A5C3254C4035ED989B895260C07A080C1D3A274C406F4484322E5560C0D3D4854D35294C402BA2F8958B5660C0A947636D552A4C40E73741B3EC5760C0FFC92C48B52B4C406A3621A3AC5A60C0BDDD19EABB2E4C40921626CC365E60C0A2D3518169314C40BF1BC107636160C02288BBE912344C404B9F4D51376460C0862D921DBA364C40444C725C826560C07205ED780D384C40BB61A407DE6760C08F0E3FCDB43A4C40E06236E2F06960C078B4C95A5E3D4C40DF0BF50DC16B60C04F62ABBD0B404C401B0AE8B6546D60C06C6BF17EBE424C4090A8CDC9096E60C0616317591A444C40D097F64A4E6F60C0CB85F2E3D7464C409B41B043DF6F60C0BF5CD8EC39484C40F354CD76E27060C046951F5B054B4C40B32088B0C17160C0B69A77ABDB4D4C40A0B9D3DF827260C0B8647A16BE504C401D1B2EE72B7360C04D071FC0AD534C40F3F702B5C27360C01003B6B6AB564C403B15E5672D7660C062711E4DED644C40415A1029CF7660C009137DC34A684C40D7FE6220877760C04030EC89BC6B4C402B7491965B7860C064464CA0436F4C40FBA286D5527960C04F78DCFBE0724C40F0291D2A737A60C07786778795764C403856CBE8EA7A60C01A9F588FB8794C4032BE669D057B60C032EEB553187A4C40929201F6247B60C0EDE77E34AE7A4C4003C1D18A367D60C0737F4ACD4F804C40F34D38BFF77D60C0B05051145F814C40BA2BC8A0BF7E60C0CE9918CDA8824C402E8E69578A7F60C0195FE24437844C40F23D7E29118060C088F5EB326C854C40DE654D66968060C03BF81353C7864C4026B1D6EA188160C0E4CA20B54B884C4009E998F9948460C025D6E4EFF4944C4096E00ADDC78860C02B86E05494A44C401D28AA3F8B8C60C07759E996FEB24C40B8219B01938F60C0D58BE6BF0ABF4C40A5A5C269809260C08F6669FA3DCB4C4053B1D4C18F9460C004D878C352D44C406D16F395739660C0C67DA5CD36DD4C402810985E1F9860C0A2E31EE3CBE54C40AED53D2F179960C07309EDD649EB4C402EE31BB5EC9960C0C46E8C578EF04C40DB0783289C9A60C0CE7A0A7290F54C403AF2682CA79B60C0C37E00FE2FFE4C40B637DC0E859C60C0F49A15AE2F044D4022E8C1DAFC9C60C091205FF518074D40987FEF7EFB9D60C0AC288224BD0C4D4086CA9A0A979F60C0AA18BDCBBB144D403EA9DF2149A160C0DC8F3210251C4D401F76F3CC6FA260C0097C5AB7BF204D404C6C579495A360C06C5B033513254D406D26ECD8CCA560C0ABC66B3FDD2C4D40A054C21A6EA960C00E646E72CA384D40AAAA0E2156AA60C0292C0086EF3B4D407C6EFE44E7AA60C002F76CE1513E4D400C1B565D10AB60C0DABD3DA3793F4D40B75FDB8D12AB60C08D8C967FEB3F4D40026C94C52DAB60C0B9CC35B910404D406BA9E176EFAA60C0B1A5910C8A404D40F9EA40D186A960C077561D8947434D4056BB24E50DA860C028CE072683464D40CC993ABE8BA660C0E3BC54161C4A4D402014EC7707A560C0C70CEE8BF14D4D40C6E7F0C9CCA260C0AE60076FDB534D40C1185FA54F9E60C0809164FF2B604D40C2C15C4B5C9B60C07C3D2F8AE9674D4046AE6B03979960C0C217156CBD6C4D40CA8498B9F79760C07F07680F5A714D4000FEA2970D9660C0491CEE8C05774D40B8422461628F60C03DCF484D718B4D40797CDB337C8B60C0D4B0762EF8964D4092AF01587C8060C0D1FF0E8C7FB54D405932B040307F60C07A0F4DFBC2B84D40FC2DDDD98B7E60C01052B18336BA4D40564D19C2417D60C03B362F69D7BC4D40FF9411CAF67B60C0C4893B3325BF4D4001E6EEF3AB7A60C08C06E26F2CC14D406AB07E40627960C0E1FE46B0F9C24D40B425E1AE1A7860C01C30038899C44D40739A02558D7260C09CFD5C6E08CB4D406CFD93F2627160C09EE3559B8FCC4D40DFC72DFB407060C0F4BBC9413BCE4D40E425C154DD6E60C01E28F46097D04D409BFEC545516D60C0C13BC3F6F1D34D402C5EF435206C60C0C63897ED52D74D40E1CE8591366B60C03BE79E3D72DA4D4088CD3F1C5B6A60C09C59C0C801DE4D40D86CFBDE8E6960C0330212350EE24D407B39984AA86860C0FC489C3B68E74D40A994DB95C56760C0A14C178F38ED4D40508FDDAFE86660C0B562D20268F34D403CCB389FCE6560C07941272C13FC4D405BD5986CA16560C0C73C67288EFD4D4098B01BC2C66360C055D3E764D7FC4D40B5F49548906160C0D2B9885AD8FB4D4054C43881805F60C0C2BA637AC4FA4D40D4B1CE21965D60C0AA19B0969CF94D4071EC06DFCF5B60C02622237B61F84D4081D6926C2C5A60C026816DED13F74D403974427DAA5860C02891B3ADB4F54D4078AD1FC3485760C040A8007744F44D40C77588EF055660C0DA71B5FFC3F24D40A7CF47B3E05460C08B5DF1F933F14D4034C5ADBED75360C0792EF71395EF4D40AB3AA6C1E95260C0ECB68CF8E7ED4D40D4C6CE6B155260C05FC9554F2DEC4D40816D8B6C595160C049672ABD65EA4D40905E1A73B45060C0853C68E491E84D408F9CA62E255060C0376C3F65B2E64D4037B4594EAA4F60C0EABBFADDC7E44D40E65C6C81424F60C0DB2243EBD2E24D4078243677EC4E60C0A0C95E28D4E04D40FE153CDFA64E60C09E7F6B2FCCDE4D40914B45C5474E60C07BCC44FFA2DA4D4092E52DB51A4E60C01DEF281C5CD64D40719C7A36154E60C049E19940FCD14D4088B2BAD72C4E60C0A5CA822488CD4D405DD76488BA4E60C0805ACD90E1BF4D408FAE9E3CE94E60C00E7DA0E601B94D401D0FA6E0E74E60C0A7E5B12273B44D4009099E9DD94E60C0BCB121722FB24D4078264F8F9B4E60C0DB9D736DB2AD4D4036F18639694E60C0312BB9487AAB4D40372ECC53284E60C02E459A2B47A94D406F8E099AD74D60C01A0EF0AB19A74D40A950D969FF4C60C0D3F2A6B5A19F4D40B3CE455CBE4B60C09EDCD2DC79944D405EB4A253024A60C0FC1B75AA1C854D40FFD03F0E614860C016EAB0A62E764D40A0F91CEBBF4660C058116BB9A16F4D4017747CB0C34360C0E38DA16A56684D40FD7DF03F134360C04D5F39289B674D406FFEF16AF54260C09771C2C0CC664D40E04F1DA2D94160C090DD209091654D40A6A1DABF883E60C08A146BEA89634D40120F51BB6B3860C0981939EA80604D40013CCB2FA83560C023C156312D5F4D40F5ADF3D7792F60C038F34EC1F15D4D40265BE2ED1D2D60C026F1994A965D4D40014DAC1EA82960C0FE01F383AE5D4D40FC4BC312552660C09EEACB16455E4D4023E87EAF1A2560C0C19BA986915E4D4049552F506D2260C0BFD6F47F5A5F4D40C17BD579182160C033DDE257F05F4D40A979A379C71F60C0BBD3621EA3604D40F5D1BB83D41C60C053AA48573B634D40B96B0F4CD11960C0AFFD4E9782654D40	30	157	3248	52	0103000020E61000000100000005000000026C94C52DAB60C02ED257A5C3254C40026C94C52DAB60C0C73C67288EFD4D4099DA4F2350DF5FC0C73C67288EFD4D4099DA4F2350DF5FC02ED257A5C3254C40026C94C52DAB60C02ED257A5C3254C40	Nachako/Stikine
11	Sḵwx̱wú7mesh sníchim	RGB(255, 192, 0)		Squamish	4		0103000020E61000000100000078000000AE6782446EC45EC0946095AF11B0484007AE58132EC45EC03A6B09C4F2AF48400CA33070D2C35EC0ECD1F460A0AF484055D27B2EA6C35EC08DA6E20F52AF4840B061AB1F6AC35EC0CF5057E3E6AE484026353A840EC35EC0D1B545BB9CAE48409F0DFE4C6AC25EC079480CDD5AAE48408A2D341A02C25EC0C6E3D26D4AAE48403F63CC90CFC15EC0BFBF2D7708AE4840CFBD66B296C15EC0F35CB4E46FAD484009EF219E6DC15EC01E6559B0C2AC4840E492A3BE50C15EC07781EE3F0FAC4840EE6AAD351EC15EC00B1FAD4C49AB48404EE51DF92DC15EC01154E2AEF2AA48409D7E05235AC15EC03C45556EA8AA4840D15BB0D053C15EC01BBC05F176AA4840927889FF1AC15EC0D06867BA0BAA48400661FCA1C2C05EC09AC5DCC666A9484003936EAA5DC05EC09705D4D1C1A848403C6CEE911EC05EC0240A75BCD6A74840655155911EC05EC00CBEBE015BA74840073E591BECBF5EC00D2FC546DFA64840472D6631B0BF5EC0760F094A7CA64840491DB230D9BF5EC0A99AC04E19A648408FC920B373C05EC09163254D19A6484062DEB69801C15EC05345F2651DA648408DD728C310C25EC012AFC9EAEFA54840D2069C8304C35EC024CBDD4B1DA648401F1D3AD500C45EC007C8E1CA77A648406EB7F0AECAC45EC0F1807ACBA0A64840B8287E06C7C55EC02E2AA96CE2A64840BAC426CBC2C65EC0AC89405FE6A64840E779B6DE65C75EC077FFD8E6EFA64840876BFFB533C85EC09068BBE451A74840BF3A73227AC85EC0536EFDF7D4A7484010586C30DCC85EC01C42991865A84840F898FEF110C95EC025C0949E8FA84840DFBFFB5F84C95EC02D3257548FA84840413A09B0D9C95EC0C4656CD38BA84840A4E3607D4ACA5EC073E9E95643A848406AE687BAAECA5EC0865F180003A7484007678387F7CA5EC0EF61F12C5EA64840CE28F01B92CB5EC000B0E1A628A64840D7B86A3445CD5EC0FFCAB75501A54840674BFD8C40D05EC0AF12F4C8EEA3484018C70F70D4D35EC0B2E921383FA348407B17409AD3D75EC0C7219A71E8A24840C871FDBD10DC5EC0B2CFED58E0A248405688BE7B5EE05EC0769CBDEE1CA348406623985E8FE45EC08956505794A34840E32968DB75E85EC0EBA691DD3CA44840937D8351E4EB5EC0E6DFEAF00CA548401CD0780CADEE5EC0D9BE2F1DFBA54840DF8FCF2AF2FA5EC054DEDAE8F2AA48400ABCFF5107095FC03B793336A9B14840DFF474625C045FC0F807015ECDB2484090D02C04E3FE5EC09FC67DAC92B44840B070EDFEEEF85EC073995685DCB6484055CEDFFCFAF25EC00B7254AE85B94840FF5D6B82F5F15EC04C5591C3E4B9484072DA7A4801F15EC0A0A04EDA41BA4840CCE3C503F4EF5EC03748899CB7BA48403C17813433EF5EC09B864C6C15BB48403A176BF07CEE5EC07B51B18E8DBB4840C65061D281ED5EC089201F5769BC4840ADF70B9DFEE85EC0F141045363BF484071D545C7ECE55EC0463C07E04FC24840D23ABF187EE15EC0CD56D3B3D6CA4840B36A0ABF68E05EC0A05A1E6A35CD48406376ECC098DF5EC0E07E9DD1EFCF484024F3ADEF19DF5EC011E8FD0872D34840D3B9B527F8DE5EC0448F564028D84840E3BE7D653FDF5EC06A125EC07EDE4840B9561E01B1E35EC0E48AE1F224E8484069017C5A43E65EC02FBA347D76EE4840D93C0377D7E85EC0327DF635D2F54840211D19F319EB5EC044DF1AB9E9FD48404C1D93C4B6EC5EC032A5B6B56E0649404546D231C1ED5EC0B51BCBBA3C114940C171F3E43BEE5EC04DF2104A5A154940BE78D4D2CBEE5EC00E466C7C621949403298975D33F05EC0937D5E4D79214940147EFDE014F25EC080B73D75482A49409D9BC48D84F05EC09D2D0069ED264940EE29962A6BEE5EC01133B1A640244940232A17A8E4EC5EC077CFC21239244940A96519117DEB5EC0C15D2D8A5E244940DD22C214FCE85EC050366D2601254940ECB9B2D0C7E55EC0259E6E221E264940003AA8A5CDE45EC0165F658B58264940C759BF20D9E35EC02774C0D76C26494029D997AEE6E25EC0EC19E8214F2649400F98E5BDF2E15EC0C24F8683F3254940AFB6C5BFF9E05EC04B2F9F154E254940596E3928F8DF5EC00CCCA8F0522449404045C66EEADE5EC0011FA52CF62249403734AB578EDC5EC0B4AA43936D1F494020966229BAD55EC09C63DF0FB81549407FE53D2895D35EC06A2C4BDD7D124940599E3B0283D15EC074DCC631170F49401FE4FE6481D05EC07DAEEAA14A0D494006E51C6FAECD5EC0BE78FBABBF074940A4F88D1C9BCA5EC0D00EF26C5E024940B66076706DC75EC0106776EDA7FD484007A8F53528C45EC09944A41D7BF94840B96FB145CEC05EC020B401F5B6F548402F8A3B8862BD5EC04D5A96733AF24840B7424041CCB25EC0CFA8D6E822E8484097ED1372AAB45EC074194A8271DC484009CECCC981B55EC03C3B0F28CED748401DA60F1168B65EC06EE7FDBD78D3484047156E7069B75EC07FE64D8056CF48409F710F0492B85EC079B041AB4CCB4840549F9FDBEDB95EC05E77547A40C748401E2929F988BB5EC0B340232717C348400663E84E6FBD5EC057472BE8B5BE48409F7529BCACBF5EC030187AEF01BA4840F2F7A526DFC05EC0DDB6F509C6B748405A9C4918E3C15EC02910F9A3AEB54840AE6782446EC45EC0946095AF11B04840	9	354	4553	36	0103000020E610000001000000050000000ABCFF5107095FC0B2CFED58E0A248400ABCFF5107095FC080B73D75482A4940B7424041CCB25EC080B73D75482A4940B7424041CCB25EC0B2CFED58E0A248400ABCFF5107095FC0B2CFED58E0A24840	Lower Mainland,South Coast
3	Tse’khene	RGB(80, 255, 80)		Sekani,Tsek’ehne,Tsek’hene,tθek'ehne	2		0103000020E610000001000000FD000000D971CF7FE2625FC00EB93A7C799F4B40AA8C6C386C655FC05830E513519B4B405DAB5F4BA6695FC00DF8C9FD0D974B40F7CC9200356D5FC0783B702365934B404180FD9251705FC0B024B84BC7904B40B676FEAA9F795FC0677445D49A8F4B40DD1B83A6657F5FC0E2156394878F4B409A467C64E5815FC022E192931B964B40C5A80B913E855FC0656EF794609E4B40F1E6FBA65F8A5FC09E636C62F8A94B40DE13CF48A98E5FC0C1C3587E6AB44B403ADDEB80D1905FC0E5C137E2FCBC4B409CF1075C22935FC0CD5B257302C64B4045EA38C6BC955FC038B6FE2810D24B40E6495232A7975FC0B364A9CCF8DE4B4099FCE7305F985FC0B3971E8480E44B40EEB0165267985FC0DB500AE2BFE84B405440DEA94A9B5FC0DA33512992E74B40EAD7D09D829E5FC083CEE7F974E94B40E8B702DE27A35FC06D2B5F1EF4F04B402CDD9B31C8A65FC0118C962D90F44B40611E01284CAD5FC02D904C2C2EFC4B4008144DF789B35FC0DC6009554A044C403ACD0C4905B75FC0F6AAAB54BD114C4079B95EC02FBB5FC0A0607FD7581A4C400FF46150A6C25FC033E0DD2A7F254C4047D36CCEFDC45FC0CFBA8C3F43304C4074BC97AAA9C95FC04A4ED26EDF3A4C4073221B91A4CD5FC0879CA63920434C403E8633382FCF5FC0B30CA14787464C407B5308BA60D05FC01F59624E5C494C4042FCE22E1BD15FC05B3BBADE564B4C40C79D84E932D25FC0DE2AC5004E4E4C4047FC59D7D8D65FC0B9DA55A970634C40F2A774AC28E15FC0887B00D5558F4C4015CEBAE7F2E45FC028C060F34DA04C4064656E28BAE65FC0AF0D549340A94C408F1EBCD308E85FC0E99B1DAA20B14C400FD39917CAE85FC0B7B03364CFB74C406A7FF98DEEE85FC06BC2E2B81DBC4C408B59F5A7C6E85FC0026265F8E9BE4C4056A91AC83FE85FC053036EFFFBC34C40509013BFFDE35FC01486D5720AE64C4070EB7BDE29E25FC03D946F2B4CF64C40AD1F3BB49AE05FC0EDDBC9142A074D40AFFF83B5D7DF5FC0C22F116F56124D40E341E10665DF5FC09906DA9A2A1D4D4099DA4F2350DF5FC012762DE65F224D407CAE27F256DF5FC0C287237967274D40DFE2DB007CDF5FC0A075786D392C4D4074F926DDC1DF5FC0A5C6C1DBCD304D4017CB2E142BE05FC047974DDB1C354D40E91F9831BAE05FC07691FD811E394D40F9F48ABE71E15FC071911DE4CA3C4D40B4A8A84054E25FC0890436141A404D4066FDF43864E35FC09461DA2204434D4097B7B222A4E45FC0ED54741E81454D408E22347216E65FC09DAF0C1389474D403604638B0DE85FC00C33FF596E494D40E09C11A555EC5FC067C75EEA934C4D4071BB4BB696EE5FC0569A66CFFF4D4D40DAED4E82C1F05FC054000ECE344F4D40A370CC4ED5F25FC0DEFB88893A504D40D639E555C6F55FC0A87CE93A7B514D4037B9A02788FC5FC042EB9FAFE2534D405CCC0634A2FE5FC026D25824B9544D40ACD035D759FF5FC0D164164102554D401F20B7A9E5FF5FC01DEBB1DB57554D409613C71A860060C06B9AD3150C564D406C08A73C470160C0A963897853574D40100C3107B50160C08BDBC7E55E584D40CAD44E1C9A0260C0B938135FEE5A4D409F4F24F0630560C01C7A924E2E634D40F20CC2DB3E0A60C0919CDAFEA4724D405BB16449450860C0FE0639616C744D4049DAA6C5410660C00BC2303A64764D40C238E8C3FF0360C0C7FDD910127A4D40F8B7CD113F0260C025F4BADEA57C4D404D51497432FF5FC0AA34BC72EF7D4D4086BF88CF26FB5FC0780958C6B27E4D403633D6B304F75FC005619B7F4A7F4D40761EEE2855F15FC02BDE343FD27F4D407DF9619FE8EC5FC0A9471B1107804D40CABF3954C1E65FC02204FB750D804D40226F799DEBE15FC040C86611E37F4D4094E87DA223DB5FC087AE64C86C7F4D40D5CC6C03B9D25FC0D07D5E558B7E4D406211E2D229D15FC0DA4D6498227E4D409DAAB1915DD05FC08493FEEFEC7D4D402935F96FB4CF5FC047E6D57F6C7D4D40ED5814A8E3CD5FC05ACEAC400B7C4D40A0B9038E9ACC5FC090B04AE1B67A4D4055F6D0EAF5CA5FC09149ED4E97784D40942399BAC2C95FC09EEFFCB4C3764D40302BAF5E2CC85FC01BEAF0280F744D405B6533DBACC25FC03D47EB20BE694D40A14509E4B3BF5FC0C5C9BC9F8D644D40AA373A95E2BC5FC0FA5292BB33604D402AAA98C6ADB95FC07C490077EF5B4D40B433EEB9C8B65FC09969E9ADA6584D40E43DE5198EB35FC09DDE2A9C89554D405A8595CB81AF5FC0C437D51234524D40F44B742378AA5FC01EBED85E714E4D4095BD1533F4A65FC0E70D6FCF034C4D404F26FBB053A35FC0AB1327F8A5494D407F42C926C99B5FC06ABFCBDC17454D40F9512732E5975FC085BCCBD3E6424D408864286DF1915FC090E8D9C0B73F4D400C6DF169CF875FC0B0B3A2F7AC3A4D409BDB542C927D5FC05EB1CD47F2354D409796049668735FC02357C9EC82314D40E7D6536181695FC0FD6FBC975A2D4D40BFEE69DB8F515FC0EF060BF36E234D404B1D945E0D525FC0ACC8535E6F184D400E3D96620B525FC0DFE9B5CE4A124D40EF6ADD84B9515FC0288A8344330D4D408AB109941A515FC063103A9AD2084D403D16065131505FC01A55EDAAD2044D409C3D307D004F5FC08D623752DD004D4024995337DD495FC0DC05237ADFF14C4075740912E0465FC0A8ED7C8A2EE84C4049B8CCFA0C455FC07590B1A95AE34C4076193903F9425FC00E4F69ABD2DE4C400785720DB7405FC0DAB499458FDA4C40DF413B01273D5FC0B512A0EE9AD44C400ABA2D9A5A375FC077A4B0289FCB4C40A41E96B64B355FC0F03119C146C84C4013CD5BEB7E335FC01899450A08C54C404A52D3B513325FC0F93BB3C524C24C404340BFBFBC305FC0D18BE232DEBF4C4014D574157D2E5FC0DF76FF0AE2BC4C40DD21DB7799285FC090E45A6B1EB64C40A8BD7D94AC245FC076E2DD5D10B14C40A893E67D99215FC0A5CA9A0EA4AC4C4071A1EBF5E81F5FC0E7B8ACD50AAA4C405FD147B3331C5FC08DD4CBEAF3A34C40576D2FF1F21A5FC05C55B21D7DA14C40E25B008E86195FC0EF7B2472269E4C4074764C43EF175FC0494D7A2C089A4C40E52B77C3900D5FC070E21AC50F7D4C40B46E21A957085FC0919C58AB546F4C40E3C62BB282055FC0D648B87462684C407FE279DD88025FC05C7EA9BB82614C4032C8C3A86AFF5EC0573060B0CD5A4C4032AE1F8228FC5EC071C1F3805B544C403CE32FC6C2F85EC09A7B8E59444E4C40651743BE39F55EC0C8B9A564A0484C40A7DF629E8DF15EC04B2639CB87434C40C7994B83BEED5EC02C7517B5123F4C40311B4870CCE95EC069AC2649593B4C40B00EEB4CB7E55EC0C5E4ADAD73384C406BF49F72EADB5EC0729BB9794F324C40374CC67058D35EC013F4D1053B2C4C401C2C5F57E6CB5EC0A7747FEF35264C40F1FB226879C55EC08EE6CB5F3F204C40FEC12514F7BF5EC0CFB4821D561A4C404A196FF944BB5EC0108EA29D78144C40874F9EE048B75EC012420312A50E4C408BE2AEBAE8B35EC0BCEA3376D9084C40A1F6EE9E0AB15EC0EF3C969A13034C40022936C994AE5EC05411BC2D51FD4B40A1D568986DAC5EC032630CC48FF74B409EF8518D7BAA5EC0B0AAB4DDCCF14B40AF203945E7A45EC0FB8BF25E61E04B404AFE918054A25EC08CDDA72B51D94B40FBFB952C6BA05EC08F4AF89B8CD44B400E1C10D1A79D5EC00046FE2889CE4B400C511ECA6A9A5EC0F776471A71C84B400ECFB4B09B965EC074F8B75D41C24B4002A69B8C00955EC02BAE3E6AF4BF4B40AE0F9A4633935EC059D7146D9CBD4B408339B7A136915EC0120307043DBB4B4073EDCB5E0D8F5EC0DBD562CCD9B84B40203D66062D8C5EC065EF0D2EE5B54B400898D24EA0885EC05601E510CCA94B40CA242B308E865EC0EEE3CD281AA24B40C335BA61D9845EC094D563DBA59A4B4071BC22032F845EC0DA55F5A30D974B401B7D3D97AB835EC0192BEED391934B400F0FD7E5D9825EC01D8C5C4DF08A4B40B39DF75A26825EC0B035C088E0814B401F369B21AC815EC0F41729446D794B40BF9EF3D587815EC0B9396EAB6E754B4044EE6D8277815EC0459BBC3FE86D4B40BC042F218E815EC0E0BCC4B3606A4B4059F2120ABB815EC0F96C4C1D01674B40F8D6AD90FF815EC068B7149FC9634B40CE43ED085D825EC0A56A6C5BBA604B406A1B3BC7D4825EC057711874D35D4B40C17CA02068835EC0E88D3A0A155B4B40581EE36A18845EC02071313E7F584B40AD8997FCE6845EC034446D2F12564B4042A08E38E3855EC0468479AE98534B40ACDF67F12A875EC0B6CCCC7EAA504B40679B9E7111865EC0F4FD9F9CBE4F4B400032F64F14805EC0E30EEA34B9474B409B2B6EB9F37B5EC026E9060BEE454B40A82835780A755EC010D4E7EA2E424B404503BA708D6A5EC093EFFDC8803E4B400256DD2D6B615EC0777FDE61223E4B408961ACE9AB5C5EC0261A3008F3364B4064EFC78D91515EC07B1C8393382F4B40AFDB1906314A5EC0557C68F589284B4035AC69A349565EC0D74924FDC52A4B40C090FBE93A5C5EC0B48332C7462B4B40202C33ABF4615EC0CDB3D9A39A2B4B404546489077675EC041ED116AC42B4B40B986E54CC46C5EC0424066EEC62B4B40567C3E9DDB715EC0E377F501A52B4B4067223945BE765EC035C87772612B4B403502B70F6D7B5EC06E7E4C0AFF2A4B40722A2BCDE87F5EC08B7BD28F802A4B402006A27E4A885EC08CCE226D3A294B40EECA3330328C5EC04CBEA44378284B40A58FF2BF73935EC08A369166C3264B4003EBE85BFE995EC0981389E7DF244B40A2B5F967019D5EC098536E67E3234B4051C5CCA9BAA25EC0043D8A26CE214B4018B1024D6AA75EC0CEC8AC00E81F4B40B268376D05AA5EC02762D4A87D1F4B40CF424CD3F1AC5EC0882EC2903B204B4050D8ACEE27B05EC0FC40CD0905224B4086CACA2DA0B35EC02B4F1C6EBD244B4072E981F852B75EC05797E22048284B40DAB3FFAA38BB5EC0482C3D8E882C4B40A1EC259149BF5EC08787EC2A62314B40611968E27DC35EC0C2A51274B8364B40FE262BBECDC75EC08D560AEF6E3C4B400C17B32831CC5EC084AA5C2969424B40812E0690DEDD5EC0864076BDBF5A4B40B00546CA27E25EC01C39862363604B4046CB151C52E65EC096EC524AA0654B40A9F6D2B054EA5EC0363B3FFA5A6A4B401F8B059B26EE5EC024AE9B03776E4B4068B3B3D8BEF15EC08A7D393ED8714B40BA2CBB5814F55EC0F7ED148962744B4054E54A893AF75EC0978561A79C754B402FD34AAFF2F95EC002FEF3BBE1764B40134B02292AFD5EC050126F662E784B40180A2672CC045FC0209D790ED17A4B407A3C7CC78B0D5FC03033BC2E6A7D4B40E58A8CF4D1165FC0D8C9935CE07F4B40C52A95EB6D245FC01425C4B91B834B4065190CB4E6325FC0BD58A77C1A864B404B7A6AC639375FC09D252EC8DA864B4010560A25D1385FC00909FB4E00874B40E69AC6706F425FC0DC16F8C2D28B4B40A5BC841B8E4C5FC0FAFDB37F7F904B402CFCFB54D04F5FC0DF83BC2142924B408B681DDB42525FC041E748F3DB934B40405FAEFB68555FC09C9E8E4E20964B40A028EFA9795F5FC071D4CED3C29D4B40D971CF7FE2625FC00EB93A7C799F4B40	54	232	1546	173	0103000020E61000000100000005000000F20CC2DB3E0A60C02762D4A87D1F4B40F20CC2DB3E0A60C02204FB750D804D40AFDB1906314A5EC02204FB750D804D40AFDB1906314A5EC02762D4A87D1F4B40F20CC2DB3E0A60C02762D4A87D1F4B40	Northeastern BC
30	Nqlispélišcn	RGB(255, 64, 0)		Kalispell	5		0103000020E6100000010000004E0000003862789178D95CC01CE03B3B622348406BD0C24836035DC017525BB10A044840DF478FC964305DC06453651D59FC4740FCAF99B0DE535DC0242701E4C9E74740CBEE2CD8286C5DC0D6D3A3C128D247408903E5FDF77C5DC0BC13694D83C84740A87FDC449D9B5DC05703E506D6C34740C60EA1C866995DC082762EAB24C84740A26022DD6E975DC0B0347464D4CC4740FA2A5357B6955DC06ABA6133D0D147405ACA90183E945DC015227C1003D74740BDCE890C07935DC0AA7968EB57DC474011990A2512925DC0499977A7B9E14740D183CC5460915DC01E37BA1613E747404A54B297F2905DC0FD0E16084FEC474047ED0CECC9905DC06635734158F1474085C9139EB9905DC015C16B434DF64740A5857F278D905DC0DFD4CE6D28FB4740E2E417B345905DC025206A5AEBFF47400EA1036DE48F5DC071E2BCA2970448400A1AAC826A8F5DC0277A1AE02E0948402123A222D98E5DC00F1ECDABB20D48403FCD837C318E5DC087F6389F2412484032D12E21A48C5DC0049C2664D91A4840A8B899CFC08B5DC031E43A6A1F1F4840560CF1E2C6895DC093100BC68A27484083BC5BAFB2885DC0B2961255B32B484084F1DFD361865DC08E1CD64DF2334840DA210D02D27F5DC0C1976C010A494840FB8B75101B7A5DC085CE35D87E5A4840328214DCA2775DC04B03C89BAF614840E5DFEBEC60755DC087BEFBDCFE674840235DBB244C735DC0B838E262886D484037FD8B425B715DC0E755C314687248403C6E3CE5846F5DC08FA83106BA764840CE95A08DBF6D5DC0F6B768819A7A48405B7F15A0016C5DC0BC6AE70F267E484013AC4565416A5DC01BD156827981484028BF209B92665DC06AA5DEF8EC874840E0E90348FE5F5DC0FBEC41B6DA924840438C626D745E5DC01A229E193A95484002C86064A65C5DC0E09899A1C9974840F8F85144375B5DC0732ECFED089A4840E74CF0409F575DC0DCB505BB6EA048407050477EFA555DC0BA8E896602A348402C6FBB78A3545DC0E16A9D4604A748409B119DDEF7515DC01281425121A44840D92D01DFAB515DC099D93718CFA348401B19F3FA2A515DC0EABA165108A348402E526C71934E5DC022D83BFC079F4840432BE4171F4D5DC0D4E77CBF089D4840B1B6A5A31B4B5DC0E9ED7466809A48403000514B3B465DC0991CC10CA7944840A92514E1F1415DC08CD9E39CE88E484090CDC8B651315DC091C885E6D576484084287D6F3C2C5DC0E473DA3D336F484071F57B28F5285DC099F8E6C61B6A48409D74A8A2F7255DC09E86477046654840CA73B2866F235DC04EA1C432EC60484030A7228F20205DC0863352FB035A4840B1A8E9C9771B5DC06C233705AE504840A9D003FCDC155DC0A561782D104648404BF8FE95D2125DC088587C6197404840367CB232AF0F5DC00A4A20B22D3B484072251E737E0C5DC03063415EF3354840C45A21DC4B095DC0B946F8A7083148408F6C7ED622065DC0B7561CDA8D2C484061744BB00E035DC05DF5814CA3284840657FBD9F1A005DC01E8F336769254840F7D339C751FD5CC0D660F1A4002348401D0F9A3ABFFA5CC0B5D14995892148407E7477667FF65CC016B866F2C5204840BB3B2BB27BF05CC045E608D03D2048404428D9AEFFEA5CC0B35B615D292048409FE163D7FFE55CC0A999911C7C2048407C1045D470E15CC0D0784E8C29214840CE27AA7347DD5CC0D9C05E24252248403862789178D95CC01CE03B3B62234840	0	0	0	0	0103000020E61000000100000005000000A87FDC449D9B5DC05703E506D6C34740A87FDC449D9B5DC0E16A9D4604A748403862789178D95CC0E16A9D4604A748403862789178D95CC05703E506D6C34740A87FDC449D9B5DC05703E506D6C34740	Thompson/Okanagan
9	Hul’q’umi’num’ / Halq'eméylem / hən̓q̓əmin̓əm̓	RGB(255, 168, 80)		Hul’q’umi’num’,Halq'eméylem,Hən̓q̓əmin̓əm̓,Halkomelem	4		0103000020E610000001000000D10000006FA4DA68F5595EC0CAC555490FCC4840649CD5C264585EC0D7EB158B97C94840BD4622D32E565EC0FB3AB3711DC4484045E3C52B77545EC0F2F257BF72BD4840D98DB5C853535EC0FBA8FB590FB648401415C523BA525EC07243E3B323AE4840AC0CCBD99F525EC0C645C976E0A548406ECDBCC4FA525EC0BA905F9C769D4840E434F408C1535EC04906C97F17954840F3F3750DE9545EC0FBCF49C8F48C4840399E416169565EC0A77DF60D408548402954A49D38585EC077E291372A7E48404F6433574D5A5EC0356C60BCE27748406B0913219E5C5EC039E7AC14977248400C8FF998215F5EC06BD72DBB726E48407B62AD4E7F615EC04F5128B8F36B48400A1175C166675EC088CBFFE1C86C48400EDC62EB3F6D5EC0C6B5E524D46D4840EF5AAF6585725EC09B81AE0B186F48409547A6A8DB755EC0ED0D12461C704840190B485427795EC0DCD1AD3F4D714840A1E5C78A7E7C5EC0C41A393FB3724840B70A406D357E5EC0B0BBE2CE7C734840ED9AFD7237825EC02D6316ACCA7548409485E475B3865EC011D209CFE8774840A90CFE88958B5EC072D5A622D979484093A4C90CCA905EC0229C659D9E7B4840ACA2DCDD3D965EC05364D3CD3D7D484023C0BE7E9BA15EC0070FC71B2A8048400CCD03C530A65EC0708490B1FD814840F9B0B82AC2AB5EC0EEACFB4E5783484076CE77AE23B15EC055DDF44D2E8448406EBA312FCFB65EC0385BF5D2D2834840AC4C5D04AFBA5EC0BE5A1A8B54824840E4C89FE210BF5EC037A1453C768048402B140CD7C1C25EC0E428E6E1E37F4840C96B7445FAC65EC09059E480DA7E4840B8B152751DC95EC0D8C38FF2817E4840A09C5DAA13CC5EC0D5F64B4D697E4840FDF7C7B99ED05EC0FE0FA2B5BB7E48403D83EEF7DBD15EC0A1F5F6CBAE7E4840ABAF987DA6D25EC07CC9C079BC7D484002DD417521DD5EC0D97B25EA34734840A86BC1C2EBE35EC0DFB8010BA766484042914FC8CDE35EC0AE8AC45F8D5E4840C80200936BE05EC0E841D9DD6556484047CED02FEDDE5EC07261F4825E544840AF092C2A19DD5EC06794BAD2DA53484011440E0E2FDC5EC051F462DB7B534840B57E0F0CA9DB5EC07AC155CD2451484062DC0FEC37DC5EC0C5A1DE80574E484040143DC965E05EC0CD1F60FEA14D4840A0B82C2BA5E35EC0A644153F604D48405E1722BEB0E75EC0793CD4961B4D4840451A2F85EDEC5EC0218AA143374C48405F22BA1C73F35EC05F0F9A64D24B48408CDA5CD7F3F55EC0A06FF67C334948402F69D03CEEF75EC03AEDAAA6D8474840BC0B636DDDF95EC0C0E05C5E094848404CB027F4FFF95EC0984032CF9C484840D4A7A2E909FB5EC09343854C894A4840B66B76B284FC5EC0430537E5464C4840F153625F58FE5EC0964F9C41E24D48401D1AA6F66C005FC04DD85400684F484038D2FA2740075FC05742C3EAF55348402F2F584568095FC0122553BFA3554840AC0F9B29590B5FC0A4921A6A7B574840C62BA5BEFA0C5FC0EA447FB2895948408DF44AE3340E5FC00C79905EDB5B4840A5BC9614C70E5FC08D31CDFBCD5D48406F89432BF20E5FC0D72DA1E1605E48400D21FB56D00E5FC0564D90F9405F48405860E51B940E5FC0A15253CFCF604840AE9E82957A0E5FC0AADAD1C578614840D8E200B1210E5FC079E0E463726248401B358468880D5FC0A0C163A02064484080F115DCD10A5FC008595621AD6A4840457678E45C0A5FC03951A3221D6C48405E41E5791D0A5FC0BB8BABC4686D484081453913230A5FC00F660B15886E484006FA84277D0A5FC0B48B671D736F48403CC8921F120C5FC0E633E2E1C07148403A652D68080F5FC0F0509232B675484044C89C831D1A5FC072327B56108448406FAA8824CD1D5FC0D0D8C5AA518848406A053B10EC1F5FC036C0A265908B48407BE0F5047C225FC0F5B30A37D98E48409C0A4B942A275FC06B8246BADD95484020D7B6C3672D5FC0148F31C3079E4840E281C7A53B2B5FC039FEA53B639F48400C2EF644FF255FC07DFE5A0501A348404253EB0799245FC0C8C61F9CDEA348408DE6E10F2C215FC07356E13B9FA54840FC20F2F9A71A5FC0991FF65B2CA84840E76D6732FC185FC0863C329709A94840390E5A5558125FC0F47422403AAD48400E89D5357C105FC031BE1FD840AE48406130580E760E5FC0170C381F30AF484004FF901A3B0C5FC0687C157DFDAF48400ABCFF5107095FC03B793336A9B14840DF8FCF2AF2FA5EC054DEDAE8F2AA48401CD0780CADEE5EC0D9BE2F1DFBA5484053808351E4EB5EC0E6DFEAF00CA54840E32968DB75E85EC0EBA691DD3CA448406623985E8FE45EC08956505794A348405688BE7B5EE05EC0769CBDEE1CA34840C871FDBD10DC5EC0B2CFED58E0A248407B17409AD3D75EC0C7219A71E8A2484018C70F70D4D35EC0B2E921383FA34840674BFD8C40D05EC0AF12F4C8EEA34840D7B86A3445CD5EC0FFCAB75501A54840CE28F01B92CB5EC000B0E1A628A6484007678387F7CA5EC0EF61F12C5EA648406AE687BAAECA5EC0865F180003A74840A4E3607D4ACA5EC073E9E95643A84840413A09B0D9C95EC0C4656CD38BA84840DFBFFB5F84C95EC02D3257548FA84840F898FEF110C95EC025C0949E8FA8484010586C30DCC85EC01C42991865A84840BF3A73227AC85EC0536EFDF7D4A74840876BFFB533C85EC09068BBE451A74840E779B6DE65C75EC077FFD8E6EFA64840BAC426CBC2C65EC0AC89405FE6A64840B8287E06C7C55EC02E2AA96CE2A648406EB7F0AECAC45EC0F1807ACBA0A648401F1D3AD500C45EC007C8E1CA77A64840D2069C8304C35EC024CBDD4B1DA648408DD728C310C25EC012AFC9EAEFA5484062DEB69801C15EC05345F2651DA648408FC920B373C05EC09163254D19A64840491DB230D9BF5EC0A99AC04E19A64840472D6631B0BF5EC0760F094A7CA64840073E591BECBF5EC00D2FC546DFA64840655155911EC05EC00CBEBE015BA748403C6CEE911EC05EC0240A75BCD6A7484003936EAA5DC05EC09705D4D1C1A848400661FCA1C2C05EC09AC5DCC666A94840927889FF1AC15EC0D06867BA0BAA4840D15BB0D053C15EC01BBC05F176AA48409D7E05235AC15EC03C45556EA8AA48404EE51DF92DC15EC01154E2AEF2AA4840EE6AAD351EC15EC00B1FAD4C49AB4840E492A3BE50C15EC07781EE3F0FAC484009EF219E6DC15EC01E6559B0C2AC4840CFBD66B296C15EC0F35CB4E46FAD48403F63CC90CFC15EC0BFBF2D7708AE48408A2D341A02C25EC0C6E3D26D4AAE48409F0DFE4C6AC25EC079480CDD5AAE484026353A840EC35EC0D1B545BB9CAE4840B061AB1F6AC35EC0CF5057E3E6AE484055D27B2EA6C35EC08DA6E20F52AF48400CA33070D2C35EC0ECD1F460A0AF484007AE58132EC45EC03A6B09C4F2AF4840AE6782446EC45EC0946095AF11B048405A9C4918E3C15EC02910F9A3AEB54840F2F7A526DFC05EC0DDB6F509C6B748409F7529BCACBF5EC030187AEF01BA48400663E84E6FBD5EC057472BE8B5BE48401E2929F988BB5EC0B340232717C34840549F9FDBEDB95EC05E77547A40C748409F710F0492B85EC079B041AB4CCB484047156E7069B75EC07FE64D8056CF48401DA60F1168B65EC06EE7FDBD78D3484009CECCC981B55EC03C3B0F28CED7484097ED1372AAB45EC074194A8271DC4840B7424041CCB25EC0CFA8D6E822E848409590E5673EAF5EC0F65D128382E4484009C0DA1AA8AB5EC063BC66007FE04840AAF9484F13A85EC09B4EB26DFEDB4840C9BEA1B483A45EC0C91DC17DE0D648409A2B393CFDA05EC0A4FF263F05D148403E566A2DD89D5EC071074C77FECA48402DF9C03D919C5EC0769FB1E407C9484094132032169B5EC077D7319C94C748406787B7A66D995EC00869E2C797C6484096FD55339E975EC0643EDA9404C64840BE09826DAE955EC0A53AA033CEC54840CB1C37EAA4935EC022906FD8E7C5484063F9643F88915EC0BD447EBB44C64840D46528055F8F5EC046C03B19D8C6484028B02E53018B5EC00AF3F24C6FC84840FE874E8632815EC092D28876B7CC48403A83B6DFE3795EC047799C2C94D04840C4F32882C4765EC0807E3C71FCD14840EE680D8C40735EC057E2D1EC06D3484063EB068E2E705EC07B554572B7D34840CB1F7108E16B5EC0C2EAD6D654D44840903357BF2B685EC0CC0C8CA85CD44840125F503D8C645EC0510FBF4ED2D34840E88E089515615EC0B898669B97D24840A2AADDD0DA5D5EC0B2D5585B8ED048401E03C34CB35B5EC072260CFD5FCE484087404BA2415B5EC08CC692FEDECD4840E7E8B259275B5EC0ABF6B7FEB6CD484055B568AE085B5EC050972D72B0CD4840661046AEE45A5EC05859FDBF9FCD4840702F200ECC5A5EC044C32D5D99CD48409F2C173CBA5A5EC0196A0BE0A7CD4840621BEBC89F5A5EC05A7863DDBDCD48403449D47F875A5EC019E07A57C4CD48402CCB4D986C5A5EC09B541EE4C2CD4840105583594F5A5EC02C231460A8CD48406CE76E833B5A5EC079AE1ED589CD4840959C3ADC295A5EC0D5532A7E4ACD4840080DD1B0295A5EC05AD37D5911CD48408127F80A225A5EC0E8DC28D3E5CC48405AC388E6015A5EC0DEBDBA5F91CC48408CAECBAEF7595EC0CC8CDE6140CC48406FA4DA68F5595EC0CAC555490FCC4840	70	1099	18381	355	0103000020E6100000010000000500000020D7B6C3672D5FC03AEDAAA6D847484020D7B6C3672D5FC0CFA8D6E822E84840AC0CCBD99F525EC0CFA8D6E822E84840AC0CCBD99F525EC03AEDAAA6D847484020D7B6C3672D5FC03AEDAAA6D8474840	Fraser Valley,Lower Mainland,South Coast,Vancouver Island
20	Dene K’e	RGB(192, 255, 96)		Dene,Dene Tha’,Acha'otinne,Slave(y)	2		0103000020E6100000010000007A000000DEE7F0E19B105EC0C79AC4E6E2D14C40B4B5282DD8135EC0AA99F47259D04C406704E6E4F7165EC02EE98DF633CF4C4035B0561CFC195EC00E2F67AF6DCE4C405CCFBFE7E51C5EC089976FD901CE4C404B902B5BB61F5EC0C812E9AEEBCD4C40ACED8A896E225EC005E3966826CE4C40CE8127840F255EC0DE8AE33DADCE4C40EE634D5A9A275EC0134C00657BCF4C40868E1C19102A5EC070ACFF128CD04C4051BFEECA712C5EC0D7B96A7BDAD14C405CCD3E77C02E5EC027443CD061D34C40C6B46424FD305EC0C6238E431DD54C406EC6A8D628335EC0C32FB00608D74C401C07569044355EC098332C4A1DD94C408200D95151375EC01E7AD13D58DB4C404826E01950395EC01256BF10B4DD4C4062437CE5413B5EC06BC56EF12BE04C402A215C74023F5EC04D90EA925CE54C4071461ECB9A425EC024C8488AC3EA4C404B36A86CBF4C5EC02D5B3D08BCFA4C400C5D1D54C2505EC0CC524E5A8E004D4093CA15AE22545EC08359C8C2BE044D40031566C668575EC073A4E7060B084D40BF716E2FBE5A5EC00F182F8F760A4D406445207BC85D5EC0B3205471B20B4D404695A25EA1695EC06DA8E25AA10D4D4053CFC07927735EC0C2805CDC8A0F4D40507F0984FA765EC07FDD5E1ED20D4D409709B6C9E0795EC04EF63EBDA20B4D40D3BAD7DD387D5EC0FF1BBA7AC6094D400D1BA83EB6805EC0CA4004FD12084D405E944440AD845EC0F2E34EB272054D404242F400F1885EC0D0F4B6779F024D40501E9ED7518E5EC03C9F2E961C014D4063F3ADD755965EC0E6F80B4570FF4C40C55294C95BA15EC0AFD3A41641FE4C40D5F83F5E34AC5EC07411C1EDD8014D400EA9F1A144B05EC044E24F218D054D40938C4D1377B15EC038AF38ED3D094D400997189291B35EC03E0F4496370E4D4028D9C39CDFB35EC0F8C15082C5164D40BD24B001DCB35EC01DEE4B690F1C4D40B0E2E1F0ABB55EC069E14D6D64204D40F38A3822DBB85EC0022FA1F40B254D4080E3DF2538BA5EC082027349B2294D40BDC3C7090EBA5EC0E8A04AC4FD324D402611E41773B75EC0E82AAC87C1384D40B3857EBAD5B45EC0436D6109A43F4D40E6A371466FB75EC046BF24333C504D40BF71BC1D33BC5EC073FFA5BA135A4D408831ECE9F3BE5EC0B04589BE4D5D4D407ADB35BD70C25EC049FFDCB50E614D405F51A3A368D25EC02FC8DD5B9B714D405EBD75242EDB5EC001755033C47A4D400E742F6A09E25EC0FBFE784B11824D40A9C6793CEAE85EC0EFD240CA94894D409A9DC71F9EEF5EC07BB6CEC02A914D401C64B908F2F55EC09623A78AAF984D409E65F35EB2FB5EC0668648C5FF9F4D401F784D3B1CFF5EC098B5F157B1A44D406ADB0ACE1D025FC0DE82308731A94D401D24E721D0045FC0E7D8B2ED79AD4D4082757C26DA095FC027F2A402A4B54D400D1DCC626F0E5FC024CAC29547BD4D405FDB47D194125FC0C1024E8C67C44D40F5B7F0864F165FC0B4C461BF06CB4D40E02F8894991C5FC0FC51880BCED64D40737394FD77215FC0ED921B85B3E04D4014F0C36E6C235FC0183CA356F8E44D40E8B3D642D1255FC02C303FAD8DEA4D40CCE506A2A1275FC09D0F0C142FEF4D40DED865E3F0285FC06EA43865E5F24D40C11E6804092A5FC01E4CCCF779F64D409456C344AF2A5FC0E16E6BAC3EF94D40859391E1A52E5FC0BD1905623C034E40B4E388882C305FC0D425B159B3074E40BA62FE674D315FC01559B3C3810B4E40EE4B717961325FC00F013F63BE0F4E406BE2D2B860335FC0482CD7E171144E4043FD509F43345FC05464A7B9A4194E40970DC4C5FD345FC0F3C30C49641F4E40930EE39E5D355FC03904287BDA254E400E67AA4F7A355FC087B7BA017F2A4E40E14C836969355FC0B000242EFD314E405D85EAFE31355FC0B30AC02E5A374E40D0FFC86095345FC03267DECDF93F4E40DB88E6ADF7335FC07E76903F20464E4012A00DE02B335FC0CEFE3B009C4C4E401C3F2CF32E325FC09FDC14C06F534E40E23FCE4186E95EC0456D76FFB38C4E4020C22E224DDE5EC0D605DD8ED9CA4E408B524B729ADA5EC011A82FB07AE54E409D3C46B3D5D75EC0372A6F5A461A4F404F80DB8CF2DB5EC09A71258272424F401C63047ABEE45EC08429B6D727734F40425DE66CD0F15EC0E19881BA0EA34F40B47922FA16A85EC0B8ECB0928EB64F40AE0CAB322B1F5EC0AB2FA5AC4B5F4F40AD1CB07A19CA5DC0B82B320121054F40B45D5756916E5DC02BDC5AEDF3AC4E407B014F57973E5DC0AE1209A34F714E4035DC5C0928275DC01C92382E37064E401C0DE0B8D62A5DC02B532C3CAAF84D405D251D2FC2305DC03D32BDE726EF4D404423418E1E325DC06894FA588AD04D40CC56E61D7D2D5DC0F509AB21F2BC4D40258DC2F9AF2A5DC0ADFF3F0D94B04D4003BF158CE1295DC0905A959146944D4040A2C488BF265DC03620968751814D402BC27EA418265DC05BDDEBD9196E4D40BD2C35186D275DC06C6B8A38495A4D40FF268CE0E52D5DC007B2D765064B4D409EAE47868D335DC030A99069AD3B4D4027350E0BB7405DC0C97F75E22E2A4D4018F0E81F274F5DC0B07A2BA52D244D40E786C7E4C8655DC0598FB5D27E174D406DCEEC3E04835DC050213FC7110B4D40D589F7DF63A55DC019D90C5018FC4C40EFF2917174E05DC0AFEDFF56E1E24C408195903E47F95DC04A3F78CE5FD84C40DEE7F0E19B105EC0C79AC4E6E2D14C40	58	193	813	128	0103000020E610000001000000050000000E67AA4F7A355FC0C812E9AEEBCD4C400E67AA4F7A355FC0B8ECB0928EB64F402BC27EA418265DC0B8ECB0928EB64F402BC27EA418265DC0C812E9AEEBCD4C400E67AA4F7A355FC0C812E9AEEBCD4C40	Northeastern BC
22	Dane-Zaa (ᑕᓀ ᖚ)	RGB(144, 240, 0)		Beaver,Dunne-za,dʌnneza,Dane-zaa Záágéʔ	2	"English is now the first language of most Dane-zaa children, and of many adults in our communities. Dane-zaa Záágéʔ was our primary language until our grandparents and parents started to send our children to school in the 1950s. English only became dominant in the 1980s. Because our language is orally based, Dane-zaa Záágéʔ becomes increasingly endangered as our fluent speakers pass away."[[277]]	0103000020E610000001000000DB0000003F8A8785C6B25DC065B890B79BB04B401F863519F6B45DC06879381054AB4B4006757C9849B95DC06A555956D7A04B40EBA3C1022DC25DC01279E25438914B4051F09C28C9D35DC0176B075482834B40F12777B8CBE15DC07AE8F172767C4B40AB2FEB20B5F65DC08895D801477A4B405B5B7FD6B7FC5DC07D8ADDA33E7C4B402272C3DF5F035EC07440A40BA17E4B40731CD6686D085EC0737798B383804B4074A2E0DA3A0E5EC047A2E968CD824B40BFF1323E62205EC07C1CABA74E8A4B40383BEB5FFB275EC02655D1DE3D8D4B40A1ED64D7732F5EC06EF530B6F18F4B40D2906A0C583A5EC0E53E1BB78E934B40E8894FF1C1445EC0E229A3CBA2964B40B39A270B954E5EC00108B6742C994B4016C30C28B5575EC08B290D742A9B4B4075502E1CE1605EC020ACD732E29C4B401C421D6766645EC0EDC0FDABCA9D4B403DFC9BA9E6675EC0970B0B0AE69E4B40B1A0485E5F6B5EC00EEEF69930A04B402E9970FBCD6E5EC0275322ABA6A14B407D31F2F22F725EC07DCB478F44A34B40AF2D29B282755EC0FEEF679A06A54B401EDBE5A1C3785EC091A6B122E9A64B40CC5F6E26F07B5EC0430B6680E8A84B4060B6899F057F5EC079B5B70D01AB4B405325946801825EC0702BA5262FAD4B40CFE99CD8E0845EC02163CE286FAF4B400CED8C42A1875EC02D314573BDB14B40203D66062D8C5EC065EF0D2EE5B54B4073EDCB5E0D8F5EC0DBD562CCD9B84B408339B7A136915EC0120307043DBB4B40AE0F9A4633935EC059D7146D9CBD4B4002A69B8C00955EC02BAE3E6AF4BF4B400ECFB4B09B965EC074F8B75D41C24B400C511ECA6A9A5EC0F776471A71C84B400E1C10D1A79D5EC00046FE2889CE4B40FBFB952C6BA05EC08F4AF89B8CD44B404AFE918054A25EC08CDDA72B51D94B40AF203945E7A45EC0FB8BF25E61E04B409EF8518D7BAA5EC0B0AAB4DDCCF14B40A1D568986DAC5EC032630CC48FF74B40022936C994AE5EC05411BC2D51FD4B40A1F6EE9E0AB15EC0EF3C969A13034C408BE2AEBAE8B35EC0BCEA3376D9084C40874F9EE048B75EC012420312A50E4C404A196FF944BB5EC0108EA29D78144C40FEC12514F7BF5EC0CFB4821D561A4C40F1FB226879C55EC08EE6CB5F3F204C401C2C5F57E6CB5EC0A7747FEF35264C40374CC67058D35EC013F4D1053B2C4C406BF49F72EADB5EC0729BB9794F324C40B00EEB4CB7E55EC0C5E4ADAD73384C40311B4870CCE95EC069AC2649593B4C40C7994B83BEED5EC02C7517B5123F4C40A7DF629E8DF15EC04B2639CB87434C40651743BE39F55EC0C8B9A564A0484C403CE32FC6C2F85EC0267C8E59444E4C4032AE1F8228FC5EC071C1F3805B544C4032C8C3A86AFF5EC0573060B0CD5A4C407FE279DD88025FC05C7EA9BB82614C40E3C62BB282055FC0D648B87462684C40B46E21A957085FC0919C58AB546F4C40E52B77C3900D5FC070E21AC50F7D4C4074764C43EF175FC0494D7A2C089A4C40E25B008E86195FC0EF7B2472269E4C40576D2FF1F21A5FC05C55B21D7DA14C405FD147B3331C5FC08DD4CBEAF3A34C4071A1EBF5E81F5FC0E7B8ACD50AAA4C40A893E67D99215FC0A5CA9A0EA4AC4C40A8BD7D94AC245FC076E2DD5D10B14C40DD21DB7799285FC090E45A6B1EB64C4014D574157D2E5FC0DF76FF0AE2BC4C404340BFBFBC305FC0D18BE232DEBF4C404A52D3B513325FC0F93BB3C524C24C4013CD5BEB7E335FC01899450A08C54C40A41E96B64B355FC0F03119C146C84C400ABA2D9A5A375FC077A4B0289FCB4C40DF413B01273D5FC04213A0EE9AD44C400785720DB7405FC0DAB499458FDA4C4076193903F9425FC00E4F69ABD2DE4C4049B8CCFA0C455FC07590B1A95AE34C4075740912E0465FC0A8ED7C8A2EE84C4024995337DD495FC0DC05237ADFF14C409C3D307D004F5FC08D623752DD004D403D16065131505FC01A55EDAAD2044D408AB109941A515FC063103A9AD2084D40EF6ADD84B9515FC0288A8344330D4D400E3D96620B525FC0DFE9B5CE4A124D404B1D945E0D525FC0ACC8535E6F184D40BFEE69DB8F515FC0EF060BF36E234D40E0C8B45171495FC00310AF69D61F4D40FBA25C7AC3425FC0743544D5891C4D40E6E1A96172395FC01B2998E942214D40EAC58464CE305FC018F1503755254D402545B824C1295FC000416AFE59284D403AD72C6657235FC000AEC7CEBA2A4D406668DF230C215FC01AF43F18CB2B4D40E8B4676AD91B5FC095CD0CA49D2E4D4032D666E5450E5FC001BEF2D081364D40E975D42836085FC0CE49C7DEE7394D402A70C3E1E7015FC0D58316E13C3D4D402EC4D46167FC5EC0DC1932A8EA3F4D405F041306E6F65EC0CE0CC0CA52424D40D2C840FAA8EF5EC0E6F7795A20454D40B157CB8B08E75EC057C3B7014B484D4071E7286DE0D35EC00641E899084F4D404A51C0FE85CE5EC0432A47E800514D40F71ADB9B7ACA5EC02B4A01BF99524D40E7D8E40B24C65EC0810045A081544D404F4B87A161C25EC021C3FC7672564D40AE80DED737BF5EC04DC857DA78584D40DCCA1011A4BC5EC02890D537985A4D40BF71BC1D33BC5EC073FFA5BA135A4D4041D8F195F9BB5EC0CA02FB2E9D594D40E6A371466FB75EC046BF24333C504D40EC841835E8AF5EC0B69ED53E543F4D40E54763EA90AD5EC017AAB7843B3A4D4009AE0A7D2DAB5EC00C7E3A7B66354D401B3F2CDDA9A85EC0C73F504ED4304D4026BA6A0EF2A55EC0FB49951D842C4D40609E4725F2A25EC0562C25FA74284D4083BE3CF150A15EC0E1160B7E85264D40CD1DB644969F5EC036627CE3A5244D40335EF8A5BF9D5EC09A1BFD06D6224D409F7FED9BCA9B5EC0A73268C315214D40ADA217AEB4995EC0C1D9C1F1641F4D40BF7285647B975EC0EC290669C31D4D401A3AC8471C955EC0401CF4FD301C4D40100EECE094925EC075CED482AD1A4D405A5272B9E28F5EC0C7253FC738194D406CF94E5B038D5EC039D5D797D2174D409D3CE950F4895EC06FD00DBE7A164D40E33C2025B3865EC0C541D3FF30154D4073C554633D835EC08613531FF5134D40BA277997907F5EC0F829A3DAC6124D40DF0E294EAA7B5EC0817273EBA5114D4053CFC07927735EC0C2805CDC8A0F4D404695A25EA1695EC06DA8E25AA10D4D407E35658F045F5EC0312A9373E60B4D406445207BC85D5EC0B3205471B20B4D40D1DF5E48475D5EC0B515B20E7E0B4D40D90DDBB7905B5EC00F2CCD14CC0A4D40BF716E2FBE5A5EC00F182F8F760A4D4009D076FBDF595EC058288E61D5094D4099B4B82E34585EC00B0717D09E084D40031566C668575EC073A4E7060B084D408CFD406B8C565EC0874F073B2D074D40F28DF5C8E7545EC06403817C85054D4093CA15AE22545EC08359C8C2BE044D40E993295E45535EC0C90E2D6EAC034D40D0DEC03FA4515EC0CD233FE9A6014D400C5D1D54C2505EC0CC524E5A8E004D40C7EC4E8103505EC09BE278C679FF4C404B36A86CBF4C5EC02D5B3D08BCFA4C4071461ECB9A425EC024C8488AC3EA4C402A215C74023F5EC04D90EA925CE54C4062437CE5413B5EC06BC56EF12BE04C404826E01950395EC01256BF10B4DD4C408200D95151375EC01E7AD13D58DB4C401C07569044355EC098332C4A1DD94C406EC6A8D628335EC0C32FB00608D74C40C6B46424FD305EC0C6238E431DD54C405CCD3E77C02E5EC027443CD061D34C4051BFEECA712C5EC0D7B96A7BDAD14C40868E1C19102A5EC070ACFF128CD04C40EE634D5A9A275EC0134C00657BCF4C40CE8127840F255EC0DE8AE33DADCE4C40ACED8A896E225EC005E3966826CE4C404B902B5BB61F5EC0C812E9AEEBCD4C405CCFBFE7E51C5EC089976FD901CE4C4035B0561CFC195EC00E2F67AF6DCE4C406704E6E4F7165EC02EE98DF633CF4C40B4B5282DD8135EC0AA99F47259D04C40DEE7F0E19B105EC0C79AC4E6E2D14C408195903E47F95DC04A3F78CE5FD84C40EFF2917174E05DC0AFEDFF56E1E24C40D589F7DF63A55DC019D90C5018FC4C406DCEEC3E04835DC050213FC7110B4D40E786C7E4C8655DC0598FB5D27E174D4018F0E81F274F5DC0B07A2BA52D244D4027350E0BB7405DC0C97F75E22E2A4D409EAE47868D335DC030A99069AD3B4D40FF268CE0E52D5DC007B2D765064B4D40BD2C35186D275DC06C6B8A38495A4D40F4A59ECE68185DC0287DF95D9E5B4D40D2734F64990A5DC0641725E089584D4029054717D0045DC0F3F97743C24F4D4032D3FE03F0035DC0A69D2176FA404D402524829F7A055DC0A17435D250354D40AC132F4980095DC0EB2FFBD0F52B4D402B81AD33EF185DC0CC817764B2284D406039166108335DC080F108D586274D400FD1365CF3405DC07B805DFEAA1E4D4049063101BF5D5DC063B41B7F32124D4088F99C2E056A5DC0E61001BDA7084D40536A883D106D5DC02488F3D8B9FE4C4022A0CEA19F6F5DC021B60223FAF54C40D53B6AB97C775DC0A671118F5DE84C4084BAC2936F785DC06038573700DB4C40266654E425785DC0FDD3E8E32AC44C40C1B997C163785DC09E00AF7C6AA54C40F2A45A8DA57C5DC0D3490B31BA984C405CB271AD9E825DC076C394D6CD824C4053D7D21553885DC035E532851C704C40B20ED870388B5DC0151F6ADD0B604C40B881F4BC8A905DC0299113BE33524C409DDDEC051B975DC02AC8515E21494C403441CA6A899C5DC05E8715236E384C4012F8085B49A65DC0DACA9EC84D154C4088EDB9F9DCA85DC059F24CDB0C084C40D52C4BA7A4A95DC05BD8922DBFF34B4060C0F9C8D4AB5DC0ED303FE676E64B401EA18F528DAF5DC0D13C403450DD4B405BD0C004DFAF5DC0F2EDDC41E7CF4B40BDC9D052BEB05DC0FA5598ADC0BF4B403F8A8785C6B25DC065B890B79BB04B40	298	352	1644	210	0103000020E610000001000000050000004B1D945E0D525FC08895D801477A4B404B1D945E0D525FC0287DF95D9E5B4D4032D3FE03F0035DC0287DF95D9E5B4D4032D3FE03F0035DC08895D801477A4B404B1D945E0D525FC08895D801477A4B40	Northeastern BC
24	X̱aad Kil / X̱aaydaa Kil (Haida)	RGB(160, 0, 160)	https://www.firstvoices.com/explore/FV/sections/Data/Haida/Hlg%CC%B1aagilda%20X%CC%B1aayda%20Kil/Hlg%CC%B1aagilda%20X%CC%B1aayda%20Kil	Haida	\N		0103000020E610000001000000A3000000A3BEDEE8B2A760C03C2DEEFF049A4B40C6C7502544A660C0CFE74E36999E4B40BA0750EBDCA460C07D4E2DBDB6A24B403B3BB78BB8A160C0D520503CC0AA4B402357014E329760C0C4A6BF3510C54B408791B98DF99360C0331027B41DCC4B40DB78E83C539260C01FA8B42A10CF4B405BE0DC9FEB9060C075CF523D16D24B408C7E8AFBDB8F60C06D12BD1388D44B40EC9FBCDEE88E60C0B9B3F78B8CD64B40892BABF6F88D60C0C4A7972F13D74B405A8CCE5BD18B60C0397D40CE62D94B40A26B148E578960C0F23ACD9A85D54B403E426EE43E8860C05FEEC3157BCB4B408448E3F3458560C0EE259A76F0C44B407F0522A84F8260C0BC00EB2301BB4B4034B54E6DBA8060C0195EBBFB74B24B402636BAC15D7E60C0C7B26BE887A64B40C0D50E6D8F7C60C032AFA4EDC2994B40FE616191117B60C0A962515BED8E4B40C58D88F55E7760C0D6D645D655784B404D2F48D3327760C016D32AD13E6B4B403D1B28883D7560C036EFA3B0B95F4B4032BC5B8B4E7460C093AA925DF2594B4064CE6982B47360C076ECC753FA554B406B45CAE1007260C03117926FA9444B40C0DFBD6F1B7360C0BF88063AAC2E4B400CE2CED3987460C0586050E6FA144B40B34C2C981F7560C076F69B80B9094B401BCAEECDF97560C0075EE73BF9FD4A40247F7222787660C0AC6D0B2FFDF94A4088CB0A3AEB7760C054EBF37864F34A40553F1AA71A7A60C00D61375EAFE74A40055C8613407B60C08414178422DF4A4023DFFECEBC7B60C0B75F1E5A80D64A4088FA01B1277C60C0B10E1F2D16CF4A40C311BD64167D60C09AD3D9350AC84A40146870781B7D60C0CF5E28D3F8C14A400FEECB6B1A7D60C0A15C055166BB4A40F6F419C1207C60C03D029CE4FEB34A40BD2E7750417B60C0FE01F63E7EAB4A408A83054A807A60C017B05F1634A64A40B9D35FD28A7960C0B738B56C6FA14A40F6F77F6E757860C04E38E3970E9E4A40FCC87F70647760C054A9AA2B41994A409D748FA62A7660C02E12EC52D9924A40679C2D4FFF7360C09D3092E1F78C4A40E9D5013F247360C085CB50929D884A404F1B8367BB7260C06F41ACF3F7824A400D06B953D57260C004915A02F97F4A4063B2E80C117360C0A17303F5667E4A40454128A3FD7260C0E43CE34C497C4A40A6579BF2407060C0DD4949523D764A409221148A3E6F60C07A9C13E5FC704A4002A47A784A6F60C093EABC3F1E6F4A402FDAAD842C7060C0E33BD33DDF684A4025033A37D87060C0B958744083644A405A336A29017160C0CCA9941DAF624A407D7DDCEA346F60C0F2628ECA8D5E4A4005334A98D26D60C092E1A7FDF05A4A4050448613856D60C0FBD7017186564A4084B81AC2C46A60C0511B7AFAAA474A40878CFA967D6760C0A3BC1667EC384A40CCE3B604316760C0059CA27AC6374A406DACC43C2B6560C0DADDA32ACC2E4A40E6B71964606460C01940478AE4284A4047C66784C06260C093181BCC3B254A409ACEED0F996160C06CF18FD876224A408D8C7F2FBE5F60C02F9FBF203F1C4A40697D9BEAAD5F60C008E286A40E1B4A40FD8F0E2B375F60C07F569510C4154A407105995DC45E60C04D5DAA7BB2114A40FC0245A6EF5D60C04BA45C57110E4A403F13A8F76B5D60C02D93D9D88A0A4A40C9D470AE885D60C03DB00CF3A9094A40A1AE0722D75D60C00889B8F5E1064A402E4EDD7F6F5E60C03945917A97044A403FE48182F35E60C0EF1296CA4F014A409467723B655F60C001D77EE969FB49405170AC8A305F60C0B381B4D52BF7494003D08425815F60C0F373348D6FF449405C8F7A70ED5F60C091878E88C1F349400C0EACFF6B6060C0BF70BA01F5F349407E901246406160C0BE6EFBA02AF549409C94407EE76160C0F6DEAA6F5FF74940C4E8F1BA7B6260C0477729247CF949406E10D5FA2B6360C0D7A1B4D9B6FB4940581A61CFE86360C0F5825E759EFE4940575766BF5F6460C0848F32EA29024A401D08E45EAA6460C046324045CA044A4096504D163D6560C012A1BCCC9D064A40FD50E047F86660C0A2789A09C9094A404985713EA36760C02086A1BCF10A4A40174FB88ADC6860C07ED85037F30D4A40CE1F36A6336A60C02F16F71E3D114A4029B77A17786A60C07AA549321A124A40BC354A7A646B60C0FD279DA65B144A402E58D341126C60C0DEE43FB53D164A402828F18AF96D60C0A06E14995A1A4A402C6BB19BCD6E60C03CF49A56181D4A4000D12AD2326F60C0486866910F1F4A40F7554B79547060C0DB7324A059234A405575E0DFCF7160C0CFA95A5819284A4042887972C17260C0342EA891A72A4A4063BCD34DC87360C020817159CD2E4A4096CF9BA2407560C0FCC8721D6D344A40FC3B4D0FB97760C0779CD4B6843B4A40E7D9BC93427D60C0EE05CC5A624A4A400FFCEEED107F60C0BCE09FCCC04E4A40533FE17FBA8060C0C81BD20F8A534A4071BF6558FC8260C0E714D5DA68594A40792EF7FDE78560C0EFB53BFB03604A400573DA03B28760C0EC2E5669DB644A40D40A90A03E8960C068CEA078806C4A407A2A33E7198A60C036F753CF1C704A403BCB3236D98B60C01EED41B347764A40D0412F77FA8C60C0DF7B5EA8EF7B4A40FB079B7EDC8D60C05FFD992EB57E4A40A095EA842F9060C09178FA3F99824A40C3C340FC959060C0FD72B91378834A4046DA7106E49260C0A6615511D28A4A40CA5D0E0D539360C095648B8B578C4A4075E82C08AA9360C060D495EE32904A40DDBBC3C60C9460C07C60CDD291944A401C34ADBC479460C00DE667D596964A40F74AB6B5DB9460C0ACE519C9CC994A40D5FF79FD2B9660C0634ABD610D9D4A40B96508215D9760C0DAB1E3136F9F4A4057D585CA709860C04B8D82F4D3A34A4074112E9DE79860C0A78311DBAFA84A40BFB1667EEE9860C01BDA45E4DDB24A40AD1BF054159960C028F367877CB54A404EC9CB4EE89960C0D21577F059B74A409D56FDE1B49C60C097630B0509BA4A406AEA8AAAED9C60C0BCF1C6F6F9BA4A40C5E6D5EA8D9E60C0D11FFA5D77BF4A403A10D588C29F60C0E138E0402FC24A40B7FD629371A060C01A870C2E00C34A40A61AD06BE4A060C0CF0BE5ECCEC54A409AE5F6218DA060C01B0EF90E65CC4A4037D26E9B10A060C0FBF6D866BBD04A40A99347159FA060C0C7641511B7D34A40137B1E50BDA160C0ED40672A7DD74A400D64FC06EDA160C0783D8172BFDA4A40115C6CF332A260C0B86BAE78CADD4A4065D04E6E94A360C05C9DBD53CEE14A402965208D08A460C057CF671934E34A401B82F36C7BA460C0E65D4BBA2EE54A4013A5028F44A460C0571B588D1AE84A403CC32C6C08A460C0B0622E1BB2EA4A40DACB1AC4B6A460C0EDBE6A7B58ED4A40AFFCA38A2DA660C03C40B3798EF44A4039EE02BAB8A660C0E65CC6EC86F74A40BD0C1FA070A560C061E62B4C2CFB4A40BD4EAD3C48A460C078EC205102FF4A40E869AD7774A360C0CE13334F130E4B404417216B53A360C0738D3A6E2C164B408F0A04077DA260C08160855F58204B40891273E0BF9D60C0C9C6881F04594B4048C3003DD59E60C018C42C3B51644B404D1E33A25AA460C0E02545D09A774B40589A495B05AC60C09C47420C1D8B4B40A3BEDEE8B2A760C03C2DEEFF049A4B40	28	218	4738	20	0103000020E61000000100000005000000589A495B05AC60C091878E88C1F34940589A495B05AC60C0397D40CE62D94B403F13A8F76B5D60C0397D40CE62D94B403F13A8F76B5D60C091878E88C1F34940589A495B05AC60C091878E88C1F34940	North Coast
5	Tsilhqot'in	RGB(112, 255, 112)	https://www.firstvoices.com/explore/FV/sections/Data/Athabascan/Tsilhqot'in%20(Xeni%20Gwet'in)/Tsilhqot'in%20(Xeni%20Gwet'in)	Chilcotin,Tzilkotin	2		0103000020E6100000010000000C01000045628CEB4DAF5EC06DAD59A976CD4940E4284760C7B15EC0DA54FDF932C9494039F90BA8D6B65EC07B9DD30D72C149408E54C8A627B95EC0689F7EFC56BD49401EF4A64A26BB5EC058E760C6ABB8494069A2922DB0BC5EC0FA5B30B321B34940E880A137D1BC5EC0EF3A21E3F2B04940E3FAE2CF6ABC5EC0E8A8DDB4A4AE4940545FD037B1B95EC06F59D3C50EA64940061CB710D3B85EC04D22850454A249401201FF2440B85EC0D4762377029E49403D7F024522B85EC0ED9BBD4902994940225EF107A3B85EC0183B829C3B934940D9D26F7DFFB95EC034F233FF2F8C49403D3F86A7B0BA5EC0767666B98C8B49400D503EE71CBE5EC0660A5575E8884940ECC5FE9808C25EC0DCD28994908649401BEA880995C65EC0F137B365A5844940C0AA6AA9E3CB5EC0532CF1FD46834940764608D860D15EC0E94EA2C39F8249408F08E5C7A3D45EC0C134C1509A824940A6FF7800BDD75EC0028B42EDCF824940137EA102ADDD5EC08774CEA66E8349403AF534FEA0E05EC04F5BE8CA988349407263A2A7A5E35EC0F6E3CA0D808349408BE8386EC9E65EC0B48797D2048349404B9EFDAB1AEA5EC04369626E078249408821A0A0A7ED5EC0D9CEAC2668804940AA5BDB6A7EF15EC019E95A2F077E49405CFB1F6967F55EC0451B6188FF7A4940D69BBF6B1AF75EC078D9DFC35C794940C5BD307D77F85EC0F80B00A7AF774940D5949CDD89F95EC0F7CC8314F67549404312A3CA5CFA5EC042C5C0E62D74494027F03B7FFBFA5EC05DD9B9F1547249400F70873371FB5EC020FEDF04697049400A548E1CC9FB5EC07F947AEC676E4940865BA2F757FD5EC0385ED3FFBA614940AFBC71BC55FE5EC06308F1B1D96549400E872C5515005FC0A93251798A6B49401294349218025FC0D1F465825A704940420AAAFE6B045FC054FE2084187449407E9D1D0F20075FC06972EDDB2E7749408870E42AA3095FC0E27F1DB37B7A4940F17C55BBE30B5FC0745B1585F27D4940E7067072EB0D5FC00CE2E1408C8149406450A504C40F5FC0F4FEB9CB4185494074B5F22D77115FC0456419020C8949403ECD19AE0E135FC0CF4EE8BAE38C4940A4CF20591B195FC0F52DF8043A9C4940449EC22BBB1A5FC0D5B41B61E99F4940DC31BB1D7A1C5FC0AD6FDEF87AA34940D8DD400A621E5FC012F6F585E7A649400AD29C53A6205FC036BE46E639AA49400B3E0A173F255FC0D1F5D411A6B049409B4745ED942C5FC043777CB954BB4940346A4752292E5FC0A080911D66BD4940DF62F265AF2F5FC029ACE6652CBF4940B77F02062D315FC0C16565DAA0C04940DECF0611A8325FC0189574C0BCC14940C365AE77EB345FC0C7FD047EDAC249408E1A316044375FC0D51336ADB9C2494086B164B3D1385FC0BB184B603DC249400AF0DE6AFF3A5FC07CD8040541C14940B70E43E8663E5FC0F7D5E3BC42BF4940ED9E8DE814425FC0CA58EAD7D4BD4940C586A96E92455FC08B20A877A2BC4940D158233753485FC00590224DE2BB4940CB1949E51C4A5FC0DA6667E895BB4940FC663674FB4B5FC0B28C3C1D88BB4940B8A3CD36A84C5FC0D74C781383BB4940DEBBE525114D5FC0A6394684D5BB49408045D9A0C64D5FC022ECE10B64BC494056E67C30114E5FC0095C31969EBC4940017C33E9324E5FC0F084983A27BD4940E1EDB8006D4E5FC0D5F5DF8E12BE4940F31D894AD44E5FC0920E732B48C14940E43316CF514F5FC081FAB71BCCC24940E6EB7E1524505FC032E32E1BBCC34940A749421006545FC0F149CD0B5ECE4940BCF062866C555FC06E842B73ABD149402E336DA37D565FC07759EDC5BCD349404FCBF6EA96575FC0B5AFB33372D54940BC67A1D6BF585FC0F7BDA3D8D1D64940787F25769C5A5FC0E1131DC866D84940BD410D51E35C5FC022675E032BD94940DDB34FB0955E5FC0A680F26470D949408E1C9F277D605FC036C0515A7ED9494007CC3934A1625FC0DB8BE7E65AD94940DEC0435209655FC0806370050CD949405A2DA82A526E5FC0264E62FE4CD74940C7FFA156C36D5FC036952FD7C2D9494086137789596D5FC086F6E24FE2DC4940EF2D8A31586D5FC0B0FC6D04A9E14940A8261C60BB6D5FC0D4B42C4578E64940182A618C7E6E5FC0A0C1E11013EC494032D829729D6F5FC03312EAF1A3F24940627276B5CC735FC02AAB16E3F3074A40A8A0460C98705FC00F63EAB663094A40F169BF1926675FC0FCFAAF7E220E4A4083E63457A1625FC0CE7AE18D18104A403A90E3C554605FC016341B4330114A409E94290E145E5FC084014CE081124A405A2CE520ED5B5FC0AE2760872A144A40B65024EAED595FC05149346247164A403D86F05524585FC05FE478A1F5184A40BAEB80DF88565FC01E149D9DA91C4A402B5D4F9FB2555FC0ED77CF84DE214A40ECAA4571FE555FC05C776A8CD2274A407A9A51A342575FC0334CE2A65F2E4A4062B0757655595FC0902D659D5F354A4092E9C6020D5C5FC0D5FF0B29AC3C4A40FEEF2C42DA5F5FC01B0E39CE68454A40AD38975DC1625FC0D0DE870B924B4A40295C9F7154665FC0670AF23ADA534A403AF89AAB09675FC015CAB3EB80564A40B14AEE3CD3685FC05A986512E75B4A408F28B4F5F26E5FC04B036C74986B4A40F5A469100F715FC036BAF3C010734A406E38EAF019725FC0455F4D9F4E774A404822D90A7A735FC0D00969D6DE794A403F3E4C4652755FC074541E9F347C4A40D792AFC2C8775FC0069CC7AA4B7E4A404B9ACA0DC07A5FC0656C8EBFED7F4A409FBF953D927E5FC0E5327D85A2804A400091331DB9835FC0C097CC44D3804A40FC5AFCBA48865FC0E48CEC796D814A40DC9CC99B97875FC0CD6C1A6C95814A40E8B5FC8462895FC0C0D3345752824A404E6396FE1D895FC00AC044C3EA834A40DDB58492FD835FC00859EF26A8854A400BBF01C6EC7D5FC0CA9E30C2D2864A4096659EA7CB755FC0D3A1E16E38874A4063E16E537A6E5FC0F60BDB2490874A40D5310A2917695FC0837EF568CE874A4089734B290B655FC0A02097E89D864A40B290F2E43E5F5FC0EE9F111F2F834A4094B9EEAF9B5A5FC04DB4EB725D7D4A40A030755A59585FC0F7579B8ECB784A40EA24762EC4515FC0804DD7A7DC714A40144B81757A4C5FC0FF2FE2C7256D4A40CCC7C11BD1415FC0EB6DFA8E25644A40B807B7083D3A5FC0CFD135E297624A40FE49C9B7FC375FC0A543ED093D654A40E7401E815E355FC06AFBF3E069674A404C8C501D44325FC058901A0303694A40F7025A5E8F2E5FC0068937E7EC694A4085EF9540222A5FC0BFEA11D40B6A4A40DB0D8A3D07285FC07EE3E7447E694A400422A7313C255FC0D794866C2B684A40B68C470CDD215FC07A40416B3E664A407D86D87C5D155FC03A58CA448A5E4A4001DD5DB4C3105FC0524FDEDBE45B4A40128E74DD1F0C5FC0AE15C9E47D594A4053BA20018D075FC02D0ED40A81574A40F187C2F825035FC005FD771B1A564A40508EC27121005FC0DBECBDFBC4554A404C7874D3FBFC5EC0DDDCF2AD21564A40CB29DBDEB7F95EC0328020070D574A40A289296658F65EC03418FADE63584A40599BA24DE0F25EC0226E090F035A4A40C149D52CB2EB5EC0FE42F1E18D5D4A401E359A4D02E85EC056E22E39335F4A406F62BE2146E45EC0683BCD4F94604A4082549BF180E05EC0626F24FC8D614A40C57DD4DEB6DD5EC03092AF2FEE614A40885254C678DA5EC06CB0E20D17624A4038334D63EAD65EC091EB748608624A40A08CB4732FD35EC0BED059A3C2614A4029E381B46BCF5EC091939A8E45614A40E27C43DEC2CB5EC0FC66F39491604A40A0F110A258C85EC082625225A75F4A4038BB10655DC55EC0D6A034FB1B604A404E65619DB9C15EC08A34677D01654A4034BADE7B3FC25EC0FE24FF15B06A4A407EC77955A4C25EC06669D2B528714A405B401D4935C15EC03FB0BCE935764A40029B9DAA28BD5EC0D1DC8F0AD7794A409F43B39BB6B85EC0E295336F847C4A40E6E8AE3A44B25EC09C8F05C09F7C4A40C38ED7332BAD5EC0AC57292A9A7C4A40E8BDC3B71DA95EC0C709CDE1BC7C4A40D2A2AE33D8A55EC033E17984817D4A40FE2D8018DEA35EC0E2DE5209A6804A4081DFC63396A05EC0233CC95784824A40E5812A549D9B5EC0CB757E0179824A408CD88223C0985EC0BCADFF6E64804A4032DB2D1AE8955EC0AA072142F17B4A4098C8EECA2A925EC0BE915ECD1B744A40526843806F8E5EC047EE2238176B4A40BBDC17B5778A5EC0D2935A1F8D664A400860BA18CB885EC0BB0E7C022D5F4A4041C167A4A7855EC031642259045B4A40C5071A6027845EC034AC772EE6584A406E30C252B7825EC04BFDB03C54574A407B921BB610935EC021E1B6FA96414A404517036DC1985EC0089938BA5E3D4A40267E1D06859B5EC027C7FE07663B4A401F972767349E5EC0C90AB41FBB394A40A450BEFEB1A05EC08003ADF668384A40A791577C0DA35EC0252E544652374A407615240440A55EC0265FB8C4FC364A4080FFCBC129A85EC0E84B671BA8364A40A20EFEB24FAA5EC0313198888D364A40B178EF769AAD5EC0E23B93A4EB364A4071F2E138A0B15EC0BA21EB6217384A404D1408049DB35EC073F769B35D384A4057ACFE867EB55EC0D1B85B4673384A4092D7B2892CB75EC0675D09923F384A40F19E2698EEB85EC03C5F4EA681374A40D8E322673AB85EC03224D4E6C3354A40DB2182DC6EB75EC087221C2189334A40334676B8B8B65EC0AA50E3EE9A304A403DBCA23541B65EC011F0F055802E4A40D3EEAC9A8AB55EC01A4E0143272C4A4069526B253DB45EC04CA1F5FF7E294A405C6D15F5DAB25EC0E7E6E43810274A404B08E4AB15B15EC00C571EC9CD244A4015931F8A48AF5EC02848F09F60224A40412F877FA8AD5EC0A5A2FDC02A204A40FCD52943CAAB5EC030313654D41D4A409941CDF02DAA5EC0A801D5106C1C4A40DB38C2892DA95EC0B8565474811B4A40B98F78D66AA85EC0C8E6A6BC181A4A407F0C79D798A65EC0BE89905B0F174A40618D8E47B3A35EC02951C964F4124A40442618567DA05EC003EB7988F90E4A40F129C102DC9E5EC05EEEAC60970C4A4076BF06D1F29C5EC0B92AFDE0790A4A402DCA7E73DD9B5EC08E623AC4C5084A40C4EBE06F9F995EC040FDEB44AA054A400DA09587FA975EC0DC0CFF5834034A4001B567F7F9955EC0B37B2A5E28004A40812BB969D1935EC0892DDAAB64FD49403382F811EA925EC022711FB08EFC49401D5E88C499925EC0A9A2EAD7C9FB49408D28DB890E925EC0E29252F9D4F94940748D1A9BA5915EC0654C5663A4F8494089E64A35DB915EC0A80ED46C6FF7494084BDE8587B925EC06ED0CB889AF64940B558233CE9925EC0E327984753F54940F72E397560935EC0CE22978A77F4494091B9AF7EF2935EC0F8AF9C390AF44940F2BE820289945EC09948C108D0F2494089EFA16A61955EC0D4298E6FCFF14940D8B8CD8AD2965EC0CB61840503F149400E6AC1FF65985EC0042C9E64F4F0494072D1EE3628995EC044AD49D2D6F049403214766BC2995EC092223B6E3AF0494069268F084A9A5EC0F7072A7B81EE4940E4593DB8E79A5EC02F3303EE10ED494036B953740D9D5EC09F788A4E9EEA4940CC7F7D9B709E5EC08D7253296FE84940D630458C589F5EC00A0FBAA830E649405B0880B5F6A05EC04782BC8A3EE249407FD6860F27A25EC0C7CC3809AFDF4940F477F1A9D4A25EC0185468855EDE4940A0EF871F6FA45EC0EF9AF57981DC4940D677196813A55EC02AEEC17CFADB4940F3C20BB719A65EC03CD123E7ABDA494085390BF910A75EC031A5523A44D9494005FBB6EBF8A75EC0E9F791C501D8494020AD7B00E6A85EC06A45043887D649404BB20A3E41AA5EC05F7FBB8FFAD4494051DECACB7AAB5EC05B3D4E08D4D34940FC120DA1B2AC5EC065D34F2F4DD249405A6B2E1E95AD5EC0AFB690BDDED0494045628CEB4DAF5EC06DAD59A976CD4940	100	115	702	78	0103000020E61000000100000005000000E8B5FC8462895FC0385ED3FFBA614940E8B5FC8462895FC0837EF568CE874A406E30C252B7825EC0837EF568CE874A406E30C252B7825EC0385ED3FFBA614940E8B5FC8462895FC0385ED3FFBA614940	
19	Tutchone	RGB(0, 160, 0)		Tutchone	2		0103000020E6100000010000005F000000E20D1027DFC960C0CE49CFDD67A64E40FAB9F604B7C560C0666492512B9C4E402D963E642BC360C080DCAEF96E954E40D86273DEFFC160C096257E5A22924E408B12F11DECBF60C0CC738E4BBE8B4E403947F6BB09BF60C0A2AEC617AE884E401C68C78F45BE60C076CD3842B9854E4000912B80A2BD60C00374B665E3824E4002F9997223BD60C09DDBBA1A30804E408B50CC4BCBBC60C02BD6C3F6A27D4E40B4CE5AF09CBC60C0242FA28B3F7B4E40C14862459BBC60C0226AC26609794E4067FB3431C9BC60C0B02B6F1004774E407F05179C29BD60C07C020F0B33754E401BD70771BFBD60C07B7D5FD299734E4055739A9E8DBE60C0E4C6AFDA3B724E40E2B6DE1797BF60C08CF71C901C714E4051F187434FC260C03CEDC419856E4E4046F33508D5C460C082F58E46DA6B4E406D9F3CB3E0CF60C0487A91A9465F4E40409A80F4A9D260C03955DBB53E5C4E40E5D3DA5313D560C095D47395095A4E40E390E8A229DD60C06B559571F3524E40767D3024F5E260C01C7203EF8A4D4E40B5F02DCE7EE760C0AB2900C6F7484E406081141BF9EB60C0AE7C0C9208444E40268E176ED3EE60C03D31807695404E40CFBC34C230F060C03E3E31FDD13E4E40CBF66AA470F360C0538E3E3F473A4E4054A64CDF8DF660C080E60180F8344E4033D6290D58F860C032CDFD7D1A314E40BB165CF59FF960C05881A2E6702D4E40E1971D5D61FA60C05AD6A3BF102A4E40F681249CDDFA60C0F7F0701321264E4016B59BCDDAFA60C0461A1B9404224E403CC3B02F83FA60C05B6F5763321E4E40DCB8E2010CFA60C0E9548F1C071B4E40C6C9B9BEA1F960C0227ADC2FCE184E406753F6B7F9F760C0F971E3B64F124E40A36939CB63F460C04F82A383FA044E40EC66F32266F360C0983DF296E4004E4080AD7F9C7AF260C0C57F79DFA8FC4D40CE29420BA9F160C01D0373EE43F84D404B419B42F9F060C053AF7059B2F34D40FE0FF21373F060C0181FDAB8F0EE4D40F3C5495311F060C013E885B50CEA4D405B3F4DFF74F160C04B7B698975E94D40444437155BF360C0B05CAEE98FE74D40A8329F38D4F560C088A009FEDCE44D40DFFABAC519F760C0F002B301A8E34D40A452B4A864F860C09534CBA4BDE24D40E91FE25FE0F860C0F64ABC18A3E24D40B83ECE8069F960C0E9829F09E1E24D40F2889D7A06FA60C037AA755C63E34D40F4A833EF9AFD60C0F8EBC45070E74D406A9855C24BFF60C086F6E82AF0E84D409231616D0D0161C0C9811761A5E94D403B335F55A70261C00414B8D80BE94D409468D045E60661C00C9D01FE59E34D409ED8DE27330D61C09E540C4306DE4D40088ED9A8C41361C0BA27362DD0DB4D40A3DA9801841A61C06E51B82B4EDC4D40EB7FDD605B2161C09659F01219DF4D404C72E3A7352861C0C8AF2B54CCE34D40317F5091FE2E61C027827AB306EA4D40E631BC8CA33561C04F5702A46BF14D403DEB1205163C61C0E64B0E34A5F94D402CC5E4DC4F4261C0D332A7DD69024E40F9E2428EDF4761C0C8ACFBF64C0A4E4021F888F9B14C61C000EFAB9676114E40BCE607C56D5461C097D2A0FD971D4E40F4DCE31F085761C0B3EC404F4A214E40A05A7579466061C0E1DC1DD5032E4E40C79C38D8AE6261C05A2B3F2F37314E40962A33E2176561C0A41ECFEA4D344E404D11113D7D6761C03ACE92C939374E40250A89C9DA6961C0AF6E32F6EB394E400F5107702C6C61C06AEE019F553C4E406D4DE61B6E6E61C0E37C69F7673E4E409137C5B89B7061C0FB317D3714404E40E2A56631B17261C0EDB9169B4B414E40C0FFCC6FAA7461C02C043060FF414E406A91505E837661C077CE77C420424E40A0F68BD3DB7A61C01BC54EAB5B974E4071DAB2DCE27061C0CC4105AB24BC4E40D41B0BE0725E61C0CCE3BFC620D44E40ED562D13B14F61C019B6753094D64E4091910600CA2361C091DC5C6450DD4E404F53AEBBFAF660C0A6AD8D1D34DF4E40F1BC38174DD960C0258FED6C8DCC4E405ACB9B1C7CD860C0254237A6D2C94E40A932C35644D760C0D173D4D44EC64E40EED2B9F6AED460C0D70364E7D0BF4E4023C2BAF03BD260C0226F62C5F8B94E40E20D1027DFC960C0CE49CFDD67A64E40	0	0	0	0	0103000020E61000000100000005000000A0F68BD3DB7A61C0BA27362DD0DB4D40A0F68BD3DB7A61C0A6AD8D1D34DF4E40C14862459BBC60C0A6AD8D1D34DF4E40C14862459BBC60C0BA27362DD0DB4D40A0F68BD3DB7A61C0BA27362DD0DB4D40	Nachako/Stikine
12	Nłeʔkepmxcín	RGB(192, 48, 0)	https://www.firstvoices.com/explore/FV/sections/Data/scw%CC%93exmxc%C3%8Cn/n%C5%82e%CA%94kepmxcin/n%C5%82e%CA%94kepmxcin	Nlaka'pamux,Thompson,Nlha7kápmx	5	"About ten percent of our population speak and think in the language fluently but many more are actively learning it".[[205]]	0103000020E610000001000000FA0000001E03C34CB35B5EC072260CFD5FCE4840A2AADDD0DA5D5EC0B2D5585B8ED04840E88E089515615EC0B898669B97D24840125F503D8C645EC0510FBF4ED2D34840903357BF2B685EC0CC0C8CA85CD44840CB1F7108E16B5EC0C2EAD6D654D4484063EB068E2E705EC07B554572B7D348405EAD40A371715EC011FEBFAC4ED74840C92E6DF517735EC0D335386DECDA4840A4142E9FC0745EC0BF52ACDAEDDD484056C81E4FAF765EC0DA7AC6F9BCE0484049674EEBDC785EC0CB2EC49260E348403B3DB8B6427B5EC024ACCDE2DFE548402F464033DA7D5EC0B3A9487742E848407745FE0E9D805EC07933BA1690EA48402B333A1885835EC0B568C2B1D0EC4840E54A2560AC895EC06641B4364BF14840FF2054F8DD8C5EC0AF022850DCF3484051251188248F5EC06C4672BE6CF648402655FB3694905EC0C4CE8237F0F84840F983C09451915EC0870984C164FB4840F753857D81915EC004574670C8FD484084A254FF48915EC0B19A7F5F190049404F369C4ACD905EC0B77CFBB255024940C7CED275A18F5EC0FEE2E84789064940FDE08F1E3C8F5EC09017B6047D084940CDADB11E298F5EC028BD7019550A49404710C0C202905EC0A85A4EBED4114940EC49116054905EC0DBE2D69DBB1A49409160DABCDE8F5EC08FC313D64E234940C74BD901AB8E5EC059BE24517C2B49400F61769CC28C5EC068879C0132334940D55B4E392F8A5EC0C8FCD2DC5D3A4940CF35B53493865EC0365E5C016C4049403ED56026B5855EC01EEEE4FC71414940F5F11E3A22855EC0996C16C828424940478C3C2A08845EC0A45DEABFC5434940B05FDFBA45835EC0C762FE09E6444940EE1BD1A4E4825EC0F345FA6A66454940B3A5972CB8805EC0450294C41A4649407C34B0A84C7F5EC035610CA1CD464940D01FCF293B7E5EC045B5609F56474940B15DE2DA987D5EC03FC392E899474940615FC78CB37C5EC0ACBC80C8CA4749405C2524063C7B5EC0F2331C523248494012D63F05347A5EC06A37AA6662484940DC3BDE9386795EC0802749626C484940B4F8F7436F785EC02F1460373F4849401A068010CD775EC0F7BCBEAE02484940B27C1E225C775EC07F9633438947494098CF644909775EC08FE050266D474940E520C85357765EC0B7E6E335CF4749401AD2F2C29D755EC02A1786136648494057764EDB6E755EC0C7DE2646FB48494042399F2B62755EC0620E337BB44949407C1C2C8738755EC0EB768B59704A4940321BB254FC745EC0E86FA5B3D44A49404FF2F66A8F745EC09D00EE4F454B49402A084D0965745EC09BDE1346824B49403EA3CA913C745EC05B64ACE93A4C4940B13428EF24745EC0D9294BA21B4D4940B94790A9CB735EC08E1B99EFE44D4940113D3DEC5A735EC088E00B836B4E4940425A7D50B0725EC09867DA8F984E4940D8D6D64721725EC00288AD67D34E494042852374EF715EC0B58F4E82334F49408F209872DA715EC076D18FAC4D504940D12545C6B2715EC099ECE19A72514940EA273B88A0715EC089D9C3D0C15249405F8486E38F715EC054664C6B95534940C4D0DFD852715EC04EE3EBAE2E544940472776CEA7705EC085FAB79FAA554940438F1A87816B5EC07EBC70678A544940C838306EE1665EC0B365D949BB5349403968AAB146625EC0EE818C021C534940AC61D974525F5EC0889884EAF452494078F05648AF5E5EC008A195E85B534940C43C4B3CEC5D5EC0FDE17B5EA35349401E1458C35E5D5EC038B7497AE1534940A4976F0DE05C5EC00CF22EE8515449407B2ED3D8235C5EC01125F83E0D554940057166E9445B5EC0DBBC17FACF5549400F6CE3EF495A5EC05989DE6BC35649407019746C46595EC03BFB4DAAB7574940A54612ADB4585EC07CD5C54370584940A51472BC25585EC0B4A3FE852E59494018757CEAFA575EC0E4C5EBD42A5A4940CD6BA3C7D4575EC084A6DA05245B4940EEC1CE209E575EC0E3D03A70325D4940222900D283575EC091177E5A265E49409A1EF0EA4F575EC0CF3907358F5F49404D30B7B11F575EC0D5EC50219E6049407AEDFC82E6565EC007C12B7AE1614940FEB890CB9C565EC0E740D6E83A6249400743426DFF555EC0726E0D10D762494090E0D2568E555EC0CC0659F118634940EEF24AFB04555EC0CFE69CD74E6349409A2D047C84545EC06752996D63634940FD526B2A51545EC030A960BE5663494087A774CF25545EC0BBC75BAB28634940C520B9BFF6535EC029289144D3624940847CE04CAB535EC02957F92443624940579D6FF45E535EC0EDB8056AE561494010712CB4F9525EC09415DD588161494052C8EE91CA525EC044BEB58731614940FCF8794E7C525EC0F3DD123CA060494076609A7A43525EC08B9D45AC60604940B1BA0446F4515EC078503788176049404C36A773CC515EC0D04DC7B7E75F49401638D17F98515EC0F1C722A0645F494037121BD13C515EC0E996CAEBB75E4940B194B38CD5505EC0D3CD8A48E45D4940BA98A5DCFB4F5EC0E36BD668995B49401A6225C3D54F5EC036C5B06FF65A4940DDA7FEB9894F5EC01C84D43C715949402F90034F274F5EC0A2D287C32158494030136A75B94E5EC030F13113EB5649403A01EE4C5B4E5EC0574A83CEBC55494064DD009C794C5EC0E31E9FD5885449409BF225F3E74A5EC0F57AD90FBC524940DD528C4450305EC035B38E78AB524940B07E4BB038265EC031C9BC4EE151494015411E4303255EC0794D3D55294D4940228395B943235EC0A8EBA5F6E04549401F08B233E6215EC03D46C41351414940BD4AD36CC2205EC07D111461E73E4940B2B67630DE1F5EC0A2CED37E913C4940AFA17728D51E5EC06E4915FE983B49403D0519314E205EC0C2EF7C104236494065E67A55F5205EC095DD6EB373334940300F36271B225EC043B05CAF972D4940D1EBB3BC9A225EC010C7E1A18C2A4940C31D2D7E75235EC07FEA20EB42244940F2F5068CD1235EC04E8E23D7062149408906757B01245EC080A1ED10EF1E4940DB10316DB3235EC0F0B600A40E1D4940F7AE7D2854235EC0EB7D0176791A494053B58E339C225EC0346216540C184940E2E37407C6215EC09AB9F5EA0D1549403657012BC2205EC0C806B9022E124940975BDA68C91F5EC00DB0238B530F49407584FE35C61F5EC0E2590A0D590E4940F390BA38C11F5EC0A00204EF9B0B494034F733A4C91F5EC0841E85B2A8084940FAA9D257D61F5EC0BEBF11E332044940F7A993B1FB1F5EC0DE55F0E6EC0349403B6DD577F8205EC04218941013024940DC0D955F86225EC0A5BE5D7128FF4840EA4E38AF8E245EC0FA6E9F2C42FB484055911BEE47255EC0B5E98DA587F94840E443A7A32F255EC0F54B9A16E5F348406E0EDFDBD7245EC0D7D21BC156E94840692031E485245EC0FE950F4F6BE24840B9504B2E12245EC0211298EAA6DA48405824634D51245EC0B9C75D4EF5D94840C641902378245EC0BBD871C550D9484094AA549C90245EC0ADA581EC08D84840B648EEBAC4245EC0272D50C043D54840B4121B8BE7245EC027F21A4EC6D34840831DAB91FA245EC0BCDBEF5F46D1484093B5B4E2EA245EC08918214A79CF48403EF61ACEE2245EC0BD82328B0FCD484085EA46B4E0245EC0A67F7DBB40CC484014856275A2245EC03BEC9DE386CB4840AD650A6A36245EC09EF7527B9ECA48405F86AD4AFE235EC0F64B0B37C5C94840369BF8D5C8235EC0EE82E652C8C74840753F0B9CA1235EC0FAC3C625DFC548401101AA3367235EC06AE86DC8AAC448403715F0EFD4225EC086ED48D9ECC148407657A0A72E225EC0E5DEC8C2A9BD4840A12E71EC29215EC0D3C7BB7E43B64840BD9EBF67B1205EC05E09A47274B2484050C5F6EE8C1F5EC003F7D4DA3BAC4840D9DE6545871C5EC0E3FC6FE6609E48404F7CBDCB191B5EC0DA353182F8964840E4E4351F551A5EC06D695D6BEE914840A43D353E071A5EC0A78233DA648F484065908BFB9E195EC01FF97B0D4E8A48407B435ED388195EC02980DBF8C2874840295A747689195EC0F579F1893985484012A3C2FFA2195EC0427CFFD3B2824840EC27D889D7195EC03CBE83E92F804840DA6DB3A9371A5EC0D93C57C87F7D4840D1E20F5FB81A5EC09B6FA01ED47A48404928D3F55A1B5EC0DA1123AE30784840CA37F588211C5EC02AB8E567967548405F31C0320E1D5EC0872C2B41067348408974D70C231E5EC066B523338170484028CD3C30621F5EC09E16AE3A086E4840BDCC54B5CD205EC0802524589C6B48408B4CECB367225EC05F912E8F3E6948407B0C424332245EC09BF99BE6EF664840BC57177A2F265EC0E8633868B16448402B19CB6E61285EC0EAB2A32084624840BA668237CA2A5EC02AD3271F6960484042EE60EA6B2D5EC0C0FA9175615E4840124ED39D48305EC0217A15386E5C4840DFF5EB6862335EC0B738427D905A4840D3A8D263BB365EC0F6071D5EC9584840639E45A8553A5EC0D3E46CF6195748404E7C2A52333E5EC03A795665835548404B642D8056425EC03E1F68CE0654484059C66B54C1465EC0B94B465BA5524840324829F5754B5EC056CA3E3E60514840C4E08C8D76505EC0280430B638504840FE2D644EC5555EC032E97614304F484082EAE96E645B5EC0BC3418C6474E48405A3D333776615EC08F26932D7D4D48408255E12482625EC038E9483D744F48405659E41F66635EC0E66C7ED3E45048401F993D100C655EC0F802561C1D53484039CAC0904C655EC0AFEF46BAA7534840B26AE5916C655EC08F6C1B4A5A5448408B082A4458655EC07845A863D7564840E260201C9C645EC004854048275F48406019AE7CE7635EC0087D2816BE6848407B62AD4E7F615EC04F5128B8F36B48400C8FF998215F5EC06BD72DBB726E48406B0913219E5C5EC039E7AC14977248404F6433574D5A5EC0356C60BCE27748402954A49D38585EC077E291372A7E4840399E416169565EC0A77DF60D40854840F3F3750DE9545EC0FBCF49C8F48C4840E434F408C1535EC04906C97F179548406ECDBCC4FA525EC0BA905F9C769D4840AC0CCBD99F525EC0C645C976E0A548401415C523BA525EC07243E3B323AE4840D98DB5C853535EC0FBA8FB590FB6484045E3C52B77545EC0F2F257BF72BD4840BD4622D32E565EC0FB3AB3711DC44840649CD5C264585EC0D7EB158B97C948406FA4DA68F5595EC0CAC555490FCC48408CAECBAEF7595EC0CC8CDE6140CC48405AC388E6015A5EC0DEBDBA5F91CC48408127F80A225A5EC0E8DC28D3E5CC4840080DD1B0295A5EC05AD37D5911CD4840959C3ADC295A5EC0D5532A7E4ACD48406CE76E833B5A5EC079AE1ED589CD4840105583594F5A5EC02C231460A8CD48402CCB4D986C5A5EC09B541EE4C2CD48403449D47F875A5EC019E07A57C4CD4840621BEBC89F5A5EC05A7863DDBDCD48409F2C173CBA5A5EC0196A0BE0A7CD4840702F200ECC5A5EC044C32D5D99CD4840661046AEE45A5EC05859FDBF9FCD484055B568AE085B5EC050972D72B0CD4840E7E8B259275B5EC0ABF6B7FEB6CD484087404BA2415B5EC08CC692FEDECD48401E03C34CB35B5EC072260CFD5FCE4840	276	955	6418	1064	0103000020E61000000100000005000000F753857D81915EC08F26932D7D4D4840F753857D81915EC06752996D636349407B435ED388195EC06752996D636349407B435ED388195EC08F26932D7D4D4840F753857D81915EC08F26932D7D4D4840	South Coast,Thompson/Okanagan
14	Nəxʷsƛ̕ay̓əmúcən	RGB(255, 192, 128)		Klallam,Clallam,S'Klallam	4		0103000020E6100000010000004100000095219E83F40D5FC051221BD01C214840FFD7A393260C5FC0097E8FFB0C20484058AEC9513C065FC0768E34E32E1C4840E92B649E5A045FC039DC1F27CD184840C26F2A310EFD5EC009FBAAC9BE154840A123BF2346F85EC0FACE5D0D1A154840A5D23501E4EC5EC0F7FB57BBE81548406EDD1E1036E35EC0E07B1D65F2134840717D8BA208DC5EC0345F16CBA4124840F8A52E3174D25EC08F957ACB141048409CF6D3BE47CD5EC0CE1F2C5DA1114840689E546D76C95EC0E3BED00915174840B7FDCFA469C85EC0955FE6EE291748406271842255BB5EC0B607A813DB0C4840C9C8D8F819B95EC066AC7883B90B4840603281A949B95EC0D848816A0408484096A96C327DB95EC0D410ED6318054840D9429B1AE3B95EC0F4F44068780248403AB530F382BA5EC0D9E44B4C31004840ED962C4F64BB5EC09DBAABE64FFE4740D6BDC9CE61BC5EC013622648C5FC47405CB160CB51BD5EC0C36267CAA6FB4740453BBB6941BE5EC00227D640E0FA4740485F81C43DBF5EC02E9C97705DFA4740D11EBBEE53C05EC0DB000B110AFA4740910B3F11B3C65EC0C28AE15AFEF84740715B25020DC95EC0591B7AC963F84740FA6CF008CECB5EC0DDDFF8247BF747404E6228A402CF5EC0DC2875472EF64740E734E033B7D25EC0A256D7CA66F44740E0419F07F8D65EC0F5A6FF5D0EF24740D376156ED1DB5EC047A550280FEF4740AF4FFABA4FE15EC09259160754EB47400D4BDD4B7DE55EC08527F93E4CE84740A87A626451E65EC03B46DF04DDE7474056F224362EE75EC08BA8DE19A3E74740F4BD3BD684E85EC0F3FB55ED97E74740C1C9B23793EC5EC033BD6B713BE847406E53BA3FC0EF5EC0D0BDC58AFCEC4740D50ABCE633F45EC05B7FECDE50F3474046C56F7286F85EC0F35349A5C2F84740DC313BEEB3FC5EC0890F261963FD4740A5E7AA84B8005FC091B899BD43014840C33C626390045FC0133E73DB750448402E5B91AE37085FC029AC6E480A07484002A8B37FAA0B5FC0194D446311094840BD556DE9E40E5FC06425BC279B0A4840560E74FCE2115FC08EDEEA47B70B484056C2AFCBA0145FC0D5014A42750C4840D489126F1A175FC084667972E40C48405EA236054C195FC0A66B081D140D48409014FCB3311B5FC0CB4C6077130D4840219C60A8C71C5FC03690E7ACF10C48400768461C9B1F5FC0A16E9459F90C4840F4EC2AB0FA1D5FC0F0D5F06FB0104840F056D9E0441C5FC0ED4CA478C7134840B8F08A13831A5FC09F2B1EF54F16484040DEE7AABE185FC0C628295B5B1848402FD4250501175FC0C4E30117FB19484045D3BA7A53155FC05913418D401B4840ED729F5DBF135FC0A0878F1C3D1C48407EA83168F80F5FC0685011D72A1E4840DF09B644300F5FC01F791C14AB1E48401CC4F1B59C0E5FC022B37D4F451F484095219E83F40D5FC051221BD01C214840	0	0	0	0	0103000020E610000001000000050000000768461C9B1F5FC0F3FB55ED97E747400768461C9B1F5FC051221BD01C214840C9C8D8F819B95EC051221BD01C214840C9C8D8F819B95EC0F3FB55ED97E747400768461C9B1F5FC0F3FB55ED97E74740	South Coast
25	Nuučaan̓uɫ	RGB(255, 96, 176)		Nuu-chah-nulth,Nootkans,West Coast,Aht	\N		0103000020E61000000100000055000000ED1F46BE353D5FC02C5DDFD2F25848409ED4AC981C405FC0280366BC93594840E51E75BC38465FC0E89AF86E2B5C48409D9787F2A74D5FC09A637C057364484073DB093CAC575FC08340A96CBD6D4840C4E75CFFFE615FC078F5E2FEC4744840BEAF5294F26A5FC0E3FC8D49E57E4840E33CA48949765FC0410CB5F734894840EBEE4553AE815FC0B999829F939448403CA08B03F6845FC0251367A680974840B14DC90D388F5FC0F054CBC1C3A44840FBAA1CC01FA35FC0E2D595B20FB14840AC5BF383A5A55FC015798AC737B54840AAA5DEE319A75FC0ABBCE41472BE48400DD648A249A95FC0FD38DE8FC9C548405F4891842AAB5FC008A2C0ACECC948405EF9D31614B25FC06E05E54430CD48401113A8C03DB55FC099D9191700CF48404A14A7B502BB5FC035C7344C02D94840E7460103C4BD5FC05BA928A197DC4840FAA95D9336BF5FC0A6D22DB643DF48408B24B58A17BF5FC09F8289FBA1E248407D73D09B04C05FC09AF9827260E548407E697D1874C15FC05516ADAA46E748404A7F9E6BA0C35FC07D436E16F9E94840F80B5F53F3C95FC0ED00804D83ED484064AD206A96D05FC013509CE2AEF548407F8F26321BDB5FC08D3E2305B5FF4840462022F808E45FC087AF248C030B49405C2F2CC11FE75FC0F6444C0E420D494072A142BC42E95FC0F4415A95C30E4940DD245334D0EB5FC0E9A4CA54010E4940C4FA64E0FFF25FC01166C825230A4940EDD5BAED02F85FC05517F4772E0C4940B9457C4A4EF95FC0B9096863570D4940D87DF0850FF45FC0AEDB0B9B3A1349407BCB9858FFEE5FC00A7393B591184940A8767BB370EA5FC0BB8A9AE2E31C4940F04F29CD39E65FC01CF418AA2F2049406C693BAA30E25FC045B2565873224940F1BD52302BDE5FC007B18B05AD2349400E22B839FFD95FC0768BEC98DA234940DB0991A982D55FC08A9511C7F92249401C4E9E808BD05FC099B8B40B08214940B4CA7BF2EFCA5FC05C01D39E021E49407A68B9F059C45FC007214CD8D11C49409EEAA294D2BD5FC065D73E180A1D494069482960BBB75FC01929114FB91B4940ED990B55E1B15FC04EC6FD9401194940ADBEEA4D11AC5FC07150A5A604154940B416AF1F18A65FC08A2BB0EBE30F49402B100CB5C29F5FC000337076C00949403BC182AF37915FC0582446D0F3FA48402B4DBECA9C885FC0D99547D08AF24840876D064ADB7E5FC09D5E34369FE948409F3B744BC1735FC058AA17804FE04840A5799DA2705F5FC05CCD4C7DF8D04840FC2702C9F65B5FC0AA69808F2ECE484061DB28DA93555FC0C1A13902D4C848406ABDF7B4F04F5FC0980469ECC7C34840881716E1E4495FC0C618546F0ABE48401F51144B7C435FC0290EB68593B74840085C71EDC23C5FC034700E465BB04840E5826BCEC4355FC005D26AEA59A8484020D7B6C3672D5FC0148F31C3079E48409C0A4B942A275FC06B8246BADD9548407BE0F5047C225FC0F5B30A37D98E48406A053B10EC1F5FC0C2C0A265908B48406FAA8824CD1D5FC0D0D8C5AA5188484044C89C831D1A5FC072327B5610844840355E5659F81A5FC0C0EFAD8E9382484062B6215DCC1B5FC0B008E33B08824840D8AEC6F4A31C5FC07E96B8DC2F81484034879FFE231E5FC0560EF0E9067F4840E1B85909E21F5FC00C5F4B5CF77C4840345CACB290225FC0BE29C907417A484019991783C3245FC07905308353784840C547D07C60275FC0CFE362BC4B7648404A83333B632A5FC0314279B06573484020C800E6AB2D5FC0388F1F7E346F4840D9230A83EA315FC02F22EFA5086B4840A41BE77413345FC02CFBB49A446748402FFE5FB91A375FC0E625E4D876624840FCD30410B13A5FC0038DD817385D4840ED1F46BE353D5FC02C5DDFD2F2584840	120	1948	8147	1511	0103000020E61000000100000005000000B9457C4A4EF95FC02C5DDFD2F2584840B9457C4A4EF95FC0768BEC98DA23494044C89C831D1A5FC0768BEC98DA23494044C89C831D1A5FC02C5DDFD2F2584840B9457C4A4EF95FC02C5DDFD2F2584840	
13	St̓át̓imcets	RGB(224, 56, 0)		St̓át̓imc,Lillooet,Statimc,Stl'atl'imx,Stl'atl'imc,Sƛ’aƛ’imxǝc,Stlatliumh,Slatlemuk	5		0103000020E610000001000000BC0000002B2BD047738A5EC06B7A2F2C9496494093B885F88C895EC0C4F260E8C69549403C173078AA885EC08988729BBB9449403F84E7CF66875EC00C84404233934940D7A0AE3CD8855EC016EA15E2E7904940BD959CE998845EC0A052F4BDAD8E4940DD15B1F87B835EC0912EE591478D49400CFBA1EA89825EC06BE7386CB68B49401118AEA28A815EC0B77A3EC84F8A4940400A4B9BF7805EC01AFACC76E0884940E79CDF136D805EC080C8EC3286874940D65E515DE07F5EC001D4362AFC864940EB5BCA350F7F5EC08002FEF3318649407C60DD0C0F7E5EC06603F50EBE854940108A1A9CD47C5EC01AE7D0A066854940603BC3D57B7B5EC0623A3539128549409A58BAD9587A5EC08FEB61EDA684494044E37AAC49795EC0229A35D6DD834940563D731036785EC0975899E5738249400180183A8C795EC0FF4CDADB337F4940D5873BCBB1795EC0057C1F04EE7B49403820C5C7F4785EC0E26FB21A6A7A4940DB5C7C7123775EC08BE799CEE078494003E00C38AB745EC0CF3B29C0BC77494055BCA0031E715EC08A4EBB58D8764940D1263EBB3A6B5EC0AB4717D24D7349403229D2F209685EC065C7BA34E26B4940EC4E1583A5685EC013F13A498864494069484137D36B5EC0C15BDC7B105F4940FEAB0FD0686F5EC09FEF3A0796584940BEAE0FD0686F5EC053EC3A0796584940FEAB0FD0686F5EC09FEF3A0796584940F59797421D705EC0DCE07E2A3C574940472776CEA7705EC085FAB79FAA554940C4D0DFD852715EC04EE3EBAE2E5449405F8486E38F715EC054664C6B95534940EA273B88A0715EC089D9C3D0C1524940D12545C6B2715EC099ECE19A725149408F209872DA715EC076D18FAC4D50494042852374EF715EC0B58F4E82334F4940D8D6D64721725EC00288AD67D34E4940425A7D50B0725EC09867DA8F984E4940113D3DEC5A735EC088E00B836B4E4940B94790A9CB735EC08E1B99EFE44D4940B13428EF24745EC0D9294BA21B4D49403EA3CA913C745EC05B64ACE93A4C49402A084D0965745EC09BDE1346824B49404FF2F66A8F745EC09D00EE4F454B4940321BB254FC745EC0E86FA5B3D44A49407C1C2C8738755EC0EB768B59704A494042399F2B62755EC0620E337BB449494057764EDB6E755EC0C7DE2646FB4849401AD2F2C29D755EC02A17861366484940E520C85357765EC0B7E6E335CF47494098CF644909775EC08FE050266D474940B27C1E225C775EC07F963343894749401A068010CD775EC0F7BCBEAE02484940B4F8F7436F785EC02F1460373F484940DC3BDE9386795EC0802749626C48494012D63F05347A5EC06A37AA66624849405C2524063C7B5EC0F2331C5232484940615FC78CB37C5EC0ACBC80C8CA474940B15DE2DA987D5EC03FC392E899474940D01FCF293B7E5EC045B5609F564749407C34B0A84C7F5EC035610CA1CD464940B3A5972CB8805EC0450294C41A464940EE1BD1A4E4825EC0F345FA6A66454940B05FDFBA45835EC0C762FE09E6444940478C3C2A08845EC0A45DEABFC5434940F5F11E3A22855EC0996C16C8284249403ED56026B5855EC01EEEE4FC71414940CF35B53493865EC0365E5C016C404940D55B4E392F8A5EC0C8FCD2DC5D3A49400F61769CC28C5EC068879C0132334940C74BD901AB8E5EC059BE24517C2B49409160DABCDE8F5EC08FC313D64E234940EC49116054905EC0DBE2D69DBB1A49404710C0C202905EC0A85A4EBED4114940CDADB11E298F5EC028BD7019550A4940FDE08F1E3C8F5EC09017B6047D084940C7CED275A18F5EC0FEE2E847890649404F369C4ACD905EC0B77CFBB25502494084A254FF48915EC0B19A7F5F19004940F753857D81915EC004574670C8FD4840F983C09451915EC0870984C164FB48402655FB3694905EC0C4CE8237F0F8484051251188248F5EC06C4672BE6CF64840FF2054F8DD8C5EC0AF022850DCF34840E54A2560AC895EC06641B4364BF148402B333A1885835EC0B568C2B1D0EC48407745FE0E9D805EC07933BA1690EA48402F464033DA7D5EC0B3A9487742E848403B3DB8B6427B5EC097ABCDE2DFE5484049674EEBDC785EC0CB2EC49260E3484056C81E4FAF765EC0DA7AC6F9BCE04840A4142E9FC0745EC0BF52ACDAEDDD4840C92E6DF517735EC04635386DECDA48405EAD40A371715EC011FEBFAC4ED7484063EB068E2E705EC07B554572B7D34840EE680D8C40735EC057E2D1EC06D34840C4F32882C4765EC0807E3C71FCD148403A83B6DFE3795EC047799C2C94D04840FE874E8632815EC092D28876B7CC484028B02E53018B5EC00AF3F24C6FC84840D46528055F8F5EC046C03B19D8C6484063F9643F88915EC0BD447EBB44C64840CB1C37EAA4935EC022906FD8E7C54840BE09826DAE955EC0A53AA033CEC5484096FD55339E975EC0643EDA9404C648406787B7A66D995EC00869E2C797C6484094132032169B5EC077D7319C94C748402DF9C03D919C5EC0769FB1E407C948403E566A2DD89D5EC071074C77FECA48409A2B393CFDA05EC0A4FF263F05D14840C9BEA1B483A45EC0C91DC17DE0D64840AAF9484F13A85EC09B4EB26DFEDB484009C0DA1AA8AB5EC0D6BB66007FE048409590E5673EAF5EC0F65D128382E44840B7424041CCB25EC0CFA8D6E822E848402F8A3B8862BD5EC04D5A96733AF24840B96FB145CEC05EC020B401F5B6F5484007A8F53528C45EC09944A41D7BF94840B66076706DC75EC0836676EDA7FD4840A4F88D1C9BCA5EC0D00EF26C5E02494006E51C6FAECD5EC0BE78FBABBF0749401FE4FE6481D05EC07DAEEAA14A0D4940599E3B0283D15EC074DCC631170F49407FE53D2895D35EC0DD2B4BDD7D12494020966229BAD55EC09C63DF0FB81549403734AB578EDC5EC0B4AA43936D1F49404045C66EEADE5EC0011FA52CF6224940596E3928F8DF5EC00CCCA8F052244940AFB6C5BFF9E05EC04B2F9F154E25494074C1E6AB64E25EC04A03AD2C3F264940C759BF20D9E35EC02774C0D76C264940003AA8A5CDE45EC0165F658B58264940ECB9B2D0C7E55EC0259E6E221E264940DD22C214FCE85EC050366D2601254940A96519117DEB5EC0C15D2D8A5E244940232A17A8E4EC5EC077CFC21239244940EE29962A6BEE5EC01133B1A6402449409D9BC48D84F05EC09D2D0069ED264940EE15CBB456F25EC069228E9BD52A4940992B81956AF35EC0DCA142342F2E4940E4FCD34BEEF35EC00F0F8345C82F4940D952D6EE57F55EC05ED2D07394354940D412612FA0F65EC0C8899F1C093C4940F2EDA8EC6EFB5EC0396361DA9A584940A701E927CDFC5EC059E4DB6A795F4940865BA2F757FD5EC0385ED3FFBA6149400A548E1CC9FB5EC00C957AEC676E49400F70873371FB5EC020FEDF046970494027F03B7FFBFA5EC05DD9B9F1547249404312A3CA5CFA5EC042C5C0E62D744940D5949CDD89F95EC0F7CC8314F6754940C5BD307D77F85EC0F80B00A7AF774940D69BBF6B1AF75EC004DADFC35C7949405CFB1F6967F55EC0451B6188FF7A4940AA5BDB6A7EF15EC0A5E95A2F077E49408821A0A0A7ED5EC066CFAC26688049404B9EFDAB1AEA5EC04369626E078249408BE8386EC9E65EC0B48797D2048349407263A2A7A5E35EC0F6E3CA0D808349403AF534FEA0E05EC04F5BE8CA98834940137EA102ADDD5EC0FA73CEA66E834940A6FF7800BDD75EC0028B42EDCF8249408F08E5C7A3D45EC0C134C1509A824940764608D860D15EC0E94EA2C39F82494001A86AA9E3CB5EC0532CF1FD468349401BEA880995C65EC0F137B365A5844940ECC5FE9808C25EC0DCD28994908649400D503EE71CBE5EC0F30A5575E88849403D3F86A7B0BA5EC0767666B98C8B4940D9D26F7DFFB95EC034F233FF2F8C49409A7746A2A2B75EC0589D87E45C8E4940A90F10961CB25EC01E356B4FFE934940CFD6BE3C62AF5EC0EEE97BF78D9649404209087881AC5EC0A096075CC6984940C6E9E42959A95EC0E28A1A70869A4940DCA72FECD2A65EC0CABEAAC85D9B4940B368086F91A45EC0EB4175BD989B4940AB33857D1FA25EC09EB90CBF799B49400A5E14E9829F5EC0858BD763139B4940FD207A7DC19C5EC0411D6A44789A4940802986A5D9935EC0CAB4476A24984940ED80B91DBE905EC097653C66709749402DA9FD259A8D5EC0F49A5BC3E49649402B2BD047738A5EC06B7A2F2C94964940	152	935	6989	1138	0103000020E61000000100000005000000865BA2F757FD5EC0A53AA033CEC54840865BA2F757FD5EC0EB4175BD989B49403229D2F209685EC0EB4175BD989B49403229D2F209685EC0A53AA033CEC54840865BA2F757FD5EC0A53AA033CEC54840	South Coast,Thompson/Okanagan
35	Ktunaxa	RGB(0, 0, 255)	https://www.firstvoices.com/explore/FV/sections/Data/Ktunaxa/Ktunaxa/Ktunaxa	Kootenay,Kootenai	\N		0103000020E6100000010000007E00000011C67485EC3E5DC0A39C9FF8517C4740599A381258445DC0B9DF026E177F4740B4C086557A4B5DC0EF972F70B98047406AB5666D585B5DC0BD261FEE498B4740C74FCF26C0665DC0027B6525DE9347409E6553BBB9705DC0440CE7E5459F4740C331CE23E1755DC0C4D441C753A64740CA7AEF1F957E5DC0894DDA345EB64740C28C4020EB815DC0CC37F763D4C347406B568F7BE5825DC04AB35D26E3CF47409060FDFEC4855DC0C92A590537DA4740EEFE3A7014855DC0BAC8B77BD2E84740EB8C843977845DC028A76AD06DFA47409FDB8D0A7B835DC0189C1227FF0E4840A8358F9D9B815DC0A38D541B30234840D9DCCD389C815DC03D84A2D9F4304840E0C0FCA8B7835DC0A22CD6601C3D4840639DFA4689875DC06EE04C23534C48407C32163CE28D5DC08EBDF706D15E484075F1F34842925DC06B004667897048407049C4343E935DC08926404E10874840DDB952A65D925DC0A93AFD52C29448409A825449D6925DC097768525DDA248405B5B7A926F945DC08E492F2992AC48403C6F5D0117975DC097AC5CAA08C2484085A39B6D24975DC016ACF16B3DD4484081CEDC0D79965DC0DEAC7A7540E24840130DC9FEAE955DC09F6BBB15DCED4840132AC30D1E925DC0BEF363FE3DF94840EDF4FC12158D5DC0F59A454C7C0A494044EBFD627B895DC04ABF6684DB15494036485BE6E7885DC08B83D7862E21494002DDDF43518A5DC01CDADE64C42E494077085B24F08E5DC0A3D0C2189A42494099088121C4945DC00A6FFE96F5514940BC7B65BEF1A35DC030F41F3E7B6D49400ABA1DEBA3AA5DC07EC43FC2267B49407CA1CC1C2AAE5DC08A981A25458B49408F20B8D06FAE5DC0D173548FF3994940A1312D0F95B05DC04218C5E347A44940E81E4D1965B35DC03516D3C957B04940B01ECE7734B65DC0141FBA4B36BC494073037C1F2EC05DC020F29623DAF4494074E837FECACA5DC0466FC729E9284A40E88B698D2ACD5DC0F6BB21564B414A4097B9827AB9CC5DC0A47AD3982B624A40BF5D20A602CA5DC0AFBD6DFA1C7E4A40EB242DB059C75DC0CF7BCEB920824A40673625547AC05DC025AFC61FDC854A402CC8E6AF01AD5DC03584A4A6E08C4A4058478988BA985DC0B1BDB89208944A40864D9577907F5DC0C6E124E4C49C4A401200C4E7F3645DC0E31E95C8D39C4A40AAA5305016525DC0921DC5935B9B4A404974460B18415DC0658948C02F984A406F8B149217325DC00C847385DA914A4003BAB8F9F7255DC0E440310B63834A40F04E47748F155DC07D89DB7434704A40D2DD0C18B5075DC0CB156CF588634A40466C70E029FB5CC028AEDE2DAB564A40F2E0276604F15CC061603F5641484A4044928C7BBEE75CC07ED07216B83B4A402E76DEBD74D95CC00D7909558A2F4A40536460A56ACD5CC007B571CA941C4A40D4DD98BAA1C25CC08DBB5AB30C0A4A407FCBBA9AB2B45CC062932DA58BF549402B0E73833AA95CC0BFC928C9BBE649409313C5ED04995CC0D1F7A86216D549403EBE90F94D8F5CC00CB588B455C84940E8F8B190B4885CC092650C348ABF494008F53F39497E5CC0C5EA4897BDB649401C42A265CB785CC0A9189B20E3AC49408E4DD2F85A735CC068AFCA58EF9D4940DCA675A4B56F5CC0D5C4CB35438949401CB73F5C056E5CC0EDC6F81A658249401813AED9DB665CC0C7405BF0A47449407E740B7AE45B5CC0321AE11E275E49406ADD048162525CC0DDA4C0E1284949401BC68DCB454A5CC00481200430384940FD1DEC49D23F5CC098F52B02CA2949409DA5302317325CC076D97088601549407EC5174AA9285CC04301966FE3024940BFC78241871D5CC0A53ACE9442EB4840B3776BE77D175CC0095EA24158D64840D7A3AF007A0D5CC0C4CF91B925B14840095C1A95A2055CC0788081238F92484096A636A8BDFD5BC0E269CB79F1704840C135CA6F4CF75BC08374D6BF4A5B48400066E2BE40F75BC0C55DC74B314B48403F8B3F9966F65BC0C03507486E3848403E291B881EF85BC0E19E7F95DF284840BB1736B147F95BC06EB228194E1E48403938E081A2FC5BC0AF29E2E310124840F43493AD43015CC0614B014813004840E96D9CDB04075CC0890E6AADCBED47402C520B23710A5CC0B13010D075E24740695EA3099F0A5CC0C942999A66DA47407F0B770A140B5CC099DAFD90CBD14740D2F0AED47C0C5CC0E4C0FAA646C44740C0D0764CEA0D5CC06AD8FBE05CB44740FF7F2D76520F5CC03BAC9A3923AD47408729FCF5F7155CC03B39C58B839B4740C91147B6381E5CC052A01248958647403A8E75737D235CC008689F8B1B784740D72C7703872C5CC05D784966E269474083A060E83B365CC0B16A729CC358474052B986EBB2445CC0C3A728ABA74947405DACE6EAD5525CC09E588829083B4740249501BF365B5CC080898C6D763947405790896EC0655CC0668E64F9EE37474064B2ABBF91715CC0F1F046F5943647406F73C1CE367B5CC04BDDB0C6D6374740982197EE817F5CC00B5886F3AF364740993D0705B7855CC06F939FFBF8344740E4540F3AAF905CC0DAB176C61137474052CF79ED1A9E5CC0F06D7AD3623D4740F410C473AAAD5CC04805DF7064444740644538B10CBD5CC04F3851FA054A47401B6C126444E15CC0532D3414CB5747404F679058CBF45CC0568C6D30A65D4740CB7D3510A4055DC0677ACFAD13644740B2C3F91690135DC07861E3AD14694740952A84FD001E5DC0E526F5A426724740C1A2C141AC245DC0E8B741CA00754740F97EB7CEDB2F5DC07E76063CC179474011C67485EC3E5DC0A39C9FF8517C4740	31	410	1075	83	0103000020E61000000100000005000000E88B698D2ACD5DC06F939FFBF8344740E88B698D2ACD5DC0E31E95C8D39C4A403F8B3F9966F65BC0E31E95C8D39C4A403F8B3F9966F65BC06F939FFBF8344740E88B698D2ACD5DC06F939FFBF8344740	Kootenay Region
29	Kwak̓wala	RGB(255, 176, 255)	https://www.firstvoices.com/explore/FV/sections/Data/Kwak'wala/Kwak%CC%93wala/Kwak%CC%93wala	Kwakwaka'wakw,Kwakiutl	\N		0103000020E610000001000000AB00000071AD850B470C60C0E7386B1914704940B282D899950260C0E0EC532CAC7149407124834ED4FF5FC00273D7007D764940AAEB86ADC5FB5FC0E55CF3FF7C7949408410681E44F55FC073D1FA90088049401AD97DA9B4F05FC09287984CF78449407D1D406373F05FC0974587D1658549404AB9750FB2EE5FC0811430EC4D8D4940953FAC58D9EE5FC0742EE09E4D90494045F5908541EF5FC09FE5F5E5709249408954FFBDC7F25FC0D90E52A8D9954940F8EF4872E7F45FC00A576B890AA04940754FDA83E3F45FC09EEA34F97EA24940457B2ED0C1F35FC0C9B1303F15A64940CC7A956EC2F25FC00CA9AAEC8EA84940A07EF715BAF25FC04FAD8C24DEAA4940CDCB67D58CEF5FC077692E19FCAB4940D8A91672A4EB5FC00586426716AD49403EFF61DF28E85FC018931857DBAD4940FC848E1812E55FC09A1B239253AE4940EC52030B58E25FC0BDB304B287AE49405875C298F2DF5FC09C65AE4280AE4940B98BA29AD9DD5FC0B05D55C445AE49408AD349E204DC5FC068F43DADE0AD4940D51C7C3434DB5FC0DF327597B3AD49404952EA3B6CDA5FC031955A6B59AD4940088F27635BD75FC0F2A8A31D74AE4940A451D2C4EFD25FC050BFE8B01DB14940671500B94CCE5FC0BF811AFB39B449403E8CED0EF9C85FC01795D7FDABB74940F141053CC3C35FC0E4F503DD9EB84940FB26839A27C05FC046A51079DEB8494062BDEA6CC4B75FC07758C28949B949407BD86289E6AE5FC02DA9D7E66CB94940266BED29BCA85FC00859C285EAB849408804DE6779A25FC025365F1B97BD494001EF28994C9F5FC0E4F42A1DD3BF494083AE6F3DEC9B5FC0B6DAC288F4C14940C1EC406C1E9A5FC062D54D1BF9C2494074F4C5CCB0965FC0AC3D78FCACC449403AFBCEEB5E915FC0AE15AB2FE7C64940B3FA7BF7717C5FC0CCBB36A695CE49409A8AA239A2785FC09B3D42D816D04940A54C89423F755FC05F0D4DC18FD14940F680CE186A725FC003BA8A36FED2494089B428CB43705FC0DAED671960D449404CA57C8D7C6F5FC003B640AA0BD54940065A9E6FED6E5FC04C3C2449B3D54940422B4D959A6E5FC08546C7AE56D649405A2DA82A526E5FC0264E62FE4CD74940E9D7FF10186E5FC05F6675FE57D74940DEC0435209655FC0806370050CD9494007CC3934A1625FC0DB8BE7E65AD949408E1C9F277D605FC036C0515A7ED94940DDB34FB0955E5FC0A680F26470D94940BD410D51E35C5FC022675E032BD949405713DB8B5E5B5FC089D4852BA8D84940787F25769C5A5FC0E1131DC866D84940053470E2FF595FC0630B5ACEE1D74940BC67A1D6BF585FC0F7BDA3D8D1D649404FCBF6EA96575FC029AFB33372D549402E336DA37D565FC07759EDC5BCD34940BCF062866C555FC06E842B73ABD14940A749421006545FC0F149CD0B5ECE4940E6EB7E1524505FC032E32E1BBCC34940E3CA4D66C44F5FC0C95A80E94EC34940E43316CF514F5FC081FAB71BCCC24940ED0BEED82B4F5FC01E1BCDCD56C24940F31D894AD44E5FC0920E732B48C14940E1EDB8006D4E5FC0D5F5DF8E12BE494056E67C30114E5FC0095C31969EBC4940B8A3CD36A84C5FC0D74C781383BB4940CB1949E51C4A5FC0DA6667E895BB4940B4CF6863FE4B5FC082015FE579B84940C79D374C554D5FC0F85344EBB2B5494019B768246E4E5FC02A97E1B4C9B24940AA0E77FD4B4F5FC09A9C4F56C0AF49405445BFE9F14F5FC06A2807E098AC4940FD2814FC62505FC051FA545F55A9494096831E47A2505FC0C0C602DEF7A5494059886EDDB2505FC0CDEE2E6482A24940CA691DD197505FC059B393F8F69E494085D8533354505FC0A69C59A0579B494034D30114EB4F5FC0F6F9705FA697494087F59C815F4F5FC048B7E438E59349403530E588B44E5FC0BA7E262F169049407BD9AF34ED4D5FC0CA3254443B8C494085AE7B9A154C5FC00D44BAD36984494051830E5F0B4B5FC0D9B89F527780494090F96C13C9485FC007CBF7CD887849404FB434985D465FC01027E60C9B7049400C4E9AF269415FC09303F19B026149402B200DAB13415FC0268E3635DB5F494090E5798C8F405FC044F5E12B8D5D4940ECE64CDF39405FC0DC03F2C93E5B49407FBFC1D8FC3F5FC0C44231F4C4574940B8B788FDF53F5FC0C37A4C084154494011765F7612405FC065FD0C82044D49408CBA66D3F93F5FC0288B7BB2404949406B44216E9F3F5FC048206F625C4549403328EC31A5405FC08CEF4FF493424940CF0EF21733425FC07959F2D3E94049409B825FF6BB435FC0503B7EB2923E49401A7094D3F1435FC0BD909260933B49403B792EF549455FC0A25DEB072A344940DEB0DE0CF0465FC0DF9C4B70353149406983B4F8B9485FC073A9A8BF1B2F4940D9AD14D5574A5FC0B95410BC8F2D4940DEC63155B24B5FC04D9AA4B13D2B4940264FDB3BF94C5FC0F6AAE8F64B284940F32BA270944D5FC0DCD8C9B474254940ED786E27304C5FC09D76CB88F5204940CDBAC115EC4A5FC0214312B7F81E494028F283AB7B495FC07D41009E611D494081739D029C485FC0BFF4D0E79B1B494021D318E98D485FC0D0BCD3CE231949402EA4F22B4F495FC0639599E9051649407EA55965274A5FC0848D42A6DF134940CC4C2F1F324A5FC01AC545C0A20F494013F75701E6485FC0B360AB43C509494079947164B2485FC067D3B5D1DA024940C7F7F972DD485FC0D4FDD385620149401D39BA42D0495FC07D2BE5615BFF484072A9FC23804B5FC0EC55EF2A4CFE484066A49F31CD4D5FC0842FACDC91FD4840BFF3733BD4515FC06EC1953C1AFC48407B295A66F4535FC0B37875C6FEF74840DF15321A65555FC0A6EB661AB3F14840EB124DD821575FC07939F7294AE44840FC2702C9F65B5FC0AA69808F2ECE4840A5799DA2705F5FC05CCD4C7DF8D048409F3B744BC1735FC058AA17804FE048404770064ADB7E5FC09D5E34369FE948402B4DBECA9C885FC0669647D08AF248403BC182AF37915FC0582446D0F3FA48402B100CB5C29F5FC000337076C0094940B416AF1F18A65FC08A2BB0EBE30F4940ADBEEA4D11AC5FC07150A5A604154940ED990B55E1B15FC04EC6FD940119494069482960BBB75FC01929114FB91B49409EEAA294D2BD5FC065D73E180A1D49407A68B9F059C45FC007214CD8D11C4940B4CA7BF2EFCA5FC05C01D39E021E49401C4E9E808BD05FC099B8B40B08214940DB0991A982D55FC08A9511C7F92249400E22B839FFD95FC0768BEC98DA234940F1BD52302BDE5FC007B18B05AD2349406C693BAA30E25FC045B2565873224940F04F29CD39E65FC01CF418AA2F204940A8767BB370EA5FC0BB8A9AE2E31C49407BCB9858FFEE5FC00A7393B591184940D87DF0850FF45FC054DD0B9B3A134940B9457C4A4EF95FC0B9096863570D4940BC64210805FB5FC01392642AE00E494012FA5ED6D8FA5FC04113F9449510494089FC7741C1F75FC0E43C2B5DC7164940DD57E0E8CFF55FC0E5A21D46EA1A494034988F0290F55FC0A37ADB324D204940C366319993F75FC039A3A95E21244940D242FD4306FE5FC0986C728A21294940F1B8BFB2BA0360C09F392C221A3D4940F430267A180760C0BF54BFEBBC444940DD568DEA200A60C0BE012CE09F4E4940F12B30D9180F60C0FE5535A2C5594940A87F6E99321C60C01CBAC299D76349403EFE14A9AF1D60C0B65FE855AF68494053655F03B81D60C090176C358B6949405DCC5E1F811D60C084413D06466A49401D822591571C60C0D7B3E83EA46B4940B2B5CAD8BB0E60C0A3B7B127156F494071AD850B470C60C0E7386B1914704940	167	786	6482	443	0103000020E6100000010000000500000053655F03B81D60C0AA69808F2ECE484053655F03B81D60C036C0515A7ED949406B44216E9F3F5FC036C0515A7ED949406B44216E9F3F5FC0AA69808F2ECE484053655F03B81D60C0AA69808F2ECE4840	South Coast,Vancouver Island
27	Hailhzaqvla	RGB(255, 128, 255)		Heiltsuk,Bella Bella,Heiltsuk-Oweek'ala	\N		0103000020E610000001000000DF000000E645DDECBBF65FC057ACE947AFB749401688FEF0C8F95FC0FF29A04AABB549405C68EAFB96FB5FC0964E311D0AB649406DD63292A5FD5FC08EE7E885DFB749402257860A600160C0CFBE0D18BBBB49405FA5D12FC70260C089441F744ABD49408265C2A6500360C0F9A11BF728BF4940919D7A38E40360C0827CBB7E53C34940AAA588847C0560C0AB6887C317CD4940B07DB02C560560C089E40C2FDED24940BF06CEFD3A0560C043BF33DA3AD5494059C10A44140460C0901EE7F410DA494062AEB9D6D40360C0F18D63FC23DC494049403F564C0460C040860EC5E4DE4940013157EFFD0560C0CF9BAC2250E14940089180D87C0760C0CB57E0E858E44940A9ED9F0EB40860C0B7BE782F71E74940DFD56D82260960C0F79AFD9302EC49409D9F9FE1370A60C0EA01360B55F149403A26B67B0C0B60C04D6BB8331BF34940F5CF05C28A0C60C0F973DEB419F449400B273547970E60C040E6F62614F4494073BD2118650F60C02ABDCA4E4EF4494022D1B434041060C0403E42299AF54940A1AEE035071060C07661D62B1EF74940A67465DECE0F60C087A9CB5C8EFA494058F59C1EB70F60C000D1F12576FB494046B53D4A3C0E60C0C5FBB9B650004A40459A7E44670D60C003F9F8FB23084A40B21FA925630D60C08D84F674D50C4A406666B797B40E60C001DF64D008114A40E6F24F21131060C06D327D038E144A401947FC8FE11060C0F761592BDC164A40E0924194DC1060C069EB281271184A40624B2F4ADF0F60C0098F1448AE1A4A40C4577C6B5F0C60C0B033C68903244A40103053BCC20C60C0FBAD79BE2C254A40E614BB05070E60C07D68253511254A4042A73699361060C04840BC9E00254A40E34688C73C1260C03CC1D97280244A40D9C43E0BFE1460C00FC0581593234A4079CDF8EDA11560C05AC26A9B34234A40AAE6FD16761660C0487C984D01234A40B3E92A88E21660C0E0E7B2FA71234A40C4B464F8721760C0819C4CE22D244A404BF48706BD1760C05270B89888264A40204F2FA11F1860C01609C5C9502A4A4003DF95A6C21860C0E6BF059B3E2D4A406ECE1073611960C05A39E948A62E4A40AC7910E35F1A60C03359511E6C304A407F43FAF1751B60C0C4B532217E314A4012A4D6C5CC1C60C0C6F38F490F334A40D9CBFBD3A11E60C0BF171FE5D0334A406F74EE7AE82060C03A6381640A354A403E957199F02160C086059C6399354A401778E305942260C021373857F4364A407FFD81EC862360C0A720DAB63E384A40730CDA41332560C063EFFF478B394A4097CA1C1F0C2660C0F6425826403A4A40AD47DC20232760C0E969FEFDA13A4A40B6FBA936BA2960C03E1D3278D83A4A40A8761077292B60C03DA6D278F03A4A408043C013262C60C05D324E47223B4A400CA20F6AD12C60C0DFDF531DCC3C4A400906BCC9742D60C00DD1990BF33E4A40992D99881C2E60C01866FBBCA7404A4047180F4D552E60C04353E714A8424A407EBC97698F2E60C0433A670496464A40F850F80FEB2E60C00EEEE2F1D64B4A401186803F0E2F60C098569CC9A94E4A40C1743E62FA2E60C019CD4758B4534A40C714AFE0DD2E60C0A368B3C2F1564A4028BC009E542E60C04201221F6A584A40257B9ED1A42D60C0055D19339C594A40E7DACD75E72C60C0095530C6B25A4A40F87C7FDCB02C60C05E0EBCEBDC5A4A405D6E7A18F92B60C0176C06AF8E5C4A40F53B83348E2B60C090967856075E4A408EB41A5F532B60C081233417D35F4A406E15ED76E12A60C08D10BDB5E4614A40F4C13764532A60C0F818491E4D644A4054EF4F60112A60C065E272E8AD654A407E340EFDF02960C06093BF78F7664A40D79ED7F7F32960C06AFEE6754A684A40F307BC9AE12960C07FD448F3D4694A40351DC7A5C02960C0A14B2561CF6A4A4043F9A1AE122960C050CD63DFB46B4A404300A4A39F2860C04363D2DC276C4A409E936270422860C0FE7BC336876C4A405A78D6A6C42760C047C51790526C4A40F42FF11A732660C0B3655A16F16A4A40344E0A85212560C009A4238189694A40D2F5FF94A32460C03E1EB8F5EB684A40277ABB0A2E2460C0BCE5FB366C684A40B47E8E00D52360C0AD47D7F24B684A4029DCABEF322360C0D38DB8716D684A40D302E646782260C076248E079E684A40DC5A3DBE932160C02BF6BF9C46694A40598676E9092160C0721F3833C8694A40A3C9A7636D2060C005444913046B4A40C07E60120A2060C0AB422A3BE76B4A409286B9D7791F60C0C39E0EEF2E6D4A40BAD3C4FD381F60C0644E6948D16D4A407D559571FE1E60C0B8443564806F4A40E06A05B2A61E60C06A3D0F16E0704A401479F48FDC1D60C0D588CF9A9D734A40C12853BA751D60C068568C6568754A40DAC71FE6171D60C03187D7B273774A403B80C4E7B61C60C0195776EECD784A408484FE8E771C60C02A2ADD3D4C794A403AEDF4E7961B60C0B1D2C7DB867A4A404A966DFE501A60C0EF29EED6737C4A4092A9481BC91860C07458AD64CE7E4A408F275D634B1760C02D53A80930814A401829B93DDE1560C00632A94F4B834A407FB0DA11C71460C052C3EAE623854A4084D80B98171460C0292101E147864A4093D0E4ECD41360C00B18E036D4874A400AAF7B46881360C071DDAFE33E894A401DBE76A2761360C09149723A508A4A4058EB6CC7631360C0A47151E6E18A4A409B589F34A51260C0FA043236628B4A409D85D6A3661160C076A5847BC18B4A4047E9E1D4A81060C018A68CAF2D8C4A407C6E8F74F70F60C019D6075D808C4A40503DB3A75E0F60C0AB9423E5F18C4A4090AD3727E10E60C0F76FCB5B1E8D4A401111B28B380E60C072CD1ABA128D4A4060277EF8CE0D60C0685BB15A6D8C4A407BF9B169FE0C60C0828CB7568C8C4A4094636A92500B60C017AA15D33D8D4A40E39212040A0A60C068366B8FBF8D4A409216CDFDE90860C027713DE9B38D4A40BFEF87FD030660C09A5054FF60864A40A40555DE0E0160C015F9E12350794A4050A41D57E6FA5FC032C777973A6F4A40D50AA93DBFF95FC0976290807B6D4A4069CFA443F7F75FC0FEC4369A736A4A409463661495F75FC0B3C2C062CC694A402FD28BAE4BF75FC05DEC2CD921694A403284A6AB4AF65FC0176E374FCC664A40CFDC5FB822F45FC00ABC4E4CFB5F4A40174F0DDB39F35FC077575604D75D4A40BD1B168B9EF25FC061A99A08A65C4A40237F09EE27F25FC0CC06AF01BD5B4A4090A015ACDAF15FC0813B4807B95B4A4078267D528DF05FC0E248ECCAA75B4A40DFCEB28ECFEF5FC05131EFED9D5B4A4080AE5A67CAEE5FC0D8054EB24A5C4A40CB2F77006BEC5FC009E415A3995D4A40536F6B3CBBE95FC0869FDCF9625F4A40B31A148ABAE65FC069852EC890614A4066E62DCE04D95FC0E9150E20F56B4A40E2844E0289D55FC00BC020206A6E4A40577198902DD25FC0F852789497704A40EA1EA9AE05CF5FC0D4B2290C61724A400FA05EA324CC5FC0C69D7B24AA734A40E38944C09DC95FC01A5DEE8556744A406509425984C75FC096BD5EE049744A4051096EF5FBC65FC04B63919E46744A40EC4FF800DDC65FC00FE1A1DE57724A40776D6A9F2EC65FC0CEDCB391C0704A407A32447415C35FC0C6D795BD026F4A40AC76A2AEBDBF5FC00045FF19FD694A402389EE5048BE5FC0DE37BD82D6644A40AB64F53CDCBD5FC08D192A7850614A4050A7F67EA4BC5FC034BBC897BC5E4A4087C79728A5BC5FC090C68136575D4A40C1D5E98136BD5FC0D3EE58E7FC5A4A40E3EE637509BF5FC037E5897487584A408631458C56C05FC0B9253B1660554A4053808EE874C35FC0FC72A9744C524A40E2B1FB186CC65FC04E653B12E44F4A407A3862B0ECC95FC0F0E1DAE0504F4A409DA98C6C7DCC5FC08D31769D134E4A4020660D491CCE5FC07C0C9EA9E7494A40396F0D8798CF5FC0F9D3887B27454A40A90AA9A794CF5FC03720B9E2E5404A40CA079CFE79CF5FC018C5FFF3BC3E4A4023D9D904CBCF5FC0E30C1F5A183D4A40B91D35722FD15FC02D116439A93B4A40DE532C0C9FD25FC057B1A8187B3A4A403D07D261DFD35FC0188E4285BB384A408F8950EAD1D45FC09D426A7E32364A401C436E3158D55FC0DE801307A8324A40D09FAAD45CD55FC04DE17263712E4A407C5EA12723D55FC05E46EDA5342B4A4074B7EA96C9D45FC0CA69FBD665284A4022756FC85DD45FC05C8EBBBEF3254A40C840E40D35D35FC0C7AA399F1D204A40E6AFE91206D35FC0801B7ABF301F4A40A764D55A08D35FC0DDECEF48721E4A4057BE96640DD35FC081511FA1CD1C4A40DBC26DD0BAD35FC0EB42D6BE46194A40CC81B8D0F8D45FC04B48D08DF9154A408018E59E0AD85FC0557B60FB1C0F4A40B6CEEBC050D95FC069B91433160B4A4044F1382F0CDA5FC01344354F5A064A408225C59EF6D95FC02ED686C2AD004A4089D79441CAD85FC02C0BF2E1D4F949401EB25BD980D75FC06A2D0E5F75F6494032784A34B3D85FC0F9F568D238F549408D4C6B8BD6D95FC05EE53E4042F44940388B45858DDC5FC0168D28B26BF2494042FCEFF9C0DF5FC021D29FFDA3F0494039EE314317EB5FC028D22FA5EFEA4940B0F2259D0DEF5FC03B9C2680ADE84940C0EA588600F15FC0EA6C5C3771E7494097DCA1DEE8F25FC059D855D41FE649402AD0A47FB1F45FC06BB4F917BCE44940FA8586BC0AF65FC0AFA9359918E34940A31C957504F75FC0EEE3F76D1CE14940C40F45417FF85FC01D285B091ADF4940483128B59CF95FC0CA45D46816DC4940A28AB3FF0DFA5FC015C64D59F0D84940A7960665C6F95FC049FC1EFDA8D5494090D37E6E28F85FC00A75ED238ACD4940DDC372C32FF85FC06FA8878481CA4940FF3D03B459F85FC05AA2FA558EC749407C3E6A8BC8F75FC0B0323B8FA3C24940F52311F6E1F65FC06A3C97FD48BE4940ED07A2B385F65FC0A8B1DA6D79B84940E645DDECBBF65FC057ACE947AFB74940	39	337	3330	169	0103000020E610000001000000050000001186803F0E2F60C0FF29A04AABB549401186803F0E2F60C068366B8FBF8D4A4050A7F67EA4BC5FC068366B8FBF8D4A4050A7F67EA4BC5FC0FF29A04AABB549401186803F0E2F60C0FF29A04AABB54940	
34	Sm̓algya̱x	RGB(192, 144, 0)		Coast Tsimshian,Tsimshian	\N		0103000020E610000001000000F7000000C4577C6B5F0C60C0B033C68903244A40103053BCC20C60C0FBAD79BE2C254A40E614BB05070E60C07D68253511254A4042A73699361060C04840BC9E00254A40E34688C73C1260C03CC1D97280244A40D9C43E0BFE1460C00FC0581593234A4079CDF8EDA11560C05AC26A9B34234A40AAE6FD16761660C0487C984D01234A40B3E92A88E21660C0E0E7B2FA71234A40C4B464F8721760C0819C4CE22D244A404BF48706BD1760C05270B89888264A40204F2FA11F1860C01609C5C9502A4A4003DF95A6C21860C0E6BF059B3E2D4A406ECE1073611960C05A39E948A62E4A40AC7910E35F1A60C03359511E6C304A407F43FAF1751B60C0C4B532217E314A4012A4D6C5CC1C60C0C6F38F490F334A40D9CBFBD3A11E60C0BF171FE5D0334A406F74EE7AE82060C03A6381640A354A403E957199F02160C086059C6399354A401778E305942260C021373857F4364A407FFD81EC862360C0A720DAB63E384A40730CDA41332560C063EFFF478B394A4097CA1C1F0C2660C0F6425826403A4A40AD47DC20232760C0E969FEFDA13A4A40B6FBA936BA2960C03E1D3278D83A4A40A8761077292B60C03DA6D278F03A4A408043C013262C60C05D324E47223B4A400CA20F6AD12C60C0DFDF531DCC3C4A400906BCC9742D60C00DD1990BF33E4A40992D99881C2E60C01866FBBCA7404A4047180F4D552E60C04353E714A8424A407EBC97698F2E60C0433A670496464A40F850F80FEB2E60C00EEEE2F1D64B4A401186803F0E2F60C098569CC9A94E4A40C1743E62FA2E60C019CD4758B4534A40C714AFE0DD2E60C0A368B3C2F1564A40BC365803173460C01FB61A7C8D7A4A4013A1391E5D3560C0CEE436AAB77E4A403C203A85943560C0BAE68690E8804A400570E0B70D3660C0BC08E8A6ED854A4007463406B03760C0CDAA2DBC41884A405C2A0840FD3D60C0A9FB1A50DF954A4081D448972D3F60C0B19504A600974A40FEB5B978BB3F60C05B793BA145994A402CAC1979AE4260C0A19AE85719A24A40BA21DB15924660C0424E70D615AC4A40D846301D104A60C05C9E3975C3B24A405136FA131B4C60C04F12E8B818B94A40BA843863FF5260C0CF8B3658B4BB4A403F372C3D065460C09307122E60BD4A40D13B6D8E785460C0932298E618BE4A40037CD409355460C02621C659C8C14A407B724057DA5260C0C44C1CE6F2CE4A40C82C22E50E5260C05FC3DD09E7D04A40C9C59F8A055060C00AC551CEABD14A40C8B23209D94E60C088F690FF7CD24A400638F5020C4D60C010E3011EB5D84A40649010CEF94C60C06EE125A7B9DA4A40BA6BE0D85F4E60C0CBF50F7E7CDF4A402294E2C0245160C09548B0B075E24A40FB842978E65260C0176EBFA69BE44A40BD3CC0248D5460C0380BCBAA61E74A40FD7A82F5B75660C0E73E80E2ACED4A4050F005907F5760C0E7220F229EF44A40A1D1635E505760C07715390D1CF84A40E7E8EB3E305760C00586BC0AB8044B402FEFE3B9165B60C0938D0D4C57144B405ECC16B0DA5F60C01A9B743D34394B400467C0928F6360C0AEBE330E534B4B402FECDE8DA66760C03E1C849A3E534B402F815FDF496760C0D6C639884A534B406CB372DA0D5F60C0A1AE22C7AA534B406AF7BA156F5A60C0C7076A8863544B40D08D7831885760C0325AC84A7A554B40BEF9A654C15560C0FE19179814594B40F4C70CF6B15460C0D30E86EB235E4B40E4768071935460C08532A2A7DD614B40DF141AC05A5460C0AD263152C4634B40772777F7D85260C0BE8A768433654B402DDE7C7BF25160C057232DEC05664B4023FC87223A5160C09FB066CB2C684B400FE46CA1615060C0A0B6B0D8676A4B40A4B10CBC205060C0E8DDCACEA16A4B40D14722D4C44F60C0156FF6A8256B4B40A817460E314F60C024BBD21FF66B4B40E5F456FEAD4C60C03413EB50F4634B40958084B6F94760C00E2CB4289A624B401B9CC8DB3F4460C032F44BD6A2624B408A8F7AA7CF4360C0F59E152221634B40B37BD93F7A4360C0F93D07593F634B40D4A76D82604360C0916A76D73F634B40EDA7C83D614360C0311D96EC13634B40DCA6C0825F4360C0C9210A8380624B4091A0667E444360C0800ABF4836624B40A6EAC31F924260C02CDAA12131614B40630A1043354160C07F20A1EB8B5F4B40B1FE2C651B4060C090C88FA1C85D4B4087BDC7A2363F60C0482F0494FC5B4B40401CE9B5E53C60C0F8516A3767564B4056321AA1993B60C095766B14FE544B4049A58850363A60C02FF5520164554B4065511F05DC3860C0945B3AA6A0574B406D2E43A1AD3760C03CA023FA20584B401CD71CEFBC3560C02AC5DE2160594B40E1595DD4B93460C0F805A5B5255A4B407C64AB200F3460C0F7FF3B0D855A4B404415920A933360C01D7BD31AA05C4B402B68BB580B3360C04F9C898D62614B40D84D7D7BC53260C0DC0E14F012644B407664B013733160C0A022FC13DF6C4B40E4A9C41C1A3160C023401BF6BA6E4B406D534F36B33060C05D79186559704B402CF25246383060C0A9C3D810AD714B40B855C633A32F60C06E9C3CA5A8724B407CD044E8ED2E60C007AFC0C83E734B40333F1652122E60C0B860C21A62734B4009E38D660A2D60C03F99693105734B4097BB3C5B6A2B60C0D285E96209724B4000F70CBBBD2960C08D2A60196F714B40AF64E217462860C00DDA76FF64714B4054142276FF2660C0BBB150BFDC714B40EDA7A5E5E52560C0469180F6C7724B40BD55427FF52460C0ED1FBA3718744B40BE848B622A2460C09B16570CBF754B40232CCFB3802360C0BC93B2F5AD774B40E40A4B9AF42260C0C10A5C6ED6794B4018839A3E822260C02D7223EB297C4B4025E35DC9252260C0CF4F00DC997E4B4020AE1C62DB2160C00B93D5AC17814B406683652E9F2160C0447714C694834B40C6526850102160C09402F3C7E88A4B409D86D3425C2060C0EEE06815B0874B405E091E8BCB1F60C0E737447195854B40E55EA0B30A1D60C03ACA4DCD9F7E4B4045278810EC1A60C03D2F6441C9784B40491E9D61901960C0DE394555BC744B401B82A7DEF91760C08F03D06BC06F4B40ADE8EEEAD51660C0C32F14BBF66B4B4000DADEDE571660C0F37E7BB4D5694B40666EAB7EF91460C0A07B9FE0A1634B408C0F2BB57F1360C0C96522A1965B4B40ABAE0AC5B51260C063E150B4A0584B40164C48CACC1160C06F88621DD5554B400642FF7CBF1060C06CAE7E044A534B4026E625A8FE0F60C09696C2D8F2504B400A83555A0B0F60C01E572FB3D5504B40CF542D45900E60C02438663473524B40DB3E1E7A240E60C0D2BE9198A0544B408151626D1B0D60C08EFA25E165594B4038C22B40C60B60C06E52F7AA5C5F4B4011512A20380B60C068F2401693624B4060213308220B60C0379D9B7CDD664B408D2D4F2D030B60C081E5CFCEB0694B40D7AAA414540A60C09E8A6B1FD16B4B40401ED209D00760C0FD6528A2896A4B40B6D2F9BC290360C0E8A17F72CC654B40ECAB034D90FD5FC05AF12499B7654B40490E47A678F55FC0C7E0DF8C39694B40EE52D7BD8AED5FC031E46427946D4B40F946470524EB5FC047686FB2CB6E4B406461E0FCB6E85FC087B4A34ED26F4B40F7CA22EF59E75FC0126203264D704B4000650A4DFBE15FC04861491DCB714B40AE9989F3B4DF5FC03C4B033D54724B40C1DFA523E6E15FC00CF532B634624B405FE833C028E55FC0E21BDCAF09564B4054EBE5102FEB5FC00D80620A0B4A4B400A98855236F55FC023930F7D423E4B40777D3175ECFB5FC047055EDDE2374B4085DCF6DCE4FC5FC01EB7DFF223354B400881DC5A9EFE5FC0BD1E27D5AD334B405B921A87600060C0224D94021A324B40C90237CF7D0160C09E39B846AA304B4036128BC6A50260C0843F12A95D2F4B4066E98A2ED70360C001D06532332E4B40428D3AC9100560C090C5D7EC292D4B4010A81259510660C0CFC207E4402C4B405BF0E6A0970760C0D8A92525772B4B401112CE63E20860C0693403BFCB2A4B40341B0B65300A60C0C8B121C23D2A4B40BC41F32FD10C60C0047BCC4E76294B40AF1F2D1C700F60C0DDBC027219294B40F1FF3801811360C0047CD94D25294B406BE912AB741560C014355E8CA6284B400EA44881651760C0B18C0AF9BB274B4043CDD1C24E1960C03BA9226D69264B402A8798B12B1B60C0612BFCC9B2244B406A543B93F71C60C08EDB66F89B224B40D6BAC5B1AD1E60C02FCCF0E728204B4025195D5C492060C08B83038E5D1D4B408563DFE7C52160C07C25D7E43D1A4B40A88C71AF1E2360C03FB038EACD164B407851FC144F2460C0947A209E11134B40106EF4DFD32460C035F99D001F0F4B40F6FA63012A2560C046B312C4320A4B40EAF6C59A1C2660C091ADE7567D054B406EB0FE7E212760C0ADE48A2A75014B40B148C0BC432760C04C667A1677FC4A402F632984222760C04EFFCE7544F74A40D8EB93AF852660C067E67A0C8EEE4A40D99BA702B02560C0A426462430E54A40588EC841C42460C09EA23543F6DC4A404408AECEC22360C00B51D704C2D54A404FEEA10EAC2260C08CC69E0675CF4A40EE9C976A802160C053A417E7F0C94A40611F924F402060C0C74A644517C54A40665D3E2FEC1E60C0C580EFC0C9C04A408E89AF80841D60C0A5EC40F9E9BC4A409E2532C1091C60C0FF2FEA8D59B94A408D722D757C1A60C04732861EFAB54A400F7739F06A1560C0C7734DF3D1AB4A40E0813D4D991360C0B02270AD06A84A409546373FB81160C0FB7C2481D4A34A406478C188C80F60C0D04F590F1D9F4A402A754F5C700D60C02574170714994A40BFEF87FD030660C09A5054FF60864A40A40555DE0E0160C015F9E12350794A4050A41D57E6FA5FC032C777973A6F4A40D50AA93DBFF95FC0976290807B6D4A4069CFA443F7F75FC0FEC4369A736A4A409463661495F75FC0B3C2C062CC694A402FD28BAE4BF75FC05DEC2CD921694A403284A6AB4AF65FC0176E374FCC664A40CFDC5FB822F45FC00ABC4E4CFB5F4A40174F0DDB39F35FC077575604D75D4A40237F09EE27F25FC0CC06AF01BD5B4A40DFCEB28ECFEF5FC05131EFED9D5B4A406C67DFDB40F65FC0AEBDF04658574A405FD6C662EEFF5FC03EF27AA93E514A40650890AED90160C09C927518B04E4A401D972CDED60360C017D30548B74B4A40ED138388E60460C026B32D62004A4A409F7DB709EB0560C0614469A932484A4009D4AABE930660C0C49463346F464A406A4D97C6280760C0A654207BDA444A4035037E97A10760C063B3900CC0424A4074697A5F1C0860C0AA0E8500C33F4A400F5FB5432C0860C0674E8DE4393D4A40FCCD59C32C0860C07AC012557B3B4A406ADACEF67A0860C002FBD56A07394A40A557E5ABFD0860C098D5FD118A364A409F8C0EDC260A60C09AA8851961344A40571FA5AE280B60C0F5F6C6324B314A40B3541D9B070B60C0DC7DDC51292E4A405583831C130B60C002ECC966922B4A40C4577C6B5F0C60C0B033C68903244A40	57	1175	8353	879	0103000020E610000001000000050000002FECDE8DA66760C0487C984D01234A402FECDE8DA66760C09402F3C7E88A4B40AE9989F3B4DF5FC09402F3C7E88A4B40AE9989F3B4DF5FC0487C984D01234A402FECDE8DA66760C0487C984D01234A40	
18	Dakelh (ᑕᗸᒡ)	RGB(0, 208, 104)		Carrier,les Porteurs,Takulie,Takelne,Dakelhne	2	The status of Dakelh varies considerably from community to community. At one extreme is Lheidli T'enneh, where there are only a handful of fluent speakers, all of them elderly. A few younger people speak the language less fluently. No one under the age of 45 speaks Lheidli dialect.\r\n\r\nSeveral other communities are similar, though the number of speakers is larger and the age of the younger speakers is a little bit lower. For example, in Saik'uz (Stoney Creek), most people over the age of fifty can speak the language. Many people in their thirties understand the language fairly well, but they cannot speak it. The only exception is a 35-year old who was raised by her grandparents.\r\n\r\nThe communities in which Dakelh is in the best shape are the remotest communities. In the Tl'azt'en Nation, most people over the age of twenty speak the language, although the younger people often do not speak it very fluently. The same is true of Lhoosk'us (Kluskus), where there are teenagers who speak the language.\r\n\r\nAlthough there are communities like Tache and Lhoosk'us in which the majority of people speak the language, Dakelh is dying everywhere, since even in these communities very few children can speak the language. Where the only speakers of a language are elders, it is obvious that the language is about to die. When there are many speakers, including younger people, it may seem that the language is healthy. However, if the youngest speakers of a language are twenty years old, unless they pass it on to their own children and create a new generation of speakers, the language is just as sure to die as a language spoken only by elders. The only difference is that it will take longer for the language to die because the youngest speakers have longer to live. Seen in this light, Dakelh is on its deathbed everywhere, though the final hour is much closer in some communities than in others.[[All State of the Language text copied directly from the Yinka Déné Language Institute's website: http://www.ydli.org/dakinfo/dakstat.htm]]	0103000020E610000001000000A4010000F6DD792C6C3D5FC0A69915D7D33F4B40F8E5C75E0F3E5FC09A41A97987404B40F659C38C373F5FC015C8A7F079414B409247153778405FC07E0B5CFD30424B400D098EE746415FC0E1664CA76A424B40E3527D6A27435FC091C46E15B5424B40534CB34D9C445FC0B7FE8277E2424B40204EAD8ECB455FC0DC1CC77997424B409333F2B887475FC0232648D1CC414B40E5EA59DAAE495FC039265F7C0E414B4030522BA6584A5FC04F1A0637FA3F4B40926DB0A9034B5FC0B17DE7CDAA3F4B40BFDFF0601C4C5FC0256F727D22404B4027A0B48F524D5FC0C381B7059C404B4074DDD0880A4E5FC05CE5BE569A414B404313CD92F94E5FC01E6C599124434B407E963785CB4F5FC0502949C6D2444B40F2180A6F77505FC0574711164D464B400DFB983E87515FC08E721D0568474B40F2CC11FCD0525FC0A82A2EDDE0484B40F7C9F52C8F535FC0A8359440604A4B40CDACB93879545FC064691FD8924A4B4089747E3EAE565FC0FE12C521BD4A4B40E5996F3DD0585FC0EB7611B6364B4B403A57D509275B5FC007F15E79234B4B407E215E3AD95C5FC02A4ACB09324B4B40CE737641C45D5FC01BEC2719644B4B406E353C49185E5FC0DEB0C697E54B4B4015E46B42925E5FC0119BAF28DD4C4B406867D0CD505F5FC0B4305E13464F4B4039AF295389605FC0FC7C272C99524B4030A81019BA615FC03432C0D656564B407C0F0D91D2635FC04379E714075C4B409A77BC757A655FC057E5A730C45D4B401F38BFA4616A5FC0EE88DF8ACC634B40287CE34D866E5FC00BA0BDCEC2694B40C5DC159F0C725FC0CEAF052DB76F4B405925DEFD18755FC08E1CE994B9754B4097EBD701D0775FC09A539BBFD97B4B40652A2672567A5FC03C3EAA3927824B40A8BB82A6657F5FC0FB166394878F4B40B676FEAA9F795FC0677445D49A8F4B404180FD9251705FC0B024B84BC7904B40F7CC9200356D5FC0783B702365934B405DAB5F4BA6695FC00DF8C9FD0D974B40AA8C6C386C655FC05830E513519B4B40D971CF7FE2625FC00EB93A7C799F4B40A028EFA9795F5FC071D4CED3C29D4B40405FAEFB68555FC09C9E8E4E20964B408B681DDB42525FC041E748F3DB934B402CFCFB54D04F5FC0DF83BC2142924B40A5BC841B8E4C5FC0FAFDB37F7F904B40E69AC6706F425FC0DC16F8C2D28B4B4010560A25D1385FC00909FB4E00874B404B7A6AC639375FC09D252EC8DA864B4065190CB4E6325FC0BD58A77C1A864B40C52A95EB6D245FC01425C4B91B834B40E58A8CF4D1165FC0D8C9935CE07F4B407A3C7CC78B0D5FC03033BC2E6A7D4B40180A2672CC045FC0209D790ED17A4B40134B02292AFD5EC050126F662E784B402FD34AAFF2F95EC002FEF3BBE1764B4034D76510D9EF5EC0EDDE6E3661794B4039D06ACE94E15EC0FF22D6B3E07E4B409AE858C6BBD45EC04C03AF0772854B407DC3F44AE5C55EC00138948546884B403152A36466C25EC02E46C541D2884B4086DAE63D1EBB5EC045BEE5E920894B4092C826DB45B65EC0D0292E922A844B40380DE60619B05EC06F6EDE93067D4B40DC770E2227A95EC027B52B5D89714B40B03C0DAB3CA25EC0FB42CB3758664B408B97907823985EC0DBEA9853BA5B4B40A3F8C3668A8F5EC02E2A0548A9574B40679B9E7111865EC0F4FD9F9CBE4F4B400032F64F14805EC0E30EEA34B9474B409B2B6EB9F37B5EC026E9060BEE454B40A82835780A755EC010D4E7EA2E424B404503BA708D6A5EC093EFFDC8803E4B400256DD2D6B615EC0777FDE61223E4B408961ACE9AB5C5EC0261A3008F3364B4064EFC78D91515EC07B1C8393382F4B40AFDB1906314A5EC0557C68F589284B400D5EB1008F025EC0EC054C357D1A4B40D55DB86CC3F65DC010E84C3CEA174B404EECEB3621E55DC044EA0B3271144B40BC26094BD7DF5DC0FAEC8DDC40134B40953ED052BFDA5DC04603BFA1D9114B40C8BC17E1CAD55DC0549112DA1D104B4098B60E7E59D35DC0A493C6EA160F4B4082900D9CEBD05DC060171597EF0D4B40F01C86757FCE5DC0F0ACB519A40C4B4020D28F4813CC5DC00233A2AD300B4B4003D7F156A5C95DC0C9F02A8E91094B40DFCC37E633C75DC0ABD317F7C2074B402C90CF3FBDC45DC0ACE4D924C1054B402193960E49C05DC01B8DC87AA6014B40F602609B72BE5DC02B8FBCAEC7FF4A40030F62201DBB5DC018F6B91D0DFC4A4090641E8E99B95DC00E324A462EFA4A403EB5CB77D5B65DC034134FC965F64A403B05BC7690B55DC0F9150B1079F44A4057C90F5E35B35DC0E479BFF686F04A4036ACEBD31AB25DC03A9D7E837EEE4A400B0B01B100B05DC0083F452247EA4A40D86652C6FBAD5DC0012EF33CD2E54A4091EB2B67FAAB5DC0513F1CA913E14A4070F6139CD8A85DC0B84C193A51D94A40185B07370EA75DC01EAB0DBE81D44A405AE1F5F278A55DC0C84D85E299CF4A40F386B27D15A45DC0C1581C769FCA4A401904F47DE0A25DC00F5CE54298C54A4035E3759AD6A15DC0B0FA0B0C8AC04A408DC709B9F4A05DC03FDD37A97ABB4A402C45ABAA37A05DC00EA0240E70B64A4096B0B5E69C9F5DC03DE09FAD6FB14A40C0203B2A229F5DC016F4650F7FAC4A40C8AFE382C49E5DC0C7B95172A4A74A404A3A4B75549E5DC0221D5C114A9E4A408DDAE4E53B9E5DC0FC03CF68D6994A40A5E512D7399E5DC0EE0A7FFA7E914A40F7883C1E7C9E5DC013454DCFB4864A40B13F620FB09E5DC07BE7A392FF804A407CBBB94CFDA35DC0D16890067B804A40CC90805EEEB05DC0DC4D91A4B0814A40BA17ACF9F8C25DC08CEBDB22CF834A407DDC3FF46DD95DC028C14BACAA864A4095089D9348F25DC0E7B8CA7434894A40827F0A64D40B5EC0F5D9F3AA958A4A408DF17F205B245EC0FC9FF5F9178A4A40DE2AB736333A5EC0E39E887316874A40FE507890DD415EC0A9AA32D411854A4015AAB5AC11435EC04284A3FAD2844A40F1E146819B435EC0F029D9E9D6844A408C038868CC435EC0478E3BA9C2844A4058AC0E6207445EC0250659D3AF844A4007D0F54E50445EC09EB31C2395844A402125676ED4445EC0982D0C395D844A4067531D8E80455EC0FDF5D0880D844A406E4339A51F4A5EC0AC89A96A61814A4093E4A46CDC5E5EC01DD3F485E1754A40C0DFE3362A665EC03865F9F999714A40318C91BA126D5EC0A0C1DE8E7F6C4A40239F75662D735EC0D3FA13E26E674A403999324813785EC06158034C8A624A406331A0422A7D5EC0ACEA1354D25C4A4082799DB5E6805EC060045C64C2584A40AE2DC252B7825EC0D8FDB03C54574A407B921BB610935EC021E1B6FA96414A404517036DC1985EC0089938BA5E3D4A40267E1D06859B5EC027C7FE07663B4A401F972767349E5EC0C90AB41FBB394A40A450BEFEB1A05EC0F302ADF668384A40A791577C0DA35EC0252E544652374A407615240440A55EC0265FB8C4FC364A4080FFCBC129A85EC0E84B671BA8364A40A20EFEB24FAA5EC0313198888D364A40B178EF769AAD5EC0E23B93A4EB364A4071F2E138A0B15EC0BA21EB6217384A408D1108049DB35EC073F769B35D384A4057ACFE867EB55EC0D1B85B4673384A4092D7B2892CB75EC0675D09923F384A40F19E2698EEB85EC03C5F4EA681374A40AF27DD9CECB85EC0D96E65C69A3C4A40888078F916B95EC05375C9AFE0404A4016FB377C88B95EC0A76374A542454A404CF821A55EBA5EC0A774FFE5C7494A404FA8D711B6BC5EC0882A4A3E0E554A40DC7417D020BD5EC0F2D1D35149564A401E9F3DF6B0BD5EC0BB01B92072574A40F85AF77D78BE5EC07BCBBD49A6584A40506CF0CEF5C05EC08C4EB60AA75B4A4048F22887CEC25EC01F1FE132315D4A40183DDEA650C55EC0ED5156CD865E4A40A0F110A258C85EC082625225A75F4A40E27C43DEC2CB5EC0FC66F39491604A4029E381B46BCF5EC091939A8E45614A40A08CB4732FD35EC0BED059A3C2614A4038334D63EAD65EC091EB748608624A40885254C678DA5EC06CB0E20D17624A40C57DD4DEB6DD5EC03092AF2FEE614A4082549BF180E05EC0626F24FC8D614A406F62BE2146E45EC0683BCD4F94604A401E359A4D02E85EC056E22E39335F4A40C149D52CB2EB5EC0FE42F1E18D5D4A40599BA24DE0F25EC0226E090F035A4A40A289296658F65EC03418FADE63584A40CB29DBDEB7F95EC0328020070D574A404C7874D3FBFC5EC0DDDCF2AD21564A40508EC27121005FC0DBECBDFBC4554A40F187C2F825035FC005FD771B1A564A4053BA20018D075FC02D0ED40A81574A40128E74DD1F0C5FC0AE15C9E47D594A4001DD5DB4C3105FC0524FDEDBE45B4A407D86D87C5D155FC03A58CA448A5E4A40B68C470CDD215FC0EE3F416B3E664A400422A7313C255FC0D794866C2B684A40DB0D8A3D07285FC07EE3E7447E694A4085EF9540222A5FC0BFEA11D40B6A4A40F7025A5E8F2E5FC0068937E7EC694A404C8C501D44325FC058901A0303694A40E7401E815E355FC06AFBF3E069674A40FE49C9B7FC375FC0A543ED093D654A40B807B7083D3A5FC0CFD135E297624A409E08F1C63D3C5FC08A75BCB1955F4A4047E669B9F1415FC0A0F83F8770554A40C2C5F22923445FC0C1D7B87809524A40F611E66B12435FC0A86A7B0414454A40C896C20829425FC0C32B7D55213B4A40EB90F1E1EF415FC08F5F0FD4BF354A4087E64A68553F5FC05752F181A4324A401D6B715A133F5FC0F7F30F80322E4A408E10D69E25405FC09133044720294A40559C72B499425FC0AE56EE2E75224A40A56D2BB4C8485FC0A703D1591B1D4A405570028429515FC02EEB3B05B6204A40ECAA4571FE555FC05C776A8CD2274A407A9A51A342575FC0334CE2A65F2E4A4062B0757655595FC0902D659D5F354A4092E9C6020D5C5FC0D5FF0B29AC3C4A40FEEF2C42DA5F5FC01B0E39CE68454A40AD38975DC1625FC0D0DE870B924B4A40295C9F7154665FC0670AF23ADA534A403AF89AAB09675FC015CAB3EB80564A40B14AEE3CD3685FC05A986512E75B4A408F28B4F5F26E5FC04B036C74986B4A40F5A469100F715FC036BAF3C010734A406E38EAF019725FC0455F4D9F4E774A404822D90A7A735FC0D00969D6DE794A403F3E4C4652755FC074541E9F347C4A40D792AFC2C8775FC0069CC7AA4B7E4A404B9ACA0DC07A5FC0656C8EBFED7F4A409FBF953D927E5FC0E5327D85A2804A400091331DB9835FC0C097CC44D3804A40D804E79610975FC087D3FBB150804A4042F2CEB7719D5FC065B0627777804A408F4D54291CA35FC05CC7635620814A40300EC6AEA7A75FC0497EF78D81824A40A59ED1E95EAF5FC0F92D108909864A40820CB6A84AB75FC00CB8901675894A4006D82C7724B95FC032BDD4506C8A4A4054EDA385B0BA5FC048F882509A8B4A406DB74A0131C05FC06D3DECEFB8904A40E51944704CC85FC02944ACB8D0974A40EF7F6C2938CC5FC08D32792A3F9B4A40E785322984CE5FC075593C6E769D4A4040C5E62F8CD55FC0B5715046A0A44A405AFDDD85A4DA5FC02230D0A589A94A403BFBA381DFE25FC01F58B8C8A9B04A40A09748B30EE85FC089B87D867FB54A407B24D03546ED5FC0AB17461710BB4A40EEE6121743F25FC0E29D49DB79C14A402476714C63F55FC0D8202C3D9CC64A406CF734BF0AF05FC0B900E4172ACC4A40824E4E2C7FE65FC088454C20E0D44A401486B3B47DE25FC006F9A8BFE5D84A40F1AB25A508E05FC0AF7F53BA88DB4A400B9EDE5E7CDE5FC0D7D042BDEEDC4A407B3A5501F9DC5FC070472AC89BDD4A4097ADEA4F5DDB5FC07A8766DDD1DD4A4080D85D80ADD95FC09542F341ABDD4A408AE25CC3EDD75FC0A917F73C42DD4A40D036107178D25FC00793DE9B7FDB4A40F92CB846A2D05FC0A87757E213DB4A40039B4CA5D0CE5FC099FFD842E9DA4A405247AF8907CD5FC0A463CA111ADB4A402FEA8EF08DC85FC0B1A7FA7F5FDC4A40B42F54D287C35FC09F2878EA10DE4A40658586A1B9BE5FC00D7BC9C4ECDF4A400386841B19BA5FC0D265AE1FE6E14A40BE8C1F8E93A85FC0E89F2CB5EDE94A4003C87D7F3EA45FC094F2F67AB6EB4A402923C322DA9F5FC0721CADF64DED4A4069E69F655C9B5FC0716B41D9A6EE4A40804D105479985FC037CABB234BEF4A4012579400A6965FC0185AEE1C65EF4A403768EF8507955FC0BEB10DC03CEF4A40D6466AFB6B8F5FC088EC6908D0ED4A4099849002F08D5FC0A50C68E3B4ED4A40497C97DF4C8C5FC0F33E3E3CE1ED4A4014647BED388B5FC0B6C3C126EBEC4A404D07EF60C7895FC0B93036DB02EC4A400FE8756F83885FC078D128F487EB4A408F49BE3434875FC0B5C64FA67AEA4A40AD8BF47AC2855FC0A40203FF83E94A4075708651FB825FC0B2C971BE0BE84A40E8E1D24EAD815FC096DC53C75AE74A40D57F92AC89805FC0F4F4C4058BE64A400515BD2D767F5FC09AC852EA21E64A4051C94F80447E5FC0BC30603FA5E54A405DE9946C737D5FC0345B45AA62E54A40F6AAB835E87C5FC00DFB84AC5AE54A401BB8F5840F7C5FC0526F934A8FE54A40E76F0658287B5FC028EACAA177E54A4041D43297297A5FC0CE4B3A1061E54A40DAFD90590A795FC0C70BF1EC9FE54A4087AD8CCE79785FC034D52ED1FAE54A40C808F807C0775FC02271958306E74A40E6CBF18E75775FC094ADDBDFF7E74A40C627B5613F775FC046F41B3135E94A4070A097BC67775FC0D16FCDAFCBEB4A40AD2014617A775FC0810DA68C41ED4A4065CB959E8E775FC0FA345537E4EE4A4078382CE276775FC05E97310D3CF04A40C5E773DD03775FC0F23FA74F4BF14A40D693496A51765FC0A19829AEDFF14A40A29CDFF049755FC0B9DCBD569DF24A40CF1F808BEA735FC00EC135C80FF34A402E0B5CB6D9715FC01CE3B4558AF34A403E4AE18CAD705FC047CA9827C2F34A40A900C0513B6F5FC0827ABD0E19F44A4059554737676D5FC04B04F22AC8F44A402A471B05CA6B5FC003AD08B176F54A4088701C013C6A5FC01EB9CE4A0DF64A40796AC1F2056A5FC0143B5689B0F64A40C0D7000E246A5FC0A5AFB0037AF74A40A4EA74E0756A5FC01C064A3E10F84A409D92E047F56A5FC0FC20437D6CF84A4034023161646C5FC094B478E818F94A405C504A6F466D5FC0D0E887B431F94A40FB7688FAC26F5FC093A595B276F94A40FF726C07D3715FC0AF32B5A4A5F94A40D5C3DA1321735FC03203B10DE3F94A402623A10CD9735FC0C3EC0272E8F94A401640A0DA0C755FC042DA8EFCD9F94A40114AAC79BC765FC085EAA28FB7F94A4032595722FB775FC0AB8630608CF94A40469B5D5A30795FC00965B77AA7F94A4051F9346BB97A5FC08C0ACC63DAF94A407019D721207B5FC0F8B87365B2F94A407DFD92F3887B5FC00AB991537CF94A40BE3749B3BC7C5FC0FFF3B7406DF94A40D5A3314E787E5FC0E16A855C50F94A4024F807889D7F5FC0062E09B39CF94A4004375F8126805FC0F8BD7DB252FA4A4021AEA8634C805FC035052A9B37FB4A4076B28A620E805FC01469837E36FC4A4082D59AB21A7F5FC0DDD9DA86CEFC4A40EA4097A6287E5FC01ED4EC84EFFC4A402FC19F9DF87A5FC07B437B893AFD4A404C8EC0A318795FC07E10E0C74AFD4A406C84C49874775FC04D67A2E96CFD4A4009054FAAA3765FC04338CDC0F4FD4A404665EBC14C765FC08917E68437FE4A40456B083833765FC076C929E591FE4A407798AA2943765FC02ED20F95FDFE4A407F183B7351765FC0DB061D5B50FF4A40F3E42E8B6F765FC049D37E589FFF4A400A51EBF55A765FC03705A7A086004B40C368D8D03B765FC015772B77A4014B4006464A7D24765FC0135D330C7C024B40A33B2C6025765FC016FB39C351034B40CFE56C9318765FC0D08D073DF6034B408116AA0A06765FC0466698C96A044B4066646191DA755FC02C80CC77D4044B405AE3A6FB38755FC00E28CE27ED044B401F2D92393F745FC0D4EF74D8EC044B402C5FDDF0BA735FC0C7D314E803054B409CE3192B20735FC081550EFF1B054B400B08869B6F725FC049B4297AE5044B4085EF0302B6715FC05F06BC387F044B401D86CD6833715FC0B02EFCD24D044B401E92D97499705FC02746433827044B400D911A4EE36E5FC0CDEB6A7EE4034B40C5ED5391CD6D5FC0BDCB235FD6034B4036E9C02BB36C5FC0E59EB76498034B40198C0CD0386C5FC07D4DF07466034B40C4661D82DA6B5FC0221FBB9D4A034B4001B9FEFA316B5FC04673BBDE73034B40A56C834FBF6A5FC07D9D7ABD71034B4096E6218B146A5FC0970BAA2955034B403A37EF9E8E695FC0FBE7D4C353034B40B8903EAED3685FC0406341BA7D034B407B6F51B873675FC0D968CFA87E034B40C95A6CDF67665FC07A34AC9974034B401C18221790655FC0A131175C57034B40C5120B7709655FC0B04D615023034B400BD4E3CF2A645FC0138D283126024B4054A042FCE6635FC01687B033B9014B400428538D94635FC0AC27A91520014B40BE4E6A9C14635FC082183D9D75004B40248EE5D4CD625FC0A986DC0521004B40DA8A798C7F625FC02720672DCBFF4A40266C8B1CF2615FC03E69E8CE7CFF4A404171E1643A615FC0D5481C0000FF4A40A0DCA590CF605FC0DDAA7551ABFE4A4021C8EA6E83605FC0410946399BFE4A40F553EA5023605FC038EABF699AFE4A4036D4C9A39F5F5FC071B8998DA4FE4A4030FC2E6BEF5E5FC03A5E450CDCFE4A4044205FA4605E5FC0C587B9A32CFF4A407E0E0B06FD5D5FC067A8541385FF4A4027CE90C8975D5FC011C2C7BBCAFF4A403144F505DC5C5FC02BD00A1C1D004B40F3DE4A59465C5FC07EBA9BCE55004B40D425E70B925B5FC0FF141402A8004B4062247EB13A5B5FC0974B1568BC004B4088B813CE695A5FC09F1915D4F9004B40CB0E7B9BE7595FC0D2EE815312014B409EFE70D862595FC0453B69EA40014B405B339DE70F595FC01B99952261014B40182643E1A2585FC07EB77E4093014B405E805B414C585FC04062FB0EC2014B40AE1F99DC1C585FC0D71B87C3FD014B40AE9385C20A585FC0D3A1DB6750024B40C91B2F88F8575FC02358F084E6024B408A8F2323D5575FC0750A89AEA8034B40B06BBD36BC575FC0E39C90B811044B40B45C6CC625565FC07E9B1A9AA3054B40345EC64E694E5FC06A1C7812FE0F4B4067F20F69DE465FC094585CEE891D4B406F7815891B425FC0522761D9AC274B40E08E885D8A405FC02B9BE5CC4A2A4B404ED9CC2E3C3F5FC060132BB64D2D4B4042EA64FD343E5FC0149AD0A99A304B40EF8CA2D1783D5FC0AAEF758316344B40EF2288BB0B3D5FC0BCD2DBF6A5374B40F0D081D1F13C5FC0A809B69D2D3B4B4003FD102E2F3D5FC046B92002923E4B40F6DD792C6C3D5FC0A69915D7D33F4B40	523	2442	10254	839	0103000020E610000001000000050000002476714C63F55FC0A703D1591B1D4A402476714C63F55FC00EB93A7C799F4B40A5E512D7399E5DC00EB93A7C799F4B40A5E512D7399E5DC0A703D1591B1D4A402476714C63F55FC0A703D1591B1D4A40	
23	Łingít	RGB(255, 255, 144)		Tlingit,Inland Tlingit	3		0103000020E610000001000000B6010000F1B73D41627960C0D46531B1F9C24D40758F6CAE1A7860C011E4A08499C44D404DF910548D7260C0130A117008CB4D40FDBE7FF3627160C045D4449F8FCC4D40F1129CFA407060C0826F9A3E3BCE4D40AAB9DC60286F60C0C40776FC17D04D40E84CDA54DD6E60C02A745E6397D04D40EA961DE29F6E60C0DF6A9DB81CD14D40D619DF17976D60C090F63FC05AD34D406551D845516D60C0A8FFACF9F1D34D402A013109176D60C0478D093197D44D400D6D0036206C60C00B5F5FEB52D74D4014252191366B60C037FFAF3A72DA4D408448861C5B6A60C0F31DFCC401DE4D408DB454DE8E6960C03AE7A7380EE24D402D25CB49A86860C012BEF73768E74D40CB863595C56760C0AD84EE9238ED4D406B6281AFE86660C030D7A20568F34D4079245E9ECE6560C020EF552B13FC4D407D586FD48A6560C033535A7F4BFE4D40F14927124C6460C08F368E588B094E40514B732B046360C0F261F6B2ED164E4055DD239B2B6260C03145B9347E214E40ECD973991A6160C048E17A14AE314E40180AD80E466060C0B8567BD80B414E40569A9482EE5F60C09D2B4A09C1484E40E1D05B3CBC5F60C0CBDAA6785C4E4E40C32CB4739A5F60C088D68A36C7534E4018D2E1218C5F60C06FD40AD3F7584E40D8817346945F60C0490ED8D5E45D4E40C21550A8A75F60C04C1B0E4B03614E4030478FDFDB5F60C0BDFBE3BD6A654E40B9C7D2872E6060C0E222F77475694E4077BB5E9AA26060C09335EA211A6D4E407104A9143B6160C09C6D6E4C4F704E40F14A92E7FA6160C006F4C29D0B734E40280CCA349A6460C05FEB5223F4794E40E2067C7E186660C0BAF59A1E147E4E40AF06280DB56760C0124BCADDE7824E401B84B9DDCB6860C0BCCADAA678864E4046ED7E15606A60C05308E412478C4E403E5DDDB1586B60C005C24EB16A904E40C0232A54376C60C099D6A6B1BD944E40425F7AFBF36C60C0B9FE5D9F39994E4068B27F9E866D60C03E7782FDD79D4E4042E90B21E76D60C0037D224F92A24E405EBA490C026E60C0B1C398F4F7A44E400533A6600D6E60C0E04C4C1762A74E401497E315086E60C0D7F84CF6CFA94E404FE8F527F16D60C03EB0E3BF40AC4E40946A9F8EC76D60C0ECDFF599B3AE4E40D7A3703D8A6D60C0B6F468AA27B14E40DD955D30386D60C01553E9279CB34E40A7E7DD58D06C60C03F70952710B64E400A48FB1F606C60C0054EB6813BB84E4046D1031F036F60C0F5143944DCBC4E4007EBFF1CE66F60C03E3C4B9011BE4E40611C5C3A667160C0732CEFAA07C04E40B5DE6FB4E37260C02158552FBFC14E409B3DD00A8C7460C0BB48A12C7CC34E404EB9C2BB5C7660C0588E90813CC54E40100874266D7A60C075CC79C6BEC84E4041D5E8D5007F60C00F0F61FC34CC4E402F336C94758160C049DA8D3EE6CD4E4027DBC01DA88660C0977329AE2AD14E4046D3D9C9608960C04ED53DB2B9D24E40289EB305048F60C0ABED26F8A6D54E405F27F565E99160C035272F3201D74E40C0EAC891CE9760C007616EF772D94E40BDE3141DC99A60C0A357039486DA4E40747E8AE3C0A060C05BCF108E59DC4E4048A5D8D1B8A360C00D36751E15DD4E404963B48EAAA660C0889CBE9EAFDD4E40BB0F406A93A960C099F5622827DE4E40C6BFCFB870AC60C07AA702EE79DE4E40BCEB6CC83FAF60C00A100533A6DE4E40E90B21E7FDB160C0B519A721AADE4E4092770E65A8B460C0289EB30584DE4E4005A73E903CB760C09F03CB1132DE4E4084F1D3B8B7B960C0F8A75489B2DD4E4053AEF02E17BC60C0B1E07EC003DD4E40A913D04458BE60C07787140324DC4E40B41CE8A1B6BF60C05B0C1EA67DDB4E40A019C407F6C660C09E0B23BDA8D74E40B69E211C33D060C0D882DE1B43D24E402C4833164DD960C0BE6C3B6D8DCC4E401A51DA1B7CD860C094A12AA6D2C94E409E42AED4B3D760C04B77D7D990C74E40E50E9BC8CCD660C0834F73F222C54E4041F0F8F6AED460C071FF91E9D0BF4E408E76DCF03BD260C0211D1EC2F8B94E4094A46B26DFC960C0062AE3DF67A64E40850B7904B7C560C0F661BD512B9C4E408B389D642BC360C0BB5F05F86E954E40BF1072DEFFC160C0F4DC425722924E40EC4B361EECBF60C02849D74CBE8B4E40BAA46ABB09BF60C0309FAC18AE884E40EEE9EA8E45BE60C0D1CDFE40B9854E4006483481A2BD60C06284F068E3824E40AC6F607223BD60C0CAFE791A30804E405C8DEC4ACBBC60C05FECBDF8A27D4E409EEE3CF19CBC60C00989B48D3F7B4E401C446B459BBC60C0AE10566309794E4046990D32C9BC60C0D4B6611404774E40AF5C6F9B29BD60C021C8410933754E40B0575870BFBD60C04CFC51D499734E40A053909F8DBE60C0F99FFCDD3B724E40F7E978CCC0BC60C07C8159A1486B4E40ECDD1FEF55BA60C01B800D8810634E40BE89213999B760C00E4FAF94655A4E40CCEF3499F1B060C0D369DD06B5454E40FD31AD4D63AE60C09A6038D7303D4E40B3B5BE48E8AC60C0A31F0DA7CC374E40A9D903AD40AC60C06DC9AA0837354E406ABFB51325AB60C0DD5CFC6D4F304E4056EF703BB4AA60C0522635B4012E4E400F29064834AA60C00E828E56B52A4E4047C8409EDDA960C06FD921FE61274E40425DA45096A960C0041BD7BFEB234E40183F8D7B73A960C0A31D37FC6E204E402A0307B474A960C0672AC423F11C4E40E2ADF36F97A960C04DD9E90775194E408BE07F2BD9A960C08446B071FD154E403DB83B6B37AA60C0AC014A438D124E40D6AC33BEAFAA60C022AB5B3D270F4E4003B2D7BB3FAB60C0B456B439CE0B4E405B79C9FFE4AB60C0C2A4F8F884084E405051F52B9DAC60C0BAA0BE654E054E402504ABEA65AD60C0CB660E492D024E40103B53E83CAE60C02313F06B24FF4D40191BBAD91FAF60C0022D5DC136FC4D405F0B7A6F0CB060C0C554FA0967F94D40A16AF46A00B160C0DD955D30B8F64D408E3BA583F5B260C0E7AA798EC8F14D4098BD6C3BEDB460C0486DE2E47EED4D40570740DCD5B660C00DC51D6FF2E94D400FED6305BFB760C050E09D7C7AE84D40344A97FEA5BB60C08DD0CFD4EBE24D4083177D05E9BC60C0195932C7F2E04D40541B9C88FEBE60C05C1D007157DD4D40EF1CCA5095C060C05DC30C8D27DA4D40FED2A23EC9C160C05BE9B5D958D74D405473B9C1D0C360C09CC0745AB7D14D403F390A1085C460C0304AD05FE8CF4D403CDC0E0D8BC560C01A6D5512D9CD4D40C4B0C398F4C660C03868AF3E1ECC4D40C1ADBB79AAC760C0734BAB2171CB4D40EBE6E26F7BC860C005DEC9A7C7CA4D405DFE43FA6DCA60C07098689082C94D40B058C345EEDC60C07590D78349C14D40D9B27C5D86DF60C0179AEB34D2CA4D40290989B40DE160C09626A5A0DBCF4D40BA6B09F9A0E260C0C1E44691B5D44D405D177E703EE460C0813E912749D94D405C936E4BE4E560C0BF9D44847FDD4D40ECFB709090E760C0F0F8F6AE41E14D40027E8D2441E960C01CD3139678E44D400C91D3D7F3EA60C047AF06280DE74D40F8174163A6EC60C0D7187442E8E84D40DA58897956EE60C0601F9DBAF2E94D40CC423BA7D9EF60C057B5A4A31CEA4D4098FA795311F060C0CAA7C7B60CEA4D407D5D86FF74F160C0821ABE8575E94D40A8AB3B165BF360C0B07092E68FE74D40A5D8D138D4F560C0DCB8C5FCDCE44D409FE3A3C519F760C0B6679604A8E34D404FE5B4A764F860C0F8DEDFA0BDE24D40A568E55EE0F860C0B81D1A16A3E24D40C479388169F960C0C8B1F50CE1E24D4032E4D87A06FA60C09E29745E63E34D408D0DDDEC0FFD60C09487855AD3E64D40048F6FEF9AFD60C01A34F44F70E74D4094347F4CEBFD60C0EF1AF4A5B7E74D405C001AA5CBFE60C0AD4CF8A57EE84D40B63176C24BFF60C0FCA71B28F0E84D4083F92B64AEFF60C0ACC5A70018E94D40A4A833F7900061C02A37514B73E94D40BE6C3B6D0D0161C0C93A1C5DA5E94D40973B33C1700161C0A741D13C80E94D40035C902D4B0261C05F96766A2EE94D409E3F6D54A70261C0B8567BD80BE94D402577D844E60661C0D8D64FFF59E34D406FD8B628330D61C07460394206DE4D400D1D3BA8C41361C08A5B0531D0DB4D403FE08101841A61C0F0FB372F4EDC4D40FB05BB615B2161C088BB7A1519DF4D403E7958A8352861C080492A53CCE34D402497FF90FE2E61C0D925AAB706EA4D4012C2A38DA33561C0B70A62A06BF14D40EF022505163C61C0B7CF2A33A5F94D40668522DD4F4261C0ACAA97DF69024E404030478FDF4761C0D316D7F84C0A4E402E90A0F8B14C61C05E10919A76114E408638D6C56D5461C0B8E68EFE971D4E40D8F15F20085761C0FE2B2B4D4A214E40B874CC79466061C03A9677D5032E4E40F4DF83D7AE6261C07F349C3237314E405FB532E1176561C06D1D1CEC4D344E40AE80423D7D6761C0CB694FC939374E406072A3C8DA6961C0E7012CF2EB394E4096B20C712C6C61C0B0C56E9F553C4E409EEDD11B6E6E61C0779D0DF9673E4E408D2AC3B89B7061C02B69C53714404E4099D36531B17261C08C84B69C4B414E40FC523F6FAA7461C089CF9D60FF414E40E1F1ED5D837661C0E3A59BC420424E4002F566D4FC7461C0992D5915E1F64D408B8BA372137561C0DC847B65DEEC4D40394371C71B7661C0E59CD843FBE04D4008759142D97861C0999A046F48D74D40B003E78CA87B61C0DBA7E33103CF4D40630D17B9A77B61C09D0FCF1264C44D4093AAED26787161C0F5BA4560ACB54D4018B49080D16861C05D5320B3B3AA4D40DC0F7860005561C0384E0AF31E914D40FD4CBD6E914461C0FAB660A92E7E4D40DF1AD82A413E61C0624D6551D8634D402C634337FB3561C0B1886187314F4D4099D711876C3461C0E46A64575A4C4D403C50A73CBA2361C07D5C1B2AC6314D400327DBC09D1B61C06BD3D85E0B284D405CAAD216D71661C0C2FBAA5CA81C4D4062BD512B4C1561C0D714C8EC2C1A4D40EB3A5453121261C0F06B2409C2094D40670E492D941261C068976F7D58F54C40B4B0A71DFE0E61C0313F373465ED4C40F5471806AC0761C0D576137CD3D44C409279E40F860661C0315F5E807DD04C40F2B6D26B330161C0F5DBD78173C24C40C617EDF1C2FB60C05E2EE23B31A94C40709692E5A4FA60C0382C0DFCA8984C40CD018239FAFA60C0C80C54C6BF8B4C402121CA17B4FB60C0D9278062647F4C4081CEA44DD5F760C0DD9A745B22794C40B0AD9FFEB3F260C06EF7729F1C714C40183F8D7BF3EC60C0B4CC22145B634C4072A3C85A43E460C09BE447FC8A4D4C406458C51B19E260C0670B08AD87434C401EC022BF7EDE60C0E2CAD93BA3314C4046EBA86A02DA60C0836A8313D11D4C40EA944737C2D660C06684B70721164C4073D53C4764CB60C0D7A6B1BD16F24B4059130B7C45CB60C0259012BBB6EB4B4034A2B43778B960C09548A29751BA4B405EDA70589AB560C0DFA815A6EFA34B40BB473657CDB360C00C790437529E4B409293895B05AC60C00341800C1D8B4B40D4B7CCE9B2A760C086FF7403059A4B40EF1D352644A660C0BE892139999E4B403CC1FEEBDCA460C00E4E44BFB6A24B40D1E7A38CB8A160C01590F63FC0AA4B4046459C4E329760C0F8A92A3410C54B409E978A8DF99360C0622F14B01DCC4B403B56293D539260C0272EC72B10CF4B40B70A62A0EB9060C0A165DD3F16D24B409599D2FADB8F60C01497E31588D44B40596ABDDFE88E60C0C45DBD8A8CD64B40F8E28BF6F88D60C008AD872F13D74B40EE06D15AD18B60C0C7F0D8CF62D94B40B54E5C8E578960C021938C9C85D54B40CEFDD5E33E8860C0DF52CE177BCB4B40B3B794F3458560C04F029B73F0C44B4090BFB4A84F8260C0942F682101BB4B402A58E36CBA8060C0959F54FB74B24B407D96E7C15D7E60C0022CF2EB87A64B4063EDEF6C8F7C60C0EA7AA2EBC2994B40331B6492117B60C0CE8B135FED8E4B40A69C2FF65E7760C0632827DA55784B405723BBD2327760C021E527D53E6B4B40876BB5873D7560C065170CAEB95F4B40E44D7E8B4E7460C06CCD565EF2594B40C18BBE82B47360C03354C554FA554B40BFF4F6E7A27060C09B5775560B524B40D6E6FF55476D60C050FD834886524B4069E21DE0496760C0B08EE3874A534B4052B648DA0D5F60C014083BC5AA534B40159161156F5A60C09752978C63544B4079E92631885760C056B77A4E7A554B40F085C954C15560C007793D9814594B403AB187F6B15460C00514EAE9235E4B4097AC8A70935460C00C23BDA8DD614B4090F63FC05A5460C0E9465854C4634B40B51A12F7D85260C05709168733654B40C5FEB27BF25160C0508A56EE05664B40CADC7C233A5160C096253ACB2C684B407B87DBA1615060C036AE7FD7676A4B40132A38BC205060C0FB40F2CEA16A4B40126745D4C44F60C01074B4AA256B4B406405BF0D314F60C0056C0723F66B4B40E73922DFA54D60C07097FDBAD36F4B40C556D0B4444A60C09BE447FC8A774B40876C205D6C4660C04640852348874B40FC8C0B07424460C0910F7A36AB944B401BD7BFEBB34260C0B3075A81219B4B40E5ED08A7854160C0923CD7F7E19E4B402A0307B4744060C0DE718A8EE4A04B40A1F831E6AE3F60C0C85D8429CAA34B40882D3D9A6A3F60C0429605137FA64B404BAC8C463E4060C02A70B20DDCA94B40EE3D5C72DC4060C0DA20938C9CAD4B408EACFC32184160C09CC3B5DAC3B04B400A100533264160C0840D4FAF94B54B406745D4449F4160C04F1F813FFCB84B4058552FBFD34160C061C43E0114BB4B40A7052FFA8A4260C04F3C670B08BF4B4039D21918F94260C0D66EBBD05CC34B40FFE6C5892F4460C022E3512AE1C94B403561FBC9184460C03AEB538EC9CE4B409294F430B44360C0E2E47E87A2D24B40C4B29943D24360C014CC988235D64B4052499D80264460C0D4EFC2D66CD94B40EDB776A2A44460C01E37FC6EBADB4B40C26D6DE1F94460C010CF126404DE4B40B8ACC266004560C02BA5677A89DF4B4011FC6F25BB4460C0B87361A417E14B407A8D5DA27A4460C0113AE8120EE34B406E6B0BCF4B4460C037397CD289E44B40BE2EC37FBA4360C0E161DA37F7E54B406DE7FBA9714260C033FB3C4679EA4B400C789961A34160C08D7DC9C683ED4B40E00F3FFF3D4160C0A629029CDEEF4B40DB17D00BF74060C04791B58652F14B406361889CBE4060C0FD497CEE04F34B40F5BA4560AC4060C0D9AF3BDD79F44B40A7583508F34060C04B051555BFF64B406116DA394D4160C00E828E56B5F84B40E0DA8992904160C0A0E238F06AFB4B405F5CAAD2164260C0C619C39CA0FF4B40F148BC3C9D4260C0A0A86C5853034C40E4326E6AA04360C04774CFBA46094C4048348122164460C0B62DCA6C900B4C4047567E198C4460C044183F8D7B0D4C409415C3D5014560C0C8258E3C100F4C40B16A10E6764560C0EBC37AA356104C40FFEA71DFEA4560C0984F560C57114C40DC2BF3565D4660C046B247A819124C406D1D1CECCD4660C0814067D2A6124C40F9122A383C4760C062DBA2CC06134C4092CA1473104860C06F0D6C9560134C403AB2F2CBE04960C07FF964C570134C401D0071572F4A60C07F8461C092134C401C60E63B784A60C011C30E63D2134C4041800C1DBB4A60C07E1AF7E637144C40990E9D9EF74A60C050DF32A7CB144C4030B951642D4B60C042EA76F695154C40DE567A6DB64B60C09C31CC09DA184C403B38D89B184C60C09BC937DBDC1A4C4058E36C3A824C60C031074147AB1C4C407EAB75E2F24C60C05891D101491E4C40E7C2482F6A4D60C0D78A36C7B91F4C40C53A55BEE74D60C04792205C01214C4022C154336B4E60C04146408523224C403067B62BF44E60C02FC1A90F24234C407EA99F37155060C08A75AA7CCF244C40938D075BEC5060C0D11E2FA4C3254C406C94F59B895260C0EE3F321D3A274C40A112D7312E5560C04A27124C35294C4036785F958B5660C0CEDE196D552A4C409F211CB3EC5760C05648F949B52B4C40789961A3AC5A60C0A6B8AAECBB2E4C40C687D9CB365E60C0D09A1F7F69314C4086747808636160C09D103AE812344C40CC441152376460C0E21E4B1FBA364C409AD2FA5B826560C082C7B7770D384C40F4531C07DE6760C009C556D0B43A4C40D82AC1E2F06960C0172AFF5A5E3D4C4085E97B0DC16B60C05F251FBB0B404C40DB19A6B6546D60C02272FA7ABE424C4066BD18CA096E60C05EDA70581A444C40554E7B4A4E6F60C0E54526E0D7464C40EDD5C743DF6F60C0F4160FEF39484C40BC5CC477E27060C09293895B054B4C40E4D70FB1C17160C066A208A9DB4D4C40ABB019E0827260C05DA45016BE504C40A837A3E62B7360C0240B98C0AD534C401FD61BB5C27360C0C6504EB4AB564C40187783682D7660C02D944C4EED644C40669FC728CF7660C04BAFCDC64A684C4085B18520877760C0342BDB87BC6B4C40D1CB28965B7860C0F581E49D436F4C4082A966D6527960C028BA2EFCE0724C40E947C329737A60C0C5E2378595764C40CF66D5E7EA7A60C0B9A5D590B8794C4021938C9C057B60C0E8DD5850187A4C4010B056ED1A7B60C0E97E4E417E7A4C402AC93A1C5D7B60C01DAD6A49477B4C403788D68A367D60C0D1AE42CA4F804C40DBFD2AC0F77D60C0FFCD8B135F814C409E5F94A0BF7E60C05645B8C9A8824C4048179B568A7F60C007EA944737844C40868F8829118060C08D43FD2E6C854C40CB129D65968060C0E107E753C7864C40765089EB188160C0153AAFB14B884C40E388B5F8948460C0D044D8F0F4944C40DBA337DCC78860C079793A5794A44C401EC3633F8B8C60C019761893FEB24C400E846401938F60C0DD60A8C30ABF4C40AC8BDB68809260C0F8510DFB3DCB4C4087C3D2C08F9460C0E2B19FC552D44C407D91D096739660C0BA66F2CD36DD4C40D8B8FE5D1F9860C0EBFF1CE6CBE54C4053AEF02E179960C09966BAD749EB4C40930035B5EC9960C088F71C588EF04C401553E9279C9A60C086A92D7590F54C4081B3942CA79B60C0598B4F0130FE4C404B5AF10D859C60C035B56CAD2F044D40DE91B1DAFC9C60C047CCECF318074D4097FF907EFB9D60C0C39D0B23BD0C4D401EE0490B979F60C064C91CCBBB144D40A5A1462149A160C08201840F251C4D40FC34EECD6FA260C00FD3BEB9BF204D4072FBE59395A360C0D828EB3713254D40850662D9CCA560C05F97E13FDD2C4D40AA0EB9196EA960C033FAD170CA384D40CEC4742156AA60C09DB98784EF3B4D4078B7B244E7AA60C0E8A221E3513E4D4009151C5E10AB60C00F0BB5A6793F4D409D9D0C8E12AB60C0823CBB7CEB3F4D400CC9C9C42DAB60C015A930B610404D404A99D4D086A960C0A08B868C47434D401711C5E40DA860C02E8F352383464D40530438BD8BA660C0817C09151C4A4D4091459A7807A560C013B69F8CF14D4D40D9EDB3CACCA260C0B33F506EDB534D40A80183A44F9E60C00D8AE6012C604D40D1B1834A5C9B60C07DB3CD8DE9674D404E64E602979960C016F88A6EBD6C4D40FE60E0B9F79760C079CE16105A714D40CFD72C970D9660C0747ADE8D05774D403FC8B260628F60C085B69C4B718B4D4097E5EB327C8B60C06326512FF8964D40C092AB587C8060C08F19A88C7FB54D40F3AB3940307F60C0A2B437F8C2B84D40AD3594DA8B7E60C04FCAA48636BA4D4085CFD6C1417D60C08080B56AD7BC4D404C18CDCAF67B60C0ABAE433525BF4D40617138F3AB7A60C08A9125732CC14D40F1B73D41627960C0D46531B1F9C24D40	0	3	300	1	0103000020E61000000100000005000000B003E78CA87B61C09B5775560B524B40B003E78CA87B61C0B519A721AADE4E40882D3D9A6A3F60C0B519A721AADE4E40882D3D9A6A3F60C09B5775560B524B40B003E78CA87B61C09B5775560B524B40	
16	Nedut’en /  Witsuwit'en	RGB(0, 244, 112)		Babine,Lake Babine,Nat’oot’en ,Nadot’en,Wet'suwet'en,Babine-Witsuwit'en,Bulkley Valley/Lakes District Language	2		0103000020E6100000010000004D0100004948F9BDB1DE5FC0F81C7867E17A4B407E9E90F632DE5FC0C593DC488F884B405FAC77D182E15FC092E94ED2E6914B40EA3A8C72CAE55FC0E72E0080C5984B40B87F44C3BAE75FC01AC50243F69C4B40FFE7EFDC6AE85FC072631D5AA79F4B40E25D76F239E85FC0BE6C4B945EA04B40858077F106E85FC096E566E57DA04B40A07AB4B2BBE75FC024EA6115A7A04B40AABDE7785CE75FC0EFDDD419DFA04B40FF71E4A13AE75FC0317202C3E4A04B401F0D69A3F4E65FC0C63E171CACA04B408888A42BE6E65FC0C4A524C5A5A04B40ECC7C234B0E65FC0B8D256C3B3A04B40FDE8CFA9A3E65FC038D5F005D8A04B40FE963781A5E65FC08DFAC6441DA14B4023251DF7A6E65FC005175D4F36A14B401A7DF74599E65FC0B2430D2050A14B40671728D08EE65FC0115E16487CA14B40144CB649A9E65FC0D83EABA7B2A14B40A0EA4E36C8E65FC0D9D97602F1A14B40FD0558EEE0E65FC03568F1777DA24B40D1F64B908EE65FC091917891A7A24B405B622B40F1E55FC00930B8F2F7A24B40B805AC6B8FE15FC05C023F86B2A34B40919AD4431ADB5FC0F571A7F11CA34B4072E00C9904D25FC02B4A2CDDF8A44B4043F45EDEFACD5FC089C0AD88C8A84B4031E40997DACD5FC0C979398FDBAE4B40AA86D6C805D25FC001EF1C3FFCB94B40B1D878CA78D75FC0F4DF4B171BC74B40980ECDABD3DC5FC0DF37E03F00D64B40DACBB783B2E05FC08A060A5276E64B40E7C87E2CACE15FC0B57CBA7949F84B40033D0F4551DE5FC07979A854450B4C408EF6318EF8DB5FC0E5D7632B33124C4079D68BECD5DB5FC0945E2A5700174C40BFAC7504C2DB5FC01536933DE61E4C40AB374AFBD1DB5FC0847913560C234C40990D2A2CFEDB5FC0939C6028D1264C40CB9735D34EDC5FC03A61551ED2294C403127A8F019DD5FC0080FFE31AC2C4C40BDED46338CE05FC02964AB321A364C4065E44B51DCE15FC08B1C3CDEE13A4C4087A450C94DE25FC030F103AF6D3F4C40635841A16DE15FC05B2E2B6588434C40866ED0B5C8DE5FC0CB54CF62FC464C40BE24960CECD95FC0220FB73B93494C4042FCE22E1BD15FC05B3BBADE564B4C407B5308BA60D05FC01F59624E5C494C40FE8833382FCF5FC0CC0DA14787464C4073221B91A4CD5FC0879CA63920434C403553825DD6C85FC02F0A30F3133C4C406B9552E0A9C35FC048047D4AE9324C409CDE3EC96FBD5FC0DC107B2979274C40F748C8A823B75FC0FC4BD9C85B1C4C409D42BB730FB25FC050C6AB08CF114C40FDA78BD439AB5FC0C6295AC476084C405F56230337A65FC0235E0F22F8FF4B40A87D269938A35FC0A4904B0E8AFA4B403A535B96589F5FC04C0F4B02F0F44B40EEB0165267985FC0DB500AE2BFE84B40D0864D91B7925FC0C36F4F61ABE24B4040C8B3B1C98C5FC0D2667373F5DB4B406A4C0062AD875FC05D048888CED54B4065E4E8104C835FC0E374B4942CD04B40F12C3F718F7F5FC02D22BF5605CB4B40E8D5FC6F617C5FC0649DD2614EC64B40B1045A2BAC795FC0DEA9F625FDC14B402CD7EDEA59775FC032614AF706BE4B404117D1F040705FC077B47FB1E4B04B40C6E3D1F99B6E5FC0F0DB564413AE4B40FA0B8B3A946B5FC01A25571CA7A34B409398D997026B5FC0B439A4C3D9984B400F431FA8576A5FC04438BC28FE8A4B40792F4200F0695FC04B10F65AC57E4B40EAD6EF6925685FC090394738C9734B407A3CECD209665FC09B9AF265646A4B407C0F0D91D2635FC04379E714075C4B4030A81019BA615FC03432C0D656564B4039AF295389605FC0FC7C272C99524B406867D0CD505F5FC0B4305E13464F4B4015E46B42925E5FC0119BAF28DD4C4B406E353C49185E5FC0DEB0C697E54B4B40CE737641C45D5FC01BEC2719644B4B407E215E3AD95C5FC02A4ACB09324B4B403A57D509275B5FC007F15E79234B4B40E5996F3DD0585FC0EB7611B6364B4B4089747E3EAE565FC0FE12C521BD4A4B40CDACB93879545FC064691FD8924A4B40F7C9F52C8F535FC0A8359440604A4B404AFC7475EC525FC0A1B45C6E8E4A4B40ABB8E09D84525FC0AA5FFA76CC4A4B40AA9C446DA4515FC067ADA7924F4B4B403A277173DD505FC0C74D6050774B4B4090C7D7A335505FC00B825D64504B4B40D84BDBE6F54F5FC01E15C8EFF14A4B40BF2F05C05A505FC0431ABA58464A4B40E2160FB365505FC0A6A0315F77494B40172E862421505FC028871BEB32494B404EC98EBF854F5FC0FE5739B138494B406A087234A24E5FC08E015A1A41494B403A1C8181984D5FC0CD24DFAD64494B40742AB9B9F74C5FC07A9BAE0071494B405BDFF16EB44C5FC0429CCA31284A4B4056E0B5037B4C5FC023F342D6B14A4B4082F76DEFBC4B5FC0D402862CF44A4B4029C3D1D5394A5FC0A20F8E2A3C4B4B40AECDE6079E495FC07F444CCE344B4B403579519D2C495FC0B3789D75DE4A4B401887E2B9AA485FC0BCF06A238F4A4B40788F5BA784475FC0F9D149EE9F4A4B40BD40384E9D465FC0B9E0AE01EF4A4B4075C0AC3481455FC0A2291F95AD4B4B40184AA31E4E455FC0A29B47A05D4C4B408DFEE6B155455FC00845064B864D4B40167738A748455FC084C624C0144E4B40BD8ACE9FA3445FC0699D12F75A4E4B4077D94339C5435FC02ADDFE195C4E4B4074F37B0553435FC05B803E56E54D4B40F5077A1FD7425FC0859B8AE3E94C4B40E4BE0E2042425FC0C2F5E540584B4B4045ACD88337425FC059975A96AE494B40921E5A9B30425FC0555FFC4199484B404D229CB6EE425FC022C658CBB5474B40686AF3AEEB435FC073F7FED552474B40F14F97A482455FC00814D3DEB6464B40B328C08805475FC0A5F260569A454B40CF0026A565485FC0D3E7513C4B444B40CA32633042495FC075AED3366C424B40E5EA59DAAE495FC039265F7C0E414B409333F2B887475FC0232648D1CC414B40204EAD8ECB455FC0DC1CC77997424B40534CB34D9C445FC0B7FE8277E2424B40E3527D6A27435FC091C46E15B5424B400D098EE746415FC0E1664CA76A424B409247153778405FC07E0B5CFD30424B40F659C38C373F5FC015C8A7F079414B40F8E5C75E0F3E5FC09A41A97987404B40F6DD792C6C3D5FC0A69915D7D33F4B4003FD102E2F3D5FC046B92002923E4B40F0D081D1F13C5FC0A809B69D2D3B4B40EF2288BB0B3D5FC0BCD2DBF6A5374B40EF8CA2D1783D5FC0AAEF758316344B4042EA64FD343E5FC0149AD0A99A304B404ED9CC2E3C3F5FC060132BB64D2D4B40E08E885D8A405FC02B9BE5CC4A2A4B406F7815891B425FC0522761D9AC274B4067F20F69DE465FC094585CEE891D4B40F086EACF0F4B5FC0FF4403BE04164B40345EC64E694E5FC06A1C7812FE0F4B40B45C6CC625565FC07E9B1A9AA3054B40B06BBD36BC575FC0E39C90B811044B408A8F2323D5575FC0750A89AEA8034B40C91B2F88F8575FC02358F084E6024B40AE9385C20A585FC0D3A1DB6750024B40AE1F99DC1C585FC0D71B87C3FD014B405E805B414C585FC04062FB0EC2014B40182643E1A2585FC07EB77E4093014B405B339DE70F595FC01B99952261014B409EFE70D862595FC0453B69EA40014B40CB0E7B9BE7595FC0D2EE815312014B4088B813CE695A5FC09F1915D4F9004B4062247EB13A5B5FC0974B1568BC004B40D425E70B925B5FC0FF141402A8004B40F3DE4A59465C5FC07EBA9BCE55004B403144F505DC5C5FC02BD00A1C1D004B4027CE90C8975D5FC011C2C7BBCAFF4A407E0E0B06FD5D5FC067A8541385FF4A4044205FA4605E5FC0C587B9A32CFF4A4030FC2E6BEF5E5FC03A5E450CDCFE4A4036D4C9A39F5F5FC071B8998DA4FE4A40F553EA5023605FC038EABF699AFE4A4021C8EA6E83605FC0410946399BFE4A40A0DCA590CF605FC0DDAA7551ABFE4A404171E1643A615FC0D5481C0000FF4A40266C8B1CF2615FC03E69E8CE7CFF4A40DA8A798C7F625FC02720672DCBFF4A40248EE5D4CD625FC0A986DC0521004B40BE4E6A9C14635FC082183D9D75004B400428538D94635FC0AC27A91520014B4054A042FCE6635FC01687B033B9014B400BD4E3CF2A645FC0138D283126024B40C5120B7709655FC0B04D615023034B401C18221790655FC0A131175C57034B40C95A6CDF67665FC07A34AC9974034B407B6F51B873675FC0D968CFA87E034B40B8903EAED3685FC0406341BA7D034B403A37EF9E8E695FC0FBE7D4C353034B4096E6218B146A5FC0970BAA2955034B40A56C834FBF6A5FC07D9D7ABD71034B4001B9FEFA316B5FC04673BBDE73034B40C4661D82DA6B5FC0221FBB9D4A034B40198C0CD0386C5FC07D4DF07466034B4036E9C02BB36C5FC0E59EB76498034B40C5ED5391CD6D5FC0BDCB235FD6034B400D911A4EE36E5FC0CDEB6A7EE4034B401E92D97499705FC02746433827044B401D86CD6833715FC0B02EFCD24D044B4085EF0302B6715FC05F06BC387F044B400B08869B6F725FC049B4297AE5044B409CE3192B20735FC081550EFF1B054B402C5FDDF0BA735FC0C7D314E803054B401F2D92393F745FC0D4EF74D8EC044B405AE3A6FB38755FC00E28CE27ED044B4066646191DA755FC02C80CC77D4044B408116AA0A06765FC0466698C96A044B40CFE56C9318765FC0D08D073DF6034B40A33B2C6025765FC016FB39C351034B4006464A7D24765FC0135D330C7C024B40C368D8D03B765FC015772B77A4014B400A51EBF55A765FC03705A7A086004B40F3E42E8B6F765FC049D37E589FFF4A407F183B7351765FC0DB061D5B50FF4A407798AA2943765FC02ED20F95FDFE4A40456B083833765FC076C929E591FE4A404665EBC14C765FC08917E68437FE4A4009054FAAA3765FC04338CDC0F4FD4A406C84C49874775FC04D67A2E96CFD4A404C8EC0A318795FC07E10E0C74AFD4A402FC19F9DF87A5FC07B437B893AFD4A40EA4097A6287E5FC01ED4EC84EFFC4A4082D59AB21A7F5FC0DDD9DA86CEFC4A4076B28A620E805FC01469837E36FC4A4021AEA8634C805FC035052A9B37FB4A4004375F8126805FC0F8BD7DB252FA4A4024F807889D7F5FC0062E09B39CF94A40D5A3314E787E5FC0E16A855C50F94A40BE3749B3BC7C5FC0FFF3B7406DF94A407DFD92F3887B5FC00AB991537CF94A407019D721207B5FC0F8B87365B2F94A4051F9346BB97A5FC08C0ACC63DAF94A40469B5D5A30795FC00965B77AA7F94A4032595722FB775FC0AB8630608CF94A40114AAC79BC765FC085EAA28FB7F94A401640A0DA0C755FC042DA8EFCD9F94A402623A10CD9735FC0C3EC0272E8F94A40D5C3DA1321735FC03203B10DE3F94A40FF726C07D3715FC0AF32B5A4A5F94A40FB7688FAC26F5FC093A595B276F94A405C504A6F466D5FC0D0E887B431F94A4034023161646C5FC094B478E818F94A409D92E047F56A5FC0FC20437D6CF84A40A4EA74E0756A5FC01C064A3E10F84A40C0D7000E246A5FC0A5AFB0037AF74A40796AC1F2056A5FC0143B5689B0F64A4088701C013C6A5FC01EB9CE4A0DF64A402A471B05CA6B5FC003AD08B176F54A4059554737676D5FC04B04F22AC8F44A40A900C0513B6F5FC0827ABD0E19F44A403E4AE18CAD705FC047CA9827C2F34A402E0B5CB6D9715FC01CE3B4558AF34A40CF1F808BEA735FC00EC135C80FF34A40A29CDFF049755FC0B9DCBD569DF24A40D693496A51765FC0A19829AEDFF14A40C5E773DD03775FC0F23FA74F4BF14A4078382CE276775FC05E97310D3CF04A4065CB959E8E775FC0FA345537E4EE4A40AD2014617A775FC0810DA68C41ED4A4070A097BC67775FC0D16FCDAFCBEB4A40C627B5613F775FC046F41B3135E94A40E6CBF18E75775FC094ADDBDFF7E74A40C808F807C0775FC02271958306E74A4087AD8CCE79785FC034D52ED1FAE54A40DAFD90590A795FC0C70BF1EC9FE54A4041D43297297A5FC0CE4B3A1061E54A40E76F0658287B5FC028EACAA177E54A401BB8F5840F7C5FC0526F934A8FE54A40F6AAB835E87C5FC00DFB84AC5AE54A405DE9946C737D5FC0345B45AA62E54A4051C94F80447E5FC0BC30603FA5E54A400515BD2D767F5FC09AC852EA21E64A40D57F92AC89805FC0F4F4C4058BE64A40E8E1D24EAD815FC096DC53C75AE74A4075708651FB825FC0B2C971BE0BE84A40AD8BF47AC2855FC0A40203FF83E94A408F49BE3434875FC0B5C64FA67AEA4A400FE8756F83885FC078D128F487EB4A404D07EF60C7895FC0B93036DB02EC4A4014647BED388B5FC0B6C3C126EBEC4A40497C97DF4C8C5FC0F33E3E3CE1ED4A4099849002F08D5FC0A50C68E3B4ED4A40D6466AFB6B8F5FC088EC6908D0ED4A403768EF8507955FC0BEB10DC03CEF4A4052549400A6965FC0185AEE1C65EF4A40804D105479985FC037CABB234BEF4A40A9E39F655C9B5FC0716B41D9A6EE4A402923C322DA9F5FC0721CADF64DED4A4003C87D7F3EA45FC094F2F67AB6EB4A40BE8C1F8E93A85FC0E89F2CB5EDE94A400386841B19BA5FC0D265AE1FE6E14A40658586A1B9BE5FC09A7BC9C4ECDF4A40B42F54D287C35FC09F2878EA10DE4A402FEA8EF08DC85FC0B1A7FA7F5FDC4A405247AF8907CD5FC0A463CA111ADB4A40039B4CA5D0CE5FC099FFD842E9DA4A40392AB846A2D05FC0357857E213DB4A40D036107178D25FC00793DE9B7FDB4A408AE25CC3EDD75FC0A917F73C42DD4A4080D85D80ADD95FC09542F341ABDD4A4097ADEA4F5DDB5FC07A8766DDD1DD4A407B3A5501F9DC5FC070472AC89BDD4A400B9EDE5E7CDE5FC0D7D042BDEEDC4A4031A925A508E05FC0AF7F53BA88DB4A401486B3B47DE25FC006F9A8BFE5D84A40824E4E2C7FE65FC088454C20E0D44A406CF734BF0AF05FC0B900E4172ACC4A402476714C63F55FC0D8202C3D9CC64A40CAD05A2BC2F65FC01781F38EDBC84A40497933F17FFA5FC0864E7E3554D14A401D08C06C38FD5FC06A41D40503DB4A408DF960FFA6FE5FC0D15E524A07E64A4057FC5D651AFF5FC0A7CF414A97EC4A4071C21709E4FE5FC00E90FB6B40F24A40D9A8DCFA20FE5FC0B181B9753FF74A4016F1C986EEFC5FC01177CA25D1FB4A405A58781E6AFB5FC054B7123C32004B40718249A0E1F75FC0FEE962CF55094B408E3226C818F65FC098B24411920E4B400D9E4A2E42F55FC0FCD1EB5C78134B4054812C6609F65FC01CB232A075184B40933BF53FC3F75FC0102D67FEDB1D4B40F6CDD8A8E7F95FC077CAFF1277234B406B521CF5EDFB5FC0D522FBB512294B40441994D54CFD5FC025D45C0A7B2E4B400652976A7AFD5FC040465D5E7C334B40777D3175ECFB5FC047055EDDE2374B400A98855236F55FC023930F7D423E4B4054EBE5102FEB5FC00D80620A0B4A4B405FE833C028E55FC0E21BDCAF09564B40C1DFA523E6E15FC00CF532B634624B40AE9989F3B4DF5FC03C4B033D54724B404948F9BDB1DE5FC0F81C7867E17A4B40	175	363	3893	216	0103000020E6100000010000000500000057FC5D651AFF5FC0D8202C3D9CC64A4057FC5D651AFF5FC05B3BBADE564B4C40F0D081D1F13C5FC05B3BBADE564B4C40F0D081D1F13C5FC0D8202C3D9CC64A4057FC5D651AFF5FC0D8202C3D9CC64A40	Interior,Nachako/Stikine
17	Danezāgé’	RGB(0, 208, 0)		Kaska,kaska Dena	2	"The Kaska language has lost its natural and everyday use as the language of the home and work place. Elders and those who do traditional work on the land still speak the native language, mostly among friends and family."[[source: http://www.gov.yk.ca/aboutyukon/language.html]]	0103000020E6100000010000002B010000B96B0F4CD11960C022FD4E9782654D40F5D1BB83D41C60C053AA48573B634D40A979A379C71F60C0BBD3621EA3604D40C17BD579182160C033DDE257F05F4D4049552F506D2260C0BFD6F47F5A5F4D4023E87EAF1A2560C0C19BA986915E4D40FC4BC312552660C09EEACB16455E4D40014DAC1EA82960C0FE01F383AE5D4D40265BE2ED1D2D60C026F1994A965D4D40F5ADF3D7792F60C038F34EC1F15D4D40013CCB2FA83560C023C156312D5F4D40120F51BB6B3860C0981939EA80604D40A6A1DABF883E60C08A146BEA89634D40E04F1DA2D94160C090DD209091654D406FFEF16AF54260C09771C2C0CC664D40FD7DF03F134360C04D5F39289B674D4017747CB0C34360C0E38DA16A56684D40A0F91CEBBF4660C058116BB9A16F4D40FFD03F0E614860C016EAB0A62E764D405EB4A253024A60C0FC1B75AA1C854D40B3CE455CBE4B60C09EDCD2DC79944D40A950D969FF4C60C0D3F2A6B5A19F4D406F8E099AD74D60C01A0EF0AB19A74D40372ECC53284E60C02E459A2B47A94D4036F18639694E60C0312BB9487AAB4D4078264F8F9B4E60C0DB9D736DB2AD4D4009099E9DD94E60C0BCB121722FB24D401D0FA6E0E74E60C0A7E5B12273B44D408FAE9E3CE94E60C00E7DA0E601B94D405DD76488BA4E60C0805ACD90E1BF4D4088B2BAD72C4E60C0A5CA822488CD4D40719C7A36154E60C049E19940FCD14D4092E52DB51A4E60C01DEF281C5CD64D40914B45C5474E60C07BCC44FFA2DA4D40FE153CDFA64E60C09E7F6B2FCCDE4D4078243677EC4E60C0A0C95E28D4E04D40E65C6C81424F60C0DB2243EBD2E24D4037B4594EAA4F60C0EABBFADDC7E44D408F9CA62E255060C0376C3F65B2E64D40905E1A73B45060C0853C68E491E84D40816D8B6C595160C049672ABD65EA4D40D4C6CE6B155260C05FC9554F2DEC4D40AB3AA6C1E95260C0ECB68CF8E7ED4D4034C5ADBED75360C0792EF71395EF4D40A7CF47B3E05460C08B5DF1F933F14D40C77588EF055660C0DA71B5FFC3F24D4078AD1FC3485760C040A8007744F44D403974427DAA5860C02891B3ADB4F54D4081D6926C2C5A60C026816DED13F74D4071EC06DFCF5B60C02622237B61F84D4074B0CE21965D60C01D19B0969CF94D40F4C23881805F60C035BA637AC4FA4D40B5F49548906160C0D2B9885AD8FB4D4098B01BC2C66360C055D3E764D7FC4D403E6B77CD9F6560C05B56F78A8DFD4D40538F37114C6460C09EDA025C8B094E402049BC2A046360C050857BB2ED164E4012D3A89A2B6260C079B02A327E214E402288A5981A6160C0601F8212AE314E400FD0090F466060C098B410D80B414E4049255D83EE5F60C064890C07C1484E400B16F23CBC5F60C068B020775C4E4E403BCA6A739A5F60C020423D39C7534E4084C711228C5F60C0612CFDD3F7584E40CFE8EF45945F60C0ED4D27D6E45D4E40F68D73A7A75F60C03FB4A14D03614E40A9CBA8DFDB5F60C0AD3941BA6A654E404A8672872E6060C0B46ED07775694E40F35FFF9AA26060C0B71027211A6D4E4019136A143B6160C0946A724F4F704E402DC768E8FA6160C0A6C19B9B0B734E40AB83AD359A6460C00C6B241FF4794E4068BC437E186660C018E5721D147E4E40C8904C0DB56760C06ACBAADCE7824E40ED0578DDCB6860C0D7D1E9AA78864E406B090815606A60C03B130413478C4E40EE5705B1586B60C0CDEB18B06A904E400448A853376C60C05AB70AB1BD944E405F704CFCF36C60C0FBD70E9E39994E40695B719E866D60C02354DBFDD79D4E40332E5721E76D60C00E81065392A24E403250F30B026E60C0680B91F0F7A44E40157BDC5F0D6E60C06BCCFE1862A74E40B42A8516086E60C02FB00EFACFA94E403454A228F16D60C0530299C040AC4E406AB9308EC76D60C08CDA6D98B3AE4E40DF7D7B3E8A6D60C006B731AC27B14E40E80D2430386D60C0313538259CB34E40B85E2B59D06C60C0B1E05C2B10B64E40E3EC641F606C60C03969B47D3BB84E40FDDD231E036F60C01C881444DCBC4E401EC7C31CE66F60C05F97069311BE4E4069A42DBFEF6F60C046246DA67FBF4E40954F83F3F66F60C056B192C411C34E40728532A3EC6F60C0856333DA71C64E408502797FD16F60C0FC80D2AEA1C94E40353E793BA66F60C0A5371C0AA3CC4E405C71158C6B6F60C02959E3B377CF4E40BCDACA27226F60C0270A217421D24E40549D8DC6CA6E60C0F710F612A2D44E40494DA521666E60C04083AD58FBD64E40157B8AF3F46D60C01B89C00D2FD94E404D49C5F7776D60C01F01DBFA3EDB4E40B042CDEAEF6C60C092C6E0E82CDD4E400685EA895D6C60C0D973F3A0FADE4E40135F1893C16B60C0286478ECA9E04E404A76E9C41C6B60C0FDD91E953CE24E4048C3189FBB6960C08E82232613E54E4052FFACC6006960C0F00688A35AE64E4070AB9E4A7A6760C0C2E974FFAAE84E4042896A6BE26560C0D1A21FD6B3EA4E40155B842A3F6460C07CDDD98B83EC4E40EA6D0C88966260C007DD2E8C28EE4E4026D96F2FB85D60C04279FCEEA7F24E40930273CE355C60C0706CC6DF32F44E40826210E0CB5A60C081C88CA0DBF54E406EF212292A5960C0660F73902AF84E402430AEC7865660C0CD6E68E57BFD4E40256AADA8EF5460C04DB24880E0004F40905D73BEB65360C054EE93B8C8034F40778556A4C74F60C097A1484EFF0D4F40D4662872EC4E60C09722262B5C104F405C9BCFE4244E60C03366EB2BC2124F40046BF0D7174D60C0841A0A1A65164F402D3ACB1E264C60C03B8399030A1A4F4049A48BC7D94960C0A90E302276234F40ECA0FAE9A44860C0D9E3BCD0D0274F4024ECBE2EFC4760C01123D591DB294F40F48086DC454760C0D3873AC6CA2B4F405742B5E77E4660C02FD4D40C9B2D4F4023EE9F44A44560C0E4400E02492F4F40FCD9F4E7B24460C0C80C723FD1304F40034032C7A74360C09BA1395B30324F407B0D2AD97F4260C03257C8E762334F401E209316384160C0CDE4157365344F4082B8A77ACD3F60C06093078634354F4023BC4A5E853E60C073205741BD354F405484E2354C3D60C02AF77F0E1B364F40ED567DC0BD3B60C091387B8259364F40267510159E3A60C0728C927E5C364F40A0427DCE283960C0962854882A364F40AE0A1669153860C0CE0400AEDF354F409F44E9AAA73660C07965DA854E354F402432586E7A3460C0D21BDFE81E344F40AFBF4BF3DF2F60C0834BF69AFB304F40014CA4E8C12E60C0376AFD19F22F4F4040BB48A2B72D60C0478F50F6D22E4F409F869043C02C60C04E70BCF49E2D4F404EBE53EFDA2B60C086A662D8562C4F404189FEC7062B60C0BE05DE62FB2A4F40D3CBA3EF422A60C0F45B65548D294F4021F10E888E2960C0D096EC6B0D284F40DCC3D4B2E82860C0744E44677C264F40D9746391502860C07DA33703DB244F40C6452DEF452760C08F31AA0B6A214F404CE007B1D12660C044399AED9B1F4F404B2EA201072660C0092FB80DD81B4F40DF6B88D3AE2560C0E5BDDCBDE3194F402F82CC73142560C043FD34F8D9154F407341AADE562460C01708CD35830F4F40BCC7ADC8E72260C0BEC6D486CCFF4E406C30DF15332260C0852F56B9D9F84E406C9EF13B4F2160C0CBBAE3DDE1F14E40E1F36EE4912060C08BEE6C4D43ED4E400A8D1078252060C043B2F225F8EA4E401B0641EE2C1F60C0B312409F6DE64E408EF63597161E60C0F06E46760EE24E406B3C84807A1D60C0471AAEAB5DDF4E40B6462600EE1C60C07C1A94157FDC4E4074F48FCBE81B60C0C471B3A635D64E40E4EDB5FF4E1B60C0A8BA97787FD34E40BC276DA8A41A60C0B5504703FBD04E40838E93B9F41860C0352BBE0D70CB4E40E5B60CEA511660C0A01C06FFA1C34E406D14A4332D1460C0F5F70CDB95BD4E408B614B35311360C0711AD6ABFFBA4E408541885C161260C05D20047E60B84E406CECB4C2860D60C0BA0A15F67BB24E40B1A33CB6330C60C0DF4FAC0CCCAF4E40D0B6A98AC60A60C0AE0FDB5315AD4E40AF2DA1CF400960C03A5E328C58AA4E40CB8857E4F10560C03F285FD3CFA44E40773B295B530260C03AA9F6ED379F4E400FD837166A0060C0CBC53032689C4E40A7C6836CD6F85FC03DBBC903C5964E40F09CE7CE29EC5FC0297B3EBD528E4E404E562C89F2DE5FC0E1280BC7F6854E400726CAEDFDD55FC0C1363B987B804E40036D9E5B07CD5FC06F6CBE2C1B7B4E40CD65816C72BB5FC00695D20BC7704E40A48AA4B7BB955FC05CFB5C08CD5A4E40DE7816F9648D5FC07B2F8CFBB3554E406AA3890408875FC0C9977860A6514E40F1C51FB6FE805FC0EEF5BBEDB34D4E4036EEEB3ADC755FC0C5E14CA31F464E40B788C11EE86B5FC0DA42091BF53E4E40EE43CE4E0D635FC07B3DE8ED31384E40E3901607375B5FC0A3AA535BD3314E4068E1F12CA7575FC0BF6E2BDAC82E4E40F23AAF5D31515FC09D829D5EFB284E4068CC27598D4B5FC02AC70E5E8A234E405B474E269D465FC07EB1AB447B1E4E40ECF9F8E142425FC0F2568962D7194E400A3A3859853E5FC04126429284154E4044B5F916E2395FC0F1354820980F4E40C3DE6EBC2D365FC04F310C4F4C0A4E40D8CE17271A2E5FC0024866909FFD4D409784A59D722C5FC0CAF70D705AFB4D409456C344AF2A5FC0E16E6BAC3EF94D40C11E6804092A5FC01E4CCCF779F64D40DED865E3F0285FC06EA43865E5F24D400DE306A2A1275FC0100F0C142FEF4D40E8B3D642D1255FC02C303FAD8DEA4D4014F0C36E6C235FC0183CA356F8E44D40737394FD77215FC0ED921B85B3E04D40E02F8894991C5FC0FC51880BCED64D4035B5F0864F165FC00EC361BF06CB4D405FDB47D194125FC0C1024E8C67C44D404E1ACC626F0E5FC0F1C7C29547BD4D4082757C26DA095FC027F2A402A4B54D405D21E721D0045FC04ED2B2ED79AD4D406ADB0ACE1D025FC05182308731A94D401F784D3B1CFF5EC00BB5F157B1A44D409E65F35EB2FB5EC0D98548C5FF9F4D401C64B908F2F55EC00923A78AAF984D40DB9AC71F9EEF5EC07BB6CEC02A914D40A9C6793CEAE85EC063D240CA94894D400E742F6A09E25EC0FBFE784B11824D405EBD75242EDB5EC001755033C47A4D40623BA3A368D25EC031B2DD5B9B714D407ADB35BD70C25EC049FFDCB50E614D408831ECE9F3BE5EC03D4689BE4D5D4D40DCCA1011A4BC5EC02890D537985A4D40AE80DED737BF5EC04DC857DA78584D404F4B87A161C25EC021C3FC7672564D40E7D8E40B24C65EC0810045A081544D40F71ADB9B7ACA5EC02B4A01BF99524D404A51C0FE85CE5EC0432A47E800514D4071E7286DE0D35EC00641E899084F4D40B157CB8B08E75EC057C3B7014B484D40D2C840FAA8EF5EC059F7795A20454D405F041306E6F65EC0CE0CC0CA52424D402EC4D46167FC5EC0DC1932A8EA3F4D402A70C3E1E7015FC0D58316E13C3D4D40E975D42836085FC0CE49C7DEE7394D4032D666E5450E5FC001BEF2D081364D40E8B4676AD91B5FC095CD0CA49D2E4D406668DF230C215FC01AF43F18CB2B4D403AD72C6657235FC000AEC7CEBA2A4D402545B824C1295FC000416AFE59284D40EAC58464CE305FC018F1503755254D40E6E1A96172395FC01B2998E942214D40FBA25C7AC3425FC0743544D5891C4D40E0C8B45171495FC00310AF69D61F4D40BFEE69DB8F515FC0EF060BF36E234D40E7D6536181695FC08A70BC975A2D4D409796049668735FC02357C9EC82314D409BDB542C927D5FC05EB1CD47F2354D400C6DF169CF875FC0B0B3A2F7AC3A4D408864286DF1915FC090E8D9C0B73F4D40F9512732E5975FC085BCCBD3E6424D407F42C926C99B5FC06ABFCBDC17454D404F26FBB053A35FC0AB1327F8A5494D4095BD1533F4A65FC0E70D6FCF034C4D40F44B742378AA5FC01EBED85E714E4D405A8595CB81AF5FC0C437D51234524D40E43DE5198EB35FC09DDE2A9C89554D40B433EEB9C8B65FC09969E9ADA6584D402AAA98C6ADB95FC07C490077EF5B4D40AA373A95E2BC5FC0FA5292BB33604D40A14509E4B3BF5FC0C5C9BC9F8D644D405B6533DBACC25FC03D47EB20BE694D40302BAF5E2CC85FC01BEAF0280F744D40942399BAC2C95FC09EEFFCB4C3764D4055F6D0EAF5CA5FC09149ED4E97784D40A0B9038E9ACC5FC090B04AE1B67A4D40ED5814A8E3CD5FC05ACEAC400B7C4D409DAAB1915DD05FC08493FEEFEC7D4D40D5CC6C03B9D25FC0D07D5E558B7E4D4094E87DA223DB5FC087AE64C86C7F4D40226F799DEBE15FC040C86611E37F4D40CABF3954C1E65FC02204FB750D804D407DF9619FE8EC5FC0A9471B1107804D40761EEE2855F15FC02BDE343FD27F4D403633D6B304F75FC005619B7F4A7F4D4086BF88CF26FB5FC0780958C6B27E4D400D54497432FF5FC01D34BC72EF7D4D40F8B7CD113F0260C025F4BADEA57C4D40C238E8C3FF0360C0C7FDD910127A4D4049DAA6C5410660C00BC2303A64764D405BB16449450860C0FE0639616C744D40F20CC2DB3E0A60C0919CDAFEA4724D40BF707EE66C0B60C087FF13235C714D40CC0139EE750D60C09934FB873A704D401CE5C2B0041060C0C36DF392636E4D40E84A821AFA1260C05862679EFA6A4D40CAA2AD067A1760C03F71649BA8674D40CBFB5246A81860C0144302C56D664D40B96B0F4CD11960C022FD4E9782654D40	4	48	518	22	0103000020E61000000100000005000000954F83F3F66F60C0743544D5891C4D40954F83F3F66F60C0728C927E5C364F40DCCA1011A4BC5EC0728C927E5C364F40DCCA1011A4BC5EC0743544D5891C4D40954F83F3F66F60C0743544D5891C4D40	Northeastern BC
21	ᓀᐦᐃᔭᐍᐏᐣ (Nēhiyawēwin)	RGB(176, 176, 176)		Cree	1		0103000020E610000001000000700100001F863519F6B45DC06879381054AB4B403F8A8785C6B25DC065B890B79BB04B40BDC9D052BEB05DC0FA5598ADC0BF4B405BD0C004DFAF5DC0F2EDDC41E7CF4B401EA18F528DAF5DC0D13C403450DD4B4060C0F9C8D4AB5DC0ED303FE676E64B40D52C4BA7A4A95DC05BD8922DBFF34B4088EDB9F9DCA85DC059F24CDB0C084C4012F8085B49A65DC0DACA9EC84D154C403441CA6A899C5DC05E8715236E384C409DDDEC051B975DC02AC8515E21494C40B881F4BC8A905DC0299113BE33524C40B20ED870388B5DC0151F6ADD0B604C4053D7D21553885DC035E532851C704C405CB271AD9E825DC076C394D6CD824C40F2A45A8DA57C5DC0D3490B31BA984C40C1B997C163785DC09E00AF7C6AA54C40266654E425785DC0FDD3E8E32AC44C4084BAC2936F785DC06038573700DB4C40D53B6AB97C775DC0A671118F5DE84C4022A0CEA19F6F5DC021B60223FAF54C40536A883D106D5DC02488F3D8B9FE4C4088F99C2E056A5DC0E61001BDA7084D4049063101BF5D5DC063B41B7F32124D400FD1365CF3405DC07B805DFEAA1E4D406039166108335DC080F108D586274D402B81AD33EF185DC0CC817764B2284D40AC132F4980095DC0EB2FFBD0F52B4D402524829F7A055DC0A17435D250354D4032D3FE03F0035DC0A69D2176FA404D401B4F4DA6D1F85CC049378A7016424D40BDDFAE61AFE35CC000FCB99248444D40B224468A60D95CC0F7125956F6474D4075F4F0623ACB5CC04DD3C625D8484D40340F0F4A48BF5CC0BE9345AEAA494D401CA4CF81DAB45CC0AF97D690E7464D40D72392985AAB5CC0406D852B5F434D401EE3A9F0E59C5CC0F707F578B63D4D40476C96BD29965CC0EF801D27C0394D4074FD2A7D98915CC01418EF2DA1204D404831A05DFD905CC0B46D23AC3C0D4D407D1D1EBB1B8F5CC0A71EBE6E06024D40D6A0B245768B5CC08019409C01F84C40567977845B825CC0548F154358EC4C40FB02AAEE72745CC0AB55859784DE4C4054AB788865685CC085834D847DD14C4053AB990B08635CC0096975902FC94C40FE7C52D8D75C5CC09CFE9AA249BD4C40435E49D186535CC0EC65331062B54C40DE671E58EE445CC0B23B55A07FA84C4031CF30AEB83B5CC052D956C96D9C4C4082667CD810345CC0ED5671662D914C401A5220DA3B295CC037A3C1F3317A4C403302906CB4245CC0290ACF4CD5644C406683D4FEEA1F5CC07B681224F55C4C40AC92DDBC75155CC0E10B5497F94F4C40748DE12AFE045CC06BECEF79B7404C4030D6190609F45BC00DC2CEAF69354C408D7FA1D130E75BC0DCE35BBDFD354C4053BF09C8A1DB5BC078B58CEF89384C400CF7C5D0E9D15BC05AF4DB02A9434C4066295AD213CF5BC0CE4BBFD2E84E4C40BC910CBD42C65BC01BB019103C574C40FF5E9C63C3BC5BC0C802C32C8A634C40359B6B3A11B35BC022DDB3D1EF664C40605B2617A89E5BC0C90129D1E9694C40C10462C29B895BC0DE58E6393E6D4C40138594574F7C5BC01956CF75356C4C40774E0B00A87E5BC01093B71C7BC34A4016CFB37D5E855BC0B9C8E8D3F3BF4A400C3789B808925BC076E36DAFB4BD4A40141ACEFFEC9A5BC011A55A094DC94A408F9FF513CA9F5BC0D3C5F10104D24A40BF80BE148BA65BC0E367936720DF4A406A36FAB688AF5BC0F6CC3846AFEA4A4061323531D1BD5BC0FCE525F249EF4A40EEF2EEA783CE5BC0649EA715FBF04A409C22691CC4E45BC05428799B56F14A40FDD08223F6F25BC0EE33AD20B7F04A400B2447B7BCFD5BC0668FA70C12EC4A40E35258C811055CC0C406516206EE4A403B615C1183115CC075CE0A5EF5FC4A40082CF7DFC8195CC081271364C50B4B40005A9B3AC0235CC0F45E0581DD0F4B407C4174FB2C345CC0FF77AAA90B104B40CCF60DCD493A5CC04B402033C10E4B40B7D89AD919425CC0B30FD4DA69064B4003B4A13526445CC043698D791AFA4A40F83663FEE8425CC01775DB9094EA4A40BFC5C1FE19405CC01663C4CBCBD74A40BFE0D637963B5CC0EF6A85EE0DC34A407C0F53B62A395CC0963669E1A9AF4A4071306951B8365CC0D3013203EE9E4A40F6E61E2415325CC0BB23012244954A4011376157CC325CC0CC1222EF69814A409462839695365CC0EADD6D106D6F4A40C6A70E08DA3A5CC01BBABA452C674A40D11403CB3B405CC020F66549C3654A40BD12F0B34B425CC0F7FB121ACA5F4A401B00B3313A445CC01B177FE021564A401820FBBE054B5CC09EB4E6B7A3454A4061024C2709525CC03CD6C6297C414A40A1C3DAA17B5E5CC0546F664DDE3F4A40E04508A722675CC01A864B9796454A408E62EE97356F5CC0911FA92B33494A40F66793A9AE755CC00CE31E3A8B4C4A40637462197A775CC0EE8DBC8578554A40A8E9233B4E7B5CC03EF4FB52B85A4A40345165B16A865CC03E18DB4E84674A40D867D7D2E9875CC0F7B33D70FF884A4039C96211C2895CC0795B649134A74A40077125A9C08B5CC0217B1C0D16CC4A409A065C1ADD8E5CC0248359D0D3E34A40488C83B6EC935CC06D44AC018CEE4A40966F319E57A25CC009449A669FF04A4090C8CAE6C8A75CC0B43C9EBD13EA4A40CECA516698AC5CC0F6E0102273DE4A40EA62399B34B25CC06A6ACCF146CD4A40AD27BFA59EB75CC0D08ABBE9BBBD4A40BD9A64B871C05CC00B351D4BDDAD4A400400011E75C85CC07049506F539C4A4081C3D7285DD05CC06732CD396A8E4A40F87F4E1D92DC5CC01C43AE3F5D844A40C3A76DD112E95CC004E920F3F57F4A4082D88F1913EA5CC03B305EBA72774A40BA4C18317BE55CC03B9EFC8CE86C4A4021A7850156DF5CC0EE4E381D80614A407EFC894F92D95CC0118AE03222554A400C112CCE3ADA5CC09227D1BC934D4A4020873CCBCEDB5CC08EBCDC63CF444A404BECC3CD67E15CC0F07DA7CAE03F4A40E56ECB63B3EA5CC0D5360C18633F4A403230FD9256F25CC0743094527A3F4A40E54D4019EE085DC0663BE7A3883F4A40328035FA83165DC0A8E52467F53F4A406835997042225DC084255E5BFA3B4A4077633186272A5DC0CAE139E620314A40DF4738A42E325DC04764BF9FB22C4A406D05C57E8B3C5DC09A5C846C78254A403792992FDA435DC008BB09D6871D4A402873F5950B495DC0D0A36D2E0D1E4A400EC24D35B6515DC0CC70E3D65E1A4A40EA697C7165535DC097A673BF1D1E4A40B17157500C555DC06EFF4FC10A224A40938F6EAAA7565DC01A0B4EAA30264A40727BE94F34585DC0FA61463F9A2A4A403017A416F8595DC0C56F78B02B304A40B425A3B1D3615DC0CD8028AB264A4A40E3072AD7F5625DC01F8BD1949F4D4A409B9B201418645DC07EE33C20CA504A40CFF9AA834A655DC0AF099A9CC3534A404D6395389D665DC0412BCB3EA9564A40E48FEF3820685DC0B7DEA61C98594A403D777F78E3695DC0B206A624AD5C4A404E6217D0F66B5DC01F93E80F05604A40AD469DF0696E5DC01E72074DBC634A409AD72CF9AD745DC027DB13ACB86C4A402C47DAAEA0785DC0E66B1D5D35724A4012F237471E7C5DC02E285F74CC764A40A0AA82763C7F5DC0020EC0D5EF794A4074ABF03A65825DC0D8B27A4C487C4A4085CA9D378F855DC0C8FD30AEF27D4A40B13FEF1FB1885DC00750A0D70B7F4A4069CA5CBAC18B5DC05EF431ADB07F4A40DBC68AE1B78E5DC08AF3B719FE7F4A4006272EAAD3985DC03E24E02B0C804A406CC3D9DEBE9A5DC0BE6F143356804A407609F3225A9C5DC00C36B711F6804A40B13F620FB09E5DC07BE7A392FF804A40F7883C1E7C9E5DC013454DCFB4864A40A5E512D7399E5DC0EE0A7FFA7E914A408DDAE4E53B9E5DC0FC03CF68D6994A404A3A4B75549E5DC0221D5C114A9E4A40C8AFE382C49E5DC0C7B95172A4A74A40C0203B2A229F5DC016F4650F7FAC4A4096B0B5E69C9F5DC03DE09FAD6FB14A402C45ABAA37A05DC00EA0240E70B64A408DC709B9F4A05DC03FDD37A97ABB4A4035E3759AD6A15DC0B0FA0B0C8AC04A401904F47DE0A25DC00F5CE54298C54A40F386B27D15A45DC0C1581C769FCA4A405AE1F5F278A55DC0C84D85E299CF4A40185B07370EA75DC01EAB0DBE81D44A4070F6139CD8A85DC0B84C193A51D94A4091EB2B67FAAB5DC0513F1CA913E14A40D86652C6FBAD5DC0012EF33CD2E54A400B0B01B100B05DC0083F452247EA4A4036ACEBD31AB25DC03A9D7E837EEE4A4057C90F5E35B35DC0E479BFF686F04A403B05BC7690B55DC0F9150B1079F44A403EB5CB77D5B65DC034134FC965F64A4090641E8E99B95DC00E324A462EFA4A40030F62201DBB5DC018F6B91D0DFC4A40F602609B72BE5DC02B8FBCAEC7FF4A402193960E49C05DC01B8DC87AA6014B402C90CF3FBDC45DC0ACE4D924C1054B40DFCC37E633C75DC0ABD317F7C2074B4003D7F156A5C95DC0C9F02A8E91094B4020D28F4813CC5DC00233A2AD300B4B40F01C86757FCE5DC0F0ACB519A40C4B4082900D9CEBD05DC060171597EF0D4B4098B60E7E59D35DC0A493C6EA160F4B40C8BC17E1CAD55DC0549112DA1D104B40953ED052BFDA5DC04603BFA1D9114B40BC26094BD7DF5DC0FAEC8DDC40134B404EECEB3621E55DC044EA0B3271144B40D55DB86CC3F65DC010E84C3CEA174B400D5EB1008F025EC0EC054C357D1A4B4035AC69A349565EC0D74924FDC52A4B40C090FBE93A5C5EC0B48332C7462B4B40202C33ABF4615EC0CDB3D9A39A2B4B404546489077675EC041ED116AC42B4B40B986E54CC46C5EC0424066EEC62B4B40567C3E9DDB715EC0E377F501A52B4B4067223945BE765EC035C87772612B4B403502B70F6D7B5EC06E7E4C0AFF2A4B40722A2BCDE87F5EC08B7BD28F802A4B402006A27E4A885EC08CCE226D3A294B40EECA3330328C5EC04CBEA44378284B40A58FF2BF73935EC08A369166C3264B4003EBE85BFE995EC0981389E7DF244B40A2B5F967019D5EC098536E67E3234B4051C5CCA9BAA25EC0043D8A26CE214B40828C2A20E39D5EC00581E85989284B403FFF7488B59B5EC07173105ABB2B4B4079E7382484975EC0850B120A32324B4091EBFAA982955EC0E4AC1FBE70354B4094AED905B4915EC0C53ED8F3E53B4B402FB6673CE98F5EC0C6357D7F163F4B40CD0D5DBB928C5EC034E0E39354454B40E7372D70098B5EC0D578A2285C484B40F1E82EE040885EC015F12D872D4E4B4042A08E38E3855EC0468479AE98534B40AD8997FCE6845EC034446D2F12564B40581EE36A18845EC02071313E7F584B40C17CA02068835EC0E88D3A0A155B4B406A1B3BC7D4825EC057711874D35D4B40CE43ED085D825EC0A56A6C5BBA604B40F8D6AD90FF815EC068B7149FC9634B4059F2120ABB815EC0F96C4C1D01674B40BC042F218E815EC0E0BCC4B3606A4B4044EE6D8277815EC0459BBC3FE86D4B40BF9EF3D587815EC0B9396EAB6E754B401F369B21AC815EC0F41729446D794B40B39DF75A26825EC0B035C088E0814B400F0FD7E5D9825EC01D8C5C4DF08A4B401B7D3D97AB835EC0192BEED391934B4071BC22032F845EC0DA55F5A30D974B40C335BA61D9845EC094D563DBA59A4B40CA242B308E865EC0EEE3CD281AA24B400898D24EA0885EC05601E510CCA94B40203D66062D8C5EC065EF0D2EE5B54B4073EDCB5E0D8F5EC0DBD562CCD9B84B408339B7A136915EC0120307043DBB4B40AE0F9A4633935EC059D7146D9CBD4B4002A69B8C00955EC02BAE3E6AF4BF4B400ECFB4B09B965EC074F8B75D41C24B400C511ECA6A9A5EC0F776471A71C84B400E1C10D1A79D5EC00046FE2889CE4B40FBFB952C6BA05EC08F4AF89B8CD44B404AFE918054A25EC08CDDA72B51D94B40BE08C12235995EC0C347C93A9EDB4B400284FF00FA905EC0772A2F4A02E44B40CB806078C4815EC03CE78A9B8AF54B401B0B18E87E7D5EC024C03C7DCDFA4B400AD65072767A5EC006BE6FA336FE4B40AE0C3DE690795EC0D06F227532014C400D703476ED775EC0F4F1948253064C40CF443CB5A6765EC0D67AB31B4B0A4C40313E52E1F4745EC05ECCBDA5FC0C4C40D98AA4E031725EC0115CC796EC104C405155B4CB38715EC06302C1A289124C4006D8455D6C6F5EC04FB20532A7154C40EB2C6C00EF6D5EC05816CA7C9F194C40C599E90F9F6C5EC0CBF0469D921D4C405BBAE1BA736B5EC0CD5B75BBEC204C400FBCECCD4C6A5EC01340DEF7A9244C401DBCA24147695EC0B955B0340D274C402F6224482E685EC0BA83AB1EA5284C400AAE8F1CEE645EC09F06077A882C4C40694446596C625EC009BDBEEAC62F4C40556E69C77A615EC08DE4ACE15B314C404EF05C5DF1605EC0BE4B6FA395324C405305229D335F5EC01D42D79330374C40ED3CBEC8155E5EC0080DB4E763394C4075DCA6D6BA5D5EC0FF1962F1F93A4C408E5B08AF2C5D5EC02FE148B5433C4C40D1DF5B7A5B5B5EC01AE6EA9DD23E4C4022A1B59DCE595EC053830F1531414C40721E471477585EC0316CBF0A20434C402A6E0FDFC1565EC07580FEDA7A444C405703349FAC545EC041C1BF89C4464C40D545E03584525EC06FB08ABCAB494C4052AAE1560C525EC017BF0E56BA4B4C404431C0D857515EC09CCA6F992E4E4C408D32601B964F5EC0D246D53E63514C409D65CDF6D34D5EC0B5A5FC5A8F544C404FB7081D974B5EC0F2CDA14D6D574C40FB154C3669495EC0F10D13EF275B4C40B868E66015475EC09BDDB75C0A5E4C40D202273E01465EC0BC2CB3EA445F4C400AE55DEAD9425EC0CD7ABAEA475F4C40481E500D9A405EC0F4832EA9FD5E4C4005AEB35EC73E5EC06DC9674FE55E4C4023A7FE85743C5EC0C2FEBE64B05D4C40CBFF88DE2C3B5EC0528D3B242C5D4C40D9B150C030395EC0DF9C05BDF55C4C40425809C1B5375EC0259E47D4205D4C408D9C2CE4D1345EC04826DC4C3F5D4C40A3FA0514B0325EC016F1337B895D4C40D918D221BB305EC052658BF1805D4C40680055D5EB2D5EC0F058CD79255D4C4084E75464932B5EC0962F0489195C4C40BEBF79C6FF285EC0893CBC93B05A4C407E4708EE6E275EC0E0EDC933DD594C40A64043F978265EC09098E326AB554C403D2E5D333D265EC025B6A76598524C40130D79511E265EC0DCEDF778EA4E4C407BDE1EAA7A265EC0EB5F8419D84A4C400413D4ADC9265EC0B438AB7C37444C40A99CEBFDD3265EC0AA1B18E5E43F4C4036D5401F5F275EC093E5980D09384C403FC4E97AB5275EC0B7FF7C9167324C40404ADC150B285EC04ED9C42CE32B4C4043054ED386285EC034882D06CE244C409E0FFE26C5285EC000D11C802A214C408E2444B220285EC0C3987EF8901D4C406F5D98565D275EC033F70EC38D184C40712DFF9A19265EC0A221B2A4F5124C40B291ACB7CA245EC02E6FE307CD0D4C40CAB9F8BF16245EC0F6A2DA76FA0A4C40D10FA7FE02235EC02F8EC2D9E2064C40539ED47DB5225EC02E815A7214034C407D3EF0DA14235EC053AFCD929AFF4B409176F6695A235EC065079F8F20FB4B40FE3F8EDF29235EC03A41F6E8E4F84B40220B9F6B15235EC038C2929C38F44B40CA68C21F01235EC0819BDAD076EE4B40433D164696225EC0F6E8859C31E94B402B1CC63E1F225EC00D896B2B74E54B405523F0E13F205EC05BF10B64EEDE4B403BB548E0071E5EC03FAAB2198BD74B40D8BCE976BA1C5EC0BAA32EE797D34B409BAC83076B1B5EC020D5E7DF48CE4B400FB14B4E7E1A5EC0E0C5332505CC4B40DDC9155DC8165EC0FED954C24EC94B40ED4841B76B135EC0878BC3C4DCC64B402B818069E00E5EC0A24AA635C1C34B402E28791D840A5EC04B2EB228ACC04B400C31FF04D8075EC099D7B7E203BF4B401567D3D620005EC056B859122DBA4B40BBC7A2A674FA5DC087AB6B069CB64B402041D16443F55DC0CC7977E75FB34B40E5C15C225DF05DC038FC3ED6DAB04B40C82775BB69EB5DC0986B42BB24AE4B40D1EAF2873EE85DC0181C112DDDAC4B4054C67C787CE25DC025C144513AAB4B40714F45DDFFDD5DC07731FE34E0A94B4080115EC1E9D55DC0523786D4A3A74B409F0E52E5D7CF5DC0FE27C11311A64B40E6748A090CCD5DC0CC63BB311DA54B4014F7907135C85DC03B990FCD48A54B40D08C80C08DC15DC0223EDE86F3A54B40D0D441172ABD5DC012759FF139A64B40BFDB1FC8AFBA5DC05CFBB0D17FA64B40B1CF356334B95DC0806F73FD4FA74B400DCBBDC5DDB55DC0577149F58DAA4B401F863519F6B45DC06879381054AB4B40	51	74	2564	70	0103000020E6100000010000000500000051C5CCA9BAA25EC0CC70E3D65E1A4A4051C5CCA9BAA25EC0BE9345AEAA494D40138594574F7C5BC0BE9345AEAA494D40138594574F7C5BC0CC70E3D65E1A4A4051C5CCA9BAA25EC0CC70E3D65E1A4A40	Northeastern BC
33	Secwepemctsín	RGB(224, 0, 0)	https://www.firstvoices.com/explore/FV/sections/Data/Secwepemc/Secwepemctsin/Secwepemc	Shuswap,Secwepemc	5		0103000020E61000000100000064010000D8D6D64721725EC00288AD67D34E494042852374EF715EC0B58F4E82334F49408F209872DA715EC076D18FAC4D504940D12545C6B2715EC099ECE19A72514940EA273B88A0715EC089D9C3D0C15249405F8486E38F715EC054664C6B95534940C4D0DFD852715EC04EE3EBAE2E544940472776CEA7705EC085FAB79FAA554940F59797421D705EC0DCE07E2A3C574940FEAB0FD0686F5EC09FEF3A079658494069484137D36B5EC0C15BDC7B105F494003EA0025CD6D5EC0F09D13CEE46449400745B20929725EC0223CA1F41469494055E36A981B765EC0A49A1B2F2A6C4940123DDDBB6D795EC05408E7E9DD6D4940CF508164DE7B5EC08514610453714940DC5CA40D177E5EC07A364B6DA6794940978CC1208B7E5EC09AFF086C747E4940C300A7997F7D5EC005D70171A48349407E9CD2971E7C5EC08D58C7153A854940108A1A9CD47C5EC01AE7D0A0668549407C60DD0C0F7E5EC06603F50EBE854940EB5BCA350F7F5EC08002FEF331864940D65E515DE07F5EC001D4362AFC864940E79CDF136D805EC080C8EC3286874940400A4B9BF7805EC01AFACC76E08849401118AEA28A815EC0B77A3EC84F8A49400CFBA1EA89825EC06BE7386CB68B4940DD15B1F87B835EC0912EE591478D4940BD959CE998845EC0A052F4BDAD8E4940D7A0AE3CD8855EC016EA15E2E79049403F84E7CF66875EC00C844042339349403C173078AA885EC08988729BBB94494093B885F88C895EC0C4F260E8C69549402B2BD047738A5EC06B7A2F2C949649402DA9FD259A8D5EC0F49A5BC3E4964940ED80B91DBE905EC097653C6670974940802986A5D9935EC0CAB4476A24984940FD207A7DC19C5EC0411D6A44789A49400A5E14E9829F5EC0858BD763139B4940AB33857D1FA25EC09EB90CBF799B4940B368086F91A45EC0EB4175BD989B4940DCA72FECD2A65EC0CABEAAC85D9B4940C6E9E42959A95EC0E28A1A70869A49404209087881AC5EC0A096075CC69849408ED9BE3C62AF5EC0EEE97BF78D964940A90F10961CB25EC01E356B4FFE9349409A7746A2A2B75EC0589D87E45C8E4940D9D26F7DFFB95EC034F233FF2F8C4940225EF107A3B85EC0183B829C3B9349403D7F024522B85EC07A9CBD49029949401201FF2440B85EC0D4762377029E4940061CB710D3B85EC04D22850454A24940545FD037B1B95EC06F59D3C50EA64940E3FAE2CF6ABC5EC074A9DDB4A4AE4940E880A137D1BC5EC0EF3A21E3F2B0494069A2922DB0BC5EC0FA5B30B321B349401EF4A64A26BB5EC058E760C6ABB849408E54C8A627B95EC0689F7EFC56BD494039F90BA8D6B65EC07B9DD30D72C14940E4284760C7B15EC06755FDF932C9494045628CEB4DAF5EC06DAD59A976CD49405A6B2E1E95AD5EC0AFB690BDDED04940FC120DA1B2AC5EC065D34F2F4DD2494051DECACB7AAB5EC05B3D4E08D4D349404BB20A3E41AA5EC05F7FBB8FFAD4494020AD7B00E6A85EC06A45043887D6494005FBB6EBF8A75EC0E9F791C501D8494085390BF910A75EC031A5523A44D94940F3C20BB719A65EC03CD123E7ABDA4940D677196813A55EC02AEEC17CFADB4940A0EF871F6FA45EC0EF9AF57981DC4940F477F1A9D4A25EC0185468855EDE49407FD6860F27A25EC0C7CC3809AFDF49405B0880B5F6A05EC04782BC8A3EE24940D630458C589F5EC00A0FBAA830E64940CC7F7D9B709E5EC08D7253296FE8494036B953740D9D5EC09F788A4E9EEA4940E4593DB8E79A5EC02F3303EE10ED494069268F084A9A5EC0F7072A7B81EE49403214766BC2995EC092223B6E3AF0494072D1EE3628995EC044AD49D2D6F049400E6AC1FF65985EC0042C9E64F4F04940D8B8CD8AD2965EC0CB61840503F1494089EFA16A61955EC0D4298E6FCFF14940F2BE820289945EC09948C108D0F2494091B9AF7EF2935EC0F8AF9C390AF44940F72E397560935EC0CE22978A77F44940B558233CE9925EC0E327984753F5494084BDE8587B925EC06ED0CB889AF6494089E64A35DB915EC0A80ED46C6FF74940748D1A9BA5915EC0654C5663A4F849408D28DB890E925EC0E29252F9D4F949401D5E88C499925EC0A9A2EAD7C9FB49403382F811EA925EC022711FB08EFC4940812BB969D1935EC0892DDAAB64FD494001B567F7F9955EC0B37B2A5E28004A400DA09587FA975EC0DC0CFF5834034A40C4EBE06F9F995EC040FDEB44AA054A402DCA7E73DD9B5EC08E623AC4C5084A4076BF06D1F29C5EC0B92AFDE0790A4A40F129C102DC9E5EC05EEEAC60970C4A40442618567DA05EC003EB7988F90E4A40618D8E47B3A35EC02951C964F4124A407F0C79D798A65EC0BE89905B0F174A40B98F78D66AA85EC0C8E6A6BC181A4A40DB38C2892DA95EC0B8565474811B4A409941CDF02DAA5EC0A801D5106C1C4A40FCD52943CAAB5EC030313654D41D4A40412F877FA8AD5EC0A5A2FDC02A204A4015931F8A48AF5EC02848F09F60224A404B08E4AB15B15EC00C571EC9CD244A405C6D15F5DAB25EC0E7E6E43810274A4069526B253DB45EC04CA1F5FF7E294A40D3EEAC9A8AB55EC01A4E0143272C4A403DBCA23541B65EC011F0F055802E4A40334676B8B8B65EC0AA50E3EE9A304A40DB2182DC6EB75EC087221C2189334A40D8E322673AB85EC03224D4E6C3354A40F19E2698EEB85EC03C5F4EA681374A4092D7B2892CB75EC0675D09923F384A4057ACFE867EB55EC0D1B85B4673384A404D1408049DB35EC073F769B35D384A4071F2E138A0B15EC0BA21EB6217384A40B178EF769AAD5EC0E23B93A4EB364A40A20EFEB24FAA5EC0313198888D364A4080FFCBC129A85EC0E84B671BA8364A407615240440A55EC0265FB8C4FC364A40A791577C0DA35EC0252E544652374A40A450BEFEB1A05EC0F302ADF668384A401F972767349E5EC0C90AB41FBB394A40267E1D06859B5EC027C7FE07663B4A404517036DC1985EC0089938BA5E3D4A407B921BB610935EC021E1B6FA96414A406E30C252B7825EC0D8FDB03C54574A4082799DB5E6805EC060045C64C2584A406331A0422A7D5EC0ACEA1354D25C4A40F99B324813785EC06158034C8A624A40239F75662D735EC0D3FA13E26E674A40318C91BA126D5EC0A0C1DE8E7F6C4A40C0DFE3362A665EC03865F9F999714A4093E4A46CDC5E5EC01DD3F485E1754A406E4339A51F4A5EC0AC89A96A61814A4067531D8E80455EC0FDF5D0880D844A402125676ED4445EC0982D0C395D844A4007D0F54E50445EC09EB31C2395844A4058AC0E6207445EC0250659D3AF844A408C038868CC435EC0478E3BA9C2844A40F1E146819B435EC0F029D9E9D6844A4015AAB5AC11435EC04284A3FAD2844A40FE507890DD415EC0A9AA32D411854A40DE2AB736333A5EC0E39E887316874A408DF17F205B245EC0FC9FF5F9178A4A40827F0A64D40B5EC0F5D9F3AA958A4A40550B9D9348F25DC0E7B8CA7434894A407DDC3FF46DD95DC028C14BACAA864A40BA17ACF9F8C25DC08CEBDB22CF834A40CC90805EEEB05DC0694E91A4B0814A407CBBB94CFDA35DC0D16890067B804A40B13F620FB09E5DC07BE7A392FF804A407609F3225A9C5DC00C36B711F6804A406CC3D9DEBE9A5DC0BE6F143356804A4006272EAAD3985DC03E24E02B0C804A40DBC68AE1B78E5DC08AF3B719FE7F4A4069CA5CBAC18B5DC05EF431ADB07F4A40B13FEF1FB1885DC09350A0D70B7F4A4085CA9D378F855DC0C8FD30AEF27D4A4074ABF03A65825DC0D8B27A4C487C4A40A0AA82763C7F5DC0020EC0D5EF794A4012F237471E7C5DC02E285F74CC764A402C47DAAEA0785DC0E66B1D5D35724A409AD72CF9AD745DC027DB13ACB86C4A40AD469DF0696E5DC01E72074DBC634A400D6517D0F66B5DC01F93E80F05604A403D777F78E3695DC0B206A624AD5C4A40E48FEF3820685DC0B7DEA61C98594A404D6395389D665DC0412BCB3EA9564A40CFF9AA834A655DC0AF099A9CC3534A409B9B201418645DC00BE43C20CA504A40E3072AD7F5625DC01F8BD1949F4D4A40B425A3B1D3615DC0CD8028AB264A4A40AF2C795192595DC048909B5D99394A40F55BBF5DB4555DC05A23FAB129304A404A8C0EBF9A4D5DC0E8DDD7BF9F244A40AEEAB65C41495DC032787B43651F4A4070BBE4560B445DC09C1F16021B194A401F4A1F37E63D5DC0C2A9403311104A406CEC1FA0213A5DC029DCCAB68A0A4A40C15A868333355DC0350E4DCAEE034A407A94F1D55F325DC01CBF007805FF4940F446DC027F2F5DC06D76E0A041FA4940806C371D072B5DC00CF3A933D3F2494075A3700970295DC04207A7A41FF04940823DA2A4EC255DC0F94EF0D141EA49408B83DBA581245DC05A5C708DF1E5494020C67A31A6185DC0F944753AABCF49407EBFB50692045DC0095536E0E6AC49406EBFB756D7EB5CC0CB7EC795558F49408228883967D85CC08118D6DBD4724940EFEFA08823CD5CC0D7E21ACFB2534940E6C5C03418D25CC0FCB44A2F524249408588A3AE94D55CC0E55F77B1653D4940A6EFBA77E5E45CC08412E3ECBF2D4940044BFD2C64F75CC003B3E20E2F274940132089CF49035DC0A250252F8A264940B04D0AEF07165DC0560639B56B2149408D2BD3756B295DC0CE18F15F3013494097AD26A4E52B5DC031175EA55F0F49404A04CBEC4D2F5DC00FEE9B1F940A49405E0CD4CFF3305DC05FD5A90031094940A4514AE269315DC0DCCE598BD5084940B2AAE3A8B6325DC0DC206F053B0649408E413FE67C345DC0C1371C413A0349404D75B8C6C5365DC077F138A1D1FC4840029DAC5034385DC0E84B4A197EF74840B669EAC0333A5DC0797669089EF348401F1A4E1AE33B5DC07F728B93E2F1484080E6C762663F5DC0944B51FFF9EC484056B4460EAD425DC0697EC0841FEA4840A8A8E40879455DC01003F10B8FE548408DAF3BC816475DC0F5BCF705FCE24840C9C033E3EF495DC0DC8E92ADDCDF48408A3E59FA784E5DC014703A30B7DA484006CE346B3F505DC03CD57A51E8D94840476A469542545DC011BF29252DD848402C0DAA52D7595DC0DE8314798FD548405C6BEE77975B5DC0EF7903AD29D54840F933F1C0BC5F5DC0C0C5E8005FD448401811D37524605DC08F2D656162D2484075B46F2214615DC026C1C150BFCD484001034D6864635DC0E3C83AA476C6484041A19D2FB2645DC0F188077F7CC24840EC0881FC6C665DC03CA2D4A06BBC48408DACA45D0E675DC0C7DEE0466BB8484087D1287672675DC008D3148CABB5484003FFC4A596685DC01A38395F66AE484058B701C323695DC0C457C04952AB4840D706A6797E695DC048D9ECDC90A6484051F9FC1F2F6A5DC06CF9EA93E0A4484051DFA487026B5DC07DCE148653A34840A989CF4EA96E5DC0A42B4B467EA14840C446C6E6F6755DC027F4ED01E7A04840A5E5313C547A5DC07342F0EBE3A148407B708EB4537E5DC0C10AACF2C5A2484064486EC682835DC0C54615D468A34840EC8DB4F52F875DC05A25F477D2A34840767FD527F8885DC0426382F381A64840D04814C6608B5DC06C6E7EF21EAA484068167B53DF8D5DC00E3124E984AC4840BD5A04706F8E5DC026E4D62F57AE4840098659D67B8F5DC0E163D3C56EB248409A4358E95B915DC0C7919D9850B9484013DD0EF3A2915DC0DF81F78625BC484031CBD58967925DC06EDFB4D5A7C2484086FF324677935DC08A279797A4C74840FBDEDC1499945DC0E11BFDCDA5CC4840A580E24DB2955DC02E9A3021FACF4840A9011CFCCC965DC0F6FF75EE19D3484040FE80D7F5975DC0AC253DE79AD648407F9132DEB8995DC07983298ECDDB48409E6A62EA5C9B5DC05AB36A6370E04840F47714ECAA9B5DC0484BADC826E148407E09C53B839D5DC0D473CC043AE54840ED81C965049E5DC0AB68F77F54E64840B295D693659F5DC0AAF5CC42F1E948406A38F2AA89A15DC0BA5CBF7F92EF4840E6C667E96DA25DC0539769D2C4F148403F35514E28A45DC0ED71274558F64840E9D953B7D6A55DC07E6C2ECD0FFB4840EE599645E2A55DC0155FA88DC9FD484082C4FF73FDA55DC0B064CFE9D401494091D85A37D5A65DC08D63A7CDC1034940B4334A824BA85DC059398912DF064940117F7DC62FAA5DC045EF83A8BC0A494070ECDA234DAB5DC0B5E8F9E8370F49405FEB5C7FAAAB5DC0E7778A334F104940193CFD13CFAC5DC03E6ECEC70D1349408E8CFCA68DAD5DC02076A975EC144940A235B3DF8CAE5DC06A8FA4BFCB1649408324F973CDAF5DC0ABDED01154194940F27D885B25B15DC08E9063B0ED1A4940C89600A70BB45DC0465C0389541E49409805B5AECEB55DC0F0FC9F9575204940056AD0F683B75DC01B66814B7A224940029AD5FD96B95DC09E889CC658254940FB1D61CC8ABA5DC0F1E169A0A2274940C3D1F5D2FDBC5DC0E2D30824CF294940DE6E472322BE5DC04BA5CD33C82A4940ED2B284392C05DC046A792D2B32C4940C080EFFDECC25DC0B8312ED17D2F49409076E4CF55C55DC0615D1F7F372F49407AE84ED5BFC55DC02BD2B8400C2F49406AD2148F6DC85DC0028FC7E1292E4940259AAA545FCB5DC07FEEBC58BB2C49401DBACDBB36CE5DC04A2B99B3022C49407D424DBE81D05DC0C8F9C3B6282C4940E4091FFDC2D15DC07FB900D95E2C4940B825989ED9D35DC0170BA809C12C4940D58762A17CD65DC039C140D9832D49405D4D3B72B2D95DC0A8F52260A72E4940A1EB6E2D45DE5DC02FC000FEFF3149402EBB326454E05DC0F0DC3F51E8334940B12DD2E4A0E15DC033F73B2876344940BE82DB7E77E45DC024ECC5A6E135494085BFF09C6EE75DC05A4712478636494015A63FB71AE95DC06E60210A57364940A997CE535FEB5DC0A5710373A036494017DD28820EEE5DC075ED74583736494050DDD897BFEF5DC069C031BAFE35494087AFE6C7E8F15DC084323078D5354940138098BB83F55DC0E0892E14B0354940CB3CB261ADFA5DC0A697A8E516354940F5FCD94F9CFC5DC0618D16DBDF3449408183DD300EFE5DC00DF108031B3449407ED9E7EDE0015EC00A90A2196D324940FEF3306DDF045EC02B3494E02B324940CBA079EAFE065EC08EAD8B3636314940EFB45E845C095EC03AF0172E7C314940FD9B5DC1070C5EC0BF2278419D30494043756C8F070F5EC071BFA025FA30494039A6F8E48D105EC09BF7FDFB8D304940CCF2958DB0115EC03F991235F02F494028F9F5F4C9145EC08FC1F7C6423049408EB35AC421185EC0C40115F4E231494049329EC20F1A5EC03FA147B4DD324940940F3ABCA71C5EC00D8ED01E2B354940AA801455991F5EC04B28D45C87374940188133640C225EC0139019F49E39494069E6BC6AC7225EC00871B307203B4940486634A6DC245EC0DAF913D9213D4940A51D816CAC255EC0D8C7AD129F3F4940817F088F03265EC0BFCEDDB2C2424940CD0F221D13295EC058660811A543494092D8BAA9192C5EC0EA6E74DB91444940E9F422E1D72F5EC0895558359F454940DC1773D597365EC0112D5EF0CB4749406FF840CB88395EC0ADEC17401E4B4940B693AC2BD93B5EC09EDCAF32AC4D49400947241CF73D5EC0F488955B08524940FCC1F2550C415EC0BE2B5EF70E544940D5F7A4DAF5435EC0C35C672DF15549404A22BA1341485EC04011EB8460574940607FC7612D4E5EC02F5745A25759494002C28CE163525EC03318F413B1594940130F122472565EC0830F35550159494045102F518F585EC086B464D7B25649409BBA7666405A5EC06E442CAC55544940ADAA8A2A015D5EC00B1159A8345049406F3BE5EC915E5EC065CC722E5C4C494005863BB32B5F5EC01E20CDE4404949407B8939BA1B625EC0418100E7084749400B9FE3256F645EC02CE5729B6F454940D7E8A62EAB675EC0BE8618F15A4549408EA9B8A2206B5EC020B1F43BD3454940BFD9B803F36E5EC09812CBE2AC494940D8D6D64721725EC00288AD67D34E4940	92	670	7345	119	0103000020E61000000100000005000000E880A137D1BC5EC027F4ED01E7A04840E880A137D1BC5EC0F5D9F3AA958A4A40EFEFA08823CD5CC0F5D9F3AA958A4A40EFEFA08823CD5CC027F4ED01E7A04840E880A137D1BC5EC027F4ED01E7A04840	Interior,Kootenay Region,Thompson/Okanagan
\.


--
-- Data for Name: language_languagefamily; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_languagefamily (id, name) FROM stdin;
1	Wakashan
2	Salishan
3	Tsimshianic
4	Athabaskan-Eyak-Tlingit
5	Xaad Kil
6	Ktunaxa
7	Algic
8	Abcd
\.


--
-- Data for Name: language_languagelink; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_languagelink (id, url, title, language_id) FROM stdin;
1	http://www.ctfn.ca/tiki-page.php?pageName=Home	Carcross/Tagish First Nation	2
2	https://www.firstvoices.com/explore/FV/sections/Data/Yukon/Tagish/Tagish	Tagish FirstVoices Archive	2
3	http://www.ammsa.com/buffalospirit/2003/footprints-AngelaSidney.html	TAngela Sidney	2
4	http://www.ydli.org/langs/sekani.htm	Yinka Déné Language Institute - Tse’khene page	3
5	http://www.languagegeek.com/dene/tsekehne/tsekehne.html	Tsek'ehne Keyboards 	3
6	http://www.stikine.net/Tahltan/tahltan.html	Tahltan Nation CD-ROM	4
7	http://www.tadmcilwraith.com/Tahltan%20Annotated%20Bibliography.pdf	An Annotated Bibliography of Tāłtān Language Materials	4
8	http://en.wikipedia.org/wiki/Tahltan_language	Wikipedia: Tahltan language	4
9	http://www.ydli.org/biblios/halkbib.htm	Bibliography of Materials on the Halkomelem Language	9
10	http://www.sfu.ca/halk-ethnobiology/html/main.htm	Halkomelem Ethnobiology	9
11	http://www.languagegeek.com/salishan/halkomelem.html	Hən̓q̓əmin̓əm̓ and Halq'eméylem Keyboards	9
12	http://www.ydli.org/biblios/sechbib.htm	YDLI: Bibliography of Materials on the Sechelt Language	10
13	http://www.languagegeek.com/nwc/nwc_keyboards.html	Download a She shashishalem Keyboard	10
14	http://www.ydli.org/biblios/squabib.htm	YDLI: Bibliography of Materials on the Squamish Language	11
15	http://www.languagegeek.com/nwc/nwc_keyboards.html	Download a Sḵwx̱wú7mesh Sníchim Keyboard	11
16	https://www.firstvoices.com/explore/FV/sections/Data/scw%CC%93exmxc%C3%8Cn/n%C5%82e%CA%94kepmxcin/n%C5%82e%CA%94kepmxcin	FirstVoices Archive	12
17	http://www.ydli.org/biblios/thombib.htm	Bibliography of Materials on the Language	12
18	http://www.languagegeek.com/salishan/nlekepmxcin.html	Nłeʔkepmxcín Keyboards	12
19	http://www.trafford.com/05-0769	(One Tree) - Counting and Colours Primer	12
20	http://www.ubcpress.ubc.ca/search/title_book.asp?BookID=4299	Thompson Ethnobotany	12
21	http://www.statimc.net/	St̓át̓imc website	13
22	http://www.uslces.org/	Upper St'át'imc Language, Culture and Education Society	13
23	http://www.maltwood.uvic.ca/statimc/default.html	Glimpses into Upper St’át’imc History through Photographs	13
24	http://www.ydli.org/biblios/lillobib.htm	Bibliography of Materials on the Lillooet Language	13
25	http://www.languagegeek.com/salishan/statimcets.html	St'át'imc Keyboards	13
26	http://www.phrasebase.com/forum/board.php?FID=323	St'át'imc Web Forum	13
27	http://www.ubcpress.ubc.ca/search/title_book.asp?BookID=1570	The Lillooet Language	13
28	http://www.ling.unt.edu/~montler/Klallam/	Klallam language	14
29	http://www.native-languages.org/klallam.htm	Native Languages of the Americas: Klallam webpage	14
30	http://en.wikipedia.org/wiki/Klallam_language	Wikipedia: Klallam	14
31	http://www.languagegeek.com/salishan/klallam.html	Nəxʷsƛ̕ay̓əmúcən Keyboard	14
32	http://www.ydli.org/products/cheryinf.htm	Cheryl Bibalhats - a children's story in Nedut'en and English	16
33	http://www.ydli.org/biblios/bwbib.htm	Bibliography of Materials on Witsuwit'en and Nedut'en	16
34	http://en.wikipedia.org/wiki/Babine-Witsuwit'en	Wikipedia: Babine-Witsuwit'en	16
35	http://www.ydli.org/pubs.htm	Yinka Dene Language Institute Publications Catalogue	16
36	http://kaska.arts.ubc.ca/	Kaska Language Website	17
37	http://www.gov.yk.ca/aboutyukon/language.html	Yukon Government - language page	17
38	http://www.firstvoices.com/scripts/WebObjects.exe/FirstVoices.woa/wa/enterLanguageArchive?archive=899265b6202904b4	Southern Tutchone FirstVoices Archive	19
39	http://www.ynlc.ca/languages/st/st.html	Yukon Native Language Centre - Southern Tutchone	19
40	http://www.ynlc.ca/languages/nt/nt.html	Yukon Native Language Centre - Northern Tutchone	19
41	http://www.treaty8.bc.ca/communities/fortnelson.php	Treaty 8 Tribal Association: Fort Nelson First Nation	20
42	http://www.ydli.org/biblios/slavebib.htm	Bibliography of Materials on the Slave Language	20
43	http://www.languagegeek.com/dene/denetha/denetha.html	Dene Tha Keyboards	20
44	http://denefont.tripod.com/	Dene Fonts	20
45	http://www.ydli.org/biblios/creebib.htm	Yinka Déné Language Institute: Bibliography of Materials on the ᓀᐦᐃᔭᐍᐏᐣ Language	21
46	http://babel.uoregon.edu/yamada/fonts/cree.html	Tᓀᐦᐃᔭᐍᐏᐣ Fonts	21
47	http://www.languagegeek.com/algon/cree/nehiyawewin.html	ᓀᐦᐃᔭᐍᐏᐣ Keyboards	21
48	http://www.nisto.com/cree/	Speak Cree	21
49	http://www.sicc.sk.ca/heritage/sils/ourlanguages/plains/plains.html	Plains Cree Resource Page (Saskatchewan)	21
50	http://cr.wikipedia.org/wiki/Main_Page	Cree Wikipedia	21
51	http://www.virtualmuseum.ca/Exhibitions/Danewajich/english/resources/language.php	Dane Wajich Dane-ẕaa Stories & Songs - Language page	22
52	http://www.livinglandscapes.bc.ca/prnr/dane_zaa/report.html	Images From a Stories Land: the Dane-zaa living landscape of northeastern BC	22
53	http://www.bcarchives.bc.ca/exhibits/journeys/english/print/forest_2_2b.html	BC Archives: Living In A Storied Land	22
54	http://www.ydli.org/biblios/haidbib.htm	Bibliography of Materials on the X̱aaydaa Kil Language	24
55	http://www.languagegeek.com/isolate/xaadas.html	X̱aaydaa Kil Keyboards	24
56	http://www.haidalanguage.org/	X̱aat Kíl - The Haida Language	24
57	http://kavilco.com/pages/khhfprojects.html	Kasaan Elders Speak	24
58	http://www.uaf.edu/anlc/publications.html	Alaska Native Language Center Publications	24
59	http://www.umista.org/home/index.php	U'mista Cultural Society	29
60	https://www.firstvoices.com/explore/FV/sections/Data/Kwak'wala/Kwak%CC%93wala/Kwak%CC%93wala	FirstVoices: Kwak̓wala Community Portal	29
61	http://www.ydli.org/biblios/kwabib.htm	Bibliography of Materials on the Kwak̓wala Language	29
62	http://www.languagegeek.com/wakashan/kwakwala.html	Kwak̓wala Keyboards	29
63	http://books.trafford.com/05-0766	ʼNa̱m Ła̱nx̱a Ḵ̕wax (One Green Tree) - Counting and Colours Primer	29
64	http://jan.ucc.nau.edu/~jar/RIL_4.html	Reversing Language Shift: Can Kwak̓wala Be Revived?	29
65	http://guweb2.gonzaga.edu/kalispel/index.html	Language of the Kalispel	30
66	http://guweb2.gonzaga.edu/kalispel/dictionary.pdf	Analysis of the dictionary provided on the above site	30
67	http://www.coyotepress.com/cgi-bin/cyp455/333.html	The Kalispel Language: An Outline of the Grammar with Texts	30
68	http://www.gitxsan.com/	Gitx̱san Chiefs' Office	31
69	http://www.ydli.org/biblios/gitbib.htm	Bibliography of Materials on the Gitksan Language	31
70	http://www.kispioxadventures.com/english/general/radio.htm	Kispiox FN Community Radio	31
71	http://www.secwepemc.org	Secwepemc Cultural Education Society	33
72	http://www.firstvoices.com/en/Secwepemc	FirstVoices: Secwepemc	33
73	http://www.firstvoices.com/en/Secwepemctsin	FirstVoices: Secwepemc (Eastern Dialect)	33
74	http://www.firstvoices.com/en/Splatsin	FirstVoices: Splatsin (Eastern dialect)	33
75	http://www.ydli.org/biblios/shusbib.htm	Bibliography of Materials on the Secwepemc Language	33
76	http://www.languagegeek.com/salishan/secwepemctsin.html	Secwepemc keyboard	33
77	http://landoftheshuswap.com/msite/catahms.php?PHPSESSID=63d8481eaafae24e12db0083edc41b70://	Chief Atahm School (Secwepemctsin immersion program)	33
78	http://www.landoftheshuswap.com/msite/lang.php	Secwepemctsin – Language of the Secwepemc	33
79	http://books.trafford.com/05-1479	Set.setsíntns re Stsmémelt (Children’s Songs)	33
80	http://www.ydli.org/biblios/kootbib.htm	Yinka Déné Language Institute: Bibliography of Materials on the Kootenay Language	35
81	http://www.languagegeek.com/isolate/ktunaxa.html	Language Geek: Ktunaxa Keyboards	35
82	http://www.ktunaxa.org/ktuqcqakyam/index.html	Ktuq̓¢qakyam News	35
83	http://www.ktunaxa.org/fourpillars/language/changinghistory.html	Strategic Plan - Ktunaxa Language	35
84	http://www.trafford.com/05-0771	N̕uk̓iʔni Kak̓aquxmaqa ʔaki¢ǂaʔin (One Green Tree)	35
85	http://www.designingnations.com/Ktunaxa.htm#Ktunaxa%20Words	Ktunaxa Words	35
86	http://www.firstvoices.com/scripts/WebObjects.exe/FirstVoices.woa/wa/enterLanguageArchive?archive=4ff342906f1cbae4	Ktunaxa FirstVoices Archive	35
87	https://www.firstvoices.com/explore/FV/sections/Data/nsyilxc%C9%99n/nsyilxc%C9%99n/nsyilxc%C9%99n	FirstVoices: nsyilxcən Community Portal	36
88	http://www.ydli.org/biblios/okabib.htm	Bibliography of Materials on the Okanagan Language	36
89	http://www.languagegeek.com/nwc/nwc_keyboards.html	Nsyilxcən Keyboard	36
90	http://www.ydli.org/biblios/saubib.htm	Yinka Déné Language Institute: Bibliography of Materials on the Saulteau Language	37
91	http://www.languagegeek.com/algon/ojibway/anishinaabemowin.html	Langauge Geek: Anishnaubemowin Keyboards	37
92	http://www.ydli.org/biblios/tsetbib.htm	Yinka Déné Language Institute: Bibliography of Materials on the Tsetsaut Language	39
93	http://www.ydli.org/bcother/chinook.htm	Chinook Jargon	43
94	http://tenaswawa.home.att.net/	Tenas Wawa - The Chinook Jargon Voice	43
\.


--
-- Data for Name: language_languagemember; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_languagemember (id, user_id) FROM stdin;
\.


--
-- Data for Name: language_languagesubfamily; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_languagesubfamily (id, name, family_id) FROM stdin;
1	Algonquian	7
2	Dene (Athabaskan)	4
3	Tlingit	4
4	Coast Salish	2
5	Interior Salish	2
6	Nuxalk	2
\.


--
-- Data for Name: language_lna; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_lna (id, language_id, name, year) FROM stdin;
13	9	LNA5952 - Seyem' Qwantlen Business Group	2015
14	38	LNA5953 - Kitasoo/Xai'xais First Nation	2015
15	9	LNA5954 - Shxwha:y Village	2015
16	36	LNA5955 - First Nation	2015
18	33	LNA5960 - Spi7uy Squqluts Language & Culture Society	2015
19	25	LNA5962 -  Yuułuʔiłʔath Government	2015
20	18	LNA5964 - Yekooche First Nation	2015
21	4	LNA5965 - Tahltan Central Government	2015
22	36	LNA5968 - Upper Similkameen Indian Band	2015
23	24	LNA5969 - Skidegate Haida Immersion Program	2015
24	6	LNA5970 - Wuikinuxv Kitasoo Nuxalk Tribal Council	2015
25	9	LNA5971 - Tsleil-Waututh Nation	2015
26	15	LNA5972 - W̱SÁNEĆ School Board	2015
27	31	LNA5973 - Gitwangak Eductaion Society/Gitwangak Band	2015
29	15	LNA5975 - Songhees First Nation	2015
30	33	LNA5977 - Skeetchestn Indian Band	2015
31	23	LNA5978 - Taku River Tlingit First Nation	2015
32	5	LNA5981 - Alexis Creek First Nation	2015
33	9	LNA5983 - CSETS	2015
34	26	LNA5986 - Lake Cowichan First Nation	2015
35	13	LNA5987 - Lilwat Nation	2015
37	9	LNA5992 - Kwikwetlem First Nation	2015
38	29	LNA6000 - Tlowitsis First Nation	2016
40	12	LNA6004 - Boston Bar First Nation	2016
41	29	LNA6005 - Laich-Kwil-Tach Research Centre	2016
42	25	LNA6009 - Uchucklesaht Tribe Government	2016
43	32	LNA6010 - Wilp Wilxo'oskwhl Nisga'a Institute	2016
44	33	LNA6012 - Splatsin Tsm7aksaltn Teaching Centre Society	2016
45	9	LNA6014 - First Nation	2016
46	29	LNA6016 - Da'naxda'xw First Nation/Tsatsisnukwomi Village	2016
47	15	LNA6018 - Esquimalt Nation	2016
48	15	LNA6020 - Tsawout First Nation	2016
49	25	LNA6021 - Ahousaht Education Authority	2016
50	9	LNA6022 - Stolo Service Agency	2016
51	5	LNA6023 - Xeni Gwet'in First Nation	2016
52	9	LNA6024 - Musqueam First Nation	2016
53	9	LNA6026 - Seabird Island Band	2016
54	12	LNA6027 - Shackan Indian Band	2016
56	31	LNA6030 - Gitanmaax Band Council	2016
57	13	LNA6031 - Ts'kw'aylacw First Nation	2016
58	15	LNA6032 - Tseycum First Nation	2016
59	3	LNA6035 - Kwadacha Nation	2016
60	25	LNA6036 - Nuchatlaht Tribe	2016
62	5	LNA6038 - Yunesit'in	2016
63	18	LNA6039 - Lhoosk'uz Dene Nation	2016
64	13	LNA6041 - Upper St'at'imc Language, Culture and Education Society	2016
65	25	LNA6043 - Ḵa:’yu:’k’t’h’-Che:ḵ’tles7et’h’ First Nations	2016
66	25	LNA6044 - Ehattesaht Chinehkint	2016
67	36	LNA6045 - Penticton Indian Band	2016
68	16	LNA6047 - Moricetown Band	2016
69	13	LNA6048 - Xaxli'p First Nation	2016
70	15	LNA6050 - Coast Salsih Employment & Training Society	2016
71	13	LNA6052 - Tsal'alh (Seton Lake Band)	2016
72	17	LNA6058 - Daylu Dena Council	2016
73	31	LNA6063 - Gitanyow Independent School Society	2016
74	33	LNA6064 - Neskonlith Indian Band	2016
75	5	LNA6066 - Tl'etinqox Government Office	2016
77	25	LNA6068 - Port Alberni Friendship Center	2016
78	36	LNA6069 - The Paul Creek Language Association	2016
79	27	LNA6070 - Heiltsuk Tribal Council	2016
81	29	LNA6074 - Sacred Wolf Friendship Center	2016
82	13	LNA6075 - N'Quatqua Child and Family Development Centre	2016
83	33	LNA6076 - Shuswap Indian Band	2016
84	33	LNA6087 - Spi7uy Squqluts Language & Culture Society	2016
85	25	LNA6090 - Yuutu it ath Government	2016
86	7	LNA268 - Haisla Education and Learning Society	2005
87	5	LNA573 - Ulkatcho First Nation	2007
88	9	LNA618 - Sto:lo Nation	2007
89	9	LNA679 - Beecher Bay First Nations	2007
90	9	LNA711 - Pauquachin First Nation	2007
91	34	LNA686 - Lax Kw'alaams Band	2007
92	12	LNA974 - Ashcroft Indian Band	2008
93	35	LNA1188 - St Mary's Indian Band	2009
94	16	LNA2112 - Skin Tyee First Nation	2011
95	12	LNA1789 - Nlaka'pamux Nation Tribal Council	2011
96	16	LNA2258 - Lake Babine Nation	2011
98	29	LNA2932 - First Nation	2013
99	9	LNA2186 - Coqualeetza Cultural Education Centre	2013
100	33	LNA3076 - Bonaparte Indian Band	2013
101	22	LNA2965 - Tribal Council	2013
103	18	LNA1870 - Carrier Sekani Tribal Council	2010
104	33	LNA2580 - High Bar First Nation	2011
105	16	LNA2273 - Nee Tahi Buhn First Nation	2011
106	18	LNA2669 - Nazko First Nation	2012
1	9	LNA5933 - CNC	2015
3	11	LNA5937 - Kwi Awt Stelmexw	2015
4	25	LNA5938 - Mowachaht/Muchalaht	2015
5	34	LNA5939 - Kitselas First Nation	2015
6	25	LNA5941 - Port Alberni Friendship Center	2015
7	8	LNA5943 - Klahoose First Nation	2015
9	18	LNA5947 - Lheidli T'enneh Band	2015
10	29	LNA5948 - UBC Faculty of Forestry	2015
11	9	LNA5949 - Musqueam First Nation	2015
12	31	LNA5951 - Anspayxw Three Crests Society	2015
120	22	LNA3346 - Blueberry First Nations School	2014
121	22	LNA3349 - West Moberly First Nations	2014
122	29	LNA3187 - Gilford Island Soccer Club	2014
123	10	LNA3314 - Sechelt Nation	2014
124	21	LNA3414 - Saulteau First Nations	2014
125	25	LNA3430 - Tla-o-qui-aht First Nations	2014
126	33	LNA3443 - shuswap Indian Band	2014
127	20	LNA3342 - Fort Nelson First Nation	2014
129	28	LNA3446 - Wuikinuxv Nation	2014
130	33	LNA3174 - Whispering Pines/ Clinton Indian Band	2014
131	22	LNA2413 - Doig River First Nation	2014
132	9	LNA3322 - Peters Band Office	2014
133	9	LNA3448 - Yakweakwioose Band 	2014
134	35	LNA3457 - Tobacco Plains Indian Band	2014
135	35	LNA3459 - Lower Kootenay Band 	2014
136	33	LNA3498 - Simpcw First Nation	2015
137	25	LNA3541 - Hupačasath First Nation	2015
139	35	LNA3540 - Aqam (St. Mary's Indian Band Administration)	2015
140	18	LNA3664 - Tl'azt'en Nation	2015
141	18	LNA3656 - Denisiqi Services Society	2015
142	3	LNA3655 - McLeod Lake Indian Band	2015
143	26	LNA3637 - Pacheedaht First Nation	2015
144	34	LNA3474 - Gitxaala Environmental Monitoring	2015
145	24	LNA3327 - Skidegate Band Council 	2015
146	3	LNA3771 - Tsay Keh Dene	2015
147	16	LNA3598 - Wet'suwet'en First Nation	2015
149	13	LNA3762 - Head of the Lake School	2015
150	31	LNA3750 - Gitksan Wet'suwet'en Education Society	2015
151	29	LNA3748 - Gwa'sala-'Nakwaxda'xw Nation	2015
152	29	LNA3732 - Quatsino First Nation	2015
153	33	LNA3674 - Adams Lake Indian Band	2015
154	18	LNA3588 - Nezul Be Hunuyeh Child & Family Services Society	2015
155	9	LNA3550 - Si'em Media Society	2015
156	18	LNA3469 - Lhtako Dene Nation 	2015
157	9	LNA3466 - Shxw'owhamel First Nation	2014
158	22	LNA3464 - Halfway River First Nation	2014
159	25	LNA3318 - Toquaht Nation	2015
160	25	LNA3758 - Tseshaht First Nation	2015
161	25	LNA3337 - Ahousat	2014
163	9	LNA3842 - Sto:lo Shxweli Halq'emeylem Language program	2015
164	9	LNA2172 - Sts'ailes Community School, Sts'ailes Indian Band	2012
165	9	LNA3802 - Katzie First Nation	2015
166	27	LNA6092 - Hailika'as Heiltsuk Health Centre Society	2016
167	15	LNA6094 - Songhees Nation	2016
168	4	LNA6095 - Tahltan Central Government	2016
169	38	LNA6096 - Kitasoo/Xai'xais First Nation	2016
170	36	LNA6097 - Okanagan Indian Band	2016
171	27	LNA6098 - Kitasoo/Xai'xais First Nation	2016
173	33	LNA6101 - Skeetchestn Indian Band	2016
174	33	LNA6103 - Chief Atahm School	2016
176	18	LNA6106 - Lhtako Dene Nation	2016
177	18	LNA6107 - Ulkatcho First Nations 	2016
178	12	LNA6108 - Nicola Tribal Association	2016
179	36	LNA6111 - Upper Nicola Band 	2016
180	33	LNA6113 - Tk'emlups te Secwepemc	2016
181	9	LNA6114 - Kwikwetlem First Nation	2016
182	36	LNA6115 - Nk'Mip Desert Cultural Centre / Osoyoos Indian Band 	2016
183	36	LNA6116 - Syilx Language House Association	2016
184	9	LNA6117 - Yale First Nation	2016
185	33	LNA6118 - Splatsin Tsm7aksaltn	2016
186	3	LNA6121 - Kwadacha Nation	2016
187	9	LNA6123 - Musqueam First Nation	2016
188	11	LNA6124 - Squamish Nation	2016
189	24	LNA6125 - Skidgate Band Council	2016
190	9	LNA6128 - Hwualumqun Heritage Language Society	2016
191	29	LNA6129 - Gwa'sala-'Nakwaxda'xw School	2016
192	20	LNA6130 - Chalo School	2016
193	25	LNA6131 - Nuchatlaht Tribe	2016
194	34	LNA6132 - Gitxaala Ntaion	2016
195	8	LNA6134 - Klahoose First Nation	2016
197	11	LNA6137 - Kwi Awt Stelmexw (KAS Cultural Society)	2016
198	25	LNA6138 - Hesquiaht Language Program	2016
199	21	LNA6139 - West Moberly First Nations	2016
200	36	LNA6140 - En'owkin Centre, Okanagan Indian Resources Society	2016
201	5	LNA6142 - Alexis Creek First Nation	2016
202	15	LNA6144 - Tseycum First Nation	2016
203	9	LNA6145 - Tsleil-Waututh First Nation	2016
204	29	LNA6146 - T̓łisa̱lagi’lakw School	2016
205	29	LNA6149 - SD85 & Tsasala Cultural Group	2016
206	27	LNA6153 - Bella Bella Community School	2016
207	6	LNA6154 - Acwsalcta School	2016
208	13	LNA6156 - Lilwat 	2016
209	33	LNA6159 - High Bar First Nation	2016
210	36	LNA6160 - Syilx Language House Association	2016
211	15	LNA6161 - Tsawout First Nation	2016
212	9	LNA6163 - Simon Fraser University	2016
108	18	LNA2504 - Saik'uz First Nation	2012
109	9	LNA2940 - Lyackson First Nation	2013
111	9	LNA3080 - Tsawwassen First Nation	2013
112	16	LNA1772 - Cheslatta Carrier Nation	2011
113	9	LNA3228 - Soowahlie First Nation	2014
114	8	LNA3159 - Homalco	2014
116	34	LNA3316 - Gitga'at First Nation	2014
117	29	LNA3234 - Upper Island Women of Native Ancestry	2014
118	15	LNA3328 - Semiahmoo First Nation	2014
119	29	LNA3320 -  Gwawaenuk Finance Office	2014
226	9	LNA6187 - Quw'utsun Syuw'entst Lelum - Cowichan Tibes	2017
227	18	LNA6188 - Lheidli T'enneh	2017
228	9	LNA6189 - Seyem' Qwantlen	2017
229	33	LNA6190 - Simpcw First Nation	2017
230	5	LNA6191 - Yunesit'in Government	2017
231	25	LNA6192 - Ehattesaht Chinehkint	2017
232	31	LNA6193 - Simgiget'm Gitwangak Society	2017
233	29	LNA6194 - Kwakiutl Band Council	2017
234	29	LNA6195 - Sacred Wolf Friendship Center	2017
235	36	LNA6196 - Penticton Indian Band	2017
236	8	LNA6197 - Homalco First Nation	2017
237	25	LNA6199 - Tlaoquiaht First Nation	2017
238	31	LNA6201 - gitwangak Band	2017
239	12	LNA6202 - Lower Nicola Indian Band	2017
240	32	LNA6203 - NLG, Ayuuḵhl Nisg̱a’a Department	2017
241	24	LNA6204 - Haida Health Center	2017
242	5	LNA6217 - N/A	2017
243	12	LNA6219 - Lower Nicola Indian Band	2017
244	13	LNA6220 - Skatin	2017
245	5	LNA6220 - Ulkatcho Indian Band	2017
247	33	LNA6223 - Neskonlith 	2017
248	13	LNA6224 - Xa'xtsa	2017
249	33	LNA6225 - Tk'emlups te Secwepemc	2017
250	18	LNA6227 - Ulkatcho First Nation	2017
251	13	LNA6228 - Samahquam	2017
253	25	LNA6230 - Mowachaht/Muchalaht First Nation	2017
254	35	LNA6231 - Aqam	2017
256	15	LNA6233 - W̱SÁNEĆ School Board	2017
257	36	LNA6234 - The Paul Creek Language Association	2017
258	13	LNA6235 - N'Quatqua	2017
259	13	LNA6236 - Xaxli'p	2017
260	31	LNA6239 - Gitxsan Health Society	2017
261	9	LNA6240 - Malahat	2017
262	31	LNA6241 - Gitxsan Health Society	2017
263	33	LNA6248 - Spi7uy Squqluts Language & Culture Society	2018
264	34	LNA6249 - Ts'msyen Sm'algya̱x Language Authority	2018
265	34	LNA6250 - Kitsumkalum Band Council	2018
266	36	LNA6251 - Syilx Language House Association 	2018
267	25	LNA6253 - Port Alberni Friendship Center	2018
268	38	LNA6256 - Kitasoo/Xai'xais First Nation	2018
269	11	LNA6260 - Squamish Nation	2017
270	9	LNA6262 - Seabird Island Band	2018
271	25	LNA6265 - Ahousat Education Authority	2018
272	24	LNA6266 - Skidegate Band Council	2018
273	18	LNA6267 - Tl'azt'en Nation	2018
274	7	LNA6268 - Haisla Nation Council 	2018
276	17	LNA6270 - Dease River First Nation	2018
277	33	LNA6271 - Splatsin 	2018
278	27	LNA6272 - Kitasoo/Xai'xais First Nation	2017
279	18	LNA6273 - Saik'uz First Nation	2018
280	25	LNA6274 - Yuułuʔiłʔatḥ Government	2018
281	18	LNA6275 - Stellat'en First Nation Band	2018
282	25	LNA6276 - Hequiaht Language Program	2018
284	18	LNA6278 - Lhtako Dene Nation	2018
285	33	LNA6279 - Adams lake Indian band	2018
286	31	LNA6280 - Gitsegukla elementary school	2018
287	9	LNA6281 - Kwantlen First Nation	2018
288	36	LNA6282 - Okanagan Indian Band	2018
289	16	LNA6283 - Carrier Sekani Family Services	2018
290	12	LNA6284 - Lytton First Nation 	2018
291	18	LNA6285 - Nakazdli	2018
293	21	LNA6287 - West Moberly First Nations	2018
294	13	LNA6288 - Lilwat Nation	2018
295	8	LNA6293 - Klahoose First Nation 	2018
296	21	LNA6294 - Blueberry River First Nations	2018
297	31	LNA6295 - Simgiget'm Gitwangak (Hereditary Chiefs)	2018
298	6	LNA6296 - NAALS	2018
299	36	LNA6297 - Syilx Language House Association	2018
300	15	LNA6298 - Esquimalt Nation	2018
301	22	LNA6299 - Prophet River First Nation	2018
302	26	LNA6300 - Ditidaht First Nation	2018
304	36	LNA6302 - Upper Nicola Band	2018
305	22	LNA6303 - Halfway River First Nation	2018
306	12	LNA6304 - Kanaka Bar Indian Band	2018
307	36	LNA6305 - Osoyoos Indian Band	2018
308	25	LNA6306 - Mowachaht/Muchalaht First Nation	2018
309	9	LNA6307 - Snaw-naw-as Health Centre	2018
310	26	LNA6309 - Ditidaht community school 	2018
311	13	LNA6310 - T'it'q'et Administration	2018
313	15	LNA6312 - W̱SÁNEĆ School Board	2018
314	31	LNA6313 - Gitanyow Independent School 	2018
315	31	LNA6314 - Gitanyow Independent School 	2018
316	9	LNA6315 - Katzie First Nation	2018
317	3	LNA6316 - Kwadacha Nation	2018
318	18	LNA6317 - Lheidli T'enneh Band	2018
319	33	LNA6319 - Skeetchestn Indian Band	2018
320	13	LNA6320 - Bridge River Indian Band	2018
321	23	LNA6321 - Axh Toowu At Wudikein Association	2018
322	5	LNA6322 - Alexis Creek First Nation	2017
215	25	LNA6169 - Mowachaht/Muchalaht First Nation	2017
216	32	LNA6170 - Wilp Wilx̱o'oskwhl Nisg̱a'a Institute	2017
217	29	LNA6171 - Laich-Kwil-Tach Treaty Society	2017
218	9	LNA6172 - Penelakut Tribe	2017
219	25	LNA6174 - Uchucklesaht Tribe Government	2017
220	18	LNA6175 - Takla Lake First Nation 	2017
221	34	LNA6177 - Kitselas First Nation	2017
223	33	LNA6180 - Skeetchestn Indian Band	2017
224	33	LNA6182 - Tk'emlups te Secwepemc	2017
225	9	LNA6185 - Snuneymuxw First Nation	2017
334	22	LNA6340 - Blueberry River First Nations	2018
335	9	LNA6341 - Qayqayt First Nation	2018
336	15	LNA6342 - Beecher Bay First Nation	2018
337	9	LNA6343 - Beecher Bay First Nation	2018
338	21	LNA6344 - Fort Nelson First Nation - Chalo School	2018
339	18	LNA6345 - Takla Lake First Nation	2018
340	35	LNA6346 - Ktunaxa nation Council	2018
341	29	LNA6348 - Tlowitsis First Nation	2018
342	16	LNA6351 - Wet'suwet'en First Nation	2018
343	9	LNA6352 - Sto:lo	2018
345	12	LNA6357 - Citxw Nlaka'pamux	2018
346	38	LNA6359 - Kitasoo/Xai'xais First Nation	2018
347	16	LNA6360 - Witsuwit'en Language and Culture Society	2018
348	33	LNA6362 - Williams Lake Indian Band/Shuswap	2018
349	32	LNA6363 - Nisga'a Village of Gitwinksihlkw	2018
350	9	LNA6365 - Stz'uminus First Nation	2018
351	5	LNA6367 - Yunesit'in Governement	2018
352	9	LNA6368 - Snuneymuxw First Nation	2018
353	29	LNA6370 - 'Na̱mg̱is First Nation	2018
354	15	LNA6378 - Songhees Nation	2018
355	15	LNA6379 - Esquimalt	2018
356	33	LNA6380 - Tk'emlups te Secwepemc	2018
357	35	LNA6381 - Lower Kootenay Indian Band	2018
358	29	LNA6382 - Laich-Kwil-Tach Treaty Society	2018
359	29	LNA6383 - Laich-Kwil-Tach Treaty Society	2018
360	22	LNA6385 - Doig River First Nation	2018
361	11	LNA6386 - Tsleil-Waututh Nation	2018
363	27	LNA6389 - Heiltsuk First Nation	2018
364	25	LNA6390 - Language Keepers Society	2018
365	9	LNA6392 - Cowichan Tribes 	2018
366	9	LNA6397 - Georgetown Snuw'uy'ulh	2018
367	35	LNA6399 - Ktunaxa Nation	2018
368	9	LNA6400 - Cheam First Nation	2018
370	25	LNA6403 - Tseshaht	2018
371	9	LNA6405 - Sts'ailes (formerly known as:  Chehalis Indian Band)	2018
372	13	LNA6407 - Upper St'at'imc Language, Culture and Education Society	2018
373	29	LNA6408 - Gwa'sala-'Nakwaxda'xw School	2018
374	9	LNA6411 - Penelakut Island School	2018
375	9	LNA6413 - Hul'q'umi'num' Language & Culture Collective	2018
376	25	LNA6414 - Mowachaht/Muchalaht First Nation	2018
377	33	LNA6415 - Skeetchestn Indian Band	2018
378	36	LNA6416 - En'owkin Centre	2018
379	29	LNA6417 - Sacred Wolf Friendship Centre	2018
381	33	LNA6419 - Simpcw First Nation	2018
382	9	LNA6423 - Katzie First nation	2018
383	27	LNA6425 - Hailika'as Heiltsuk Health Centre Society	2018
385	12	LNA6435 - Lower Nicola Indian Band	2018
386	18	LNA6436 - Ulkatcho First Nations	2018
387	33	LNA6437 - Tk'emlups te Secwepemc	2018
388	36	LNA6439 - Penticton Indian Band	2018
389	8	LNA6440 - Homalco First Nation	2018
390	25	LNA6442 - Ahousat Education Authority	2018
391	31	LNA6443 - Gitanyow Daycare	2018
392	28	LNA6457 - Wuikinuxv  Nation	2018
393	25	LNA6459 - Tseshaht First Nation	2018
394	13	LNA6462 - Simon Fraser University	2018
395	9	LNA6463 - Mission Friendship Centre Soceity 	2018
396	35	LNA6464 - Tobacco Plains Indian Band	2018
397	13	LNA6466 - Xaxli'p 	2019
398	32	LNA6467 - Wilp Wilxo'oskwhl Nisga'a Institute	2019
399	34	LNA6468 - Gitga'at	2019
400	12	LNA6469 - Nicola Tribal Association	2019
402	24	LNA6473 - X̱aad Kil Nee, Haida Nation	2019
403	11	LNA6475 - Squamish Nation	2019
404	33	LNA6476 - Shuswap Indian Band	2019
405	36	LNA6478 - Westbank First Nation	2019
406	9	LNA6479 - Seabird Island Band	2018
407	32	LNA6480 - Gingolx Village Government	2018
408	5	LNA6481 - Esdilagh First Nations	2018
410	32	LNA6484 - Ayuuḵhl Nisg̱a’a Department, Nisg̱a’a Lisims Government	2019
411	12	LNA6485 - piyeʔwiʔx kt Language Foundation Society	2019
412	3	LNA6486 - McLeod Lake Indian Band	2019
413	33	LNA6487 - Thompson Rivers University 	2019
415	36	LNA6489 - Penticton Indian Band	2019
416	16	LNA6492 - Old Fort Economic Development Society	2019
417	9	LNA6493 - Nanoose	2019
418	33	LNA6494 - Esk’etemc	2019
419	4	LNA6495 - Tahltan Central Government	2019
420	32	LNA6496 - Nisga'a Village of Gitwinkihlkw	2019
421	9	LNA6498 - Lower Fraser Valley Aboriginal Society	2018
422	31	LNA6499 - Gitxsan Wet'suwet'en Education Society	2019
423	31	LNA6500 - Gitxsan Wet'suwet'en Education Society	2019
424	31	LNA6501 - Gitxsan Wet'suwet'en Education Society	2019
425	23	LNA6503 - Children Of The Taku Society	2019
426	25	LNA6505 - Ehattesaht Chinehkint	2019
427	24	LNA6506 - Chief Matthews School	2019
323	29	LNA6323 - Da'naxda'xw/Awaetlala	2018
325	25	LNA6327 - Toquaht Nation	2018
326	8	LNA6329 - Tla'amin First Nation	2018
327	9	LNA6330 - Organization	2018
328	5	LNA6332 - Denisiqi Services Society 	2018
329	32	LNA6334 - Wilp Wilxo'oskwhl Nisga'a	2018
330	9	LNA6335 - Scowlitz First Nation	2018
331	12	LNA6336 - Boothroyd Band	2018
332	33	LNA6337 - Skwlax (Little Shuswap) First Nation	2018
333	9	LNA6339 - Kwaw-kwaw-aplit First Nation	2018
463	18	LNA6548 - Lhtako Dene Nation	2019
464	25	LNA6549 - Ahoiusat Education Authority	2019
465	5	LNA6550 - Punky Lake WIlderness Camp Society	2019
466	18	LNA6553 - Maiyoo Keyoh Society	2019
467	18	LNA6554 - Takla Lake First Nation 	2019
2	12	LNA5936 - Nicola Tribal Association	2015
8	36	LNA5944 - Syilx Language House Association/Syilx First Nation	2015
162	34	LNA3860 - 'Na Aksa Gyilak'yoo School - Kitsumkalum	2015
172	16	LNA6100 - Old Fort Economic Development Society	2016
175	16	LNA6105 - Wet'suwet'en First Nation/Wet'suwet'en Elder and Youth Education Society	2016
196	32	LNA6136 - Gitlaxt'aamiks Village Government	2016
214	9	LNA6168 - Shxw'owhamel First Nation	2017
246	25	LNA6221 - Ahousat Education Authority	2017
255	29	LNA6232 - Dzawada'enuxw Health and Social Development Centre	2017
344	33	LNA6354 - Shuswap Nation Tribal Council	2018
369	15	LNA6402 - W̱SÁNEĆ School Board	2018
384	25	LNA6427 - Ka:'yu:'k't'h' / Che:k:tles7et'h' First Nations	2018
409	11	LNA6482 - Sea to Sky Learning Connections - Cultural Journeys and Learning Expeditions	2019
414	15	LNA6488 - PEPÁḴEṈ HÁUTW̱ Native Plant and Garden Program located on  W̱JOȽEȽP	2018
428	9	LNA6507 - Coqualeetza Cultural Education Centre	2019
430	9	LNA6509 - Kwikwetlem First Nation 	2018
432	29	LNA6511 - Lilawagila School	2019
434	13	LNA6515 - Lillooet Friendship Centre Society	2019
435	13	LNA6516 - Lilwat Nation	2019
436	26	LNA6518 - Ditidaht Community School	2019
437	9	LNA6519 - Penelakut Tribe	2019
438	9	LNA6520 - Leq'á:mel First Nation	2019
439	9	LNA6520 - Skwah First Nation	2019
440	3	LNA6521 - McLeod Lake Indian Band	2019
441	5	LNA6522 - Alexis Creek First Nation	2019
442	29	LNA6524 - Hase Revitalization Society 	2019
443	35	LNA6525 - Aqam 	2019
444	18	LNA6526 - Nak'azdli Whut'en	2019
445	31	LNA6527 - Gitxsan Child and Family Services Society	2019
446	34	LNA6528 - Kitselas First Nation (Community Elders Group)	2018
447	33	LNA6529 - Tk'emlups te Secwepemc	2019
448	31	LNA6530 - Gitxsan Child and Family Services Society	2019
449	25	LNA6531 - Huu-ay-aht First Nation	2019
450	36	LNA6532 - Penticton Indian Band	2019
451	12	LNA6533 - Coldwater School	2019
452	12	LNA6534 - Coldwater School	2019
453	29	LNA6535 - Musgmagw Dzawada'enuxw Tribal Council	2019
454	13	LNA6536 - Pa'La7Wit Society of the Lower Lillooet Lake	2019
455	9	LNA6539 - Kwantlen First Nation 	2019
456	13	LNA6540 - In-Shuck-Ch Services Society DBA Samahquam Services Society	2019
457	36	LNA6541 - Lower Similkameen Indian Band	2019
458	9	LNA6542 - Tsawwassen First Nation	2019
459	9	LNA6543 - Qualicum First Nation	2019
460	29	LNA6544 - Nuyumbalees Cultural Centre	2019
461	18	LNA6545 - Stellat'en First Nation Band	2019
17	12	LNA5958 - Lower Nicola Indian band	2015
28	36	LNA5974 - En'owkin Centre, Okanagan Indian Resources Society	2015
36	27	LNA5988 - Hailika'as Heiltsuk Health Centre Society	2015
39	12	LNA6003 - Lytton First Nation Health - Nlaka'pamux Nation Tribal Council	2016
55	9	LNA6028 - Coast Salish Employment & Training Society	2016
61	29	LNA6037 - We Wai Kum Treaty Liq'wala Revitalization Committee	2016
76	26	LNA6067 - Asaabuus Daycare/Ditidaht First Nation	2016
80	32	LNA6071 - Nisga'a Village of Gitwinksihlkw	2016
110	15	LNA2975 - T'Sou-ke First Nation 	2013
138	5	LNA3514 - Tsilhqot'in National Government	2015
292	25	LNA6286 - Ehattesaht Chinehkint Tribe	2018
303	31	LNA6301 - Gitksan Wet'suwet'en Education Society	2018
324	33	LNA6325 - Stswecem'c Xgat'tem First Nation	2018
462	18	LNA6547 - Quesnel Dakelh Education & Employment	2019
97	33	LNA2845 - Secwepemc Cultural Education Society	2013
107	9	LNA2712 - Scowlitz	2012
115	29	LNA3304 - Lilawagila School / Dzawada'enuxw First Nation	2014
128	8	LNA3230 - Sliammon, Klahoose and Homalco	2014
148	33	LNA3730 - Tk'emlups te Secwepemc (Kamloops Indian Band)	2015
213	18	LNA6167 - Nadleh Whut'en Indian Band	2016
222	16	LNA6179 - Witsuwit'en Language and Culture Society/Moricetown Band	2017
252	9	LNA6229 - Hul'q'umi'num' - Gulf Islands National Park Reserve Committee	2017
275	4	LNA6269 - Tahltan Central Government	2018
283	11	LNA6277 - KAS Cultural Society (Kwi Awt Stelmexw)	2018
312	29	LNA6311 - ̱'Na̱mg̱is First Nation	2018
362	26	LNA6387 - Pacheedaht First Nation	2018
380	33	LNA6418 - Secwepemc Cultural Education Society	2018
401	12	LNA6472 - Scw'exmx Child & Family Services Society	2019
429	33	LNA6508 - Splatsin Tsm7aksaltn	2019
431	34	LNA6510 - Kitselas First Nation	2019
433	13	LNA6512 - Pa'La7Wit Society of the Lower Lillooet Lake	2019
102	7	LNA1858 - Kitamaat Village Council 	2010
\.


--
-- Data for Name: language_lnadata; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_lnadata (id, fluent_speakers, some_speakers, learners, pop_off_res, pop_on_res, pop_total_value, lna_id, community_id, name) FROM stdin;
6	5	35	53	1150	550	1700	1	353	CNA - Snuneymuxw First Nation - 2015-11-20
7	0	0	0	0	0	0	\N	236	CNA - Doig River First Nation - 2015-11-20
8	0	0	0	0	0	0	\N	216	CNA - Burns Lake Indian Band - 2015-11-23
9	22	10	46	501	339	840	2	228	CNA - Coldwater Indian Band - 2015-11-24
10	5	3	12	298	53	351	2	230	CNA - Cook's Ferry Indian Band - 2015-11-24
15	8	5	4	225	90	315	2	343	CNA - Siska Indian Band - 2015-11-24
16	6	9	97	1858	2087	3945	3	359	CNA - Squamish First Nations - 2015-11-24
17	16	36	55	360	225	585	4	298	CNA - Mowachaht / Muchalaht First Nations - 2015-11-25
327	10	38	50	105	94	199	134	374	CNA - ʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) - 2014-05-02
328	4	44	50	153	83	236	135	286	CNA - yaqan nuʔkiy (Lower Kootenay) - 2014-05-02
329	101	10	0	104	158	262	158	253	CNA - Halfway River First Nations - 2014-10-31
330	9	147	59	456	246	702	136	342	CNA - Simpcw - 2014-12-02
331	18	21	0	127	53	180	138	204	CNA - ʔEsdilagh - 2014-12-03
332	105	123	155	147	277	424	138	363	CNA - Yunesit'in - 2014-12-03
333	103	79	115	319	320	639	138	208	CNA - Tsi Del Del - 2014-12-03
334	128	164	177	236	180	416	138	399	CNA - Xeni Gwet'in - 2014-12-03
335	39	22	89	189	123	312	138	375	CNA - Tl’esqox - 2014-12-03
338	0	5	8	169	125	294	137	259	CNA - Hupacasath - 2014-12-04
339	0	0	0	1586	2898	4484	155	231	CNA - Cowichan Tribes - 2014-12-04
340	4	4	4	105	107	212	155	251	CNA - Halalt First Nation - 2014-12-04
18	4	12	16	343	300	643	5	268	CNA - Kitselas Indian Band - 2015-11-26
19	0	0	0	0	0	0	\N	388	CNA - Ucluelet First Nation - 2015-11-27
120	2	16	132	291	2	293	42	387	CNA - Uchucklesaht Tribe - 2016-03-08
121	41	10	38	1	200	201	43	307	CNA - Nisga'a Village Of Gitwinksihlkw - 2016-03-15
122	90	20	98	1	405	406	43	306	CNA - Nisga'a Village of Gingolx - 2016-03-15
123	110	40	48	1	378	379	43	308	CNA - Nisga'a Village of Laxgalt'sap - 2016-03-15
124	90	90	110	1	758	759	43	309	CNA - Nisga'a Village of New Aiyansh - 2016-03-15
125	0	2	0	129	1	130	\N	257	CNA - High Bar First Nation - 2016-03-16
126	10	12	39	570	894	1464	44	357	CNA - Spallumcheen Indian Band - 2016-03-18
127	6	0	34	180	140	320	45	291	CNA - MÁLEXEȽ (Malahat) - 2016-03-29
128	0	0	0	0	0	0	\N	279	CNA - Lake Babine Nation - 2016-04-01
129	15	6	16	186	19	205	46	232	CNA - Da'naxda'xw First Nation - 2016-04-01
3	16	7	557	300	900	1200	1	226	CNA - Chemainus First Nation - 2015-11-20
4	13	69	112	327	566	893	1	321	CNA - Penelakut Indian Band - 2015-11-20
5	4	4	27	100	200	300	1	352	CNA - Snaw-Naw-As First Nation - 2015-11-20
131	0	0	0	0	0	0	\N	242	CNA - Gitanmaax Band Council - 2016-04-04
132	0	0	0	0	0	0	\N	247	CNA - Glen Vowell Band - 2016-04-04
133	112	157	64	718	697	1415	\N	266	CNA - Kispiox Band - 2016-04-04
135	39	14	256	1430	900	2330	49	206	CNA - Ahousaht - 2016-04-06
136	0	2	44	325	251	576	50	386	CNA - Tzeachten First Nation - 2016-04-06
137	185	8	271	175	251	426	51	399	CNA - Xeni Gwet-In First Nations - 2016-04-06
138	0	27	40	590	674	1264	52	299	CNA - Musqueam Indian Band - 2016-04-07
140	2	8	0	69	64	133	54	338	CNA - Shackan - 2016-04-07
139	0	0	0	412	561	0	53	334	CNA - Seabird Island Band - 2016-04-07
325	0	0	0	35	27	62	132	323	CNA - Peters Band - 2014-03-27
326	4	34	0	600	600	1200	123	335	CNA - Sechelt Indian Band - 2014-03-25
341	0	0	0	0	29	29	155	280	CNA - Lake Cowichan First Nation - 2014-12-04
342	30	21	150	470	480	950	155	321	CNA - Penelakut Tribe - 2014-12-04
343	26	28	150	1558	355	1913	144	246	CNA - Gitxaala Nation - 2014-12-05
528	14	9	46	177	220	397	240	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2017-05-30
77	0	0	0	0	0	0	\N	348	CNA - Skowkale First Nations - 2015-12-07
151	1	1	1	41	61	102	39	349	CNA - Skuppah Indian Band - 2016-04-08
152	0	0	0	0	0	0	\N	315	CNA - Old Masset Village Council - 2016-04-08
224	0	0	0	0	0	0	\N	395	CNA - Wet'suwet'en First Nation - 2016-11-10
299	6	180	15	1200	500	1700	100	212	CNA - St'uxwtéws (Bonaparte) - 2013-06-06
374	0	0	0	9	1	10	163	324	CNA - Popkum First Nation - 2015-11-30
375	0	0	0	69	11	80	163	401	CNA - Skawahlook First Nation - 2015-11-30
386	0	166	0	0	0	0	\N	\N	CNA -  - 2016-11-22
449	0	0	0	0	0	0	\N	309	CNA - New Aiyansh Village - 2016-12-13
450	5	5	45	75	125	200	202	383	CNA - W̱SIḴEM (Tseycum) - 2016-12-13
523	52	47	34	891	396	1287	238	245	CNA - Gitwangak Band Council - 2017-05-29
524	47	16	213	563	687	1250	239	287	CNA - Lower Nicola Indian Band - 2017-05-30
2	83	58	50	400	200	600	\N	242	CNA - Gitanmaax Band Council - 2015-11-20
599	25	17	28	0	0	0	\N	228	CNA - Coldwater - 2017-11-20
670	0	0	0	0	0	0	\N	385	CNA - T'Sou-ke Nation - 2017-12-15
742	15	176	109	116	120	236	345	310	CNA - Nooaitch - 2018-04-12
816	19	16	48	551	428	979	378	391	CNA - Upper Nicola Band - 2018-04-25
890	11	84	45	83	44	127	401	338	CNA - Shackan - 2018-10-24
14	2	8	0	69	64	133	2	338	CNA - Shackan First Nation - 2015-11-24
35	18	3	122	900	809	1709	16	314	CNA - Okanagan Indian Band - 2015-12-02
36	2	2	2	1	1	2	\N	303	CNA - Nazko First Nation - 2015-12-02
37	1	0	1	196	303	499	14	267	CNA - Kitasoo Xai'xais First Nation - 2015-12-02
38	0	0	0	0	0	0	\N	307	CNA - Nisga'a Village Of Gitwinksihlkw - 2015-12-02
39	0	0	0	0	0	0	\N	306	CNA - Nisga'a Village of Gingolx - 2015-12-02
11	36	27	17	538	660	1198	2	287	CNA - Lower Nicola Indian Band - 2015-11-24
12	4	0	7	81	52	133	2	305	CNA - Nicomen Indian Band - 2015-11-24
13	7	7	8	123	104	227	2	310	CNA - Nooaitch Indian Band - 2015-11-24
20	13	59	59	640	50	690	6	256	CNA - Hesquiaht First Nation - 2015-11-27
21	0	0	0	0	0	0	\N	242	CNA - Gitanmaax Band Council - 2015-11-29
22	0	0	0	0	0	0	\N	247	CNA - Glen Vowell Band - 2015-11-29
23	0	0	0	0	0	0	\N	266	CNA - Kispiox Band - 2015-11-29
24	2	25	58	324	52	376	7	270	CNA - Klahoose First Nation - 2015-11-30
25	24	0	147	487	554	1041	8	322	CNA - Penticton Indian Band - 2015-11-30
26	0	0	0	0	0	0	\N	242	CNA - Gitanmaax Band Council - 2015-11-30
27	0	0	0	0	0	0	\N	247	CNA - Glen Vowell Band - 2015-11-30
28	0	0	0	0	0	0	\N	266	CNA - Kispiox Band - 2015-11-30
29	2	3	4	315	95	410	9	283	CNA - Lheidli-T'enneh Band - 2015-11-30
30	37	45	159	903	930	1833	10	302	CNA - ʼNa̱mǥis First Nation - 2015-11-30
31	0	27	40	589	679	1268	11	299	CNA - Musqueam Indian Band - 2015-12-01
32	112	157	64	718	697	1415	12	266	CNA - Kispiox Band - 2015-12-01
33	1	7	12	140	120	260	13	274	CNA - Kwantlen First Nation - 2015-12-01
34	0	12	9	288	80	368	15	340	CNA - Shxwha:Y Village (Skway First Nation) - 2015-12-01
50	0	0	0	462	384	846	\N	243	CNA - Gitanyow Band - 2015-12-03
51	12	30	24	140	100	240	20	402	CNA - Yekooche First Nation - 2015-12-03
52	23	45	64	440	317	757	21	261	CNA - Iskut First Nation - 2015-12-03
53	19	20	57	1596	293	1889	21	365	CNA - Tahltan Indian Band - 2015-12-03
55	18	5	65	847	1583	2430	23	346	CNA - Skidegate Band Council - 2015-12-04
56	11	18	592	739	921	1660	24	313	CNA - Nuxalk Nation - 2015-12-04
57	0	6	20	101	264	365	26	320	CNA - Pauquachin First Nation - 2015-12-04
58	4	10	341	281	600	881	26	377	CNA - W̱JOȽEȽP (Tsartlip) - 2015-12-04
59	0	13	87	212	537	749	26	379	CNA - Tsawout First Nation - 2015-12-04
60	0	3	10	48	104	152	26	383	CNA - Tseycum Indian Band - 2015-12-04
62	19	29	59	266	120	386	28	288	CNA - Lower Similkameen Indian Band - 2015-12-04
63	39	20	116	1156	821	1977	28	314	CNA - Okanagan Indian Band - 2015-12-04
64	12	14	93	204	329	533	28	317	CNA - Osoyoos Indian Band - 2015-12-04
65	35	27	147	487	554	1041	28	322	CNA - Penticton Indian Band - 2015-12-04
66	21	18	56	537	373	910	28	391	CNA - Upper Nicola Band - 2015-12-04
67	4	0	9	34	57	91	28	392	CNA - Upper Similkameen Indian Band - 2015-12-04
68	37	8	80	423	426	849	28	394	CNA - Westbank First Nation - 2015-12-04
69	1	8	40	230	400	630	29	355	CNA - Songhees First Nation - 2015-12-04
70	0	0	0	0	0	0	\N	243	CNA - Gitanyow Band - 2015-12-04
71	0	0	0	0	0	0	\N	244	CNA - Gitsegukla Band Council - 2015-12-04
72	0	2	16	247	228	475	25	217	CNA - Burrard Band - 2015-12-04
73	8	1	45	150	400	550	30	345	CNA - Skeetchestn Indian Band - 2015-12-04
74	3	62	20	298	150	448	31	367	CNA - Taku River Tlingit First Nation - 2015-12-07
75	0	0	0	0	0	0	\N	231	CNA - Cowichan Tribes - 2015-12-07
76	0	0	0	0	0	0	\N	207	CNA - Aitchelitz First Nation - 2015-12-07
78	0	0	0	0	0	0	\N	386	CNA - Tzeachten First Nation - 2015-12-07
79	0	0	0	0	0	0	\N	400	CNA - Yakweakwioose Band - 2015-12-07
80	103	79	115	319	320	639	32	208	CNA - Alexis Creek Indian Band - 2015-12-07
82	0	0	0	0	0	0	\N	223	CNA - Chawathil Band - 2015-12-08
83	0	0	0	0	0	0	\N	235	CNA - Ditidaht First Nation - 2015-12-09
85	39	592	324	887	1286	2173	35	297	CNA - Mount Currie - 2015-12-10
86	0	500	40	300	200	500	\N	247	CNA - Glen Vowell Band - 2015-12-11
87	97	266	307	500	1600	2100	36	255	CNA - Heiltsuk Nation - 2015-12-11
88	0	1	2	40	52	92	37	278	CNA - Kwikwetlem First Nation - 2015-12-15
89	0	0	0	0	0	0	\N	209	CNA - Ashcroft Indian Band - 2015-12-15
91	0	0	0	0	0	0	\N	264	CNA - Kanaka Bar Indian Band - 2015-12-15
92	0	0	0	0	0	0	\N	287	CNA - Lower Nicola Indian Band - 2015-12-15
93	0	0	0	0	0	0	\N	290	CNA - Lytton First Nation - 2015-12-15
81	9	12	19	1200	500	1700	33	353	CNA - Snuneymuxw First Nation - 2015-12-08
95	0	0	0	0	0	0	\N	310	CNA - Nooaitch Indian Band - 2015-12-15
96	0	0	0	0	0	0	\N	316	CNA - Oregon Jack Creek Band - 2015-12-15
84	0	0	21	5	20	25	34	280	CNA - Lake Cowichan First Nation - 2015-12-09
97	0	0	0	0	0	0	\N	343	CNA - Siska Indian Band - 2015-12-15
98	22	12	2	200	200	400	\N	216	CNA - Burns Lake Indian Band - 2016-01-04
99	20	20	4	50	50	100	\N	247	CNA - Glen Vowell Band - 2016-01-22
100	0	0	0	0	0	0	\N	216	CNA - Burns Lake Indian Band - 2016-01-26
101	0	0	0	0	0	0	\N	300	CNA - Nadleh Whut'en Nation - 2016-01-26
102	0	0	0	0	0	0	\N	301	CNA - Nak'azdli Whut'en Nation - 2016-01-26
103	0	0	0	0	0	0	\N	330	CNA - Saik'uz First Nation - 2016-01-26
104	0	0	0	0	0	0	\N	362	CNA - Stellat'en - 2016-01-26
105	0	0	0	0	0	0	\N	366	CNA - Takla Lake First Nation - 2016-01-26
106	0	0	0	0	0	0	\N	371	CNA - Tl'azt'en Nation - 2016-01-26
108	0	0	0	0	0	0	\N	306	CNA - Nisga'a Village of Gingolx - 2016-02-17
109	0	0	0	0	0	0	\N	384	CNA - Ts'kw'aylaxw First Nation - 2016-02-22
110	6	5	0	345	70	415	38	373	CNA - Tlowitsis Tribe - 2016-02-23
111	0	0	0	0	0	0	\N	405	CNA - ʔakisq̓nuk First Nation - 2016-02-23
112	0	0	0	0	0	0	\N	374	CNA - Tobacco Plains Indian Band - 2016-03-01
113	5	3	12	298	53	351	39	230	CNA - Cook's Ferry - 2016-03-01
114	4	0	7	81	52	133	39	305	CNA - Nicomen Indian Band - 2016-03-01
41	0	0	0	0	0	0	\N	309	CNA - Nisga'a Village of New Aiyansh - 2015-12-02
42	47	16	212	538	660	1198	17	287	CNA - Lower Nicola Indian Band - 2015-12-03
43	0	0	0	0	0	0	\N	303	CNA - Nazko First Nation - 2015-12-03
44	11	45	57	182	420	602	18	219	CNA - Tsq'escenemc (Canim Lake) - 2015-12-03
45	7	20	41	412	309	721	18	220	CNA - Canoe Creek - 2015-12-03
46	91	337	203	460	472	932	18	239	CNA - Esketemc - 2015-12-03
47	1	2	33	236	179	415	18	354	CNA - Soda Creek First Nation - 2015-12-03
48	7	21	169	471	273	744	18	397	CNA - Williams Lake Indian Band - 2015-12-03
49	9	13	26	417	220	637	19	388	CNA - Ucluelet First Nation - 2015-12-03
141	12	65	279	1586	2898	4484	55	231	CNA - Cowichan Tribes - 2016-04-07
142	405	157	411	1602	805	2407	56	242	CNA - Gitanmaax Band Council - 2016-04-07
143	0	0	0	0	0	0	\N	223	CNA - Chawathil Band - 2016-04-07
144	0	0	0	0	0	0	\N	224	CNA - Cheam Band - 2016-04-07
146	0	0	0	0	0	0	\N	341	CNA - Shxw'ow'hamel First Nation - 2016-04-07
147	4	22	34	331	151	482	57	384	CNA - Ts'kw'aylaxw First Nation - 2016-04-08
148	0	3	10	48	104	152	58	383	CNA - W̱SIḴEM (Tseycum) - 2016-04-08
149	2	5	48	134	70	204	39	264	CNA - Kanaka Bar Indian Band - 2016-04-08
150	37	49	100	1062	785	1847	39	290	CNA - Lytton First Nation - 2016-04-08
153	40	1	0	1562	361	1923	\N	246	CNA - Gitxaala Nation - 2016-04-11
154	26	127	95	230	300	530	59	272	CNA - Kwadacha - 2016-04-12
155	1	4	5	131	25	156	60	312	CNA - Nuchatlaht First Nation - 2016-04-14
156	3	10	59	300	150	450	60	238	CNA - ʔiiḥatis (Ehattesaht) - 2016-04-14
157	0	1	6	15	7	22	61	276	CNA - Kwiakah First Nation - 2016-04-14
158	8	23	127	731	389	1120	61	221	CNA - We Wai Kai First Nation - 2016-04-14
159	12	20	155	415	395	810	61	218	CNA - Wei Wai Kum First Nation - 2016-04-14
160	96	147	183	195	274	469	62	363	CNA - Yunesit'in - 2016-04-19
161	41	37	26	161	73	234	63	271	CNA - Lhoosk'uz Dene Nation - 2016-04-21
166	1	5	93	185	194	379	64	368	CNA - T’ít’q’et First Nation - 2016-04-25
168	112	157	64	718	697	1415	\N	266	CNA - Anspa yaxw (Kispiox) - 2016-04-26
169	0	0	0	0	0	0	\N	242	CNA - Gitanmaax Band Council - 2016-04-26
170	0	0	0	0	0	0	\N	247	CNA - Sik-edakh (Glen Vowell) - 2016-04-26
182	94	15	106	1367	668	2035	68	296	CNA - Moricetown Band Office - 2016-04-28
167	0	0	0	0	0	0	\N	398	CNA - Xaxli'p First Nation - 2016-04-25
162	9	3	65	201	219	420	64	215	CNA - Nxwísten (Bridge River) - 2016-04-25
163	2	3	35	107	86	193	64	222	CNA - Sekw’el’wás (Cayoose Creek) - 2016-04-25
164	4	22	34	331	151	482	64	384	CNA - Ts'kw'aylaxw - 2016-04-25
165	17	6	89	402	245	647	64	337	CNA - Tsal'álh (Seton Lake) - 2016-04-25
171	9	12	0	565	394	959	64	398	CNA - Xaxli'p First Nation - 2016-04-26
172	21	30	73	432	167	599	65	262	CNA - Ka:'yu:'k't'h' / Che:k:tles7et'h' - 2016-04-26
173	3	10	59	300	150	450	66	238	CNA - ʔiiḥatis (Ehattesaht) - 2016-04-27
174	35	27	147	487	554	1041	67	322	CNA - Penticton Indian Band - 2016-04-28
175	12	14	93	204	329	533	67	317	CNA - Osoyoos Indian Band - 2016-04-28
176	37	8	80	423	426	849	67	394	CNA - Westbank First Nation - 2016-04-28
177	90	20	98	1	405	406	\N	306	CNA - Gingolx Village Government - 2016-04-28
179	90	90	110	1	758	759	\N	309	CNA - New Aiyansh Village - 2016-04-28
183	2	4	10	150	350	500	69	398	CNA - Xaxli'p First Nation - 2016-04-28
184	0	13	87	212	537	749	70	379	CNA - SȾÁUTW̱ (Tsawout) - 2016-04-28
185	4	10	341	281	600	881	70	377	CNA - W̱JOȽEȽP (Tsartlip) - 2016-04-28
186	0	0	0	0	0	0	\N	368	CNA - T’ít’q’et First Nation - 2016-04-29
187	10	16	35	350	350	700	71	337	CNA - Tsal'álh (Seton Lake) - 2016-05-03
181	6	1	9	597	193	790	68	250	CNA - Hagwilget Village - 2016-04-28
188	0	0	0	0	0	0	\N	250	CNA - Hagwilget Village - 2016-05-03
189	0	0	0	0	0	0	\N	279	CNA - Lake Babine Nation - 2016-05-03
116	0	1	11	169	94	263	40	214	CNA - Boston Bar First Nation - 2016-03-01
117	12	20	155	415	395	810	41	218	CNA - Campbell River First Nation - 2016-03-01
118	8	23	127	731	389	1120	41	221	CNA - Cape Mudge - 2016-03-01
119	0	1	6	15	7	22	41	276	CNA - Kwiakah First Nation - 2016-03-01
130	1	0	4	106	200	306	47	240	CNA - Esquimalt Nation - 2016-04-04
201	0	0	0	0	0	0	\N	335	CNA - Sechelt Indian Band - 2016-06-15
202	110	80	130	1000	400	1400	75	372	CNA - Tl'etinqox-T'in Government Office - 2016-06-20
203	11	57	48	527	247	774	76	235	CNA - Ditidaht First Nation - 2016-06-23
204	13	38	59	640	50	690	77	256	CNA - Hesquiaht - 2016-06-24
205	19	11	42	211	248	459	78	288	CNA - Lower Similkameen Indian Band - 2016-06-27
206	117	166	327	1206	1207	2413	79	255	CNA - Heiltsuk Nation - 2016-06-28
207	50	145	60	200	225	425	80	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2016-06-29
208	0	0	0	0	0	0	\N	248	CNA - Gwa'sala-'Nakwaxda'xw First Nation - 2016-06-29
209	0	0	0	0	0	0	\N	328	CNA - G̱usgimukw (Quatsino First Nation) - 2016-06-29
210	10	100	59	435	372	807	81	273	CNA - Kwakiutl Band Council - 2016-06-29
211	7	0	5	141	204	345	82	311	CNA - N'Quatqua - 2016-06-29
212	2	3	0	128	80	208	83	339	CNA - Kenpesq't (Shuswap) - 2016-07-15
213	0	0	0	0	0	0	\N	332	CNA - Saulteau First Nations - 2016-09-15
214	0	0	0	0	0	0	\N	283	CNA - Lheidli T'enneh Band - 2016-10-26
215	0	0	0	0	0	0	\N	306	CNA - Gingolx Village Government - 2016-11-07
216	0	0	0	0	0	0	\N	308	CNA - Laxgalts'ap Village Government - 2016-11-07
217	0	0	0	0	0	0	\N	309	CNA - New Aiyansh Village - 2016-11-07
218	0	0	0	0	0	0	\N	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2016-11-07
219	0	0	0	141	0	141	\N	257	CNA - Llenlleney'ten (High Bar) - 2016-11-10
220	0	0	0	0	0	0	\N	306	CNA - Gingolx Village Government - 2016-11-10
221	0	0	0	0	0	0	\N	308	CNA - Laxgalts'ap Village Government - 2016-11-10
222	0	0	0	0	0	0	\N	309	CNA - New Aiyansh Village - 2016-11-10
223	0	0	0	0	0	0	\N	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2016-11-10
225	0	0	0	0	0	0	\N	304	CNA - Neskonlith - 2016-11-14
226	7	20	41	412	309	721	84	220	CNA - Canoe Creek - 2016-11-14
227	91	337	203	460	472	932	84	239	CNA - Esketemc - 2016-11-14
228	6	15	169	471	273	744	84	397	CNA - T'exelcemc (Williams Lake) - 2016-11-14
230	1	0	33	236	179	415	84	354	CNA - Xats'ull (Soda Creek) - 2016-11-14
231	0	0	0	0	0	0	\N	216	CNA - Ts'il Kaz Koh (Burns Lake) - 2016-11-15
232	9	13	26	443	206	649	85	388	CNA - Ucluelet First Nation - 2016-11-16
233	0	0	0	170	680	850	87	389	CNA - Ulkatchot'en - 2008-10-14
234	0	0	0	13	23	36	88	207	CNA - Aitchelitz First Nation  - 2008-10-15
235	0	0	0	172	129	301	88	282	CNA - Leq'á:mel First Nation - 2008-10-15
236	0	0	0	57	13	70	88	401	CNA - Skawahlook First Nation - 2008-10-15
237	0	0	0	58	155	213	88	348	CNA - Skowkale First Nation - 2008-10-15
238	0	0	0	214	58	272	88	340	CNA - Skway First Nation - 2008-10-15
239	0	0	0	42	82	124	88	360	CNA - Squiala First Nation - 2008-10-15
240	0	0	0	84	158	242	88	364	CNA - Sumas First Nation - 2008-10-15
241	0	0	0	132	202	334	88	386	CNA - Tzeachten First Nation - 2008-10-15
242	0	0	0	29	29	58	88	400	CNA - Yakweakwioose Band - 2008-10-15
243	0	0	0	129	94	223	89	210	CNA - Scia'new (Beecher Bay) - 2008-10-17
244	0	0	0	2260	970	3230	91	281	CNA - Lax Kw'alaams Band - 2008-10-17
245	0	0	0	120	242	362	90	320	CNA - BOḰEĆEN (Pauquachin) - 2008-10-17
246	0	0	0	932	511	1443	86	252	CNA - Haisla - 2008-09-18
247	0	0	0	159	70	229	92	209	CNA - Ashcroft Indian Band - 2008-10-24
248	5	13	9	122	228	350	93	361	CNA - ʔaq̓am (St. Mary's Band) - 2009-02-25
250	5	0	33	47	190	237	93	286	CNA - yaqan nuʔkiy (Lower Kootenay) - 2009-02-25
251	7	0	4	29	115	144	93	374	CNA - ʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) - 2009-02-25
252	11	14	13	256	163	419	103	300	CNA - Nadleh Whut'en - 2010-06-03
253	50	150	57	913	578	1491	103	371	CNA - Tl’azt’en Nation  - 2010-06-03
254	25	20	5	318	532	850	103	330	CNA - Saik'uz First Nation - 2010-06-03
255	7	12	20	46	58	104	103	216	CNA - Ts'il Kaz Koh (Burns Lake) - 2010-06-03
256	205	383	50	585	915	1500	103	301	CNA - Nak'azdli Band - 2010-06-03
257	100	100	0	274	383	657	103	366	CNA - Takla Lake First Nation - 2010-06-03
258	18	16	35	213	186	399	103	362	CNA - Stellat'en First Nation - 2010-06-03
259	10	10	88	115	98	213	103	395	CNA - Wet'suwet'en First Nation - 2010-06-03
260	242	21	81	946	731	1677	102	406	CNA - Kitamaat Village Council - 2010-06-03
261	8	16	0	104	60	164	94	347	CNA - Skin Tyee Nation - 2011-03-02
191	41	37	26	161	73	234	\N	271	CNA - Lhoosk'uz Dene Nation - 2016-05-04
192	0	0	21	5	20	25	\N	280	CNA - Lake Cowichan First Nation - 2016-05-04
193	0	0	0	2	2	4	\N	332	CNA - Saulteau First Nations - 2016-05-04
194	3	3	28	150	168	318	72	233	CNA - Daylu Dena Council - 2016-05-06
195	6	9	97	1858	2087	3945	\N	359	CNA - Squamish Nation - 2016-05-26
196	0	0	0	0	0	0	\N	250	CNA - Hagwilget Village - 2016-05-30
197	0	0	0	0	0	0	\N	279	CNA - Lake Babine Nation - 2016-05-30
198	0	0	0	0	0	0	\N	241	CNA - Fort Nelson First Nation - 2016-06-07
200	11	31	8	320	325	645	74	304	CNA - Neskonlith - 2016-06-14
289	8	41	27	296	389	685	97	220	CNA - Canoe Creek - 2012-12-13
294	15	34	47	362	392	754	97	357	CNA - Splats'in - 2012-12-13
295	20	40	25	327	23	350	98	292	CNA - Mama̱liliḵa̱la / Qwe'Qwa'Sot'Em - 2013-05-22
296	53	187	15	110	146	256	101	253	CNA - Halfway River First Nations - 2013-05-24
297	25	68	15	170	93	263	101	325	CNA - Prophet River First Nation - 2013-05-24
298	0	10	1	133	118	251	110	385	CNA - T'Sou-ke Nation - 2013-05-24
300	0	5	60	265	186	451	111	380	CNA - Tsawwassen First Nation - 2013-06-13
301	10	60	60	123	123	246	\N	234	CNA - Dease River First Nation - 2013-09-06
304	8	20	50	243	30	273	122	277	CNA - Ḵwikwa̱sutinux̱  / Ha̱'xwa-mis - 2014-01-27
305	2	5	33	165	200	365	113	356	CNA - Soowahlie Indian Band - 2014-01-29
306	1	4	20	213	110	323	117	229	CNA - K'ómoks First Nation - 2014-01-29
307	10	577	333	448	587	1035	128	351	CNA - Sliammon First Nation - 2014-01-31
308	7	5	36	421	87	508	115	378	CNA - Dzawada̱ʼenux̱w (Tsawataineuk) - 2014-03-17
309	58	610	50	620	143	763	116	254	CNA - Gitga'at Nation - 2014-03-25
310	0	5	50	120	20	140	159	376	CNA - Toquaht First Nation - 2014-03-26
311	0	3	5	40	43	83	118	336	CNA - SEMYOME (Semiahmoo) - 2014-03-28
312	12	8	0	36	4	40	119	249	CNA - Gwawaʼenux̱w - 2014-03-27
314	1	2	23	165	142	307	121	393	CNA - West Moberly First Nations - 2014-04-09
315	2	7	22	2192	751	2943	145	315	CNA - Old Masset Village Council - 2014-03-28
316	7	6	35	869	740	1609	145	346	CNA - Skidegate Band Council - 2014-03-28
317	15	0	0	520	394	914	124	332	CNA - Saulteau First Nations - 2014-04-23
318	20	40	28	550	550	1100	125	369	CNA - Tla-o-qui-aht First Nation - 2014-04-23
319	50	200	0	157	142	299	131	236	CNA - Doig  River First Nation - 2011-09-14
320	58	128	154	435	449	884	127	241	CNA - Fort Nelson First Nation - 2014-04-23
321	2	2	0	153	85	238	126	339	CNA - Kenpesq't (Shuswap) - 2014-04-24
322	6	14	20	85	65	150	130	396	CNA - Pellt'iq't (Whispering Pines/Clinton) - 2014-04-23
323	6	5	10	215	65	280	129	318	CNA - Wuikinuxv Nation - 2014-04-28
324	0	0	0	28	35	63	133	400	CNA - Yakweakwioose Band - 2014-04-28
413	0	0	0	0	0	0	\N	255	CNA - Heiltsuk Nation - 2016-12-02
264	10	10	12	205	215	420	164	282	CNA - Leq'á:mel First Nation - 2011-03-15
265	0	15	1	230	100	330	164	333	CNA - Scowlitz First Nation - 2011-03-15
266	0	10	19	245	295	540	99	223	CNA - Chawathil First Nation - 2011-03-16
267	0	12	11	87	148	235	99	348	CNA - Skowkale First Nation - 2011-03-16
268	5	11	21	296	187	483	99	224	CNA - Cheam First Nation - 2011-03-16
269	416	247	128	903	1409	2312	96	279	CNA - Lake Babine Nation - 2011-05-18
270	7	10	0	109	21	130	105	404	CNA - Nee-Tahi-Buhn Indian Band - 2011-06-08
271	5	9	9	191	75	266	95	213	CNA - Boothroyd Band - 2010-06-01
272	2	5	0	151	91	242	95	214	CNA - Boston Bar First Nation  - 2010-06-01
273	2	4	0	140	64	204	95	264	CNA - Kanaka Bar Indian Band - 2010-06-01
274	36	43	80	1062	785	1847	95	290	CNA - Lytton First Nation - 2010-06-01
275	0	1	0	49	13	62	95	316	CNA - Oregon Jack Creek Band - 2010-06-01
276	1	0	1	41	61	102	95	349	CNA - Skuppah Indian Band - 2010-06-01
277	0	6	3	165	45	210	95	358	CNA - Spuzzum First Nation - 2010-06-01
278	50	30	80	500	500	1000	108	330	CNA - Saik'uz First Nation - 2011-12-01
280	23	25	11	194	167	361	106	303	CNA - Nazko First Nation - 2012-06-21
281	2	0	0	160	90	250	107	333	CNA - Scowlitz First Nation - 2012-06-22
282	20	13	29	580	213	793	97	212	CNA - St'uxwtéws (Bonaparte) - 2012-12-13
284	2	8	3	103	129	232	97	339	CNA - Kenpesq't (Shuswap) - 2012-12-13
285	1	6	0	81	421	502	97	384	CNA - Ts'kw'aylaxw - 2012-12-13
286	0	7	14	76	54	130	97	396	CNA - Pellt'iq't (Whispering Pines/Clinton) - 2012-12-13
287	19	89	82	311	362	673	97	205	CNA - Sexqeltqín (Adams Lake) - 2012-12-13
288	3	29	135	450	600	1050	97	263	CNA - Tk'emlups (Kamloops) - 2012-12-13
290	5	20	52	81	227	308	97	285	CNA - Skwlax (Little Shuswap) - 2012-12-13
291	8	22	23	271	320	591	97	304	CNA - Neskonlith - 2012-12-13
292	4	14	44	240	397	637	97	342	CNA - Simpcw - 2012-12-13
302	6	20	5	194	10	204	109	289	CNA - Lyackson First Nation - 2013-05-22
303	22	118	4	224	253	477	114	258	CNA - Homalco First Nation - 2014-01-20
293	8	30	79	283	278	561	97	345	CNA - Skeetchestn - 2012-12-13
350	26	275	57	513	520	1033	141	389	CNA - Ulkatchot'en - 2015-04-23
351	151	242	103	1160	581	1741	140	371	CNA - Tl’azt’en Nation  - 2015-04-27
352	15	79	79	427	108	535	142	294	CNA - McLeod Lake - 2015-04-27
353	10	90	96	328	418	746	153	205	CNA - Sexqeltqín (Adams Lake) - 2015-04-29
354	3	197	178	521	537	1058	148	263	CNA - Tk'emlups (Kamloops) - 2015-05-19
356	21	210	120	350	501	851	151	248	CNA - Gwa'sala-'Nakwaxda'xw First Nation - 2015-05-20
357	106	193	230	1643	694	2337	150	242	CNA - Gitanmaax Band Council - 2015-05-20
358	48	59	82	455	367	822	150	243	CNA - Gitanyow Band Council - 2015-05-20
359	44	74	95	567	415	982	150	244	CNA - Gitsegukla Band Council - 2015-05-20
360	22	34	45	227	181	408	150	247	CNA - Sik-edakh (Glen Vowell) - 2015-05-20
361	77	123	159	961	631	1592	150	266	CNA - Anspa yaxw (Kispiox) - 2015-05-20
362	5	26	25	510	550	1060	160	382	CNA - Tseshaht First Nation - 2015-05-21
363	5	65	145	292	70	362	149	331	CNA - Samahquam Nation - 2015-05-28
364	4	45	45	151	49	200	149	237	CNA - Douglas First Nation - 2015-05-28
365	20	25	56	196	228	424	146	381	CNA - Tsay Keh Dene - 2015-05-28
366	7	51	51	353	58	411	149	344	CNA - Skatin Nations - 2015-05-27
367	0	18	15	200	360	560	165	265	CNA - Katzie First Nation - 2015-06-11
368	0	0	2	49	34	83	165	278	CNA - Kwikwetlem First Nation - 2015-06-12
369	0	29	38	580	680	1260	165	299	CNA - xʷməθkʷəy̓əm (Musqueam) - 2015-06-12
370	40	15	40	1400	800	2200	161	206	CNA - Ahousaht - 2014-04-01
371	0	1	14	171	260	431	163	386	CNA - Tzeachten First Nation - 2015-11-30
372	0	2	0	222	132	354	163	282	CNA - Leq'á:mel First Nation - 2015-11-30
376	0	7	20	68	169	237	163	348	CNA - Skowkale First Nation - 2015-11-30
377	0	0	0	53	127	180	163	360	CNA - Squiala First Nation - 2015-11-30
378	0	0	0	9	32	41	163	207	CNA - Aitchelitz First Nation  - 2015-11-30
379	3	40	40	491	255	746	162	269	CNA - Kitsumkalum Band Council - 2015-12-04
380	0	0	0	0	0	0	\N	294	CNA - McLeod Lake - 2016-11-18
381	0	0	0	0	0	0	\N	286	CNA - yaqan nuʔkiy (Lower Kootenay) - 2016-11-18
382	0	0	0	0	0	0	\N	374	CNA - ʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) - 2016-11-18
383	0	0	0	0	0	0	\N	405	CNA - ʔakisq̓nuk First Nation - 2016-11-18
384	0	0	0	0	0	0	\N	361	CNA - ʔaq̓am (St. Mary's Band) - 2016-11-18
387	0	0	0	0	0	0	\N	282	CNA - Leq'á:mel First Nation - 2016-11-24
388	1	9	41	230	400	630	167	355	CNA - Songhees Nation - 2016-11-24
389	15	24	70	562	195	757	168	261	CNA - Iskut First Nation - 2016-11-24
390	19	20	57	1596	293	1889	168	365	CNA - Tahltan Nation - 2016-11-24
385	0	0	0	1208	1206	2414	166	255	CNA - Heiltsuk Nation - 2016-11-21
344	210	105	140	1100	700	1800	154	301	CNA - Nak'azdli Band - 2014-12-05
346	6	0	0	142	99	241	147	395	CNA - Wet'suwet'en First Nation - 2014-12-05
347	6	28	130	197	177	374	139	361	CNA - ʔaq̓am (St. Mary's Band) - 2014-12-04
348	0	22	5	217	62	279	143	319	CNA - Pacheedaht First Nation - 2015-03-15
349	15	22	10	88	75	163	156	329	CNA - Lhtako Dene Nation - 2014-11-17
391	10	15	52	212	307	519	171	267	CNA - Kitasoo/Xaixais Nation - 2016-11-24
398	17	19	120	386	364	750	174	205	CNA - Sexqeltqín (Adams Lake) - 2016-11-30
399	0	0	0	0	0	0	\N	209	CNA - Ashcroft Indian Band - 2016-11-30
400	0	0	0	0	0	0	\N	214	CNA - Boston Bar First Nation  - 2016-11-30
401	0	0	0	0	0	0	\N	228	CNA - Coldwater - 2016-11-30
402	0	0	0	0	0	0	\N	230	CNA - Cook's Ferry - 2016-11-30
404	0	0	0	0	0	0	\N	310	CNA - Nooaitch - 2016-11-30
405	0	0	0	0	0	0	\N	338	CNA - Shackan - 2016-11-30
406	0	0	0	0	0	0	\N	343	CNA - Siska Indian Band - 2016-11-30
407	7	10	72	166	81	247	175	395	CNA - Wet'suwet'en First Nation - 2016-11-30
408	6	3	9	89	85	174	176	329	CNA - Lhtako Dene Nation - 2016-12-01
409	30	63	39	415	1048	1463	177	389	CNA - Ulkatchot'en - 2016-12-01
410	5	6	8	81	52	133	178	305	CNA - Nicomen Indian Band - 2016-12-02
411	29	33	56	82	120	202	178	310	CNA - Nooaitch - 2016-12-02
412	2	8	0	69	64	133	178	338	CNA - Shackan - 2016-12-02
337	1	18	17	122	58	180	157	341	CNA - Shxw'owhamel First Nation - 2014-10-31
394	0	0	0	0	0	0	\N	402	CNA - Yekooche First Nation - 2016-11-24
395	47	139	8	108	78	186	172	279	CNA - Lake Babine Nation - 2016-11-25
396	10	1	37	282	248	530	173	345	CNA - Skeetchestn - 2016-11-28
397	1	1	2	1	1	2	\N	382	CNA - Tseshaht First Nation - 2016-11-28
392	18	3	122	900	809	1709	170	314	CNA - Okanagan Indian Band - 2016-11-24
393	0	0	0	0	0	0	\N	283	CNA - Lheidli T'enneh Band - 2016-11-24
426	0	0	0	0	0	0	\N	276	CNA - Kwiakah First Nation - 2016-12-09
427	0	0	0	0	0	0	\N	221	CNA - We Wai Kai First Nation - 2016-12-09
428	0	0	0	0	0	0	\N	218	CNA - Wei Wai Kum First Nation - 2016-12-09
429	0	0	0	0	0	0	\N	364	CNA - Sumas First Nation - 2016-12-09
430	16	247	199	552	663	1215	190	226	CNA - Chemainus First Nation - 2016-12-09
431	12	50	279	1586	2898	4484	190	231	CNA - Cowichan Tribes - 2016-12-09
432	24	120	316	393	597	990	191	248	CNA - Gwa'sala-'Nakwaxda'xw First Nation - 2016-12-11
433	0	0	0	0	0	0	\N	331	CNA - Samahquam Nation - 2016-12-12
434	58	128	193	390	423	813	192	241	CNA - Fort Nelson First Nation - 2016-12-12
435	1	4	5	131	25	156	193	312	CNA - Nuchatlaht First Nation - 2016-12-12
436	26	33	157	1457	453	1910	194	246	CNA - Gitxaala Nation - 2016-12-12
438	0	0	0	0	0	0	\N	215	CNA - Nxwísten (Bridge River) - 2016-12-12
439	0	0	0	0	0	0	\N	384	CNA - Ts'kw'aylaxw - 2016-12-12
440	0	0	0	0	0	0	\N	368	CNA - T’ít’q’et First Nation - 2016-12-12
441	0	0	0	0	0	0	\N	398	CNA - Xaxli'p First Nation - 2016-12-12
442	445	588	313	940	867	1807	196	309	CNA - New Aiyansh Village - 2016-12-12
443	6	9	97	1858	2087	3945	197	359	CNA - Squamish Nation - 2016-12-12
444	13	7	44	640	50	690	198	256	CNA - Hesquiaht - 2016-12-13
445	10	11	48	185	115	300	199	393	CNA - West Moberly First Nations - 2016-12-13
446	33	26	147	487	550	1037	200	322	CNA - Penticton Indian Band - 2016-12-13
447	0	0	0	0	0	0	\N	282	CNA - Leq'á:mel First Nation - 2016-12-13
437	2	25	58	324	52	376	195	270	CNA - Klahoose First Nation - 2016-12-12
448	103	79	115	319	320	639	201	208	CNA - Tsi Del Del - 2016-12-13
451	0	32	18	237	265	502	203	217	CNA - Tsleil-Waututh Nation - 2016-12-13
452	45	43	186	1300	500	1800	204	302	CNA - ʼNa̱mǥis First Nation - 2016-12-13
454	0	0	0	132	20	152	\N	376	CNA - Toquaht First Nation - 2016-12-20
455	0	0	0	0	0	0	\N	388	CNA - Ucluelet First Nation - 2016-12-20
456	84	300	179	1200	500	1700	205	302	CNA - ʼNa̱mǥis First Nation - 2016-12-20
457	0	0	0	0	0	0	\N	372	CNA - Tl'etinqox-T'in Government Office - 2017-01-05
458	0	0	0	0	0	0	\N	375	CNA - Tl’esqox - 2017-01-05
459	0	0	0	0	0	0	\N	208	CNA - Tsi Del Del - 2017-01-05
460	0	0	0	0	0	0	\N	399	CNA - Xeni Gwet'in - 2017-01-05
461	0	0	0	0	0	0	\N	363	CNA - Yunesit'in - 2017-01-05
462	3	3	28	150	168	318	\N	233	CNA - Daylu Dena Council - 2017-01-06
463	0	0	0	0	0	0	\N	278	CNA - Kwikwetlem First Nation - 2017-01-06
464	22	48	230	1200	1300	2500	206	255	CNA - Heiltsuk Nation - 2017-01-11
465	16	16	622	775	947	1722	207	313	CNA - Nuxalk Nation - 2017-01-13
466	39	592	324	887	1286	2173	208	297	CNA - Lil'wat Nation - 2017-01-20
467	0	0	0	0	0	0	\N	243	CNA - Gitanyow Band Council - 2017-03-27
470	0	0	3	143	1	144	209	257	CNA - Llenlleney'ten (High Bar) - 2017-03-30
471	23	0	147	487	554	1041	210	322	CNA - Penticton Indian Band - 2017-04-02
472	0	13	87	212	537	749	211	379	CNA - SȾÁUTW̱ (Tsawout) - 2017-04-03
473	0	0	0	0	0	0	\N	271	CNA - Lhoosk'uz Dene Nation - 2017-04-05
474	0	0	0	0	0	0	\N	329	CNA - Lhtako Dene Nation - 2017-04-05
475	0	0	0	0	0	0	\N	389	CNA - Ulkatchot'en - 2017-04-05
476	3	5	212	443	563	1006	212	225	CNA - Chehalis Indian Band - 2017-04-06
477	0	0	0	0	0	0	\N	317	CNA - Osoyoos Indian Band - 2017-04-11
478	0	0	0	0	0	0	\N	351	CNA - Sliammon First Nation - 2017-04-11
479	0	0	0	0	0	0	\N	235	CNA - Ditidaht First Nation - 2017-04-13
469	0	0	0	0	0	0	\N	245	CNA - Gitwangak Band Council - 2017-03-27
480	16	10	21	286	258	544	213	300	CNA - Nadleh Whut'en - 2017-04-13
481	2	4	3	83	91	174	214	341	CNA - Shxw'owhamel First Nation - 2017-04-20
482	18	28	55	360	225	585	215	298	CNA - Mowachaht / Muchalaht - 2017-04-24
483	90	20	98	1	405	406	216	306	CNA - Gingolx Village Government - 2017-04-24
484	110	40	48	1	378	379	216	308	CNA - Laxgalts'ap Village Government - 2017-04-24
485	90	90	110	1	758	759	216	309	CNA - New Aiyansh Village - 2017-04-24
487	1	0	7	15	7	22	217	276	CNA - Kwiakah First Nation - 2017-04-25
488	8	23	127	731	389	1120	217	221	CNA - We Wai Kai First Nation - 2017-04-25
489	12	20	155	415	395	810	217	218	CNA - Wei Wai Kum First Nation - 2017-04-25
415	1	3	112	779	550	1329	180	263	CNA - Tk'emlups (Kamloops) - 2016-12-06
416	0	1	2	40	52	92	181	278	CNA - Kwikwetlem First Nation - 2016-12-06
417	14	21	0	338	541	879	182	317	CNA - Osoyoos Indian Band - 2016-12-07
418	23	0	147	495	570	1065	183	322	CNA - Penticton Indian Band - 2016-12-07
419	0	1	8	100	50	150	184	403	CNA - Yale First Nation - 2016-12-07
420	10	12	39	497	398	895	185	357	CNA - Splats'in - 2016-12-07
421	0	0	0	0	0	0	\N	313	CNA - Nuxalk Nation - 2016-12-08
422	24	131	126	230	314	544	186	272	CNA - Kwadacha - 2016-12-08
424	6	37	130	70	430	500	188	359	CNA - Squamish Nation - 2016-12-09
501	0	0	0	0	0	0	\N	301	CNA - Nak'azdli Band - 2017-04-26
502	0	0	0	0	0	0	\N	330	CNA - Saik'uz First Nation - 2017-04-26
503	0	0	0	0	0	0	\N	362	CNA - Stellat'en First Nation - 2017-04-26
505	0	0	0	0	0	0	\N	371	CNA - Tl’azt’en Nation  - 2017-04-26
506	0	0	0	0	0	0	\N	216	CNA - Ts'il Kaz Koh (Burns Lake) - 2017-04-26
507	0	0	0	0	0	0	\N	394	CNA - Westbank First Nation - 2017-04-26
508	9	25	96	1060	687	1747	225	353	CNA - Snuneymuxw First Nation - 2017-04-26
509	10	227	86	2465	2492	4957	226	231	CNA - Cowichan Tribes - 2017-04-27
510	8	14	19	323	100	423	227	283	CNA - Lheidli T'enneh Band - 2017-04-27
511	2	0	26	191	95	286	228	274	CNA - Kwantlen First Nation - 2017-04-27
512	4	15	67	476	220	696	229	342	CNA - Simpcw - 2017-04-27
513	96	147	183	195	274	469	230	363	CNA - Yunesit'in - 2017-04-27
514	3	10	59	300	150	450	231	238	CNA - ʔiiḥatis (Ehattesaht) - 2017-04-27
515	30	38	40	714	443	1157	232	245	CNA - Gitwangak Band Council - 2017-04-27
516	17	85	48	400	350	750	233	273	CNA - Kwakiutl Band Council - 2017-04-27
517	10	100	59	435	372	807	234	273	CNA - Kwakiutl Band Council - 2017-05-05
518	35	27	147	487	554	1041	235	322	CNA - Penticton Indian Band - 2017-05-05
519	32	12	19	250	275	525	236	258	CNA - Homalco First Nation - 2017-05-11
520	0	0	0	163	75	238	\N	264	CNA - Kanaka Bar Indian Band - 2017-05-11
521	16	225	113	704	429	1133	237	369	CNA - Tla-o-qui-aht First Nation - 2017-05-17
522	0	0	0	0	0	0	\N	371	CNA - Tl’azt’en Nation  - 2017-05-24
526	33	27	106	1278	528	1806	240	308	CNA - Laxgalts'ap Village Government - 2017-05-30
527	24	36	132	1079	783	1862	240	309	CNA - New Aiyansh Village - 2017-05-30
529	2	14	194	1000	780	1780	241	315	CNA - Old Masset Village Council - 2017-06-02
530	285	27	104	1019	585	1604	242	372	CNA - Tl'etinqox-T'in Government Office - 2017-06-02
531	0	0	0	0	0	0	\N	228	CNA - Coldwater - 2017-06-06
532	0	0	0	0	0	0	\N	230	CNA - Cook's Ferry - 2017-06-06
536	0	10	39	366	95	461	244	344	CNA - Skatin Nations - 2017-06-08
537	33	76	278	1100	600	1700	246	206	CNA - Ahousaht - 2017-06-12
538	0	0	0	0	0	0	\N	209	CNA - Ashcroft Indian Band - 2017-06-12
540	0	0	0	0	0	0	\N	228	CNA - Coldwater - 2017-06-12
541	0	0	0	0	0	0	\N	230	CNA - Cook's Ferry - 2017-06-12
542	0	0	0	0	0	0	\N	305	CNA - Nicomen Indian Band - 2017-06-12
543	0	0	0	0	0	0	\N	310	CNA - Nooaitch - 2017-06-12
544	0	0	0	0	0	0	\N	338	CNA - Shackan - 2017-06-12
545	0	0	0	0	0	0	\N	343	CNA - Siska Indian Band - 2017-06-12
546	2	5	33	354	237	591	247	304	CNA - Neskonlith - 2017-06-12
534	0	0	0	0	0	0	\N	310	CNA - Nooaitch - 2017-06-06
535	0	0	0	0	0	0	\N	338	CNA - Shackan - 2017-06-06
533	45	16	209	563	687	1250	243	287	CNA - Lower Nicola Indian Band - 2017-06-06
547	2	2	47	220	72	292	248	237	CNA - Douglas First Nation - 2017-06-13
548	3	152	160	521	537	1058	249	263	CNA - Tk'emlups (Kamloops) - 2017-06-13
549	0	0	0	0	0	0	\N	359	CNA - Squamish Nation - 2017-06-14
550	58	111	4	522	523	1045	245	389	CNA - Ulkatchot'en - 2017-06-14
552	0	4	9	292	81	373	251	331	CNA - Samahquam Nation - 2017-06-15
553	19	36	55	360	225	585	253	298	CNA - Mowachaht / Muchalaht - 2017-06-15
555	18	25	30	500	80	580	255	378	CNA - Dzawada̱ʼenux̱w (Tsawataineuk) - 2017-06-15
556	4	17	166	159	188	347	\N	361	CNA - ʔaq̓am (St. Mary's Band) - 2017-06-16
557	0	8	20	101	264	365	256	320	CNA - BOḰEĆEN (Pauquachin) - 2017-06-16
558	0	15	87	212	537	749	256	379	CNA - SȾÁUTW̱ (Tsawout) - 2017-06-16
559	4	12	341	281	600	881	256	377	CNA - W̱JOȽEȽP (Tsartlip) - 2017-06-16
560	0	4	10	48	104	152	256	383	CNA - W̱SIḴEM (Tseycum) - 2017-06-16
561	18	11	42	211	248	459	257	288	CNA - Lower Similkameen Indian Band - 2017-06-16
562	6	4	29	157	204	361	258	311	CNA - N'Quatqua - 2017-06-16
563	82	72	74	500	500	1000	259	398	CNA - Xaxli'p First Nation - 2017-06-23
564	5	0	14	5	21	26	252	280	CNA - Lake Cowichan First Nation - 2017-06-23
554	5	17	0	159	188	347	254	361	CNA - ʔaq̓am (St. Mary's Band) - 2017-06-15
565	0	0	0	0	0	0	\N	243	CNA - Gitanyow Band Council - 2017-06-27
566	112	157	64	718	697	1415	260	266	CNA - Anspa yaxw (Kispiox) - 2017-06-27
491	2	16	132	291	2	293	219	387	CNA - Uchucklesaht Tribe - 2017-04-25
493	0	0	0	0	0	0	\N	236	CNA - Doig  River First Nation - 2017-04-25
494	7	10	40	364	299	663	221	268	CNA - Kitselas First Nation - 2017-04-25
495	94	32	185	1382	675	2057	222	296	CNA - Moricetown Band Office - 2017-04-25
496	13	54	44	314	224	538	223	345	CNA - Skeetchestn - 2017-04-26
497	3	152	160	521	537	1058	224	263	CNA - Tk'emlups (Kamloops) - 2017-04-26
498	0	0	0	0	0	0	\N	233	CNA - Daylu Dena Council - 2017-04-26
499	0	0	0	0	0	0	\N	234	CNA - Dease River First Nation - 2017-04-26
500	0	0	0	0	0	0	\N	300	CNA - Nadleh Whut'en - 2017-04-26
579	0	0	0	0	0	0	\N	304	CNA - Neskonlith - 2017-11-07
580	0	0	0	0	0	0	\N	205	CNA - Sexqeltqín (Adams Lake) - 2017-11-07
581	0	0	0	0	0	0	\N	357	CNA - Splats'in - 2017-11-07
582	0	0	0	0	0	0	\N	274	CNA - Kwantlen First Nation - 2017-11-07
583	0	0	0	0	0	0	\N	315	CNA - Old Masset Village Council - 2017-11-07
584	0	0	0	0	0	0	\N	346	CNA - Skidegate Band Council - 2017-11-07
585	7	20	41	412	309	721	263	220	CNA - Canoe Creek - 2017-11-08
586	91	337	203	460	472	932	263	239	CNA - Esketemc - 2017-11-08
587	6	15	169	471	273	744	263	397	CNA - T'exelcemc (Williams Lake) - 2017-11-08
588	11	45	57	182	420	602	263	219	CNA - Tsq'escenemc (Canim Lake) - 2017-11-08
589	1	0	33	236	179	415	263	354	CNA - Xats'ull (Soda Creek) - 2017-11-08
590	19	60	205	450	180	630	264	254	CNA - Gitga'at Nation - 2017-11-09
591	3	7	110	883	90	973	264	295	CNA - Metlakatla Band Council - 2017-11-09
592	3	17	64	498	249	747	265	269	CNA - Kitsumkalum Band Council - 2017-11-14
593	0	0	0	0	0	0	\N	318	CNA - Wuikinuxv Nation - 2017-11-16
594	13	38	59	640	50	690	267	256	CNA - Hesquiaht - 2017-11-17
595	0	0	0	0	0	0	\N	362	CNA - Stellat'en First Nation - 2017-11-17
596	0	0	0	0	0	0	\N	314	CNA - Okanagan Indian Band - 2017-11-17
597	0	0	0	0	0	0	\N	394	CNA - Westbank First Nation - 2017-11-17
598	1	4	4	212	307	519	268	267	CNA - Kitasoo/Xaixais Nation - 2017-11-20
600	0	0	0	0	0	0	\N	309	CNA - New Aiyansh Village - 2017-11-21
601	9	28	324	1971	2076	4047	269	359	CNA - Squamish Nation - 2017-11-23
603	23	0	184	433	643	1076	266	322	CNA - Penticton Indian Band - 2017-11-27
604	33	76	278	1100	600	1700	271	206	CNA - Ahousaht - 2017-11-29
605	17	6	71	965	697	1662	272	346	CNA - Skidegate Band Council - 2017-11-30
606	18	33	1465	1200	581	1781	273	371	CNA - Tl’azt’en Nation  - 2017-11-30
607	89	0	123	1235	636	1871	274	252	CNA - Haisla - 2017-12-01
608	26	30	84	502	304	806	275	261	CNA - Iskut First Nation - 2017-12-02
609	17	23	72	1596	293	1889	275	365	CNA - Tahltan Nation - 2017-12-02
610	10	10	79	506	398	904	277	357	CNA - Splats'in - 2017-12-04
611	1	19	20	170	30	200	276	234	CNA - Dease River First Nation - 2017-12-05
612	9	25	55	212	307	519	278	267	CNA - Kitasoo/Xaixais Nation - 2017-12-05
613	12	10	8	520	480	1000	279	330	CNA - Saik'uz First Nation - 2017-12-05
614	7	15	9	448	228	676	280	388	CNA - Ucluelet First Nation - 2017-12-05
615	18	15	2	240	268	508	281	362	CNA - Stellat'en First Nation - 2017-12-06
616	11	54	31	700	50	750	282	256	CNA - Hesquiaht - 2017-12-06
617	6	24	449	2041	2239	4280	283	359	CNA - Squamish Nation - 2017-12-06
618	5	8	9	91	83	174	284	329	CNA - Lhtako Dene Nation - 2017-12-07
619	13	21	67	402	370	772	285	205	CNA - Sexqeltqín (Adams Lake) - 2017-12-07
620	194	149	12	589	419	1008	286	244	CNA - Gitsegukla Band Council - 2017-12-08
621	5	17	58	180	101	281	287	274	CNA - Kwantlen First Nation - 2017-12-08
622	18	3	146	900	809	1709	288	314	CNA - Okanagan Indian Band - 2017-12-08
623	416	247	128	863	1447	2310	289	279	CNA - Lake Babine Nation - 2017-12-11
624	5	0	0	1238	795	2033	290	290	CNA - Lytton First Nation - 2017-12-12
625	10	0	0	0	815	815	\N	394	CNA - Westbank First Nation - 2017-12-12
626	111	139	179	750	1450	2200	291	301	CNA - Nak'azdli Band - 2017-12-12
627	5	9	47	340	150	490	292	238	CNA - ʔiiḥatis (Ehattesaht) - 2017-12-13
628	10	11	48	227	141	368	293	393	CNA - West Moberly First Nations - 2017-12-13
629	42	728	324	767	1452	2219	294	297	CNA - Lil'wat Nation - 2017-12-13
635	0	0	0	0	0	0	\N	229	CNA - K'ómoks First Nation - 2017-12-13
639	0	0	0	0	0	0	\N	292	CNA - Mama̱liliḵa̱la / Qwe'Qwa'Sot'Em - 2017-12-13
631	0	0	0	0	0	0	\N	378	CNA - Dzawada̱ʼenux̱w (Tsawataineuk) - 2017-12-13
636	0	0	0	0	0	0	\N	273	CNA - Kwakiutl Band Council - 2017-12-13
640	0	0	0	0	0	0	\N	370	CNA - T̕łat̕łasiḵ̕wala - 2017-12-13
632	0	0	0	0	0	0	\N	248	CNA - Gwa'sala-'Nakwaxda'xw First Nation - 2017-12-13
637	0	0	0	0	0	0	\N	276	CNA - Kwiakah First Nation - 2017-12-13
641	0	0	0	0	0	0	\N	221	CNA - We Wai Kai First Nation - 2017-12-13
633	0	0	0	0	0	0	\N	249	CNA - Gwawaʼenux̱w - 2017-12-13
638	0	0	0	0	0	0	\N	277	CNA - Ḵwikwa̱sutinux̱  / Ha̱'xwa-mis - 2017-12-13
569	0	0	0	0	0	0	\N	287	CNA - Lower Nicola Indian Band - 2017-07-20
572	0	0	0	0	0	0	\N	228	CNA - Coldwater - 2017-10-16
576	0	0	0	0	0	0	\N	338	CNA - Shackan - 2017-10-16
570	0	0	0	0	0	0	\N	209	CNA - Ashcroft Indian Band - 2017-10-16
573	0	0	0	0	0	0	\N	230	CNA - Cook's Ferry - 2017-10-16
578	1	0	0	53	179	232	\N	204	CNA - ʔEsdilagh - 2017-10-23
568	6	10	58	237	182	419	262	247	CNA - Sik-edakh (Glen Vowell) - 2017-06-28
571	0	0	0	0	0	0	\N	214	CNA - Boston Bar First Nation  - 2017-10-16
575	0	0	0	0	0	0	\N	310	CNA - Nooaitch - 2017-10-16
654	112	157	64	718	697	1415	303	266	CNA - Anspa yaxw (Kispiox) - 2017-12-14
655	48	59	60	912	822	1734	303	243	CNA - Gitanyow Band Council - 2017-12-14
656	44	74	45	567	415	982	303	244	CNA - Gitsegukla Band Council - 2017-12-14
657	22	34	48	227	181	408	303	247	CNA - Sik-edakh (Glen Vowell) - 2017-12-14
658	62	25	0	143	140	283	305	253	CNA - Halfway River First Nations - 2017-12-14
648	10	0	164	423	426	849	299	394	CNA - Westbank First Nation - 2017-12-13
659	8	12	12	180	63	243	306	264	CNA - Kanaka Bar Indian Band - 2017-12-14
660	10	4	119	208	371	579	307	317	CNA - Osoyoos Indian Band - 2017-12-14
661	7	32	63	390	198	588	308	298	CNA - Mowachaht / Muchalaht - 2017-12-14
678	0	0	0	0	0	0	\N	353	CNA - Snuneymuxw First Nation - 2017-12-15
679	0	0	0	0	0	0	\N	258	CNA - Homalco First Nation - 2017-12-15
680	0	0	0	0	0	0	\N	270	CNA - Klahoose First Nation - 2017-12-15
681	0	8	20	101	264	365	313	320	CNA - BOḰEĆEN (Pauquachin) - 2017-12-15
682	0	15	87	212	537	749	313	379	CNA - SȾÁUTW̱ (Tsawout) - 2017-12-15
683	4	12	341	281	600	881	313	377	CNA - W̱JOȽEȽP (Tsartlip) - 2017-12-15
671	0	4	10	48	104	152	313	383	CNA - W̱SIḴEM (Tseycum) - 2017-12-15
673	0	0	0	0	0	0	\N	231	CNA - Cowichan Tribes - 2017-12-15
674	0	0	0	0	0	0	\N	280	CNA - Lake Cowichan First Nation - 2017-12-15
675	0	0	0	0	0	0	\N	289	CNA - Lyackson First Nation - 2017-12-15
645	13	10	0	227	242	469	296	211	CNA - Blueberry River First Nations - 2017-12-13
646	30	38	45	902	402	1304	297	245	CNA - Gitwangak Band Council - 2017-12-13
647	11	18	621	788	944	1732	298	313	CNA - Nuxalk Nation - 2017-12-13
649	1	0	4	106	200	306	300	240	CNA - SXIMEȽEȽ (Esquimalt) - 2017-12-13
650	18	32	200	152	125	277	301	325	CNA - Prophet River First Nation - 2017-12-14
651	11	57	48	527	247	774	302	235	CNA - Ditidaht First Nation - 2017-12-14
652	117	202	115	1643	2337	3980	303	242	CNA - Gitanmaax Band Council - 2017-12-14
653	13	7	156	552	427	979	304	391	CNA - Upper Nicola Band - 2017-12-14
666	35	5	40	300	400	700	312	302	CNA - ʼNa̱mǥis First Nation - 2017-12-15
667	0	0	0	0	0	0	\N	210	CNA - Scia'new (Beecher Bay) - 2017-12-15
668	0	0	0	0	0	0	\N	355	CNA - Songhees Nation - 2017-12-15
669	0	0	0	0	0	0	\N	240	CNA - SXIMEȽEȽ (Esquimalt) - 2017-12-15
676	0	0	0	0	0	0	\N	321	CNA - Penelakut Tribe - 2017-12-15
677	0	0	0	0	0	0	\N	327	CNA - Qualicum First Nation - 2017-12-15
662	0	0	0	75	180	0	309	352	CNA - Snaw-Naw-As First Nation  - 2017-12-15
663	0	0	0	0	0	0	\N	251	CNA - Halalt First Nation - 2017-12-15
664	7	8	57	750	300	1050	310	235	CNA - Ditidaht First Nation - 2017-12-15
665	2	2	44	226	192	418	311	368	CNA - T’ít’q’et First Nation - 2017-12-15
700	1	0	2	150	150	300	321	367	CNA - Taku River Tlingit First Nation - 2017-12-16
701	101	78	115	367	336	703	322	208	CNA - Tsi Del Del - 2018-01-11
704	0	0	0	0	0	0	\N	366	CNA - Takla Lake First Nation - 2018-01-15
705	0	5	10	144	12	156	325	376	CNA - Toquaht First Nation - 2018-01-15
707	14	79	319	507	600	1107	326	351	CNA - Sliammon First Nation - 2018-01-18
708	0	7	60	620	675	1295	327	299	CNA - xʷməθkʷəy̓əm (Musqueam) - 2018-01-19
709	0	0	0	0	0	0	\N	289	CNA - Lyackson First Nation - 2018-01-23
710	285	27	104	1019	585	1604	328	372	CNA - Tl'etinqox-T'in Government Office - 2018-01-26
711	0	0	0	0	0	0	\N	266	CNA - Anspa yaxw (Kispiox) - 2018-01-29
694	13	56	74	287	253	540	319	345	CNA - Skeetchestn - 2017-12-15
695	0	0	0	0	0	0	\N	212	CNA - St'uxwtéws (Bonaparte) - 2017-12-15
696	0	0	0	0	0	0	\N	263	CNA - Tk'emlups (Kamloops) - 2017-12-15
697	0	0	0	0	0	0	\N	219	CNA - Tsq'escenemc (Canim Lake) - 2017-12-15
698	0	0	0	0	0	0	\N	354	CNA - Xats'ull (Soda Creek) - 2017-12-15
712	90	20	98	1	405	406	329	306	CNA - Gingolx Village Government - 2018-01-30
713	110	40	48	1	378	379	329	308	CNA - Laxgalts'ap Village Government - 2018-01-30
714	90	90	110	1	758	759	329	309	CNA - New Aiyansh Village - 2018-01-30
703	12	13	18	512	200	712	324	220	CNA - Canoe Creek - 2018-01-15
715	41	10	38	1	200	201	329	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2018-01-30
644	1	15	23	345	60	405	295	270	CNA - Klahoose First Nation - 2017-12-13
686	24	131	126	230	314	544	317	272	CNA - Kwadacha - 2017-12-15
687	8	12	50	344	76	420	318	283	CNA - Lheidli T'enneh Band - 2017-12-15
688	0	0	0	0	0	0	\N	220	CNA - Canoe Creek - 2017-12-15
689	0	0	0	0	0	0	\N	239	CNA - Esketemc - 2017-12-15
691	0	0	0	0	0	0	\N	396	CNA - Pellt'iq't (Whispering Pines/Clinton) - 2017-12-15
692	0	0	0	0	0	0	\N	205	CNA - Sexqeltqín (Adams Lake) - 2017-12-15
693	0	0	0	0	0	0	\N	342	CNA - Simpcw - 2017-12-15
699	12	9	52	275	200	475	320	215	CNA - Nxwísten (Bridge River) - 2017-12-15
684	60	56	110	464	500	964	315	243	CNA - Gitanyow Band Council - 2017-12-15
685	0	7	7	265	306	571	316	265	CNA - Katzie First Nation - 2017-12-15
718	13	7	6	150	205	355	332	285	CNA - Skwlax (Little Shuswap) - 2018-02-01
719	0	0	0	0	0	0	\N	229	CNA - K'ómoks First Nation - 2018-02-01
720	1	4	0	15	30	45	333	275	CNA - Kwaw-kwaw-apilt First Nation - 2018-02-02
722	0	0	0	98	0	98	335	326	CNA - Qayqayt First Nation - 2018-02-02
721	30	30	14	227	242	469	334	211	CNA - Blueberry River First Nations - 2018-02-02
734	0	0	0	0	0	0	\N	379	CNA - SȾÁUTW̱ (Tsawout) - 2018-04-11
736	0	0	0	0	0	0	\N	383	CNA - W̱SIḴEM (Tseycum) - 2018-04-11
737	1	87	71	170	79	249	345	209	CNA - Ashcroft Indian Band - 2018-04-12
738	1	174	107	181	90	271	345	214	CNA - Boston Bar First Nation  - 2018-04-12
739	137	533	351	563	384	947	345	228	CNA - Coldwater - 2018-04-12
740	11	149	67	290	60	350	345	230	CNA - Cook's Ferry - 2018-04-12
741	3	84	43	71	61	132	345	305	CNA - Nicomen Indian Band - 2018-04-12
743	11	84	45	83	44	127	345	338	CNA - Shackan - 2018-04-12
744	29	110	65	256	64	320	345	343	CNA - Siska Indian Band - 2018-04-12
745	1	4	4	212	307	519	346	267	CNA - Kitasoo/Xaixais Nation - 2018-04-14
746	88	32	201	1381	659	2040	347	296	CNA - Moricetown Band Office - 2018-04-15
747	0	0	0	0	0	0	\N	294	CNA - McLeod Lake - 2018-04-16
748	10	9	7	549	232	781	348	397	CNA - T'exelcemc (Williams Lake) - 2018-04-16
749	16	7	557	300	900	1200	\N	226	CNA - Chemainus First Nation - 2018-04-17
750	16	7	557	300	900	1200	350	226	CNA - Stz'uminus First Nation - 2018-04-17
751	0	0	0	0	0	0	\N	266	CNA - Anspa yaxw (Kispiox) - 2018-04-17
752	96	147	183	195	274	469	351	363	CNA - Yunesit'in - 2018-04-17
754	12	22	87	1109	721	1830	352	353	CNA - Snuneymuxw First Nation - 2018-04-18
755	0	0	201	0	0	0	\N	334	CNA - Seabird Island Indian Band - 2018-04-19
756	120	90	287	921	969	1890	353	302	CNA - ʼNa̱mǥis First Nation - 2018-04-19
757	0	0	0	0	0	0	\N	317	CNA - Osoyoos Indian Band - 2018-04-19
758	1	9	41	230	400	630	354	355	CNA - Songhees Nation - 2018-04-19
759	1	0	4	106	200	306	355	240	CNA - SXIMEȽEȽ (Esquimalt) - 2018-04-20
760	2	14	81	799	561	1360	356	263	CNA - Tk'emlups (Kamloops) - 2018-04-20
761	4	10	117	133	111	244	357	286	CNA - yaqan nuʔkiy (Lower Kootenay) - 2018-04-20
726	12	50	52	115	94	209	340	374	CNA - ʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) - 2018-02-23
727	7	20	10	400	430	830	341	373	CNA - Ławitʼsis (Tlowitsis) - 2018-03-16
728	11	6	41	159	90	249	342	395	CNA - Wet'suwet'en First Nation - 2018-03-27
729	0	0	0	375	475	850	343	334	CNA - Seabird Island Indian Band - 2018-03-31
730	0	0	0	0	0	0	\N	241	CNA - Fort Nelson First Nation - 2018-04-04
731	2	0	0	250	80	330	344	339	CNA - Kenpesq't (Shuswap) - 2018-04-05
732	0	0	0	0	0	0	\N	241	CNA - Fort Nelson First Nation - 2018-04-05
733	0	0	0	0	0	0	\N	320	CNA - BOḰEĆEN (Pauquachin) - 2018-04-11
766	0	0	0	0	0	0	\N	331	CNA - Samahquam Nation - 2018-04-22
767	0	0	0	0	0	0	\N	344	CNA - Skatin Nations - 2018-04-22
768	187	121	115	158	150	308	360	236	CNA - Doig  River First Nation - 2018-04-23
769	0	0	86	180	90	270	362	319	CNA - Pacheedaht First Nation - 2018-04-23
770	0	0	0	0	0	0	\N	266	CNA - Anspa yaxw (Kispiox) - 2018-04-23
771	30	144	282	1206	1605	2811	363	255	CNA - Heiltsuk Nation - 2018-04-23
772	26	1072	880	429	704	1133	364	369	CNA - Tla-o-qui-aht First Nation - 2018-04-23
777	0	0	0	0	0	0	\N	211	CNA - Blueberry River First Nations - 2018-04-23
778	0	0	0	0	0	0	\N	241	CNA - Fort Nelson First Nation - 2018-04-23
775	0	0	0	0	0	0	\N	393	CNA - West Moberly First Nations - 2018-04-23
776	0	8	12	237	265	502	361	217	CNA - Tsleil-Waututh Nation - 2018-04-23
789	4	44	71	153	83	236	367	286	CNA - yaqan nuʔkiy (Lower Kootenay) - 2018-04-24
717	2	2	10	165	70	235	331	213	CNA - Boothroyd Band - 2018-02-01
780	0	0	0	0	0	0	\N	282	CNA - Leq'á:mel First Nation - 2018-04-24
781	0	0	0	0	0	0	\N	293	CNA - Matsqui First Nation - 2018-04-24
783	0	0	0	0	0	0	\N	348	CNA - Skowkale First Nation - 2018-04-24
784	0	0	0	0	0	0	\N	340	CNA - Skway First Nation - 2018-04-24
785	0	0	0	0	0	0	\N	360	CNA - Squiala First Nation - 2018-04-24
786	0	0	0	0	0	0	\N	364	CNA - Sumas First Nation - 2018-04-24
787	0	2	44	325	251	576	\N	386	CNA - Tzeachten First Nation - 2018-04-24
788	0	0	0	0	0	0	\N	400	CNA - Yakweakwioose Band - 2018-04-24
723	1	0	1	127	130	257	337	210	CNA - Scia'new (Beecher Bay) - 2018-02-02
724	13	49	26	390	423	813	338	241	CNA - Fort Nelson First Nation - 2018-02-07
762	1	0	7	15	7	22	359	276	CNA - Kwiakah First Nation - 2018-04-21
763	7	23	127	770	374	1144	359	221	CNA - We Wai Kai First Nation - 2018-04-21
764	12	20	155	427	405	832	359	218	CNA - Wei Wai Kum First Nation - 2018-04-21
765	0	0	0	0	0	0	\N	237	CNA - Douglas First Nation - 2018-04-22
773	10	227	154	2501	2521	5022	366	231	CNA - Cowichan Tribes - 2018-04-23
779	0	0	0	0	0	0	\N	207	CNA - Aitchelitz First Nation  - 2018-04-24
801	0	0	0	0	0	0	\N	234	CNA - Dease River First Nation - 2018-04-24
802	8	3	65	201	219	420	372	215	CNA - Nxwísten (Bridge River) - 2018-04-24
803	2	2	35	107	86	193	372	222	CNA - Sekw’el’wás (Cayoose Creek) - 2018-04-24
804	11	5	34	331	151	482	372	384	CNA - Ts'kw'aylaxw - 2018-04-24
805	12	5	89	402	245	647	372	337	CNA - Tsal'álh (Seton Lake) - 2018-04-24
806	1	5	93	185	194	379	372	368	CNA - T’ít’q’et First Nation - 2018-04-24
807	9	12	1	565	394	959	372	398	CNA - Xaxli'p First Nation - 2018-04-24
809	10	14	140	400	1000	1400	374	321	CNA - Penelakut Tribe - 2018-04-25
810	2	0	1	117	84	201	375	251	CNA - Halalt First Nation - 2018-04-25
811	9	36	76	360	225	585	376	298	CNA - Mowachaht / Muchalaht - 2018-04-25
800	3	5	42	590	467	1057	371	225	CNA - Chehalis Indian Band - 2018-04-24
812	19	29	25	231	286	517	378	288	CNA - Lower Similkameen Indian Band - 2018-04-25
813	38	20	97	1116	918	2034	378	314	CNA - Okanagan Indian Band - 2018-04-25
814	10	13	92	153	390	543	378	317	CNA - Osoyoos Indian Band - 2018-04-25
815	29	26	172	433	643	1076	378	322	CNA - Penticton Indian Band - 2018-04-25
817	4	0	9	139	72	211	378	392	CNA - Upper Similkameen Indian Band - 2018-04-25
818	37	8	78	428	461	889	378	394	CNA - Westbank First Nation - 2018-04-25
819	0	0	0	729	484	1213	\N	382	CNA - Tseshaht First Nation - 2018-04-25
820	4	2	40	200	14	214	375	289	CNA - Lyackson First Nation - 2018-04-25
821	10	61	57	435	376	811	379	273	CNA - Kwakiutl Band Council - 2018-04-25
822	0	0	0	0	0	0	\N	214	CNA - Boston Bar First Nation  - 2018-04-25
823	0	0	0	0	0	0	\N	230	CNA - Cook's Ferry - 2018-04-25
824	0	0	0	0	0	0	\N	264	CNA - Kanaka Bar Indian Band - 2018-04-25
825	0	0	0	0	0	0	\N	290	CNA - Lytton First Nation - 2018-04-25
826	0	0	0	0	0	0	\N	305	CNA - Nicomen Indian Band - 2018-04-25
827	0	0	0	0	0	0	\N	343	CNA - Siska Indian Band - 2018-04-25
792	7	10	216	159	188	347	367	361	CNA - ʔaq̓am (St. Mary's Band) - 2018-04-24
793	2	1	5	343	205	548	368	224	CNA - Cheam First Nation - 2018-04-24
794	0	0	0	0	0	0	\N	241	CNA - Fort Nelson First Nation - 2018-04-24
795	0	8	20	101	264	365	369	320	CNA - BOḰEĆEN (Pauquachin) - 2018-04-24
796	0	15	87	212	537	749	369	379	CNA - SȾÁUTW̱ (Tsawout) - 2018-04-24
797	4	12	341	281	600	881	369	377	CNA - W̱JOȽEȽP (Tsartlip) - 2018-04-24
798	0	4	10	48	104	152	369	383	CNA - W̱SIḴEM (Tseycum) - 2018-04-24
799	7	177	331	800	500	1300	370	382	CNA - Tseshaht First Nation - 2018-04-24
839	0	0	0	0	0	0	\N	371	CNA - Tl’azt’en Nation  - 2018-05-09
840	0	0	0	17	25	42	\N	207	CNA - Aitchelitz First Nation  - 2018-05-18
841	0	0	0	0	0	0	\N	275	CNA - Kwaw-kwaw-apilt First Nation - 2018-05-18
843	0	0	0	149	117	266	\N	293	CNA - Matsqui First Nation - 2018-05-18
844	0	0	0	11	1	12	\N	324	CNA - Popkum First Nation - 2018-05-18
845	0	0	0	77	11	88	\N	401	CNA - Skawahlook First Nation - 2018-05-18
846	0	0	0	75	184	259	\N	348	CNA - Skowkale First Nation - 2018-05-18
847	0	0	0	0	0	0	\N	350	CNA - Skwah First Nation - 2018-05-18
848	0	0	0	307	105	412	\N	340	CNA - Skway First Nation - 2018-05-18
849	0	0	0	72	147	219	\N	360	CNA - Squiala First Nation - 2018-05-18
850	0	0	0	155	175	330	\N	364	CNA - Sumas First Nation - 2018-05-18
851	0	0	0	525	266	791	\N	386	CNA - Tzeachten First Nation - 2018-05-18
852	0	0	0	37	34	71	\N	400	CNA - Yakweakwioose Band - 2018-05-18
854	0	0	0	0	0	0	\N	208	CNA - Tsi Del Del - 2018-05-29
855	0	0	0	0	0	0	\N	331	CNA - Samahquam Nation - 2018-05-30
856	45	16	209	563	687	1250	385	287	CNA - Lower Nicola Indian Band - 2018-06-01
857	172	329	467	528	527	1055	386	389	CNA - Ulkatchot'en - 2018-06-06
858	2	14	81	799	561	1360	387	263	CNA - Tk'emlups (Kamloops) - 2018-06-10
859	0	0	0	0	0	0	\N	231	CNA - Cowichan Tribes - 2018-06-11
860	10	16	172	433	643	1076	388	322	CNA - Penticton Indian Band - 2018-06-11
861	22	33	17	231	241	472	389	258	CNA - Homalco First Nation - 2018-06-11
863	71	83	168	349	482	831	391	243	CNA - Gitanyow Band Council - 2018-06-12
791	11	11	25	117	158	275	367	405	CNA - ʔakisq̓nuk First Nation - 2018-04-24
831	22	0	0	227	181	408	\N	247	CNA - Sik-edakh (Glen Vowell) - 2018-04-25
832	0	7	533	265	317	582	382	265	CNA - Katzie First Nation - 2018-04-25
833	12	56	74	285	264	549	377	345	CNA - Skeetchestn - 2018-04-25
834	0	0	0	500	1228	1228	383	255	CNA - Heiltsuk Nation - 2018-05-03
835	21	30	73	432	167	599	384	262	CNA - Ka:'yu:'k't'h' / Che:k:tles7et'h' - 2018-05-09
836	0	0	0	0	0	0	\N	396	CNA - Pellt'iq't (Whispering Pines/Clinton) - 2018-05-09
837	0	0	0	0	0	0	\N	345	CNA - Skeetchestn - 2018-05-09
862	33	76	278	1100	600	1700	390	206	CNA - Ahousaht - 2018-06-12
838	0	0	0	0	0	0	\N	263	CNA - Tk'emlups (Kamloops) - 2018-05-09
828	0	0	0	476	220	0	381	342	CNA - Simpcw - 2018-04-25
830	12	0	52	718	697	1415	\N	266	CNA - Anspa yaxw (Kispiox) - 2018-04-25
874	0	0	0	0	0	0	395	333	CNA - Scowlitz First Nation - 2018-10-05
875	0	0	0	0	0	0	395	364	CNA - Sumas First Nation - 2018-10-05
877	16	219	0	800	249	1049	397	398	CNA - Xaxli'p First Nation - 2018-10-18
878	90	20	98	1	405	406	398	306	CNA - Gingolx Village Government - 2018-10-18
879	110	40	48	1	378	379	398	308	CNA - Laxgalts'ap Village Government - 2018-10-18
880	90	90	110	1	758	759	398	309	CNA - New Aiyansh Village - 2018-10-18
881	41	10	38	1	200	201	398	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2018-10-18
882	18	812	804	702	128	830	399	254	CNA - Gitga'at Nation - 2018-10-21
883	5	6	8	67	66	133	400	305	CNA - Nicomen Indian Band - 2018-10-23
884	30	32	64	124	112	236	400	310	CNA - Nooaitch - 2018-10-23
885	5	9	1	102	31	133	400	338	CNA - Shackan - 2018-10-23
886	0	0	0	0	0	0	\N	361	CNA - ʔaq̓am (St. Mary's Band) - 2018-10-23
887	137	533	351	563	384	947	401	228	CNA - Coldwater - 2018-10-24
888	47	16	213	563	687	1250	401	287	CNA - Lower Nicola Indian Band - 2018-10-24
889	15	176	109	116	120	236	401	310	CNA - Nooaitch - 2018-10-24
891	11	14	147	2303	773	3076	402	315	CNA - Old Masset Village Council - 2018-10-25
893	5	4	18	290	120	410	404	339	CNA - Kenpesq't (Shuswap) - 2018-10-29
895	0	0	0	0	0	0	406	223	CNA - Chawathil First Nation - 2018-10-31
896	0	0	0	0	0	0	406	224	CNA - Cheam First Nation - 2018-10-31
897	0	0	0	0	0	0	406	225	CNA - Chehalis Indian Band - 2018-10-31
898	0	0	0	0	0	0	406	323	CNA - Peters Band - 2018-10-31
899	0	0	0	0	0	0	406	324	CNA - Popkum First Nation - 2018-10-31
900	0	0	0	0	0	0	406	334	CNA - Seabird Island Indian Band - 2018-10-31
901	0	0	0	0	0	0	406	401	CNA - Skawahlook First Nation - 2018-10-31
902	0	0	0	0	0	0	406	390	CNA - Union Bar Band - 2018-10-31
903	0	0	0	0	0	0	406	403	CNA - Yale First Nation - 2018-10-31
892	9	28	342	1974	2077	4051	403	359	CNA - Squamish Nation - 2018-10-28
904	56	237	182	1539	476	2015	407	306	CNA - Gingolx Village Government - 2018-10-31
905	25	4	10	184	52	236	408	204	CNA - ʔEsdilagh - 2018-11-01
906	180	180	215	1440	2160	3600	409	359	CNA - Squamish Nation - 2018-11-01
908	32	22	99	1278	510	1788	410	308	CNA - Laxgalts'ap Village Government - 2018-11-02
910	14	9	39	177	220	397	410	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2018-11-02
907	21	10	57	1399	378	1777	410	306	CNA - Gingolx Village Government - 2018-11-02
909	24	36	252	1079	758	1837	410	309	CNA - New Aiyansh Village - 2018-11-02
911	7	12	12	180	63	243	411	264	CNA - Kanaka Bar Indian Band - 2018-11-04
912	5	0	5	1238	795	2033	411	290	CNA - Lytton First Nation - 2018-11-04
913	10	17	50	470	108	578	412	294	CNA - McLeod Lake - 2018-11-06
914	3	0	20	354	237	591	413	304	CNA - Neskonlith - 2018-11-06
915	0	0	0	0	0	0	414	377	CNA - W̱JOȽEȽP (Tsartlip) - 2018-11-06
916	23	0	190	433	643	1076	415	322	CNA - Penticton Indian Band - 2018-11-06
919	31	23	305	576	440	1016	418	239	CNA - Esketemc - 2018-11-08
917	47	133	12	114	76	190	416	279	CNA - Lake Babine Nation - 2018-11-07
920	21	33	84	796	304	1100	419	261	CNA - Iskut First Nation - 2018-11-08
918	1	6	23	76	178	254	417	352	CNA - Snaw-Naw-As First Nation  - 2018-11-08
921	9	19	73	1858	290	2148	419	365	CNA - Tahltan Nation - 2018-11-08
922	20	26	52	208	189	397	420	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2018-11-09
924	0	0	0	0	0	0	\N	314	CNA - Okanagan Indian Band - 2018-11-13
925	0	0	0	0	0	0	\N	317	CNA - Osoyoos Indian Band - 2018-11-13
926	0	0	0	0	0	0	\N	322	CNA - Penticton Indian Band - 2018-11-13
927	0	0	0	0	0	0	\N	391	CNA - Upper Nicola Band - 2018-11-13
928	0	0	0	0	0	0	\N	392	CNA - Upper Similkameen Indian Band - 2018-11-13
929	0	0	0	0	0	0	\N	394	CNA - Westbank First Nation - 2018-11-13
930	0	0	0	0	0	0	421	274	CNA - Kwantlen First Nation - 2018-11-13
866	2	11	15	120	80	200	392	318	CNA - Wuikinuxv Nation - 2018-06-14
867	0	0	0	0	0	0	\N	368	CNA - T’ít’q’et First Nation - 2018-06-25
868	5	25	98	594	608	1202	393	382	CNA - Tseshaht First Nation - 2018-06-25
869	0	0	0	0	0	0	\N	371	CNA - Tl’azt’en Nation  - 2018-06-27
870	22	22	2	100	100	200	\N	383	CNA - W̱SIḴEM (Tseycum) - 2018-07-04
871	0	0	0	0	0	0	394	297	CNA - Lil'wat Nation - 2018-08-26
872	0	0	0	0	0	0	395	282	CNA - Leq'á:mel First Nation - 2018-10-05
873	0	0	0	0	0	0	395	293	CNA - Matsqui First Nation - 2018-10-05
935	8	16	108	468	532	1000	\N	321	CNA - Penelakut Tribe - 2018-11-14
865	0	0	0	0	0	0	\N	290	CNA - Lytton First Nation - 2018-06-14
937	0	0	36	712	2303	3015	427	315	CNA - Old Masset Village Council - 2018-11-15
931	0	0	0	725	555	0	424	266	CNA - Anspa yaxw (Kispiox) - 2018-11-13
932	0	0	0	1225	670	0	424	242	CNA - Gitanmaax Band Council - 2018-11-13
933	0	0	0	235	245	0	424	247	CNA - Sik-edakh (Glen Vowell) - 2018-11-13
936	5	9	47	360	150	510	426	238	CNA - ʔiiḥatis (Ehattesaht) - 2018-11-15
948	1	3	0	235	155	390	428	350	CNA - Skwah First Nation - 2018-11-15
949	0	0	0	65	170	235	428	340	CNA - Skway First Nation - 2018-11-15
950	4	0	0	120	110	230	428	356	CNA - Soowahlie Indian Band - 2018-11-15
951	0	1	46	40	115	155	428	360	CNA - Squiala First Nation - 2018-11-15
952	0	0	0	80	155	235	428	364	CNA - Sumas First Nation - 2018-11-15
953	1	5	0	185	220	405	428	386	CNA - Tzeachten First Nation - 2018-11-15
954	0	3	0	20	35	55	428	400	CNA - Yakweakwioose Band - 2018-11-15
955	0	0	0	85	60	145	428	403	CNA - Yale First Nation - 2018-11-15
956	10	10	76	508	401	909	429	357	CNA - Splats'in - 2018-11-16
957	0	0	0	0	0	0	430	278	CNA - Kwikwetlem First Nation - 2018-11-16
958	7	10	40	364	299	663	431	268	CNA - Kitselas First Nation - 2018-11-16
960	2	2	47	220	72	292	433	237	CNA - Douglas First Nation - 2018-11-16
961	1	4	9	292	81	373	433	331	CNA - Samahquam Nation - 2018-11-16
962	7	20	39	366	95	461	433	344	CNA - Skatin Nations - 2018-11-16
963	81	683	452	767	1452	2219	435	297	CNA - Lil'wat Nation - 2018-11-21
964	0	0	0	0	0	0	\N	382	CNA - Tseshaht First Nation - 2018-11-23
965	6	8	64	542	238	780	436	235	CNA - Ditidaht First Nation - 2018-11-27
966	0	0	0	0	0	0	437	321	CNA - Penelakut Tribe - 2018-11-27
967	0	4	3	407	135	542	438	282	CNA - Leq'á:mel First Nation - 2018-11-29
968	4	10	18	422	231	653	439	350	CNA - Skwah First Nation - 2018-12-03
969	10	17	50	470	108	578	440	294	CNA - McLeod Lake - 2018-12-04
970	2	185	149	251	186	437	434	368	CNA - T’ít’q’et First Nation - 2018-12-04
971	100	78	115	367	335	702	441	208	CNA - Tsi Del Del - 2018-12-05
974	111	139	179	900	1836	2736	444	301	CNA - Nak'azdli Band - 2018-12-06
940	0	0	0	265	310	575	428	265	CNA - Katzie First Nation - 2018-11-15
941	2	0	0	100	110	210	428	274	CNA - Kwantlen First Nation - 2018-11-15
942	0	0	0	15	25	40	428	275	CNA - Kwaw-kwaw-apilt First Nation - 2018-11-15
943	1	5	0	55	110	165	428	293	CNA - Matsqui First Nation - 2018-11-15
944	0	0	0	85	30	115	428	323	CNA - Peters Band - 2018-11-15
945	2	0	0	40	115	155	428	333	CNA - Scowlitz First Nation - 2018-11-15
946	0	0	0	55	85	140	428	341	CNA - Shxw'owhamel First Nation - 2018-11-15
972	4	12	216	159	188	347	443	361	CNA - ʔaq̓am (St. Mary's Band) - 2018-12-06
973	10	100	59	435	372	807	442	273	CNA - Kwakiutl Band Council - 2018-12-06
947	0	7	0	75	163	238	428	348	CNA - Skowkale First Nation - 2018-11-15
975	335	210	140	948	607	1555	448	266	CNA - Anspa yaxw (Kispiox) - 2018-12-07
977	0	0	0	0	0	0	447	239	CNA - Esketemc - 2018-12-07
978	0	0	0	0	0	0	447	342	CNA - Simpcw - 2018-12-07
979	0	0	0	0	0	0	447	345	CNA - Skeetchestn - 2018-12-07
980	0	0	0	0	0	0	447	212	CNA - St'uxwtéws (Bonaparte) - 2018-12-07
981	0	0	0	0	0	0	447	397	CNA - T'exelcemc (Williams Lake) - 2018-12-07
982	2	14	81	799	561	1360	447	263	CNA - Tk'emlups (Kamloops) - 2018-12-07
983	0	0	0	0	0	0	447	219	CNA - Tsq'escenemc (Canim Lake) - 2018-12-07
984	1	0	17	360	323	683	446	268	CNA - Kitselas First Nation - 2018-12-07
986	0	0	0	0	0	0	449	388	CNA - Ucluelet First Nation - 2018-12-07
989	0	0	0	0	0	0	451	287	CNA - Lower Nicola Indian Band - 2018-12-07
990	0	0	0	0	0	0	451	290	CNA - Lytton First Nation - 2018-12-07
992	0	0	0	0	0	0	451	310	CNA - Nooaitch - 2018-12-07
987	137	533	351	563	384	947	452	228	CNA - Coldwater - 2018-12-07
1005	0	0	0	0	0	0	460	221	CNA - We Wai Kai First Nation - 2019-01-21
1006	18	15	2	240	268	508	461	362	CNA - Stellat'en First Nation - 2019-01-24
1007	50	94	28	212	31	243	462	271	CNA - Lhoosk'uz Dene Nation - 2019-01-25
993	0	0	0	0	0	0	451	338	CNA - Shackan - 2018-12-07
999	0	0	0	0	0	0	455	265	CNA - Katzie First Nation - 2018-12-10
1000	8	49	74	190	108	298	455	274	CNA - Kwantlen First Nation - 2018-12-10
995	17	24	53	416	62	478	453	378	CNA - Dzawada̱ʼenux̱w (Tsawataineuk) - 2018-12-07
996	2	2	47	220	72	292	454	237	CNA - Douglas First Nation - 2018-12-07
997	1	4	9	292	81	373	454	331	CNA - Samahquam Nation - 2018-12-07
998	7	20	39	366	95	461	454	344	CNA - Skatin Nations - 2018-12-07
1001	0	0	0	0	0	0	456	331	CNA - Samahquam Nation - 2019-01-10
1002	0	0	0	0	0	0	457	288	CNA - Lower Similkameen Indian Band - 2019-01-14
1003	1	14	46	189	187	376	458	380	CNA - Tsawwassen First Nation - 2019-01-15
1004	0	0	0	0	0	0	459	327	CNA - Qualicum First Nation - 2019-01-17
1008	5	8	9	92	83	175	463	329	CNA - Lhtako Dene Nation - 2019-01-25
939	2	1	0	170	205	375	428	224	CNA - Cheam First Nation - 2018-11-15
976	0	0	0	0	0	0	445	242	CNA - Gitanmaax Band Council - 2018-12-07
985	14	22	62	646	82	728	449	260	CNA - Huu-ay-aht - 2018-12-07
988	0	0	0	0	0	0	451	230	CNA - Cook's Ferry - 2018-12-07
994	23	0	195	433	643	1076	450	322	CNA - Penticton Indian Band - 2018-12-07
1009	45	120	50	291	114	405	462	303	CNA - Nazko First Nation - 2019-01-25
1010	24	101	278	1100	600	1700	464	206	CNA - Ahousaht - 2019-01-25
180	41	10	38	1	200	201	\N	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2016-04-28
190	13	59	59	640	50	690	\N	256	CNA - Hesquiaht - 2016-05-03
199	100	98	116	464	396	860	73	243	CNA - Gitanyow Band Council - 2016-06-09
61	0	0	0	883	421	0	27	245	CNA - Gitwangak Band Council - 2015-12-04
229	11	45	57	182	420	602	84	219	CNA - Tsq'escenemc (Canim Lake) - 2016-11-14
249	9	0	8	52	206	258	93	405	CNA - ʔakisq̓nuk First Nation - 2009-02-25
262	8	18	100	163	167	330	112	227	CNA - Cheslatta Carrier Nation - 2010-07-05
263	3	6	32	443	560	1003	164	225	CNA - Chehalis Indian Band - 2011-03-15
355	13	73	36	432	185	617	152	328	CNA - G̱usgimukw (Quatsino First Nation) - 2015-05-19
567	2	4	7	149	183	332	261	291	CNA - MÁLEXEȽ (Malahat) - 2017-06-28
630	0	0	0	0	0	0	\N	232	CNA - Da̱'naxda̱'xw / A̱waetla̱la̱ - 2017-12-13
279	0	0	0	95	0	95	104	257	CNA - Llenlleney'ten (High Bar) - 2012-05-23
283	14	42	43	112	445	557	97	219	CNA - Tsq'escenemc (Canim Lake) - 2012-12-13
829	0	0	0	0	0	0	\N	374	CNA - ʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) - 2018-04-25
790	12	50	60	115	94	209	367	374	CNA - ʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) - 2018-04-24
403	0	0	0	0	0	0	\N	305	CNA - Nicomen Indian Band - 2016-11-30
313	24	15	0	220	250	470	120	211	CNA - Blueberry River First Nations - 2014-04-08
336	381	177	103	905	598	1503	138	372	CNA - Tl'etinqox-T'in Government Office - 2014-12-03
345	30	53	47	792	950	1742	154	371	CNA - Tl’azt’en Nation  - 2014-12-05
373	0	5	10	143	105	248	163	293	CNA - Matsqui First Nation - 2015-11-30
423	0	27	40	589	679	1268	187	299	CNA - xʷməθkʷəy̓əm (Musqueam) - 2016-12-09
425	18	5	65	955	671	1626	189	346	CNA - Skidegate Band Council - 2016-12-09
453	0	0	0	0	0	0	\N	367	CNA - Taku River Tlingit First Nation - 2016-12-14
468	0	0	0	0	0	0	\N	244	CNA - Gitsegukla Band Council - 2017-03-27
486	41	10	38	1	200	201	216	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2017-04-24
492	202	360	790	574	250	824	220	366	CNA - Takla Lake First Nation - 2017-04-25
504	0	0	0	0	0	0	\N	366	CNA - Takla Lake First Nation - 2017-04-26
525	21	10	58	1399	394	1793	240	306	CNA - Gingolx Village Government - 2017-05-30
414	20	9	156	539	426	965	179	391	CNA - Upper Nicola Band - 2016-12-05
602	0	19	229	412	561	973	270	334	CNA - Seabird Island Indian Band - 2017-11-23
490	0	0	0	440	522	0	218	321	CNA - Penelakut Tribe - 2017-04-25
642	0	0	0	0	0	0	\N	218	CNA - Wei Wai Kum First Nation - 2017-12-13
690	0	0	0	0	0	0	\N	257	CNA - Llenlleney'ten (High Bar) - 2017-12-15
702	5	11	4	200	20	220	323	232	CNA - Da̱'naxda̱'xw / A̱waetla̱la̱ - 2018-01-15
716	10	38	23	150	108	258	330	333	CNA - Scowlitz First Nation - 2018-02-01
864	0	0	0	0	0	0	\N	290	CNA - Lytton First Nation - 2018-06-13
753	50	145	60	200	225	425	349	307	CNA - Nisga'a Village of Gitwinksihlkw  - 2018-04-18
735	0	0	0	0	0	0	\N	377	CNA - W̱JOȽEȽP (Tsartlip) - 2018-04-11
934	0	1	3	150	150	300	425	367	CNA - Taku River Tlingit First Nation - 2018-11-13
938	0	0	0	75	25	100	428	207	CNA - Aitchelitz First Nation  - 2018-11-15
1012	0	0	0	0	0	0	465	375	CNA - Tl’esqox - 2019-01-28
1014	0	0	0	0	0	0	465	389	CNA - Ulkatchot'en - 2019-01-28
774	0	0	0	0	0	0	\N	332	CNA - Saulteau First Nations - 2018-04-23
1015	0	0	0	0	0	0	465	399	CNA - Xeni Gwet'in - 2019-01-28
1016	0	0	0	0	0	0	465	363	CNA - Yunesit'in - 2019-01-28
1017	0	0	0	0	0	0	465	204	CNA - ʔEsdilagh - 2019-01-28
40	0	0	0	0	0	0	\N	308	CNA - Nisga'a Village of Laxgalt'sap - 2015-12-02
54	1	3	10	35	66	101	22	392	CNA - Upper Similkameen Indian Band - 2015-12-03
90	0	0	0	0	0	0	\N	230	CNA - Cook's Ferry Indian Band - 2015-12-15
94	0	0	0	0	0	0	\N	305	CNA - Nicomen Indian Band - 2015-12-15
107	0	0	0	0	0	0	\N	235	CNA - Ditidaht First Nation - 2016-02-02
115	8	5	4	225	90	315	39	343	CNA - Siska Indian Band - 2016-03-01
134	0	13	87	212	537	749	48	379	CNA - Tsawout First Nation - 2016-04-05
145	0	0	0	0	0	0	\N	333	CNA - Scowlitz First Nation - 2016-04-07
178	110	40	48	1	378	379	\N	308	CNA - Laxgalts'ap Village Government - 2016-04-28
539	0	0	0	0	0	0	\N	214	CNA - Boston Bar First Nation  - 2017-06-12
551	34	62	27	528	527	1055	250	389	CNA - Ulkatchot'en - 2017-06-15
574	0	0	0	0	0	0	\N	305	CNA - Nicomen Indian Band - 2017-10-16
577	0	0	0	0	0	0	\N	343	CNA - Siska Indian Band - 2017-10-16
643	0	0	0	0	0	0	\N	302	CNA - ʼNa̱mǥis First Nation - 2017-12-13
634	0	0	0	0	0	0	\N	328	CNA - G̱usgimukw (Quatsino First Nation) - 2017-12-13
672	0	0	0	0	0	0	\N	226	CNA - Chemainus First Nation - 2017-12-15
706	0	0	0	0	0	0	\N	367	CNA - Taku River Tlingit First Nation - 2018-01-16
725	124	69	45	550	250	800	339	366	CNA - Takla Lake First Nation - 2018-02-13
853	0	0	0	0	0	0	\N	244	CNA - Gitsegukla Band Council - 2018-05-23
876	3	5	150	95	55	150	396	374	CNA - ʔakink̓umǂasnuqǂiʔit (Tobacco Plains Band) - 2018-10-11
1011	0	0	0	0	0	0	465	372	CNA - Tl'etinqox-T'in Government Office - 2019-01-28
1013	0	0	0	0	0	0	465	208	CNA - Tsi Del Del - 2019-01-28
782	0	0	0	0	0	0	\N	401	CNA - Skawahlook First Nation - 2018-04-24
808	26	118	327	393	597	990	373	248	CNA - Gwa'sala-'Nakwaxda'xw First Nation - 2018-04-24
842	0	0	0	276	138	414	\N	282	CNA - Leq'á:mel First Nation - 2018-05-18
894	14	62	101	425	425	850	405	394	CNA - Westbank First Nation - 2018-10-29
923	0	0	0	0	0	0	\N	288	CNA - Lower Similkameen Indian Band - 2018-11-13
959	17	24	53	416	62	478	432	378	CNA - Dzawada̱ʼenux̱w (Tsawataineuk) - 2018-11-16
991	0	0	0	0	0	0	451	305	CNA - Nicomen Indian Band - 2018-12-07
1018	39	17	31	611	219	830	467	366	CNA - Takla Lake First Nation - 2019-07-02
\.


--
-- Data for Name: language_placename; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.language_placename (id, point, name, other_name, kind) FROM stdin;
299	0101000020E6100000A796ADF5454A60C02A1C412AC5284B40	Seashore Charters		poi
300	0101000020E6100000CE55F31C91CA5DC0E4A08499B6434940	FirstVoices - Splatsin (Eastern dialect)		poi
301	0101000020E6100000309DD66D501660C08AE942ACFE084E40	Liard Kaska FirstVoices Archive		poi
302	0101000020E6100000E7A8A3E36AE05FC06D57E883655C4940	Kwak̓wala FirstVoices Archive		poi
303	0101000020E6100000BC22F8DF4AF05CC00EF62686E4CA4840	Ktunaxa FirstVoices Archive		poi
304	0101000020E6100000F03504C7653F5FC093C3279D48064940	Klahoose FirstVoices Archive		poi
305	0101000020E6100000E9B7AF03E71860C04AED45B41D5B4B40	kitsumkalum sm'algyax FirstVoices Archive		poi
306	0101000020E6100000815B77F354ED5EC00A3197546D634840	HUL'Q'UMI'NUM' FirstVoices Archive		poi
307	0101000020E6100000D9EA724A407F60C0ECDE8AC404A34A40	Hlg̱aagilda X̱aayda Kil FirstVoices Archive		poi
308	0101000020E6100000520DFB3DB1CC5EC0666B7D91D09C4840	hən̓q̓əmin̓əm̓ FirstVoices Archive		poi
309	0101000020E6100000C8EF6DFAB31460C061527C7C42FC4A40	Haisla FirstVoices Archive		poi
310	0101000020E610000072A43330720860C0BF28417FA1854B40	Gitsenimx̱  FirstVoices Archive		poi
311	0101000020E6100000C26856B60FB65FC00B46257502FE4840	Ehattesaht FirstVoices Archive		poi
312	0101000020E61000002843554CA5D660C0D733846396154E40	C/TFN Tlingit FirstVoices Archive		poi
313	0101000020E61000004A07EBFF1C135EC0BB6070CD1D574940	Secwepemc FirstVoices Archive		poi
314	0101000020E6100000AF0793E2E3EC5DC0C99063EB196A4940	Secwepemctsin (Eastern Dialect) FirstVoices Archive		poi
315	0101000020E61000000742B28009395FC08BFB8F4C87064B40	Stellat'en FirstVoices Archive		poi
316	0101000020E610000066A032FE7D265FC0BA69334E430A4B40	Nadleh Whut'en FirstVoices Archive		poi
317	0101000020E6100000DD24068195435FC0D86322A5D94C4B40	Yekooche FirstVoices Archive		poi
318	0101000020E610000036E84B6F7FFB5EC0BADA8AFD65934840	Snuneymuxw FirstVoices Archive		poi
319	0101000020E61000006EC328081E7B5EC0CD5B751DAA574940	Northern St̕át̕imcets FirstVoices Archive		poi
320	0101000020E6100000936FB6B9314960C07B4D0F0A4A294B40	Metlakatla Sm'algyax FirstVoices Archive		poi
321	0101000020E6100000B6A2CD716E7D5EC01CD13DEB1A914840	Halq'eméylem FirstVoices Archive		poi
322	0101000020E610000082E7DEC325A05EC0FB5B02F04F7D4A40	Dakelh/Southern Carrier FirstVoices Archive		poi
323	0101000020E6100000B519A721AA615FC059164CFC51784840	Nuu-chah-nulth FirstVoices Archive		poi
324	0101000020E61000007061DD7877675FC04529215855B54C40	Kwadacha Tsek'ene FirstVoices Archive		poi
325	0101000020E61000005A492BBEA1335FC03DB7D095089E4840	c̕išaaʔatḥ		poi
326	0101000020E61000007764AC36FFA95FC03EAE0D15E32E4A40	Bella Coola's Eagle Lodge		poi
327	0101000020E6100000F12900C633895EC0419FC893A4234A40	Xats’ull Heritage Village		poi
328	0101000020E6100000EC51B81E85F25CC0DF701FB9354F4940	CrossRiver Wilderness Centre		poi
329	0101000020E6100000F5BEF1B567F05CC0350A4966F5CA4840	St. Eugene Golf Resort & Casino		poi
330	0101000020E6100000DE03745FCE055EC04242942F68AD4840	Mascot Gold Mine Tours and Snaza’ist Discovery Centre 		poi
331	0101000020E610000047B071FDBBDB5DC023827170E9844840	Nk'Mip - The Okanagan’s Ultimate Destination Resort		poi
332	0101000020E61000008657923CD7DB5DC053B4722F30854840	Nk'Mip Desert Cultural Centre		poi
333	0101000020E61000004A07EBFF1C135EC0BB6070CD1D574940	Secwepemc Museum and Heritage Park		poi
334	0101000020E6100000B6B9313D61E75DC0DE1CAED51E704940	Talking Rock Resort and Quaaout Lodge		poi
335	0101000020E6100000B0E8D66B7AFB5EC0068195438B924840	Tillicum Lelum Aboriginal Friendship Centre		poi
336	0101000020E61000009C33A2B4376A5DC0459DB98784A74840	Lower Columbia All First Nations		poi
337	0101000020E6100000F72004E44B685EC0810A47904AD94B40	Tansi Friendship Centre Society		poi
338	0101000020E61000009626A5A0DB3F5FC053CBD6FA22D74840	Wachiay Friendship Centre Society		poi
339	0101000020E61000002387889B530F5EC06C95607138E14B40	Nawican Friendship Centre		poi
340	0101000020E61000000B9B012EC8EC5EC00D8AE6012C644840	Hiiye'yu Lelum (House of Friendship) Society		poi
341	0101000020E6100000179D2CB5DEAC5EC07E350708E6664D40	Fort Nelson Aboriginal Friendship Society		poi
342	0101000020E6100000EC681CEA77365EC0A1D79FC4E71E4C40	Fort St John Friendship Society		poi
343	0101000020E6100000D4EFC2D66CA95FC0ACA8C1340C334B40	Dzelk'ant Friendship Center - Houston Program Office		poi
344	0101000020E6100000300DC347C4165EC04A253CA1D7574940	Interior Indian Friendship Society		poi
345	0101000020E6100000BEDA519CA3DF5DC00113B87537F14840	Ki-Low-Na Friendship Society		poi
346	0101000020E610000079EBFCDB657B5EC036E50AEF72594940	Lillooet Friendship Centre Society		poi
347	0101000020E61000001AE0826C59325EC011AB3FC2300E4940	Conayt Friendship Society		poi
348	0101000020E61000003605323B8BE55DC0569E40D829BE4840	OoknaKane Friendship Centre		poi
349	0101000020E6100000670E492D94335FC038BD8BF7E39E4840	Port Alberni Friendship Center		poi
350	0101000020E6100000A438471D1DB05EC08DB7955E9BF54A40	Prince George Native Friendship Centre		poi
351	0101000020E610000010CCD1E3774A60C0A6811FD5B0274B40	Friendship House Association of Prince Rupert		poi
352	0101000020E61000001D739EB12FA05EC0DBC4C9FD0E7D4A40	Quesnel Tillicum Society, Native Friendship Centre		poi
353	0101000020E6100000AB4198DBBD1260C0EF75525F96424B40	Kermode Friendship Society		poi
354	0101000020E6100000111B2C9CA4C45EC04D69FD2D01A44840	Vancouver Aboriginal Friendship Centre 		poi
355	0101000020E6100000938C9C853DD15DC026A77686A9214940	First Nations Friendship Centre		poi
356	0101000020E61000000DFAD2DB9FD75EC0C7D6338463364840	BC Association of Aboriginal Friendship Centres		poi
357	0101000020E6100000FDA4DAA7E3D85EC09A22C0E95D3A4840	Victoria Native Friendship Centre		poi
358	0101000020E6100000DBC01DA8D3E160C0B32616F88A5C4E40	Skookum Jim Friendship Centre		poi
359	0101000020E6100000A31EA2D11D895EC0E700C11C3D104A40	Cariboo Friendship Society		poi
360	0101000020E6100000E2C96E66F4BB5FC083A44FABE84B4940	U'mista Cultural Centre		poi
361	0101000020E6100000F3E7DB82A50460C0D21A834E08154A40	Heiltsuk Cultural Education Centre		poi
362	0101000020E6100000293DD34B8CDD5EC024F25D4A5D4A4840	First Peoples' Heritage, Language and Culture Council		poi
363	0101000020E6100000293DD34B8CDD5EC024F25D4A5D4A4840	First Peoples' Cultural Foundation		poi
364	0101000020E6100000B6A2CD716E7D5EC01CD13DEB1A914840	Coqualeetza Cultural Education Centre		poi
365	0101000020E6100000E754320054ED5EC05245F12A6B634840	Quw'utsun Syuw’entst Lelum' Culture and Education Centre		poi
366	0101000020E6100000BAF770C971ED5EC030629F008A634840	Red River West Cultural Association		poi
367	0101000020E61000004A07EBFF1C135EC0BB6070CD1D574940	Secwepemc Cultural Education Society		poi
368	0101000020E61000005C9198A086E65DC01BF4A5B73FBD4840	En'owkin Centre		poi
369	0101000020E6100000D591239D81045FC09AEC9FA701FD4A40	Stoney Creek Elders Cultural Society		poi
370	0101000020E61000004A97FE25A9065FC0C9ACDEE176F84A40	Yinka Déné Language Institute		poi
371	0101000020E610000051888043A8CA5FC05C55F65D11644B40	Dze L K'ant Friendship Centre 		poi
372	0101000020E6100000F17EDC7EF92A5FC09D9E776341674840	Ditidaht FirstVoices Archive		poi
373	0101000020E6100000C0CFB870A08460C0CF328B506C014B40	x̱aad kil (Massett Haida) FirstVoices Archive		poi
374	0101000020E6100000DDEBA4BE2CD55FC073124A5F08834B40	Wet’suwet’en FirstVoices Archive		poi
375	0101000020E6100000E7A8A3E36AE05FC06D57E883655C4940	’Uik̓ala FirstVoices Archive		poi
376	0101000020E6100000D542C9E4D4045FC0D10836AE7FB54940	Tsilhqot'in (Xeni Gwet'in) FirstVoices Archive		poi
377	0101000020E610000066BFEE74E7C25EC0841266DAFE7D4B40	Tse'Khene FirstVoices Archive		poi
378	0101000020E61000002843554CA5D660C0D733846396154E40	Tagish FirstVoices Archive		poi
379	0101000020E6100000FA298E03AFE160C014419C87135C4E40	Southern Tutchone FirstVoices Archive		poi
380	0101000020E61000003BA759A0DD265FC0B03A72A433F24840	Sliammon FirstVoices Archive		poi
381	0101000020E61000001EA5129ED0DD5EC05B272EC72B4A4840	SENĆOŦEN FirstVoices Archive		poi
382	0101000020E6100000D26F5F07CEB05FC0F46F97FDBA2F4A40	Nuxalk FirstVoices Archive		poi
383	0101000020E61000003108AC1C5AE25DC07D76C075C5F04840	nsyilxcən FirstVoices Archive		poi
384	0101000020E6100000386744696F645EC0D05E7D3CF41B4940	nłeʔkepmxcin FirstVoices Archive		poi
385	0101000020E6100000C3D66CE5A52260C03B72A433309A4B40	Nisga'a FirstVoices Archive		poi
386	0101000020E61000001EF98381E70F5FC086C613419C394B40	Nak’azdli Dakelh FirstVoices Archive		poi
387	0101000020E6100000CDE847C329655CC000FF942A51704A40	ᒪᐢᑿᒋᐢ ᓀᐦᐃᔭᐍᐏᐣ / Maskwacis Cree FirstVoices Archive		poi
388	0101000020E61000002F8A1EF818AE5EC051BEA08504284940	Lil'wat FirstVoices Archive		poi
389	0101000020E61000006ADAC534534A60C08942CBBA7F284B40	Museum of Northern B.C.		poi
390	0101000020E610000053944BE317135EC0999CDA19A6564940	Secwepemc Museum and Heritage Park		poi
391	0101000020E6100000A4703D0AD74F5FC05C8FC2F528044940	Wei Wai Kum House of Treasures		poi
392	0101000020E6100000250516C0140260C06891ED7C3F8D4B40	'Ksan Native Village and Museum		poi
393	0101000020E61000000C2252D32E905EC0B779E3A430934840	XÁ:YTEM  Longhouse Interpretive Centre		poi
394	0101000020E61000009EEE3CF19CC75EC065FED13769A44840	Bill Reid Gallery of Northwest Coast Art		poi
395	0101000020E6100000AE7FD767CE665EC0F6B4C35F93AD4840	Ruby Creek Art Gallery		poi
396	0101000020E61000006C4084B872BC5EC0B37BF2B0500F4940	Squamish Lil'wat Cultural Centre		poi
397	0101000020E61000007E6FD39FFD7B5EC01D01DC2C5E584940	St'át'imc Cultural Experiences		poi
398	0101000020E6100000C2F9D4B14A7D5EC011E50B5A488E4840	Sto:lo Artisan Centre		poi
251	0101000020E610000013000068562260C07E41D15094994B40	New Aiyansh	New Aiyansh	
252	0101000020E61000005BFFFF5FD32560C076EBE5FA279A4B40	Lisims	Nass (River)	
253	0101000020E610000072FFFF4B542260C07B9B3635B1994B40	Gitlaxt’aamiks	Gitlakdamiks literally, "people on the ponds"	
265	0101000020E610000055000092C98460C00E8897B279014B40	jagwaal	"...from her (Leona's) parents' home down here to Auntie Bea's house" (describing the location of an old village site at modern-day Masset)	
266	0101000020E6100000370000E06EEB5FC0C729848404A84B40	Sik-edakh	Glen-Vowell	
267	0101000020E6100000C9FEFF278DDF5FC0FD913751855C4940	Gwa'sala-'Nakwaxda'xw		
268	0101000020E6100000DCFFFF71EE7F60C0C599DCE2D39F4A40	HLG̱AAGILDA	Skidegate (original name)	
269	0101000020E6100000A0FEFFFF13645EC09C696495C50E4940	nƛ̓əq̓ƛ̓áq̓tn	Kanaka Bar area	
271	0101000020E61000005D0000B0BF7F60C0503DF7AE06A24A40	SG̱IIDAGIDS	Skidegate	
272	0101000020E6100000C1FEFF1F30645EC08FE0C8CE0D114940	sísqeʔ	Siska Creek	
250	0101000020E610000083E4766DAE7A60C05624871040624A40	T’AAXWII X̱AAYDAG̱A GWAAY.YAAY IINAG̱WAAY	Moresby Island	
273	0101000020E6100000FD0000A02F995EC0DF91D7F329F94940	Tl’esqox	Muddy Creek	
274	0101000020E61000007BE82E8DFF8D60C095EC82A65DDB4A40	X̱AAYDAG̱A GWAAY.YAAY IINAG̱WAAY	Graham Island	
275	0101000020E6100000E058AA4D858560C096DC5BC60AAB4A40	X̱AAYDAG̱A GWAAY.YAAY	Haida Gwaii (Queen Charlotte Islands)	
276	0101000020E6100000450000AE19ED5DC08F577E2A226A4940	Sexqeltqín	Adams Lake	
286	0101000020E610000021C8410933895EC02DD0EE9062104A40	Esk’ét	Alkali Lake	
287	0101000020E61000001EA9BEF38B655EC0691B7FA2B28B4940	Llenllenéy’ten	High Bar 	
288	0101000020E61000009A5C8C8175EC5DC03BDF4F8D97684940	Qw7ewt	Little Shuswap Lake	
289	0101000020E6100000605969520A755EC0B37C5D86FF704940	Tsk’wéylecw	Pavilion	
290	0101000020E6100000E3C62DE6E7875EC0D8BCAAB35A224A40	Xats’úll 	Soda Creek	
291	0101000020E6100000499C1551137D5EC0568330B77B0B4A40	T’éxel’c	Williams Lake	
292	0101000020E6100000467EFD101B105EC08B89CDC7B57B4940	Pelltíq’t	Clinton	
293	0101000020E6100000BABF7ADCB7855EC0FC709010E5CB4940	Xgét’tem’	Dog Creek	
294	0101000020E61000000C93A982515C5EC068CC24EA05B14840	Chawathil		
295	0101000020E6100000D4D4B2B5BE7D5EC001158E2095624940	Xwisten	Bridge River	
296	0101000020E6100000DD06B5DFDAA75EC01616DC0F78004B40	Lheidli-T'enneh		
270	0101000020E6100000B344679945EC5FC037894160E5AC4B40	Kispiox		
297	0101000020E6100000A051BAF42FEB5FC05264ADA1D4A04B40	Gitanmaax		
298	\N	Ẹdo	Benin	
254	0101000020E61000000801000099EC5FC08B5D0E4B27404940	G̱ut̕sala	Quatsino Sound	
255	0101000020E610000084000080240060C0F0B1E7676E6E4940	T̕łat̕łasiḵ̕wala	Nahwitti	
256	0101000020E610000050FFFFFFE9335EC087415A8C4E0E4940	Scw’́exmx	"People of the creek" (Nicola Valley people)	
257	0101000020E610000050FFFFFFB15C5EC086662C0101F54840	Nkatsám	Boothroyd area	
258	0101000020E6100000D7FEFFDF32655EC0FB7CE756B01D4940	ƛ̓q̓əmcín	Lytton area	
259	0101000020E610000021FFFF9C31D65EC08490D9B11B3F4840	PKOLS	Mount Douglas	
260	0101000020E61000004A01004001555EC0C2F93718C3374940	nk̓əmcín	Spences Bridge area	
261	0101000020E6100000A8FFFFFFC48460C0F3B4AC6898024B40	4 villages of Massett		
262	0101000020E61000006AFFFF2DE28460C0FE2FA426BA014B40	aaw	"Way down the other end, as far as the hill..." (describing the location of an old village site at modern-day Masset)	
263	0101000020E6100000C4FFFF85D58460C04E7C275B8E014B40	iijaaw	"...from the hill up to Leona's mum's house" (describing the location of an old village site at modern-day Masset)	
264	0101000020E610000005000025BE8460C0D14D1A7252014B40	ḵ’yang	"...from Auntie Bea's house up this way" (describing the location of an old village site at modern-day Masset)	
277	0101000020E6100000F853E3A59B545EC05E4BC8073D634940	St’uxwtéws 	Bonaparte	
278	0101000020E6100000F81BEDB8E1ED5DC07616BD5301634940	Sk’atsin 	Neskonlith	
279	0101000020E610000012DDB3AED1015DC0C3F5285C8F404940	Kenpésq’t	Shuswap	
280	0101000020E610000087F9F202EC085EC0755AB741ED974940	Simpcw	Simpcw	
281	0101000020E610000080D3BB783F365EC01BF1643733604940	Skítsesten	Skeetchestn	
282	0101000020E6100000E8667FA0DCC85DC0096EA46C91464940	Splatsín	Splatsín	
283	0101000020E6100000C40AB77C24135EC09B3C65355D574940	Tk’emlúps	Kamloops	
284	0101000020E6100000E1B721C66B665EC0749A05DA1DD64940	Tsq’éscen	Canim Lake	
285	0101000020E61000005C1E6B46068F5EC08E93C2BCC7D14940	Stswécem’c	Canoe Creek	
\.


--
-- Data for Name: spatial_ref_sys; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.spatial_ref_sys (srid, auth_name, auth_srid, srtext, proj4text) FROM stdin;
\.


--
-- Data for Name: geocode_settings; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.geocode_settings (name, setting, unit, category, short_desc) FROM stdin;
\.


--
-- Data for Name: pagc_gaz; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_gaz (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_lex; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_lex (id, seq, word, stdword, token, is_custom) FROM stdin;
\.


--
-- Data for Name: pagc_rules; Type: TABLE DATA; Schema: tiger; Owner: postgres
--

COPY tiger.pagc_rules (id, rule, is_custom) FROM stdin;
\.


--
-- Data for Name: topology; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.topology (id, name, srid, "precision", hasz) FROM stdin;
\.


--
-- Data for Name: layer; Type: TABLE DATA; Schema: topology; Owner: postgres
--

COPY topology.layer (topology_id, layer_id, schema_name, table_name, feature_column, feature_type, level, child_id) FROM stdin;
\.


--
-- Name: auth_group_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_id_seq', 1, false);


--
-- Name: auth_group_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_group_permissions_id_seq', 1, false);


--
-- Name: auth_permission_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_permission_id_seq', 72, true);


--
-- Name: auth_user_groups_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_groups_id_seq', 1, false);


--
-- Name: auth_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_id_seq', 1, true);


--
-- Name: auth_user_user_permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.auth_user_user_permissions_id_seq', 1, false);


--
-- Name: django_admin_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_admin_log_id_seq', 1, true);


--
-- Name: django_content_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_content_type_id_seq', 18, true);


--
-- Name: django_migrations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.django_migrations_id_seq', 50, true);


--
-- Name: language_champion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_champion_id_seq', 46, true);


--
-- Name: language_community_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_community_id_seq', 406, true);


--
-- Name: language_community_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_community_language_id_seq', 446, true);


--
-- Name: language_communitylink_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_communitylink_id_seq', 440, true);


--
-- Name: language_dialect_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_dialect_id_seq', 54, true);


--
-- Name: language_language_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_language_id_seq', 43, true);


--
-- Name: language_languagefamily_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_languagefamily_id_seq', 8, true);


--
-- Name: language_languagelink_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_languagelink_id_seq', 94, true);


--
-- Name: language_languagemember_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_languagemember_id_seq', 1, false);


--
-- Name: language_languagesubfamily_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_languagesubfamily_id_seq', 6, true);


--
-- Name: language_lna_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_lna_id_seq', 467, true);


--
-- Name: language_lnadata_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_lnadata_id_seq', 1018, true);


--
-- Name: language_placename_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.language_placename_id_seq', 398, true);


--
-- Name: auth_group auth_group_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_name_key UNIQUE (name);


--
-- Name: auth_group_permissions auth_group_permissions_group_id_permission_id_0cd325b0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_permission_id_0cd325b0_uniq UNIQUE (group_id, permission_id);


--
-- Name: auth_group_permissions auth_group_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_group auth_group_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group
    ADD CONSTRAINT auth_group_pkey PRIMARY KEY (id);


--
-- Name: auth_permission auth_permission_content_type_id_codename_01ab375a_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_codename_01ab375a_uniq UNIQUE (content_type_id, codename);


--
-- Name: auth_permission auth_permission_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_pkey PRIMARY KEY (id);


--
-- Name: auth_user_groups auth_user_groups_user_id_group_id_94350c0c_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_group_id_94350c0c_uniq UNIQUE (user_id, group_id);


--
-- Name: auth_user auth_user_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_pkey PRIMARY KEY (id);


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_permission_id_14a6b632_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_permission_id_14a6b632_uniq UNIQUE (user_id, permission_id);


--
-- Name: auth_user auth_user_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user
    ADD CONSTRAINT auth_user_username_key UNIQUE (username);


--
-- Name: django_admin_log django_admin_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_pkey PRIMARY KEY (id);


--
-- Name: django_content_type django_content_type_app_label_model_76bd3d3b_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_app_label_model_76bd3d3b_uniq UNIQUE (app_label, model);


--
-- Name: django_content_type django_content_type_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_content_type
    ADD CONSTRAINT django_content_type_pkey PRIMARY KEY (id);


--
-- Name: django_migrations django_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_migrations
    ADD CONSTRAINT django_migrations_pkey PRIMARY KEY (id);


--
-- Name: django_session django_session_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_session
    ADD CONSTRAINT django_session_pkey PRIMARY KEY (session_key);


--
-- Name: language_champion language_champion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_champion
    ADD CONSTRAINT language_champion_pkey PRIMARY KEY (id);


--
-- Name: language_community_languages language_community_langu_community_id_language_id_1babdea0_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_community_languages
    ADD CONSTRAINT language_community_langu_community_id_language_id_1babdea0_uniq UNIQUE (community_id, language_id);


--
-- Name: language_community_languages language_community_language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_community_languages
    ADD CONSTRAINT language_community_language_pkey PRIMARY KEY (id);


--
-- Name: language_community language_community_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_community
    ADD CONSTRAINT language_community_pkey PRIMARY KEY (id);


--
-- Name: language_communitylink language_communitylink_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_communitylink
    ADD CONSTRAINT language_communitylink_pkey PRIMARY KEY (id);


--
-- Name: language_dialect language_dialect_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_dialect
    ADD CONSTRAINT language_dialect_pkey PRIMARY KEY (id);


--
-- Name: language_language language_language_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_language
    ADD CONSTRAINT language_language_pkey PRIMARY KEY (id);


--
-- Name: language_languagefamily language_languagefamily_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagefamily
    ADD CONSTRAINT language_languagefamily_pkey PRIMARY KEY (id);


--
-- Name: language_languagelink language_languagelink_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagelink
    ADD CONSTRAINT language_languagelink_pkey PRIMARY KEY (id);


--
-- Name: language_languagemember language_languagemember_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagemember
    ADD CONSTRAINT language_languagemember_pkey PRIMARY KEY (id);


--
-- Name: language_languagesubfamily language_languagesubfamily_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagesubfamily
    ADD CONSTRAINT language_languagesubfamily_pkey PRIMARY KEY (id);


--
-- Name: language_lna language_lna_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_lna
    ADD CONSTRAINT language_lna_pkey PRIMARY KEY (id);


--
-- Name: language_lnadata language_lnadata_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_lnadata
    ADD CONSTRAINT language_lnadata_pkey PRIMARY KEY (id);


--
-- Name: language_placename language_placename_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_placename
    ADD CONSTRAINT language_placename_pkey PRIMARY KEY (id);


--
-- Name: auth_group_name_a6ea08ec_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_name_a6ea08ec_like ON public.auth_group USING btree (name varchar_pattern_ops);


--
-- Name: auth_group_permissions_group_id_b120cbf9; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_group_id_b120cbf9 ON public.auth_group_permissions USING btree (group_id);


--
-- Name: auth_group_permissions_permission_id_84c5c92e; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_group_permissions_permission_id_84c5c92e ON public.auth_group_permissions USING btree (permission_id);


--
-- Name: auth_permission_content_type_id_2f476e4b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_permission_content_type_id_2f476e4b ON public.auth_permission USING btree (content_type_id);


--
-- Name: auth_user_groups_group_id_97559544; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_group_id_97559544 ON public.auth_user_groups USING btree (group_id);


--
-- Name: auth_user_groups_user_id_6a12ed8b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_groups_user_id_6a12ed8b ON public.auth_user_groups USING btree (user_id);


--
-- Name: auth_user_user_permissions_permission_id_1fbb5f2c; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_permission_id_1fbb5f2c ON public.auth_user_user_permissions USING btree (permission_id);


--
-- Name: auth_user_user_permissions_user_id_a95ead1b; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_user_permissions_user_id_a95ead1b ON public.auth_user_user_permissions USING btree (user_id);


--
-- Name: auth_user_username_6821ab7c_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX auth_user_username_6821ab7c_like ON public.auth_user USING btree (username varchar_pattern_ops);


--
-- Name: django_admin_log_content_type_id_c4bce8eb; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_content_type_id_c4bce8eb ON public.django_admin_log USING btree (content_type_id);


--
-- Name: django_admin_log_user_id_c564eba6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_admin_log_user_id_c564eba6 ON public.django_admin_log USING btree (user_id);


--
-- Name: django_session_expire_date_a5c62663; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_expire_date_a5c62663 ON public.django_session USING btree (expire_date);


--
-- Name: django_session_session_key_c0390e0f_like; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX django_session_session_key_c0390e0f_like ON public.django_session USING btree (session_key varchar_pattern_ops);


--
-- Name: language_champion_community_id_8ce5ae78; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_champion_community_id_8ce5ae78 ON public.language_champion USING btree (community_id);


--
-- Name: language_champion_language_id_ad4f5260; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_champion_language_id_ad4f5260 ON public.language_champion USING btree (language_id);


--
-- Name: language_community_language_community_id_2d79d6b6; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_community_language_community_id_2d79d6b6 ON public.language_community_languages USING btree (community_id);


--
-- Name: language_community_language_language_id_2fccea31; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_community_language_language_id_2fccea31 ON public.language_community_languages USING btree (language_id);


--
-- Name: language_community_point_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_community_point_id ON public.language_community USING gist (point);


--
-- Name: language_communitylink_community_id_b5b84c07; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_communitylink_community_id_b5b84c07 ON public.language_communitylink USING btree (community_id);


--
-- Name: language_dialect_language_id_c6b6c639; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_dialect_language_id_c6b6c639 ON public.language_dialect USING btree (language_id);


--
-- Name: language_language_bbox_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_language_bbox_id ON public.language_language USING gist (bbox);


--
-- Name: language_language_geom_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_language_geom_id ON public.language_language USING gist (geom);


--
-- Name: language_language_sub_family_id_d812be64; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_language_sub_family_id_d812be64 ON public.language_language USING btree (sub_family_id);


--
-- Name: language_languagelink_language_id_e3168673; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_languagelink_language_id_e3168673 ON public.language_languagelink USING btree (language_id);


--
-- Name: language_languagemember_user_id_fdbfb868; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_languagemember_user_id_fdbfb868 ON public.language_languagemember USING btree (user_id);


--
-- Name: language_languagesubfamily_family_id_4c721362; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_languagesubfamily_family_id_4c721362 ON public.language_languagesubfamily USING btree (family_id);


--
-- Name: language_lna_language_id_992c5137; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_lna_language_id_992c5137 ON public.language_lna USING btree (language_id);


--
-- Name: language_lnadata_community_id_343e7e38; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_lnadata_community_id_343e7e38 ON public.language_lnadata USING btree (community_id);


--
-- Name: language_lnadata_lna_id_468d89b1; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_lnadata_lna_id_468d89b1 ON public.language_lnadata USING btree (lna_id);


--
-- Name: language_placename_point_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX language_placename_point_id ON public.language_placename USING gist (point);


--
-- Name: auth_group_permissions auth_group_permissio_permission_id_84c5c92e_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissio_permission_id_84c5c92e_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_group_permissions auth_group_permissions_group_id_b120cbf9_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_group_permissions
    ADD CONSTRAINT auth_group_permissions_group_id_b120cbf9_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_permission auth_permission_content_type_id_2f476e4b_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_permission
    ADD CONSTRAINT auth_permission_content_type_id_2f476e4b_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_group_id_97559544_fk_auth_group_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_group_id_97559544_fk_auth_group_id FOREIGN KEY (group_id) REFERENCES public.auth_group(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_groups auth_user_groups_user_id_6a12ed8b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_groups
    ADD CONSTRAINT auth_user_groups_user_id_6a12ed8b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permi_permission_id_1fbb5f2c_fk_auth_perm FOREIGN KEY (permission_id) REFERENCES public.auth_permission(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: auth_user_user_permissions auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auth_user_user_permissions
    ADD CONSTRAINT auth_user_user_permissions_user_id_a95ead1b_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_content_type_id_c4bce8eb_fk_django_co; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_content_type_id_c4bce8eb_fk_django_co FOREIGN KEY (content_type_id) REFERENCES public.django_content_type(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: django_admin_log django_admin_log_user_id_c564eba6_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.django_admin_log
    ADD CONSTRAINT django_admin_log_user_id_c564eba6_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_champion language_champion_community_id_8ce5ae78_fk_language_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_champion
    ADD CONSTRAINT language_champion_community_id_8ce5ae78_fk_language_ FOREIGN KEY (community_id) REFERENCES public.language_community(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_champion language_champion_language_id_ad4f5260_fk_language_language_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_champion
    ADD CONSTRAINT language_champion_language_id_ad4f5260_fk_language_language_id FOREIGN KEY (language_id) REFERENCES public.language_language(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_community_languages language_community_l_community_id_112ad114_fk_language_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_community_languages
    ADD CONSTRAINT language_community_l_community_id_112ad114_fk_language_ FOREIGN KEY (community_id) REFERENCES public.language_community(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_community_languages language_community_l_language_id_f98d229d_fk_language_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_community_languages
    ADD CONSTRAINT language_community_l_language_id_f98d229d_fk_language_ FOREIGN KEY (language_id) REFERENCES public.language_language(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_communitylink language_communityli_community_id_b5b84c07_fk_language_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_communitylink
    ADD CONSTRAINT language_communityli_community_id_b5b84c07_fk_language_ FOREIGN KEY (community_id) REFERENCES public.language_community(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_dialect language_dialect_language_id_c6b6c639_fk_language_language_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_dialect
    ADD CONSTRAINT language_dialect_language_id_c6b6c639_fk_language_language_id FOREIGN KEY (language_id) REFERENCES public.language_language(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_language language_language_sub_family_id_d812be64_fk_language_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_language
    ADD CONSTRAINT language_language_sub_family_id_d812be64_fk_language_ FOREIGN KEY (sub_family_id) REFERENCES public.language_languagesubfamily(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_languagelink language_languagelin_language_id_e3168673_fk_language_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagelink
    ADD CONSTRAINT language_languagelin_language_id_e3168673_fk_language_ FOREIGN KEY (language_id) REFERENCES public.language_language(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_languagemember language_languagemember_user_id_fdbfb868_fk_auth_user_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagemember
    ADD CONSTRAINT language_languagemember_user_id_fdbfb868_fk_auth_user_id FOREIGN KEY (user_id) REFERENCES public.auth_user(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_languagesubfamily language_languagesub_family_id_4c721362_fk_language_; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_languagesubfamily
    ADD CONSTRAINT language_languagesub_family_id_4c721362_fk_language_ FOREIGN KEY (family_id) REFERENCES public.language_languagefamily(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_lna language_lna_language_id_992c5137_fk_language_language_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_lna
    ADD CONSTRAINT language_lna_language_id_992c5137_fk_language_language_id FOREIGN KEY (language_id) REFERENCES public.language_language(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_lnadata language_lnadata_community_id_343e7e38_fk_language_community_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_lnadata
    ADD CONSTRAINT language_lnadata_community_id_343e7e38_fk_language_community_id FOREIGN KEY (community_id) REFERENCES public.language_community(id) DEFERRABLE INITIALLY DEFERRED;


--
-- Name: language_lnadata language_lnadata_lna_id_468d89b1_fk_language_lna_id; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.language_lnadata
    ADD CONSTRAINT language_lnadata_lna_id_468d89b1_fk_language_lna_id FOREIGN KEY (lna_id) REFERENCES public.language_lna(id) DEFERRABLE INITIALLY DEFERRED;


--
-- PostgreSQL database dump complete
--

