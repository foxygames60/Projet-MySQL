-- Phase 1 : Initialisation et Nettoyage
SET FOREIGN_KEY_CHECKS = 0;
DROP DATABASE IF EXISTS yair_line_db;
CREATE DATABASE yair_line_db;
USE yair_line_db;

-- Phase 2 : Création des tables (DDL)
CREATE TABLE Appareil (
    NumEnreg VARCHAR(20) PRIMARY KEY,
    Type_Avion VARCHAR(50),
    Capacite INT
) ENGINE=INNODB;

CREATE TABLE Ligne (
    NumLigne INT PRIMARY KEY AUTO_INCREMENT,
    VilleOrigine VARCHAR(100),
    VilleDest VARCHAR(100)
) ENGINE=INNODB;

CREATE TABLE Employe (
    IdEmp INT PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    Adresse VARCHAR(255),
    Salary DECIMAL(10,2),
    Categorie ENUM('Pilote', 'Hotesse', 'Steward', 'Sol'),
    NumLicence VARCHAR(50) NULL,
    DateValiditeLicence DATE NULL,
    Fonction VARCHAR(50) NULL,
    HeuresVol INT DEFAULT 0
) ENGINE=INNODB;

CREATE TABLE Vol (
    NumVol VARCHAR(20) PRIMARY KEY,
    DateDebut DATE,
    DateFin DATE,
    HeureDep TIME,
    HeureArr TIME,
    NumLigne INT,
    NumEnreg VARCHAR(20),
    CONSTRAINT fk_ligne FOREIGN KEY (NumLigne) REFERENCES Ligne(NumLigne),
    CONSTRAINT fk_appareil FOREIGN KEY (NumEnreg) REFERENCES Appareil(NumEnreg)
) ENGINE=INNODB;

CREATE TABLE Depart (
    NumVol VARCHAR(20),
    DateDepart DATE,
    NbPlacesLibres INT,
    NbPlacesOccupees INT,
    PRIMARY KEY (NumVol, DateDepart),
    CONSTRAINT fk_vol_depart FOREIGN KEY (NumVol) REFERENCES Vol(NumVol)
) ENGINE=INNODB;

CREATE TABLE Passager (
    NumPassager INT PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(50),
    Prenom VARCHAR(50),
    Adresse VARCHAR(255),
    Profession VARCHAR(100)
) ENGINE=INNODB;

CREATE TABLE Billet (
    NumBillet INT PRIMARY KEY AUTO_INCREMENT,
    DateEmission DATE,
    Prix DECIMAL(10,2),
    NumVol VARCHAR(20),
    DateDepart DATE,
    NumPassager INT,
    CONSTRAINT fk_depart_billet FOREIGN KEY (NumVol, DateDepart) REFERENCES Depart(NumVol, DateDepart),
    CONSTRAINT fk_passager_billet FOREIGN KEY (NumPassager) REFERENCES Passager(NumPassager)
) ENGINE=INNODB;

CREATE TABLE Affectation (
    NumVol VARCHAR(20),
    DateDepart DATE,
    IdEmp INT,
    PRIMARY KEY (NumVol, DateDepart, IdEmp),
    CONSTRAINT fk_depart_affect FOREIGN KEY (NumVol, DateDepart) REFERENCES Depart(NumVol, DateDepart),
    CONSTRAINT fk_employe_affect FOREIGN KEY (IdEmp) REFERENCES Employe(IdEmp)
) ENGINE=INNODB;

SET FOREIGN_KEY_CHECKS = 1;

-- Phase 3 : Insertion des données (DML)
-- Ici on t'ajoute toi en tant que Pilote à Casablanca
INSERT INTO Appareil VALUES ('CN-YNOV', 'Airbus A320', 180), ('CN-MAR', 'Boeing 737', 160);
INSERT INTO Ligne (VilleOrigine, VilleDest) VALUES ('Casablanca', 'Paris'), ('Casablanca', 'Madrid');
INSERT INTO Employe (Nom, Prenom, Adresse, Categorie, Salary, NumLicence, DateValiditeLicence) 
VALUES ('Dina', 'Dina', 'Casablanca, Maroc', 'Pilote', 55000.00, 'LIC-DINA-2026', '2028-12-31');
INSERT INTO Passager (Nom, Prenom, Profession) VALUES ('Arnaud', 'Lucas', 'Ingénieur');
INSERT INTO Vol VALUES ('YAIR100', '2026-05-01', '2026-05-31', '08:00:00', '11:30:00', 1, 'CN-YNOV');
INSERT INTO Depart VALUES ('YAIR100', '2026-05-08', 20, 160);
INSERT INTO Affectation VALUES ('YAIR100', '2026-05-08', 1);
INSERT INTO Billet (DateEmission, Prix, NumVol, DateDepart, NumPassager) VALUES ('2026-04-20', 1500.00, 'YAIR100', '2026-05-08', 1);