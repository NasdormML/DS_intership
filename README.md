# Привет команда R&D!

## Оглавление

- [Задача 1. Стоимость никеля в пятицентовой монете](#задача-1-стоимость-никеля-в-пятицентовой-монете)
- [Задача 2. Поиск дублеров по номеру телефона](#задача-2-поиск-дублеров-по-номеру-телефона)
- [Дублеры аккаунтов по телефону](#дублеры-аккаунтов-по-телефону)

---

## Задача 1. Стоимость никеля в пятицентовой монете

**Условие:**  
Аналитик Светлана заметила, что цена никеля превысила $100.000 за тонну. Пятицентовая монета весит 5 г и содержит 25 % никеля (остальное — медь).  

**Вопрос:**  
Сколько стоит никель, содержащийся в одной монете?

**Решение:**  
1. Цена никеля: $100.000 за 1.000.000 г (1.т = 1.000.000 г) 
2. Стоимость 1 г никеля = $100.000 / 1.000.000 г = $0.10/г
3. Масса никеля в монете: 5 г * 25 % = 1.25 г.  
4. Стоимость никеля в монете: 1.25 г * $0.10/г = $0.125

> **Ответ:** \$0.125

---

## Задача 2. Поиск дублеров по номеру телефона

**Условие:**  
Напишите SQL‑запрос, показывающий аккаунты, заведённые с одного и того же номера телефона.  
Нужно два варианта:  
1. Без оконных функций  
2. С использованием оконных функций 

**Исходная схема:**

```sql
create table accounts (
 acc int primary key,
 name varchar(256),
 email varchar(256),
 phone varchar(256)
);
insert into accounts(acc, name, email, phone) values
(1, 'Alice', 'alice@example.com', '89151234567'),
(2, 'Bob', 'bob@example.com', '+79167654321'),
(3, 'Charlie', 'ch@example.com', '8(985)123-45-67'),
(4, 'Dylan', 'dylan@example.com', '+79167654321'),
(5, 'Eve', 'eve@example.com', '+79167654321'),
(6, 'Frank', 'frank@example.com', '+79851234567'),
(7, 'Glenda', 'glenda@example.com', '+12124504567');
```

**Приложения:**

Non_window.sql — запрос без оконных функций (GROUP BY + HAVING / IN).
```sql
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
```

Window.sql — запрос с использованием оконной функции COUNT() OVER.
```sql
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
```
### Дублеры аккаунтов по телефону

| acc | name    | email             | phone              | normalized_phone |
|-----|---------|-------------------|--------------------|------------------|
| 2   | Bob     | bob@example.com   | +79167654321       | 9167654321       |
| 4   | Dylan   | dylan@example.com | +79167654321       | 9167654321       |
| 5   | Eve     | eve@example.com   | +79167654321       | 9167654321       |
| 3   | Charlie | ch@example.com    | 8(985)123-45-67    | 9851234567       |
| 6   | Frank   | frank@example.com | +79851234567       | 9851234567       |

---
