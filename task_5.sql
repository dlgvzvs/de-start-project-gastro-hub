WITH menu_cte AS ( -- делаю отбор всех пицц
	SELECT
		m.cafe_name,
		category.key AS category_name,
		dishes.key AS nomenclature,
		dishes.value::integer AS price
	FROM raw_data.menu m
	JOIN JSON_EACH_TEXT(m.menu::json) category
	JOIN JSON_EACH_TEXT(category.value::json) dishes
	WHERE category.key = 'Пицца'),

WITH menu_with_rank AS ( -- проставляю рейтинг по убыванию цены
      SELECT
          cte.*,
          ROW_NUMBER() OVER (PARTITION BY cte.cafe_name ORDER BY cte.price DESC) AS rating
      FROM menu_cte cte
)
	
SELECT -- вывожу таблицу по запросу, показывая самые дорогие пиццы
	cafe_name,
	category_name,
	nomenclature,
	price
FROM menu_with_rank
WHERE rating = 1
ORDER BY cafe_name ASC;
