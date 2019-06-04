-- Pour remercier ses coordinateurs de ventes, la sociétésouhaite augmenter leur salaire de $100. Affichez le numéro de l’employé, son nom et son prénom, ainsi que le salaire augmenté.
-- Utilisez les sous-requêtes avancées.
SELECT
  e.last_name || ' ' || e.first_name " NOM PRENOM ",
  e.employee_id,
  e.salary + 100 " SALAIRE + 100 "
FROM
  t_employee e
WHERE
    manager_id IN (SELECT employee_id FROM t_employee WHERE manager_id IS NULL
  );
