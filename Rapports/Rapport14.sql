-- Affichez le numéro du train, le nom du train et le nombre de places libres. Ne prendre en compte que les trains qui ont parcouru une distance supérieure à300 Km le 22/05/2019 et pour lesquels des billets ont étéréservés.
-- Triez les résultats par le numéro du train.

SELECT
  e.last_name || ' ' || e.first_name " NOM_PRENOM ",
  e.employee_id,
  e.salary + 100 " SALAIRE + 100 "
FROM
  t_employee e
WHERE
  e.employee_id = ANY (
    SELECT
      DISTINCT emp.employee_id
    FROM
      t_employee emp
      JOIN t_reservation r ON r.employee_id = emp.employee_id
  );
