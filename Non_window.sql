SELECT acc,
       name,
       email,
       phone
FROM accounts
WHERE RIGHT(REGEXP_REPLACE(phone, '\D', '', 'g'), 10)
      IN (
        SELECT RIGHT(REGEXP_REPLACE(phone, '\D', '', 'g'), 10)
        FROM accounts
        GROUP BY RIGHT(REGEXP_REPLACE(phone, '\D', '', 'g'), 10)
        HAVING COUNT(*) > 1
      )
ORDER BY acc;
