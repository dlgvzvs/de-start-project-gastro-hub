SELECT
	 cafe_name,
	 COUNT(DISTINCT manager_uuid) AS unique_managers_count -- теперь учитываются только уникальные ID менеджеров
FROM cafe.restaurant_manager_work_dates
JOIN cafe.restaurants USING (restaurant_uuid)
GROUP BY cafe_name -- добавил группировку по названию заведения
ORDER BY unique_managers_count DESC
LIMIT 3;
