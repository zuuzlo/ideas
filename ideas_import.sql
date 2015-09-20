--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
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
-- Name: categories; Type: TABLE; Schema: public; Owner: kirk; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name character varying(255),
    description text,
    user_id integer,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    slug character varying(255)
);


ALTER TABLE public.categories OWNER TO kirk;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: kirk
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO kirk;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kirk
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: categories_ideas; Type: TABLE; Schema: public; Owner: kirk; Tablespace: 
--

CREATE TABLE categories_ideas (
    category_id integer NOT NULL,
    idea_id integer NOT NULL
);


ALTER TABLE public.categories_ideas OWNER TO kirk;

--
-- Name: friendly_id_slugs; Type: TABLE; Schema: public; Owner: kirk; Tablespace: 
--

CREATE TABLE friendly_id_slugs (
    id integer NOT NULL,
    slug character varying(255) NOT NULL,
    sluggable_id integer NOT NULL,
    sluggable_type character varying(50),
    scope character varying(255),
    created_at timestamp without time zone
);


ALTER TABLE public.friendly_id_slugs OWNER TO kirk;

--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE; Schema: public; Owner: kirk
--

CREATE SEQUENCE friendly_id_slugs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.friendly_id_slugs_id_seq OWNER TO kirk;

--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kirk
--

ALTER SEQUENCE friendly_id_slugs_id_seq OWNED BY friendly_id_slugs.id;


--
-- Name: idea_links; Type: TABLE; Schema: public; Owner: kirk; Tablespace: 
--

CREATE TABLE idea_links (
    id integer NOT NULL,
    name character varying(255),
    link_url character varying(255),
    user_id integer,
    slug character varying(255),
    idea_linkable_id integer,
    idea_linkable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.idea_links OWNER TO kirk;

--
-- Name: idea_links_id_seq; Type: SEQUENCE; Schema: public; Owner: kirk
--

CREATE SEQUENCE idea_links_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.idea_links_id_seq OWNER TO kirk;

--
-- Name: idea_links_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kirk
--

ALTER SEQUENCE idea_links_id_seq OWNED BY idea_links.id;


--
-- Name: ideas; Type: TABLE; Schema: public; Owner: kirk; Tablespace: 
--

CREATE TABLE ideas (
    id integer NOT NULL,
    name character varying(255),
    description text,
    benefits text,
    problem_solves text,
    slug character varying(255),
    user_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    status character varying(255)
);


ALTER TABLE public.ideas OWNER TO kirk;

--
-- Name: ideas_id_seq; Type: SEQUENCE; Schema: public; Owner: kirk
--

CREATE SEQUENCE ideas_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ideas_id_seq OWNER TO kirk;

--
-- Name: ideas_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kirk
--

ALTER SEQUENCE ideas_id_seq OWNED BY ideas.id;


--
-- Name: notes; Type: TABLE; Schema: public; Owner: kirk; Tablespace: 
--

CREATE TABLE notes (
    id integer NOT NULL,
    title character varying(255),
    text text,
    slug character varying(255),
    user_id integer,
    notable_id integer,
    notable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


ALTER TABLE public.notes OWNER TO kirk;

--
-- Name: notes_id_seq; Type: SEQUENCE; Schema: public; Owner: kirk
--

CREATE SEQUENCE notes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.notes_id_seq OWNER TO kirk;

--
-- Name: notes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kirk
--

ALTER SEQUENCE notes_id_seq OWNED BY notes.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: kirk; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE public.schema_migrations OWNER TO kirk;

--
-- Name: tasks; Type: TABLE; Schema: public; Owner: kirk; Tablespace: 
--

CREATE TABLE tasks (
    id integer NOT NULL,
    name character varying(255),
    description text,
    assigned_by integer,
    assigned_to integer,
    user_id integer,
    percent_complete integer,
    start_date date,
    finish_date date,
    completion_date date,
    status character varying(255),
    slug character varying(255),
    taskable_id integer,
    taskable_type character varying(255),
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    "position" integer
);


ALTER TABLE public.tasks OWNER TO kirk;

--
-- Name: tasks_id_seq; Type: SEQUENCE; Schema: public; Owner: kirk
--

CREATE SEQUENCE tasks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasks_id_seq OWNER TO kirk;

--
-- Name: tasks_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kirk
--

ALTER SEQUENCE tasks_id_seq OWNED BY tasks.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: kirk; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying(255) DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying(255) DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying(255),
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    created_at timestamp without time zone,
    updated_at timestamp without time zone,
    confirmation_token character varying(255),
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    slug character varying(255)
);


ALTER TABLE public.users OWNER TO kirk;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: kirk
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_id_seq OWNER TO kirk;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kirk
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kirk
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kirk
--

ALTER TABLE ONLY friendly_id_slugs ALTER COLUMN id SET DEFAULT nextval('friendly_id_slugs_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kirk
--

ALTER TABLE ONLY idea_links ALTER COLUMN id SET DEFAULT nextval('idea_links_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kirk
--

ALTER TABLE ONLY ideas ALTER COLUMN id SET DEFAULT nextval('ideas_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kirk
--

ALTER TABLE ONLY notes ALTER COLUMN id SET DEFAULT nextval('notes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kirk
--

ALTER TABLE ONLY tasks ALTER COLUMN id SET DEFAULT nextval('tasks_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kirk
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: kirk
--

COPY categories (id, name, description, user_id, created_at, updated_at, slug) FROM stdin;
6	Process	Describe ideas that regard process.	1	2014-12-21 04:58:25.670636	2014-12-21 04:58:25.670636	process
7	Process	ideas around process	2	2014-12-21 04:59:42.509884	2014-12-21 04:59:42.509884	process
8	Home	for around the home ideas and other thoughts	2	2014-12-21 05:00:39.409311	2014-12-22 02:39:12.879976	home
23	Try	I'll try again.	1	2014-12-27 04:22:15.953767	2014-12-27 04:22:15.953767	try
24	Rails Apps	Ideas around rails apps	1	2015-01-01 13:15:10.434868	2015-01-01 13:15:10.434868	rails-apps
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kirk
--

SELECT pg_catalog.setval('categories_id_seq', 25, true);


--
-- Data for Name: categories_ideas; Type: TABLE DATA; Schema: public; Owner: kirk
--

COPY categories_ideas (category_id, idea_id) FROM stdin;
24	4
24	7
24	8
\.


--
-- Data for Name: friendly_id_slugs; Type: TABLE DATA; Schema: public; Owner: kirk
--

COPY friendly_id_slugs (id, slug, sluggable_id, sluggable_type, scope, created_at) FROM stdin;
\.


--
-- Name: friendly_id_slugs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kirk
--

SELECT pg_catalog.setval('friendly_id_slugs_id_seq', 1, false);


--
-- Data for Name: idea_links; Type: TABLE DATA; Schema: public; Owner: kirk
--

COPY idea_links (id, name, link_url, user_id, slug, idea_linkable_id, idea_linkable_type, created_at, updated_at) FROM stdin;
2	Bootstrap Componets	http://getbootstrap.com/components/	1	bootstrap-componets	4	Idea	2015-01-21 02:43:14.168881	2015-01-21 02:43:14.168881
3	Rails record validation	http://guides.rubyonrails.org/active_record_validations.html	1	rails-record-validation	4	Idea	2015-01-23 01:45:16.509508	2015-01-23 01:45:16.509508
8	New link	http://google.com	1	new-link	20	Task	2015-03-07 03:20:50.663849	2015-03-07 03:20:50.663849
9	Bootstrap form_for	https://github.com/bootstrap-ruby/rails-bootstrap-forms	1	bootstrap-form_for	4	Idea	2015-03-08 12:58:38.678434	2015-03-08 12:58:38.678434
10	Isotope	http://isotope.metafizzy.co/options.html#containerstyle	1	isotope	8	Idea	2015-04-04 13:35:49.371615	2015-04-04 13:35:49.371615
11	Automation with Mechanize and Ruby	http://crabonature.pl/posts/23-automation-with-mechanize-and-ruby	1	automation-with-mechanize-and-ruby	8	Idea	2015-04-04 13:37:15.670749	2015-04-04 13:37:15.670749
12	mechanize	http://docs.seattlerb.org/mechanize/Mechanize.html	1	mechanize	8	Idea	2015-04-04 13:37:56.160454	2015-04-04 13:37:56.160454
13	Stub external calls	https://robots.thoughtbot.com/how-to-stub-external-services-in-tests	1	stub-external-calls	8	Idea	2015-04-04 19:19:39.347737	2015-04-04 19:19:39.347737
\.


--
-- Name: idea_links_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kirk
--

SELECT pg_catalog.setval('idea_links_id_seq', 13, true);


--
-- Data for Name: ideas; Type: TABLE DATA; Schema: public; Owner: kirk
--

COPY ideas (id, name, description, benefits, problem_solves, slug, user_id, created_at, updated_at, status) FROM stdin;
4	Idea App	Build an app which keeps track of ideas.  Has a work flow which will help manage and make progress on the idea.  It will have categories for the ideas, action items or tasks, also will track status. It will also allow attachments, pictures attachments, ability to add links to the idea. 	Organize your ideas.  Give you the ability to come back to your idea and work on it over time. 	Forgetting a good idea and never pursuing it. Procrastination.  Project management for an idea.	idea-app	1	2014-12-31 15:38:08.639215	2015-03-07 03:30:00.160654	Active
8	Zuuzlo	Coupon website only showing the latest coupons from multiple stores.			zuuzlo	1	2015-03-28 12:38:18.964249	2015-03-28 12:38:18.964249	Active
7	All Kohls Cash Back	Create a website where you get cash back from you online purchases.	People can get 2% cash back on their purchases from Kohls. It will also generate 2% revenue on purchase.		all-kohls-cash-back	1	2015-02-08 14:55:04.522723	2015-02-08 14:55:04.522723	Hold
\.


--
-- Name: ideas_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kirk
--

SELECT pg_catalog.setval('ideas_id_seq', 8, true);


--
-- Data for Name: notes; Type: TABLE DATA; Schema: public; Owner: kirk
--

COPY notes (id, title, text, slug, user_id, notable_id, notable_type, created_at, updated_at) FROM stdin;
57	Two	This is the second note. Updated now. reupdate.  Update again.	two	1	23	Category	2014-12-27 13:30:14.789978	2014-12-27 13:38:38.383039
7	Another good note	this may not work again.	another-good-note	1	6	Category	2014-12-23 05:21:38.741227	2014-12-23 05:21:38.741227
61	Mobile new	This is a new mobile note.	mobile-new	1	23	Category	2014-12-27 15:17:22.11049	2014-12-27 15:17:22.11049
62	 3	dfda. try this.	3	1	23	Category	2014-12-28 02:13:29.180413	2014-12-28 02:13:50.572841
63	5	Five.	5	1	23	Category	2014-12-28 02:26:59.606959	2014-12-28 02:26:59.606959
64	16	Sixteen, is the last test note.	16	1	23	Category	2014-12-28 02:49:21.701533	2014-12-28 02:49:21.701533
65	First Note	This is the first note of a note.	first-note	1	57	Note	2014-12-28 05:03:58.961299	2014-12-28 05:03:58.961299
66	2	This is second.	2	1	57	Note	2014-12-28 16:44:50.165594	2014-12-28 16:44:50.165594
70	Referring Controller	See AKC coupon model toggle favorites.	referring-controller	1	4	Idea	2015-01-01 13:57:28.70745	2015-01-01 13:57:28.70745
74	Note of Note	Testing	note-of-note	1	70	Note	2015-03-01 21:03:23.587533	2015-03-01 21:03:23.587533
76	Test note 1	This is  a test note to see if I can add a note to a task.	test-note-1	1	20	Task	2015-03-06 03:20:58.103837	2015-03-06 03:20:58.103837
77	Dash board concept	Create a dash board for all the user ideas.  Include % complete ect...	dash-board-concept	1	4	Idea	2015-03-08 13:01:05.857586	2015-03-08 13:01:05.857586
75	String to Class	@task.taskable_type.classify. constantize.find(@task.taskable_id)	string-to-class	1	4	Idea	2015-03-03 03:33:24.441589	2015-03-08 13:07:21.68938
78	jquery prev	$('#task_13').prevAll(':visible:first')	jquery-prev	1	4	Idea	2015-03-15 02:36:22.37387	2015-03-15 02:36:22.37387
23	Last new	this is the last new note.	last-new	1	6	Category	2014-12-25 02:37:45.519436	2014-12-25 02:37:45.519436
\.


--
-- Name: notes_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kirk
--

SELECT pg_catalog.setval('notes_id_seq', 78, true);


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: public; Owner: kirk
--

COPY schema_migrations (version) FROM stdin;
20141215041113
20141216015150
20141216015957
20141216020556
20141216032507
20141221044143
20141221234641
20141228184201
20141228190936
20141229023014
20141231061213
20150101155841
20150119015643
20150314022155
\.


--
-- Data for Name: tasks; Type: TABLE DATA; Schema: public; Owner: kirk
--

COPY tasks (id, name, description, assigned_by, assigned_to, user_id, percent_complete, start_date, finish_date, completion_date, status, slug, taskable_id, taskable_type, created_at, updated_at, "position") FROM stdin;
21	Add Sub Tasks	Create the ability to add sub tasks to a task.  Give infinite ability to add child / parent relationships.	\N	\N	1	50	2015-02-08	2015-03-27	\N	Active	add-sub-tasks	4	Idea	2015-02-08 14:49:21.584822	2015-03-20 01:21:21.902486	7
22	Task selected only	When adding a new task make sure it only is shown when the tab that is select matches it's status	\N	\N	1	50	2015-02-08	2015-03-27	\N	Hold	task-selected-only	4	Idea	2015-02-08 14:51:00.766133	2015-03-20 01:21:21.922681	6
38	Task2		\N	\N	1	100	2015-03-14	\N	2015-03-14	Complete	task2	7	Idea	2015-03-15 02:33:50.741321	2015-03-15 02:33:58.619439	2
37	test 1		\N	\N	1	50	2015-03-14	\N	\N	Active	test-1	7	Idea	2015-03-15 02:33:27.388892	2015-03-15 02:34:25.652927	1
10	Add delete to Idea controller	Idea controller doesn't have delete method yet. need to add.	\N	\N	1	100	2015-01-05	2015-01-16	2015-01-17	Complete	add-delete-to-idea-controller	4	Idea	2015-01-02 14:40:31.7319	2015-03-20 01:31:14.200103	3
11	Add tabs to Tasks view	Add tabs All, Active, Complete.	\N	\N	1	100	2015-01-02	2015-01-16	2015-01-11	Complete	add-tabs-to-tasks-view	4	Idea	2015-01-02 16:06:21.003903	2015-03-20 02:00:31.368983	1
20	Add components to componets	Add notes to tasks, Add links to tasks	\N	\N	1	70	2015-01-22	2015-03-27	\N	Active	add-components-to-componets	4	Idea	2015-01-23 01:46:54.197362	2015-03-19 02:44:24.253218	10
28	Write tests	Write test for make tasks, notes, links assignable to parents of other elements.	\N	\N	1	50	\N	2015-03-27	\N	Active	write-tests	20	Task	2015-03-04 04:14:53.318558	2015-03-07 03:22:11.560121	\N
18	More / less button	Get the more  / less button working on the description for tasks	\N	\N	1	100	2015-01-17	2015-01-30	2015-01-17	Complete	more-less-button	4	Idea	2015-01-17 12:09:15.203361	2015-03-20 02:00:31.386698	0
14	Add complete button	Add a complete button to the task so that one button push will put the completion date and % complete to 100%.  	\N	\N	1	100	\N	2015-01-30	2015-01-17	Complete	add-complete-button	4	Idea	2015-01-06 04:41:40.978767	2015-03-19 03:20:03.487825	5
35	Expand Button	Add a expand button so it will show sub task of a task	\N	\N	1	50	\N	2015-03-27	\N	Active	expand-button	21	Task	2015-03-08 12:50:49.11774	2015-03-11 00:30:40.867099	\N
36	Denote Children	Add an icon or some method to denote children tasks when displaying children tasks.	\N	\N	1	0	2015-03-11	2015-03-27	\N	Hold	denote-children	21	Task	2015-03-11 21:41:34.307157	2015-03-11 21:41:34.307157	\N
26	Check all task views	Make sure all task views are checked and the parent is correctly set.	\N	\N	1	30	2015-03-03	2015-03-27	\N	Hold	check-all-task-views	20	Task	2015-03-04 03:48:13.362644	2015-03-04 04:12:01.035782	\N
32	Fix Notes for Children	Fix the notes for parent.  Note doesn't show up.	\N	\N	1	100	2015-03-05	2015-03-27	2015-03-06	Complete	fix-notes-for-children	20	Task	2015-03-06 03:16:35.75145	2015-03-07 03:21:44.745147	\N
19	Add color to Task	Add colors to the task rows to indicate status. Consider doing this or not.  It may not be benificial	\N	\N	1	0	\N	2015-02-13	\N	Hold	add-color-to-task	4	Idea	2015-01-17 12:12:20.581014	2015-03-20 01:20:21.759915	9
13	Add update button task	Add an update button the percent complete can be updated and the status can be changed.	\N	\N	1	100	\N	2015-01-30	2015-01-17	Complete	add-update-button-task	4	Idea	2015-01-06 04:39:48.649092	2015-03-19 03:22:45.000685	4
12	Add Priority	Add column to Idea Tasks to capture the ordering of the tasks.  Need to sort the top task in order chosen by user.	\N	\N	1	0	2015-01-05	2015-01-30	\N	Hold	add-priority	4	Idea	2015-01-06 04:37:43.264871	2015-03-20 01:21:13.590998	8
23	Change Task Status	When changing task status change the class of the row to the new status.	\N	\N	1	100	2015-02-12	2015-03-20	2015-02-22	Complete	change-task-status	4	Idea	2015-02-13 02:18:59.807679	2015-03-20 01:31:14.218431	2
39	Remove cash back	To get launched remove cash bake stuff for now.	\N	\N	1	0	2015-03-28	\N	\N	Hold	remove-cash-back	8	Idea	2015-03-28 12:39:52.831486	2015-03-28 12:39:52.831486	1
41	Cheap server	Find cheap way to host site	\N	\N	1	0	2015-03-28	\N	\N	Hold	cheap-server	8	Idea	2015-03-28 12:46:28.726191	2015-03-28 12:46:28.726191	3
42	Finish tests	Make sure all tests are up-to-date	\N	\N	1	0	2015-03-28	\N	\N	Hold	finish-tests	8	Idea	2015-03-28 12:47:27.003499	2015-03-28 12:47:27.003499	4
43	Admin set up	Set up admin section to do admin stuff online.	\N	\N	1	0	2015-03-28	\N	\N	Hold	admin-set-up	8	Idea	2015-03-28 12:51:35.258481	2015-03-28 12:51:35.258481	5
45	Coupon design	Optimize coupon design	\N	\N	1	0	2015-03-28	\N	\N	Hold	coupon-design	8	Idea	2015-03-28 13:23:39.527227	2015-03-28 13:23:39.527227	6
46	remove cash back	remove the cash back info	\N	\N	1	0	2015-03-28	\N	\N	Hold	remove-cash-back-task	45	Task	2015-03-28 13:24:11.697101	2015-03-28 13:24:11.697101	1
47	Add modal	Add a modal for coupon codes to make sure you get the click.	\N	\N	1	0	2015-03-28	\N	\N	Hold	add-modal	45	Task	2015-03-28 13:24:45.195277	2015-03-28 13:24:45.195277	2
40	LS auto store	Load stores automatically for Link share.	\N	\N	1	100	2015-03-28	2015-04-04	\N	Active	ls-auto-store	8	Idea	2015-03-28 12:45:41.274061	2015-04-05 03:59:39.78539	2
44	Remove stores	Remove store if not active. Don't display if not active.	\N	\N	1	0	2015-03-28	\N	\N	Hold	remove-stores	40	Task	2015-03-28 12:53:27.966565	2015-04-05 04:24:07.598341	1
48	delete coupons	set up admin way to delete coupons.	\N	\N	1	0	2015-04-04	\N	\N	Hold	delete-coupons	43	Task	2015-04-05 04:32:51.059621	2015-04-05 04:32:51.059621	1
49	Update stores	set up admin way to update all stores from LS, Ebay, ect.	\N	\N	1	0	2015-04-04	\N	\N	Hold	update-stores	43	Task	2015-04-05 04:34:08.32591	2015-04-05 04:34:08.32591	2
\.


--
-- Name: tasks_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kirk
--

SELECT pg_catalog.setval('tasks_id_seq', 49, true);


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: kirk
--

COPY users (id, email, encrypted_password, reset_password_token, reset_password_sent_at, remember_created_at, sign_in_count, current_sign_in_at, last_sign_in_at, current_sign_in_ip, last_sign_in_ip, created_at, updated_at, confirmation_token, confirmed_at, confirmation_sent_at, slug) FROM stdin;
2	kcjarvis56@hotmail.com	$2a$10$xYS3.aGBUF88GCU9raJ1yuN4UI4niP3dNE2JF8/vgHFL9PUtLIBfm	\N	\N	\N	1	2014-12-21 04:59:11.969113	2014-12-21 04:59:11.969113	127.0.0.1	127.0.0.1	2014-12-21 04:59:10.756985	2014-12-21 04:59:11.970507	1bebd7885174f50c8b74f849995b04b3e25793b631a8fab1536005e5e7a7daa3	\N	2014-12-21 04:59:11.585268	kcjarvis56-hotmail-com
1	kirk.jarvs@gmail.com	$2a$10$9MglBnzOLkoq5AeFTAOpsuao0A3cxoKCt4yjgkssgl3EgZgCIcNIO	\N	\N	\N	8	2015-03-11 01:15:59.356135	2014-12-27 15:14:31.906713	192.168.0.13	192.168.0.13	2014-12-20 14:38:57.699081	2015-03-11 01:15:59.358582	114ade33496dd84251aea483a46cd6cb54ef2e50434b5a4025a4f4e75f3e394b	2014-12-22 05:11:27.288407	2014-12-20 14:38:58.513114	kirk-jarvs-gmail-com
\.


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kirk
--

SELECT pg_catalog.setval('users_id_seq', 2, true);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: kirk; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: friendly_id_slugs_pkey; Type: CONSTRAINT; Schema: public; Owner: kirk; Tablespace: 
--

ALTER TABLE ONLY friendly_id_slugs
    ADD CONSTRAINT friendly_id_slugs_pkey PRIMARY KEY (id);


--
-- Name: idea_links_pkey; Type: CONSTRAINT; Schema: public; Owner: kirk; Tablespace: 
--

ALTER TABLE ONLY idea_links
    ADD CONSTRAINT idea_links_pkey PRIMARY KEY (id);


--
-- Name: ideas_pkey; Type: CONSTRAINT; Schema: public; Owner: kirk; Tablespace: 
--

ALTER TABLE ONLY ideas
    ADD CONSTRAINT ideas_pkey PRIMARY KEY (id);


--
-- Name: notes_pkey; Type: CONSTRAINT; Schema: public; Owner: kirk; Tablespace: 
--

ALTER TABLE ONLY notes
    ADD CONSTRAINT notes_pkey PRIMARY KEY (id);


--
-- Name: tasks_pkey; Type: CONSTRAINT; Schema: public; Owner: kirk; Tablespace: 
--

ALTER TABLE ONLY tasks
    ADD CONSTRAINT tasks_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: kirk; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_categories_ideas_on_idea_id_and_category_id; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_categories_ideas_on_idea_id_and_category_id ON categories_ideas USING btree (idea_id, category_id);


--
-- Name: index_categories_on_slug; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_categories_on_slug ON categories USING btree (slug);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type ON friendly_id_slugs USING btree (slug, sluggable_type);


--
-- Name: index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE UNIQUE INDEX index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope ON friendly_id_slugs USING btree (slug, sluggable_type, scope);


--
-- Name: index_friendly_id_slugs_on_sluggable_id; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_id ON friendly_id_slugs USING btree (sluggable_id);


--
-- Name: index_friendly_id_slugs_on_sluggable_type; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_friendly_id_slugs_on_sluggable_type ON friendly_id_slugs USING btree (sluggable_type);


--
-- Name: index_idea_links_on_idea_linkable_id_and_idea_linkable_type; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_idea_links_on_idea_linkable_id_and_idea_linkable_type ON idea_links USING btree (idea_linkable_id, idea_linkable_type);


--
-- Name: index_idea_links_on_user_id; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_idea_links_on_user_id ON idea_links USING btree (user_id);


--
-- Name: index_ideas_on_user_id; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_ideas_on_user_id ON ideas USING btree (user_id);


--
-- Name: index_notes_on_notable_id_and_notable_type; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_notes_on_notable_id_and_notable_type ON notes USING btree (notable_id, notable_type);


--
-- Name: index_notes_on_user_id; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_notes_on_user_id ON notes USING btree (user_id);


--
-- Name: index_tasks_on_taskable_id_and_taskable_type; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_tasks_on_taskable_id_and_taskable_type ON tasks USING btree (taskable_id, taskable_type);


--
-- Name: index_tasks_on_user_id; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_tasks_on_user_id ON tasks USING btree (user_id);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: index_users_on_slug; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE INDEX index_users_on_slug ON users USING btree (slug);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: kirk; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


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

