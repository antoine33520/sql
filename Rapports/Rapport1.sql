SELECT *
FROM (SELECT e.last_name ||' '|| e.first_name "Meilleur employée"
FROM t_employee e 
JOIN t_reservation r
USING (employee_id)
GROUP BY employee_id, e.last_name, e.first_name
ORDER BY count (r.reservation_id)desc)
WHERE ROWNUM <= 1 ;
