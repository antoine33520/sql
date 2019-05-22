-- Créez le rapport sur tous les trajets effectués par les trains OLVoyage. Affichez le numéro du train, le trajet qui est constituéde la ville de départ avec l’heure de départ et la ville d’arrivée avec l’heure d’arrivée, la distance parcourue et le prix initial.
-- Exemple : Nice (24/03/19 08:00) –Brest (24/03/19 16:10)
-- Triez les résultats par numéro du train.
SELECT
  t.train_id,
  t.departure_time,
  sd.city,
  t.arrival_time,
  sa.city,
  t.distance,
  (t.arrival_time - t.departure_time) as time_travel,
  t.price
FROM
  T_TRAIN t
  JOIN T_STATION sd ON sd.station_id = t.departure_station_id
  JOIN T_STATION sa ON sa.station_id = t.arrival_station_id;