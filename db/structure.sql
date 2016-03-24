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
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: postgis; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS postgis WITH SCHEMA public;


--
-- Name: EXTENSION postgis; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION postgis IS 'PostGIS geometry, geography, and raster spatial types and functions';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: api_keys; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE api_keys (
    id integer NOT NULL,
    user_id integer,
    token character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: api_keys_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE api_keys_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: api_keys_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE api_keys_id_seq OWNED BY api_keys.id;


--
-- Name: broadcasts; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE broadcasts (
    id integer NOT NULL,
    subject character varying,
    body character varying,
    scope character varying,
    scheduled_for timestamp without time zone,
    state character varying,
    creator_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: broadcasts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE broadcasts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: broadcasts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE broadcasts_id_seq OWNED BY broadcasts.id;


--
-- Name: claims; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE claims (
    id integer NOT NULL,
    claimant_id integer,
    development_id integer,
    moderator_id integer,
    role character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    reason character varying,
    state character varying
);


--
-- Name: claims_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE claims_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: claims_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE claims_id_seq OWNED BY claims.id;


--
-- Name: crosswalks; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE crosswalks (
    id integer NOT NULL,
    organization_id integer,
    development_id integer,
    internal_id character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: crosswalks_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE crosswalks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: crosswalks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE crosswalks_id_seq OWNED BY crosswalks.id;


--
-- Name: development_team_memberships; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE development_team_memberships (
    id integer NOT NULL,
    role character varying,
    development_id integer,
    organization_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: development_team_memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE development_team_memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: development_team_memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE development_team_memberships_id_seq OWNED BY development_team_memberships.id;


--
-- Name: developments; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE developments (
    id integer NOT NULL,
    creator_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    rdv boolean,
    asofright boolean,
    ovr55 boolean,
    clusteros boolean,
    phased boolean,
    stalled boolean,
    name character varying(140),
    status character varying(20),
    "desc" character varying,
    project_url character varying(140),
    mapc_notes character varying,
    tagline character varying(85),
    address character varying(140),
    state character varying(2) DEFAULT 'MA'::character varying,
    zip_code character varying(9),
    height integer,
    stories integer,
    year_compl integer,
    prjarea integer,
    singfamhu integer,
    twnhsmmult integer,
    lgmultifam integer,
    tothu integer,
    gqpop integer,
    rptdemp integer,
    emploss integer,
    estemp integer,
    commsf integer,
    hotelrms integer,
    onsitepark integer,
    total_cost integer,
    team_membership_count integer,
    cancelled boolean DEFAULT false,
    private boolean DEFAULT false,
    fa_ret double precision,
    fa_ofcmd double precision,
    fa_indmf double precision,
    fa_whs double precision,
    fa_rnd double precision,
    fa_edinst double precision,
    fa_other double precision,
    fa_hotel double precision,
    other_rate double precision,
    affordable double precision,
    latitude numeric(12,9),
    longitude numeric(12,9),
    place_id integer
);


--
-- Name: developments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE developments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: developments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE developments_id_seq OWNED BY developments.id;


--
-- Name: developments_programs; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE developments_programs (
    id integer NOT NULL,
    development_id integer,
    program_id integer
);


--
-- Name: developments_programs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE developments_programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: developments_programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE developments_programs_id_seq OWNED BY developments_programs.id;


--
-- Name: edits; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE edits (
    id integer NOT NULL,
    editor_id integer,
    moderator_id integer,
    development_id integer,
    state character varying,
    fields json,
    applied_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    ignore_conflicts boolean DEFAULT false,
    moderated_at timestamp without time zone,
    applied boolean DEFAULT false NOT NULL
);


--
-- Name: edits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE edits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: edits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE edits_id_seq OWNED BY edits.id;


--
-- Name: field_edits; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE field_edits (
    id integer NOT NULL,
    edit_id integer,
    name character varying,
    change json,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: field_edits_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE field_edits_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: field_edits_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE field_edits_id_seq OWNED BY field_edits.id;


--
-- Name: flags; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE flags (
    id integer NOT NULL,
    flagger_id integer,
    development_id integer,
    reason text,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    resolver_id integer
);


--
-- Name: flags_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE flags_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: flags_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE flags_id_seq OWNED BY flags.id;


--
-- Name: inbox_notices; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE inbox_notices (
    id integer NOT NULL,
    subject character varying,
    body character varying,
    state character varying,
    level character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: inbox_notices_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE inbox_notices_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inbox_notices_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE inbox_notices_id_seq OWNED BY inbox_notices.id;


--
-- Name: memberships; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE memberships (
    id integer NOT NULL,
    user_id integer,
    organization_id integer,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: memberships_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE memberships_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: memberships_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE memberships_id_seq OWNED BY memberships.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE organizations (
    id integer NOT NULL,
    creator_id integer,
    name character varying,
    website character varying,
    url_template character varying,
    location character varying,
    email character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    abbv character varying,
    short_name character varying,
    gravatar_email character varying,
    hashed_email character varying
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE organizations_id_seq OWNED BY organizations.id;


--
-- Name: place_profiles; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE place_profiles (
    id integer NOT NULL,
    latitude numeric,
    longitude numeric,
    radius numeric,
    polygon json,
    response json,
    expires_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: place_profiles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE place_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: place_profiles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE place_profiles_id_seq OWNED BY place_profiles.id;


--
-- Name: places; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE places (
    id integer NOT NULL,
    name character varying,
    type character varying,
    place_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: places_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE places_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: places_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE places_id_seq OWNED BY places.id;


--
-- Name: programs; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE programs (
    id integer NOT NULL,
    type character varying,
    name character varying,
    description character varying,
    url character varying,
    sort_order integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: programs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE programs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: programs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE programs_id_seq OWNED BY programs.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: searches; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE searches (
    id integer NOT NULL,
    query json,
    user_id integer,
    saved boolean,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    title character varying(140)
);


--
-- Name: searches_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE searches_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: searches_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE searches_id_seq OWNED BY searches.id;


--
-- Name: subscriptions; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE subscriptions (
    id integer NOT NULL,
    user_id integer,
    subscribable_id integer,
    subscribable_type character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: subscriptions_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE subscriptions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: subscriptions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE subscriptions_id_seq OWNED BY subscriptions.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    first_name character varying,
    last_name character varying,
    hashed_email character varying,
    last_checked_subscriptions timestamp without time zone DEFAULT '2016-02-12 16:39:06.664379'::timestamp without time zone NOT NULL,
    mail_frequency character varying(8) DEFAULT 'weekly'::character varying
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: verifications; Type: TABLE; Schema: public; Owner: -; Tablespace:
--

CREATE TABLE verifications (
    id integer NOT NULL,
    user_id integer,
    verifier_id integer,
    reason text,
    state character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: verifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE verifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: verifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE verifications_id_seq OWNED BY verifications.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_keys ALTER COLUMN id SET DEFAULT nextval('api_keys_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY broadcasts ALTER COLUMN id SET DEFAULT nextval('broadcasts_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY claims ALTER COLUMN id SET DEFAULT nextval('claims_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY crosswalks ALTER COLUMN id SET DEFAULT nextval('crosswalks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY development_team_memberships ALTER COLUMN id SET DEFAULT nextval('development_team_memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY developments ALTER COLUMN id SET DEFAULT nextval('developments_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY developments_programs ALTER COLUMN id SET DEFAULT nextval('developments_programs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY edits ALTER COLUMN id SET DEFAULT nextval('edits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY field_edits ALTER COLUMN id SET DEFAULT nextval('field_edits_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY flags ALTER COLUMN id SET DEFAULT nextval('flags_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY inbox_notices ALTER COLUMN id SET DEFAULT nextval('inbox_notices_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships ALTER COLUMN id SET DEFAULT nextval('memberships_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY organizations ALTER COLUMN id SET DEFAULT nextval('organizations_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY place_profiles ALTER COLUMN id SET DEFAULT nextval('place_profiles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY places ALTER COLUMN id SET DEFAULT nextval('places_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY programs ALTER COLUMN id SET DEFAULT nextval('programs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches ALTER COLUMN id SET DEFAULT nextval('searches_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions ALTER COLUMN id SET DEFAULT nextval('subscriptions_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY verifications ALTER COLUMN id SET DEFAULT nextval('verifications_id_seq'::regclass);


--
-- Name: api_keys_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY api_keys
    ADD CONSTRAINT api_keys_pkey PRIMARY KEY (id);


--
-- Name: broadcasts_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY broadcasts
    ADD CONSTRAINT broadcasts_pkey PRIMARY KEY (id);


--
-- Name: claims_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY claims
    ADD CONSTRAINT claims_pkey PRIMARY KEY (id);


--
-- Name: crosswalks_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY crosswalks
    ADD CONSTRAINT crosswalks_pkey PRIMARY KEY (id);


--
-- Name: development_team_memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY development_team_memberships
    ADD CONSTRAINT development_team_memberships_pkey PRIMARY KEY (id);


--
-- Name: developments_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY developments
    ADD CONSTRAINT developments_pkey PRIMARY KEY (id);


--
-- Name: developments_programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY developments_programs
    ADD CONSTRAINT developments_programs_pkey PRIMARY KEY (id);


--
-- Name: edits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY edits
    ADD CONSTRAINT edits_pkey PRIMARY KEY (id);


--
-- Name: field_edits_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY field_edits
    ADD CONSTRAINT field_edits_pkey PRIMARY KEY (id);


--
-- Name: flags_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY flags
    ADD CONSTRAINT flags_pkey PRIMARY KEY (id);


--
-- Name: inbox_notices_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY inbox_notices
    ADD CONSTRAINT inbox_notices_pkey PRIMARY KEY (id);


--
-- Name: memberships_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT memberships_pkey PRIMARY KEY (id);


--
-- Name: organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: place_profiles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY place_profiles
    ADD CONSTRAINT place_profiles_pkey PRIMARY KEY (id);


--
-- Name: places_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY places
    ADD CONSTRAINT places_pkey PRIMARY KEY (id);


--
-- Name: programs_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY programs
    ADD CONSTRAINT programs_pkey PRIMARY KEY (id);


--
-- Name: searches_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT searches_pkey PRIMARY KEY (id);


--
-- Name: subscriptions_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT subscriptions_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: verifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace:
--

ALTER TABLE ONLY verifications
    ADD CONSTRAINT verifications_pkey PRIMARY KEY (id);


--
-- Name: index_api_keys_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_api_keys_on_user_id ON api_keys USING btree (user_id);


--
-- Name: index_broadcasts_on_creator_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_broadcasts_on_creator_id ON broadcasts USING btree (creator_id);


--
-- Name: index_claims_on_claimant_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_claims_on_claimant_id ON claims USING btree (claimant_id);


--
-- Name: index_claims_on_development_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_claims_on_development_id ON claims USING btree (development_id);


--
-- Name: index_claims_on_moderator_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_claims_on_moderator_id ON claims USING btree (moderator_id);


--
-- Name: index_crosswalks_on_development_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_crosswalks_on_development_id ON crosswalks USING btree (development_id);


--
-- Name: index_crosswalks_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_crosswalks_on_organization_id ON crosswalks USING btree (organization_id);


--
-- Name: index_development_team_memberships_on_development_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_development_team_memberships_on_development_id ON development_team_memberships USING btree (development_id);


--
-- Name: index_development_team_memberships_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_development_team_memberships_on_organization_id ON development_team_memberships USING btree (organization_id);


--
-- Name: index_developments_on_creator_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_developments_on_creator_id ON developments USING btree (creator_id);


--
-- Name: index_developments_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_developments_on_place_id ON developments USING btree (place_id);


--
-- Name: index_developments_programs_on_development_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_developments_programs_on_development_id ON developments_programs USING btree (development_id);


--
-- Name: index_developments_programs_on_program_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_developments_programs_on_program_id ON developments_programs USING btree (program_id);


--
-- Name: index_edits_on_development_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_edits_on_development_id ON edits USING btree (development_id);


--
-- Name: index_edits_on_editor_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_edits_on_editor_id ON edits USING btree (editor_id);


--
-- Name: index_edits_on_moderator_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_edits_on_moderator_id ON edits USING btree (moderator_id);


--
-- Name: index_field_edits_on_edit_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_field_edits_on_edit_id ON field_edits USING btree (edit_id);


--
-- Name: index_flags_on_development_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_flags_on_development_id ON flags USING btree (development_id);


--
-- Name: index_flags_on_flagger_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_flags_on_flagger_id ON flags USING btree (flagger_id);


--
-- Name: index_memberships_on_organization_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_memberships_on_organization_id ON memberships USING btree (organization_id);


--
-- Name: index_memberships_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_memberships_on_user_id ON memberships USING btree (user_id);


--
-- Name: index_organizations_on_creator_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_organizations_on_creator_id ON organizations USING btree (creator_id);


--
-- Name: index_places_on_place_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_places_on_place_id ON places USING btree (place_id);


--
-- Name: index_searches_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_searches_on_user_id ON searches USING btree (user_id);


--
-- Name: index_subscriptions_on_subscribable_type_and_subscribable_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_subscriptions_on_subscribable_type_and_subscribable_id ON subscriptions USING btree (subscribable_type, subscribable_id);


--
-- Name: index_subscriptions_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_subscriptions_on_user_id ON subscriptions USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_verifications_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_verifications_on_user_id ON verifications USING btree (user_id);


--
-- Name: index_verifications_on_verifier_id; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE INDEX index_verifications_on_verifier_id ON verifications USING btree (verifier_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace:
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_10c668431f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY developments_programs
    ADD CONSTRAINT fk_rails_10c668431f FOREIGN KEY (program_id) REFERENCES programs(id);


--
-- Name: fk_rails_32c28d0dc2; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY api_keys
    ADD CONSTRAINT fk_rails_32c28d0dc2 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_4ba831b3b1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY crosswalks
    ADD CONSTRAINT fk_rails_4ba831b3b1 FOREIGN KEY (development_id) REFERENCES developments(id);


--
-- Name: fk_rails_64267aab58; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT fk_rails_64267aab58 FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: fk_rails_6b0105280e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY crosswalks
    ADD CONSTRAINT fk_rails_6b0105280e FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: fk_rails_8a6232040f; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY development_team_memberships
    ADD CONSTRAINT fk_rails_8a6232040f FOREIGN KEY (development_id) REFERENCES developments(id);


--
-- Name: fk_rails_8ce2d558c3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY flags
    ADD CONSTRAINT fk_rails_8ce2d558c3 FOREIGN KEY (development_id) REFERENCES developments(id);


--
-- Name: fk_rails_933bdff476; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY subscriptions
    ADD CONSTRAINT fk_rails_933bdff476 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_99326fb65d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY memberships
    ADD CONSTRAINT fk_rails_99326fb65d FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_9dafeeb28b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY field_edits
    ADD CONSTRAINT fk_rails_9dafeeb28b FOREIGN KEY (edit_id) REFERENCES edits(id);


--
-- Name: fk_rails_ab0bf7bd2c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY places
    ADD CONSTRAINT fk_rails_ab0bf7bd2c FOREIGN KEY (place_id) REFERENCES places(id);


--
-- Name: fk_rails_b0da45c949; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY developments_programs
    ADD CONSTRAINT fk_rails_b0da45c949 FOREIGN KEY (development_id) REFERENCES developments(id);


--
-- Name: fk_rails_b2bbf7151d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY development_team_memberships
    ADD CONSTRAINT fk_rails_b2bbf7151d FOREIGN KEY (organization_id) REFERENCES organizations(id);


--
-- Name: fk_rails_bbb862ca66; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY claims
    ADD CONSTRAINT fk_rails_bbb862ca66 FOREIGN KEY (development_id) REFERENCES developments(id);


--
-- Name: fk_rails_d95949fd60; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY developments
    ADD CONSTRAINT fk_rails_d95949fd60 FOREIGN KEY (place_id) REFERENCES places(id);


--
-- Name: fk_rails_e192b86393; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY searches
    ADD CONSTRAINT fk_rails_e192b86393 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_f184078eb4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY verifications
    ADD CONSTRAINT fk_rails_f184078eb4 FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_f2673df165; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY edits
    ADD CONSTRAINT fk_rails_f2673df165 FOREIGN KEY (development_id) REFERENCES developments(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20151125100000');

INSERT INTO schema_migrations (version) VALUES ('20151125201006');

INSERT INTO schema_migrations (version) VALUES ('20151125201054');

INSERT INTO schema_migrations (version) VALUES ('20151125201223');

INSERT INTO schema_migrations (version) VALUES ('20151125201312');

INSERT INTO schema_migrations (version) VALUES ('20151125201402');

INSERT INTO schema_migrations (version) VALUES ('20151125201447');

INSERT INTO schema_migrations (version) VALUES ('20151125201531');

INSERT INTO schema_migrations (version) VALUES ('20151127164741');

INSERT INTO schema_migrations (version) VALUES ('20151130142956');

INSERT INTO schema_migrations (version) VALUES ('20151201152713');

INSERT INTO schema_migrations (version) VALUES ('20151201210030');

INSERT INTO schema_migrations (version) VALUES ('20151202194028');

INSERT INTO schema_migrations (version) VALUES ('20151202230119');

INSERT INTO schema_migrations (version) VALUES ('20151211185037');

INSERT INTO schema_migrations (version) VALUES ('20151211203155');

INSERT INTO schema_migrations (version) VALUES ('20151211220538');

INSERT INTO schema_migrations (version) VALUES ('20151211221759');

INSERT INTO schema_migrations (version) VALUES ('20151215205923');

INSERT INTO schema_migrations (version) VALUES ('20151215292904');

INSERT INTO schema_migrations (version) VALUES ('20151221193304');

INSERT INTO schema_migrations (version) VALUES ('20151221194441');

INSERT INTO schema_migrations (version) VALUES ('20151229200152');

INSERT INTO schema_migrations (version) VALUES ('20151231181025');

INSERT INTO schema_migrations (version) VALUES ('20160104162316');

INSERT INTO schema_migrations (version) VALUES ('20160104163955');

INSERT INTO schema_migrations (version) VALUES ('20160104174240');

INSERT INTO schema_migrations (version) VALUES ('20160105155100');

INSERT INTO schema_migrations (version) VALUES ('20160120164130');

INSERT INTO schema_migrations (version) VALUES ('20160122215653');

INSERT INTO schema_migrations (version) VALUES ('20160122220237');

INSERT INTO schema_migrations (version) VALUES ('20160122220243');

INSERT INTO schema_migrations (version) VALUES ('20160122225122');

INSERT INTO schema_migrations (version) VALUES ('20160122225135');

INSERT INTO schema_migrations (version) VALUES ('20160122231311');

INSERT INTO schema_migrations (version) VALUES ('20160126211510');

INSERT INTO schema_migrations (version) VALUES ('20160129171814');

INSERT INTO schema_migrations (version) VALUES ('20160202213848');

INSERT INTO schema_migrations (version) VALUES ('20160204210517');

INSERT INTO schema_migrations (version) VALUES ('20160205213705');

INSERT INTO schema_migrations (version) VALUES ('20160208220942');

INSERT INTO schema_migrations (version) VALUES ('20160208231004');

INSERT INTO schema_migrations (version) VALUES ('20160209214001');

INSERT INTO schema_migrations (version) VALUES ('20160210184025');

INSERT INTO schema_migrations (version) VALUES ('20160308203038');

INSERT INTO schema_migrations (version) VALUES ('20160321203100');

