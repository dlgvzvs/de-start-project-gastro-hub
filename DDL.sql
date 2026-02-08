BEGIN; -- запускаю транзакцию по созданию таблиц

CREATE SCHEMA IF NOT EXISTS cafe; -- создаю схему, если её ещё не было

CREATE TYPE cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria'); -- создаю енум для 4 типов заведений

CREATE TABLE IF NOT EXISTS cafe.restaurants ( -- создаю справочник ресторанов
	restaurant_uuid UUID PRIMARY KEY NOT NULL DEFAULT GEN_RANDOM_UUID(),
	cafe_name VARCHAR,
	type cafe.restaurant_type,
	menu JSONB
	);

SELECT * FROM cafe.restaurants; -- это для проверки, можно удалить. DBeaver косячит, селект работает, а таблицу в списке не видно.

CREATE TABLE IF NOT EXISTS cafe.managers ( -- создаю справочник менеджеров
	manager_uuid UUID PRIMARY KEY NOT NULL DEFAULT GEN_RANDOM_UUID(),
	manager VARCHAR, 
	manager_phone VARCHAR
	);

CREATE TABLE IF NOT EXISTS cafe.restaurant_manager_work_dates ( -- создаю справочник трудового стажа менеджеров
	restaurant_uuid UUID REFERENCES cafe.restaurants(restaurant_uuid),
	manager_uuid UUID REFERENCES cafe.managers(manager_uuid),
	start_work_date DATE,
	end_work_date DATE,
	PRIMARY KEY (restaurant_uuid, manager_uuid)
	);

CREATE TABLE IF NOT EXISTS cafe.sales ( -- формирую новую таблицу продаж на основе сырой таблицы
	date DATE,
	restaurant_uuid UUID REFERENCES cafe.restaurants.restaurant_uuid, -- добавил тип UUID
	avg_check NUMERIC(6, 2), -- добавил тип NUMERIC как в описании задания
	PRIMARY KEY (date, restaurant_uuid)
	);

COMMIT; -- заканчиваю создавать таблицы
ROLLBACK; -- откатываюсь назад (при необходимости)
