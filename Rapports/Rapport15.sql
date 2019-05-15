SELECT
  UPPER(e.last_name) || ' ' || e.first_name "NOM    Prénom",
  NVL(r.cr, 0) "Nb réservations"
FROM
  t_employee e FULL
  OUTER JOIN (
    SELECT
      employee_id,
      COUNT(reservation_id) cr
    FROM
      t_reservation
    GROUP BY
      employee_id
  ) r ON r.employee_id = e.employee_id START WITH e.manager_id = 1 CONNECT BY PRIOR e.employee_id = e.manager_id;