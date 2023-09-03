CREATE TABLE "user" (
    id SERIAL PRIMARY KEY,
    user_name VARCHAR(100) UNIQUE NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password VARCHAR(100) NOT NULL,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE profile (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    dob VARCHAR(100) NOT NULL,
    user_id  INTEGER UNIQUE,
    FOREIGN KEY (user_id) REFERENCES "user" (id)
);

CREATE TABLE accounts (
    id SERIAL PRIMARY KEY, 
    server_id VARCHAR(255) UNIQUE NOT NULL,
    user_id INTEGER UNIQUE,
    FOREIGN KEY (user_id) REFERENCES "user" (id)

);

CREATE TABLE web_server (
    id SERIAL PRIMARY KEY,
    server_id VARCHAR(255) UNIQUE NOT NULL,
    server_ip VARCHAR(100) UNIQUE NOT NULL,
    server_name VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE data (
    id SERIAL PRIMARY KEY,
    user_id INTEGER,
    email VARCHAR(255),
    password VARCHAR(100),
    preferences VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES "user" (id)
);

ALTER TABLE accounts
ADD FOREIGN KEY (server_id) 
REFERENCES web_server (server_id);

CREATE OR REPLACE FUNCTION insert_into_profile()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO profile (name, dob, user_id)
    VALUES (NEW.name, '01-01-2000', NEW.id);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER register_user_trigger
AFTER INSERT ON "user"
FOR EACH ROW
EXECUTE FUNCTION insert_into_profile();

CREATE OR REPLACE FUNCTION update_user_preferences()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE data
    SET email = NEW.email,
        password = NEW.password,
        preferences = NEW.preferences
    WHERE user_id = NEW.user_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_preferences_trigger
AFTER UPDATE ON "user"
FOR EACH ROW
WHEN (NEW.preferences IS NOT NULL)
EXECUTE FUNCTION update_user_preferences();


