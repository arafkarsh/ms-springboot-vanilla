--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

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

--
-- Name: ms_schema; Type: SCHEMA; Schema: -; Owner: msadm
--

CREATE SCHEMA ms_schema;


ALTER SCHEMA ms_schema OWNER TO msadm;

--
-- Name: sendnotification(text); Type: PROCEDURE; Schema: ms_schema; Owner: msadm
--

CREATE PROCEDURE ms_schema.sendnotification(IN customer_id text, OUT message text)
    LANGUAGE plpgsql
    AS $$
BEGIN
  -- logic here
  message := 'Notification sent to ' || customer_id;
END;
$$;


ALTER PROCEDURE ms_schema.sendnotification(IN customer_id text, OUT message text) OWNER TO msadm;

--
-- Name: sendnotificationfunc(text); Type: FUNCTION; Schema: ms_schema; Owner: msadm
--

CREATE FUNCTION ms_schema.sendnotificationfunc(customer_id text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
  message text;
BEGIN
  message := 'PostgreSQL:sendNotificationFunc: Notification sent to ' || customer_id;
  RETURN message;
END;
$$;


ALTER FUNCTION ms_schema.sendnotificationfunc(customer_id text) OWNER TO msadm;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: association_value_entry; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.association_value_entry (
    id bigint NOT NULL,
    saga_id character varying(255) NOT NULL,
    association_key character varying(255) NOT NULL,
    association_value character varying(255) NOT NULL,
    saga_type character varying(255)
);


ALTER TABLE ms_schema.association_value_entry OWNER TO msadm;

--
-- Name: association_value_entry_id_seq; Type: SEQUENCE; Schema: ms_schema; Owner: msadm
--

CREATE SEQUENCE ms_schema.association_value_entry_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ms_schema.association_value_entry_id_seq OWNER TO msadm;

--
-- Name: association_value_entry_id_seq; Type: SEQUENCE OWNED BY; Schema: ms_schema; Owner: msadm
--

ALTER SEQUENCE ms_schema.association_value_entry_id_seq OWNED BY ms_schema.association_value_entry.id;


--
-- Name: cart_es_view_items_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.cart_es_view_items_tx (
    id bigint NOT NULL,
    cart_id character varying(64) NOT NULL,
    product_id character varying(128) NOT NULL,
    quantity integer NOT NULL,
    unit_price numeric(18,2) NOT NULL,
    line_total numeric(18,2) NOT NULL
);


ALTER TABLE ms_schema.cart_es_view_items_tx OWNER TO msadm;

--
-- Name: cart_es_view_items_tx_id_seq; Type: SEQUENCE; Schema: ms_schema; Owner: msadm
--

CREATE SEQUENCE ms_schema.cart_es_view_items_tx_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ms_schema.cart_es_view_items_tx_id_seq OWNER TO msadm;

--
-- Name: cart_es_view_items_tx_id_seq; Type: SEQUENCE OWNED BY; Schema: ms_schema; Owner: msadm
--

ALTER SEQUENCE ms_schema.cart_es_view_items_tx_id_seq OWNED BY ms_schema.cart_es_view_items_tx.id;


--
-- Name: cart_es_view_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.cart_es_view_tx (
    cart_id character varying(64) NOT NULL,
    checked_out boolean DEFAULT false NOT NULL,
    total numeric(18,2) DEFAULT 0 NOT NULL
);


ALTER TABLE ms_schema.cart_es_view_tx OWNER TO msadm;

--
-- Name: carts_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.carts_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp(6) without time zone NOT NULL,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp(6) without time zone NOT NULL,
    isactive boolean,
    version integer,
    customerid character varying(255) NOT NULL,
    productid character varying(255) NOT NULL,
    productname character varying(32),
    price numeric(38,2) NOT NULL,
    quantity numeric(38,2) NOT NULL
);


ALTER TABLE ms_schema.carts_tx OWNER TO msadm;

--
-- Name: country_geolite_m; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.country_geolite_m (
    geoname_id integer NOT NULL,
    locale_code character varying(255) NOT NULL,
    continent_code character varying(255) NOT NULL,
    continent_name character varying(255) NOT NULL,
    country_iso_code character varying(255),
    country_name character varying(255),
    is_in_european_union integer NOT NULL
);


ALTER TABLE ms_schema.country_geolite_m OWNER TO msadm;

--
-- Name: country_m; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.country_m (
    countryuuid uuid NOT NULL,
    countrycode character varying(255) NOT NULL,
    countryid integer NOT NULL,
    countryname character varying(255) NOT NULL,
    countryofficialname character varying(255)
);


ALTER TABLE ms_schema.country_m OWNER TO msadm;

--
-- Name: country_t; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.country_t (
    cid integer NOT NULL,
    countryid integer NOT NULL,
    countrycode character varying(255) NOT NULL,
    countryname character varying(255) NOT NULL,
    countryofficialname character varying(255)
);


ALTER TABLE ms_schema.country_t OWNER TO msadm;

--
-- Name: critical_table_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.critical_table_tx (
    pkey character varying NOT NULL,
    userid character varying NOT NULL,
    isactive boolean DEFAULT true NOT NULL
);


ALTER TABLE ms_schema.critical_table_tx OWNER TO msadm;

--
-- Name: domain_event_entry; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.domain_event_entry (
    global_index bigint NOT NULL,
    event_identifier character varying(255) NOT NULL,
    aggregate_identifier character varying(255) NOT NULL,
    sequence_number bigint NOT NULL,
    type character varying(255) NOT NULL,
    time_stamp character varying(255) NOT NULL,
    payload_type character varying(255) NOT NULL,
    payload_revision character varying(255),
    payload bytea NOT NULL,
    meta_data bytea
);


ALTER TABLE ms_schema.domain_event_entry OWNER TO msadm;

--
-- Name: domain_event_entry_global_index_seq; Type: SEQUENCE; Schema: ms_schema; Owner: msadm
--

CREATE SEQUENCE ms_schema.domain_event_entry_global_index_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE ms_schema.domain_event_entry_global_index_seq OWNER TO msadm;

--
-- Name: domain_event_entry_global_index_seq; Type: SEQUENCE OWNED BY; Schema: ms_schema; Owner: msadm
--

ALTER SEQUENCE ms_schema.domain_event_entry_global_index_seq OWNED BY ms_schema.domain_event_entry.global_index;


--
-- Name: order_item_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.order_item_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    price numeric(38,2),
    productid character varying(255),
    productname character varying(255),
    quantity numeric(38,2),
    order_id uuid
);


ALTER TABLE ms_schema.order_item_tx OWNER TO msadm;

--
-- Name: order_payment_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.order_payment_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    status character varying(255),
    transaction_id character varying(255)
);


ALTER TABLE ms_schema.order_payment_tx OWNER TO msadm;

--
-- Name: order_state_history_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.order_state_history_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    notes character varying(255),
    sourcestate character varying(255),
    targetstate character varying(255),
    transitionevent character varying(255),
    order_id uuid,
    orderversion integer
);


ALTER TABLE ms_schema.order_state_history_tx OWNER TO msadm;

--
-- Name: order_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.order_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    currency character varying(255),
    customer_id character varying(255),
    city character varying(255),
    country character varying(255),
    landmark character varying(255),
    phone character varying(255),
    state character varying(255),
    street character varying(255),
    zip_code character varying(255),
    totalordervalue numeric(38,2),
    payment_id uuid,
    orderstatus character varying(255),
    result character varying(255)
);


ALTER TABLE ms_schema.order_tx OWNER TO msadm;

--
-- Name: products_m; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.products_m (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp(6) without time zone NOT NULL,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp(6) without time zone NOT NULL,
    isactive boolean,
    version integer,
    productdetails character varying(64) NOT NULL,
    productlocationzipcode character varying(255),
    productname character varying(32),
    price numeric(38,2) NOT NULL
);


ALTER TABLE ms_schema.products_m OWNER TO msadm;

--
-- Name: reservation_flight_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.reservation_flight_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    airlines character varying(255),
    flightid character varying(255),
    flightreservationno character varying(255),
    fromcity character varying(255),
    journeydate date,
    pnr character varying(255),
    rate integer,
    reservationstatus character varying(255),
    statusreasons character varying(255),
    tocity character varying(255),
    reservation_id uuid,
    gender character varying(255),
    passengername character varying(255)
);


ALTER TABLE ms_schema.reservation_flight_tx OWNER TO msadm;

--
-- Name: reservation_hotel_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.reservation_hotel_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    days integer,
    enddate date,
    hotelid character varying(255),
    hotelname character varying(255),
    hotelreservationno character varying(255),
    persons integer,
    rate integer,
    reservationstatus character varying(255),
    startdate date,
    reservation_id uuid
);


ALTER TABLE ms_schema.reservation_hotel_tx OWNER TO msadm;

--
-- Name: reservation_payment_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.reservation_payment_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    status character varying(255),
    transaction_id character varying(255)
);


ALTER TABLE ms_schema.reservation_payment_tx OWNER TO msadm;

--
-- Name: reservation_rental_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.reservation_rental_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    days integer,
    enddate date,
    rate integer,
    rentalid character varying(255),
    rentalname character varying(255),
    rentalreservationno character varying(255),
    rentaltype character varying(255),
    rentalvehiclelicense character varying(255),
    reservationstatus character varying(255),
    startdate date,
    statusreasons character varying(255),
    reservation_id uuid,
    primarydriver character varying(255)
);


ALTER TABLE ms_schema.reservation_rental_tx OWNER TO msadm;

--
-- Name: reservation_state_history_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.reservation_state_history_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    aggregateversionno integer DEFAULT 0,
    notes character varying(255),
    sourcestate character varying(255),
    targetstate character varying(255),
    transitionevent character varying(255),
    reservation_id uuid
);


ALTER TABLE ms_schema.reservation_state_history_tx OWNER TO msadm;

--
-- Name: reservation_tx; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.reservation_tx (
    uuid uuid NOT NULL,
    createdby character varying(255) NOT NULL,
    createdtime timestamp without time zone NOT NULL,
    isactive boolean,
    updatedby character varying(255) NOT NULL,
    updatedtime timestamp without time zone NOT NULL,
    version integer,
    currency character varying(255),
    city character varying(255),
    country character varying(255),
    landmark character varying(255),
    phone character varying(255),
    state character varying(255),
    street character varying(255),
    zip_code character varying(255),
    customer_id character varying(255),
    reservationstatus character varying(255),
    result character varying(255),
    totalvalue integer,
    payment_id uuid,
    rollbackonfailure boolean
);


ALTER TABLE ms_schema.reservation_tx OWNER TO msadm;

--
-- Name: saga_entry; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.saga_entry (
    saga_id character varying(255) NOT NULL,
    revision character varying(255),
    saga_type character varying(255),
    serialized_saga bytea
);


ALTER TABLE ms_schema.saga_entry OWNER TO msadm;

--
-- Name: snapshot_event_entry; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.snapshot_event_entry (
    sequence_number bigint NOT NULL,
    aggregate_identifier character varying(255) NOT NULL,
    type character varying(255) NOT NULL,
    event_identifier character varying(255) NOT NULL,
    time_stamp character varying(255) NOT NULL,
    payload_type character varying(255) NOT NULL,
    payload_revision character varying(255),
    payload bytea NOT NULL,
    meta_data bytea
);


ALTER TABLE ms_schema.snapshot_event_entry OWNER TO msadm;

--
-- Name: token_entry; Type: TABLE; Schema: ms_schema; Owner: msadm
--

CREATE TABLE ms_schema.token_entry (
    processor_name character varying(255) NOT NULL,
    segment integer NOT NULL,
    token bytea,
    token_type character varying(255),
    "timestamp" character varying(255),
    owner character varying(255)
);


ALTER TABLE ms_schema.token_entry OWNER TO msadm;

--
-- Name: association_value_entry id; Type: DEFAULT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.association_value_entry ALTER COLUMN id SET DEFAULT nextval('ms_schema.association_value_entry_id_seq'::regclass);


--
-- Name: cart_es_view_items_tx id; Type: DEFAULT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.cart_es_view_items_tx ALTER COLUMN id SET DEFAULT nextval('ms_schema.cart_es_view_items_tx_id_seq'::regclass);


--
-- Name: domain_event_entry global_index; Type: DEFAULT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.domain_event_entry ALTER COLUMN global_index SET DEFAULT nextval('ms_schema.domain_event_entry_global_index_seq'::regclass);


--
-- Data for Name: association_value_entry; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.association_value_entry (id, saga_id, association_key, association_value, saga_type) FROM stdin;
\.


--
-- Data for Name: cart_es_view_items_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.cart_es_view_items_tx (id, cart_id, product_id, quantity, unit_price, line_total) FROM stdin;
\.


--
-- Data for Name: cart_es_view_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.cart_es_view_tx (cart_id, checked_out, total) FROM stdin;
\.


--
-- Data for Name: carts_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.carts_tx (uuid, createdby, createdtime, updatedby, updatedtime, isactive, version, customerid, productid, productname, price, quantity) FROM stdin;
b1edfc2d-a907-4806-b51f-28c7bd3cdd3f	john.doe	2023-05-28 20:26:12.919	john.doe	2023-05-28 20:26:12.919	t	0	jane.doe	902	Paper 100 Bundle	50.00	5.00
bbef5710-e7ba-4bc9-9c01-353dbd82dd6e	john.doe	2023-05-28 20:26:12.919	john.doe	2023-05-28 20:26:12.919	t	0	jane.doe	902	Book Lined	30.00	3.00
a43e9fd2-a3bd-4281-91e9-96f5e130f032	anonymousUser	2023-07-02 10:30:12.991269	anonymousUser	2023-07-02 10:30:12.991269	t	0	john.doe	1542	Lunch Box	35.00	1.00
f9e9c861-e48c-4485-ac7d-5f6c29beeb37	anonymousUser	2023-07-02 10:35:50.113237	anonymousUser	2023-07-02 10:35:50.113237	t	0	john.doe	1544	Umbrella	32.00	1.00
faca053a-b4af-4a31-aa15-bf2dbf2102e1	anonymousUser	2023-07-02 10:30:53.952645	anonymousUser	2023-08-05 13:51:09.563412	t	2	john.doe	1543	School Bag	45.00	1.00
f8477299-98df-43b0-a04d-11d22c128406	john.doe	2024-10-27 16:24:44.534	john.doe	2024-10-27 16:24:44.534	t	0	123	789	Pencil	130.00	13.00
d40f2025-9e31-455a-b27d-9831223d2c84	john.doe	2024-10-29 14:29:16.459	john.doe	2024-10-29 14:29:16.459	t	0	123	12	Apple Pencil	24000.00	1.00
7b54e398-711a-4820-a32c-81c7dfab1ab1	john.doe	2023-05-28 20:26:12.919	john.doe	2024-11-22 11:52:12.96	t	2	123	678	Pen	30.00	2.00
a4fbe178-cc96-486c-b08a-962ce4adf3d9	john.doe	2024-11-22 11:53:13.9	john.doe	2024-11-22 11:53:13.9	t	0	123	987	iPhone 16 Pro Max	153000.00	1.00
016dce68-bdee-475b-8adc-fa30cd7e722d	john.doe	2024-11-22 11:53:30.631	john.doe	2024-11-22 11:53:30.631	t	0	123	987	iPhone 16 Pro	133000.00	1.00
b636adce-6a38-43f9-9cab-b1799189cac2	john.doe	2025-08-12 11:58:05.463	john.doe	2025-08-12 11:58:05.463	t	0	123	988	iPhone 17 Air	123000.00	1.00
\.


--
-- Data for Name: country_geolite_m; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.country_geolite_m (geoname_id, locale_code, continent_code, continent_name, country_iso_code, country_name, is_in_european_union) FROM stdin;
49518	en	AF	Africa	RW	Rwanda	0
51537	en	AF	Africa	SO	Somalia	0
69543	en	AS	Asia	YE	Yemen	0
99237	en	AS	Asia	IQ	Iraq	0
102358	en	AS	Asia	SA	Saudi Arabia	0
130758	en	AS	Asia	IR	Iran	0
146669	en	EU	Europe	CY	Cyprus	1
149590	en	AF	Africa	TZ	Tanzania	0
163843	en	AS	Asia	SY	Syria	0
174982	en	AS	Asia	AM	Armenia	0
192950	en	AF	Africa	KE	Kenya	0
203312	en	AF	Africa	CD	DR Congo	0
223816	en	AF	Africa	DJ	Djibouti	0
226074	en	AF	Africa	UG	Uganda	0
239880	en	AF	Africa	CF	Central African Republic	0
241170	en	AF	Africa	SC	Seychelles	0
248816	en	AS	Asia	JO	Jordan	0
272103	en	AS	Asia	LB	Lebanon	0
285570	en	AS	Asia	KW	Kuwait	0
286963	en	AS	Asia	OM	Oman	0
289688	en	AS	Asia	QA	Qatar	0
290291	en	AS	Asia	BH	Bahrain	0
290557	en	AS	Asia	AE	United Arab Emirates	0
294640	en	AS	Asia	IL	Israel	0
298795	en	AS	Asia	TR	Turkey	0
337996	en	AF	Africa	ET	Ethiopia	0
338010	en	AF	Africa	ER	Eritrea	0
357994	en	AF	Africa	EG	Egypt	0
366755	en	AF	Africa	SD	Sudan	0
390903	en	EU	Europe	GR	Greece	1
433561	en	AF	Africa	BI	Burundi	0
453733	en	EU	Europe	EE	Estonia	1
458258	en	EU	Europe	LV	Latvia	1
587116	en	AS	Asia	AZ	Azerbaijan	0
597427	en	EU	Europe	LT	Lithuania	1
607072	en	EU	Europe	SJ	Svalbard and Jan Mayen	0
614540	en	AS	Asia	GE	Georgia	0
617790	en	EU	Europe	MD	Moldova	0
630336	en	EU	Europe	BY	Belarus	0
660013	en	EU	Europe	FI	Finland	1
661882	en	EU	Europe	AX	Åland Islands	1
690791	en	EU	Europe	UA	Ukraine	0
718075	en	EU	Europe	MK	North Macedonia	0
719819	en	EU	Europe	HU	Hungary	1
732800	en	EU	Europe	BG	Bulgaria	1
783754	en	EU	Europe	AL	Albania	0
798544	en	EU	Europe	PL	Poland	1
798549	en	EU	Europe	RO	Romania	1
831053	en	EU	Europe	XK	Kosovo	0
878675	en	AF	Africa	ZW	Zimbabwe	0
895949	en	AF	Africa	ZM	Zambia	0
921929	en	AF	Africa	KM	Comoros	0
927384	en	AF	Africa	MW	Malawi	0
932692	en	AF	Africa	LS	Lesotho	0
933860	en	AF	Africa	BW	Botswana	0
934292	en	AF	Africa	MU	Mauritius	0
934841	en	AF	Africa	SZ	Eswatini	0
935317	en	AF	Africa	RE	Réunion	1
953987	en	AF	Africa	ZA	South Africa	0
1024031	en	AF	Africa	YT	Mayotte	1
1036973	en	AF	Africa	MZ	Mozambique	0
1062947	en	AF	Africa	MG	Madagascar	0
1149361	en	AS	Asia	AF	Afghanistan	0
1168579	en	AS	Asia	PK	Pakistan	0
1210997	en	AS	Asia	BD	Bangladesh	0
1218197	en	AS	Asia	TM	Turkmenistan	0
1220409	en	AS	Asia	TJ	Tajikistan	0
1227603	en	AS	Asia	LK	Sri Lanka	0
1252634	en	AS	Asia	BT	Bhutan	0
1269750	en	AS	Asia	IN	India	0
1282028	en	AS	Asia	MV	Maldives	0
1282588	en	AS	Asia	IO	British Indian Ocean Territory	0
1282988	en	AS	Asia	NP	Nepal	0
1327865	en	AS	Asia	MM	Myanmar	0
1512440	en	AS	Asia	UZ	Uzbekistan	0
1522867	en	AS	Asia	KZ	Kazakhstan	0
1527747	en	AS	Asia	KG	Kyrgyzstan	0
1546748	en	AN	Antarctica	TF	French Southern Territories	0
1547314	en	AN	Antarctica	HM	Heard and McDonald Islands	0
1547376	en	AS	Asia	CC	Cocos (Keeling) Islands	0
1559582	en	OC	Oceania	PW	Palau	0
1562822	en	AS	Asia	VN	Vietnam	0
1605651	en	AS	Asia	TH	Thailand	0
1643084	en	AS	Asia	ID	Indonesia	0
1655842	en	AS	Asia	LA	Laos	0
1668284	en	AS	Asia	TW	Taiwan	0
1694008	en	AS	Asia	PH	Philippines	0
1733045	en	AS	Asia	MY	Malaysia	0
1814991	en	AS	Asia	CN	China	0
1819730	en	AS	Asia	HK	Hong Kong	0
1820814	en	AS	Asia	BN	Brunei	0
1821275	en	AS	Asia	MO	Macao	0
1831722	en	AS	Asia	KH	Cambodia	0
1835841	en	AS	Asia	KR	South Korea	0
1861060	en	AS	Asia	JP	Japan	0
1873107	en	AS	Asia	KP	North Korea	0
1880251	en	AS	Asia	SG	Singapore	0
1899402	en	OC	Oceania	CK	Cook Islands	0
1966436	en	OC	Oceania	TL	Timor-Leste	0
2017370	en	EU	Europe	RU	Russia	0
2029969	en	AS	Asia	MN	Mongolia	0
2077456	en	OC	Oceania	AU	Australia	0
2078138	en	OC	Oceania	CX	Christmas Island	0
2080185	en	OC	Oceania	MH	Marshall Islands	0
2081918	en	OC	Oceania	FM	Federated States of Micronesia	0
2088628	en	OC	Oceania	PG	Papua New Guinea	0
2103350	en	OC	Oceania	SB	Solomon Islands	0
2110297	en	OC	Oceania	TV	Tuvalu	0
2110425	en	OC	Oceania	NR	Nauru	0
2134431	en	OC	Oceania	VU	Vanuatu	0
2139685	en	OC	Oceania	NC	New Caledonia	0
2155115	en	OC	Oceania	NF	Norfolk Island	0
2186224	en	OC	Oceania	NZ	New Zealand	0
2205218	en	OC	Oceania	FJ	Fiji	0
2215636	en	AF	Africa	LY	Libya	0
2233387	en	AF	Africa	CM	Cameroon	0
2245662	en	AF	Africa	SN	Senegal	0
2260494	en	AF	Africa	CG	Congo Republic	0
2264397	en	EU	Europe	PT	Portugal	1
2275384	en	AF	Africa	LR	Liberia	0
2287781	en	AF	Africa	CI	Ivory Coast	0
2300660	en	AF	Africa	GH	Ghana	0
2309096	en	AF	Africa	GQ	Equatorial Guinea	0
2328926	en	AF	Africa	NG	Nigeria	0
2361809	en	AF	Africa	BF	Burkina Faso	0
2363686	en	AF	Africa	TG	Togo	0
2372248	en	AF	Africa	GW	Guinea-Bissau	0
2378080	en	AF	Africa	MR	Mauritania	0
2395170	en	AF	Africa	BJ	Benin	0
2400553	en	AF	Africa	GA	Gabon	0
2403846	en	AF	Africa	SL	Sierra Leone	0
2410758	en	AF	Africa	ST	São Tomé and Príncipe	0
2411586	en	EU	Europe	GI	Gibraltar	0
2413451	en	AF	Africa	GM	Gambia	0
2420477	en	AF	Africa	GN	Guinea	0
2434508	en	AF	Africa	TD	Chad	0
2440476	en	AF	Africa	NE	Niger	0
2453866	en	AF	Africa	ML	Mali	0
2461445	en	AF	Africa	EH	Western Sahara	0
2464461	en	AF	Africa	TN	Tunisia	0
2510769	en	EU	Europe	ES	Spain	1
2542007	en	AF	Africa	MA	Morocco	0
2562770	en	EU	Europe	MT	Malta	1
2589581	en	AF	Africa	DZ	Algeria	0
2622320	en	EU	Europe	FO	Faroe Islands	0
2623032	en	EU	Europe	DK	Denmark	1
2629691	en	EU	Europe	IS	Iceland	0
2635167	en	EU	Europe	GB	United Kingdom	0
2658434	en	EU	Europe	CH	Switzerland	0
2661886	en	EU	Europe	SE	Sweden	1
2750405	en	EU	Europe	NL	Netherlands	1
2782113	en	EU	Europe	AT	Austria	1
2802361	en	EU	Europe	BE	Belgium	1
2921044	en	EU	Europe	DE	Germany	1
2960313	en	EU	Europe	LU	Luxembourg	1
2963597	en	EU	Europe	IE	Ireland	1
2993457	en	EU	Europe	MC	Monaco	0
3017382	en	EU	Europe	FR	France	1
3041565	en	EU	Europe	AD	Andorra	0
3042058	en	EU	Europe	LI	Liechtenstein	0
3042142	en	EU	Europe	JE	Jersey	0
3042225	en	EU	Europe	IM	Isle of Man	0
3042362	en	EU	Europe	GG	Guernsey	0
3057568	en	EU	Europe	SK	Slovakia	1
3077311	en	EU	Europe	CZ	Czechia	1
3144096	en	EU	Europe	NO	Norway	0
3164670	en	EU	Europe	VA	Vatican City	0
3168068	en	EU	Europe	SM	San Marino	0
3175395	en	EU	Europe	IT	Italy	1
3190538	en	EU	Europe	SI	Slovenia	1
3194884	en	EU	Europe	ME	Montenegro	0
3202326	en	EU	Europe	HR	Croatia	1
3277605	en	EU	Europe	BA	Bosnia and Herzegovina	0
3351879	en	AF	Africa	AO	Angola	0
3355338	en	AF	Africa	NA	Namibia	0
3370751	en	AF	Africa	SH	Saint Helena	0
3371123	en	AN	Antarctica	BV	Bouvet Island	0
3374084	en	NA	North America	BB	Barbados	0
3374766	en	AF	Africa	CV	Cabo Verde	0
3378535	en	SA	South America	GY	Guyana	0
3381670	en	SA	South America	GF	French Guiana	1
3382998	en	SA	South America	SR	Suriname	0
3424932	en	NA	North America	PM	Saint Pierre and Miquelon	0
3425505	en	NA	North America	GL	Greenland	0
3437598	en	SA	South America	PY	Paraguay	0
3439705	en	SA	South America	UY	Uruguay	0
3469034	en	SA	South America	BR	Brazil	0
3474414	en	SA	South America	FK	Falkland Islands	0
3474415	en	AN	Antarctica	GS	South Georgia and the South Sandwich Islands	0
3489940	en	NA	North America	JM	Jamaica	0
3508796	en	NA	North America	DO	Dominican Republic	0
3562981	en	NA	North America	CU	Cuba	0
3570311	en	NA	North America	MQ	Martinique	1
3572887	en	NA	North America	BS	Bahamas	0
3573345	en	NA	North America	BM	Bermuda	0
3573511	en	NA	North America	AI	Anguilla	0
3573591	en	NA	North America	TT	Trinidad and Tobago	0
3575174	en	NA	North America	KN	St Kitts and Nevis	0
3575830	en	NA	North America	DM	Dominica	0
3576396	en	NA	North America	AG	Antigua and Barbuda	0
3576468	en	NA	North America	LC	Saint Lucia	0
3576916	en	NA	North America	TC	Turks and Caicos Islands	0
3577279	en	NA	North America	AW	Aruba	0
3577718	en	NA	North America	VG	British Virgin Islands	0
3577815	en	NA	North America	VC	St Vincent and Grenadines	0
3578097	en	NA	North America	MS	Montserrat	0
3578421	en	NA	North America	MF	Saint Martin	1
3578476	en	NA	North America	BL	Saint Barthélemy	0
3579143	en	NA	North America	GP	Guadeloupe	1
3580239	en	NA	North America	GD	Grenada	0
3580718	en	NA	North America	KY	Cayman Islands	0
3582678	en	NA	North America	BZ	Belize	0
3585968	en	NA	North America	SV	El Salvador	0
3595528	en	NA	North America	GT	Guatemala	0
3608932	en	NA	North America	HN	Honduras	0
3617476	en	NA	North America	NI	Nicaragua	0
3624060	en	NA	North America	CR	Costa Rica	0
3625428	en	SA	South America	VE	Venezuela	0
3658394	en	SA	South America	EC	Ecuador	0
3686110	en	SA	South America	CO	Colombia	0
3703430	en	NA	North America	PA	Panama	0
3723988	en	NA	North America	HT	Haiti	0
3865483	en	SA	South America	AR	Argentina	0
3895114	en	SA	South America	CL	Chile	0
3923057	en	SA	South America	BO	Bolivia	0
3932488	en	SA	South America	PE	Peru	0
3996063	en	NA	North America	MX	Mexico	0
4030656	en	OC	Oceania	PF	French Polynesia	0
4030699	en	OC	Oceania	PN	Pitcairn Islands	0
4030945	en	OC	Oceania	KI	Kiribati	0
4031074	en	OC	Oceania	TK	Tokelau	0
4032283	en	OC	Oceania	TO	Tonga	0
4034749	en	OC	Oceania	WF	Wallis and Futuna	0
4034894	en	OC	Oceania	WS	Samoa	0
4036232	en	OC	Oceania	NU	Niue	0
4041468	en	OC	Oceania	MP	Northern Mariana Islands	0
4043988	en	OC	Oceania	GU	Guam	0
4566966	en	NA	North America	PR	Puerto Rico	0
4796775	en	NA	North America	VI	U.S. Virgin Islands	0
5854968	en	OC	Oceania	UM	U.S. Outlying Islands	0
5880801	en	OC	Oceania	AS	American Samoa	0
6251999	en	NA	North America	CA	Canada	0
6252001	en	NA	North America	US	United States	0
6254930	en	AS	Asia	PS	Palestine	0
6255147	en	AS	Asia	\N	\N	0
6255148	en	EU	Europe	\N	\N	0
6290252	en	EU	Europe	RS	Serbia	0
6697173	en	AN	Antarctica	AQ	Antarctica	0
7609695	en	NA	North America	SX	Sint Maarten	0
7626836	en	NA	North America	CW	Curaçao	0
7626844	en	NA	North America	BQ	Bonaire, Sint Eustatius, and Saba	0
7909807	en	AF	Africa	SS	South Sudan	0
\.


--
-- Data for Name: country_m; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.country_m (countryuuid, countrycode, countryid, countryname, countryofficialname) FROM stdin;
\.


--
-- Data for Name: country_t; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.country_t (cid, countryid, countrycode, countryname, countryofficialname) FROM stdin;
1	1	USA	America	United States of America
2	250	FRA	France	The French Republic
3	76	BRA	Brazil	The Federative Republic of Brazil
6	124	CAN	Canada	Canada
7	276	DEU	Germany	Federal Republic of Germany
8	724	ESP	Spain	Kingdom of Spain
9	380	ITA	Italy	Italian Republic
10	56	BEL	Belgium	Kingdom of Belgium
11	528	NLD	Netherlands	Kingdom of Netherlands
12	616	POL	Poland	Republic of Poland
13	792	TUR	Turkey	Republic of Turkey
15	40	AUT	Austria	Republic of Austria
14	756	CHE	Switzerland	Swiss Confederation
16	32	ARG	Argentina	Argentine Republic
17	76	BRA	Brazil	Federative Republic of Brazil
18	152	CHL	Chile	Republic of Chile
19	170	COL	Columbia	Republic of Columbia
20	484	MEX	Mexico	United Mexican States
21	858	URY	Uruguay	Oriental Republic of Uruguay
22	604	PER	Peru	Republic of Peru
23	862	VEN	Venezuela	Bolivarin Republic of Venezuela
4	111	ITA	Italy	Italy
5	356	IND	India	Republic of India
\.


--
-- Data for Name: critical_table_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.critical_table_tx (pkey, userid, isactive) FROM stdin;
abc1001	jane.doe	t
abc1002	john.doe	t
\.


--
-- Data for Name: domain_event_entry; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.domain_event_entry (global_index, event_identifier, aggregate_identifier, sequence_number, type, time_stamp, payload_type, payload_revision, payload, meta_data) FROM stdin;
\.


--
-- Data for Name: order_item_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.order_item_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, price, productid, productname, quantity, order_id) FROM stdin;
fb19e155-144c-493d-895d-ff7614e7f53f	anonymousUser	2023-07-05 11:24:30.548063	t	anonymousUser	2023-07-07 12:44:27.556828	1	40000.00	5dcb87dd-0480-4e45-be83-ddcba3313c4f	Apple Watch 5	1.00	7a8bc3d8-911f-4aee-bc71-5dfa25a4a3ae
34510d2c-663b-40da-9154-55aa3ee75118	anonymousUser	2023-07-05 11:24:30.547118	t	anonymousUser	2023-07-07 12:44:27.556975	1	45000.00	25886064-2a6d-417a-9040-111166f250f3	Apple Watch 6	1.00	7a8bc3d8-911f-4aee-bc71-5dfa25a4a3ae
33afea94-2cde-40e5-afee-0dd4de32546b	anonymousUser	2023-07-07 11:24:30.547	t	anonymousUser	2023-07-07 12:44:27.556975	1	90000.00	25886064-2a6d-417a-9040-111166f250f3	iPhone 15	1.00	e5a5bb0d-6282-4072-9926-a0653095fd07
3bb8be4a-ca61-4d19-9a7d-5e43c134916a	anonymousUser	2023-07-07 11:24:30.547	t	anonymousUser	2023-07-07 12:44:27.556975	1	80000.00	25886064-2a6d-417a-9040-111166f250f3	iPhone 14	1.00	e5a5bb0d-6282-4072-9926-a0653095fd07
\.


--
-- Data for Name: order_payment_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.order_payment_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, status, transaction_id) FROM stdin;
63fd3531-ee6b-40d8-aed0-2faeebc41c87	anonymousUser	2023-07-05 11:24:30.527592	t	anonymousUser	2023-07-05 11:24:30.527592	0	string	string
999bda45-b1ad-4af3-a2fa-4564cca52ed6	anonymousUser	2023-07-07 12:44:27.541352	t	anonymousUser	2023-07-07 12:44:27.541352	0	string	string
\.


--
-- Data for Name: order_state_history_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.order_state_history_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, notes, sourcestate, targetstate, transitionevent, order_id, orderversion) FROM stdin;
c86ddba1-6869-495d-9e44-3d181ea41f87	anonymousUser	2023-07-13 18:00:32.710834	t	anonymousUser	2023-07-13 18:00:32.710834	0		PAYMENT_CONFIRMED	PACKING_FORK	PACKAGE_FORK_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1605
1f33c58e-ae3d-42bc-a5cf-eb622a888603	anonymousUser	2023-07-13 18:00:32.716818	t	anonymousUser	2023-07-13 18:00:32.716818	0		PACKING_FORK	ORDER_PACKAGING_START	PACKAGE_FORK_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1606
f8d069bc-4f15-4c67-8dd1-ce6e87f4f693	anonymousUser	2023-07-13 18:00:32.721738	t	anonymousUser	2023-07-13 18:00:32.721738	0		ORDER_PACKAGING_START	SEND_BILL_START	PACKAGE_FORK_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1607
b0e36d16-d0a2-4f27-9022-81758040d6ba	anonymousUser	2023-07-13 18:00:32.728011	t	anonymousUser	2023-07-13 18:00:32.728011	0		SEND_BILL_START	ORDER_PACKAGING_DONE	PACKAGE_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1608
1f49f434-a161-4a63-a8fc-5bfb7067e826	anonymousUser	2023-07-13 18:00:32.736294	t	anonymousUser	2023-07-13 18:00:32.736294	0		ORDER_PACKAGING_DONE	SEND_BILL_DONE	ORDER_SEND_BILL_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1609
845665d0-9019-473b-8a97-1975961c67c7	anonymousUser	2023-07-13 18:00:32.744518	t	anonymousUser	2023-07-13 18:00:32.744518	0		PACKING_FORK	SHIPPED	ORDER_SEND_BILL_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1610
83cf194e-84b8-45b7-a591-2d2d422de703	anonymousUser	2023-07-13 18:00:33.835162	t	anonymousUser	2023-07-13 18:00:33.835162	0		SHIPPED	IN_TRANSIT	ORDER_IN_TRANSIT_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1611
016cc36f-0e57-48de-bca4-01d74941dfe3	anonymousUser	2023-07-13 18:00:34.888597	t	anonymousUser	2023-07-13 18:00:34.888597	0		IN_TRANSIT	REACHED_DESTINATION	SEND_FOR_DELIVERY_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1612
6ddd6cd3-26d7-43e2-bb4d-687a6e9ec314	anonymousUser	2023-07-13 18:00:35.968272	t	anonymousUser	2023-07-13 18:00:35.968272	0		REACHED_DESTINATION	DELIVERED	ORDER_DELIVERED_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1613
67883839-bbb7-453c-bf72-b0ffc8424ef9	anonymousUser	2023-07-13 18:00:35.976364	t	anonymousUser	2023-07-13 18:00:35.976364	0		DELIVERED	ORDER_COMPLETED	AUTO_TRANSITION_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1614
dad9efb3-dc2b-4e83-afff-6ad2ecb638a8	anonymousUser	2023-07-13 18:00:28.454872	t	anonymousUser	2023-07-13 18:00:28.454872	0		ORDER_INITIALIZED	CREDIT_CHECKING	CREDIT_CHECKING_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1601
ba4341e4-40db-4628-bd8b-4af8d079ccd4	anonymousUser	2023-07-13 18:00:29.539638	t	anonymousUser	2023-07-13 18:00:29.539638	0		CREDIT_CHECKING	CREDIT_APPROVED	CREDIT_APPROVED_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1602
94420e1c-63ec-418f-9d93-6e0fe20b714c	anonymousUser	2023-07-13 18:00:30.598671	t	anonymousUser	2023-07-13 18:00:30.598671	0		CREDIT_APPROVED	PAYMENT_PROCESSING	PAYMENT_INIT_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1603
37d17669-8bf6-4bfd-acef-ac28bb5d8749	anonymousUser	2023-07-13 18:00:31.657143	t	anonymousUser	2023-07-13 18:00:31.657143	0		PAYMENT_PROCESSING	PAYMENT_CONFIRMED	PAYMENT_APPROVED_EVENT	e5a5bb0d-6282-4072-9926-a0653095fd07	1604
\.


--
-- Data for Name: order_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.order_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, currency, customer_id, city, country, landmark, phone, state, street, zip_code, totalordervalue, payment_id, orderstatus, result) FROM stdin;
7a8bc3d8-911f-4aee-bc71-5dfa25a4a3ae	anonymousUser	2023-07-07 12:44:27.546798	t	anonymousUser	2023-07-11 11:43:12.021425	40	INR	123	Edison	USA	Near Walmart	7321002010	NJ	321 Cobblestone Lane	08110	85000.00	999bda45-b1ad-4af3-a2fa-4564cca52ed6	ORDER_INITIALIZED	IN_PROGRESS
e5a5bb0d-6282-4072-9926-a0653095fd07	anonymousUser	2023-07-05 11:24:30.537602	t	anonymousUser	2023-07-13 18:00:35.97734	1614	INR	123	Edison	USA	Near Walmart	7321002010	NJ	321 Cobblestone Lan	08110	170000.00	63fd3531-ee6b-40d8-aed0-2faeebc41c87	ORDER_COMPLETED	DELIVERED
\.


--
-- Data for Name: products_m; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.products_m (uuid, createdby, createdtime, updatedby, updatedtime, isactive, version, productdetails, productlocationzipcode, productname, price) FROM stdin;
22273a09-ee9e-4e5a-98fa-6bcfcfa97b49	john.doe	2023-05-28 20:26:12.919	john.doe	2023-05-28 20:26:12.919	t	0	iPhone 10, 64 GB	12345	iPhone 10	60000.00
7b54e398-711a-4820-a32c-81c7dfab1ab1	john.doe	2023-05-28 20:26:12.925	john.doe	2023-05-28 20:26:12.925	t	0	iPhone 11, 128 GB	12345	iPhone 11	70000.00
14879f35-9b10-4b75-8641-280731161aee	john.doe	2023-05-28 20:26:12.925	john.doe	2023-05-28 20:26:12.925	t	0	Samsung Galaxy s20, 256 GB	12345	Samsung Galaxy s20	80000.00
2b4d83d6-0063-429e-9d27-94aacb6abba6	john.doe	2023-05-28 20:31:14.267	john.doe	2023-05-28 20:31:14.267	t	0	Google Pixel 7, 128 GB SSD, 16GB RAM	98321	Google Pixel 7	60000.00
273c4812-40cb-4939-ae22-f4ad89d7a0ec	john.doe	2023-05-28 20:32:40.006	john.doe	2023-05-28 20:32:40.006	t	0	Samsung Galaxy S22, 16GB RAM, 128 GB SDD	46123	Samsung Galaxy S22	65000.00
eef67186-ff2a-42b9-809e-93536d0c1076	john.doe	2023-05-28 23:11:41.662	john.doe	2023-05-28 23:11:41.662	t	0	Google Pixel 6, 8GB RAM, 64GB SSD	12345	Google Pixel 6	50000.00
1a9d1e4e-525b-4dc4-b8ad-9a354a7b3418	john.doe	2023-06-25 19:21:01.598	john.doe	2023-06-25 19:21:01.598	t	0	Google Pixel 5 32 GB	12345	Google Pixel 5	35000.00
434ca819-4d11-4965-a88a-c087681414a8	john.doe	2023-06-25 22:26:09.847	john.doe	2023-06-25 22:26:09.847	t	0	Google Pixel 5 32 GB	12345	Google Pixel 5	35000.00
6c4bd74b-fb0a-4988-b83d-531744e4f8bf	john.doe	2023-06-25 22:26:21.592	john.doe	2023-06-25 22:26:21.592	t	0	Google Pixel 5 64 GB	12345	Google Pixel 5	40000.00
fd3288ef-2d49-4ea1-9a58-bb2f280fc2bd	john.doe	2023-06-25 22:44:10.901	john.doe	2023-06-25 22:44:10.901	t	0	Google Pixel 5 128 GB	12345	Google Pixel 5	50000.00
75383383-8ed7-4c28-a79c-7ca1cd6713e8	john.doe	2023-06-25 23:05:11.667	john.doe	2023-06-25 23:05:11.667	t	0	iPhone 10, 128GB BLACK	12345	iPhone 10	65000.00
adff3e12-d019-49fe-bfd1-f8634ccec604	john.doe	2023-06-25 23:05:57.463	john.doe	2023-06-25 23:05:57.463	t	0	iPhone 10, 128GB WHITE	12345	iPhone 10	65000.00
8b1458b1-5aa9-437f-a3de-ea8050ba0e05	john.doe	2023-06-25 23:06:09.566	john.doe	2023-06-25 23:06:09.566	t	0	iPhone 10, 128GB GOLD	12345	iPhone 10	65000.00
d5e3fa1d-86c7-4bf5-985b-af865bea9c07	john.doe	2023-06-25 23:07:23.325	john.doe	2023-06-25 23:07:23.325	t	0	iPhone 11, 256GB BLACK	12345	iPhone 11	75000.00
b7277469-cb79-4746-abae-e595b32a3666	john.doe	2023-06-25 23:07:38.454	john.doe	2023-06-25 23:07:38.454	t	0	iPhone 11, 512GB BLACK	12345	iPhone 11	85000.00
f2cc6216-9d04-4f3f-882f-4f1567a1a449	john.doe	2023-06-25 23:09:04.734	john.doe	2023-06-25 23:09:04.734	t	0	iPhone 12, 512GB BLACK	12345	iPhone 12	95000.00
3907ec91-f9f4-4e35-851c-ff56573fdaa3	john.doe	2024-10-02 07:36:02.584	john.doe	2024-10-02 07:36:02.584	t	0	iPhone 16 Pro, 512GB BLUE, Apple Intelligence	63468	iPhone 16	155000.00
761fe8ea-40dd-408b-8a8d-21efdaf70b87	john.doe	2024-12-18 17:37:38.789	john.doe	2024-12-18 17:37:38.789	t	0	iPhone 17, 2TB, 512GB RAM	12345	iPhone 17	200000.00
ecb6bdfd-0fcb-4601-a8d1-a1677b224248	john.doe	2024-12-18 17:39:54.731	john.doe	2024-12-18 17:39:54.731	t	0	iPhone 17, 1TB, 512GB RAM	12345	iPhone 17	170000.00
\.


--
-- Data for Name: reservation_flight_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.reservation_flight_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, airlines, flightid, flightreservationno, fromcity, journeydate, pnr, rate, reservationstatus, statusreasons, tocity, reservation_id, gender, passengername) FROM stdin;
067514b4-20a6-4a66-bf88-54ea05afa02d	anonymousUser	2023-07-12 23:17:41.92806	t	anonymousUser	2023-07-12 23:17:41.92806	0	Delta	KOC-BAN	string	KOC	2023-07-31	pnr65321	5000	RESERVATION_REQUEST_RECEIVED	string	BAN	b9176b11-d924-495e-a459-3b17687d773e	F	Jane Doe
85697f23-3b3f-461b-aea9-f31c06907917	anonymousUser	2023-07-12 23:17:41.927086	t	anonymousUser	2023-07-12 23:17:41.927086	0	Delta	BAN-KOC	string	BAN	2023-07-28	pnr12356	5000	RESERVATION_REQUEST_RECEIVED	string	KOC	b9176b11-d924-495e-a459-3b17687d773e	F	Jane Doe
f64a1d45-8ec9-4022-8fc4-2180de771ead	anonymousUser	2023-07-12 23:17:41.927086	t	anonymousUser	2023-07-12 23:17:41.927086	0	Delta	BAN-KOC	string	BAN	2023-07-28	pnr12356	5000	RESERVATION_REQUEST_RECEIVED	string	KOC	b9176b11-d924-495e-a459-3b17687d773e	M	John Doe
fb948edc-a0ec-4d46-a437-3322d08f3752	anonymousUser	2023-07-12 23:17:41.92806	t	anonymousUser	2023-07-12 23:17:41.92806	0	Delta	KOC-BAN	string	KOC	2023-07-31	pnr65321	5000	RESERVATION_REQUEST_RECEIVED	string	BAN	b9176b11-d924-495e-a459-3b17687d773e	M	John Doe
dfba3728-f6fa-4e43-a604-446989a27473	anonymousUser	2023-07-17 14:13:10.257117	t	anonymousUser	2023-07-17 14:13:10.257117	0	Vistara	KOC-HYD-123		KOC	2023-07-28	pnr65322	5000	RESERVATION_REQUEST_RECEIVED	string	HYD	7be6cf96-70bd-4384-98d3-3a8bd5708501	F	Jane Doe
be9ae8a1-8694-4f99-88fc-c1eef7994a57	anonymousUser	2023-07-17 14:13:10.257402	t	anonymousUser	2023-07-17 14:13:10.257402	0	Vistara	HYD-KOC-321		HYD	2023-07-31	pnr65322	5000	RESERVATION_REQUEST_RECEIVED	string	KOC	7be6cf96-70bd-4384-98d3-3a8bd5708501	F	Jane Doe
\.


--
-- Data for Name: reservation_hotel_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.reservation_hotel_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, days, enddate, hotelid, hotelname, hotelreservationno, persons, rate, reservationstatus, startdate, reservation_id) FROM stdin;
759d0604-c0cf-4e68-8d3d-e1db250c15d8	anonymousUser	2023-07-12 23:17:41.932012	t	anonymousUser	2023-07-12 23:17:41.932012	0	3	2023-07-31	taj-kochi	Hotel Taj Palace, KOCHI, Kerala	123456	2	21500	RESERVATION_REQUEST_RECEIVED	2023-07-28	b9176b11-d924-495e-a459-3b17687d773e
4f5fa6b3-2f4b-4018-829b-a634015cc05d	anonymousUser	2023-07-17 13:20:57.238046	t	anonymousUser	2023-07-17 13:20:57.238046	0	2	2023-07-31	Holiday-Inn-kochi	Hotel Holiday-Inn, KOCHI, Kerala	123457	1	15000	RESERVATION_REQUEST_RECEIVED	2023-07-28	3d256890-52bb-4b5f-afa5-c978fa6cabfd
\.


--
-- Data for Name: reservation_payment_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.reservation_payment_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, status, transaction_id) FROM stdin;
ab4c885f-24cf-4f1d-8854-0e4a905f46e1	anonymousUser	2023-07-12 23:17:41.917495	t	anonymousUser	2023-07-12 23:17:41.917495	0	string	string
1385e871-256f-43ae-ad6c-a903bfd1ace7	anonymousUser	2023-07-17 12:59:54.080742	t	anonymousUser	2023-07-17 12:59:54.080742	0	string	string
916d5ae4-f786-431b-92e2-266379fe613c	anonymousUser	2023-07-17 13:20:57.223166	t	anonymousUser	2023-07-17 13:20:57.223166	0	string	string
9c16eb4a-f9f7-429c-9a13-3b65c1fb799c	anonymousUser	2023-07-17 14:13:10.244575	t	anonymousUser	2023-07-17 14:13:10.244575	0	string	string
7ee53b4f-df5c-4e85-bc0e-550e47b69b86	anonymousUser	2023-07-17 16:47:43.634659	t	anonymousUser	2023-07-17 16:47:43.634659	0	string	string
\.


--
-- Data for Name: reservation_rental_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.reservation_rental_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, days, enddate, rate, rentalid, rentalname, rentalreservationno, rentaltype, rentalvehiclelicense, reservationstatus, startdate, statusreasons, reservation_id, primarydriver) FROM stdin;
81cf8f66-69ab-4b49-8dcc-8f6739e4b13b	anonymousUser	2023-07-12 23:17:41.93635	t	anonymousUser	2023-07-12 23:17:41.93635	0	3	2023-07-31	15000	scorpio-2023	Top Cars Rental - Scorpio	9876543	SUV	KL-05-Y-2023	RESERVATION_REQUEST_RECEIVED	2023-07-28		b9176b11-d924-495e-a459-3b17687d773e	Jane Doe
b7557130-b45f-489b-a1da-0e7f23ee35f8	anonymousUser	2023-07-17 16:47:43.639294	t	anonymousUser	2023-07-17 16:47:43.639294	0	5	2023-07-30	17000	XUV-700-2023	Top Cars Rental - XUV 700	7879543	SUV	KL-05-Y-2022	RESERVATION_REQUEST_RECEIVED	2023-07-25		a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7	Ann Doe
\.


--
-- Data for Name: reservation_state_history_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.reservation_state_history_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, aggregateversionno, notes, sourcestate, targetstate, transitionevent, reservation_id) FROM stdin;
f8653e93-6fef-4f72-99be-6d93c283260c	anonymousUser	2023-07-18 12:29:00.12061	t	anonymousUser	2023-07-18 12:29:00.12061	0	275		RESERVATION_INITIALIZED	IN_PROGRESS	RESERVATION_INIT_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
2949c532-b840-48c9-b89d-642e6af19db5	anonymousUser	2023-07-18 12:29:00.165012	t	anonymousUser	2023-07-18 12:29:00.165012	0	277		IN_PROGRESS	HOTEL_BOOKING_REQUEST	HOTEL_BOOKING_REQUEST_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
5b502cf9-7493-46b7-9f62-c85e6929dd23	anonymousUser	2023-07-18 12:29:00.19796	t	anonymousUser	2023-07-18 12:29:00.19796	0	278		HOTEL_BOOKING_REQUEST	HOTEL_BOOKING_CONFIRMED	HOTEL_BOOKING_CONFIRMED_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
03c14b3e-cbbf-4b57-8e26-3efd3c097471	anonymousUser	2023-07-18 12:29:00.23182	t	anonymousUser	2023-07-18 12:29:00.23182	0	279		HOTEL_BOOKING_CONFIRMED	IN_PROGRESS	HOTEL_BOOKING_COMPLETED_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
48634472-f0c1-4bc7-adb9-85ad447d0c07	anonymousUser	2023-07-18 12:29:00.266222	t	anonymousUser	2023-07-18 12:29:00.266222	0	280		IN_PROGRESS	PAYMENT_REQUEST_INIT	PAYMENT_REQUEST_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
51b0e1f4-a7f3-42b9-8c12-32e3388d2769	anonymousUser	2023-07-18 12:29:00.295794	t	anonymousUser	2023-07-18 12:29:00.295794	0	281		PAYMENT_REQUEST_INIT	PAYMENT_DECLINED	PAYMENT_DECLINED_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
d35ed373-35c0-46b6-8e7c-8fc8894b94c4	anonymousUser	2023-07-18 12:29:00.328715	t	anonymousUser	2023-07-18 12:29:00.328715	0	282		PAYMENT_DECLINED	TRIP_CANCELLED	TRIP_CANCELLED_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
bc126237-a9d3-4a42-98f9-74c47a1e1c14	anonymousUser	2023-07-18 12:29:00.333812	t	anonymousUser	2023-07-18 12:29:00.333812	0	283		TRIP_CANCELLED	ROLLBACK_IN_PROGRESS	START_ROLLBACK_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
b79868d8-a834-4cd5-843f-d4038c17ed89	anonymousUser	2023-07-18 12:29:00.339508	t	anonymousUser	2023-07-18 12:29:00.339508	0	284		ROLLBACK_IN_PROGRESS	HOTEL_BOOKING_ROLLBACK	HOTEL_ROLLBACK_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
a112ad3d-ecfd-4a4f-9f3c-8573d44dbe22	anonymousUser	2023-07-18 12:29:00.343053	t	anonymousUser	2023-07-18 12:29:00.343053	0	285		HOTEL_BOOKING_ROLLBACK	ROLLBACK	ROLLBACK_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
7ef6d061-28da-420f-992e-45b842932845	anonymousUser	2023-07-18 12:29:00.346431	t	anonymousUser	2023-07-18 12:29:00.346431	0	286		ROLLBACK	RESERVATION_TERMINATED	AUTO_TRANSITION_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
39206c76-6b87-4531-85fd-c0c6356e7aba	anonymousUser	2023-07-18 12:29:00.088734	t	anonymousUser	2023-07-18 12:29:00.088734	0	274		RESERVATION_REQUEST_RECEIVED	RESERVATION_INITIALIZED	RESERVATION_VALIDATION_EVENT	3d256890-52bb-4b5f-afa5-c978fa6cabfd
7e9b4314-793a-42e8-9bf0-d72517801e36	anonymousUser	2023-07-18 12:29:36.628521	t	anonymousUser	2023-07-18 12:29:36.628521	0	241		RESERVATION_REQUEST_RECEIVED	RESERVATION_INITIALIZED	RESERVATION_VALIDATION_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
a64cf1ef-2584-47b4-abc0-2016c54cdeb5	anonymousUser	2023-07-18 12:29:36.667822	t	anonymousUser	2023-07-18 12:29:36.667822	0	242		RESERVATION_INITIALIZED	IN_PROGRESS	RESERVATION_INIT_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
b1f9bea5-f056-405d-96ce-dbc59b167b37	anonymousUser	2023-07-18 12:29:36.710601	t	anonymousUser	2023-07-18 12:29:36.710601	0	244		IN_PROGRESS	FLIGHT_BOOKING_REQUEST	FLIGHT_BOOKING_REQUEST_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
f2d43579-44b8-416d-b508-44949b33088a	anonymousUser	2023-07-18 12:29:36.760582	t	anonymousUser	2023-07-18 12:29:36.760582	0	245		FLIGHT_BOOKING_REQUEST	FLIGHT_BOOKING_CONFIRMED	FLIGHT_BOOKING_CONFIRMED_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
6e684267-00c4-4fb1-aef3-978af4302095	anonymousUser	2023-07-18 12:29:36.793519	t	anonymousUser	2023-07-18 12:29:36.793519	0	246		FLIGHT_BOOKING_CONFIRMED	IN_PROGRESS	FLIGHT_BOOKING_COMPLETED_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
7e32c8b5-0e36-4688-929e-c64a70e4905c	anonymousUser	2023-07-18 12:29:36.825646	t	anonymousUser	2023-07-18 12:29:36.825646	0	247		IN_PROGRESS	PAYMENT_REQUEST_INIT	PAYMENT_REQUEST_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
4c07bac1-5ffb-431a-b814-d2642e986e6e	anonymousUser	2023-07-18 12:29:36.855575	t	anonymousUser	2023-07-18 12:29:36.855575	0	248		PAYMENT_REQUEST_INIT	PAYMENT_DECLINED	PAYMENT_DECLINED_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
b30ef92a-7375-40d2-8d56-deefb8394e38	anonymousUser	2023-07-18 12:29:36.888076	t	anonymousUser	2023-07-18 12:29:36.888076	0	249		PAYMENT_DECLINED	TRIP_CANCELLED	TRIP_CANCELLED_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
fa809ec7-51b3-493b-8e6a-76ca652f0b55	anonymousUser	2023-07-18 12:29:36.892701	t	anonymousUser	2023-07-18 12:29:36.892701	0	250		TRIP_CANCELLED	ROLLBACK_IN_PROGRESS	START_ROLLBACK_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
d19e57b8-43b1-4645-8cd8-af827449b9d6	anonymousUser	2023-07-18 12:29:36.897575	t	anonymousUser	2023-07-18 12:29:36.897575	0	251		ROLLBACK_IN_PROGRESS	FLIGHT_BOOKING_ROLLBACK	FLIGHT_ROLLBACK_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
df7943d4-6bc6-487c-b12b-310ff7c0a821	anonymousUser	2023-07-18 12:29:36.90185	t	anonymousUser	2023-07-18 12:29:36.90185	0	252		FLIGHT_BOOKING_ROLLBACK	ROLLBACK	ROLLBACK_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
12a95225-4a09-43d1-92bf-315d889b3c0a	anonymousUser	2023-07-18 12:29:36.905463	t	anonymousUser	2023-07-18 12:29:36.905463	0	253		ROLLBACK	RESERVATION_TERMINATED	AUTO_TRANSITION_EVENT	7be6cf96-70bd-4384-98d3-3a8bd5708501
6378cde0-167e-4dfe-84b4-6a84d85c13aa	anonymousUser	2023-07-18 12:28:18.111079	t	anonymousUser	2023-07-18 12:28:18.111079	0	8818		RENTAL_BOOKING_REQUEST	RENTAL_BOOKING_CONFIRMED	RENTAL_BOOKING_CONFIRMED_EVENT	b9176b11-d924-495e-a459-3b17687d773e
64c3077d-807f-48d0-ac40-8fdd153ca6d7	anonymousUser	2023-07-18 12:28:18.161323	t	anonymousUser	2023-07-18 12:28:18.161323	0	8819		RENTAL_BOOKING_CONFIRMED	IN_PROGRESS	RENTAL_BOOKING_COMPLETED_EVENT	b9176b11-d924-495e-a459-3b17687d773e
ffd82952-92b2-4374-917e-4eedd126becf	anonymousUser	2023-07-18 12:30:06.663721	t	anonymousUser	2023-07-18 12:30:06.663721	0	311		RESERVATION_REQUEST_RECEIVED	RESERVATION_INITIALIZED	RESERVATION_VALIDATION_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
5c9f3944-c758-4a3e-b273-c2bef38a09e2	anonymousUser	2023-07-18 12:28:18.207308	t	anonymousUser	2023-07-18 12:28:18.207308	0	8821		IN_PROGRESS	FLIGHT_BOOKING_REQUEST	FLIGHT_BOOKING_REQUEST_EVENT	b9176b11-d924-495e-a459-3b17687d773e
2e215890-2c9e-4a74-9ebb-df04c9c024eb	anonymousUser	2023-07-18 12:30:06.69645	t	anonymousUser	2023-07-18 12:30:06.69645	0	312		RESERVATION_INITIALIZED	IN_PROGRESS	RESERVATION_INIT_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
f751bf51-0e5b-48c4-8b2f-4c169108cea0	anonymousUser	2023-07-18 12:28:18.24543	t	anonymousUser	2023-07-18 12:28:18.24543	0	8822		FLIGHT_BOOKING_REQUEST	FLIGHT_BOOKING_CONFIRMED	FLIGHT_BOOKING_CONFIRMED_EVENT	b9176b11-d924-495e-a459-3b17687d773e
85cbc423-ab68-42e9-ba6d-c30216bacd88	anonymousUser	2023-07-18 12:30:06.742328	t	anonymousUser	2023-07-18 12:30:06.742328	0	314		IN_PROGRESS	RENTAL_BOOKING_REQUEST	RENTAL_BOOKING_REQUEST_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
494ac320-1ca2-4944-b7fe-fce750a2a206	anonymousUser	2023-07-18 12:28:18.281623	t	anonymousUser	2023-07-18 12:28:18.281623	0	8823		FLIGHT_BOOKING_CONFIRMED	IN_PROGRESS	FLIGHT_BOOKING_COMPLETED_EVENT	b9176b11-d924-495e-a459-3b17687d773e
e9882a90-be41-43c6-8259-7ffb1b5112cf	anonymousUser	2023-07-18 12:30:06.788352	t	anonymousUser	2023-07-18 12:30:06.788352	0	315		RENTAL_BOOKING_REQUEST	RENTAL_BOOKING_CONFIRMED	RENTAL_BOOKING_CONFIRMED_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
d66c7d65-ac7e-4db2-b5be-219379a53fb2	anonymousUser	2023-07-18 12:28:18.31804	t	anonymousUser	2023-07-18 12:28:18.31804	0	8824		IN_PROGRESS	PAYMENT_REQUEST_INIT	PAYMENT_REQUEST_EVENT	b9176b11-d924-495e-a459-3b17687d773e
77b3ceec-f9f2-4503-8bb6-ee9ca4ce6d56	anonymousUser	2023-07-18 12:30:06.819609	t	anonymousUser	2023-07-18 12:30:06.819609	0	316		RENTAL_BOOKING_CONFIRMED	IN_PROGRESS	RENTAL_BOOKING_COMPLETED_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
591fa512-27cf-43ea-9abe-7c9507c7e31c	anonymousUser	2023-07-18 12:30:06.853165	t	anonymousUser	2023-07-18 12:30:06.853165	0	317		IN_PROGRESS	PAYMENT_REQUEST_INIT	PAYMENT_REQUEST_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
22c10b58-c6ae-4e56-b5ae-491a7b0c2bb5	anonymousUser	2023-07-18 12:30:06.88419	t	anonymousUser	2023-07-18 12:30:06.88419	0	318		PAYMENT_REQUEST_INIT	PAYMENT_DECLINED	PAYMENT_DECLINED_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
2b12edaf-1f54-4a15-8625-0364a7f40717	anonymousUser	2023-07-18 12:30:06.91678	t	anonymousUser	2023-07-18 12:30:06.91678	0	319		PAYMENT_DECLINED	TRIP_CANCELLED	TRIP_CANCELLED_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
c777e112-a10e-4356-a109-35147ca2bbaa	anonymousUser	2023-07-18 12:28:17.848777	t	anonymousUser	2023-07-18 12:28:17.848777	0	8810		RESERVATION_REQUEST_RECEIVED	RESERVATION_INITIALIZED	RESERVATION_VALIDATION_EVENT	b9176b11-d924-495e-a459-3b17687d773e
5a85bc50-dcdb-4654-aff4-c9b75656a886	anonymousUser	2023-07-18 12:28:17.884376	t	anonymousUser	2023-07-18 12:28:17.884376	0	8811		RESERVATION_INITIALIZED	IN_PROGRESS	RESERVATION_INIT_EVENT	b9176b11-d924-495e-a459-3b17687d773e
fc22a94a-f0c1-4d0e-8e24-584f9fce09ac	anonymousUser	2023-07-18 12:28:17.960786	t	anonymousUser	2023-07-18 12:28:17.960786	0	8813		IN_PROGRESS	HOTEL_BOOKING_REQUEST	HOTEL_BOOKING_REQUEST_EVENT	b9176b11-d924-495e-a459-3b17687d773e
d14f1e42-0b27-4d98-a380-d2aced69726d	anonymousUser	2023-07-18 12:28:17.995743	t	anonymousUser	2023-07-18 12:28:17.995743	0	8814		HOTEL_BOOKING_REQUEST	HOTEL_BOOKING_CONFIRMED	HOTEL_BOOKING_CONFIRMED_EVENT	b9176b11-d924-495e-a459-3b17687d773e
0dfe8d87-7e30-4a39-b159-8e4bb3d92847	anonymousUser	2023-07-18 12:28:18.032927	t	anonymousUser	2023-07-18 12:28:18.032927	0	8815		HOTEL_BOOKING_CONFIRMED	IN_PROGRESS	HOTEL_BOOKING_COMPLETED_EVENT	b9176b11-d924-495e-a459-3b17687d773e
d1d35d19-c83b-4e55-b4ee-229bb15835ed	anonymousUser	2023-07-18 12:28:18.078301	t	anonymousUser	2023-07-18 12:28:18.078301	0	8817		IN_PROGRESS	RENTAL_BOOKING_REQUEST	RENTAL_BOOKING_REQUEST_EVENT	b9176b11-d924-495e-a459-3b17687d773e
f7545d0b-d828-48f1-ab1e-a3cea7759e1c	anonymousUser	2023-07-18 12:28:18.352999	t	anonymousUser	2023-07-18 12:28:18.352999	0	8825		PAYMENT_REQUEST_INIT	PAYMENT_DECLINED	PAYMENT_DECLINED_EVENT	b9176b11-d924-495e-a459-3b17687d773e
f5c82214-49a1-40b2-a77a-0ae978870486	anonymousUser	2023-07-18 12:28:18.385766	t	anonymousUser	2023-07-18 12:28:18.385766	0	8826		PAYMENT_DECLINED	TRIP_CANCELLED	TRIP_CANCELLED_EVENT	b9176b11-d924-495e-a459-3b17687d773e
91038c5d-d283-4375-9802-380ff9196a69	anonymousUser	2023-07-18 12:28:18.391093	t	anonymousUser	2023-07-18 12:28:18.391093	0	8827		TRIP_CANCELLED	ROLLBACK_IN_PROGRESS	START_ROLLBACK_EVENT	b9176b11-d924-495e-a459-3b17687d773e
573d91bd-5f6d-40a2-8ec8-bc01ce385bec	anonymousUser	2023-07-18 12:28:18.399315	t	anonymousUser	2023-07-18 12:28:18.399315	0	8828		ROLLBACK_IN_PROGRESS	FLIGHT_BOOKING_ROLLBACK	FLIGHT_ROLLBACK_EVENT	b9176b11-d924-495e-a459-3b17687d773e
6bf5c21e-6e99-4f9d-82a7-02f6ed2349fe	anonymousUser	2023-07-18 12:28:18.405235	t	anonymousUser	2023-07-18 12:28:18.405235	0	8829		ROLLBACK_IN_PROGRESS	RENTAL_BOOKING_ROLLBACK	RENTAL_ROLLBACK_EVENT	b9176b11-d924-495e-a459-3b17687d773e
f189890c-2ed5-40ae-a67a-9a5062429a51	anonymousUser	2023-07-18 12:28:18.408624	t	anonymousUser	2023-07-18 12:28:18.408624	0	8830		ROLLBACK_IN_PROGRESS	HOTEL_BOOKING_ROLLBACK	HOTEL_ROLLBACK_EVENT	b9176b11-d924-495e-a459-3b17687d773e
a7405784-aabe-4e22-ab5c-967f10c38124	anonymousUser	2023-07-18 12:28:18.413834	t	anonymousUser	2023-07-18 12:28:18.413834	0	8831		FLIGHT_BOOKING_ROLLBACK	ROLLBACK	ROLLBACK_EVENT	b9176b11-d924-495e-a459-3b17687d773e
b859cc93-767c-45cd-aa9d-259100116630	anonymousUser	2023-07-18 12:28:18.41796	t	anonymousUser	2023-07-18 12:28:18.41796	0	8832		ROLLBACK	RESERVATION_TERMINATED	AUTO_TRANSITION_EVENT	b9176b11-d924-495e-a459-3b17687d773e
dc036f2d-f5b1-4e25-92f8-5c1cbddfae06	anonymousUser	2023-07-18 12:30:06.920666	t	anonymousUser	2023-07-18 12:30:06.920666	0	320		TRIP_CANCELLED	ROLLBACK_IN_PROGRESS	START_ROLLBACK_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
13118ff2-af53-479a-8685-7dff00b0e558	anonymousUser	2023-07-18 12:30:06.926025	t	anonymousUser	2023-07-18 12:30:06.926025	0	321		ROLLBACK_IN_PROGRESS	RENTAL_BOOKING_ROLLBACK	RENTAL_ROLLBACK_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
50e01a4b-3985-4efa-8e66-0e9b4d78ef86	anonymousUser	2023-07-18 12:30:06.92971	t	anonymousUser	2023-07-18 12:30:06.92971	0	322		RENTAL_BOOKING_ROLLBACK	ROLLBACK	ROLLBACK_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
be4180d1-d1b2-4c44-a765-476c2ccd80fa	anonymousUser	2023-07-18 12:30:06.933362	t	anonymousUser	2023-07-18 12:30:06.933362	0	323		ROLLBACK	RESERVATION_TERMINATED	AUTO_TRANSITION_EVENT	a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7
\.


--
-- Data for Name: reservation_tx; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.reservation_tx (uuid, createdby, createdtime, isactive, updatedby, updatedtime, version, currency, city, country, landmark, phone, state, street, zip_code, customer_id, reservationstatus, result, totalvalue, payment_id, rollbackonfailure) FROM stdin;
3d256890-52bb-4b5f-afa5-c978fa6cabfd	anonymousUser	2023-07-17 13:20:57.232586	t	anonymousUser	2023-07-18 12:29:00.347048	286	INR	West Hartford	USA		732-236-0001	CT	5 Edgebrook Drive	08311	234	RESERVATION_TERMINATED	ROLLBACK	30000	916d5ae4-f786-431b-92e2-266379fe613c	f
7be6cf96-70bd-4384-98d3-3a8bd5708501	anonymousUser	2023-07-17 14:13:10.245199	t	anonymousUser	2023-07-18 12:29:36.905921	253	INR	West Hartford	USA		732-627-0003	CT	5 Edgebrook Dr	082201	345	RESERVATION_TERMINATED	ROLLBACK	10000	9c16eb4a-f9f7-429c-9a13-3b65c1fb799c	f
a74d7ab4-d7d1-4c8a-aa69-2de50d4127e7	anonymousUser	2023-07-17 16:47:43.629823	t	anonymousUser	2023-07-18 12:30:06.933831	323	INR	East Hartford	USA		732-627-0005	CT	13 Edgebrook Dr	082321	456	RESERVATION_TERMINATED	ROLLBACK	85000	7ee53b4f-df5c-4e85-bc0e-550e47b69b86	f
b9176b11-d924-495e-a459-3b17687d773e	anonymousUser	2023-07-12 23:17:41.921865	t	anonymousUser	2023-07-18 12:28:18.418688	8832	INR	Edison	USA	Walmart	732-236-0000	NJ	321 Cobblestone Ln	08211	123	RESERVATION_TERMINATED	ROLLBACK	119500	ab4c885f-24cf-4f1d-8854-0e4a905f46e1	f
\.


--
-- Data for Name: saga_entry; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.saga_entry (saga_id, revision, saga_type, serialized_saga) FROM stdin;
\.


--
-- Data for Name: snapshot_event_entry; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.snapshot_event_entry (sequence_number, aggregate_identifier, type, event_identifier, time_stamp, payload_type, payload_revision, payload, meta_data) FROM stdin;
\.


--
-- Data for Name: token_entry; Type: TABLE DATA; Schema: ms_schema; Owner: msadm
--

COPY ms_schema.token_entry (processor_name, segment, token, token_type, "timestamp", owner) FROM stdin;
\.


--
-- Name: association_value_entry_id_seq; Type: SEQUENCE SET; Schema: ms_schema; Owner: msadm
--

SELECT pg_catalog.setval('ms_schema.association_value_entry_id_seq', 1, false);


--
-- Name: cart_es_view_items_tx_id_seq; Type: SEQUENCE SET; Schema: ms_schema; Owner: msadm
--

SELECT pg_catalog.setval('ms_schema.cart_es_view_items_tx_id_seq', 1, false);


--
-- Name: domain_event_entry_global_index_seq; Type: SEQUENCE SET; Schema: ms_schema; Owner: msadm
--

SELECT pg_catalog.setval('ms_schema.domain_event_entry_global_index_seq', 1, false);


--
-- Name: association_value_entry association_value_entry_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.association_value_entry
    ADD CONSTRAINT association_value_entry_pkey PRIMARY KEY (id);


--
-- Name: cart_es_view_items_tx cart_es_view_items_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.cart_es_view_items_tx
    ADD CONSTRAINT cart_es_view_items_tx_pkey PRIMARY KEY (id);


--
-- Name: cart_es_view_tx cart_es_view_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.cart_es_view_tx
    ADD CONSTRAINT cart_es_view_tx_pkey PRIMARY KEY (cart_id);


--
-- Name: carts_tx carts_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.carts_tx
    ADD CONSTRAINT carts_tx_pkey PRIMARY KEY (uuid);


--
-- Name: country_geolite_m country_geolite_m_pk; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.country_geolite_m
    ADD CONSTRAINT country_geolite_m_pk PRIMARY KEY (geoname_id);


--
-- Name: country_m country_m_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.country_m
    ADD CONSTRAINT country_m_pkey PRIMARY KEY (countryuuid);


--
-- Name: country_t country_t_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.country_t
    ADD CONSTRAINT country_t_pkey PRIMARY KEY (cid);


--
-- Name: domain_event_entry domain_event_entry_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.domain_event_entry
    ADD CONSTRAINT domain_event_entry_pkey PRIMARY KEY (global_index);


--
-- Name: order_item_tx order_item_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.order_item_tx
    ADD CONSTRAINT order_item_tx_pkey PRIMARY KEY (uuid);


--
-- Name: order_state_history_tx order_state_history_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.order_state_history_tx
    ADD CONSTRAINT order_state_history_tx_pkey PRIMARY KEY (uuid);


--
-- Name: order_tx order_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.order_tx
    ADD CONSTRAINT order_tx_pkey PRIMARY KEY (uuid);


--
-- Name: order_payment_tx payment_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.order_payment_tx
    ADD CONSTRAINT payment_tx_pkey PRIMARY KEY (uuid);


--
-- Name: products_m products_m_pkey1; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.products_m
    ADD CONSTRAINT products_m_pkey1 PRIMARY KEY (uuid);


--
-- Name: reservation_flight_tx reservation_flight_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_flight_tx
    ADD CONSTRAINT reservation_flight_tx_pkey PRIMARY KEY (uuid);


--
-- Name: reservation_hotel_tx reservation_hotel_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_hotel_tx
    ADD CONSTRAINT reservation_hotel_tx_pkey PRIMARY KEY (uuid);


--
-- Name: reservation_payment_tx reservation_payment_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_payment_tx
    ADD CONSTRAINT reservation_payment_tx_pkey PRIMARY KEY (uuid);


--
-- Name: reservation_rental_tx reservation_rental_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_rental_tx
    ADD CONSTRAINT reservation_rental_tx_pkey PRIMARY KEY (uuid);


--
-- Name: reservation_state_history_tx reservation_state_history_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_state_history_tx
    ADD CONSTRAINT reservation_state_history_tx_pkey PRIMARY KEY (uuid);


--
-- Name: reservation_tx reservation_tx_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_tx
    ADD CONSTRAINT reservation_tx_pkey PRIMARY KEY (uuid);


--
-- Name: saga_entry saga_entry_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.saga_entry
    ADD CONSTRAINT saga_entry_pkey PRIMARY KEY (saga_id);


--
-- Name: snapshot_event_entry snapshot_event_entry_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.snapshot_event_entry
    ADD CONSTRAINT snapshot_event_entry_pkey PRIMARY KEY (aggregate_identifier, sequence_number);


--
-- Name: token_entry token_entry_pkey; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.token_entry
    ADD CONSTRAINT token_entry_pkey PRIMARY KEY (processor_name, segment);


--
-- Name: cart_es_view_items_tx uk_cart_item; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.cart_es_view_items_tx
    ADD CONSTRAINT uk_cart_item UNIQUE (cart_id, product_id);


--
-- Name: domain_event_entry uq_aggregate_seq; Type: CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.domain_event_entry
    ADD CONSTRAINT uq_aggregate_seq UNIQUE (aggregate_identifier, sequence_number);


--
-- Name: idx_agg_seq; Type: INDEX; Schema: ms_schema; Owner: msadm
--

CREATE INDEX idx_agg_seq ON ms_schema.domain_event_entry USING btree (aggregate_identifier, sequence_number);


--
-- Name: idx_cart_item_cartid; Type: INDEX; Schema: ms_schema; Owner: msadm
--

CREATE INDEX idx_cart_item_cartid ON ms_schema.cart_es_view_items_tx USING btree (cart_id);


--
-- Name: idx_event_identifier; Type: INDEX; Schema: ms_schema; Owner: msadm
--

CREATE INDEX idx_event_identifier ON ms_schema.domain_event_entry USING btree (event_identifier);


--
-- Name: order_tx fk17hk2k77tycbvnfa968wayqhd; Type: FK CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.order_tx
    ADD CONSTRAINT fk17hk2k77tycbvnfa968wayqhd FOREIGN KEY (payment_id) REFERENCES ms_schema.order_payment_tx(uuid);


--
-- Name: cart_es_view_items_tx fk_item_cart; Type: FK CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.cart_es_view_items_tx
    ADD CONSTRAINT fk_item_cart FOREIGN KEY (cart_id) REFERENCES public.cart_es_view_tx(cart_id) ON DELETE CASCADE;


--
-- Name: order_item_tx fkb3heb7c2x68gtl42n66w217vl; Type: FK CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.order_item_tx
    ADD CONSTRAINT fkb3heb7c2x68gtl42n66w217vl FOREIGN KEY (order_id) REFERENCES ms_schema.order_tx(uuid);


--
-- Name: order_state_history_tx fkqm01yul77rf1ekm5seeqxnaqp; Type: FK CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.order_state_history_tx
    ADD CONSTRAINT fkqm01yul77rf1ekm5seeqxnaqp FOREIGN KEY (order_id) REFERENCES ms_schema.order_tx(uuid);


--
-- Name: reservation_flight_tx reservation_flight_tx_fk; Type: FK CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_flight_tx
    ADD CONSTRAINT reservation_flight_tx_fk FOREIGN KEY (reservation_id) REFERENCES ms_schema.reservation_tx(uuid);


--
-- Name: reservation_hotel_tx reservation_hotel_tx_fk; Type: FK CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_hotel_tx
    ADD CONSTRAINT reservation_hotel_tx_fk FOREIGN KEY (reservation_id) REFERENCES ms_schema.reservation_tx(uuid);


--
-- Name: reservation_rental_tx reservation_rental_tx_fk; Type: FK CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_rental_tx
    ADD CONSTRAINT reservation_rental_tx_fk FOREIGN KEY (reservation_id) REFERENCES ms_schema.reservation_tx(uuid);


--
-- Name: reservation_state_history_tx reservation_state_history_tx_fk; Type: FK CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_state_history_tx
    ADD CONSTRAINT reservation_state_history_tx_fk FOREIGN KEY (reservation_id) REFERENCES ms_schema.reservation_tx(uuid);


--
-- Name: reservation_tx reservation_tx_fk; Type: FK CONSTRAINT; Schema: ms_schema; Owner: msadm
--

ALTER TABLE ONLY ms_schema.reservation_tx
    ADD CONSTRAINT reservation_tx_fk FOREIGN KEY (payment_id) REFERENCES ms_schema.reservation_payment_tx(uuid);


--
-- PostgreSQL database dump complete
--

