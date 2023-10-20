CREATE TABLE animals (
    id INT NOT NULL,
    name VARCHAR(100),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL,
    PRIMARY KEY (id)
);

ALTER TABLE animals
ADD species VARCHAR(100);

-- Owners
CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(250),
    age INT,
);

-- Species
CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

-- Update animals table to set id to auto-increment
CREATE TABLE animals_update (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    date_of_birth DATE,
    escape_attempts INT,
    neutered BOOLEAN,
    weight_kg DECIMAL,
    species VARCHAR(100)
);

INSERT INTO animals_update
SELECT *
FROM animals;

DROP TABLE animals;
RENAME TABLE animals_update TO animals;

-- remove column species
ALTER TABLE animals
DROP COLUMN species;

-- add column species_id
ALTER TABLE animals
ADD COLUMN species_id INT

ALTER TABLE animals
ADD CONSTRAINT fk_species
FOREIGN KEY(species_id)
REFERENCES species(id);

-- add column owner_id
ALTER TABLE animals
ADD COLUMN owner_id INT

ALTER TABLE animals
ADD CONSTRAINT fk_owners
FOREIGN KEY(owner_id)
REFERENCES owners(id);