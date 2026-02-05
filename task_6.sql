BEGIN; -- начинаю транзакцию
WITH new_cappuccino_prices AS (
SELECT
	m.cafe_name,
	(m.menu -> 'Кофе') ->> 'Капучино'::numeric AS old_capp_price
	((m.menu -> 'Кофе') ->> 'Капучино'::numeric * 1.2) AS new_capp_price,
FROM raw_data.menu m
FOR UPDATE) -- включаю блокировку строк (запрещаю даже чтение)

UPDATE cafe.restaurants
SET menu = JSONB_SET(menu, '{Кофе, Капучино}', ncp.new_capp_price) -- вставляю новые цены в меню
FROM new_cappuccino_prices ncp
WHERE cafe.restaurants.cafe_name = ncp.cafe_name;

COMMIT; -- подтверждаю транзакцию
