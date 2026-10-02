# DATA 635 Assignment 3.2
# Written by Deepika Agnihotri
# Semester : Third semester
# Professor Joel Weymouth
USE cruise;
# Problem 1
SELECT
    p.passenger_id,
    p.first_name,
    p.last_name,
    p.nationality,
    COUNT(t.ticket_id) AS ticket_count,
    SUM(t.ticket_price) AS total_ticket_spent
FROM passenger p
JOIN ticket t
    ON p.passenger_id = t.passenger_id
GROUP BY
    p.passenger_id,
    p.first_name,
    p.last_name,
    p.nationality
ORDER BY total_ticket_spent DESC
LIMIT 10;

# Problem 2
SELECT
    nationality,
    COUNT(*) AS passenger_count
FROM passenger
GROUP BY nationality
ORDER BY passenger_count DESC, nationality ASC;

# Problem 3
SELECT
    r.nationality,
    r.passenger_count,
    r.total_reward_points,
    COALESCE(tp.total_ticket_prices, 0) AS total_ticket_prices
FROM
(
    SELECT
        nationality,
        COUNT(passenger_id) AS passenger_count,
        SUM(reward_points) AS total_reward_points
    FROM passenger
    GROUP BY nationality
) r
LEFT JOIN
(
    SELECT
        p.nationality,
        SUM(t.ticket_price) AS total_ticket_prices
    FROM passenger p
    LEFT JOIN ticket t
        ON p.passenger_id = t.passenger_id
    GROUP BY p.nationality
) tp
    ON r.nationality = tp.nationality
ORDER BY r.total_reward_points DESC, r.nationality ASC;
# Problem 4
SELECT
    c.captain_id,
    c.first_name AS captain_first_name,
    c.last_name AS captain_last_name,
    s.ship_name,
    COALESCE(SUM(t.ticket_price), 0) AS total_ticket_revenue
FROM captain c
LEFT JOIN ship s
    ON c.ship_id = s.ship_id
LEFT JOIN ticket t
    ON s.ship_id = t.ship_id
GROUP BY
    c.captain_id,
    c.first_name,
    c.last_name,
    s.ship_name
ORDER BY
    c.first_name ASC,
    c.last_name ASC;

# Problem 5
SELECT
    t.ticket_id,
    p.passenger_id,
    p.first_name,
    p.last_name,
    p.nationality,
    s.ship_name,
    s.ship_capacity,
    sch.schedule_id,
    sch.schedule_season,
    sch.days
FROM ticket t
JOIN passenger p
    ON t.passenger_id = p.passenger_id
JOIN ship s
    ON t.ship_id = s.ship_id
JOIN schedule sch
    ON t.schedule_id = sch.schedule_id
WHERE
    sch.days > 20
    OR s.ship_capacity >= 60
ORDER BY t.ticket_id ASC;
# Problem 6
SELECT
    t.ticket_id,
    t.cabin_grade,
    t.ticket_price,
    p.passenger_id,
    p.first_name,
    p.last_name,
    p.nationality,
    p.reward_points,
    s.ship_name,
    sch.schedule_season
FROM ticket t
JOIN passenger p
    ON t.passenger_id = p.passenger_id
JOIN ship s
    ON t.ship_id = s.ship_id
JOIN schedule sch
    ON t.schedule_id = sch.schedule_id
WHERE
    p.is_repeat_customer = 1
    AND sch.schedule_season = 'Summer'
    AND s.ship_name LIKE '%Princess%'
ORDER BY
    p.reward_points DESC,
    t.cabin_grade ASC,
    p.last_name ASC,
    p.first_name ASC;
