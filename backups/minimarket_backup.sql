--
-- PostgreSQL database dump
--

\restrict qzd21WtxTo9KkQeNwMR4hQXioW0DqAnBLuFC48uI60Y26Wwo7r4L2eSl4rkRSx7

-- Dumped from database version 16.15 (Debian 16.15-1.pgdg13+2)
-- Dumped by pg_dump version 16.15 (Debian 16.15-1.pgdg13+2)

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
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: MetodoPago; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."MetodoPago" AS ENUM (
    'EFECTIVO',
    'TARJETA',
    'TRANSFERENCIA'
);


ALTER TYPE public."MetodoPago" OWNER TO app;

--
-- Name: TipoMovimiento; Type: TYPE; Schema: public; Owner: app
--

CREATE TYPE public."TipoMovimiento" AS ENUM (
    'ENTRADA',
    'SALIDA',
    'AJUSTE'
);


ALTER TYPE public."TipoMovimiento" OWNER TO app;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: Categoria; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."Categoria" (
    id integer NOT NULL,
    nombre text NOT NULL,
    descripcion text,
    descuento double precision DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Categoria" OWNER TO app;

--
-- Name: Categoria_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."Categoria_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Categoria_id_seq" OWNER TO app;

--
-- Name: Categoria_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."Categoria_id_seq" OWNED BY public."Categoria".id;


--
-- Name: DetalleVenta; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."DetalleVenta" (
    id integer NOT NULL,
    "ventaId" integer NOT NULL,
    "productoId" integer NOT NULL,
    cantidad integer NOT NULL,
    "precioUnit" double precision NOT NULL,
    descuento double precision DEFAULT 0 NOT NULL,
    subtotal double precision NOT NULL,
    "stockInsuficiente" boolean DEFAULT false NOT NULL
);


ALTER TABLE public."DetalleVenta" OWNER TO app;

--
-- Name: DetalleVenta_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."DetalleVenta_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."DetalleVenta_id_seq" OWNER TO app;

--
-- Name: DetalleVenta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."DetalleVenta_id_seq" OWNED BY public."DetalleVenta".id;


--
-- Name: Movimiento; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."Movimiento" (
    id integer NOT NULL,
    "productoId" integer NOT NULL,
    tipo public."TipoMovimiento" NOT NULL,
    cantidad integer NOT NULL,
    motivo text,
    "stockAntes" integer NOT NULL,
    "stockDespues" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."Movimiento" OWNER TO app;

--
-- Name: Movimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."Movimiento_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Movimiento_id_seq" OWNER TO app;

--
-- Name: Movimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."Movimiento_id_seq" OWNED BY public."Movimiento".id;


--
-- Name: Permiso; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."Permiso" (
    id integer NOT NULL,
    codigo text NOT NULL,
    modulo text NOT NULL,
    descripcion text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Permiso" OWNER TO app;

--
-- Name: Permiso_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."Permiso_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Permiso_id_seq" OWNER TO app;

--
-- Name: Permiso_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."Permiso_id_seq" OWNED BY public."Permiso".id;


--
-- Name: Producto; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."Producto" (
    id integer NOT NULL,
    nombre text NOT NULL,
    descripcion text,
    precio double precision NOT NULL,
    stock integer DEFAULT 0 NOT NULL,
    "stockMinimo" integer DEFAULT 5 NOT NULL,
    descuento double precision DEFAULT 0 NOT NULL,
    "categoriaId" integer NOT NULL,
    "proveedorId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "codigoBarra" text
);


ALTER TABLE public."Producto" OWNER TO app;

--
-- Name: Producto_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."Producto_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Producto_id_seq" OWNER TO app;

--
-- Name: Producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."Producto_id_seq" OWNED BY public."Producto".id;


--
-- Name: Proveedor; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."Proveedor" (
    id integer NOT NULL,
    nombre text NOT NULL,
    telefono text,
    email text,
    direccion text,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Proveedor" OWNER TO app;

--
-- Name: Proveedor_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."Proveedor_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Proveedor_id_seq" OWNER TO app;

--
-- Name: Proveedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."Proveedor_id_seq" OWNED BY public."Proveedor".id;


--
-- Name: RefreshToken; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."RefreshToken" (
    id text NOT NULL,
    "tokenHash" text NOT NULL,
    "expiresAt" timestamp(3) without time zone NOT NULL,
    revoked boolean DEFAULT false NOT NULL,
    "replacedByTokenId" text,
    "usuarioId" integer NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public."RefreshToken" OWNER TO app;

--
-- Name: Rol; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."Rol" (
    id integer NOT NULL,
    codigo text NOT NULL,
    nombre text NOT NULL,
    descripcion text,
    activo boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL
);


ALTER TABLE public."Rol" OWNER TO app;

--
-- Name: RolPermiso; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."RolPermiso" (
    "rolId" integer NOT NULL,
    "permisoId" integer NOT NULL
);


ALTER TABLE public."RolPermiso" OWNER TO app;

--
-- Name: Rol_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."Rol_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Rol_id_seq" OWNER TO app;

--
-- Name: Rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."Rol_id_seq" OWNED BY public."Rol".id;


--
-- Name: Usuario; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."Usuario" (
    id integer NOT NULL,
    nombre text NOT NULL,
    email text NOT NULL,
    "passwordHash" text NOT NULL,
    activo boolean DEFAULT true NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "updatedAt" timestamp(3) without time zone NOT NULL,
    "rolId" integer NOT NULL,
    "pinAutorizacionHash" text
);


ALTER TABLE public."Usuario" OWNER TO app;

--
-- Name: Usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."Usuario_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Usuario_id_seq" OWNER TO app;

--
-- Name: Usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."Usuario_id_seq" OWNED BY public."Usuario".id;


--
-- Name: Venta; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public."Venta" (
    id integer NOT NULL,
    total double precision NOT NULL,
    "descuentoTotal" double precision DEFAULT 0 NOT NULL,
    "createdAt" timestamp(3) without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "metodoPago" public."MetodoPago" DEFAULT 'EFECTIVO'::public."MetodoPago" NOT NULL,
    "tieneStockInsuficiente" boolean DEFAULT false NOT NULL,
    "autorizadoPorId" integer,
    "motivoAutorizacion" text,
    "userId" integer NOT NULL
);


ALTER TABLE public."Venta" OWNER TO app;

--
-- Name: Venta_id_seq; Type: SEQUENCE; Schema: public; Owner: app
--

CREATE SEQUENCE public."Venta_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public."Venta_id_seq" OWNER TO app;

--
-- Name: Venta_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: app
--

ALTER SEQUENCE public."Venta_id_seq" OWNED BY public."Venta".id;


--
-- Name: _prisma_migrations; Type: TABLE; Schema: public; Owner: app
--

CREATE TABLE public._prisma_migrations (
    id character varying(36) NOT NULL,
    checksum character varying(64) NOT NULL,
    finished_at timestamp with time zone,
    migration_name character varying(255) NOT NULL,
    logs text,
    rolled_back_at timestamp with time zone,
    started_at timestamp with time zone DEFAULT now() NOT NULL,
    applied_steps_count integer DEFAULT 0 NOT NULL
);


ALTER TABLE public._prisma_migrations OWNER TO app;

--
-- Name: Categoria id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Categoria" ALTER COLUMN id SET DEFAULT nextval('public."Categoria_id_seq"'::regclass);


--
-- Name: DetalleVenta id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."DetalleVenta" ALTER COLUMN id SET DEFAULT nextval('public."DetalleVenta_id_seq"'::regclass);


--
-- Name: Movimiento id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Movimiento" ALTER COLUMN id SET DEFAULT nextval('public."Movimiento_id_seq"'::regclass);


--
-- Name: Permiso id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Permiso" ALTER COLUMN id SET DEFAULT nextval('public."Permiso_id_seq"'::regclass);


--
-- Name: Producto id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Producto" ALTER COLUMN id SET DEFAULT nextval('public."Producto_id_seq"'::regclass);


--
-- Name: Proveedor id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Proveedor" ALTER COLUMN id SET DEFAULT nextval('public."Proveedor_id_seq"'::regclass);


--
-- Name: Rol id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Rol" ALTER COLUMN id SET DEFAULT nextval('public."Rol_id_seq"'::regclass);


--
-- Name: Usuario id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Usuario" ALTER COLUMN id SET DEFAULT nextval('public."Usuario_id_seq"'::regclass);


--
-- Name: Venta id; Type: DEFAULT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Venta" ALTER COLUMN id SET DEFAULT nextval('public."Venta_id_seq"'::regclass);


--
-- Data for Name: Categoria; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."Categoria" (id, nombre, descripcion, descuento, "createdAt", "updatedAt") FROM stdin;
31	Bebidas	Bebidas gaseosas, jugos, aguas y energeticas	0	2026-09-02 05:16:06.579	2026-09-02 05:16:06.579
33	Confites	Chocolates, dulces, galletas y snacks	0	2026-09-02 05:16:06.579	2026-09-02 05:16:06.579
32	Abarrotes	Productos basicos de despensa	0	2026-09-02 05:16:06.579	2026-09-02 05:16:06.579
34	Limpieza	Articulos de aseo para el hogar	0	2026-09-02 05:16:06.579	2026-09-02 05:16:06.579
35	Lacteos	Leches, yogures, quesos y derivados	0	2026-09-02 05:16:06.579	2026-09-02 05:16:06.579
36	Panaderia	Panes, masas y productos horneados	0	2026-09-02 05:16:06.579	2026-09-02 05:16:06.579
38	Congelados	Comidas y productos congelados	0	2026-09-02 05:16:06.58	2026-09-02 05:16:06.58
37	Cuidado Personal	Higiene y cuidado personal	0	2026-09-02 05:16:06.58	2026-09-02 05:16:06.58
39	Frutas y Verduras	Productos frescos de temporada	0	2026-09-02 05:16:06.58	2026-09-02 05:16:06.58
40	Mascotas	Alimentos y accesorios para mascotas	0	2026-09-02 05:16:06.58	2026-09-02 05:16:06.58
\.


--
-- Data for Name: DetalleVenta; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."DetalleVenta" (id, "ventaId", "productoId", cantidad, "precioUnit", descuento, subtotal, "stockInsuficiente") FROM stdin;
1	1	1511	1	5050	0	5050	f
2	2	1522	1	11700	0	11700	f
3	3	1522	1	11700	0	11700	f
4	4	1557	1	4790	0	4790	f
5	5	1522	1	11700	0	11700	f
6	5	1790	1	8750	0	8750	f
7	6	1511	1	5050	0	5050	f
8	7	1557	1	4790	0	4790	f
9	8	1678	2	11000	0	22000	f
10	8	1666	2	3940	0	7880	f
11	8	1557	1	4790	0	4790	f
12	8	1511	1	5050	0	5050	f
13	8	1680	1	1370	0	1370	f
14	8	1790	1	8750	0	8750	f
15	8	1696	1	1330	0	1330	f
16	8	1700	1	8280	0	8280	f
17	8	1855	1	5750	0	5750	f
18	8	1635	1	3130	0	3130	f
19	9	1678	1	11000	0	11000	f
20	9	1666	1	3940	0	3940	f
21	9	1522	1	11700	0	11700	f
22	10	1522	3	11700	0	35100	f
23	10	1557	2	4790	0	9580	f
24	10	1790	2	8750	0	17500	f
25	10	1511	6	5050	0	30300	f
26	10	1666	1	3940	0	3940	f
27	10	1678	1	11000	0	11000	f
28	10	1850	1	3790	0	3790	f
29	11	1666	2	3940	0	7880	f
30	11	1522	1	11700	0	11700	f
31	11	1790	1	8750	0	8750	f
32	11	1511	1	5050	0	5050	f
33	11	1678	1	11000	0	11000	f
34	12	1678	1	11000	0	11000	f
35	12	1666	1	3940	0	3940	f
36	12	1522	1	11700	0	11700	f
37	12	1557	1	4790	0	4790	f
38	12	1790	1	8750	0	8750	f
39	12	1511	1	5050	0	5050	f
40	12	1680	1	1370	0	1370	f
41	12	1755	1	2410	0	2410	f
42	13	1522	1	11700	0	11700	f
43	13	1790	1	8750	0	8750	f
44	13	1511	1	5050	0	5050	f
45	13	1678	1	11000	0	11000	f
46	13	1666	1	3940	0	3940	f
47	14	1522	1	11700	0	11700	f
48	14	1678	1	11000	0	11000	f
49	15	1666	1	3940	0	3940	f
50	16	1522	1	11700	0	11700	f
51	17	1678	1	11000	0	11000	f
52	17	1666	1	3940	0	3940	f
53	18	1666	1	3940	0	3940	f
54	19	1522	1	11700	0	11700	f
55	20	1666	1	3940	0	3940	f
56	20	1522	1	11700	0	11700	f
57	20	1790	1	8750	0	8750	f
58	21	1678	1	11000	0	11000	f
\.


--
-- Data for Name: Movimiento; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."Movimiento" (id, "productoId", tipo, cantidad, motivo, "stockAntes", "stockDespues", "createdAt") FROM stdin;
1	1511	SALIDA	1	Venta #1	81	80	2026-09-02 05:23:12.696
2	1522	SALIDA	1	Venta #2	118	117	2026-09-02 05:23:28.769
3	1522	SALIDA	1	Venta #3	117	116	2026-09-02 05:23:36.311
4	1557	SALIDA	1	Venta #4	89	88	2026-09-02 06:13:18.455
5	1522	SALIDA	1	Venta #5	116	115	2026-09-02 06:13:29.023
6	1790	SALIDA	1	Venta #5	91	90	2026-09-02 06:13:29.027
7	1511	SALIDA	1	Venta #6	80	79	2026-09-02 06:13:51.483
8	1557	SALIDA	1	Venta #7	88	87	2026-09-02 06:14:57.977
9	1678	SALIDA	2	Venta #8	81	79	2026-09-02 06:19:34.866
10	1666	SALIDA	2	Venta #8	147	145	2026-09-02 06:19:34.87
11	1557	SALIDA	1	Venta #8	87	86	2026-09-02 06:19:34.872
12	1511	SALIDA	1	Venta #8	79	78	2026-09-02 06:19:34.875
13	1680	SALIDA	1	Venta #8	52	51	2026-09-02 06:19:34.877
14	1790	SALIDA	1	Venta #8	90	89	2026-09-02 06:19:34.879
15	1696	SALIDA	1	Venta #8	19	18	2026-09-02 06:19:34.881
16	1700	SALIDA	1	Venta #8	177	176	2026-09-02 06:19:34.883
17	1855	SALIDA	1	Venta #8	36	35	2026-09-02 06:19:34.886
18	1635	SALIDA	1	Venta #8	30	29	2026-09-02 06:19:34.889
19	1678	SALIDA	1	Venta #9	79	78	2026-09-02 06:19:43.588
20	1666	SALIDA	1	Venta #9	145	144	2026-09-02 06:19:43.59
21	1522	SALIDA	1	Venta #9	115	114	2026-09-02 06:19:43.592
22	1522	SALIDA	3	Venta #10	114	111	2026-09-02 06:21:00.498
23	1557	SALIDA	2	Venta #10	86	84	2026-09-02 06:21:00.502
24	1790	SALIDA	2	Venta #10	89	87	2026-09-02 06:21:00.504
25	1511	SALIDA	6	Venta #10	78	72	2026-09-02 06:21:00.506
26	1666	SALIDA	1	Venta #10	144	143	2026-09-02 06:21:00.508
27	1678	SALIDA	1	Venta #10	78	77	2026-09-02 06:21:00.51
28	1850	SALIDA	1	Venta #10	37	36	2026-09-02 06:21:00.511
29	1666	SALIDA	2	Venta #11	143	141	2026-09-02 06:22:15.633
30	1522	SALIDA	1	Venta #11	111	110	2026-09-02 06:22:15.637
31	1790	SALIDA	1	Venta #11	87	86	2026-09-02 06:22:15.64
32	1511	SALIDA	1	Venta #11	72	71	2026-09-02 06:22:15.645
33	1678	SALIDA	1	Venta #11	77	76	2026-09-02 06:22:15.648
34	1678	SALIDA	1	Venta #12	76	75	2026-09-02 06:22:34.943
35	1666	SALIDA	1	Venta #12	141	140	2026-09-02 06:22:34.945
36	1522	SALIDA	1	Venta #12	110	109	2026-09-02 06:22:34.948
37	1557	SALIDA	1	Venta #12	84	83	2026-09-02 06:22:34.95
38	1790	SALIDA	1	Venta #12	86	85	2026-09-02 06:22:34.953
39	1511	SALIDA	1	Venta #12	71	70	2026-09-02 06:22:34.955
40	1680	SALIDA	1	Venta #12	51	50	2026-09-02 06:22:34.958
41	1755	SALIDA	1	Venta #12	192	191	2026-09-02 06:22:34.96
42	1522	SALIDA	1	Venta #13	109	108	2026-09-02 06:23:42.616
43	1790	SALIDA	1	Venta #13	85	84	2026-09-02 06:23:42.62
44	1511	SALIDA	1	Venta #13	70	69	2026-09-02 06:23:42.623
45	1678	SALIDA	1	Venta #13	75	74	2026-09-02 06:23:42.626
46	1666	SALIDA	1	Venta #13	140	139	2026-09-02 06:23:42.628
47	1522	SALIDA	1	Venta #14	108	107	2026-09-02 06:25:14.397
48	1678	SALIDA	1	Venta #14	74	73	2026-09-02 06:25:14.4
49	1666	SALIDA	1	Venta #15	139	138	2026-09-02 06:25:23.784
50	1522	SALIDA	1	Venta #16	107	106	2026-09-02 06:26:43.175
51	1678	SALIDA	1	Venta #17	73	72	2026-09-02 06:30:17.139
52	1666	SALIDA	1	Venta #17	138	137	2026-09-02 06:30:17.141
53	1666	SALIDA	1	Venta #18	137	136	2026-09-02 06:30:41.507
54	1522	SALIDA	1	Venta #19	106	105	2026-09-02 06:32:03.775
55	1666	SALIDA	1	Venta #20	136	135	2026-09-02 06:34:14.108
56	1522	SALIDA	1	Venta #20	105	104	2026-09-02 06:34:14.111
57	1790	SALIDA	1	Venta #20	84	83	2026-09-02 06:34:14.113
58	1678	SALIDA	1	Venta #21	72	71	2026-09-02 06:35:11.421
\.


--
-- Data for Name: Permiso; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."Permiso" (id, codigo, modulo, descripcion, "createdAt", "updatedAt") FROM stdin;
3	dashboard.ver	dashboard	Ver dashboard operativo	2026-08-24 04:36:09.224	2026-09-02 05:16:05.571
1	usuarios.gestionar	usuarios	Crear, editar, listar y eliminar usuarios	2026-08-24 04:36:08.908	2026-09-02 05:16:05.576
2	stock.autorizar	ventas	Autorizar ventas con stock insuficiente	2026-08-24 04:36:08.908	2026-09-02 05:16:05.584
\.


--
-- Data for Name: Producto; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."Producto" (id, nombre, descripcion, precio, stock, "stockMinimo", descuento, "categoriaId", "proveedorId", "createdAt", "updatedAt", "codigoBarra") FROM stdin;
1522	Aceite Carozzi Canola 750 g	Aceite Carozzi Canola 750 g, producto ideal para minimarket distribuido por Watt's Comercial.	11700	104	17	0	32	33	2026-07-09 05:16:06.685	2026-09-02 06:34:14.11	7801000000822
1557	Aceite Carozzi Tradicional 750 g	Aceite Carozzi Tradicional 750 g, producto seleccionado distribuido por Soprole.	4790	83	17	0	32	38	2026-07-06 05:16:06.685	2026-09-02 06:22:34.949	7801000001171
1696	Lechuga La Vega Roja 5 kg	Lechuga La Vega Roja 5 kg, producto para venta diaria distribuido por Nestle Chile.	1330	18	13	0	39	34	2026-08-25 05:16:06.685	2026-09-02 06:19:34.88	7801000002567
1700	Leche Colun Natural 1 kg	Leche Colun Natural 1 kg, producto con stock estable distribuido por Nestle Chile.	8280	176	17	0	35	34	2026-05-03 05:16:06.685	2026-09-02 06:19:34.883	7801000002604
1855	Harina Iansa Canola 2 kg	Harina Iansa Canola 2 kg, producto familiar distribuido por Distribuidora Rabie.	5750	35	15	0	32	40	2026-07-17 05:16:06.685	2026-09-02 06:19:34.885	7801000004158
1635	Azucar Carozzi Fina 200 g	Azucar Carozzi Fina 200 g, producto formato conveniente distribuido por CCU.	3130	29	18	0	32	35	2026-03-08 05:16:06.685	2026-09-02 06:19:34.887	7801000001959
1680	Barra cereal Costa Avellana 180 g	Barra cereal Costa Avellana 180 g, producto ideal para minimarket distribuido por Nestle Chile.	1370	50	10	0	33	34	2026-05-29 05:16:06.685	2026-09-02 06:22:34.956	7801000002406
1666	Aceite Banquete Tradicional 500 g	Aceite Banquete Tradicional 500 g, producto ideal para minimarket distribuido por Watt's Comercial.	3940	135	13	0	32	33	2026-03-16 05:16:06.685	2026-09-02 06:34:14.107	7801000002260
1678	Aceite Banquete Maravilla 1.5 kg	Aceite Banquete Maravilla 1.5 kg, producto ideal para minimarket distribuido por Carozzi.	11000	71	15	0	32	37	2026-07-20 05:16:06.685	2026-09-02 06:35:11.42	7801000002383
1790	Aceite Chef Fina 400 g	Aceite Chef Fina 400 g, producto ideal para minimarket distribuido por Watt's Comercial.	8750	83	17	0	32	33	2026-05-26 05:16:06.685	2026-09-02 06:34:14.112	7801000003502
1755	Hallulla Fuchs Blanco 800 g	Hallulla Fuchs Blanco 800 g, producto formato conveniente distribuido por Nestle Chile.	2410	191	20	0	36	34	2026-05-12 05:16:06.685	2026-09-02 06:22:34.959	7801000003151
1441	Caramelo Marco Polo Avellana 250 g	Caramelo Marco Polo Avellana 250 g, producto calidad supermercado distribuido por CCU.	2920	114	9	0	33	35	2026-07-30 05:16:06.685	2026-07-30 05:16:06.685	7801000000013
1442	Cloro Nova Aroma floral 1 L	Cloro Nova Aroma floral 1 L, producto calidad supermercado distribuido por CCU.	11700	45	12	0	34	35	2026-07-03 05:16:06.685	2026-07-03 05:16:06.685	7801000000020
1443	Mantequilla Nestle Natural 900 g	Mantequilla Nestle Natural 900 g, producto para venta diaria distribuido por Agrosuper.	4120	64	8	0	35	32	2026-06-27 05:16:06.685	2026-06-27 05:16:06.685	7801000000037
1444	Mantequilla Parmalat Protein 500 g	Mantequilla Parmalat Protein 500 g, producto para venta diaria distribuido por Coca-Cola Embonor.	4620	78	12	0	35	31	2026-07-23 05:16:06.685	2026-07-23 05:16:06.685	7801000000044
1445	Quesillo Soprole Entera 250 g	Quesillo Soprole Entera 250 g, producto ideal para minimarket distribuido por CCU.	3120	140	7	0	35	35	2026-04-02 05:16:06.685	2026-04-02 05:16:06.685	7801000000051
1446	Marraqueta Ideal Chocolate 250 g	Marraqueta Ideal Chocolate 250 g, producto seleccionado distribuido por Agrosuper.	2740	10	17	0	36	32	2026-03-09 05:16:06.685	2026-03-09 05:16:06.685	7801000000068
1447	Te helado Fanta Manzana 12 x 350 ml	Te helado Fanta Manzana 12 x 350 ml, producto para venta diaria distribuido por Distribuidora Rabie.	2340	144	12	0	31	40	2026-03-20 05:16:06.685	2026-03-20 05:16:06.685	7801000000075
1448	Empanada La Crianza Primavera 12 unidades	Empanada La Crianza Primavera 12 unidades, producto para venta diaria distribuido por Dimak Mayorista.	10400	133	15	0	38	39	2026-06-17 05:16:06.685	2026-06-17 05:16:06.685	7801000000082
1449	Pasta dental Rexona Aloe vera 90 g	Pasta dental Rexona Aloe vera 90 g, producto de alta rotacion distribuido por Coca-Cola Embonor.	4040	180	15	0	37	31	2026-07-20 05:16:06.685	2026-07-20 05:16:06.685	7801000000099
1450	Nuggets Frutos del Maipo Vainilla 250 g	Nuggets Frutos del Maipo Vainilla 250 g, producto con stock estable distribuido por Watt's Comercial.	8280	168	18	0	38	33	2026-07-30 05:16:06.685	2026-07-30 05:16:06.685	7801000000105
1451	Zanahoria Fruta Sur Maduro 2 kg	Zanahoria Fruta Sur Maduro 2 kg, producto ideal para minimarket distribuido por CCU.	7980	3	11	0	39	35	2026-04-02 05:16:06.685	2026-04-02 05:16:06.685	7801000000112
1452	Azucar Tucapel Libre de gluten 750 g	Azucar Tucapel Libre de gluten 750 g, producto con stock estable distribuido por Unilever Chile.	3560	115	8	16	32	36	2026-04-27 05:16:06.685	2026-04-27 05:16:06.685	7801000000129
1453	Papas fritas Costa Frutilla 180 g	Papas fritas Costa Frutilla 180 g, producto para venta diaria distribuido por Carozzi.	3800	104	16	0	33	37	2026-08-12 05:16:06.685	2026-08-12 05:16:06.685	7801000000136
1454	Lentejas Iansa Libre de gluten 500 g	Lentejas Iansa Libre de gluten 500 g, producto de alta rotacion distribuido por Dimak Mayorista.	1370	189	7	0	32	39	2026-08-06 05:16:06.685	2026-08-06 05:16:06.685	7801000000143
1455	Arroz Carozzi Grado 1 500 g	Arroz Carozzi Grado 1 500 g, producto ideal para minimarket distribuido por CCU.	3950	185	7	0	32	35	2026-05-16 05:16:06.685	2026-05-16 05:16:06.685	7801000000150
1456	Bebida cola Red Bull Limon 500 ml botella	Bebida cola Red Bull Limon 500 ml botella, producto para venta diaria distribuido por Watt's Comercial.	12900	108	6	0	31	33	2026-04-05 05:16:06.685	2026-04-05 05:16:06.685	7801000000167
1457	Marraqueta Castaño Blanco 12 unidades	Marraqueta Castaño Blanco 12 unidades, producto familiar distribuido por Dimak Mayorista.	4330	105	13	0	36	39	2026-04-11 05:16:06.685	2026-04-11 05:16:06.685	7801000000174
1458	Bebida lima limon Kem Sin azucar 2.5 L botella	Bebida lima limon Kem Sin azucar 2.5 L botella, producto para venta diaria distribuido por CCU.	3900	195	9	0	31	35	2026-04-27 05:16:06.685	2026-04-27 05:16:06.685	7801000000181
1459	Alimento gato Whiskas Piel sensible 1 kg	Alimento gato Whiskas Piel sensible 1 kg, producto seleccionado distribuido por Watt's Comercial.	11800	30	8	0	40	33	2026-06-11 05:16:06.685	2026-06-11 05:16:06.685	7801000000198
1460	Verduras surtidas San Jorge Pollo 500 g	Verduras surtidas San Jorge Pollo 500 g, producto formato conveniente distribuido por Unilever Chile.	12300	165	19	0	38	36	2026-07-13 05:16:06.685	2026-07-13 05:16:06.685	7801000000204
1461	Choclo PF Primavera 1 kg	Choclo PF Primavera 1 kg, producto de alta rotacion distribuido por Dimak Mayorista.	10700	144	13	0	38	39	2026-04-03 05:16:06.685	2026-04-03 05:16:06.685	7801000000211
1462	Toalla higienica Kotex Antibacterial 250 ml	Toalla higienica Kotex Antibacterial 250 ml, producto calidad supermercado distribuido por Dimak Mayorista.	6960	169	16	0	37	39	2026-07-09 05:16:06.685	2026-07-09 05:16:06.685	7801000000228
1463	Tortilla La Selecta Integral 600 g	Tortilla La Selecta Integral 600 g, producto ideal para minimarket distribuido por Coca-Cola Embonor.	4690	42	12	0	36	31	2026-05-03 05:16:06.685	2026-05-03 05:16:06.685	7801000000235
1464	Ramitas Bon o Bon Menta 100 g	Ramitas Bon o Bon Menta 100 g, producto con stock estable distribuido por Distribuidora Rabie.	1130	183	18	0	33	40	2026-07-02 05:16:06.685	2026-07-02 05:16:06.685	7801000000242
1465	Toalla higienica Pepsodent Aloe vera 350 ml	Toalla higienica Pepsodent Aloe vera 350 ml, producto formato conveniente distribuido por Dimak Mayorista.	2570	59	9	0	37	39	2026-04-04 05:16:06.685	2026-04-04 05:16:06.685	7801000000259
1466	Helado Minuto Verde Tradicional 250 g	Helado Minuto Verde Tradicional 250 g, producto formato conveniente distribuido por Soprole.	12800	175	11	0	38	38	2026-08-30 05:16:06.685	2026-08-30 05:16:06.685	7801000000266
1467	Bebida naranja Andina Naranja 350 ml lata	Bebida naranja Andina Naranja 350 ml lata, producto familiar distribuido por Nestle Chile.	11700	121	6	0	31	34	2026-06-03 05:16:06.685	2026-06-03 05:16:06.685	7801000000273
1468	Queque Fuchs Multigrano 700 g	Queque Fuchs Multigrano 700 g, producto con stock estable distribuido por Carozzi.	4860	178	7	0	36	37	2026-08-26 05:16:06.685	2026-08-26 05:16:06.685	7801000000280
1469	Lata gato Master Dog Control olor 1 kg	Lata gato Master Dog Control olor 1 kg, producto formato conveniente distribuido por Unilever Chile.	16100	193	12	0	40	36	2026-07-27 05:16:06.685	2026-07-27 05:16:06.685	7801000000297
1470	Nuggets Minuto Verde Pollo 1.5 kg	Nuggets Minuto Verde Pollo 1.5 kg, producto con stock estable distribuido por Nestle Chile.	3510	49	9	0	38	34	2026-06-18 05:16:06.685	2026-06-18 05:16:06.685	7801000000303
1471	Toalla higienica Dove Menta 250 ml	Toalla higienica Dove Menta 250 ml, producto formato conveniente distribuido por Nestle Chile.	4330	25	7	0	37	34	2026-07-30 05:16:06.685	2026-07-30 05:16:06.685	7801000000310
1472	Shampoo mascota Champion Dog Pollo 10 kg	Shampoo mascota Champion Dog Pollo 10 kg, producto familiar distribuido por Carozzi.	7820	163	5	0	40	37	2026-06-16 05:16:06.685	2026-06-16 05:16:06.685	7801000000327
1473	Queso gauda Soprole Sin lactosa 125 g	Queso gauda Soprole Sin lactosa 125 g, producto calidad supermercado distribuido por Unilever Chile.	6500	173	8	0	35	36	2026-04-18 05:16:06.685	2026-04-18 05:16:06.685	7801000000334
1474	Toalla higienica Colgate Menta 90 g	Toalla higienica Colgate Menta 90 g, producto de alta rotacion distribuido por Agrosuper.	4170	105	7	0	37	32	2026-07-21 05:16:06.685	2026-07-21 05:16:06.685	7801000000341
1475	Fideos Miraflores Tradicional 750 g	Fideos Miraflores Tradicional 750 g, producto para venta diaria distribuido por Dimak Mayorista.	12000	64	13	0	32	39	2026-04-24 05:16:06.685	2026-04-24 05:16:06.685	7801000000358
1476	Fideos Lobos Fina 500 g	Fideos Lobos Fina 500 g, producto para venta diaria distribuido por Nestle Chile.	6330	112	13	0	32	34	2026-07-26 05:16:06.685	2026-07-26 05:16:06.685	7801000000365
1477	Papel higienico Omo Concentrado 3 L	Papel higienico Omo Concentrado 3 L, producto para venta diaria distribuido por Soprole.	6000	22	17	0	34	38	2026-08-22 05:16:06.685	2026-08-22 05:16:06.685	7801000000372
1478	Barra cereal Costa Chocolate 12 unidades	Barra cereal Costa Chocolate 12 unidades, producto con stock estable distribuido por Distribuidora Rabie.	3750	47	10	0	33	40	2026-06-23 05:16:06.685	2026-06-23 05:16:06.685	7801000000389
1479	Salsa de tomate Lucchetti Libre de gluten 400 g	Salsa de tomate Lucchetti Libre de gluten 400 g, producto ideal para minimarket distribuido por Agrosuper.	1340	106	16	0	32	32	2026-07-01 05:16:06.685	2026-07-01 05:16:06.685	7801000000396
1480	Pan pita Ideal Blanco 500 g	Pan pita Ideal Blanco 500 g, producto formato conveniente distribuido por Coca-Cola Embonor.	5130	129	14	0	36	31	2026-05-10 05:16:06.685	2026-05-10 05:16:06.685	7801000000402
1481	Azucar Banquete Tradicional 1.5 kg	Azucar Banquete Tradicional 1.5 kg, producto para venta diaria distribuido por Soprole.	1130	168	7	0	32	38	2026-05-09 05:16:06.685	2026-05-09 05:16:06.685	7801000000419
1482	Empanada Savory Primavera 400 g	Empanada Savory Primavera 400 g, producto ideal para minimarket distribuido por Agrosuper.	12100	108	20	0	38	32	2026-07-06 05:16:06.685	2026-07-06 05:16:06.685	7801000000426
1483	Palta Campo Lindo Roja 3 kg	Palta Campo Lindo Roja 3 kg, producto familiar distribuido por Carozzi.	9190	100	9	0	39	37	2026-03-26 05:16:06.685	2026-03-26 05:16:06.685	7801000000433
1484	Lentejas Lobos Integral 400 g	Lentejas Lobos Integral 400 g, producto ideal para minimarket distribuido por Distribuidora Rabie.	6310	34	5	0	32	40	2026-04-18 05:16:06.685	2026-04-18 05:16:06.685	7801000000440
1485	Mantequilla Nestle Vainilla 500 g	Mantequilla Nestle Vainilla 500 g, producto con stock estable distribuido por Dimak Mayorista.	2410	168	15	0	35	39	2026-03-13 05:16:06.685	2026-03-13 05:16:06.685	7801000000457
1486	Tomate La Vega Roja 5 kg	Tomate La Vega Roja 5 kg, producto formato conveniente distribuido por Nestle Chile.	7640	181	5	0	39	34	2026-05-15 05:16:06.685	2026-05-15 05:16:06.685	7801000000464
1487	Acondicionador Pepsodent Humectante 400 ml	Acondicionador Pepsodent Humectante 400 ml, producto de alta rotacion distribuido por Coca-Cola Embonor.	6750	104	9	0	37	31	2026-03-18 05:16:06.685	2026-03-18 05:16:06.685	7801000000471
1488	Mantequilla Parmalat Entera 170 g	Mantequilla Parmalat Entera 170 g, producto formato conveniente distribuido por Carozzi.	4910	167	14	0	35	37	2026-03-12 05:16:06.685	2026-03-12 05:16:06.685	7801000000488
1489	Hamburguesa Minuto Verde Primavera 12 unidades	Hamburguesa Minuto Verde Primavera 12 unidades, producto calidad supermercado distribuido por Coca-Cola Embonor.	14300	150	6	0	38	31	2026-07-21 05:16:06.685	2026-07-21 05:16:06.685	7801000000495
1490	Empanada Minuto Verde Queso 12 unidades	Empanada Minuto Verde Queso 12 unidades, producto para venta diaria distribuido por Nestle Chile.	2650	178	18	0	38	34	2026-03-17 05:16:06.685	2026-03-17 05:16:06.685	7801000000501
1491	Queso gauda Quillayes Entera 900 g	Queso gauda Quillayes Entera 900 g, producto familiar distribuido por CCU.	7020	34	11	0	35	35	2026-04-16 05:16:06.685	2026-04-16 05:16:06.685	7801000000518
1492	Zanahoria Agro Maule Malla 5 kg	Zanahoria Agro Maule Malla 5 kg, producto de alta rotacion distribuido por CCU.	5180	189	11	0	39	35	2026-04-04 05:16:06.685	2026-04-04 05:16:06.685	7801000000525
1493	Manjar Nestle Sin lactosa 250 g	Manjar Nestle Sin lactosa 250 g, producto formato conveniente distribuido por Agrosuper.	1170	164	18	0	35	32	2026-08-18 05:16:06.685	2026-08-18 05:16:06.685	7801000000532
1494	Caramelo Bon o Bon Leche 30 g	Caramelo Bon o Bon Leche 30 g, producto seleccionado distribuido por Distribuidora Rabie.	6190	200	14	0	33	40	2026-06-30 05:16:06.685	2026-06-30 05:16:06.685	7801000000549
1495	Leche Surlat Descremada 125 g	Leche Surlat Descremada 125 g, producto seleccionado distribuido por Watt's Comercial.	7470	121	19	9	35	33	2026-05-28 05:16:06.685	2026-05-28 05:16:06.685	7801000000556
1496	Limpiador piso Poett Ultra 450 ml	Limpiador piso Poett Ultra 450 ml, producto formato conveniente distribuido por Nestle Chile.	9230	175	12	0	34	34	2026-07-22 05:16:06.685	2026-07-22 05:16:06.685	7801000000563
1497	Desodorante Dove Sensitive 16 unidades	Desodorante Dove Sensitive 16 unidades, producto de alta rotacion distribuido por Soprole.	2450	177	20	0	37	38	2026-05-12 05:16:06.685	2026-05-12 05:16:06.685	7801000000570
1498	Hallulla Kingsbury Chocolate 6 unidades	Hallulla Kingsbury Chocolate 6 unidades, producto con stock estable distribuido por Nestle Chile.	3660	186	7	0	36	34	2026-06-17 05:16:06.685	2026-06-17 05:16:06.685	7801000000587
1499	Harina Miraflores Canola 1 kg	Harina Miraflores Canola 1 kg, producto calidad supermercado distribuido por Watt's Comercial.	5280	123	5	0	32	33	2026-09-02 05:16:06.685	2026-09-02 05:16:06.685	7801000000594
1500	Te helado Red Bull Light 2 L botella	Te helado Red Bull Light 2 L botella, producto seleccionado distribuido por Agrosuper.	8680	100	12	0	31	32	2026-03-31 05:16:06.685	2026-03-31 05:16:06.685	7801000000600
1501	Snack perro Master Dog Pescado 10 kg	Snack perro Master Dog Pescado 10 kg, producto para venta diaria distribuido por CCU.	32800	32	14	0	40	35	2026-06-02 05:16:06.685	2026-06-02 05:16:06.685	7801000000617
1502	Quesillo Soprole Frutilla 125 g	Quesillo Soprole Frutilla 125 g, producto ideal para minimarket distribuido por Watt's Comercial.	6120	133	20	0	35	33	2026-08-31 05:16:06.685	2026-08-31 05:16:06.685	7801000000624
1503	Cloro Virutex Antibacterial 3 L	Cloro Virutex Antibacterial 3 L, producto ideal para minimarket distribuido por Distribuidora Rabie.	14600	33	12	0	34	40	2026-05-08 05:16:06.685	2026-05-08 05:16:06.685	7801000000631
1504	Shampoo Head & Shoulders Control caida 350 ml	Shampoo Head & Shoulders Control caida 350 ml, producto de alta rotacion distribuido por Distribuidora Rabie.	3800	72	9	0	37	40	2026-07-04 05:16:06.685	2026-07-04 05:16:06.685	7801000000648
1505	Pan pita La Selecta Vainilla 600 g	Pan pita La Selecta Vainilla 600 g, producto con stock estable distribuido por Watt's Comercial.	1480	103	11	0	36	33	2026-07-22 05:16:06.685	2026-07-22 05:16:06.685	7801000000655
1506	Cepillo dental Colgate Original 90 g	Cepillo dental Colgate Original 90 g, producto calidad supermercado distribuido por Dimak Mayorista.	2560	178	20	0	37	39	2026-07-02 05:16:06.685	2026-07-02 05:16:06.685	7801000000662
1507	Acondicionador Nivea Humectante 75 ml	Acondicionador Nivea Humectante 75 ml, producto formato conveniente distribuido por Nestle Chile.	3910	166	18	0	37	34	2026-04-27 05:16:06.685	2026-04-27 05:16:06.685	7801000000679
1508	Papa Agro Maule Roja 5 kg	Papa Agro Maule Roja 5 kg, producto de alta rotacion distribuido por Nestle Chile.	3660	182	5	0	39	34	2026-04-24 05:16:06.685	2026-04-24 05:16:06.685	7801000000686
1509	Limpiador piso Poett Limon 1 L	Limpiador piso Poett Limon 1 L, producto calidad supermercado distribuido por Carozzi.	6290	130	20	0	34	37	2026-08-11 05:16:06.685	2026-08-11 05:16:06.685	7801000000693
1510	Collar Master Dog Carne 15 kg	Collar Master Dog Carne 15 kg, producto ideal para minimarket distribuido por Carozzi.	2940	23	9	0	40	37	2026-04-13 05:16:06.685	2026-04-13 05:16:06.685	7801000000709
1512	Bebida cola Kem Original 2.5 L botella	Bebida cola Kem Original 2.5 L botella, producto familiar distribuido por Distribuidora Rabie.	12800	144	7	0	31	40	2026-05-28 05:16:06.685	2026-05-28 05:16:06.685	7801000000723
1513	Agua saborizada Kem Sin azucar 6 x 350 ml	Agua saborizada Kem Sin azucar 6 x 350 ml, producto ideal para minimarket distribuido por Coca-Cola Embonor.	11500	113	5	0	31	31	2026-03-29 05:16:06.685	2026-03-29 05:16:06.685	7801000000730
1514	Papel higienico Omo Concentrado 12 unidades	Papel higienico Omo Concentrado 12 unidades, producto calidad supermercado distribuido por Carozzi.	960	37	7	0	34	37	2026-07-17 05:16:06.685	2026-07-17 05:16:06.685	7801000000747
1515	Jabon Kotex Invisible 75 ml	Jabon Kotex Invisible 75 ml, producto calidad supermercado distribuido por Nestle Chile.	7570	109	5	0	37	34	2026-03-28 05:16:06.685	2026-03-28 05:16:06.685	7801000000754
1516	Nuggets Tarragona Queso 1 kg	Nuggets Tarragona Queso 1 kg, producto familiar distribuido por Nestle Chile.	1570	18	17	0	38	34	2026-07-25 05:16:06.685	2026-07-25 05:16:06.685	7801000000761
1517	Te helado Watts Durazno 500 ml botella	Te helado Watts Durazno 500 ml botella, producto familiar distribuido por Watt's Comercial.	12500	49	6	0	31	33	2026-03-08 05:16:06.685	2026-03-08 05:16:06.685	7801000000778
1518	Lentejas Tucapel Tradicional 2 kg	Lentejas Tucapel Tradicional 2 kg, producto calidad supermercado distribuido por Distribuidora Rabie.	2250	194	8	0	32	40	2026-08-27 05:16:06.685	2026-08-27 05:16:06.685	7801000000785
1519	Acondicionador Kotex Humectante 75 ml	Acondicionador Kotex Humectante 75 ml, producto ideal para minimarket distribuido por CCU.	7960	69	7	0	37	35	2026-05-06 05:16:06.685	2026-05-06 05:16:06.685	7801000000792
1520	Toalla absorbente Clorinda Original 6 unidades	Toalla absorbente Clorinda Original 6 unidades, producto de alta rotacion distribuido por Watt's Comercial.	13800	79	8	0	34	33	2026-04-21 05:16:06.685	2026-04-21 05:16:06.685	7801000000808
1521	Te helado Fanta Sin azucar 350 ml lata	Te helado Fanta Sin azucar 350 ml lata, producto seleccionado distribuido por Unilever Chile.	6690	134	9	22	31	36	2026-07-23 05:16:06.685	2026-07-23 05:16:06.685	7801000000815
1523	Manjar Nestle Protein 500 g	Manjar Nestle Protein 500 g, producto de alta rotacion distribuido por Agrosuper.	3010	136	6	0	35	32	2026-05-15 05:16:06.685	2026-05-15 05:16:06.685	7801000000839
1524	Tortilla Castaño Sin azucar 6 unidades	Tortilla Castaño Sin azucar 6 unidades, producto de alta rotacion distribuido por CCU.	2080	195	11	0	36	35	2026-04-28 05:16:06.685	2026-04-28 05:16:06.685	7801000000846
1525	Desodorante Nivea Humectante 6 unidades	Desodorante Nivea Humectante 6 unidades, producto de alta rotacion distribuido por Distribuidora Rabie.	1880	125	18	0	37	40	2026-03-17 05:16:06.685	2026-03-17 05:16:06.685	7801000000853
1511	Aceite Miraflores Grado 1 200 g	Aceite Miraflores Grado 1 200 g, producto familiar distribuido por Carozzi.	5050	69	20	0	32	37	2026-08-31 05:16:06.685	2026-09-02 06:23:42.622	7801000000716
1526	Lata gato Pedigree Piel sensible 10 kg	Lata gato Pedigree Piel sensible 10 kg, producto con stock estable distribuido por Nestle Chile.	11900	4	9	0	40	34	2026-07-06 05:16:06.685	2026-07-06 05:16:06.685	7801000000860
1527	Alimento gato Cat Chow Control olor 3 kg	Alimento gato Cat Chow Control olor 3 kg, producto ideal para minimarket distribuido por Dimak Mayorista.	16100	177	9	0	40	39	2026-04-08 05:16:06.685	2026-04-08 05:16:06.685	7801000000877
1528	Sal Chef Canola 1.5 kg	Sal Chef Canola 1.5 kg, producto calidad supermercado distribuido por Coca-Cola Embonor.	7250	29	9	0	32	31	2026-03-14 05:16:06.685	2026-03-14 05:16:06.685	7801000000884
1529	Yogur Watts Sin lactosa 900 g	Yogur Watts Sin lactosa 900 g, producto para venta diaria distribuido por Carozzi.	8470	97	17	0	35	37	2026-08-07 05:16:06.685	2026-08-07 05:16:06.685	7801000000891
1530	Alimento perro Doko Control olor 10 kg	Alimento perro Doko Control olor 10 kg, producto formato conveniente distribuido por Soprole.	23400	27	5	0	40	38	2026-04-10 05:16:06.685	2026-04-10 05:16:06.685	7801000000907
1531	Queque Tarragona Tradicional 6 unidades	Queque Tarragona Tradicional 6 unidades, producto seleccionado distribuido por Agrosuper.	970	65	9	0	36	32	2026-03-10 05:16:06.685	2026-03-10 05:16:06.685	7801000000914
1532	Bebida lima limon Red Bull Original 2 L botella	Bebida lima limon Red Bull Original 2 L botella, producto calidad supermercado distribuido por Dimak Mayorista.	3530	62	12	0	31	39	2026-03-12 05:16:06.685	2026-03-12 05:16:06.685	7801000000921
1533	Azucar Miraflores Con albahaca 200 g	Azucar Miraflores Con albahaca 200 g, producto ideal para minimarket distribuido por Agrosuper.	3440	155	8	0	32	32	2026-07-07 05:16:06.685	2026-07-07 05:16:06.685	7801000000938
1534	Sal Chef Grado 1 2 kg	Sal Chef Grado 1 2 kg, producto calidad supermercado distribuido por Agrosuper.	4420	175	20	0	32	32	2026-05-16 05:16:06.685	2026-05-16 05:16:06.685	7801000000945
1535	Pasta dental Nivea Sensitive 16 unidades	Pasta dental Nivea Sensitive 16 unidades, producto de alta rotacion distribuido por Distribuidora Rabie.	3290	169	14	0	37	40	2026-04-10 05:16:06.685	2026-04-10 05:16:06.685	7801000000952
1536	Alimento gato Cat Chow Piel sensible 10 kg	Alimento gato Cat Chow Piel sensible 10 kg, producto calidad supermercado distribuido por Soprole.	34700	102	15	0	40	38	2026-03-24 05:16:06.685	2026-03-24 05:16:06.685	7801000000969
1537	Bebida energetica Coca-Cola Limon 350 ml lata	Bebida energetica Coca-Cola Limon 350 ml lata, producto de alta rotacion distribuido por Soprole.	5640	91	13	0	31	38	2026-07-23 05:16:06.685	2026-07-23 05:16:06.685	7801000000976
1538	Hamburguesa Minuto Verde Vacuno 6 unidades	Hamburguesa Minuto Verde Vacuno 6 unidades, producto seleccionado distribuido por Distribuidora Rabie.	9300	134	20	0	38	40	2026-03-25 05:16:06.685	2026-03-25 05:16:06.685	7801000000983
1539	Cloro Omo Original 6 unidades	Cloro Omo Original 6 unidades, producto para venta diaria distribuido por Distribuidora Rabie.	11300	162	8	0	34	40	2026-06-17 05:16:06.685	2026-06-17 05:16:06.685	7801000000990
1540	Bebida naranja Fanta Original 500 ml botella	Bebida naranja Fanta Original 500 ml botella, producto con stock estable distribuido por Watt's Comercial.	7080	180	10	21	31	33	2026-08-16 05:16:06.685	2026-08-16 05:16:06.685	7801000001003
1541	Desinfectante Omo Limon 1 L	Desinfectante Omo Limon 1 L, producto familiar distribuido por Nestle Chile.	1210	17	15	11	34	34	2026-08-18 05:16:06.685	2026-08-18 05:16:06.685	7801000001010
1542	Lavalozas Clorinda Antibacterial 1.5 L	Lavalozas Clorinda Antibacterial 1.5 L, producto para venta diaria distribuido por Carozzi.	12400	99	13	0	34	37	2026-07-22 05:16:06.685	2026-07-22 05:16:06.685	7801000001027
1543	Lata gato Fit Formula Carne 3 kg	Lata gato Fit Formula Carne 3 kg, producto ideal para minimarket distribuido por Distribuidora Rabie.	17300	188	18	6	40	40	2026-09-01 05:16:06.685	2026-09-01 05:16:06.685	7801000001034
1544	Crema de leche Nestle Frutilla 6 unidades	Crema de leche Nestle Frutilla 6 unidades, producto ideal para minimarket distribuido por Soprole.	2330	21	13	0	35	38	2026-08-23 05:16:06.685	2026-08-23 05:16:06.685	7801000001041
1545	Hueso carnaza Doko Carne 8 kg	Hueso carnaza Doko Carne 8 kg, producto de alta rotacion distribuido por Watt's Comercial.	1800	97	14	0	40	33	2026-07-04 05:16:06.685	2026-07-04 05:16:06.685	7801000001058
1546	Papas prefritas San Jorge Queso 400 g	Papas prefritas San Jorge Queso 400 g, producto familiar distribuido por Distribuidora Rabie.	7620	5	5	0	38	40	2026-03-25 05:16:06.685	2026-03-25 05:16:06.685	7801000001065
1547	Barra cereal Marco Polo Queso 12 unidades	Barra cereal Marco Polo Queso 12 unidades, producto calidad supermercado distribuido por Nestle Chile.	4680	138	18	0	33	34	2026-05-31 05:16:06.685	2026-05-31 05:16:06.685	7801000001072
1548	Pizza Tarragona Familiar 12 unidades	Pizza Tarragona Familiar 12 unidades, producto de alta rotacion distribuido por Unilever Chile.	2460	169	7	0	38	36	2026-04-03 05:16:06.685	2026-04-03 05:16:06.685	7801000001089
1549	Postre lacteo Surlat Sin lactosa 1 kg	Postre lacteo Surlat Sin lactosa 1 kg, producto formato conveniente distribuido por Agrosuper.	8800	178	9	0	35	32	2026-05-27 05:16:06.685	2026-05-27 05:16:06.685	7801000001096
1550	Hueso carnaza Pedigree Adulto 85 g	Hueso carnaza Pedigree Adulto 85 g, producto ideal para minimarket distribuido por CCU.	24900	155	15	0	40	35	2026-08-09 05:16:06.685	2026-08-09 05:16:06.685	7801000001102
1551	Jugo nectar Vital Zero 6 x 350 ml	Jugo nectar Vital Zero 6 x 350 ml, producto formato conveniente distribuido por Carozzi.	2050	58	12	0	31	37	2026-05-17 05:16:06.685	2026-05-17 05:16:06.685	7801000001119
1552	Helado Cuisine & Co Pollo 12 unidades	Helado Cuisine & Co Pollo 12 unidades, producto ideal para minimarket distribuido por Dimak Mayorista.	7040	158	13	0	38	39	2026-08-29 05:16:06.685	2026-08-29 05:16:06.685	7801000001126
1553	Arroz Tucapel Integral 500 g	Arroz Tucapel Integral 500 g, producto de alta rotacion distribuido por Carozzi.	7450	159	11	0	32	37	2026-04-28 05:16:06.685	2026-04-28 05:16:06.685	7801000001133
1554	Papa Santa Isabel Roja 2 kg	Papa Santa Isabel Roja 2 kg, producto ideal para minimarket distribuido por Nestle Chile.	1380	99	6	0	39	34	2026-03-15 05:16:06.685	2026-03-15 05:16:06.685	7801000001140
1555	Zanahoria Santa Isabel Malla 1.5 kg	Zanahoria Santa Isabel Malla 1.5 kg, producto seleccionado distribuido por Watt's Comercial.	4340	15	12	0	39	33	2026-04-05 05:16:06.685	2026-04-05 05:16:06.685	7801000001157
1556	Salsa de tomate Miraflores Maravilla 5 kg	Salsa de tomate Miraflores Maravilla 5 kg, producto seleccionado distribuido por Distribuidora Rabie.	7560	72	11	0	32	40	2026-06-27 05:16:06.685	2026-06-27 05:16:06.685	7801000001164
1558	Hamburguesa Tarragona Queso 500 g	Hamburguesa Tarragona Queso 500 g, producto ideal para minimarket distribuido por Unilever Chile.	7490	195	16	0	38	36	2026-05-09 05:16:06.685	2026-05-09 05:16:06.685	7801000001188
1559	Harina Carozzi Tradicional 1 kg	Harina Carozzi Tradicional 1 kg, producto formato conveniente distribuido por Distribuidora Rabie.	8920	58	12	0	32	40	2026-05-02 05:16:06.685	2026-05-02 05:16:06.685	7801000001195
1560	Snack perro Fit Formula Piel sensible 15 kg	Snack perro Fit Formula Piel sensible 15 kg, producto con stock estable distribuido por Agrosuper.	25000	63	20	0	40	32	2026-05-22 05:16:06.685	2026-05-22 05:16:06.685	7801000001201
1561	Harina Miraflores Integral 500 g	Harina Miraflores Integral 500 g, producto de alta rotacion distribuido por Carozzi.	1460	68	18	0	32	37	2026-03-08 05:16:06.685	2026-03-08 05:16:06.685	7801000001218
1562	Papa Bio Campo Maduro 5 kg	Papa Bio Campo Maduro 5 kg, producto calidad supermercado distribuido por Dimak Mayorista.	7650	71	8	0	39	39	2026-05-07 05:16:06.685	2026-05-07 05:16:06.685	7801000001225
1563	Shampoo mascota Pedigree Pollo 3 kg	Shampoo mascota Pedigree Pollo 3 kg, producto formato conveniente distribuido por Dimak Mayorista.	26300	193	11	0	40	39	2026-05-29 05:16:06.685	2026-05-29 05:16:06.685	7801000001232
1564	Pan molde San Camilo Sin azucar 400 g	Pan molde San Camilo Sin azucar 400 g, producto con stock estable distribuido por Agrosuper.	850	60	20	0	36	32	2026-08-15 05:16:06.685	2026-08-15 05:16:06.685	7801000001249
1565	Collar Master Dog Pollo 15 kg	Collar Master Dog Pollo 15 kg, producto familiar distribuido por Distribuidora Rabie.	32200	36	15	0	40	40	2026-06-15 05:16:06.685	2026-06-15 05:16:06.685	7801000001256
1566	Collar Champion Dog Control olor 1 kg	Collar Champion Dog Control olor 1 kg, producto formato conveniente distribuido por Dimak Mayorista.	34200	78	12	0	40	39	2026-08-10 05:16:06.685	2026-08-10 05:16:06.685	7801000001263
1567	Galleta Nutra Bien Chocolate 100 g	Galleta Nutra Bien Chocolate 100 g, producto calidad supermercado distribuido por Carozzi.	2700	55	15	0	33	37	2026-07-10 05:16:06.685	2026-07-10 05:16:06.685	7801000001270
1568	Tortilla Castaño Chocolate 12 unidades	Tortilla Castaño Chocolate 12 unidades, producto ideal para minimarket distribuido por Distribuidora Rabie.	1760	33	17	0	36	40	2026-08-09 05:16:06.685	2026-08-09 05:16:06.685	7801000001287
1569	Alimento perro Pedigree Piel sensible 3 kg	Alimento perro Pedigree Piel sensible 3 kg, producto familiar distribuido por Carozzi.	4140	13	20	0	40	37	2026-07-29 05:16:06.685	2026-07-29 05:16:06.685	7801000001294
1570	Acondicionador Head & Shoulders Antibacterial 250 ml	Acondicionador Head & Shoulders Antibacterial 250 ml, producto con stock estable distribuido por CCU.	4100	76	5	0	37	35	2026-05-01 05:16:06.685	2026-05-01 05:16:06.685	7801000001300
1571	Collar Fit Formula Pescado 15 kg	Collar Fit Formula Pescado 15 kg, producto calidad supermercado distribuido por Soprole.	5600	37	13	0	40	38	2026-05-23 05:16:06.685	2026-05-23 05:16:06.685	7801000001317
1572	Pasta dental Rexona Aloe vera 150 ml	Pasta dental Rexona Aloe vera 150 ml, producto seleccionado distribuido por Unilever Chile.	6220	30	17	0	37	36	2026-05-24 05:16:06.685	2026-05-24 05:16:06.685	7801000001324
1573	Papas fritas Bon o Bon Vainilla 180 g	Papas fritas Bon o Bon Vainilla 180 g, producto con stock estable distribuido por Dimak Mayorista.	3870	14	9	0	33	39	2026-04-18 05:16:06.685	2026-04-18 05:16:06.685	7801000001331
1574	Caramelo Ambrosoli Avellana 30 g	Caramelo Ambrosoli Avellana 30 g, producto seleccionado distribuido por Agrosuper.	4920	1	20	0	33	32	2026-08-06 05:16:06.685	2026-08-06 05:16:06.685	7801000001348
1575	Chicle Evercrisp Queso 250 g	Chicle Evercrisp Queso 250 g, producto ideal para minimarket distribuido por Dimak Mayorista.	5740	75	9	0	33	39	2026-07-05 05:16:06.685	2026-07-05 05:16:06.685	7801000001355
1576	Toalla higienica Pepsodent Sensitive 150 ml	Toalla higienica Pepsodent Sensitive 150 ml, producto familiar distribuido por Distribuidora Rabie.	2190	167	17	0	37	40	2026-08-30 05:16:06.685	2026-08-30 05:16:06.685	7801000001362
1577	Barra cereal Trident Avellana 100 g	Barra cereal Trident Avellana 100 g, producto de alta rotacion distribuido por Unilever Chile.	3500	17	18	0	33	36	2026-07-01 05:16:06.685	2026-07-01 05:16:06.685	7801000001379
1578	Pizza Cuisine & Co Vainilla 400 g	Pizza Cuisine & Co Vainilla 400 g, producto familiar distribuido por Carozzi.	4540	195	20	0	38	37	2026-06-21 05:16:06.685	2026-06-21 05:16:06.685	7801000001386
1579	Pan molde San Camilo Integral 250 g	Pan molde San Camilo Integral 250 g, producto para venta diaria distribuido por Nestle Chile.	1960	104	5	0	36	34	2026-07-13 05:16:06.685	2026-07-13 05:16:06.685	7801000001393
1580	Leche Surlat Sin lactosa 6 unidades	Leche Surlat Sin lactosa 6 unidades, producto con stock estable distribuido por Soprole.	2680	184	20	0	35	38	2026-09-01 05:16:06.685	2026-09-01 05:16:06.685	7801000001409
1581	Sal Banquete Con albahaca 400 g	Sal Banquete Con albahaca 400 g, producto familiar distribuido por Soprole.	2030	199	8	10	32	38	2026-05-17 05:16:06.685	2026-05-17 05:16:06.685	7801000001416
1582	Limpiador piso Nova Ultra 3 L	Limpiador piso Nova Ultra 3 L, producto calidad supermercado distribuido por CCU.	7030	160	8	0	34	35	2026-05-23 05:16:06.685	2026-05-23 05:16:06.685	7801000001423
1583	Harina Iansa Grado 1 750 g	Harina Iansa Grado 1 750 g, producto formato conveniente distribuido por Soprole.	11200	176	18	0	32	38	2026-04-08 05:16:06.685	2026-04-08 05:16:06.685	7801000001430
1584	Papas prefritas Cuisine & Co Tradicional 500 g	Papas prefritas Cuisine & Co Tradicional 500 g, producto formato conveniente distribuido por Coca-Cola Embonor.	12400	199	6	0	38	31	2026-08-12 05:16:06.685	2026-08-12 05:16:06.685	7801000001447
1585	Choclo Frutos del Maipo Napolitana 700 g	Choclo Frutos del Maipo Napolitana 700 g, producto familiar distribuido por Soprole.	3420	25	19	0	38	38	2026-05-21 05:16:06.685	2026-05-21 05:16:06.685	7801000001454
1586	Chicle Evercrisp Avellana 140 g	Chicle Evercrisp Avellana 140 g, producto calidad supermercado distribuido por Distribuidora Rabie.	1240	141	15	0	33	40	2026-08-14 05:16:06.685	2026-08-14 05:16:06.685	7801000001461
1587	Caramelo Trident Queso 30 g	Caramelo Trident Queso 30 g, producto con stock estable distribuido por Unilever Chile.	900	102	6	0	33	36	2026-08-24 05:16:06.685	2026-08-24 05:16:06.685	7801000001478
1588	Alfajor Ambrosoli Vainilla 100 g	Alfajor Ambrosoli Vainilla 100 g, producto formato conveniente distribuido por Coca-Cola Embonor.	650	168	12	0	33	31	2026-08-07 05:16:06.685	2026-08-07 05:16:06.685	7801000001485
1589	Jabon Rexona Antibacterial 16 unidades	Jabon Rexona Antibacterial 16 unidades, producto con stock estable distribuido por Coca-Cola Embonor.	2030	16	14	0	37	31	2026-05-10 05:16:06.685	2026-05-10 05:16:06.685	7801000001492
1590	Verduras surtidas PF Vainilla 6 unidades	Verduras surtidas PF Vainilla 6 unidades, producto con stock estable distribuido por Soprole.	11300	27	17	0	38	38	2026-04-02 05:16:06.685	2026-04-02 05:16:06.685	7801000001508
1591	Cepillo dental Kotex Menta 75 ml	Cepillo dental Kotex Menta 75 ml, producto para venta diaria distribuido por Soprole.	5280	191	17	0	37	38	2026-07-05 05:16:06.685	2026-07-05 05:16:06.685	7801000001515
1592	Detergente Poett Lavanda 750 ml	Detergente Poett Lavanda 750 ml, producto formato conveniente distribuido por Soprole.	8210	172	19	0	34	38	2026-04-20 05:16:06.685	2026-04-20 05:16:06.685	7801000001522
1593	Hamburguesa PF Tradicional 12 unidades	Hamburguesa PF Tradicional 12 unidades, producto ideal para minimarket distribuido por Coca-Cola Embonor.	2060	135	11	0	38	31	2026-04-20 05:16:06.685	2026-04-20 05:16:06.685	7801000001539
1594	Papas prefritas La Crianza Napolitana 1 kg	Papas prefritas La Crianza Napolitana 1 kg, producto seleccionado distribuido por Carozzi.	6620	19	11	0	38	37	2026-04-06 05:16:06.685	2026-04-06 05:16:06.685	7801000001546
1595	Cebolla Bio Campo Maduro 500 g	Cebolla Bio Campo Maduro 500 g, producto para venta diaria distribuido por Nestle Chile.	8000	29	10	0	39	34	2026-08-30 05:16:06.685	2026-08-30 05:16:06.685	7801000001553
1596	Bebida naranja Sprite Naranja 1 L botella	Bebida naranja Sprite Naranja 1 L botella, producto con stock estable distribuido por Soprole.	5080	20	15	0	31	38	2026-04-02 05:16:06.685	2026-04-02 05:16:06.685	7801000001560
1597	Lata gato Whiskas Adulto 8 kg	Lata gato Whiskas Adulto 8 kg, producto con stock estable distribuido por Coca-Cola Embonor.	21100	5	17	0	40	31	2026-04-16 05:16:06.685	2026-04-16 05:16:06.685	7801000001577
1598	Manzana Huerto Central Organica bandeja	Manzana Huerto Central Organica bandeja, producto con stock estable distribuido por Dimak Mayorista.	6110	13	11	0	39	39	2026-08-29 05:16:06.685	2026-08-29 05:16:06.685	7801000001584
1599	Empanada Savory Tradicional 1 kg	Empanada Savory Tradicional 1 kg, producto seleccionado distribuido por Unilever Chile.	5830	142	7	24	38	36	2026-08-18 05:16:06.685	2026-08-18 05:16:06.685	7801000001591
1600	Queso gauda Quillayes Frutilla 125 g	Queso gauda Quillayes Frutilla 125 g, producto seleccionado distribuido por Carozzi.	2810	147	10	0	35	37	2026-04-18 05:16:06.685	2026-04-18 05:16:06.685	7801000001607
1601	Suavizante Virutex Hipoalergenico 750 ml	Suavizante Virutex Hipoalergenico 750 ml, producto formato conveniente distribuido por Soprole.	6350	186	14	0	34	38	2026-08-04 05:16:06.685	2026-08-04 05:16:06.685	7801000001614
1602	Limpiador piso Nova Hipoalergenico 450 ml	Limpiador piso Nova Hipoalergenico 450 ml, producto calidad supermercado distribuido por CCU.	8030	36	18	0	34	35	2026-04-20 05:16:06.685	2026-04-20 05:16:06.685	7801000001621
1603	Palta Santa Isabel Premium 1.5 kg	Palta Santa Isabel Premium 1.5 kg, producto familiar distribuido por Coca-Cola Embonor.	7430	73	12	5	39	31	2026-03-07 05:16:06.685	2026-03-07 05:16:06.685	7801000001638
1604	Papa Campo Lindo Organica 2 kg	Papa Campo Lindo Organica 2 kg, producto con stock estable distribuido por CCU.	7540	41	9	0	39	35	2026-06-14 05:16:06.685	2026-06-14 05:16:06.685	7801000001645
1605	Papas fritas Evercrisp Menta 45 g	Papas fritas Evercrisp Menta 45 g, producto formato conveniente distribuido por Dimak Mayorista.	2470	142	6	0	33	39	2026-08-21 05:16:06.685	2026-08-21 05:16:06.685	7801000001652
1606	Bebida naranja Kem Original 2 L botella	Bebida naranja Kem Original 2 L botella, producto calidad supermercado distribuido por Unilever Chile.	12900	188	19	14	31	36	2026-05-04 05:16:06.685	2026-05-04 05:16:06.685	7801000001669
1607	Alimento perro Dog Chow Control olor 1 kg	Alimento perro Dog Chow Control olor 1 kg, producto con stock estable distribuido por Soprole.	21300	28	8	0	40	38	2026-04-04 05:16:06.685	2026-04-04 05:16:06.685	7801000001676
1608	Chocolate Nutra Bien Bitter 45 g	Chocolate Nutra Bien Bitter 45 g, producto de alta rotacion distribuido por CCU.	2470	77	20	0	33	35	2026-04-27 05:16:06.685	2026-04-27 05:16:06.685	7801000001683
1609	Pan integral La Selecta Artesanal 800 g	Pan integral La Selecta Artesanal 800 g, producto formato conveniente distribuido por Agrosuper.	2290	107	14	0	36	32	2026-04-11 05:16:06.685	2026-04-11 05:16:06.685	7801000001690
1610	Jugo nectar Sprite Limon 500 ml botella	Jugo nectar Sprite Limon 500 ml botella, producto de alta rotacion distribuido por Nestle Chile.	7230	150	13	0	31	34	2026-07-21 05:16:06.685	2026-07-21 05:16:06.685	7801000001706
1611	Azucar Lobos Con albahaca 2 kg	Azucar Lobos Con albahaca 2 kg, producto formato conveniente distribuido por Agrosuper.	7040	92	17	0	32	32	2026-07-31 05:16:06.685	2026-07-31 05:16:06.685	7801000001713
1612	Jabon Rexona Control caida 90 g	Jabon Rexona Control caida 90 g, producto familiar distribuido por Unilever Chile.	7290	157	8	0	37	36	2026-08-21 05:16:06.685	2026-08-21 05:16:06.685	7801000001720
1613	Galleta Costa Bitter 140 g	Galleta Costa Bitter 140 g, producto familiar distribuido por Carozzi.	6740	34	9	0	33	37	2026-06-14 05:16:06.685	2026-06-14 05:16:06.685	7801000001737
1614	Mantequilla Parmalat Natural 1 L	Mantequilla Parmalat Natural 1 L, producto para venta diaria distribuido por Coca-Cola Embonor.	7740	153	9	0	35	31	2026-06-18 05:16:06.685	2026-06-18 05:16:06.685	7801000001744
1615	Helado Cuisine & Co Vacuno 700 g	Helado Cuisine & Co Vacuno 700 g, producto formato conveniente distribuido por Nestle Chile.	14100	178	6	0	38	34	2026-08-10 05:16:06.685	2026-08-10 05:16:06.685	7801000001751
1616	Masa pizza Fuchs Integral 800 g	Masa pizza Fuchs Integral 800 g, producto de alta rotacion distribuido por Watt's Comercial.	3230	177	19	0	36	33	2026-05-22 05:16:06.685	2026-05-22 05:16:06.685	7801000001768
1617	Pan molde Fuchs Blanco 250 g	Pan molde Fuchs Blanco 250 g, producto seleccionado distribuido por Unilever Chile.	3830	34	13	0	36	36	2026-03-29 05:16:06.685	2026-03-29 05:16:06.685	7801000001775
1618	Agua mineral Coca-Cola Naranja 1.5 L botella	Agua mineral Coca-Cola Naranja 1.5 L botella, producto ideal para minimarket distribuido por Dimak Mayorista.	12200	130	19	15	31	39	2026-06-26 05:16:06.685	2026-06-26 05:16:06.685	7801000001782
1619	Tomate Bio Campo Maduro 3 kg	Tomate Bio Campo Maduro 3 kg, producto formato conveniente distribuido por CCU.	9630	199	5	0	39	35	2026-08-23 05:16:06.685	2026-08-23 05:16:06.685	7801000001799
1620	Chocolate Sahne Nuss Menta 250 g	Chocolate Sahne Nuss Menta 250 g, producto familiar distribuido por Coca-Cola Embonor.	3140	22	6	0	33	31	2026-04-03 05:16:06.685	2026-04-03 05:16:06.685	7801000001805
1621	Salsa de tomate Miraflores Con albahaca 1.5 kg	Salsa de tomate Miraflores Con albahaca 1.5 kg, producto con stock estable distribuido por Carozzi.	7050	79	17	12	32	37	2026-07-30 05:16:06.685	2026-07-30 05:16:06.685	7801000001812
1622	Manzana Santa Isabel Roja unidad	Manzana Santa Isabel Roja unidad, producto seleccionado distribuido por Distribuidora Rabie.	5560	191	9	23	39	40	2026-08-27 05:16:06.685	2026-08-27 05:16:06.685	7801000001829
1623	Galleta Marco Polo Avellana 45 g	Galleta Marco Polo Avellana 45 g, producto para venta diaria distribuido por Soprole.	2780	154	8	0	33	38	2026-03-26 05:16:06.685	2026-03-26 05:16:06.685	7801000001836
1624	Lechuga Campo Lindo Maduro 1.5 kg	Lechuga Campo Lindo Maduro 1.5 kg, producto con stock estable distribuido por CCU.	6820	163	13	0	39	35	2026-05-18 05:16:06.685	2026-05-18 05:16:06.685	7801000001843
1625	Hamburguesa Frutos del Maipo Queso 1 kg	Hamburguesa Frutos del Maipo Queso 1 kg, producto formato conveniente distribuido por Soprole.	4720	100	18	0	38	38	2026-05-10 05:16:06.685	2026-05-10 05:16:06.685	7801000001850
1626	Detergente Elite Hipoalergenico 1 L	Detergente Elite Hipoalergenico 1 L, producto formato conveniente distribuido por Coca-Cola Embonor.	11700	1	15	0	34	31	2026-04-20 05:16:06.685	2026-04-20 05:16:06.685	7801000001867
1627	Toalla absorbente Elite Antibacterial 900 ml	Toalla absorbente Elite Antibacterial 900 ml, producto formato conveniente distribuido por Nestle Chile.	11500	23	7	0	34	34	2026-04-14 05:16:06.685	2026-04-14 05:16:06.685	7801000001874
1628	Pan pita Fuchs Integral 400 g	Pan pita Fuchs Integral 400 g, producto ideal para minimarket distribuido por Carozzi.	2540	42	20	0	36	37	2026-09-02 05:16:06.685	2026-09-02 05:16:06.685	7801000001881
1629	Alimento perro Champion Dog Cachorro 10 kg	Alimento perro Champion Dog Cachorro 10 kg, producto familiar distribuido por Nestle Chile.	26800	173	15	0	40	34	2026-05-29 05:16:06.685	2026-05-29 05:16:06.685	7801000001898
1630	Shampoo Dove Aloe vera 350 ml	Shampoo Dove Aloe vera 350 ml, producto para venta diaria distribuido por Coca-Cola Embonor.	1460	186	5	0	37	31	2026-04-11 05:16:06.685	2026-04-11 05:16:06.685	7801000001904
1631	Bebida cola Coca-Cola Light 2.5 L botella	Bebida cola Coca-Cola Light 2.5 L botella, producto familiar distribuido por Nestle Chile.	11900	136	7	0	31	34	2026-05-08 05:16:06.685	2026-05-08 05:16:06.685	7801000001911
1632	Lentejas Chef Maravilla 1.5 kg	Lentejas Chef Maravilla 1.5 kg, producto de alta rotacion distribuido por Carozzi.	6890	6	8	0	32	37	2026-03-30 05:16:06.685	2026-03-30 05:16:06.685	7801000001928
1633	Yogur Soprole Entera 1 kg	Yogur Soprole Entera 1 kg, producto formato conveniente distribuido por Unilever Chile.	4710	141	20	0	35	36	2026-06-09 05:16:06.685	2026-06-09 05:16:06.685	7801000001935
1634	Bebida energetica Red Bull Naranja 6 x 350 ml	Bebida energetica Red Bull Naranja 6 x 350 ml, producto ideal para minimarket distribuido por Coca-Cola Embonor.	4600	76	7	0	31	31	2026-08-16 05:16:06.685	2026-08-16 05:16:06.685	7801000001942
1636	Pan integral Cuisine & Co Artesanal 800 g	Pan integral Cuisine & Co Artesanal 800 g, producto formato conveniente distribuido por Coca-Cola Embonor.	4830	182	13	0	36	31	2026-07-17 05:16:06.685	2026-07-17 05:16:06.685	7801000001966
1637	Bebida lima limon Vital Original 350 ml lata	Bebida lima limon Vital Original 350 ml lata, producto de alta rotacion distribuido por Coca-Cola Embonor.	7070	27	19	0	31	31	2026-06-23 05:16:06.685	2026-06-23 05:16:06.685	7801000001973
1638	Cebolla Fruta Sur Nacional 1 kg	Cebolla Fruta Sur Nacional 1 kg, producto de alta rotacion distribuido por Watt's Comercial.	1060	45	6	0	39	33	2026-08-06 05:16:06.685	2026-08-06 05:16:06.685	7801000001980
1639	Agua saborizada Kem Naranja 12 x 350 ml	Agua saborizada Kem Naranja 12 x 350 ml, producto formato conveniente distribuido por Agrosuper.	2400	49	12	0	31	32	2026-03-23 05:16:06.685	2026-03-23 05:16:06.685	7801000001997
1640	Detergente Omo Concentrado 1 L	Detergente Omo Concentrado 1 L, producto calidad supermercado distribuido por Coca-Cola Embonor.	12300	41	12	0	34	31	2026-08-18 05:16:06.685	2026-08-18 05:16:06.685	7801000002000
1641	Detergente Nova Aroma floral 1.5 L	Detergente Nova Aroma floral 1.5 L, producto formato conveniente distribuido por Carozzi.	6100	180	18	0	34	37	2026-04-21 05:16:06.685	2026-04-21 05:16:06.685	7801000002017
1642	Shampoo mascota Master Dog Senior 1 kg	Shampoo mascota Master Dog Senior 1 kg, producto ideal para minimarket distribuido por Agrosuper.	26800	54	14	0	40	32	2026-04-10 05:16:06.685	2026-04-10 05:16:06.685	7801000002024
1643	Toalla absorbente Poett Ultra 1 L	Toalla absorbente Poett Ultra 1 L, producto para venta diaria distribuido por Dimak Mayorista.	5730	161	16	0	34	39	2026-05-12 05:16:06.685	2026-05-12 05:16:06.685	7801000002031
1644	Suavizante Clorinda Ultra 450 ml	Suavizante Clorinda Ultra 450 ml, producto seleccionado distribuido por Agrosuper.	5150	41	14	0	34	32	2026-08-02 05:16:06.685	2026-08-02 05:16:06.685	7801000002048
1645	Pizza Tarragona Vacuno 12 unidades	Pizza Tarragona Vacuno 12 unidades, producto familiar distribuido por Coca-Cola Embonor.	6710	4	7	0	38	31	2026-08-08 05:16:06.685	2026-08-08 05:16:06.685	7801000002055
1646	Sal Banquete Tradicional 5 kg	Sal Banquete Tradicional 5 kg, producto ideal para minimarket distribuido por Watt's Comercial.	13000	154	12	0	32	33	2026-07-12 05:16:06.685	2026-07-12 05:16:06.685	7801000002062
1647	Lechuga Valle Verde Nacional 2 kg	Lechuga Valle Verde Nacional 2 kg, producto para venta diaria distribuido por Distribuidora Rabie.	1020	102	18	0	39	40	2026-04-08 05:16:06.685	2026-04-08 05:16:06.685	7801000002079
1648	Crema de leche Nestle Entera 900 g	Crema de leche Nestle Entera 900 g, producto ideal para minimarket distribuido por Nestle Chile.	7950	83	20	0	35	34	2026-04-14 05:16:06.685	2026-04-14 05:16:06.685	7801000002086
1649	Agua mineral Andina Limon 12 x 350 ml	Agua mineral Andina Limon 12 x 350 ml, producto seleccionado distribuido por Unilever Chile.	3440	13	20	0	31	36	2026-04-03 05:16:06.685	2026-04-03 05:16:06.685	7801000002093
1650	Masa pizza Fuchs Tradicional 400 g	Masa pizza Fuchs Tradicional 400 g, producto con stock estable distribuido por Agrosuper.	4450	189	13	0	36	32	2026-05-21 05:16:06.685	2026-05-21 05:16:06.685	7801000002109
1651	Cepillo dental Rexona Menta 16 unidades	Cepillo dental Rexona Menta 16 unidades, producto calidad supermercado distribuido por Watt's Comercial.	7060	27	16	0	37	33	2026-05-03 05:16:06.685	2026-05-03 05:16:06.685	7801000002116
1652	Quesillo Parmalat Descremada 500 g	Quesillo Parmalat Descremada 500 g, producto con stock estable distribuido por Dimak Mayorista.	5200	171	11	0	35	39	2026-07-10 05:16:06.685	2026-07-10 05:16:06.685	7801000002123
1653	Chocolate Marco Polo Frutilla 12 unidades	Chocolate Marco Polo Frutilla 12 unidades, producto para venta diaria distribuido por Soprole.	4660	175	11	0	33	38	2026-08-29 05:16:06.685	2026-08-29 05:16:06.685	7801000002130
1654	Masa pizza San Camilo Tradicional 500 g	Masa pizza San Camilo Tradicional 500 g, producto con stock estable distribuido por Agrosuper.	1170	129	6	0	36	32	2026-08-23 05:16:06.685	2026-08-23 05:16:06.685	7801000002147
1655	Arroz Lobos Canola 1.5 kg	Arroz Lobos Canola 1.5 kg, producto de alta rotacion distribuido por Coca-Cola Embonor.	2040	72	16	0	32	31	2026-03-21 05:16:06.685	2026-03-21 05:16:06.685	7801000002154
1656	Agua saborizada Fanta Light 500 ml botella	Agua saborizada Fanta Light 500 ml botella, producto seleccionado distribuido por Dimak Mayorista.	11700	100	17	0	31	39	2026-06-25 05:16:06.685	2026-06-25 05:16:06.685	7801000002161
1657	Shampoo mascota Pedigree Pescado 10 kg	Shampoo mascota Pedigree Pescado 10 kg, producto calidad supermercado distribuido por Watt's Comercial.	20200	192	9	0	40	33	2026-03-28 05:16:06.685	2026-03-28 05:16:06.685	7801000002178
1658	Hueso carnaza Champion Dog Pollo 85 g	Hueso carnaza Champion Dog Pollo 85 g, producto ideal para minimarket distribuido por Coca-Cola Embonor.	8800	198	7	0	40	31	2026-06-02 05:16:06.685	2026-06-02 05:16:06.685	7801000002185
1659	Alimento perro Pedigree Control olor 15 kg	Alimento perro Pedigree Control olor 15 kg, producto con stock estable distribuido por Carozzi.	6580	31	11	14	40	37	2026-06-10 05:16:06.685	2026-06-10 05:16:06.685	7801000002192
1660	Crema de leche Colun Descremada 125 g	Crema de leche Colun Descremada 125 g, producto con stock estable distribuido por Nestle Chile.	6610	13	11	0	35	34	2026-06-17 05:16:06.685	2026-06-17 05:16:06.685	7801000002208
1661	Platano Campo Lindo Premium 3 kg	Platano Campo Lindo Premium 3 kg, producto ideal para minimarket distribuido por Watt's Comercial.	4160	152	17	0	39	33	2026-07-03 05:16:06.685	2026-07-03 05:16:06.685	7801000002215
1662	Hallulla Tarragona Vainilla 600 g	Hallulla Tarragona Vainilla 600 g, producto seleccionado distribuido por Soprole.	1390	124	5	0	36	38	2026-08-27 05:16:06.685	2026-08-27 05:16:06.685	7801000002222
1663	Quesillo Soprole Descremada 250 g	Quesillo Soprole Descremada 250 g, producto calidad supermercado distribuido por Unilever Chile.	6670	46	5	14	35	36	2026-04-03 05:16:06.685	2026-04-03 05:16:06.685	7801000002239
1664	Salsa de tomate Lucchetti Maravilla 2 kg	Salsa de tomate Lucchetti Maravilla 2 kg, producto de alta rotacion distribuido por Nestle Chile.	10300	80	15	0	32	34	2026-04-26 05:16:06.685	2026-04-26 05:16:06.685	7801000002246
1665	Pan integral Tarragona Vainilla 600 g	Pan integral Tarragona Vainilla 600 g, producto ideal para minimarket distribuido por Coca-Cola Embonor.	4130	164	14	0	36	31	2026-08-22 05:16:06.685	2026-08-22 05:16:06.685	7801000002253
1667	Platano Fruta Sur Maduro bandeja	Platano Fruta Sur Maduro bandeja, producto para venta diaria distribuido por Nestle Chile.	5870	128	13	0	39	34	2026-03-14 05:16:06.685	2026-03-14 05:16:06.685	7801000002277
1668	Shampoo mascota Whiskas Cachorro 100 g	Shampoo mascota Whiskas Cachorro 100 g, producto calidad supermercado distribuido por Nestle Chile.	31900	21	10	0	40	34	2026-06-14 05:16:06.685	2026-06-14 05:16:06.685	7801000002284
1669	Alcohol gel Head & Shoulders Invisible 90 g	Alcohol gel Head & Shoulders Invisible 90 g, producto de alta rotacion distribuido por Carozzi.	7810	94	7	0	37	37	2026-06-19 05:16:06.685	2026-06-19 05:16:06.685	7801000002291
1670	Verduras surtidas Frutos del Maipo Napolitana 1.5 kg	Verduras surtidas Frutos del Maipo Napolitana 1.5 kg, producto formato conveniente distribuido por Watt's Comercial.	5520	187	17	0	38	33	2026-08-27 05:16:06.685	2026-08-27 05:16:06.685	7801000002307
1671	Lavalozas Comfort Lavanda 900 ml	Lavalozas Comfort Lavanda 900 ml, producto formato conveniente distribuido por Dimak Mayorista.	1310	181	8	0	34	39	2026-08-02 05:16:06.685	2026-08-02 05:16:06.685	7801000002314
1672	Detergente Clorinda Lavanda 1.5 L	Detergente Clorinda Lavanda 1.5 L, producto ideal para minimarket distribuido por Carozzi.	1690	109	6	0	34	37	2026-09-02 05:16:06.685	2026-09-02 05:16:06.685	7801000002321
1673	Acondicionador Colgate Antibacterial 16 unidades	Acondicionador Colgate Antibacterial 16 unidades, producto de alta rotacion distribuido por CCU.	2440	124	11	0	37	35	2026-08-11 05:16:06.685	2026-08-11 05:16:06.685	7801000002338
1674	Choclo San Jorge Vainilla 6 unidades	Choclo San Jorge Vainilla 6 unidades, producto seleccionado distribuido por Soprole.	4520	120	16	0	38	38	2026-07-13 05:16:06.685	2026-07-13 05:16:06.685	7801000002345
1675	Lavalozas Clorinda Limon 450 ml	Lavalozas Clorinda Limon 450 ml, producto de alta rotacion distribuido por Soprole.	7690	59	16	0	34	38	2026-05-13 05:16:06.685	2026-05-13 05:16:06.685	7801000002352
1676	Toalla absorbente Virutex Aroma floral 3 L	Toalla absorbente Virutex Aroma floral 3 L, producto familiar distribuido por Watt's Comercial.	15000	33	15	0	34	33	2026-07-14 05:16:06.685	2026-07-14 05:16:06.685	7801000002369
1677	Postre lacteo Loncoleche Natural 170 g	Postre lacteo Loncoleche Natural 170 g, producto calidad supermercado distribuido por Distribuidora Rabie.	4850	73	14	0	35	40	2026-06-25 05:16:06.685	2026-06-25 05:16:06.685	7801000002376
1679	Arena sanitaria Pedigree Piel sensible 1 kg	Arena sanitaria Pedigree Piel sensible 1 kg, producto con stock estable distribuido por Carozzi.	17800	64	17	0	40	37	2026-07-24 05:16:06.685	2026-07-24 05:16:06.685	7801000002390
1681	Lavalozas Clorinda Hipoalergenico 900 ml	Lavalozas Clorinda Hipoalergenico 900 ml, producto para venta diaria distribuido por Unilever Chile.	15400	95	8	0	34	36	2026-03-16 05:16:06.685	2026-03-16 05:16:06.685	7801000002413
1682	Caramelo Evercrisp Avellana 45 g	Caramelo Evercrisp Avellana 45 g, producto para venta diaria distribuido por CCU.	6070	125	20	0	33	35	2026-08-21 05:16:06.685	2026-08-21 05:16:06.685	7801000002420
1683	Collar Fit Formula Senior 15 kg	Collar Fit Formula Senior 15 kg, producto familiar distribuido por Distribuidora Rabie.	14700	61	19	25	40	40	2026-06-09 05:16:06.685	2026-06-09 05:16:06.685	7801000002437
1684	Snack perro Pedigree Carne 100 g	Snack perro Pedigree Carne 100 g, producto ideal para minimarket distribuido por Distribuidora Rabie.	30900	170	17	0	40	40	2026-06-23 05:16:06.685	2026-06-23 05:16:06.685	7801000002444
1685	Tomate Santa Isabel Malla 5 kg	Tomate Santa Isabel Malla 5 kg, producto para venta diaria distribuido por Watt's Comercial.	9230	95	10	0	39	33	2026-05-29 05:16:06.685	2026-05-29 05:16:06.685	7801000002451
1686	Limpiador piso Nova Hipoalergenico 900 ml	Limpiador piso Nova Hipoalergenico 900 ml, producto familiar distribuido por Distribuidora Rabie.	9860	169	9	0	34	40	2026-06-05 05:16:06.685	2026-06-05 05:16:06.685	7801000002468
1687	Ramitas Costa Queso 85 g	Ramitas Costa Queso 85 g, producto ideal para minimarket distribuido por Dimak Mayorista.	1480	195	19	0	33	39	2026-07-28 05:16:06.685	2026-07-28 05:16:06.685	7801000002475
1688	Alimento gato Dog Chow Control olor 100 g	Alimento gato Dog Chow Control olor 100 g, producto seleccionado distribuido por Dimak Mayorista.	10200	182	20	0	40	39	2026-07-22 05:16:06.685	2026-07-22 05:16:06.685	7801000002482
1689	Masa pizza Cuisine & Co Multigrano 500 g	Masa pizza Cuisine & Co Multigrano 500 g, producto para venta diaria distribuido por Unilever Chile.	3140	76	7	0	36	36	2026-07-06 05:16:06.685	2026-07-06 05:16:06.685	7801000002499
1690	Bebida cola Kem Naranja 500 ml botella	Bebida cola Kem Naranja 500 ml botella, producto familiar distribuido por Soprole.	10100	34	5	0	31	38	2026-05-15 05:16:06.685	2026-05-15 05:16:06.685	7801000002505
1691	Manjar Parmalat Light 125 g	Manjar Parmalat Light 125 g, producto de alta rotacion distribuido por Soprole.	3200	34	11	0	35	38	2026-07-11 05:16:06.685	2026-07-11 05:16:06.685	7801000002512
1692	Manjar Quillayes Light 250 g	Manjar Quillayes Light 250 g, producto para venta diaria distribuido por Agrosuper.	1840	66	11	0	35	32	2026-06-14 05:16:06.685	2026-06-14 05:16:06.685	7801000002529
1693	Empanada Savory Queso 700 g	Empanada Savory Queso 700 g, producto formato conveniente distribuido por Soprole.	4810	85	20	0	38	38	2026-07-14 05:16:06.685	2026-07-14 05:16:06.685	7801000002536
1694	Papel higienico Poett Limon 12 unidades	Papel higienico Poett Limon 12 unidades, producto con stock estable distribuido por Distribuidora Rabie.	5490	4	16	0	34	40	2026-07-08 05:16:06.685	2026-07-08 05:16:06.685	7801000002543
1695	Hueso carnaza Pedigree Adulto 1 kg	Hueso carnaza Pedigree Adulto 1 kg, producto con stock estable distribuido por Coca-Cola Embonor.	18700	58	8	0	40	31	2026-05-11 05:16:06.685	2026-05-11 05:16:06.685	7801000002550
1697	Crema de leche Quillayes Sin lactosa 1 L	Crema de leche Quillayes Sin lactosa 1 L, producto formato conveniente distribuido por Nestle Chile.	5790	138	11	0	35	34	2026-06-27 05:16:06.685	2026-06-27 05:16:06.685	7801000002574
1698	Pizza Savory Queso 1.5 kg	Pizza Savory Queso 1.5 kg, producto para venta diaria distribuido por Watt's Comercial.	4650	181	7	0	38	33	2026-08-06 05:16:06.685	2026-08-06 05:16:06.685	7801000002581
1699	Lata gato Doko Pollo 15 kg	Lata gato Doko Pollo 15 kg, producto ideal para minimarket distribuido por Agrosuper.	34600	104	15	0	40	32	2026-06-02 05:16:06.685	2026-06-02 05:16:06.685	7801000002598
1701	Bebida naranja Sprite Light 1 L botella	Bebida naranja Sprite Light 1 L botella, producto para venta diaria distribuido por Watt's Comercial.	10400	181	14	0	31	33	2026-06-17 05:16:06.685	2026-06-17 05:16:06.685	7801000002611
1702	Arroz Tucapel Grado 1 2 kg	Arroz Tucapel Grado 1 2 kg, producto formato conveniente distribuido por Unilever Chile.	2740	29	6	0	32	36	2026-07-11 05:16:06.685	2026-07-11 05:16:06.685	7801000002628
1703	Arena sanitaria Pedigree Pescado 500 g	Arena sanitaria Pedigree Pescado 500 g, producto familiar distribuido por Dimak Mayorista.	10900	23	16	0	40	39	2026-04-12 05:16:06.685	2026-04-12 05:16:06.685	7801000002635
1704	Pan integral Cuisine & Co Vainilla 6 unidades	Pan integral Cuisine & Co Vainilla 6 unidades, producto calidad supermercado distribuido por Dimak Mayorista.	2280	178	8	0	36	39	2026-04-27 05:16:06.685	2026-04-27 05:16:06.685	7801000002642
1705	Mantequilla Loncoleche Frutilla 170 g	Mantequilla Loncoleche Frutilla 170 g, producto para venta diaria distribuido por Soprole.	6620	56	19	0	35	38	2026-05-24 05:16:06.685	2026-05-24 05:16:06.685	7801000002659
1706	Crema de leche Loncoleche Natural 125 g	Crema de leche Loncoleche Natural 125 g, producto familiar distribuido por Dimak Mayorista.	6060	130	13	0	35	39	2026-05-11 05:16:06.685	2026-05-11 05:16:06.685	7801000002666
1707	Bebida energetica Red Bull Zero 1 L botella	Bebida energetica Red Bull Zero 1 L botella, producto seleccionado distribuido por Unilever Chile.	8940	191	12	0	31	36	2026-08-11 05:16:06.685	2026-08-11 05:16:06.685	7801000002673
1708	Choclo Cuisine & Co Queso 6 unidades	Choclo Cuisine & Co Queso 6 unidades, producto con stock estable distribuido por Carozzi.	3520	197	7	0	38	37	2026-03-25 05:16:06.685	2026-03-25 05:16:06.685	7801000002680
1709	Caramelo Nutra Bien Avellana 250 g	Caramelo Nutra Bien Avellana 250 g, producto seleccionado distribuido por Agrosuper.	400	38	13	0	33	32	2026-05-05 05:16:06.685	2026-05-05 05:16:06.685	7801000002697
1710	Te helado Watts Limon 6 x 350 ml	Te helado Watts Limon 6 x 350 ml, producto calidad supermercado distribuido por CCU.	11500	180	18	0	31	35	2026-06-06 05:16:06.685	2026-06-06 05:16:06.685	7801000002703
1711	Platano Valle Verde Malla 5 kg	Platano Valle Verde Malla 5 kg, producto con stock estable distribuido por Unilever Chile.	650	155	6	0	39	36	2026-07-28 05:16:06.685	2026-07-28 05:16:06.685	7801000002710
1712	Alimento perro Whiskas Pollo 3 kg	Alimento perro Whiskas Pollo 3 kg, producto calidad supermercado distribuido por CCU.	20300	31	9	17	40	35	2026-04-02 05:16:06.685	2026-04-02 05:16:06.685	7801000002727
1713	Alcohol gel Pepsodent Sensitive 75 ml	Alcohol gel Pepsodent Sensitive 75 ml, producto familiar distribuido por Agrosuper.	5580	107	20	0	37	32	2026-04-03 05:16:06.685	2026-04-03 05:16:06.685	7801000002734
1714	Barra cereal Ambrosoli Chocolate 180 g	Barra cereal Ambrosoli Chocolate 180 g, producto familiar distribuido por Agrosuper.	2700	178	19	0	33	32	2026-07-29 05:16:06.685	2026-07-29 05:16:06.685	7801000002741
1715	Ramitas Nutra Bien Avellana 45 g	Ramitas Nutra Bien Avellana 45 g, producto seleccionado distribuido por Watt's Comercial.	2780	121	8	0	33	33	2026-06-10 05:16:06.685	2026-06-10 05:16:06.685	7801000002758
1716	Cebolla Huerto Central Primera seleccion 3 kg	Cebolla Huerto Central Primera seleccion 3 kg, producto seleccionado distribuido por Agrosuper.	3110	66	17	0	39	32	2026-07-29 05:16:06.685	2026-07-29 05:16:06.685	7801000002765
1717	Shampoo mascota Fit Formula Cachorro 3 kg	Shampoo mascota Fit Formula Cachorro 3 kg, producto de alta rotacion distribuido por Unilever Chile.	12600	88	6	0	40	36	2026-04-15 05:16:06.685	2026-04-15 05:16:06.685	7801000002772
1718	Choclo PF Familiar 1.5 kg	Choclo PF Familiar 1.5 kg, producto con stock estable distribuido por CCU.	2830	3	7	0	38	35	2026-04-11 05:16:06.685	2026-04-11 05:16:06.685	7801000002789
1719	Yogur Parmalat Light 1 kg	Yogur Parmalat Light 1 kg, producto ideal para minimarket distribuido por CCU.	4470	159	6	0	35	35	2026-04-07 05:16:06.685	2026-04-07 05:16:06.685	7801000002796
1720	Lata gato Champion Dog Piel sensible 8 kg	Lata gato Champion Dog Piel sensible 8 kg, producto familiar distribuido por Watt's Comercial.	7410	68	8	0	40	33	2026-03-31 05:16:06.685	2026-03-31 05:16:06.685	7801000002802
1721	Cloro Poett Ultra 1 L	Cloro Poett Ultra 1 L, producto seleccionado distribuido por Agrosuper.	4800	100	9	0	34	32	2026-06-29 05:16:06.685	2026-06-29 05:16:06.685	7801000002819
1722	Nuggets Minuto Verde Queso 1 kg	Nuggets Minuto Verde Queso 1 kg, producto con stock estable distribuido por Unilever Chile.	12700	154	20	0	38	36	2026-06-30 05:16:06.685	2026-06-30 05:16:06.685	7801000002826
1723	Queque Ideal Chocolate 400 g	Queque Ideal Chocolate 400 g, producto con stock estable distribuido por Unilever Chile.	3320	33	18	0	36	36	2026-06-24 05:16:06.685	2026-06-24 05:16:06.685	7801000002833
1724	Chicle Nutra Bien Frutilla 140 g	Chicle Nutra Bien Frutilla 140 g, producto seleccionado distribuido por Nestle Chile.	660	101	17	21	33	34	2026-05-13 05:16:06.685	2026-05-13 05:16:06.685	7801000002840
1725	Snack perro Fit Formula Cachorro 1 kg	Snack perro Fit Formula Cachorro 1 kg, producto familiar distribuido por Nestle Chile.	14900	13	16	0	40	34	2026-05-22 05:16:06.685	2026-05-22 05:16:06.685	7801000002857
1726	Suavizante Elite Ultra 1 L	Suavizante Elite Ultra 1 L, producto familiar distribuido por Coca-Cola Embonor.	11500	140	15	0	34	31	2026-06-13 05:16:06.685	2026-06-13 05:16:06.685	7801000002864
1727	Nuggets La Crianza Primavera 1 kg	Nuggets La Crianza Primavera 1 kg, producto seleccionado distribuido por Soprole.	2900	75	19	0	38	38	2026-07-14 05:16:06.685	2026-07-14 05:16:06.685	7801000002871
1728	Jabon Rexona Control caida 16 unidades	Jabon Rexona Control caida 16 unidades, producto seleccionado distribuido por Distribuidora Rabie.	3710	85	5	0	37	40	2026-04-26 05:16:06.685	2026-04-26 05:16:06.685	7801000002888
1729	Yogur Soprole Sin lactosa 1 kg	Yogur Soprole Sin lactosa 1 kg, producto familiar distribuido por Distribuidora Rabie.	5730	144	14	0	35	40	2026-08-13 05:16:06.685	2026-08-13 05:16:06.685	7801000002895
1730	Papa Bio Campo Malla unidad	Papa Bio Campo Malla unidad, producto calidad supermercado distribuido por Agrosuper.	3340	143	10	0	39	32	2026-06-11 05:16:06.685	2026-06-11 05:16:06.685	7801000002901
1731	Alcohol gel Kotex Original 150 ml	Alcohol gel Kotex Original 150 ml, producto con stock estable distribuido por Soprole.	7070	128	14	0	37	38	2026-04-13 05:16:06.685	2026-04-13 05:16:06.685	7801000002918
1732	Desodorante Kotex Antibacterial 75 ml	Desodorante Kotex Antibacterial 75 ml, producto calidad supermercado distribuido por Dimak Mayorista.	8840	62	17	0	37	39	2026-07-17 05:16:06.685	2026-07-17 05:16:06.685	7801000002925
1733	Snack perro Doko Senior 500 g	Snack perro Doko Senior 500 g, producto con stock estable distribuido por Coca-Cola Embonor.	8900	92	12	0	40	31	2026-05-07 05:16:06.685	2026-05-07 05:16:06.685	7801000002932
1734	Chicle Sahne Nuss Frutilla 180 g	Chicle Sahne Nuss Frutilla 180 g, producto con stock estable distribuido por Carozzi.	6550	105	7	0	33	37	2026-07-26 05:16:06.685	2026-07-26 05:16:06.685	7801000002949
1735	Shampoo Nivea Original 90 g	Shampoo Nivea Original 90 g, producto familiar distribuido por Distribuidora Rabie.	4730	179	10	0	37	40	2026-04-09 05:16:06.685	2026-04-09 05:16:06.685	7801000002956
1736	Bebida energetica Sprite Zero 1.5 L botella	Bebida energetica Sprite Zero 1.5 L botella, producto seleccionado distribuido por Soprole.	2840	146	12	0	31	38	2026-05-02 05:16:06.685	2026-05-02 05:16:06.685	7801000002963
1737	Suavizante Poett Concentrado 6 unidades	Suavizante Poett Concentrado 6 unidades, producto de alta rotacion distribuido por Watt's Comercial.	7920	64	17	0	34	33	2026-05-19 05:16:06.685	2026-05-19 05:16:06.685	7801000002970
1738	Manjar Parmalat Descremada 1 L	Manjar Parmalat Descremada 1 L, producto con stock estable distribuido por Carozzi.	7660	41	7	0	35	37	2026-03-08 05:16:06.685	2026-03-08 05:16:06.685	7801000002987
1739	Desinfectante Poett Hipoalergenico 6 unidades	Desinfectante Poett Hipoalergenico 6 unidades, producto formato conveniente distribuido por Carozzi.	12000	92	19	0	34	37	2026-08-11 05:16:06.685	2026-08-11 05:16:06.685	7801000002994
1740	Chicle Ambrosoli Vainilla 250 g	Chicle Ambrosoli Vainilla 250 g, producto para venta diaria distribuido por Watt's Comercial.	5780	20	9	0	33	33	2026-06-12 05:16:06.685	2026-06-12 05:16:06.685	7801000003007
1741	Lavalozas Nova Concentrado 750 ml	Lavalozas Nova Concentrado 750 ml, producto familiar distribuido por Carozzi.	10100	38	17	0	34	37	2026-08-15 05:16:06.685	2026-08-15 05:16:06.685	7801000003014
1742	Alcohol gel Head & Shoulders Control caida 400 ml	Alcohol gel Head & Shoulders Control caida 400 ml, producto familiar distribuido por Soprole.	2930	95	12	0	37	38	2026-06-07 05:16:06.685	2026-06-07 05:16:06.685	7801000003021
1743	Postre lacteo Soprole Protein 6 unidades	Postre lacteo Soprole Protein 6 unidades, producto con stock estable distribuido por Unilever Chile.	6370	137	16	0	35	36	2026-03-16 05:16:06.685	2026-03-16 05:16:06.685	7801000003038
1744	Fideos Iansa Libre de gluten 1.5 kg	Fideos Iansa Libre de gluten 1.5 kg, producto ideal para minimarket distribuido por Dimak Mayorista.	3150	139	6	0	32	39	2026-05-20 05:16:06.685	2026-05-20 05:16:06.685	7801000003045
1745	Desinfectante Quix Aroma floral 900 ml	Desinfectante Quix Aroma floral 900 ml, producto de alta rotacion distribuido por Agrosuper.	10500	42	15	0	34	32	2026-08-25 05:16:06.685	2026-08-25 05:16:06.685	7801000003052
1746	Queso gauda Surlat Sin lactosa 250 g	Queso gauda Surlat Sin lactosa 250 g, producto con stock estable distribuido por Unilever Chile.	5600	118	9	0	35	36	2026-05-29 05:16:06.685	2026-05-29 05:16:06.685	7801000003069
1747	Marraqueta Ideal Blanco 6 unidades	Marraqueta Ideal Blanco 6 unidades, producto ideal para minimarket distribuido por Soprole.	2270	41	11	0	36	38	2026-04-09 05:16:06.685	2026-04-09 05:16:06.685	7801000003076
1748	Bebida cola Andina Sin azucar 12 x 350 ml	Bebida cola Andina Sin azucar 12 x 350 ml, producto de alta rotacion distribuido por Watt's Comercial.	6990	40	15	0	31	33	2026-08-15 05:16:06.685	2026-08-15 05:16:06.685	7801000003083
1749	Collar Pedigree Adulto 10 kg	Collar Pedigree Adulto 10 kg, producto con stock estable distribuido por Carozzi.	11100	95	19	14	40	37	2026-04-16 05:16:06.685	2026-04-16 05:16:06.685	7801000003090
1750	Jugo nectar Watts Light 12 x 350 ml	Jugo nectar Watts Light 12 x 350 ml, producto ideal para minimarket distribuido por CCU.	1290	26	17	0	31	35	2026-08-30 05:16:06.685	2026-08-30 05:16:06.685	7801000003106
1751	Salsa de tomate Tucapel Libre de gluten 750 g	Salsa de tomate Tucapel Libre de gluten 750 g, producto familiar distribuido por Watt's Comercial.	8140	160	13	0	32	33	2026-06-02 05:16:06.685	2026-06-02 05:16:06.685	7801000003113
1752	Sal Lucchetti Tradicional 750 g	Sal Lucchetti Tradicional 750 g, producto calidad supermercado distribuido por Distribuidora Rabie.	1950	109	13	0	32	40	2026-03-31 05:16:06.685	2026-03-31 05:16:06.685	7801000003120
1753	Agua mineral Coca-Cola Light 2.5 L botella	Agua mineral Coca-Cola Light 2.5 L botella, producto para venta diaria distribuido por Unilever Chile.	1350	51	20	0	31	36	2026-03-31 05:16:06.685	2026-03-31 05:16:06.685	7801000003137
1754	Zanahoria Agro Maule Organica 1 kg	Zanahoria Agro Maule Organica 1 kg, producto formato conveniente distribuido por Soprole.	1870	130	8	0	39	38	2026-07-27 05:16:06.685	2026-07-27 05:16:06.685	7801000003144
1756	Alimento gato Champion Dog Carne 100 g	Alimento gato Champion Dog Carne 100 g, producto de alta rotacion distribuido por Dimak Mayorista.	32600	110	5	0	40	39	2026-06-12 05:16:06.685	2026-06-12 05:16:06.685	7801000003168
1757	Queque Ideal Chocolate 500 g	Queque Ideal Chocolate 500 g, producto para venta diaria distribuido por Soprole.	2340	176	11	0	36	38	2026-05-17 05:16:06.685	2026-05-17 05:16:06.685	7801000003175
1758	Masa pizza Kingsbury Integral 500 g	Masa pizza Kingsbury Integral 500 g, producto familiar distribuido por Nestle Chile.	2490	26	12	0	36	34	2026-05-20 05:16:06.685	2026-05-20 05:16:06.685	7801000003182
1759	Tortilla San Camilo Sin azucar 700 g	Tortilla San Camilo Sin azucar 700 g, producto calidad supermercado distribuido por Nestle Chile.	4940	14	16	0	36	34	2026-05-02 05:16:06.685	2026-05-02 05:16:06.685	7801000003199
1760	Chocolate Nutra Bien Vainilla 180 g	Chocolate Nutra Bien Vainilla 180 g, producto familiar distribuido por Soprole.	410	124	8	0	33	38	2026-06-01 05:16:06.685	2026-06-01 05:16:06.685	7801000003205
1761	Postre lacteo Nestle Descremada 900 g	Postre lacteo Nestle Descremada 900 g, producto de alta rotacion distribuido por Carozzi.	4840	177	20	17	35	37	2026-07-10 05:16:06.685	2026-07-10 05:16:06.685	7801000003212
1762	Fideos Miraflores Maravilla 5 kg	Fideos Miraflores Maravilla 5 kg, producto familiar distribuido por CCU.	6770	12	5	0	32	35	2026-05-25 05:16:06.685	2026-05-25 05:16:06.685	7801000003229
1763	Suavizante Virutex Ultra 3 L	Suavizante Virutex Ultra 3 L, producto formato conveniente distribuido por Distribuidora Rabie.	9840	178	13	0	34	40	2026-04-07 05:16:06.685	2026-04-07 05:16:06.685	7801000003236
1764	Desinfectante Clorinda Concentrado 3 L	Desinfectante Clorinda Concentrado 3 L, producto calidad supermercado distribuido por Agrosuper.	7440	106	17	0	34	32	2026-03-09 05:16:06.685	2026-03-09 05:16:06.685	7801000003243
1765	Papas fritas Costa Bitter 100 g	Papas fritas Costa Bitter 100 g, producto ideal para minimarket distribuido por Agrosuper.	4060	54	5	0	33	32	2026-06-26 05:16:06.685	2026-06-26 05:16:06.685	7801000003250
1766	Arroz Lobos Tradicional 1.5 kg	Arroz Lobos Tradicional 1.5 kg, producto seleccionado distribuido por Nestle Chile.	11400	116	10	0	32	34	2026-08-26 05:16:06.685	2026-08-26 05:16:06.685	7801000003267
1767	Pan molde Cuisine & Co Integral 250 g	Pan molde Cuisine & Co Integral 250 g, producto con stock estable distribuido por Nestle Chile.	2880	165	12	0	36	34	2026-05-24 05:16:06.685	2026-05-24 05:16:06.685	7801000003274
1768	Lavalozas Omo Hipoalergenico 6 unidades	Lavalozas Omo Hipoalergenico 6 unidades, producto formato conveniente distribuido por Dimak Mayorista.	8180	38	16	0	34	39	2026-08-03 05:16:06.685	2026-08-03 05:16:06.685	7801000003281
1769	Galleta Nutra Bien Chocolate 45 g	Galleta Nutra Bien Chocolate 45 g, producto de alta rotacion distribuido por Agrosuper.	5820	88	7	0	33	32	2026-06-23 05:16:06.685	2026-06-23 05:16:06.685	7801000003298
1770	Lechuga Bio Campo Malla 3 kg	Lechuga Bio Campo Malla 3 kg, producto con stock estable distribuido por Agrosuper.	6910	99	16	0	39	32	2026-04-02 05:16:06.685	2026-04-02 05:16:06.685	7801000003304
1771	Shampoo Nivea Antibacterial 250 ml	Shampoo Nivea Antibacterial 250 ml, producto seleccionado distribuido por CCU.	8960	141	20	0	37	35	2026-04-02 05:16:06.685	2026-04-02 05:16:06.685	7801000003311
1772	Tortilla La Selecta Blanco 700 g	Tortilla La Selecta Blanco 700 g, producto ideal para minimarket distribuido por Distribuidora Rabie.	4640	144	7	0	36	40	2026-06-06 05:16:06.685	2026-06-06 05:16:06.685	7801000003328
1773	Arroz Tucapel Canola 200 g	Arroz Tucapel Canola 200 g, producto ideal para minimarket distribuido por Carozzi.	9540	127	18	0	32	37	2026-03-06 05:16:06.685	2026-03-06 05:16:06.685	7801000003335
1774	Choclo La Crianza Primavera 400 g	Choclo La Crianza Primavera 400 g, producto de alta rotacion distribuido por Carozzi.	6850	30	19	0	38	37	2026-06-09 05:16:06.685	2026-06-09 05:16:06.685	7801000003342
1775	Bebida energetica Watts Light 500 ml botella	Bebida energetica Watts Light 500 ml botella, producto ideal para minimarket distribuido por Coca-Cola Embonor.	10000	35	18	0	31	31	2026-08-31 05:16:06.685	2026-08-31 05:16:06.685	7801000003359
1776	Platano Valle Verde Nacional unidad	Platano Valle Verde Nacional unidad, producto de alta rotacion distribuido por Dimak Mayorista.	8870	178	11	0	39	39	2026-07-26 05:16:06.685	2026-07-26 05:16:06.685	7801000003366
1777	Palta La Vega Malla 1.5 kg	Palta La Vega Malla 1.5 kg, producto con stock estable distribuido por Watt's Comercial.	9800	27	18	0	39	33	2026-06-28 05:16:06.685	2026-06-28 05:16:06.685	7801000003373
1778	Tortilla Fuchs Vainilla 6 unidades	Tortilla Fuchs Vainilla 6 unidades, producto de alta rotacion distribuido por Carozzi.	4760	18	7	0	36	37	2026-07-21 05:16:06.685	2026-07-21 05:16:06.685	7801000003380
1779	Papel higienico Comfort Limon 1 L	Papel higienico Comfort Limon 1 L, producto calidad supermercado distribuido por Agrosuper.	5570	133	18	0	34	32	2026-03-17 05:16:06.685	2026-03-17 05:16:06.685	7801000003397
1780	Pan integral Ideal Chocolate 250 g	Pan integral Ideal Chocolate 250 g, producto para venta diaria distribuido por Coca-Cola Embonor.	1210	192	20	0	36	31	2026-05-04 05:16:06.685	2026-05-04 05:16:06.685	7801000003403
1781	Pasta dental Nivea Control caida 16 unidades	Pasta dental Nivea Control caida 16 unidades, producto con stock estable distribuido por CCU.	5720	69	5	25	37	35	2026-03-15 05:16:06.685	2026-03-15 05:16:06.685	7801000003410
1782	Yogur Watts Sin lactosa 170 g	Yogur Watts Sin lactosa 170 g, producto ideal para minimarket distribuido por Soprole.	6480	55	13	0	35	38	2026-03-17 05:16:06.685	2026-03-17 05:16:06.685	7801000003427
1783	Desinfectante Elite Ultra 1 L	Desinfectante Elite Ultra 1 L, producto de alta rotacion distribuido por Soprole.	9080	35	11	0	34	38	2026-06-22 05:16:06.685	2026-06-22 05:16:06.685	7801000003434
1784	Bebida lima limon Watts Light 1.5 L botella	Bebida lima limon Watts Light 1.5 L botella, producto con stock estable distribuido por Distribuidora Rabie.	3160	27	17	0	31	40	2026-03-20 05:16:06.685	2026-03-20 05:16:06.685	7801000003441
1785	Pasta dental Dove Menta 350 ml	Pasta dental Dove Menta 350 ml, producto de alta rotacion distribuido por CCU.	5800	37	18	0	37	35	2026-07-19 05:16:06.685	2026-07-19 05:16:06.685	7801000003458
1786	Leche Soprole Vainilla 900 g	Leche Soprole Vainilla 900 g, producto calidad supermercado distribuido por Agrosuper.	1870	194	11	0	35	32	2026-08-25 05:16:06.685	2026-08-25 05:16:06.685	7801000003465
1787	Detergente Poett Lavanda 12 unidades	Detergente Poett Lavanda 12 unidades, producto para venta diaria distribuido por Watt's Comercial.	2050	98	13	0	34	33	2026-07-05 05:16:06.685	2026-07-05 05:16:06.685	7801000003472
1788	Palta Fruta Sur Verde 5 kg	Palta Fruta Sur Verde 5 kg, producto con stock estable distribuido por Watt's Comercial.	7930	149	18	0	39	33	2026-04-14 05:16:06.685	2026-04-14 05:16:06.685	7801000003489
1789	Pan pita Kingsbury Vainilla 6 unidades	Pan pita Kingsbury Vainilla 6 unidades, producto para venta diaria distribuido por Watt's Comercial.	5270	160	10	0	36	33	2026-04-25 05:16:06.685	2026-04-25 05:16:06.685	7801000003496
1791	Harina Tucapel Con albahaca 2 kg	Harina Tucapel Con albahaca 2 kg, producto de alta rotacion distribuido por Watt's Comercial.	3290	89	8	0	32	33	2026-07-22 05:16:06.685	2026-07-22 05:16:06.685	7801000003519
1792	Queso gauda Loncoleche Frutilla 250 g	Queso gauda Loncoleche Frutilla 250 g, producto calidad supermercado distribuido por Carozzi.	8360	115	18	0	35	37	2026-07-18 05:16:06.685	2026-07-18 05:16:06.685	7801000003526
1793	Verduras surtidas San Jorge Tradicional 250 g	Verduras surtidas San Jorge Tradicional 250 g, producto calidad supermercado distribuido por Agrosuper.	1550	183	13	0	38	32	2026-06-29 05:16:06.685	2026-06-29 05:16:06.685	7801000003533
1794	Desinfectante Elite Lavanda 6 unidades	Desinfectante Elite Lavanda 6 unidades, producto con stock estable distribuido por Dimak Mayorista.	2360	166	5	0	34	39	2026-05-13 05:16:06.685	2026-05-13 05:16:06.685	7801000003540
1795	Quesillo Watts Natural 125 g	Quesillo Watts Natural 125 g, producto de alta rotacion distribuido por Coca-Cola Embonor.	2450	44	16	12	35	31	2026-07-08 05:16:06.685	2026-07-08 05:16:06.685	7801000003557
1796	Jugo nectar Kem Original 2.5 L botella	Jugo nectar Kem Original 2.5 L botella, producto familiar distribuido por Unilever Chile.	7910	76	16	0	31	36	2026-03-14 05:16:06.685	2026-03-14 05:16:06.685	7801000003564
1797	Pasta dental Kotex Original 16 unidades	Pasta dental Kotex Original 16 unidades, producto calidad supermercado distribuido por Unilever Chile.	3370	200	15	0	37	36	2026-08-11 05:16:06.685	2026-08-11 05:16:06.685	7801000003571
1798	Chocolate Trident Menta 85 g	Chocolate Trident Menta 85 g, producto calidad supermercado distribuido por Carozzi.	4620	145	15	12	33	37	2026-03-12 05:16:06.685	2026-03-12 05:16:06.685	7801000003588
1799	Cloro Comfort Hipoalergenico 12 unidades	Cloro Comfort Hipoalergenico 12 unidades, producto familiar distribuido por Agrosuper.	3650	182	13	0	34	32	2026-07-28 05:16:06.685	2026-07-28 05:16:06.685	7801000003595
1800	Quesillo Nestle Natural 170 g	Quesillo Nestle Natural 170 g, producto de alta rotacion distribuido por Unilever Chile.	3390	89	12	0	35	36	2026-03-07 05:16:06.685	2026-03-07 05:16:06.685	7801000003601
1801	Ramitas Sahne Nuss Queso 45 g	Ramitas Sahne Nuss Queso 45 g, producto con stock estable distribuido por Nestle Chile.	2480	152	15	0	33	34	2026-03-14 05:16:06.685	2026-03-14 05:16:06.685	7801000003618
1802	Galleta Evercrisp Frutilla 180 g	Galleta Evercrisp Frutilla 180 g, producto con stock estable distribuido por CCU.	5110	25	17	10	33	35	2026-04-11 05:16:06.685	2026-04-11 05:16:06.685	7801000003625
1803	Zanahoria Huerto Central Organica 3 kg	Zanahoria Huerto Central Organica 3 kg, producto familiar distribuido por Unilever Chile.	5740	41	20	0	39	36	2026-03-25 05:16:06.685	2026-03-25 05:16:06.685	7801000003632
1804	Pizza Cuisine & Co Tradicional 12 unidades	Pizza Cuisine & Co Tradicional 12 unidades, producto para venta diaria distribuido por Coca-Cola Embonor.	3430	164	12	0	38	31	2026-08-16 05:16:06.685	2026-08-16 05:16:06.685	7801000003649
1805	Papas fritas Trident Queso 100 g	Papas fritas Trident Queso 100 g, producto ideal para minimarket distribuido por Nestle Chile.	6010	89	6	0	33	34	2026-04-03 05:16:06.685	2026-04-03 05:16:06.685	7801000003656
1806	Shampoo Elite Sensitive 90 g	Shampoo Elite Sensitive 90 g, producto formato conveniente distribuido por Unilever Chile.	7580	24	9	0	37	36	2026-04-04 05:16:06.685	2026-04-04 05:16:06.685	7801000003663
1807	Toalla absorbente Virutex Aroma floral 900 ml	Toalla absorbente Virutex Aroma floral 900 ml, producto familiar distribuido por Unilever Chile.	12400	38	16	0	34	36	2026-07-14 05:16:06.685	2026-07-14 05:16:06.685	7801000003670
1808	Hallulla Fuchs Sin azucar 700 g	Hallulla Fuchs Sin azucar 700 g, producto con stock estable distribuido por Carozzi.	4750	71	14	0	36	37	2026-05-17 05:16:06.685	2026-05-17 05:16:06.685	7801000003687
1809	Postre lacteo Soprole Protein 125 g	Postre lacteo Soprole Protein 125 g, producto familiar distribuido por Distribuidora Rabie.	3270	124	15	0	35	40	2026-06-10 05:16:06.685	2026-06-10 05:16:06.685	7801000003694
1810	Helado Savory Vacuno 1.5 kg	Helado Savory Vacuno 1.5 kg, producto ideal para minimarket distribuido por Carozzi.	13100	176	5	0	38	37	2026-06-05 05:16:06.685	2026-06-05 05:16:06.685	7801000003700
1811	Alimento gato Pedigree Carne 500 g	Alimento gato Pedigree Carne 500 g, producto con stock estable distribuido por Agrosuper.	17500	27	14	0	40	32	2026-09-01 05:16:06.685	2026-09-01 05:16:06.685	7801000003717
1812	Suavizante Clorinda Hipoalergenico 1.5 L	Suavizante Clorinda Hipoalergenico 1.5 L, producto para venta diaria distribuido por Carozzi.	10000	165	6	0	34	37	2026-08-23 05:16:06.685	2026-08-23 05:16:06.685	7801000003724
1813	Cebolla Fruta Sur Roja bandeja	Cebolla Fruta Sur Roja bandeja, producto familiar distribuido por Soprole.	7210	58	15	0	39	38	2026-05-25 05:16:06.685	2026-05-25 05:16:06.685	7801000003731
1814	Chicle Costa Vainilla 12 unidades	Chicle Costa Vainilla 12 unidades, producto formato conveniente distribuido por CCU.	5930	193	10	0	33	35	2026-04-10 05:16:06.685	2026-04-10 05:16:06.685	7801000003748
1815	Hueso carnaza Champion Dog Control olor 3 kg	Hueso carnaza Champion Dog Control olor 3 kg, producto calidad supermercado distribuido por Soprole.	12900	195	13	0	40	38	2026-08-04 05:16:06.685	2026-08-04 05:16:06.685	7801000003755
1816	Postre lacteo Parmalat Entera 170 g	Postre lacteo Parmalat Entera 170 g, producto formato conveniente distribuido por Watt's Comercial.	1200	125	16	0	35	33	2026-03-09 05:16:06.685	2026-03-09 05:16:06.685	7801000003762
1817	Limpiador piso Quix Original 6 unidades	Limpiador piso Quix Original 6 unidades, producto de alta rotacion distribuido por Dimak Mayorista.	1770	61	11	0	34	39	2026-06-16 05:16:06.685	2026-06-16 05:16:06.685	7801000003779
1818	Te helado Vital Durazno 1 L botella	Te helado Vital Durazno 1 L botella, producto de alta rotacion distribuido por Nestle Chile.	2610	73	8	11	31	34	2026-06-24 05:16:06.685	2026-06-24 05:16:06.685	7801000003786
1819	Masa pizza Castaño Multigrano 12 unidades	Masa pizza Castaño Multigrano 12 unidades, producto ideal para minimarket distribuido por Coca-Cola Embonor.	1210	101	18	0	36	31	2026-05-03 05:16:06.685	2026-05-03 05:16:06.685	7801000003793
1820	Zanahoria La Vega Maduro 1 kg	Zanahoria La Vega Maduro 1 kg, producto familiar distribuido por CCU.	2050	175	8	0	39	35	2026-05-08 05:16:06.685	2026-05-08 05:16:06.685	7801000003809
1821	Desodorante Dove Aloe vera 75 ml	Desodorante Dove Aloe vera 75 ml, producto formato conveniente distribuido por Nestle Chile.	5700	121	6	0	37	34	2026-07-28 05:16:06.685	2026-07-28 05:16:06.685	7801000003816
1822	Galleta Ambrosoli Vainilla 180 g	Galleta Ambrosoli Vainilla 180 g, producto ideal para minimarket distribuido por Carozzi.	2810	122	8	0	33	37	2026-06-29 05:16:06.685	2026-06-29 05:16:06.685	7801000003823
1823	Pizza PF Queso 1.5 kg	Pizza PF Queso 1.5 kg, producto ideal para minimarket distribuido por Coca-Cola Embonor.	5330	3	5	0	38	31	2026-07-15 05:16:06.685	2026-07-15 05:16:06.685	7801000003830
1824	Agua saborizada Sprite Sin azucar 2 L botella	Agua saborizada Sprite Sin azucar 2 L botella, producto seleccionado distribuido por CCU.	7350	61	10	0	31	35	2026-05-20 05:16:06.685	2026-05-20 05:16:06.685	7801000003847
1825	Nuggets Frutos del Maipo Napolitana 500 g	Nuggets Frutos del Maipo Napolitana 500 g, producto para venta diaria distribuido por Soprole.	6600	183	19	0	38	38	2026-03-15 05:16:06.685	2026-03-15 05:16:06.685	7801000003854
1826	Agua saborizada Sprite Original 2.5 L botella	Agua saborizada Sprite Original 2.5 L botella, producto formato conveniente distribuido por Soprole.	1980	136	7	0	31	38	2026-03-18 05:16:06.685	2026-03-18 05:16:06.685	7801000003861
1827	Toalla higienica Head & Shoulders Antibacterial 350 ml	Toalla higienica Head & Shoulders Antibacterial 350 ml, producto para venta diaria distribuido por Watt's Comercial.	6240	48	18	15	37	33	2026-05-05 05:16:06.685	2026-05-05 05:16:06.685	7801000003878
1828	Palta Huerto Central Premium 2 kg	Palta Huerto Central Premium 2 kg, producto seleccionado distribuido por Dimak Mayorista.	2860	173	15	0	39	39	2026-07-15 05:16:06.685	2026-07-15 05:16:06.685	7801000003885
1829	Bebida lima limon Fanta Zero 1 L botella	Bebida lima limon Fanta Zero 1 L botella, producto para venta diaria distribuido por Nestle Chile.	12200	93	8	0	31	34	2026-03-17 05:16:06.685	2026-03-17 05:16:06.685	7801000003892
1830	Cepillo dental Rexona Antibacterial 16 unidades	Cepillo dental Rexona Antibacterial 16 unidades, producto familiar distribuido por Nestle Chile.	7400	52	16	0	37	34	2026-03-09 05:16:06.685	2026-03-09 05:16:06.685	7801000003908
1831	Manzana Valle Verde Verde 5 kg	Manzana Valle Verde Verde 5 kg, producto de alta rotacion distribuido por Unilever Chile.	3340	7	20	0	39	36	2026-03-09 05:16:06.685	2026-03-09 05:16:06.685	7801000003915
1832	Manjar Parmalat Entera 6 unidades	Manjar Parmalat Entera 6 unidades, producto ideal para minimarket distribuido por Dimak Mayorista.	8600	85	10	0	35	39	2026-04-26 05:16:06.685	2026-04-26 05:16:06.685	7801000003922
1833	Leche Surlat Protein 500 g	Leche Surlat Protein 500 g, producto ideal para minimarket distribuido por Coca-Cola Embonor.	1960	66	11	0	35	31	2026-08-07 05:16:06.685	2026-08-07 05:16:06.685	7801000003939
1834	Hueso carnaza Champion Dog Pollo 15 kg	Hueso carnaza Champion Dog Pollo 15 kg, producto familiar distribuido por Agrosuper.	30500	161	20	0	40	32	2026-06-04 05:16:06.685	2026-06-04 05:16:06.685	7801000003946
1835	Jabon Kotex Sensitive 90 g	Jabon Kotex Sensitive 90 g, producto familiar distribuido por Nestle Chile.	8160	10	14	0	37	34	2026-04-14 05:16:06.685	2026-04-14 05:16:06.685	7801000003953
1836	Leche Quillayes Frutilla 1 L	Leche Quillayes Frutilla 1 L, producto formato conveniente distribuido por Coca-Cola Embonor.	1400	23	7	23	35	31	2026-07-22 05:16:06.685	2026-07-22 05:16:06.685	7801000003960
1837	Hamburguesa La Crianza Queso 500 g	Hamburguesa La Crianza Queso 500 g, producto de alta rotacion distribuido por Soprole.	10900	195	8	0	38	38	2026-05-09 05:16:06.685	2026-05-09 05:16:06.685	7801000003977
1838	Ramitas Sahne Nuss Bitter 12 unidades	Ramitas Sahne Nuss Bitter 12 unidades, producto con stock estable distribuido por Dimak Mayorista.	3640	181	11	0	33	39	2026-06-30 05:16:06.685	2026-06-30 05:16:06.685	7801000003984
1839	Jugo nectar Andina Naranja 500 ml botella	Jugo nectar Andina Naranja 500 ml botella, producto con stock estable distribuido por Unilever Chile.	9490	103	10	13	31	36	2026-06-26 05:16:06.685	2026-06-26 05:16:06.685	7801000003991
1840	Ramitas Marco Polo Avellana 100 g	Ramitas Marco Polo Avellana 100 g, producto formato conveniente distribuido por Carozzi.	4930	25	17	0	33	37	2026-06-01 05:16:06.685	2026-06-01 05:16:06.685	7801000004004
1841	Agua saborizada Andina Zero 6 x 350 ml	Agua saborizada Andina Zero 6 x 350 ml, producto calidad supermercado distribuido por CCU.	11700	187	17	0	31	35	2026-08-26 05:16:06.685	2026-08-26 05:16:06.685	7801000004011
1842	Pan integral Kingsbury Vainilla 6 unidades	Pan integral Kingsbury Vainilla 6 unidades, producto con stock estable distribuido por CCU.	1340	34	8	0	36	35	2026-07-24 05:16:06.685	2026-07-24 05:16:06.685	7801000004028
1843	Barra cereal Nutra Bien Leche 250 g	Barra cereal Nutra Bien Leche 250 g, producto familiar distribuido por Coca-Cola Embonor.	5170	115	10	0	33	31	2026-08-02 05:16:06.685	2026-08-02 05:16:06.685	7801000004035
1844	Alcohol gel Colgate Control caida 90 g	Alcohol gel Colgate Control caida 90 g, producto ideal para minimarket distribuido por Agrosuper.	7660	118	11	0	37	32	2026-07-10 05:16:06.685	2026-07-10 05:16:06.685	7801000004042
1845	Alfajor Nutra Bien Vainilla 45 g	Alfajor Nutra Bien Vainilla 45 g, producto seleccionado distribuido por Watt's Comercial.	940	81	16	0	33	33	2026-03-09 05:16:06.685	2026-03-09 05:16:06.685	7801000004059
1846	Fideos Miraflores Libre de gluten 750 g	Fideos Miraflores Libre de gluten 750 g, producto para venta diaria distribuido por Distribuidora Rabie.	12800	55	7	0	32	40	2026-08-27 05:16:06.685	2026-08-27 05:16:06.685	7801000004066
1847	Arena sanitaria Doko Cachorro 8 kg	Arena sanitaria Doko Cachorro 8 kg, producto con stock estable distribuido por Carozzi.	20700	48	10	0	40	37	2026-08-10 05:16:06.685	2026-08-10 05:16:06.685	7801000004073
1848	Pan pita Ideal Sin azucar 800 g	Pan pita Ideal Sin azucar 800 g, producto con stock estable distribuido por Dimak Mayorista.	2410	86	15	0	36	39	2026-04-16 05:16:06.685	2026-04-16 05:16:06.685	7801000004080
1849	Papa Valle Verde Verde 1.5 kg	Papa Valle Verde Verde 1.5 kg, producto para venta diaria distribuido por Nestle Chile.	7860	113	8	0	39	34	2026-07-22 05:16:06.685	2026-07-22 05:16:06.685	7801000004097
1851	Yogur Soprole Vainilla 500 g	Yogur Soprole Vainilla 500 g, producto con stock estable distribuido por Nestle Chile.	8320	157	5	0	35	34	2026-03-11 05:16:06.685	2026-03-11 05:16:06.685	7801000004110
1852	Agua mineral Watts Naranja 2 L botella	Agua mineral Watts Naranja 2 L botella, producto con stock estable distribuido por Soprole.	10100	8	9	0	31	38	2026-04-30 05:16:06.685	2026-04-30 05:16:06.685	7801000004127
1853	Desodorante Dove Control caida 6 unidades	Desodorante Dove Control caida 6 unidades, producto ideal para minimarket distribuido por Unilever Chile.	8680	113	13	0	37	36	2026-07-13 05:16:06.685	2026-07-13 05:16:06.685	7801000004134
1854	Chocolate Costa Vainilla 45 g	Chocolate Costa Vainilla 45 g, producto ideal para minimarket distribuido por CCU.	1110	175	7	0	33	35	2026-04-22 05:16:06.685	2026-04-22 05:16:06.685	7801000004141
1856	Shampoo Elite Antibacterial 350 ml	Shampoo Elite Antibacterial 350 ml, producto de alta rotacion distribuido por Unilever Chile.	4650	151	12	0	37	36	2026-07-05 05:16:06.685	2026-07-05 05:16:06.685	7801000004165
1857	Helado Tarragona Primavera 6 unidades	Helado Tarragona Primavera 6 unidades, producto calidad supermercado distribuido por Watt's Comercial.	13500	26	18	19	38	33	2026-05-18 05:16:06.685	2026-05-18 05:16:06.685	7801000004172
1858	Tomate Agro Maule Primera seleccion 2 kg	Tomate Agro Maule Primera seleccion 2 kg, producto formato conveniente distribuido por Nestle Chile.	8080	181	8	0	39	34	2026-04-19 05:16:06.685	2026-04-19 05:16:06.685	7801000004189
1859	Papas fritas Trident Vainilla 250 g	Papas fritas Trident Vainilla 250 g, producto con stock estable distribuido por CCU.	3580	30	17	0	33	35	2026-06-03 05:16:06.685	2026-06-03 05:16:06.685	7801000004196
1860	Alcohol gel Pepsodent Invisible 16 unidades	Alcohol gel Pepsodent Invisible 16 unidades, producto con stock estable distribuido por Unilever Chile.	7150	198	5	0	37	36	2026-08-02 05:16:06.685	2026-08-02 05:16:06.685	7801000004202
1861	Marraqueta San Camilo Tradicional 600 g	Marraqueta San Camilo Tradicional 600 g, producto familiar distribuido por Unilever Chile.	4690	122	19	0	36	36	2026-07-23 05:16:06.685	2026-07-23 05:16:06.685	7801000004219
1862	Toalla absorbente Comfort Antibacterial 450 ml	Toalla absorbente Comfort Antibacterial 450 ml, producto calidad supermercado distribuido por Distribuidora Rabie.	4740	161	9	0	34	40	2026-03-12 05:16:06.685	2026-03-12 05:16:06.685	7801000004226
1863	Hallulla Ideal Multigrano 800 g	Hallulla Ideal Multigrano 800 g, producto para venta diaria distribuido por Unilever Chile.	1580	143	15	9	36	36	2026-05-09 05:16:06.685	2026-05-09 05:16:06.685	7801000004233
1864	Papel higienico Elite Limon 3 L	Papel higienico Elite Limon 3 L, producto formato conveniente distribuido por Dimak Mayorista.	5430	45	11	0	34	39	2026-05-27 05:16:06.685	2026-05-27 05:16:06.685	7801000004240
1865	Tomate Campo Lindo Premium 1.5 kg	Tomate Campo Lindo Premium 1.5 kg, producto ideal para minimarket distribuido por Agrosuper.	7390	32	14	0	39	32	2026-08-08 05:16:06.685	2026-08-08 05:16:06.685	7801000004257
1866	Alfajor Sahne Nuss Bitter 85 g	Alfajor Sahne Nuss Bitter 85 g, producto familiar distribuido por Agrosuper.	3510	157	15	0	33	32	2026-06-13 05:16:06.685	2026-06-13 05:16:06.685	7801000004264
1867	Arena sanitaria Whiskas Senior 500 g	Arena sanitaria Whiskas Senior 500 g, producto formato conveniente distribuido por Coca-Cola Embonor.	31600	104	5	0	40	31	2026-06-06 05:16:06.685	2026-06-06 05:16:06.685	7801000004271
1868	Pan pita Tarragona Tradicional 400 g	Pan pita Tarragona Tradicional 400 g, producto formato conveniente distribuido por Unilever Chile.	3160	191	11	0	36	36	2026-07-10 05:16:06.685	2026-07-10 05:16:06.685	7801000004288
1869	Jugo nectar Fanta Original 2.5 L botella	Jugo nectar Fanta Original 2.5 L botella, producto familiar distribuido por Nestle Chile.	12000	83	12	0	31	34	2026-08-04 05:16:06.685	2026-08-04 05:16:06.685	7801000004295
1870	Lechuga Bio Campo Organica 5 kg	Lechuga Bio Campo Organica 5 kg, producto familiar distribuido por Agrosuper.	6570	91	12	0	39	32	2026-05-18 05:16:06.685	2026-05-18 05:16:06.685	7801000004301
1871	Empanada La Crianza Tradicional 1.5 kg	Empanada La Crianza Tradicional 1.5 kg, producto ideal para minimarket distribuido por Nestle Chile.	1690	176	14	0	38	34	2026-05-12 05:16:06.685	2026-05-12 05:16:06.685	7801000004318
1872	Verduras surtidas Frutos del Maipo Primavera 1 kg	Verduras surtidas Frutos del Maipo Primavera 1 kg, producto calidad supermercado distribuido por Carozzi.	6170	45	8	0	38	37	2026-07-19 05:16:06.685	2026-07-19 05:16:06.685	7801000004325
1873	Cepillo dental Rexona Humectante 400 ml	Cepillo dental Rexona Humectante 400 ml, producto formato conveniente distribuido por Carozzi.	7980	23	20	0	37	37	2026-06-25 05:16:06.685	2026-06-25 05:16:06.685	7801000004332
1874	Papas prefritas Tarragona Pollo 700 g	Papas prefritas Tarragona Pollo 700 g, producto ideal para minimarket distribuido por Distribuidora Rabie.	9200	93	7	0	38	40	2026-03-21 05:16:06.685	2026-03-21 05:16:06.685	7801000004349
1875	Hallulla Cuisine & Co Vainilla 800 g	Hallulla Cuisine & Co Vainilla 800 g, producto para venta diaria distribuido por Distribuidora Rabie.	3320	110	16	0	36	40	2026-03-13 05:16:06.685	2026-03-13 05:16:06.685	7801000004356
1876	Crema de leche Soprole Descremada 1 L	Crema de leche Soprole Descremada 1 L, producto calidad supermercado distribuido por Agrosuper.	8060	42	20	0	35	32	2026-06-19 05:16:06.685	2026-06-19 05:16:06.685	7801000004363
1850	Sal Banquete Maravilla 500 g	Sal Banquete Maravilla 500 g, producto familiar distribuido por Agrosuper.	3790	36	16	0	32	32	2026-04-08 05:16:06.685	2026-09-02 06:21:00.511	7801000004103
1877	Marraqueta Ideal Multigrano 700 g	Marraqueta Ideal Multigrano 700 g, producto con stock estable distribuido por Soprole.	5740	10	16	0	36	38	2026-03-16 05:16:06.685	2026-03-16 05:16:06.685	7801000004370
1878	Tomate La Vega Maduro 500 g	Tomate La Vega Maduro 500 g, producto familiar distribuido por Unilever Chile.	5700	136	8	0	39	36	2026-06-19 05:16:06.685	2026-06-19 05:16:06.685	7801000004387
1879	Marraqueta La Selecta Multigrano 12 unidades	Marraqueta La Selecta Multigrano 12 unidades, producto para venta diaria distribuido por Agrosuper.	2460	157	14	0	36	32	2026-04-12 05:16:06.685	2026-04-12 05:16:06.685	7801000004394
1880	Palta Bio Campo Primera seleccion 500 g	Palta Bio Campo Primera seleccion 500 g, producto ideal para minimarket distribuido por Agrosuper.	3240	164	8	0	39	32	2026-07-04 05:16:06.685	2026-07-04 05:16:06.685	7801000004400
1881	Cloro Comfort Limon 750 ml	Cloro Comfort Limon 750 ml, producto seleccionado distribuido por Dimak Mayorista.	6010	56	6	0	34	39	2026-08-16 05:16:06.685	2026-08-16 05:16:06.685	7801000004417
1882	Salsa de tomate Chef Libre de gluten 1 kg	Salsa de tomate Chef Libre de gluten 1 kg, producto familiar distribuido por Carozzi.	6300	179	15	0	32	37	2026-08-24 05:16:06.685	2026-08-24 05:16:06.685	7801000004424
1883	Papas prefritas La Crianza Primavera 250 g	Papas prefritas La Crianza Primavera 250 g, producto de alta rotacion distribuido por Unilever Chile.	8140	110	11	0	38	36	2026-06-21 05:16:06.685	2026-06-21 05:16:06.685	7801000004431
1884	Cebolla Huerto Central Maduro 1.5 kg	Cebolla Huerto Central Maduro 1.5 kg, producto calidad supermercado distribuido por Carozzi.	4420	0	7	0	39	37	2026-03-12 05:16:06.685	2026-03-12 05:16:06.685	7801000004448
1885	Fideos Iansa Tradicional 200 g	Fideos Iansa Tradicional 200 g, producto ideal para minimarket distribuido por Distribuidora Rabie.	11600	77	13	0	32	40	2026-03-31 05:16:06.685	2026-03-31 05:16:06.685	7801000004455
1886	Pan molde Tarragona Multigrano 800 g	Pan molde Tarragona Multigrano 800 g, producto de alta rotacion distribuido por Nestle Chile.	2770	162	18	0	36	34	2026-06-15 05:16:06.685	2026-06-15 05:16:06.685	7801000004462
1887	Bebida naranja Red Bull Durazno 1.5 L botella	Bebida naranja Red Bull Durazno 1.5 L botella, producto familiar distribuido por Unilever Chile.	9520	40	5	0	31	36	2026-07-21 05:16:06.685	2026-07-21 05:16:06.685	7801000004479
1888	Alfajor Sahne Nuss Frutilla 45 g	Alfajor Sahne Nuss Frutilla 45 g, producto formato conveniente distribuido por Dimak Mayorista.	1230	190	6	0	33	39	2026-05-01 05:16:06.685	2026-05-01 05:16:06.685	7801000004486
1889	Lechuga Valle Verde Maduro 1 kg	Lechuga Valle Verde Maduro 1 kg, producto de alta rotacion distribuido por Nestle Chile.	4580	1	9	0	39	34	2026-07-31 05:16:06.685	2026-07-31 05:16:06.685	7801000004493
1890	Queque Ideal Vainilla 800 g	Queque Ideal Vainilla 800 g, producto formato conveniente distribuido por Coca-Cola Embonor.	2100	172	20	0	36	31	2026-05-10 05:16:06.685	2026-05-10 05:16:06.685	7801000004509
1891	Azucar Lobos Maravilla 1.5 kg	Azucar Lobos Maravilla 1.5 kg, producto seleccionado distribuido por Agrosuper.	11100	80	7	0	32	32	2026-05-15 05:16:06.685	2026-05-15 05:16:06.685	7801000004516
1892	Bebida energetica Kem Original 2.5 L botella	Bebida energetica Kem Original 2.5 L botella, producto de alta rotacion distribuido por Distribuidora Rabie.	10500	3	12	0	31	40	2026-06-30 05:16:06.685	2026-06-30 05:16:06.685	7801000004523
1893	Pan molde Fuchs Chocolate 12 unidades	Pan molde Fuchs Chocolate 12 unidades, producto con stock estable distribuido por Distribuidora Rabie.	4660	137	17	0	36	40	2026-04-25 05:16:06.685	2026-04-25 05:16:06.685	7801000004530
1894	Arena sanitaria Champion Dog Control olor 10 kg	Arena sanitaria Champion Dog Control olor 10 kg, producto ideal para minimarket distribuido por Agrosuper.	23300	165	9	0	40	32	2026-03-07 05:16:06.685	2026-03-07 05:16:06.685	7801000004547
1895	Desodorante Nivea Antibacterial 150 ml	Desodorante Nivea Antibacterial 150 ml, producto calidad supermercado distribuido por Distribuidora Rabie.	7480	81	18	25	37	40	2026-04-15 05:16:06.685	2026-04-15 05:16:06.685	7801000004554
1896	Lentejas Chef Libre de gluten 750 g	Lentejas Chef Libre de gluten 750 g, producto ideal para minimarket distribuido por Dimak Mayorista.	7440	55	12	0	32	39	2026-06-21 05:16:06.685	2026-06-21 05:16:06.685	7801000004561
1897	Alfajor Nutra Bien Queso 250 g	Alfajor Nutra Bien Queso 250 g, producto con stock estable distribuido por Carozzi.	690	138	15	0	33	37	2026-05-04 05:16:06.685	2026-05-04 05:16:06.685	7801000004578
1898	Agua mineral Sprite Naranja 12 x 350 ml	Agua mineral Sprite Naranja 12 x 350 ml, producto familiar distribuido por Distribuidora Rabie.	3990	142	19	0	31	40	2026-04-28 05:16:06.685	2026-04-28 05:16:06.685	7801000004585
1899	Manzana Campo Lindo Premium 2 kg	Manzana Campo Lindo Premium 2 kg, producto seleccionado distribuido por Coca-Cola Embonor.	6400	183	11	0	39	31	2026-04-18 05:16:06.685	2026-04-18 05:16:06.685	7801000004592
1900	Snack perro Dog Chow Piel sensible 3 kg	Snack perro Dog Chow Piel sensible 3 kg, producto de alta rotacion distribuido por Coca-Cola Embonor.	16500	168	12	5	40	31	2026-05-16 05:16:06.685	2026-05-16 05:16:06.685	7801000004608
1901	Manzana Valle Verde Nacional 1 kg	Manzana Valle Verde Nacional 1 kg, producto calidad supermercado distribuido por Unilever Chile.	3290	5	5	0	39	36	2026-07-29 05:16:06.685	2026-07-29 05:16:06.685	7801000004615
1902	Queque Cuisine & Co Integral 400 g	Queque Cuisine & Co Integral 400 g, producto con stock estable distribuido por Agrosuper.	1160	190	9	0	36	32	2026-03-13 05:16:06.685	2026-03-13 05:16:06.685	7801000004622
1903	Platano Bio Campo Premium 2 kg	Platano Bio Campo Premium 2 kg, producto con stock estable distribuido por Distribuidora Rabie.	5810	92	8	0	39	40	2026-03-28 05:16:06.685	2026-03-28 05:16:06.685	7801000004639
1904	Acondicionador Nivea Antibacterial 250 ml	Acondicionador Nivea Antibacterial 250 ml, producto seleccionado distribuido por Dimak Mayorista.	7700	30	13	0	37	39	2026-07-11 05:16:06.685	2026-07-11 05:16:06.685	7801000004646
1905	Bebida cola Watts Original 1 L botella	Bebida cola Watts Original 1 L botella, producto calidad supermercado distribuido por Coca-Cola Embonor.	10700	124	9	7	31	31	2026-08-19 05:16:06.685	2026-08-19 05:16:06.685	7801000004653
1906	Cebolla La Vega Premium 3 kg	Cebolla La Vega Premium 3 kg, producto ideal para minimarket distribuido por Nestle Chile.	9390	122	14	0	39	34	2026-04-07 05:16:06.685	2026-04-07 05:16:06.685	7801000004660
1907	Lentejas Carozzi Libre de gluten 1.5 kg	Lentejas Carozzi Libre de gluten 1.5 kg, producto de alta rotacion distribuido por Soprole.	10500	48	9	0	32	38	2026-03-30 05:16:06.685	2026-03-30 05:16:06.685	7801000004677
1908	Manzana Huerto Central Primera seleccion 1 kg	Manzana Huerto Central Primera seleccion 1 kg, producto formato conveniente distribuido por Dimak Mayorista.	8710	69	7	0	39	39	2026-07-27 05:16:06.685	2026-07-27 05:16:06.685	7801000004684
1909	Helado Tarragona Pollo 250 g	Helado Tarragona Pollo 250 g, producto con stock estable distribuido por Carozzi.	5650	27	5	0	38	37	2026-04-11 05:16:06.685	2026-04-11 05:16:06.685	7801000004691
1910	Arena sanitaria Dog Chow Adulto 15 kg	Arena sanitaria Dog Chow Adulto 15 kg, producto seleccionado distribuido por Coca-Cola Embonor.	25100	5	12	0	40	31	2026-03-07 05:16:06.685	2026-03-07 05:16:06.685	7801000004707
1911	Platano Fruta Sur Verde bandeja	Platano Fruta Sur Verde bandeja, producto calidad supermercado distribuido por CCU.	440	54	12	0	39	35	2026-05-06 05:16:06.685	2026-05-06 05:16:06.685	7801000004714
1912	Agua mineral Vital Light 1 L botella	Agua mineral Vital Light 1 L botella, producto de alta rotacion distribuido por CCU.	4470	138	12	0	31	35	2026-04-13 05:16:06.685	2026-04-13 05:16:06.685	7801000004721
1913	Alfajor Marco Polo Frutilla 250 g	Alfajor Marco Polo Frutilla 250 g, producto con stock estable distribuido por Soprole.	5520	161	14	0	33	38	2026-07-20 05:16:06.685	2026-07-20 05:16:06.685	7801000004738
1914	Papel higienico Clorinda Hipoalergenico 1.5 L	Papel higienico Clorinda Hipoalergenico 1.5 L, producto seleccionado distribuido por Agrosuper.	5880	185	5	7	34	32	2026-03-12 05:16:06.685	2026-03-12 05:16:06.685	7801000004745
1915	Jabon Pepsodent Sensitive 6 unidades	Jabon Pepsodent Sensitive 6 unidades, producto formato conveniente distribuido por Dimak Mayorista.	5440	78	9	0	37	39	2026-04-20 05:16:06.685	2026-04-20 05:16:06.685	7801000004752
1916	Cepillo dental Nivea Sensitive 400 ml	Cepillo dental Nivea Sensitive 400 ml, producto de alta rotacion distribuido por Coca-Cola Embonor.	7910	40	5	0	37	31	2026-08-11 05:16:06.685	2026-08-11 05:16:06.685	7801000004769
1917	Queso gauda Loncoleche Descremada 6 unidades	Queso gauda Loncoleche Descremada 6 unidades, producto para venta diaria distribuido por Distribuidora Rabie.	4780	143	13	0	35	40	2026-04-04 05:16:06.685	2026-04-04 05:16:06.685	7801000004776
1918	Verduras surtidas San Jorge Vainilla 400 g	Verduras surtidas San Jorge Vainilla 400 g, producto familiar distribuido por Nestle Chile.	5190	78	11	0	38	34	2026-08-02 05:16:06.685	2026-08-02 05:16:06.685	7801000004783
1919	Papas prefritas PF Pollo 500 g	Papas prefritas PF Pollo 500 g, producto seleccionado distribuido por Agrosuper.	3290	64	5	0	38	32	2026-06-20 05:16:06.685	2026-06-20 05:16:06.685	7801000004790
1920	Bebida lima limon Coca-Cola Original 6 x 350 ml	Bebida lima limon Coca-Cola Original 6 x 350 ml, producto con stock estable distribuido por Coca-Cola Embonor.	10300	6	13	0	31	31	2026-05-13 05:16:06.685	2026-05-13 05:16:06.685	7801000004806
\.


--
-- Data for Name: Proveedor; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."Proveedor" (id, nombre, telefono, email, direccion, "createdAt", "updatedAt") FROM stdin;
31	Coca-Cola Embonor	+56940001001	ventas.embonor@example.com	Av. Las Condes 12200, Santiago	2026-09-02 05:16:06.654	2026-09-02 05:16:06.654
34	Nestle Chile	+56940001002	pedidos.nestle@example.com	Las Condes 11287, Santiago	2026-09-02 05:16:06.655	2026-09-02 05:16:06.655
35	CCU	+56940001006	pedidos.ccu@example.com	Av. Vitacura 2670, Santiago	2026-09-02 05:16:06.655	2026-09-02 05:16:06.655
36	Unilever Chile	+56940001004	clientes.unilever@example.com	Av. Presidente Riesco 5335, Santiago	2026-09-02 05:16:06.655	2026-09-02 05:16:06.655
38	Soprole	+56940001008	distribucion.soprole@example.com	Av. Santa Maria 0842, Santiago	2026-09-02 05:16:06.655	2026-09-02 05:16:06.655
37	Carozzi	+56940001005	ventas.carozzi@example.com	Camino Longitudinal Sur 5201, San Bernardo	2026-09-02 05:16:06.655	2026-09-02 05:16:06.655
33	Watt's Comercial	+56940001003	distribucion.watts@example.com	Camino Melipilla 10600, Maipu	2026-09-02 05:16:06.655	2026-09-02 05:16:06.655
32	Agrosuper	+56940001007	comercial.agrosuper@example.com	Camino La Estrella 401, Rancagua	2026-09-02 05:16:06.655	2026-09-02 05:16:06.655
40	Distribuidora Rabie	+56940001010	pedidos.rabie@example.com	Panamericana Norte 18900, Lampa	2026-09-02 05:16:06.655	2026-09-02 05:16:06.655
39	Dimak Mayorista	+56940001009	ventas.dimak@example.com	Av. Americo Vespucio 1501, Quilicura	2026-09-02 05:16:06.655	2026-09-02 05:16:06.655
\.


--
-- Data for Name: RefreshToken; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."RefreshToken" (id, "tokenHash", "expiresAt", revoked, "replacedByTokenId", "usuarioId", "createdAt") FROM stdin;
656cdded-b693-40c9-82da-fab694173e53	d5b2ef4e48cfff20dd80788cc04c9116f8ef172b529fddd905210f05bcadeef5	2026-08-31 05:05:14.099	f	\N	1	2026-08-24 05:05:14.106
cd76ef02-5b3c-4f32-9d34-aa7df3506161	b4d2c1ccea01ddc5f8f08c6d227aa83cb873225c28101cbb6ba71b246de7f403	2026-09-09 04:17:21.889	t	e4169bb5-ea60-4afd-8ef1-5008d87c3084	1	2026-09-02 05:17:21.897
e4169bb5-ea60-4afd-8ef1-5008d87c3084	95b848271dbd13b2ab0a427c4b9dbd72cab094f25808c51ebfcfdb575a200f76	2026-09-09 04:52:11.971	t	f6e6e5e0-97c8-4b11-9fad-b43c133a69f8	1	2026-09-02 05:52:11.971
f6e6e5e0-97c8-4b11-9fad-b43c133a69f8	299d9d36db731f55e605ccbd8b42f73574616127bbeef3681f14932dbb3aa62f	2026-09-09 05:13:12.58	t	0e5a5d80-639c-458b-930b-fb7f7ada287c	1	2026-09-02 06:13:12.58
fb193987-3dec-43a0-bcda-243dfafd005c	ac4c1c880afecca13bb2e1b1b7ba97732466d871488fe1014ecee169dfd23e4c	2026-09-09 06:17:19.72	f	\N	1	2026-09-02 07:17:19.72
0e5a5d80-639c-458b-930b-fb7f7ada287c	f6f592c0449a4b64be19e7a3108b6b5ec5640ad98f85509807a41cc1b864f5b8	2026-09-09 05:30:12.611	t	fb193987-3dec-43a0-bcda-243dfafd005c	1	2026-09-02 06:30:12.611
\.


--
-- Data for Name: Rol; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."Rol" (id, codigo, nombre, descripcion, activo, "createdAt", "updatedAt") FROM stdin;
1	SUPER_ADMIN	Super admin	Acceso completo al sistema	t	2026-08-24 04:36:08.908	2026-09-02 05:16:05.456
2	ADMIN	Admin	Administracion operativa del minimarket	t	2026-08-24 04:36:08.908	2026-09-02 05:16:05.539
3	SUPERVISOR	Supervisor	Supervision de operaciones y autorizaciones	t	2026-08-24 04:36:08.908	2026-09-02 05:16:05.552
4	VENDEDOR	Vendedor	Operacion de ventas	t	2026-08-24 04:36:08.908	2026-09-02 05:16:05.559
\.


--
-- Data for Name: RolPermiso; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."RolPermiso" ("rolId", "permisoId") FROM stdin;
1	3
1	1
1	2
2	2
3	2
4	3
\.


--
-- Data for Name: Usuario; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."Usuario" (id, nombre, email, "passwordHash", activo, "createdAt", "updatedAt", "rolId", "pinAutorizacionHash") FROM stdin;
1	Super Admin	superadmin@minimarket.local	$2b$10$/W6NGieIj2.2t5xf2S6cguF2K3g1Zv6bUvfHjxMO86T6gpAlj3rk2	t	2026-08-24 04:36:08.574	2026-09-02 05:16:05.971	1	$2b$10$Hl65w4xNqlFjhIVnZhqCDeXyfl1W7HXRUPwXkuTyBBG5Hmr4RB3J6
4	Admin	admin@minimarket.local	$2b$10$1h1RsFCPeNpaIAtEoN8XyugwmNwQkQ/j8EVSlRi1MXjZ17UHpE.H2	t	2026-09-02 05:16:06.228	2026-09-02 05:16:06.228	2	$2b$10$xQO7BLIH5N7kQ0dZA/j2VOTxcMBwEg6oKS/mg.XH1dvwiyAWzuFk6
5	Supervisor	supervisor@minimarket.local	$2b$10$RP/D271pLGEJYrk.KU7L4.w6ENH7/4YrwhBK8v310IDwTwAZv/3Nu	t	2026-09-02 05:16:06.446	2026-09-02 05:16:06.446	3	$2b$10$DGr5oaznavo0b35GuMoNxeaOJ1hOXtga/Zu1dLAp7hVK6FgZINBQO
\.


--
-- Data for Name: Venta; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public."Venta" (id, total, "descuentoTotal", "createdAt", "metodoPago", "tieneStockInsuficiente", "autorizadoPorId", "motivoAutorizacion", "userId") FROM stdin;
1	5050	0	2026-09-02 05:23:12.672	EFECTIVO	f	\N	\N	1
2	11700	0	2026-09-02 05:23:28.757	TARJETA	f	\N	\N	1
3	11700	0	2026-09-02 05:23:36.303	TRANSFERENCIA	f	\N	\N	1
4	4790	0	2026-09-02 06:13:18.448	EFECTIVO	f	\N	\N	1
5	20450	0	2026-09-02 06:13:29.013	TARJETA	f	\N	\N	1
6	5050	0	2026-09-02 06:13:51.476	EFECTIVO	f	\N	\N	1
7	4790	0	2026-09-02 06:14:57.968	EFECTIVO	f	\N	\N	1
8	68330	0	2026-09-02 06:19:34.856	EFECTIVO	f	\N	\N	1
9	26640	0	2026-09-02 06:19:43.58	EFECTIVO	f	\N	\N	1
10	111210	0	2026-09-02 06:21:00.489	EFECTIVO	f	\N	\N	1
11	44380	0	2026-09-02 06:22:15.62	EFECTIVO	f	\N	\N	1
12	49010	0	2026-09-02 06:22:34.931	EFECTIVO	f	\N	\N	1
13	40440	0	2026-09-02 06:23:42.609	EFECTIVO	f	\N	\N	1
14	22700	0	2026-09-02 06:25:14.391	EFECTIVO	f	\N	\N	1
15	3940	0	2026-09-02 06:25:23.777	EFECTIVO	f	\N	\N	1
16	11700	0	2026-09-02 06:26:43.164	EFECTIVO	f	\N	\N	1
17	14940	0	2026-09-02 06:30:17.131	EFECTIVO	f	\N	\N	1
18	3940	0	2026-09-02 06:30:41.497	EFECTIVO	f	\N	\N	1
19	11700	0	2026-09-02 06:32:03.765	EFECTIVO	f	\N	\N	1
20	24390	0	2026-09-02 06:34:14.102	EFECTIVO	f	\N	\N	1
21	11000	0	2026-09-02 06:35:11.412	EFECTIVO	f	\N	\N	1
\.


--
-- Data for Name: _prisma_migrations; Type: TABLE DATA; Schema: public; Owner: app
--

COPY public._prisma_migrations (id, checksum, finished_at, migration_name, logs, rolled_back_at, started_at, applied_steps_count) FROM stdin;
b73d1c25-fb91-44be-9975-43b51d483861	9cb74963532a39dfd68d670b7f30bc4bf08ff20205ed65ed03f9adccbb2acba5	2026-08-24 04:36:08.260929+00	20260506004143_init	\N	\N	2026-08-24 04:36:07.611554+00	1
9f75ff4c-2e6e-402a-883b-305becd5ee5e	a9dd24b472689d48b5a02946a288fc21475b542f217ee73b98d6352c91ad1d9d	2026-08-24 04:36:09.590124+00	20260629213716_force_user_cascade	\N	\N	2026-08-24 04:36:09.556805+00	1
52b42478-3e5a-4e57-a672-a81d1ffdfd7a	071c1709a49f2aa7e717b1395fdf7ae3e3975e9aa3daf82b855dbba0d57c8eb0	2026-08-24 04:36:08.555703+00	20260509030000_add_product_search_indexes	\N	\N	2026-08-24 04:36:08.269559+00	1
2eaf28d2-a4c9-49fc-a0a8-96a315def2c8	a8281241cfb972880b8def9d7135af01f19262f821bb91898878307e03b625e0	2026-08-24 04:36:08.697592+00	20260512000000_add_users_auth	\N	\N	2026-08-24 04:36:08.564247+00	1
2e9e71fb-e133-4bac-8366-d0af189bfa69	404caf9fdca5effe4e4268d9edb11a7051fdb4b8a3497df33c3ffd825e3bf28f	2026-08-24 04:36:08.731174+00	20260512160000_add_metodo_pago_venta	\N	\N	2026-08-24 04:36:08.706006+00	1
379fe284-6afd-4ab5-bfb8-087e1f07c8ff	d5b0f9f35117bea0152dbf2f58c8e71350b62e55965c823b8ee08a086213379a	2026-08-24 04:36:09.790261+00	20260712223818_add_refresh_token	\N	\N	2026-08-24 04:36:09.598669+00	1
88d6625d-aded-45db-a6db-3aa6e0d9e79e	7f75c1b39cbc16a18e4c1fdeb24aa6d4aa8c1d01dbc3ef0b619607ada54f0cd3	2026-08-24 04:36:08.764374+00	20260516045344_dbminimarkt	\N	\N	2026-08-24 04:36:08.739434+00	1
895cb06c-7b5b-45aa-95ca-32ea550dfe46	2299bf7175f89dec09a7c9368889794f4bc6db5095f95f429c4fefa940d74f24	2026-08-24 04:36:08.856126+00	20260516120000_add_stock_authorization_to_sales	\N	\N	2026-08-24 04:36:08.772989+00	1
d001c709-602c-4fb4-b001-caa38b28db2b	f858d78387d74d8c07dd2482298e79b887c2d0f62ee8353df4e6679e8a2ce2dd	2026-08-24 04:36:08.889485+00	20260516123000_add_vendedor_role	\N	\N	2026-08-24 04:36:08.864483+00	1
e3e12fb0-8fc8-444c-b548-a78682b00cf7	770952d90c11f17fac557ef6bbb8873ed3555f64dd8efbfe41dc039973c4acf9	2026-08-24 04:36:09.206561+00	20260516133000_add_rbac_tables	\N	\N	2026-08-24 04:36:08.897939+00	1
a5d39200-6864-4f19-90c7-7965ee84fd0b	6379e540f1251e6e193012d20858dd98ed2f491a96075aba56c0e84ea562930a	2026-08-24 04:36:09.248297+00	20260516134000_add_dashboard_permission	\N	\N	2026-08-24 04:36:09.214956+00	1
e2315e72-f5e3-4534-97d6-eeae29fd781f	a55ca66a2c401b9642c25624e1298cc16d8735c16ef744b34c449561c9b8d1e4	2026-08-24 04:36:09.331653+00	20260516135000_scope_sales_by_user	\N	\N	2026-08-24 04:36:09.256655+00	1
293d702b-3fb3-4b49-bab1-ddd4bf1dfe0a	e021c104ece732da4297e19e4367bbd50be187059cca998ca7fea50463af1fc1	2026-08-24 04:36:09.381712+00	20260516140000_add_authorization_pin_to_users	\N	\N	2026-08-24 04:36:09.340058+00	1
c93a75a5-237c-4538-a855-f3840401b76c	ee418763814977111252b4675c08ddd16c2d1ef0b9a6528c3a92c77e5842b083	2026-08-24 04:36:09.431778+00	20260517015157_add_users	\N	\N	2026-08-24 04:36:09.390007+00	1
ca3d52b2-6a5d-4d66-be06-c83b8c695a16	0c8b77420d30cffcc3fdbdf7d08e3849466615df296f243c57188f2ed58d932e	2026-08-24 04:36:09.548358+00	20260629002514_update_venta_user_relation	\N	\N	2026-08-24 04:36:09.44005+00	1
\.


--
-- Name: Categoria_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."Categoria_id_seq"', 40, true);


--
-- Name: DetalleVenta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."DetalleVenta_id_seq"', 58, true);


--
-- Name: Movimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."Movimiento_id_seq"', 58, true);


--
-- Name: Permiso_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."Permiso_id_seq"', 15, true);


--
-- Name: Producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."Producto_id_seq"', 1920, true);


--
-- Name: Proveedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."Proveedor_id_seq"', 40, true);


--
-- Name: Rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."Rol_id_seq"', 20, true);


--
-- Name: Usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."Usuario_id_seq"', 5, true);


--
-- Name: Venta_id_seq; Type: SEQUENCE SET; Schema: public; Owner: app
--

SELECT pg_catalog.setval('public."Venta_id_seq"', 21, true);


--
-- Name: Categoria Categoria_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Categoria"
    ADD CONSTRAINT "Categoria_pkey" PRIMARY KEY (id);


--
-- Name: DetalleVenta DetalleVenta_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."DetalleVenta"
    ADD CONSTRAINT "DetalleVenta_pkey" PRIMARY KEY (id);


--
-- Name: Movimiento Movimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Movimiento"
    ADD CONSTRAINT "Movimiento_pkey" PRIMARY KEY (id);


--
-- Name: Permiso Permiso_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Permiso"
    ADD CONSTRAINT "Permiso_pkey" PRIMARY KEY (id);


--
-- Name: Producto Producto_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Producto"
    ADD CONSTRAINT "Producto_pkey" PRIMARY KEY (id);


--
-- Name: Proveedor Proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Proveedor"
    ADD CONSTRAINT "Proveedor_pkey" PRIMARY KEY (id);


--
-- Name: RefreshToken RefreshToken_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."RefreshToken"
    ADD CONSTRAINT "RefreshToken_pkey" PRIMARY KEY (id);


--
-- Name: RolPermiso RolPermiso_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."RolPermiso"
    ADD CONSTRAINT "RolPermiso_pkey" PRIMARY KEY ("rolId", "permisoId");


--
-- Name: Rol Rol_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Rol"
    ADD CONSTRAINT "Rol_pkey" PRIMARY KEY (id);


--
-- Name: Usuario Usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_pkey" PRIMARY KEY (id);


--
-- Name: Venta Venta_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Venta"
    ADD CONSTRAINT "Venta_pkey" PRIMARY KEY (id);


--
-- Name: _prisma_migrations _prisma_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public._prisma_migrations
    ADD CONSTRAINT _prisma_migrations_pkey PRIMARY KEY (id);


--
-- Name: Categoria_nombre_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "Categoria_nombre_key" ON public."Categoria" USING btree (nombre);


--
-- Name: Permiso_codigo_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "Permiso_codigo_key" ON public."Permiso" USING btree (codigo);


--
-- Name: Producto_categoriaId_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "Producto_categoriaId_idx" ON public."Producto" USING btree ("categoriaId");


--
-- Name: Producto_codigoBarra_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "Producto_codigoBarra_key" ON public."Producto" USING btree ("codigoBarra");


--
-- Name: Producto_precio_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "Producto_precio_idx" ON public."Producto" USING btree (precio);


--
-- Name: Producto_stock_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "Producto_stock_idx" ON public."Producto" USING btree (stock);


--
-- Name: Proveedor_email_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "Proveedor_email_key" ON public."Proveedor" USING btree (email);


--
-- Name: RefreshToken_usuarioId_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "RefreshToken_usuarioId_idx" ON public."RefreshToken" USING btree ("usuarioId");


--
-- Name: RolPermiso_permisoId_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "RolPermiso_permisoId_idx" ON public."RolPermiso" USING btree ("permisoId");


--
-- Name: Rol_codigo_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "Rol_codigo_key" ON public."Rol" USING btree (codigo);


--
-- Name: Usuario_email_key; Type: INDEX; Schema: public; Owner: app
--

CREATE UNIQUE INDEX "Usuario_email_key" ON public."Usuario" USING btree (email);


--
-- Name: Usuario_rolId_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "Usuario_rolId_idx" ON public."Usuario" USING btree ("rolId");


--
-- Name: Venta_userId_idx; Type: INDEX; Schema: public; Owner: app
--

CREATE INDEX "Venta_userId_idx" ON public."Venta" USING btree ("userId");


--
-- Name: DetalleVenta DetalleVenta_productoId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."DetalleVenta"
    ADD CONSTRAINT "DetalleVenta_productoId_fkey" FOREIGN KEY ("productoId") REFERENCES public."Producto"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: DetalleVenta DetalleVenta_ventaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."DetalleVenta"
    ADD CONSTRAINT "DetalleVenta_ventaId_fkey" FOREIGN KEY ("ventaId") REFERENCES public."Venta"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Movimiento Movimiento_productoId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Movimiento"
    ADD CONSTRAINT "Movimiento_productoId_fkey" FOREIGN KEY ("productoId") REFERENCES public."Producto"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Producto Producto_categoriaId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Producto"
    ADD CONSTRAINT "Producto_categoriaId_fkey" FOREIGN KEY ("categoriaId") REFERENCES public."Categoria"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Producto Producto_proveedorId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Producto"
    ADD CONSTRAINT "Producto_proveedorId_fkey" FOREIGN KEY ("proveedorId") REFERENCES public."Proveedor"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: RefreshToken RefreshToken_usuarioId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."RefreshToken"
    ADD CONSTRAINT "RefreshToken_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES public."Usuario"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RolPermiso RolPermiso_permisoId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."RolPermiso"
    ADD CONSTRAINT "RolPermiso_permisoId_fkey" FOREIGN KEY ("permisoId") REFERENCES public."Permiso"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: RolPermiso RolPermiso_rolId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."RolPermiso"
    ADD CONSTRAINT "RolPermiso_rolId_fkey" FOREIGN KEY ("rolId") REFERENCES public."Rol"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: Usuario Usuario_rolId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Usuario"
    ADD CONSTRAINT "Usuario_rolId_fkey" FOREIGN KEY ("rolId") REFERENCES public."Rol"(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: Venta Venta_userId_fkey; Type: FK CONSTRAINT; Schema: public; Owner: app
--

ALTER TABLE ONLY public."Venta"
    ADD CONSTRAINT "Venta_userId_fkey" FOREIGN KEY ("userId") REFERENCES public."Usuario"(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict qzd21WtxTo9KkQeNwMR4hQXioW0DqAnBLuFC48uI60Y26Wwo7r4L2eSl4rkRSx7

