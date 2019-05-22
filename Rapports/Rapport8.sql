SELECT
  last_name,
  first_name,
  address
FROM
  t_customer
WHERE
  pass_id IS NULL;