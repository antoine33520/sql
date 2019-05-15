SELECT
  emp.nbemp " Nb d’employés ",
  cus.nbcus " Nb d’acheteurs",
  cus.abo " % d’abonnés ",
  res.nbres " Nb de réservations ",
  tic.nbtic " Nb de tickets ",
  tr.nbtr " Nb de trains ",
  sta.nbsta " Nb de stations "
FROM
  (
    SELECT
      COUNT(e.employee_id) nbemp
    FROM
      t_employee e
  ) emp,
  (
    SELECT
      COUNT(c.customer_id) nbcus,
      ROUND(
        (COUNT(c.pass_id) / COUNT(c.customer_id) * 100),
        2
      ) || '%' abo
    FROM
      t_customer c
  ) cus,
  (
    SELECT
      COUNT(r.reservation_id) nbres
    FROM
      t_reservation r
  ) res,
  (
    SELECT
      COUNT(ti.ticket_id) nbtic
    FROM
      t_ticket ti
  ) tic,
  (
    SELECT
      COUNT(t.train_id) nbtr
    FROM
      t_train t
  ) tr,
  (
    SELECT
      COUNT(s.station_id) nbsta
    FROM
      t_station s
  ) sta;