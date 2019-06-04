-- OLVoyage souhaite faire une étude commerciale. Affichez le nombre de clients qui ont bénéficiéde la réduction «Sénior »pour réserver des billets pour les trains partant au mois de mars 2019. Ne prenez en compte que les réservations payées. Supposez que vous ne vous rappelez pas du nombre de jours dans le mois de mars.
-- Indice
-- Vous allez faire une jointure entre six tables, donc vous aurez au moins cinq conditions de jointure.
SELECT
  COUNT(c.customer_id)
FROM
  t_customer c
  JOIN t_reservation r ON c.customer_id = r.buyer_id
  JOIN t_ticket tk ON r.reservation_id = tk.reservation_id
  JOIN t_wagon_train wt ON tk.wag_tr_id = wt.wag_tr_id
  JOIN t_train t ON wt.train_id = t.train_id
  JOIN t_pass p ON c.pass_id = p.pass_id
WHERE
  p.pass_name = 'Senior'
  AND t.departure_time LIKE '__/01/19'
  AND r.buy_method IS NOT NULL;
