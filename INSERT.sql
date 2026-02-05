INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_work_date, end_work_date) -- заполняю справочник
SELECT 
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(s.report_date) AS start_work_date,
    MAX(s.report_date) AS end_work_date
FROM raw_data.sales rds
JOIN cafe.restaurants r ON rds.cafe_name = r.cafe_name
JOIN cafe.managers m ON rds.manager = m.manager AND rds.manager_phone = m.manager_phone
GROUP BY r.restaurant_uuid, m.manager_uuid;

CREATE TABLE IF NOT EXISTS cafe.sales ( -- формирую новую таблицу продаж на основе сырой таблицы
	date DATE,
	restaurant_uuid VARCHAR REFERENCES restaurants.restaurant_uuid,
	avg_check
	PRIMARY KEY (date, restaurant_uuid)
	);

INSERT INTO cafe.restaurants (restaurant_uuid, cafe_name, type, menu) -- заполняю справочник
SELECT
	GEN_RANDOM_UUID(),
	m.cafe_name, 
    type, 
    menu::JSONB
FROM raw_data.menu m
GROUP BY cafe_name, type;

-- Думал вставить вот такой вариант (по примеру из задания 5), но есть подозрения, что в поле type попадёт не то, что надо.
--INSERT INTO cafe.restaurants (restaurant_uuid, cafe_name, type, menu)
--SELECT
	--GEN_RANDOM_UUID(),
	--m.cafe_name,
	--category.key AS category_name,
	--dishes::jsonb
--FROM raw_data.menu m
--JOIN JSON_EACH_TEXT(m.menu::json) category
--JOIN JSON_EACH_TEXT(category.value::json) dishes;

INSERT INTO cafe.managers ( -- заполняю справочник
SELECT
	GEN_RANDOM_UUID(),
	manager, 
    manager_phone
FROM raw_data.sales
GROUP BY manager, manager_phone;

INSERT INTO cafe.sales (date, restaurant_uuid, avg_check) -- заполняю таблицу продаж
SELECT
	report_date,
	restaurant_uuid,
	avg_check
FROM raw_data.sales;
JOIN cafe.restaurants ON raw_data.sales.cafe_name = cafe.restaurants.cafe_name;
