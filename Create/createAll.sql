SET ECHO ON

CREATE SEQUENCE numReference 
Start WITH 1 
INCREMENT by 1;

CREATE SEQUENCE numCommande
Start WITH 1 
INCREMENT by 1;

CREATE SEQUENCE codeZebre
Start WITH 1 
INCREMENT by 1;

CREATE SEQUENCE codeIndividu
Start WITH 1 
INCREMENT by 1;

CREATE SEQUENCE numLivraisons 
Start WITH 1 
INCREMENT by 1;

CREATE SEQUENCE numPaiement
START WITH 1
INCREMENT BY 1;

CREATE TABLE Produit(
  numReference number(20) NOT NULL,
  typeProduit number(5) NOT NULL,
  description varchar2(20) NOT NULL,
  preFix varchar2(10) NOT NULL,
  prixVente number(10,2) NOT NULL,
  dateEntree date NOT NULL,
  seuilMinStock number(4) NOT NULL,
  stock number(4) NOT NULL,
  PRIMARY KEY(numReference)
);

CREATE TABLE Adresse (
  codePostal varchar2(7) NOT NULL,
  pays varchar2(5) NOT NULL,
  numCiv number(5) NOT NULL,
  ville varchar2(15) NOT NULL, 
  rue varchar2(20) NOT NULL,
  PRIMARY KEY(codePostal)
);

CREATE TABLE Individu(
  codeIndividu number(20) NOT NULL,
  numTel varchar2(14) NOT NULL,
  motDePasse varchar2(14) NOT NULL,
  codePostal varchar2(7) NOT NULL,
  PRIMARY KEY(codeIndividu),
  FOREIGN KEY(codePostal) REFERENCES Adresse ON DELETE CASCADE
);

CREATE TABLE Commande(
  numCommande number(20) NOT NULL,
  dateCommande date NOT NULL, 
  etatCommande varchar2(10) NOT NULL,
  codeIndividu number(20) NOT NULL,
  PRIMARY KEY(numCommande),
  FOREIGN KEY(codeIndividu) REFERENCES Individu ON DELETE CASCADE
);

CREATE TABLE Livraisons(
  numLivraison number(20),
  numReference number(20) NOT NULL,
  numCommande number(20) NOT NULL,
	dateJour date NOT NULL,
  dateLivraison date NOT NULL,
  nbrItems number(10) NOT NULL,
  PRIMARY KEY(numLivraison),
	FOREIGN KEY(numCommande) REFERENCES Commande ON DELETE CASCADE,
	FOREIGN KEY(numReference) REFERENCES Produit ON DELETE CASCADE 
);

CREATE TABLE Paiement(
  numPaiement number(20) NOT NULL,
  numLivraison number(20) NOT NULL,
  montant number(10,2) NOT NULL,
  datePaiement date NOT NULL,
  methodePaiement varchar2(14) NOT NULL,
  PRIMARY KEY(numPaiement, numLivraison),
  FOREIGN KEY(numLivraison) REFERENCES Livraisons ON DELETE CASCADE
);

CREATE TABLE CarteCredit(
  numPaiement number(20),
  numLivraison number(20),
  dateExpiration date NOT NULL,
  numCarte number(16) NOT NULL,
  typeCarte varchar2(16) NOT NULL,
  PRIMARY KEY(numPaiement, numLivraison),
  FOREIGN KEY(numPaiement, numLivraison) REFERENCES Paiement ON DELETE CASCADE
);

CREATE TABLE Cheque(
  numPaiement number(20),
  numLivraison number(20),
  numCheque number(20) NOT NULL,
  idBanque number(10) NOT NULL,
  PRIMARY KEY(numPaiement, numLivraison),
  FOREIGN KEY(numPaiement, numLivraison) REFERENCES Paiement ON DELETE CASCADE
);

CREATE TABLE CommandeProduit(
  numReference number(20) NOT NULL,
  numCommande number(20) NOT NULL,
  nbrItems number(10) NOT NULL, 
  PRIMARY KEY(numReference, numCommande),
  FOREIGN KEY(numReference) REFERENCES Produit ON DELETE CASCADE,
  FOREIGN KEY(numCommande) REFERENCES Commande ON DELETE CASCADE
);  

CREATE TABLE Fournisseur(
  codeIndividu number(20) NOT NULL,
  typeFourn varchar2(50) NOT NULL,
  attribut varchar2(50) NOT NULL,
  PRIMARY KEY(codeIndividu),
  FOREIGN KEY(codeIndividu) REFERENCES Individu ON DELETE CASCADE
);

CREATE TABLE Client(
  codeIndividu number(20) NOT NULL,
  nom varchar2(50) NOT NULL,
  prenom varchar2(50) NOT NULL,
  qualite varchar2(50) NOT NULL,
  etatCompte varChar(10) NOT NULL,
  PRIMARY KEY(codeIndividu),
  FOREIGN KEY(codeIndividu) REFERENCES Individu ON DELETE CASCADE
);

CREATE TABLE ProduitFournisseur(
  codeIndividu number(20) NOT NULL,
  numReference number(20) NOT NULL,
  ordrePrio number(1) NOT NULL,
  PRIMARY KEY(codeIndividu, numReference),
  FOREIGN KEY(codeIndividu) REFERENCES Fournisseur ON DELETE CASCADE,
  FOREIGN KEY(numReference) REFERENCES Produit ON DELETE CASCADE
);

CREATE TABLE Facture(
  numLivraison number(20) NOT NULL,
  prixSousTotal number(10,2) NOT NULL,
  taxes number(10,2) NOT NULL,
  prixTotal number(10,2) NOT NULL,
  etatFacture varchar2(15) NOT NULL,
  datePayerLim date NOT NULL,
	codeIndividu number(20) NOT NULL,
  PRIMARY KEY(numLivraison),
  FOREIGN KEY(codeIndividu) REFERENCES Client ON DELETE CASCADE,
  FOREIGN KEY(numLivraison) REFERENCES Livraisons ON DELETE CASCADE
);

CREATE TABLE Exemplaire (
  codeZebre number(12) NOT NULL,
  numReference number(20) NOT NULL,
  numLivraison number(20) NOT NULL,
  PRIMARY KEY(codeZebre),
  FOREIGN KEY(numReference) REFERENCES Produit ON DELETE CASCADE,
  FOREIGN KEY(numLivraison) REFERENCES Livraisons ON DELETE CASCADE
);

ALTER TABLE Produit
ADD CONSTRAINT stock_Positif CHECK (stock >= 0);

ALTER TABLE Produit
ADD CONSTRAINT seuilMinimum_Positif CHECK (seuilMinStock >= 0);

ALTER TABLE CarteCredit
ADD CONSTRAINT typeCarte_Valide CHECK 
(typeCarte IN ('VISA', 'Master Card', 'American Express'));

ALTER TABLE CommandeProduit
ADD CONSTRAINT nbrItems_Valide CHECK (nbrItems >=0);

ALTER TABLE Fournisseur
ADD CONSTRAINT typeFourn_Valide CHECK
(typeFourn IN ('Transformateur', 'Importateur', 'Livreur'));


CREATE OR REPLACE TRIGGER Valider_Stock_Produit
BEFORE INSERT ON Livraisons 
FOR EACH ROW

DECLARE
	qqt INTEGER := 0;

BEGIN
	
	SELECT stock
	INTO qqt
	FROM Produit
 	WHERE numReference = :NEW.numreference;

	IF :NEW.nbritems > qqt THEN 
		raise_application_error(-20101, 'Nombre commande superieur au stock existant.');
	END IF;
END;
/

CREATE OR REPLACE TRIGGER Actualiser_Stock_Produit
AFTER INSERT ON Livraisons 
FOR EACH ROW

BEGIN
	UPDATE CommandeProduit SET nbrItems = (nbrItems - :New.nbrItems) WHERE numReference = :NEW.numReference AND numCommande = :NEW.numCommande;	
	UPDATE Produit SET stock = (stock - :NEW.nbritems) WHERE numReference = :NEW.numreference;
END;
/

CREATE OR REPLACE TRIGGER Valider_Stock_Commande 
BEFORE INSERT ON Livraisons
FOR EACH ROW
FOLLOWS Valider_Stock_Produit

DECLARE
	qqt INTEGER := 0;

BEGIN
	
	SELECT nbritems 
	INTO qqt
	FROM CommandeProduit
	WHERE numReference = :NEW.numreference AND numCommande = :NEW.numCommande;

	IF :NEW.nbritems > qqt THEN 
		raise_application_error(-20102, 'Nombre commande est superieur au stock de la commande.');
	END IF;
END;
/


CREATE OR REPLACE TRIGGER Valider_Paiement
BEFORE INSERT ON Paiement 
FOR EACH ROW

DECLARE
	montantFacture number(10,2) := 0;

BEGIN
  
	SELECT prixTotal 
  INTO montantFacture 
  FROM Facture 
  WHERE Facture.numLivraison = :NEW.numLivraison;
	
	IF :NEW.montant > montantFacture THEN 
    raise_application_error(-20103, 'Montant du paiement est superieur au montant de la facture');
	END IF;
END;
/

create or replace function QuantiteDejaLivree(numRef in number, numCom in number)
return number 
is
    num_livr    number(20);
    date_livr   date;
    nbr_items_c number(20) := 0;

begin
    select NUMLIVRAISON into num_livr from LIVRAISONS Where numCommande = numCom and NUMREFERENCE = numRef;
    select DATELIVRAISON into date_livr from LIVRAISONS where NUMLIVRAISON = num_livr;
    if date_livr < SYSDATE THEN
        select NBRITEMS into nbr_items_c from LIVRAISONS Where numCommande = numCom and NUMREFERENCE = numRef;
        return nbr_items_c;
    END IF;
end;
/


create or replace function TotalFacture(numFac in number)
return number
is
    montant_total_c number(10, 2) := 0;
begin

    select prixTotal
    into montant_total_c
    from Facture
    where numFac = numLivraison;
    return montant_total_c;
end;
/

create or replace procedure ProduireFacture(numLivr in number, dateLimite_f in date)
    is

    num_client_c       number(20);
    nom_client_c       varchar(50);
    prenom_client_c    varchar(50);
    num_livraison_c    number(20);
    date_livraison_c   date;
    prix_soustotal_c   number(10, 2);
    dateLimite_c       date;
    
    e_rue              varchar(10) ;
    e_ville            varchar(10) ;
    e_numCiv           varchar(10) ;
    e_pays             varchar(10) ;
    e_cp               varchar(10) ;
    c_num_livraison    int ;
    c_type_produit     varchar(20) ;
    c_prix_vente       varchar(20) ;
    c_code_zebre       varchar(20) ;
    c_num_commande     varchar(20);
    CURSOR cur_liste_commande IS
        SELECT LIVRAISONS.NUMLIVRAISON, LIVRAISONS.NUMCOMMANDE, CODEZEBRE, PRIXVENTE, TYPEPRODUIT
        INTO c_num_livraison, c_num_commande, c_code_zebre, c_prix_vente, c_type_produit
        FROM LIVRAISONS
                 INNER JOIN COMMANDEPRODUIT C2 on LIVRAISONS.NUMCOMMANDE = C2.NUMCOMMANDE
                 INNER JOIN PRODUIT P on P.NUMREFERENCE = C2.NUMREFERENCE
                 INNER JOIN EXEMPLAIRE E on LIVRAISONS.NUMLIVRAISON = E.NUMLIVRAISON
        WHERE LIVRAISONS.NUMLIVRAISON = numLivr;
    produits_commandes cur_liste_commande%ROWTYPE;

BEGIN

    SELECT codePostal, pays, numCiv, ville, rue
    INTO e_cp, e_pays, e_numCiv, e_ville, e_rue
    FROM Adresse
    WHERE codepostal =
          (SELECT codePostal
           FROM INDIVIDU
           WHERE CODEINDIVIDU =
                 (SELECT CODEINDIVIDU
                  FROM FACTURE
                  WHERE NUMLIVRAISON = numLivr));

    SELECT CODEINDIVIDU INTO num_client_c FROM Facture WHERE numLivraison = numLivr;

    SELECT nom
    INTO nom_client_c
    FROM Client
             INNER JOIN Facture ON Client.codeIndividu = Facture.CODEINDIVIDU and Facture.NUMLIVRAISON = numLivr;

    SELECT prenom
    INTO prenom_client_c
    FROM Client
             INNER JOIN Facture ON Client.codeIndividu = Facture.CODEINDIVIDU and Facture.NUMLIVRAISON = numLivr;

    SELECT numLivraison INTO num_livraison_c FROM Facture WHERE numLivraison = numLivr;

    SELECT DATELIVRAISON INTO date_livraison_c FROM LIVRAISONS WHERE numLivraison = numLivr;
    
    SELECT prixSousTotal INTO prix_soustotal_c FROM Facture WHERE numLivraison = numLivr;



    SELECT datePayerLim INTO dateLimite_c FROM FACTURE WHERE datePayerLim = dateLimite_f;

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

    dbms_output.PUT_LINE(' ');
    DBMS_OUTPUT.PUT_LINE('Date Limite de paiement : ' || dateLimite_c);
    dbms_output.PUT_LINE(' ');
    dbms_output.PUT_LINE(' ');
    dbms_output.put_line('Prix Sous-Total: ' || prix_soustotal_c || '$');
    dbms_output.put_line('Montant des Taxes: ' || prix_soustotal_c *0.15|| '$');
    dbms_output.put_line('Prix Total: ' || prix_soustotal_c * 1.15 || '$');
END;
/
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
