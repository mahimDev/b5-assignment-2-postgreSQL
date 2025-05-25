-- ranger table
CREATE TABLE rangers (
    ranger_id SERIAL PRIMARY KEY,
    "name" VARCHAR(100) NOT NULL,
    region VARCHAR(100) NOT NULL
);

-- species table
CREATE TABLE species (
    species_id SERIAL PRIMARY KEY,
    common_name VARCHAR(100) NOT NULL,
    scientific_name VARCHAR(150) NOT NULL,
    discovery_date DATE NOT NULL,
    conservation_status VARCHAR(50) NOT NULL CHECK (
        conservation_status IN ('Endangered', 'Vulnerable', 'Historic')
    )
);

-- sightings
CREATE TABLE sightings (
    sighting_id SERIAL PRIMARY KEY,
    ranger_id INT REFERENCES rangers(ranger_id),
    species_id INT REFERENCES species(species_id),
    sighting_time TIMESTAMP NOT NULL,
    location VARCHAR(100) NOT NULL,
    notes TEXT
);

----------------------------
--     data insertion     --
----------------------------

-- rangers
INSERT INTO rangers (ranger_id, name, region) VALUES 
(1, 'Alice Green', 'Northern Hills'),
(2, 'Bob White', 'River Delta'),
(3, 'Carol King', 'Mountain Range');

-- species

INSERT INTO species (
    species_id,common_name, scientific_name,discovery_date , 
    conservation_status) VALUES 
(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


-- sightings

INSERT INTO sightings (sighting_id,species_id,ranger_id,location,
sighting_time , notes) VALUES
(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL);


--------------------
-- prb sls
--------------------

--pb-1
INSERT INTO rangers(name, region) VALUES ('Derek Fox', 'Coastal Plains');

--pb-2
SELECT COUNT(DISTINCT species_id) unique_species_count FROM sightings;

--pb-3

SELECT * FROM sightings
WHERE location ILIKE '%Pass%';

--pb-4

SELECT r.name, COUNT(s.sighting_id) as total_sightings FROM rangers r
LEFT JOIN sightings s ON r.ranger_id = s.ranger_id
GROUP BY r.ranger_id, r.name;

--pb-5
SELECT s.common_name FROM species s 
LEFT JOIN sightings si ON s.species_id = si.species_id
WHERE si.sighting_id IS NULL;

--pb-6
SELECT sp.common_name, si.sighting_time, r.name
FROM sightings si
JOIN species sp ON si.species_id = sp.species_id
JOIN rangers r ON si.ranger_id = r.ranger_id
ORDER BY si.sighting_time DESC
LIMIT 2;

--pb-7
UPDATE species
SET conservation_status = 'Historic'
WHERE discovery_date < '1800-01-01';

--pb-8
SELECT sighting_id,
    CASE
        WHEN EXTRACT(HOUR FROM sighting_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sighting_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_day
FROM sightings;

--pb-9

DELETE FROM rangers
WHERE ranger_id NOT IN (
    SELECT DISTINCT ranger_id FROM sightings
);