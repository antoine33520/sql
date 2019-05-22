-- OLVoyage souhaite faire une étude commerciale. Affichez le nombre de clients qui ont bénéficiéde la réduction «Sénior »pour réserver des billets pour les trains partant au mois de mars 2019. Ne prenez en compte que les réservations payées. Supposez que vous ne vous rappelez pas du nombre de jours dans le mois de mars.
-- Indice
-- Vous allez faire une jointure entre six tables, donc vous aurez au moins cinq conditions de jointure.
SELECT
  COUNT(r.reservation_id) "Janvier 2019 sénior pass :"
FROM
  t_reservation r
  JOIN t_ticket t ON t.reservation_id = t.reservation_id
  JOIN t_wagon_train w ON t.wag_tr_id = w.wag_tr_id
  JOIN t_train t ON w.train_id = t.train_id
  JOIN t_customer c ON t.customer_id = c.customer_id
  JOIN t_pass p ON c.pass_id = p.pass_id
WHERE
  p.pass_name='Senior'
  AND r.buy_method IS NOT NULL
  AND t.departure_time LIKE '__/%01/19%';