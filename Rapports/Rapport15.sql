-- Suite aux nombreux recrutements, OLVoyage souhaite établir un nouvel organigramme.
-- Le nombre des réservations enregistrées par les employés doit suivre leur nom et leur prénom indentés.
-- Etant donnéque le dirigeant ne s’occupe pas des réservations, il ne doit pas apparaitre sur l’organigramme.
COLUMN NAME FORMAT A20
SELECT
  LPAD(
    e.last_name || ' ' || e.first_name,
    LENGTH(e.last_name || ' ' || e.first_name) +(LEVEL * 2) -2,
    '   '
  ) AS NAME,
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
