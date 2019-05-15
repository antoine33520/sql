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