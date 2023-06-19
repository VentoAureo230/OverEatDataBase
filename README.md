# Sujet d'examen conception, administration et sécurisation d'une base de donnée

## Description

Nous avons réalisé la BDD de Over Eats, un concurrent fictif à Uber eats. 

A ce titre avons rendu un MCD, un script de création avec des données permettant d’illustrer les requêtes et la gestion de sécurité demandée.

## Contraintes

En plus des contraintes basiques de vérification de la qualité des données (Null, Non Null, date d’arrivée de la commande > date de création de la commande etc…). Vous avez ces contraintes spécifiques au client

Le choix du coursier se fait après que le restaurant est accepté la commande
Une commande ne peut pas être annulée si le coursier l’a prise en charge

## Sécurité

Voici les niveaux d’accès Over Eats, voici les demandes :

Niveau support opérationnel : SAV basique de Over eats, ils ont besoin d’un accès permettant le suivi des commandes (numéro de téléphones des partis, détails, etc) mais n’ont pas accès aux informations sensibles (informations de paiements). Fort turnover des employés donc pas de garantie de sécurité.

Niveau commercial : ont accès aux informations des restaurants (notamment CA) et peuvent les aider à paramétrer leurs comptes. N’ont pas accès aux informations des particuliers et des coursiers

Niveau recrutement : ont accès aux données des coursiers mais n’ont pas accès aux restaurants.

Niveau Admin : full accès. 


## Vues 

Il vous ai demandés de créer les vues suivantes : 

CA des restaurants par ville (Pour les commerciaux et les admins)
Top 10 des livreurs faisant le plus de livraison par ville (Pour les recruteurs et admins)
Clients commandant le plus à une enseigne données (Admin uniquement)

L’exécution de ces vues doit être illustrée avec des données.

## Procédures

Vous devez créer une procédure stockée pour archiver les comptes clients inactifs depuis plus de 2ans.

Les commandes annulées doivent être archivées au bout de 3 ans.
