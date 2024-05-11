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
    name varchar(128) UNIQUE NOT NULL
);

CREATE TABLE history
(
    id bigint generated always as identity primary key,
    history(id) bigint unique references location(id) NOT NULL,
    description TEXT
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
    model VARCHAR(128) NOT NULL,
    description TEXT
);

CREATE TABLE catapult
(
    id bigint generated always as identity primary key,
    rocket bigint unique references rocket(id) NOT NULL,
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

-- 1
CREATE OR REPLACE FUNCTION update_rocket_description()
RETURNS TRIGGER AS
$$
BEGIN
    IF NEW.punching_power <= 50 THEN

        UPDATE catapult
        SET description = 'Катапульта вещает: "Ракета недостаточно мощная, не могу пульнуть сорян :("'
        WHERE rocket = NEW.id;
    END IF;

    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER rocket_punching_power_trigger
AFTER UPDATE ON rocket
FOR EACH ROW
EXECUTE FUNCTION update_rocket_description();