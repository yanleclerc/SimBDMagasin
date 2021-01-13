SET ECHO ON;

--Insertion des données de la table Produit
INSERT
INTO Produit
VALUES(2,1002,'Brosse a dents','Bros', 1.25,TO_DATE('2020-02-03'),4, 15);

INSERT
INTO Produit
VALUES(3, 1002, 'Brosse a cheveux','Bros', 2.82,TO_DATE('1920-11-23'), 15, 5);

INSERT
INTO Produit
VALUES(4, 15, 'Pillules pour bobo', 'Pill', 12.02,TO_DATE('2004-08-11'), 23, 54);

INSERT
INTO Produit
VALUES(5, 1534, 'Coupe ongle', 'Coup', 0.95, TO_DATE('1987-12-25'), 2,12);

INSERT
INTO Produit
VALUES(6, 425, 'Couche pour adulte', 'Couc', 25.34, TO_DATE('2011-01-12'), 43, 123);

--Insertion des données de la table Adresse
INSERT
INTO Adresse
VALUES('H2S-3T1', 'CAN', 12345, 'Quebec', 'Random');

INSERT
INTO Adresse
VALUES('A5B-3T1', 'USA', 23456, 'Boston', 'Bay'); 

INSERT
INTO Adresse
VALUES('B1C-3T1', 'FR', 34567, 'Paris', 'Rochelle'); 

INSERT
INTO Adresse
VALUES('L8I-3T1', 'MEX', 45678, 'Aguella', 'Payo'); 

INSERT
INTO Adresse
VALUES('G6Z-3T1', 'CHN', 56789, 'Zhouqing', 'Wang'); 

--Insertions des données de la table Individu

INSERT
INTO Individu
VALUES(2, '(514)-123-1234','Secret','H2S-3T1');

INSERT
INTO Individu
VALUES(3, '(438)-098-8765','secret1', 'A5B-3T1');

INSERT
INTO Individu
VALUES(4, '(450)-534-8745','secret2', 'B1C-3T1');

INSERT
INTO Individu
VALUES(5, '(800)-164-8934','Secret3', 'H2S-3T1');

INSERT
INTO Individu
VALUES(6, '(514)-435-1458','Secret4', 'G6Z-3T1');  

INSERT
INTO Individu
VALUES(7, '(514)-524-6454', 'Secret5', 'G6Z-3T1');

INSERT
INTO Individu
VALUES(8, '(450)-156-8797', 'Secret6', 'B1C-3T1');

INSERT
INTO Individu
VALUES(9, '(438)-003-5438', 'Secret7', 'H2S-3T1');

INSERT
INTO Individu
VALUES(10, '(514)-233-5349', 'Secret8', 'H2S-3T1');

INSERT
INTO Individu
VALUES(11, '(438)-665-4368', 'Secret9', 'A5B-3T1');

INSERT
INTO Individu
VALUES(12, '(514)-583-1523', 'Secret10', 'B1C-3T1');

--Insertions des données de la table Client

INSERT
INTO Client
VALUES(2, 'Alor', 'Jeanie', 'qualite1', 'souffrance'); 

INSERT
INTO Client
VALUES(3, 'Feore', 'Jacque', 'qualite2', 'paye');

INSERT
INTO Client
VALUES(4, 'Berger', 'Maxime', 'qualite3', 'souffrance');

INSERT
INTO Client
VALUES(5, 'Lebois', 'Joel', 'qualite4', 'paye');

INSERT
INTO Client
VALUES(6, 'Malumba', 'Angele', 'qualite5', 'souffrance');

--Insertions des données de la table Fournisseur

INSERT
INTO Fournisseur
VALUES(7, 'Transformateur', 'Present'); 

INSERT
INTO Fournisseur
VALUES(8, 'Importateur', 'lent');

INSERT
INTO Fournisseur
VALUES(9, 'Livreur', 'incompetant');

INSERT
INTO Fournisseur
VALUES(10, 'Livreur', 'pas cher');

INSERT
INTO Fournisseur
VALUES(11, 'Importateur', 'Vrac');

--Insertions des données de la table ProduitFournisseur

INSERT
INTO ProduitFournisseur
VALUES(7, 2, 1);

INSERT
INTO ProduitFournisseur
VALUES(8,3,2);

INSERT
INTO ProduitFournisseur
VALUES(9,4,3);

INSERT
INTO ProduitFournisseur
VALUES(10,5,4);

INSERT
INTO ProduitFournisseur
VALUES(11,6,1);

--Insertion des données de la table Commande


INSERT
INTO Commande
VALUES(2, TO_DATE('1912-04-01'), 'livrer', 2);

INSERT
INTO Commande
VALUES(3, TO_DATE('2001-09-30'), 'livrer', 3);

INSERT
INTO Commande
VALUES(4, TO_DATE('2020-10-12'), 'preparer', 4);

INSERT
INTO Commande
VALUES(5, TO_DATE('2020-01-01'), 'livrer', 5);

INSERT
INTO Commande
VALUES(6, TO_DATE('2019-12-25'), 'preparer', 6);

--Insertion des données de la table CommandeProduit

INSERT
INTO CommandeProduit
VALUES(2,6,4);

INSERT
INTO CommandeProduit
VALUES(3,5,1);

INSERT
INTO CommandeProduit
VALUES(4,4,9);

INSERT
INTO CommandeProduit
VALUES(5,3,12);

INSERT
INTO CommandeProduit
VALUES(6,2,122);

--Insertions des données de la table Livraisons

INSERT
INTO Livraisons
VALUES(2, 2, 6, TO_DATE('2019-05-04'), TO_DATE('2019-05-07'), 4); 

INSERT
INTO Livraisons
VALUES(3, 4,4, TO_DATE('2018-02-23'), TO_DATE('2018-03-01'), 4);

INSERT
INTO Livraisons
VALUES(4, 5,3, TO_DATE('2020-11-02'), TO_DATE('2020-11-02'), 6);

INSERT
INTO Livraisons
VALUES(5, 6,2, TO_DATE('1999-06-16'), TO_DATE('2020-02-02'), 100);

INSERT
INTO Livraisons
VALUES(6, 6,2, TO_DATE('2020-12-03'), TO_DATE('2020-12-04'), 20);

--Insertions des données de la table Exemplaire

INSERT
INTO Exemplaire
VALUES(12345, 2, 2);

INSERT
INTO Exemplaire
VALUES(43261, 5, 2);

INSERT
INTO Exemplaire
VALUES(125131, 6, 5);

INSERT
INTO Exemplaire
VALUES(132124, 3, 4);

INSERT
INTO Exemplaire
VALUES(5445, 4, 3);

--Insertions des données de la table Facture


INSERT
INTO Facture
VALUES(2, 200, 1.15, 215, 'non payee',TO_DATE('2021-01-01'),  2);

INSERT
INTO Facture
VALUES(3, 100, 1.15, 115, 'paye partiel', TO_DATE('2020-02-02'), 3);

INSERT
INTO Facture
VALUES(4, 150, 1.15, 172.5, 'non payee', TO_DATE('2020-03-03'), 4);

INSERT
INTO Facture
VALUES(5, 435, 1.15, 500.25, 'payee', TO_DATE('2020-04-04'), 5);

INSERT
INTO Facture
VALUES(6, 1000, 1.15, 1150, 'paye partiel', TO_DATE('2020-05-05'), 6);

--Insertions des données de la table Paiement

INSERT
INTO Paiement
Values(2, 2, 150, TO_DATE('2020-05-12'), 'CarteCredit'); 

INSERT
INTO Paiement
Values(3, 3, 115, TO_DATE('2019-12-25'), 'Cheque'); 

INSERT
INTO Paiement
Values(4, 4, 25, TO_DATE('2018-01-30'), 'Cheque'); 

INSERT
INTO Paiement
Values(5, 5, 325, TO_DATE('2020-09-11'), 'CarteCredit'); 

INSERT
INTO Paiement
Values(6, 6, 500, TO_DATE('2010-02-22'), 'CarteCredit');

--Insertions des données de la table Cheque

INSERT
INTO Cheque
VALUES( 2, 2, 1234123, 99999);

INSERT
INTO Cheque
VALUES( 3, 3, 435234, 88888);

INSERT
INTO Cheque
VALUES( 4, 4, 5839, 77777);

INSERT
INTO Cheque
VALUES( 5, 5, 45327, 6666);

INSERT
INTO Cheque
VALUES( 6, 6, 13453, 44444);

--Insertions des données de la table CarteCredit

INSERT
INTO CarteCredit
VALUES( 2, 2, TO_DATE('2021-04-05'), 132124, 'VISA');

INSERT
INTO CarteCredit
VALUES( 3, 3, TO_DATE('2020-12-30'), 213415, 'Master Card');

INSERT
INTO CarteCredit
VALUES( 4, 4, TO_DATE('2021-01-12'), 456456, 'American Express');

INSERT
INTO CarteCredit
VALUES( 5, 5, TO_DATE('2022-11-23'), 53435, 'VISA');

INSERT
INTO CarteCredit
VALUES( 6, 6, TO_DATE('2022-12-03'), 34234, 'Master Card');

