CREATE VIEW top_3_restaurants AS ( -- вывожу на экран топ-3 ресторана
 	WITH ranked_restaurants AS (
		SELECT
 			r.cafe_name,
 			r.type,
 			ROUND(AVG(avg_check),2) AS average_check
 			ROW_NUMBER() OVER (PARTITION BY r.type ORDER BY AVG(s.avg_check) DESC) AS rating
 		FROM cafe.restaurants r
 		JOIN cafe.sales s ON r.restaurant_uuid = s.restaurant_uuid
 		GROUP BY r.cafe_name, r.type)
 	SELECT *
 	FROM ranked_restaurants
 	WHERE rating <=3
);
