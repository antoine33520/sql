-- Calculez la vitesse moyenne des trains. Utilisez l’affichage suivant : 90 km/h. Pour chacun des trains, vous afficherez son numéro et son nom au format Paris –Bordeaux.
SELECT
  a.city || ' - ' || b.city " TRAIN ",
  ROUND(
    (distance /((arrival_time - departure_time) * 24)),
    0
  ) || ' km/h' " VITESSE "
FROM
  T_TRAIN t
  JOIN T_STATION a ON a.station_id = t.departure_station_id
  JOIN T_STATION b ON b.station_id = t.arrival_station_id;