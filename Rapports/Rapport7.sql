-- Affichez le Top-5 des trains (les 5 premiers trains) par rapport aux nombres de billets réservés. Le train doit être affichéde manière suivante Paris –Brest.
SELECT
  *
FROM
  (
    SELECT
      d.city || ' - ' || a.city " Top-5 des trains "
    FROM
      t_train t
      JOIN T_station d ON t.departure_station_id = d.station_id
      JOIN T_station a ON t.arrival_station_id = a.station_id
      JOIN T_wagon_train wt ON t.Train_id = wt.train_id
      JOIN T_ticket ti ON wt.wag_tr_id = ti.wag_tr_id
    GROUP BY
      d.city || ' - ' || a.city,
      train_id
    ORDER BY
      COUNT(ti.TICKET_ID) DESC
  )
WHERE
  ROWNUM <= 5;