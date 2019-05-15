SELECT
  r.reservation_id,
  r.creation_date,
  e.last_name,
  e.first_name,
  c.last_name,
  c.first_name
FROM
  t_reservation r
  JOIN t_employee e ON e.employee_id = r.employee_id
  JOIN t_customer c ON c.customer_id = r.buyer_id
WHERE
  r.creation_date = (
    SELECT
      MIN(creation_date)
    FROM
      t_reservation
  );