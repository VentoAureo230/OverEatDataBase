# Privilèges pour `Admin`@`%`

GRANT USAGE ON *.* TO `Admin`@`%`;

GRANT ALL PRIVILEGES ON `over\_eats`.* TO `Admin`@`%`;


# Privilèges pour `commercial`@`%`

GRANT USAGE ON *.* TO `commercial`@`%`;

GRANT SELECT, INSERT, UPDATE, CREATE, ALTER, SHOW VIEW ON `over_eats`.`adresse_restaurant` TO `commercial`@`%`;

GRANT SELECT, INSERT, UPDATE, ALTER, SHOW VIEW ON `over_eats`.`restaurant` TO `commercial`@`%`;

GRANT SELECT, SHOW VIEW ON `over_eats`.`vue_ca_restaurants_ville` TO `commercial`@`%`;


# Privilèges pour `recrutement`@`%`

GRANT USAGE ON *.* TO `recrutement`@`%`;

GRANT SELECT, SHOW VIEW ON `over_eats`.`coursier_a_zone_geographique` TO `recrutement`@`%`;

GRANT SELECT, SHOW VIEW ON `over_eats`.`coursier` TO `recrutement`@`%`;

GRANT SELECT, SHOW VIEW ON `over_eats`.`top_livreurs_par_ville` TO `recrutement`@`%`;

GRANT SELECT, SHOW VIEW ON `over_eats`.`type_vehicule` TO `recrutement`@`%`;

GRANT SELECT, SHOW VIEW ON `over_eats`.`url_coursier` TO `recrutement`@`%`;


# Privilèges pour `sav`@`%`

GRANT USAGE ON *.* TO `sav`@`%`;

GRANT SELECT (`email`, `nom`, `prenom`, `telephone`), SHOW VIEW ON `over_eats`.`client` TO `sav`@`%`;

GRANT SELECT, INSERT (`menu_id_menu`), SHOW VIEW ON `over_eats`.`commande_a_menu` TO `sav`@`%`;

GRANT SELECT, SHOW VIEW ON `over_eats`.`commande` TO `sav`@`%`;

GRANT SELECT (`nom`, `telephone`), SHOW VIEW ON `over_eats`.`restaurant` TO `sav`@`%`;