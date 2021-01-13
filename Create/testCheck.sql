--Fichier de tests pour les checks et les triggers
SET ECHO ON
--test du check d'une quantité < 0 pour une commande
INSERT INTO CommandeProduit
VALUES(2, 3, -1);

--test du check d'une quantité < 0 pour le stock d'un produit
INSERT INTO Produit
VALUES(3, 0, 'xxx', 'xxx', 0.00, TO_DATE('2020-02-21'), 0,-1);

--test du check d'une quantité < 0 pour le seuil minimun du stock d'une produit
INSERT INTO Produit 
VALUES(2, 0, 'xxx', 'xxx' ,0.00, TO_DATE('2020-01-01'), -1, 0);

--test du check type de la carte (VISA, American Express, Master Card)
INSERT INTO CarteCredit
VALUES(2, 2, TO_DATE('2021-01-01'), 102345223423, 'Test');

--test du check type de fournisseur (Fournisseur, Transformateur, Livreur)
INSERT INTO Fournisseur 
VALUES(12, 'TEST', 'Pas bon');

--Inserts pour représenter les triggers
INSERT INTO Produit
VALUES(10, 24, 'test trigger', 'test', 10.00, TO_DATE('2020-12-09'), 5, 25);

INSERT INTO Commande
VALUES(10, TO_DATE('2020-12-09'), 'prep', 2);

INSERT INTO CommandeProduit
VALUES(10, 10, 15);

--Tables des inserts pour les test des triggers
SELECT numreference, stock FROM produit WHERE numreference = 10;
SELECT numReference, numCommande, nbrItems FROM CommandeProduit WHERE numReference = 10 AND numCommande = 10;

--test du trigger Valider_Stock_Produit. nbrItems > quantité en stock du produit 
INSERT INTO Livraisons
VALUES(10, 10, 10, TO_DATE('2020-12-09'), TO_DATE('2020-12-25'), 26);

--test du trigger Valider_Stock_Commande. nbrItems > quantité de la commande
INSERT INTO Livraisons
VALUES(10, 10, 10, TO_DATE('2020-12-09'), TO_DATE('2020-12-25'), 16);

--test du trigger Actualiser_Stock_Produit. update les stocks des tables
INSERT INTO Livraisons
VALUES(10, 10, 10, TO_DATE('2020-12-09'), TO_DATE('2020-12-25'), 10);

SELECT numreference, stock FROM produit WHERE numreference = 10;
SELECT numReference, numCommande, nbrItems FROM CommandeProduit WHERE numReference = 10 AND numCommande = 10;

--test du trigger Valider_Paiement. montant > prixTotal de la facture
INSERT INTO Paiement
VALUES(15, 3, 116, TO_DATE('2020-12-09'), 'Cheque' );
