-- ===========================================
-- Procédure:  ProduireFacture
-- Description: Imprime sur le terminal
-- la facture client d'une livraison
-- IN : Le numero de livraison
-- IN : La date limite du paiement de la facture
-- ===========================================

CREATE OR REPLACE PROCEDURE ProduireFacture(numLivr IN NUMBER, dateLimite_f IN DATE)
    IS

-- Déclaration des variables
    num_client_c       number(20);
    nom_client_c       varchar(50);
    prenom_client_c    varchar(50);
    num_livraison_c    number(20);
    date_livraison_c   DATE;
    prix_soustotal_c   NUMBER(10, 2);
    dateLimite_c       date;
    e_rue              VARCHAR(10) ;
    e_ville            VARCHAR(10) ;
    e_numCiv           VARCHAR(10) ;
    e_pays             VARCHAR(10) ;
    e_cp               VARCHAR(10) ;
    c_num_livraison    INT ;
    c_type_produit     VARCHAR(20) ;
    c_prix_vente       VARCHAR(20) ;
    c_code_zebre       VARCHAR(20) ;
    c_num_commande     VARCHAR(20);

    -- Déclaration du curseur qui va parcourir les produits de la livraisons dans les
    -- differentes commandes
    CURSOR cur_liste_commande IS
        SELECT LIVRAISONS.NUMLIVRAISON, LIVRAISONS.NUMCOMMANDE, CODEZEBRE, PRIXVENTE, TYPEPRODUIT
        INTO c_num_livraison, c_num_commande, c_code_zebre, c_prix_vente, c_type_produit
        FROM LIVRAISONS
        /* Jointure de plusieurs tables pour regrouper les differentes informations */
                 INNER JOIN COMMANDEPRODUIT C2 on LIVRAISONS.NUMCOMMANDE = C2.NUMCOMMANDE
                 INNER JOIN PRODUIT P on P.NUMREFERENCE = C2.NUMREFERENCE
                 INNER JOIN EXEMPLAIRE E on LIVRAISONS.NUMLIVRAISON = E.NUMLIVRAISON
        WHERE LIVRAISONS.NUMLIVRAISON = numLivr;
    produits_commandes cur_liste_commande%ROWTYPE;

BEGIN

/* Selects des multiples variables de la facture */

    SELECT CODEINDIVIDU INTO num_client_c FROM Facture WHERE numLivraison = numLivr;

    SELECT codePostal, pays, numCiv, ville, rue
    INTO e_cp, e_pays, e_numCiv, e_ville, e_rue
    FROM Adresse
    WHERE codepostal =
          (SELECT codePostal
           FROM INDIVIDU
           WHERE CODEINDIVIDU = num_client_c);

    SELECT nom
    INTO nom_client_c
    FROM Client
             INNER JOIN Facture ON Client.codeIndividu = Facture.CODEINDIVIDU AND Facture.NUMLIVRAISON = numLivr;

    SELECT prenom
    INTO prenom_client_c
    FROM Client
             INNER JOIN Facture ON Client.codeIndividu = Facture.CODEINDIVIDU AND Facture.NUMLIVRAISON = numLivr;

    SELECT numLivraison INTO num_livraison_c FROM Facture WHERE numLivraison = numLivr;

    SELECT DATELIVRAISON INTO date_livraison_c FROM LIVRAISONS WHERE numLivraison = numLivr;

    SELECT prixSousTotal INTO prix_soustotal_c FROM Facture WHERE numLivraison = numLivr;

    SELECT datePayerLim INTO dateLimite_c FROM FACTURE WHERE datePayerLim = dateLimite_f;


-- Début de l'impression de la facture avec tous les éléments sélectionnés précédemment

    dbms_output.put_line('**********Facture Client**********');
    dbms_output.PUT_LINE(' ');
    dbms_output.PUT_LINE(' ');
    dbms_output.put_line('Numero du Client: ' || num_client_c);
    dbms_output.put_line('Nom du Client: ' || nom_client_c);
    dbms_output.put_line('Prenom du Client: ' || prenom_client_c);
    dbms_output.put_line('Adresse du Client : ');
    dbms_output.put_line('Numero Civique: ' || e_numCiv);
    dbms_output.put_line('Rue: ' || e_rue);
    dbms_output.put_line('Code Postal: ' || e_cp);
    dbms_output.put_line('Ville: ' || e_ville);
    dbms_output.put_line('Pays: ' || e_pays);
    dbms_output.put_line('Numero de Livraison: ' || num_livraison_c);
    dbms_output.put_line('Date de Livraison: ' || date_livraison_c);
    dbms_output.PUT_LINE(' ');

-- Utilisation du curseur pour obtenir la liste des produits

    OPEN cur_liste_commande;
    LOOP
        FETCH cur_liste_commande INTO produits_commandes;
        dbms_output.put_line('#Produit : ' || produits_commandes.TYPEPRODUIT);
        DBMS_OUTPUT.put_line('Code Zebre : ' || produits_commandes.CODEZEBRE);
        dbms_output.put_line('#Commande : ' || produits_commandes.NUMCOMMANDE);
        dbms_output.put_line('Prix : ' || produits_commandes.PRIXVENTE);
        dbms_output.PUT_LINE(' ');
        EXIT WHEN cur_liste_commande%NOTFOUND;
    END LOOP;
    CLOSE cur_liste_commande;

--Impression des dernières information de la facture

    dbms_output.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Date Limite de paiement : ' || dateLimite_c);
    dbms_output.PUT_LINE(' ');
    dbms_output.PUT_LINE(' ');
    dbms_output.put_line('Prix Sous-Total: ' || prix_soustotal_c || '$');
    dbms_output.put_line('Montant des Taxes: ' || prix_soustotal_c *0.15|| '$'); --Calcul des taxes
    dbms_output.put_line('Prix Total: ' || prix_soustotal_c * 1.15 || '$');
END;
/
