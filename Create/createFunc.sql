-- ============================================ 
-- Fonction:  QuantiteDejaLivree
-- Description: Retourne la quantitee livree d'un article 
-- précis dans une commande
-- IN NUMBER : Numero de référence d'un produit
-- IN NUMBER : Numero de commande dans lequel on cherche
-- RETOUR NUMBER : Le nombre d'items deja livre
-- ============================================

CREATE OR REPLACE FUNCTION QuantiteDejaLivree(numRef IN NUMBER, numCom IN NUMBER)
RETURN NUMBER 
IS
    num_livr    NUMBER(20);
    date_livr   DATE;
    nbr_items_c NUMBER(20) := 0;

BEGIN
    SELECT NUMLIVRAISON INTO num_livr FROM LIVRAISONS WHERE numCommande = numCom AND NUMREFERENCE = numRef;
    SELECT DATELIVRAISON INTO date_livr FROM LIVRAISONS WHERE NUMLIVRAISON = num_livr;
    /*Vérification que la date de livraison soit dans le passee*/
    IF date_livr < SYSDATE THEN
        SELECT NBRITEMS INTO nbr_items_c FROM LIVRAISONS WHERE numCommande = numCom AND NUMREFERENCE = numRef;
        /*Retourne le nombre d'items associe a la commande et numero reference*/
        RETURN nbr_items_c;
    END IF;
END;
/

-- ============================================ 
-- Fonction:  TotalFacture
-- Description: Retourne le total de la facture donnée
-- en parametre
-- IN NUMBER : le numero de facture que l'on cherche le total
-- RETOUR NUMBER : Le total de la facture
-- ============================================

CREATE OR REPLACE FUNCTION TotalFacture(numFac IN NUMBER)
RETURN NUMBER
IS
    montant_total_c NUMBER(10, 2) := 0;
BEGIN
    SELECT prixTotal
    INTO montant_total_c
    FROM Facture
    WHERE numFac = numLivraison;
    /*Retourne le prixTotal de la facture en parametre*/
    RETURN montant_total_c;
END;
/


