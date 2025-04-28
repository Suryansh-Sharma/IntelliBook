-- SELECT
--     TO_CHAR(t.timestamp, 'FMMonth') AS month_name,
--     tg.name AS tag_name,
--     SUM(t.amount) AS total_amount
-- FROM
--     user_entity u
-- INNER JOIN category c ON c.user_id = u.id
-- INNER JOIN category_tags ct ON ct.category_id = c.id
-- INNER JOIN tag tg ON tg.id = ct.tag_id
-- INNER JOIN "transaction" t ON t.category_id = c.id
-- WHERE
--     u.id = 1
--     AND t.timestamp BETWEEN '2025-01-01 07:04:56.789' AND '2025-10-01 07:04:56.789'
-- GROUP BY
--     TO_CHAR(t.timestamp, 'FMMonth'),
--     tg.name
-- ORDER BY
--     MIN(t.timestamp); 
SELECT
	TO_CHAR(T.TIMESTAMP, 'FMMonth') AS MONTH_NAME,
	COALESCE(SUM(T.AMOUNT), 0) AS AMOUNT,
	EXTRACT(
		MONTH
		FROM
			T.TIMESTAMP
	) AS MONTH_ORDER
FROM
	TRANSACTION T
	JOIN CATEGORY C ON C.ID = T.CATEGORY_ID
	LEFT JOIN TRANSACTION_TAGS TT ON T.ID = TT.TRANSACTION_ID
	LEFT JOIN TAG TG ON TG.ID = TT.TAG_ID
WHERE
	T.USER_ID = 1
	AND T.TIMESTAMP BETWEEN '2025-01-01 07:04:56.789' AND '2025-10-01 07:04:56.789'
GROUP BY
	TO_CHAR(T.TIMESTAMP, 'FMMonth'),
	EXTRACT(
		MONTH
		FROM
			T.TIMESTAMP
	)
ORDER BY
	MONTH_ORDER