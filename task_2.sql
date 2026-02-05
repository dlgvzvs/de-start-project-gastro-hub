-- Запутался в оконных функциях и подзапросах. Изначально предполагал в CTE extracting_years прописать оконную функцию с разбиением
-- среднего чека по годам, но потом решил вместо этого прописать GROUP BY. Не уверен, как было бы лучше.

CREATE MATERIALIZED VIEW avg_check_dynamics_by_years AS (
	WITH extracting_years AS ( -- собираю информацию по годам
		SELECT DISTINCT
			r.cafe_name,
			EXTRACT(YEAR FROM date) AS year,
			AVG(avg_check) AS chosen_year_check -- усредняю цены по типам заведений и годам
		FROM cafe.sales s
		JOIN cafe.restaurants r ON s.restaurant_uuid = r.restaurant_uuid
		WHERE EXTRACT(YEAR FROM s.date) <> 2023 -- исключаю 2023-ий год
		GROUP BY EXTRACT(YEAR FROM s.date), r.cafe_name
	),
	SELECT -- вывожу информацию на экран
		extracting_years.year,
		cafe_name,
		chosen_year_check, -- беру среднюю цену за текущий год (в разрезе наименований заведений)
		LAG(chosen_year_check) OVER (PARTITION BY cafe_name ORDER BY year) AS prev_year_check, -- беру среднюю цену за год со смещением на 1 год назад (в разрезе наименований заведений)
		(chosen_year_check - prev_year_check) / prev_year_check * 100 AS delta
	FROM cafe.restaurants r
	JOIN extracting_years ey ON r.cafe_name = ey.cafe_name
	GROUP BY year, cafe_name, type);
