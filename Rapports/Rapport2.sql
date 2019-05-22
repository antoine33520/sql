-- Affichez le nom et le prénom des acheteurs qui ont payédes réservations ne contenant pas de billet àleur nom (donc pour quelqu’un d’autre). Triez les résultats par nom et prénom.
SELECT
  concat('c.first_name' || ' ' || 'c.last_name') AS name,
  r.reservation_id
from
  T_CUSTOMER c
  JOIN T_RESERVATION r ON r.buyer_id = c.customer_id
  JOIN T_PASS p ON p.pass_id = c.pass_id
WHERE
  name <> p.pass_name