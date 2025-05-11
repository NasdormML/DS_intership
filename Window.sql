SELECT acc,
       name,
       email,
       phone
FROM (
    SELECT
      acc,
      name,
      email,
      phone,
      COUNT(*) 
        OVER (
          PARTITION BY RIGHT(REGEXP_REPLACE(phone, '\D', '', 'g'), 10)
        ) AS cnt
    FROM accounts
) t
WHERE cnt > 1
ORDER BY RIGHT(REGEXP_REPLACE(phone, '\D', '', 'g'), 10), acc;
