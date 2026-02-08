BEGIN; -- запускаю транзакцию по заполнению таблиц

INSERT INTO cafe.restaurants (restaurant_uuid, cafe_name, type, menu) -- заполняю справочник
SELECT
	GEN_RANDOM_UUID(),
	m.cafe_name,
    CAST(s.type AS cafe.restaurant_type) AS type,
    menu::JSONB
FROM raw_data.menu m
JOIN raw_data.sales s ON m.cafe_name = s.cafe_name
GROUP BY cafe_name, type, menu; -- добавил группировку по меню (не совсем понял, для чего нужно группировать по json-объекту, но ладно)

INSERT INTO cafe.managers (manager_uuid, manager, manager_phone) -- указал заполняемые столбцы
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
FROM raw_data.sales -- убрал точку с запятой
JOIN cafe.restaurants ON raw_data.sales.cafe_name = cafe.restaurants.cafe_name;

INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_work_date, end_work_date) -- заполняю справочник
SELECT 
    r.restaurant_uuid,
    m.manager_uuid,
    MIN(rds.report_date) AS start_work_date, -- исправил алиас
    MAX(rds.report_date) AS end_work_date -- и здесь
FROM raw_data.sales rds
JOIN cafe.restaurants r ON rds.cafe_name = r.cafe_name
JOIN cafe.managers m ON rds.manager = m.manager AND rds.manager_phone = m.manager_phone
GROUP BY r.restaurant_uuid, m.manager_uuid;

COMMIT; -- заканчиваю заполнять таблицы
ROLLBACK; -- откатываюсь назад (при необходимости)
