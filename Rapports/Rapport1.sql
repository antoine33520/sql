-- OLVoyage souhaite connaître son meilleur employé. Affichez le prénom et le nom de l’employéqui a enregistréle plus grand nombre de réservations.
-- Si plusieurs employés ont le même nombre de réservations, vous les afficherez tous.
SELECT
  *
FROM
  (
    SELECT
      UPPER(last_name) || ' ' || first_name "Nom",
      count(reservation_id) "Nombre de reservations"
    FROM
      T_RESERVATION r
      JOIN T_EMPLOYEE e ON r.employee_id = e.employee_id
    GROUP BY
      last_name,
      first_name
    ORDER BY
      count(reservation_id) DESC
  )
WHERE
  ROWNUM <= 1;
