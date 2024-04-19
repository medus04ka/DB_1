-- ограничение
CREATE OR REPLACE FUNCTION check_depart_arrival()
    RETURNS TRIGGER AS $$
BEGIN
    IF NEW.depart = NEW.arrival THEN
        RAISE EXCEPTION 'Сорян, бро не обыграет систему жизни';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- сам триггер
CREATE TRIGGER check_depart_arrival_different
BEFORE INSERT ON flights
FOR EACH ROW
EXECUTE FUNCTION check_depart_arrival();

-- 2 рандом (поиграться)
CREATE OR REPLACE FUNCTION check_location_references()
    RETURNS TRIGGER AS $$
BEGIN
    -- Проверяем, есть ли рейсы, отправляющиеся из локейшн
    IF EXISTS (SELECT 1 FROM flights WHERE depart = OLD.id) THEN
        RAISE EXCEPTION 'Ты не снесешь место с отправками (особенно когда они активные)';
    END IF;

    -- Проверяем, есть ли рейсы, прибывающие в локейшн
    IF EXISTS (SELECT 1 FROM flights WHERE arrival = OLD.id) THEN
        RAISE EXCEPTION 'Ты не снесешь место прибывания (особенно когда оно активное)';
    END IF;

    -- Проверяем, есть ли нпси тут
    IF EXISTS (SELECT 1 FROM character WHERE location = OLD.id) THEN
        RAISE EXCEPTION 'Ты не снесешь место где живут нпси (особенно если их там много)';
    END IF;

    RETURN OLD;
END;
$$ LANGUAGE plpgsql;

-- рандом, триггер
CREATE TRIGGER prevent_location_deletion
    BEFORE DELETE ON location
    FOR EACH ROW
EXECUTE FUNCTION check_location_references();

