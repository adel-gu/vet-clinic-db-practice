/*Queries that provide answers to the questions from all projects.*/
-- Find all animals whose name ends in "mon".
SELECT * FROM animals
WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT * FROM animals
WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-01-01';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT * FROM animals
WHERE neutered = true AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth
FROM animals
WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts
FROM animals
WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals
WHERE neutered = true;

SELECT * FROM animals
WHERE name != 'Gabumon';

SELECT * FROM animals
WHERE weight_kg BETWEEN 10.4 AND 17.3;

.
BEGIN;

UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';

UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;

COMMIT;

BEGIN;
DELETE FROM animals;

ROLLBACK;

BEGIN;

DELETE FROM animals
WHERE date_of_birth > '2022-01-01';

SAVEPOINT delete_animals;

UPDATE animals
SET weight_kg = weight_kg * -1;

ROLLBACK TO delete_animals;

COMMIT;

-- Write queries to answer the following questions:
-- How many animals are there?
SELECT COUNT(*)
FROM animals;

-- How many animals have never tried to escape?

SELECT COUNT(*)
FROM animals
WHERE escape_attempts = 0;

-- What is the average weight of animals?
SELECT AVG(weight_kg)
FROM animals;

-- Who escapes the most, neutered or not neutered animals?

WITH sub AS (
  SELECT neutered, AVG(escape_attempts) AS "avg escape attempts"
  FROM animals
  GROUP BY neutered
)

SELECT sub.neutered, sub."avg escape attempts"
FROM sub
WHERE sub."avg escape attempts" = (
  SELECT MAX(sub."avg escape attempts")
  FROM sub
);

-- What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg), MAX(weight_kg)
FROM animals
GROUP BY species;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?

SELECT species, AVG(escape_attempts)
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-30'
GROUP BY species;

-- Write queries (using JOIN) to answer the following questions:

-- What animals belong to Melody Pond?
SELECT animals.name, owners.full_name
FROM animals
JOIN owners
  ON animals.owner_id = owners.id
  WHERE owners.full_name = 'Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT animals.name, species.name
FROM animals
JOIN species
  ON animals.species_id = species.id
  WHERE species.name = 'Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT owners.full_name AS "Owner name", animals.name AS "Animal name"
FROM owners
FULL JOIN animals
  ON owners.id = animals.owner_id;

-- How many animals are there per species?
SELECT species.name, COUNT(animals.name)
FROM species
JOIN animals
  ON species.id = animals.species_id
GROUP BY species.name;

-- List all Digimon owned by Jennifer Orwell.
SELECT animals.name, owners.full_name
FROM animals
JOIN owners
  ON animals.owner_id = owners.id
JOIN species
  ON animals.species_id = species.id
  WHERE species.name = 'Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT animals.name, owners.full_name, animals.escape_attempts
FROM animals
JOIN owners
  ON animals.owner_id = owners.id
  WHERE owners.full_name = 'Dean Winchester'
  AND animals.escape_attempts = 0;

-- Who owns the most animals?
WITH sub AS (
  SELECT owners.full_name AS "Owner name", COUNT(animals.name) AS "Animal count"
  FROM owners
  JOIN animals
  ON owners.id = animals.owner_id
  GROUP BY owners.full_name
)

SELECT * FROM sub
WHERE "Animal count" = (
  SELECT MAX(sub."Animal count")
  FROM sub
);
