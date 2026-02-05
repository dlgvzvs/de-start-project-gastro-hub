BEGIN; -- запускаю транзакцию
EXCLUSIVE -- разрешаю чтение таблицы, а изменения запрещаю
ALTER TABLE cafe.managers ADD COLUMN phone_numbers_array -- создаю поле для массива номеров телефонов
SELECT -- может этот селект переместить в отдельный СТЕ? Сам пока не знаю.
	ROW_NUMBER() OVER (ORDER BY manager ASC) AS moy_poryadkoviy_nomer_na_rukave -- ранжирую менеджеров по алфавиту
	manager_phone, -- старый телефон
	moy_poryadkoviy_nomer_na_rukave + 99 AS corrent_rank -- чтобы отсчёт начинался с числа 100, я добавляю 99
	CONCAT('8-800-2500-', correct_rank) AS new_phone -- тут нужен CONCAT для нового номера телефонаы
FROM cafe.managers;
UPDATE cafe.managers -- обновляю данные в новом столбце
phone_numbers_array = ARRAY[manager_phone, new_phone] -- закидываю в новый столбец массив из старого и нового телефона
SAVEPOINT already_created_new_array -- на всякий случай делаю точки сохранения
ALTER TABLE cafe.managers DELETE COLUMN manager_phone -- удаляю неактуальные старые данные
COMMIT; -- подтверждаю транзакцию
