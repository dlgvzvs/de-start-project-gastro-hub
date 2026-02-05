-- Тут вопрос - что считать пиццерией? Все заведения со словом "пиццерия" в названии или все, у кого есть хотя бы одна пицца в продаже?

WITH only_pizzerias AS ( -- отбираю пиццерии (если в продаже есть хотя бы 1 пицца)
SELECT
	cafe_name,
	menu::json
FROM cafe.restaurants
WHERE EXISTS (
    SELECT 1
    FROM JSON_EACH_TEXT(menu::json) AS category
    WHERE category.key = 'Пицца')
),

pizzas AS ( -- выбираю пиццы из всего перечня блюд и напитков
SELECT
	cafe_name,
    JSON_EACH_TEXT(menu::json) AS category
FROM only_pizzerias
WHERE category.key = 'Пицца'),

ranking_pizzas AS ( -- ранжирую пиццерии по количеству пицц в меню
SELECT
	cafe_name,
    COUNT(*) AS number_of_pizzas,
    DENSE_RANK() OVER (ORDER BY number_of_pizzas DESC) AS rank
FROM pizzas
GROUP BY cafe_name)

SELECT -- вывожу на экран запрос
	cafe_name,
	number_of_pizzas
FROM ranking_pizzas
WHERE rank = 1;
