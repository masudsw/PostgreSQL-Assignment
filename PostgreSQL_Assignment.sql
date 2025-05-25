DROP TABLE IF EXISTS sightings CASCADE;
DROP TABLE IF EXISTS rangers;
DROP TABLE IF EXISTS species;
create table rangers(
	ranger_id serial primary key,
 	name varchar(100) not null,
 	region varchar(150) not null
);

create table species(
	species_id serial primary key,
	common_name varchar(100) not null,
 	scientific_name varchar(100) not null,
 	discovery_date date not null,
 	conservation_status varchar(250) not null
);

create table sightings(
	sighting_id serial primary key,
	ranger_id integer references rangers(ranger_id),
	species_id integer references species(species_id),
	sighting_time timestamp not null,
	location varchar(100) not null,
	notes varchar(250)
);


INSERT INTO rangers (ranger_id, name, region) VALUES
	(1, 'Alice Green', 'Northern Hills'),
	(2, 'Bob White', 'River Delta'),
	(3, 'Carol King', 'Mountain Range');


INSERT INTO species (species_id, common_name, scientific_name, discovery_date, conservation_status) VALUES
	(1, 'Snow Leopard', 'Panthera uncia', '1775-01-01', 'Endangered'),
	(2, 'Bengal Tiger', 'Panthera tigris tigris', '1758-01-01', 'Endangered'),
	(3, 'Red Panda', 'Ailurus fulgens', '1825-01-01', 'Vulnerable'),
	(4, 'Asiatic Elephant', 'Elephas maximus indicus', '1758-01-01', 'Endangered');


INSERT INTO sightings (sighting_id, species_id, ranger_id, location, sighting_time, notes) VALUES
	(1, 1, 1, 'Peak Ridge', '2024-05-10 07:45:00', 'Camera trap image captured'),
	(2, 2, 2, 'Bankwood Area', '2024-05-12 16:20:00', 'Juvenile seen'),
	(3, 3, 3, 'Bamboo Grove East', '2024-05-15 09:10:00', 'Feeding observed'),
	(4, 1, 2, 'Snowfall Pass', '2024-05-18 18:30:00', NULL); 

SELECT setval('rangers_ranger_id_seq', (SELECT MAX(ranger_id) FROM rangers));

insert into rangers(name,region) values('Derek Fox','Coastal Plains');--Problem 1


select count(distinct species_id) as unique_species_count from sightings ;--Problem 2

select sighting_id,species_id,ranger_id,location,sighting_time,notes from sightings where location like('%Pass%');--Problem 3

select rangers.name, count(sightings.ranger_id) as total_sightings from sightings--Problem 4
left join rangers on rangers.ranger_id=sightings.ranger_id
group by rangers.name;

select species.common_name from species--Problem 5
left join
sightings on species.species_id=sightings.species_id
where sightings.species_id is null;


select species.common_name, sightings.sighting_time, rangers.name --Problem 6
from species, sightings,rangers
where sightings.species_id=species.species_id and
sightings.ranger_id=rangers.ranger_id
order by sightings.sighting_time desc
limit 2;


update species--Problem 7
set conservation_status='Historic'
where  extract(year from discovery_date)<1800;


select  sighting_id,--Problem 8
case
when extract (hour from sighting_time)<12 then 'Morning'
when extract (hour from sighting_time)>=12 and extract(hour from sighting_time)<=17 then 'Afternoon'
else 'Evening'
end as time_of_day
from sightings;


delete from rangers --Problem 9
where ranger_id in
(
select  rangers.ranger_id  from rangers
left join sightings on rangers.ranger_id=sightings.ranger_id
where sightings.ranger_id is null
);