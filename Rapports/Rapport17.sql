-- Les coordinateurs de ventes souhaitent disposer d’un outil simple et rapide pour enregistrer les paiements des réservations.
-- Créez un script interrogeant l’utilisateur, àchaque exécution, sur le numéro de la réservation et son type de paiement.
-- Le prix de la réservation doit être calculéet enregistré.
-- Un rapport sur la réservation doit également être créé. Le nom du fichier de rapport correspondra àl’exemple suivant : resa_NRéservation.htm (ex : resa_13.htm).
-- Enregistrez les paiements pour les réservations suivantes.
-- Numéro de la réservation	Type de paiement
-- 13	Credit Card
-- 18	Cash
-- 23	Cheque
-- 31	Cash
-- Les types de paiement acceptés dans la colonne (sensibles àla casse) sont :
-- Cash
-- Cheque
-- Credit Card
UPDATE
  t_reservation
SET
  buy_method = INITCAP('&Type_de_paiement'),
  price = (
    SELECT
      SUM(
        (tt.price) + ((tt.price * NVL(w.class_pct, 0)) / 100) - (
          (
            (tt.price +((tt.price * NVL(w.class_pct, 0)) / 100)) * NVL(
              CASE
                WHEN TO_CHAR(tt.departure_time, 'D') BETWEEN 1
                AND 5 THEN discount_pct
                WHEN TO_CHAR(tt.departure_time, 'D') BETWEEN 6
                AND 7 THEN discount_we_pct
              END,
              0
            )
          ) / 100
        )
      )
    FROM
      t_reservation r
      JOIN t_ticket t ON r.reservation_id = t.reservation_id
      JOIN t_customer c ON t.customer_id = c.customer_id FULL
      OUTER JOIN t_pass p ON c.pass_id = p.pass_id
      JOIN t_wagon_train wt ON t.wag_tr_id = wt.wag_tr_id
      JOIN t_train tt ON wt.train_id = tt.train_id
      JOIN t_wagon w ON wt.wagon_id = w.wagon_id
    WHERE
      r.reservation_id = & & num_de_reservation
    GROUP BY
      r.reservation_id
  )
WHERE
  reservation_id = & Numero_de_reservation;
