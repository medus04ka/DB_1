DROP TABLE IF EXISTS catapult CASCADE;
DROP TABLE IF EXISTS character CASCADE;
DROP TABLE IF EXISTS flights CASCADE;
DROP TABLE IF EXISTS location CASCADE;
DROP TABLE IF EXISTS rocket CASCADE;
DROP TABLE IF EXISTS viewpoint CASCADE;
DROP TABLE IF EXISTS catapult_structure CASCADE;
DROP TABLE IF EXISTS object_viewpoint CASCADE;
DROP TABLE IF EXISTS feelings_character CASCADE;
DROP TABLE IF EXISTS feelings CASCADE;

CREATE TABLE location
(
    id bigint generated always as identity primary key,
    name varchar(128) UNIQUE NOT NULL,
    history TEXT
);

CREATE TABLE flights
(
    id bigint generated always as identity primary key,
    security_lvl int NOT NULL,
    description TEXT,
    depart bigint references location(id) NOT NULL,
    arrival bigint references location(id) NOT NULL
);

CREATE TABLE rocket
(
    id bigint generated always as identity primary key,
    type VARCHAR(128) NOT NULL,
    weight int NOT NULL,
    punching_power int NOT NULL,
    direction bigint references flights(id) NOT NULL,
    acceleration int NOT NULL
);

CREATE TABLE catapult_structure
(
    id int generated always as identity primary key,
    model VARCHAR(128) UNIQUE NOT NULL,
    description TEXT
);

CREATE TABLE catapult
(
    id bigint generated always as identity primary key,
    rocket bigint references rocket(id) NOT NULL,
    structure int references catapult_structure(id) NOT NULL,
    description TEXT,
    location bigint references location(id) NOT NULL
);

CREATE TABLE object_viewpoint
(
    id int generated always as identity primary key,
    object int NOT NULL,
    rightness TEXT
);

CREATE TABLE viewpoint
(
    id int generated always as identity primary key,
    object_id int references object_viewpoint(id) NOT NULL,
    description TEXT
);

CREATE TABLE character
(
    id int generated always as identity primary key,
    name VARCHAR(64) NOT NULL,
    charging_capacity int NOT NULL,
    location bigint references location(id) NOT NULL,
    viewpoint int references viewpoint(id) NOT NULL
);

CREATE TABLE feelings
(
    id int generated always as identity primary key,
    description TEXT,
    reason VARCHAR(128)
);

CREATE TABLE feelings_character
(
    id_feelings int references feelings(id),
    id_character int references character(id)
);

INSERT INTO location(name, history) VALUES ('Германия', 'вселенная анимешки\манги "монстр" ');
INSERT INTO location(name, history) VALUES ('Грандлайн', 'вселенная анимешки\манги "Ванпис" ');
INSERT INTO object_viewpoint(object, rightness) VALUES (1,'true');
INSERT INTO object_viewpoint(object, rightness) VALUES (2,'false');
INSERT INTO viewpoint(object_id, description) VALUES (1,'блаблабла');
INSERT INTO viewpoint(object_id, description) VALUES (2,'sdfgdsfdg');
INSERT INTO character(name, charging_capacity, location, viewpoint) VALUES ('Флойд', 100, 1, 1);
INSERT INTO character(name, charging_capacity, location, viewpoint) VALUES ('Миша', 200, 2, 2);
INSERT INTO flights(security_lvl, description, depart, arrival) VALUES ('35','oiksfmldn', 1, 2);
INSERT INTO rocket(type, weight, punching_power, direction, acceleration) VALUES ('земля-воздух', 1000, 1500, 1, 100);
INSERT INTO catapult_structure(model, description) VALUES ('RTX72','12345654321');
INSERT INTO catapult(rocket, structure, description, location) VALUES (1, 1, 'ляляля', 1);
INSERT INTO feelings(description, reason) VALUES ('', 'psihicheskie otkloneniya');