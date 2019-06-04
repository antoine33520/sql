-- La sociétéOLVoyage souhaite faire des statistiques. Affichez les totaux pour les unités suivantes : employés, clients, pourcentage des clients abonnés (bien évidemment les calculs doivent exclure les abonnements périmés), trains, gares, réservations, billets. Prendre en compte les réservations et les billets non payés.
-- Votre rapport ne contiendra qu’une seule ligne avec un total par colonne.
-- Indice
-- Dans cette requête, vous pourrez constater l’effet de deux fonctions COUNT() dans un même SELECT. Pensez àutiliser les sous-requêtes dans le FROM, ça vous aidera énormément ici et dans les rapports suivants.
SELECT
  (
    SELECT
      COUNT(employee_id)
    FROM
      t_employee
  ) "Employe",
  (
    SELECT
      COUNT(customer_id)
    FROM
      t_customer
  ) "Client",
  (
    SELECT
      ROUND(
        ((SUM(NVL2(pass_id, 1, 0))) / COUNT(customer_id)) * 100,
        2
      )
    FROM
      t_customer
  ) "% ABONNES",
  (
    SELECT
      COUNT(train_id)
    FROM
      t_train
  ) "Train",
  (
    SELECT
      COUNT(station_id)
    FROM
      t_station
  ) "Station",
  (
    SELECT
      COUNT(reservation_id)
    FROM
      t_reservation
  ) "Reservation",
  (
    SELECT
      COUNT(ticket_id)
    FROM
      t_ticket
  ) "Ticket"
FROM
  dual;
