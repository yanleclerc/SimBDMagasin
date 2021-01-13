set echo on;

/* Trigger pour la validation de stock valide dans l'inventaire (Table Produit) */

CREATE OR REPLACE TRIGGER Valider_Stock_Produit
BEFORE INSERT ON Livraisons 
FOR EACH ROW

DECLARE
	qqt INTEGER := 0;

BEGIN
	/* Variable qqt qui sert de comparaison pour la valeur limite de stock */
	SELECT stock
	INTO qqt
	FROM Produit
 	WHERE numReference = :NEW.numreference;
	
        /* Si le nombre d'item est superieur a qqt, on lance une erreur systeme */
	IF :NEW.nbritems > qqt THEN 
		raise_application_error(-20101, 'Nombre commande superieur au stock existant.');
	END IF;
END;
/

/* Trigger pour actualiser le stock dans la table Produit */

CREATE OR REPLACE TRIGGER Actualiser_Stock_Produit
AFTER INSERT ON Livraisons 
FOR EACH ROW

BEGIN
	UPDATE CommandeProduit SET nbrItems = (nbrItems - :New.nbrItems) WHERE numReference = :NEW.numReference AND numCommande = :NEW.numCommande;	
	UPDATE Produit SET stock = (stock - :NEW.nbritems) WHERE numReference = :NEW.numreference;
END;
/

/* Trigger pour la validation stock commande reste inferieur au stock en inventaire */

CREATE OR REPLACE TRIGGER Valider_Stock_Commande 
BEFORE INSERT ON Livraisons
FOR EACH ROW
FOLLOWS Valider_Stock_Produit

DECLARE
	qqt INTEGER := 0;

BEGIN
	/* Variable qqt qui sert de comparaison pour la valeur limite de stock */
	SELECT nbritems 
	INTO qqt
	FROM CommandeProduit
	WHERE numReference = :NEW.numreference AND numCommande = :NEW.numCommande;

        /* Si le nombre d'item est superieur a qqt, on lance une erreur systeme */
	IF :NEW.nbritems > qqt THEN 
		raise_application_error(-20102, 'Nombre commande est superieur au stock de la commande.');
	END IF;
END;
/

/* Trigger pour la validation de paiement */

CREATE OR REPLACE TRIGGER Valider_Paiement
BEFORE INSERT ON Paiement 
FOR EACH ROW

DECLARE
	montantFacture number(10,2) := 0;

BEGIN
  /* Variable montantFacture qui sert de comparaison pour la valeur limite de paiement */
	SELECT prixTotal 
  INTO montantFacture 
  FROM Facture 
  WHERE Facture.numLivraison = :NEW.numLivraison;
  
	/* Si le montant de paiement est superieur au montantFacture, on lance une erreur systeme */
	IF :NEW.montant > montantFacture THEN 
    raise_application_error(-20103, 'Montant du paiement est superieur au montant de la facture');
	END IF;
END;
/

