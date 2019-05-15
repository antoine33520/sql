SELECT e.first_name  ||' '||  e.last_name AS Employé, COUNT(r.reservation_id) AS Réservation
FROM t_employee e
JOIN t_reservation r
ON e.employee_id = r.employee_id
GROUP BY (e.first_name  ||' '||  e.last_name)
ORDER BY Réservation DESC;

(ca affiche que le derniere samsoul)
