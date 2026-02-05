SELECT DISTINCT -- выбираю уникальные названия заведений, где менялись менеджеры (причём если менеджер мог вернуться, то он считается уникальным). 
                -- Сильно сомневаюсь в своей правоте касательно такого подхода к подсчёту.
	 cafe_name,
	 COUNT(manager_uuid) AS managers_number
FROM cafe.restaurant_manager_work_dates
JOIN cafe.restaurants USING restaurant_uuid
ORDER BY managers_number DESC
LIMIT 3;
