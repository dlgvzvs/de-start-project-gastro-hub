CREATE SCHEMA IF NOT EXISTS cafe; -- создаю схему, если её ещё не было

CREATE TYPE cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria'); -- создаю енум для 4 типов заведений

CREATE TABLE IF NOT EXISTS cafe.restaurants ( -- создаю справочник ресторанов
	restaurant_uuid UUID PRIMARY KEY NOT NULL DEFAULT GEN_RANDOM_UUID(),
	cafe_name VARCHAR,
	type cafe.restaurant_type,
	menu JSONB
	);

CREATE TABLE IF NOT EXISTS cafe.managers ( -- создаю справочник менеджеров
	manager_uuid UUID PRIMARY KEY NOT NULL DAFAULT GEN_RANDOM_UUID(),
	manager VARCHAR, 
	manager_phone VARCHAR
	);

CREATE TABLE IF NOT EXISTS cafe.restaurant_manager_work_dates ( -- создаю справочник трудового стажа менеджеров
	restaurant_uuid UUID VARCHAR REFERENCES restaurants(restaurant_uuid),
	manager_uuid UUID VARCHAR REFERENCES managers(manager_uuid),
	start_work_date DATE,
	end_work_date DATE,
	PRIMARY KEY (restaurant_uuid, manager_uuid)
	);
