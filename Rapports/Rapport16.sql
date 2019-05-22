-- Pour remercier ses coordinateurs de ventes, la sociétésouhaite augmenter leur salaire de $100. Affichez le numéro de l’employé, son nom et son prénom, ainsi que le salaire augmenté.
-- Utilisez les sous-requêtes avancées.
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