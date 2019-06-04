-- Affichez le numéro du billet, le prénom et le nom du client ainsi que le train (même format que pour le rapport 5) pour les billets de première classe ayant étéréservés par les clients de moins de 25 ans.
-- Ne récupérez que les informations sur les réservations payées qui ont étéfaites 20 jours avant la date de départ du train.
-- Ne prenez en compte que les trains qui partent entre le 15/04/2019 et le 25/04/2019.
-- Triez les résultats par la date de la réservation.

SELECT
  t.ticket_id,
  c.last_name,
  c.first_name,
  wt.train_id
FROM
  t_ticket t
  JOIN t_reservation r ON t.reservation_id = r.reservation_id
  JOIN t_customer c ON r.buyer_id = c.customer_id
  JOIN t_wagon_train wt ON t.wag_tr_id = wt.wag_tr_id
  JOIN t_wagon w ON wt.wagon_id = w.wagon_id
  JOIN t_train tr ON wt.train_id = tr.train_id
WHERE
  w.class_type = 1
  AND c.birth_date > sysdate -9131
  AND r.creation_date > tr.departure_time -20
  AND tr.departure_time BETWEEN '15/04/2019'
  AND '25/01/2019';
