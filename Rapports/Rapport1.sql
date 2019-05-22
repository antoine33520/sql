-- OLVoyage souhaite connaître son meilleur employé. Affichez le prénom et le nom de l’employéqui a enregistréle plus grand nombre de réservations.
-- Si plusieurs employés ont le même nombre de réservations, vous les afficherez tous.
SELECT
  *
FROM
  (
    SELECT
      e.last_name || ' ' || e.first_name "Meilleur employée"
    FROM
      t_employee e
      JOIN t_reservation r USING (employee_id)
    GROUP BY
      employee_id,
      e.last_name,
      e.first_name
    ORDER BY
      count (r.reservation_id) desc
  )
WHERE
  ROWNUM <= 1;