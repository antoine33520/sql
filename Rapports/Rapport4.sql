-- En prévision de la rentrée, OLVoyage prévoie une campagne publicitaire pour vendre ses abonnements. Àla date du 15 mai 2019, affichez les noms et les prénoms des clients avec leur titre d’abonnement. Si le client a un abonnement périmé, affichez le titre d’abonnement avec Périmé!, si le client n’a aucun abonnement affichez Aucun.
-- Les titres d’abonnements sont valables un an àcompter de la date de souscription.
-- Triez les résultats par nom et prénom.
SELECT
  last_name || ' ' || first_name " NOM_PRENOM ",
  CASE
    WHEN MONTHS_BETWEEN('15/05/2019', pass_date) > 12 THEN 'PERIME !'
    WHEN MONTHS_BETWEEN('15/05/2019', pass_date) IS NULL THEN 'AUCUN'
    WHEN MONTHS_BETWEEN('15/05/2019', pass_date) < 12 THEN 'VALIDE'
  END "ABONNEMENT"
FROM
  T_CUSTOMER;
