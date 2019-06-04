-- OLVoyage a besoin des statistiques sur les trains partant de Paris. Affichez les numéros des trains et les noms des trains avec le titre de chaque abonnement. Calculez également les tarifs comprenant chaque type de réduction pendant la semaine et le week-end. Ne pas prendre en compte les augmentations dues àla classe. Triez les résultats par numéro du train.
-- Indice
-- Votre première jointure avec un produit cartésien attendu…et probablement la dernière.
SELECT
  train_id || '' || d.city || '-' || a.city "Nom du train ",
  pass_name "TITRE ",(t_train.price * discount_pct) / 100 "Prix reduit ",
  (t_train.price * discount_we_pct) / 100 "Prix reduit weekend -
END "
FROM
  T_TRAIN
  CROSS JOIN T_PASS
  JOIN T_STATION d ON d.station_id = departure_station_id
  JOIN T_STATION a ON a.station_id = arrival_station_id
  AND d.city = 'Paris'
ORDER BY
  train_id;
