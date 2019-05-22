-- Pour sa campagne publicitaire OLVoyage souhaite connaître le prénom, le nom et l’adresse des clients qui n’ont jamais eu d’abonnement. Triez les résultats par nom et prénom.
SELECT
  last_name,
  first_name,
  address
FROM
  t_customer
WHERE
  pass_id IS NULL;