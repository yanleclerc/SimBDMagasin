SET ECHO ON

DROP SEQUENCE CODEINDIVIDU;
DROP SEQUENCE CODEZEBRE;
DROP SEQUENCE NUMCOMMANDE;
DROP SEQUENCE NUMLIVRAISONS;
DROP SEQUENCE NUMREFERENCE;
DROP SEQUENCE NUMPAIEMENT;

DROP TRIGGER Actualiser_Stock_Produit;
DROP TRIGGER Valider_Stock_Produit;
DROP TRIGGER Valider_Paiement;
DROP TRIGGER Valider_Stock_Commande; 

DROP TABLE ProduitFournisseur;
DROP TABLE CommandeProduit;
DROP TABLE CarteCredit;
DROP TABLE Cheque;
DROP TABLE Paiement;
DROP TABLE Exemplaire;
DROP TABLE Facture;
DROP TABLE Livraisons;
DROP TABLE Client;
DROP TABLE Fournisseur;
DROP TABLE Commande;
DROP TABLE Individu;
DROP TABLE Adresse;
DROP TABLE Produit;

DROP PROCEDURE ProduireFacture;

DROP FUNCTION QuantiteDejaLivree;
DROP FUNCTION TotalFacture;

