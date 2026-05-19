USE yair_line_db;

-- 1. Liste des avions
SELECT * FROM Appareil;
-- 2. Liste des pilotes
SELECT Nom, Prenom, NumLicence FROM Employe WHERE Categorie = 'Pilote';
-- 3. Personnel par catégorie
SELECT Categorie, COUNT(*) AS 'Total' FROM Employe GROUP BY Categorie;
-- 4. Passagers par vol
SELECT P.Nom, P.Prenom, B.NumVol FROM Passager P JOIN Billet B ON P.NumPassager = B.NumPassager;
-- 5. Vols vers Paris
SELECT V.* FROM Vol V JOIN Ligne L ON V.NumLigne = L.NumLigne WHERE L.VilleDest = 'Paris';
-- 6. Départs du 8 mai 2026
SELECT * FROM Depart WHERE DateDepart = '2026-05-08';
-- 7. Destinations desservies
SELECT DISTINCT VilleDest AS 'Villes' FROM Ligne;
-- 8. Destinations par pilote
SELECT DISTINCT E.Nom, L.VilleDest FROM Employe E JOIN Affectation A ON E.IdEmp = A.IdEmp JOIN Vol V ON A.NumVol = V.NumVol JOIN Ligne L ON V.NumLigne = L.NumLigne;
-- 9. Licences à renouveler
SELECT Nom, DateValiditeLicence FROM Employe WHERE DateValiditeLicence < CURDATE();
-- 10. Passagers effectuant plus de 2 vols
SELECT NumPassager, COUNT(*) AS 'NbVols' FROM Billet GROUP BY NumPassager HAVING NbVols > 2;
-- 11. Professions les plus fréquentes
SELECT Profession, COUNT(*) FROM Passager GROUP BY Profession ORDER BY 2 DESC;
-- 12. Heures de vol cumulées par pilote
SELECT Nom, HeuresVol FROM Employe WHERE Categorie = 'Pilote';
-- 13. Temps d'utilisation de chaque avion
SELECT V.NumEnreg, SUM(TIMEDIFF(V.HeureArr, V.HeureDep)) FROM Vol V JOIN Depart D ON V.NumVol = D.NumVol GROUP BY V.NumEnreg;
-- 14. Passagers par mois
SELECT MONTH(DateDepart) AS 'Mois', SUM(NbPlacesOccupees) FROM Depart GROUP BY Mois;
-- 15. Passagers par avion et par mois
SELECT V.NumEnreg, MONTH(D.DateDepart) AS 'Mois', SUM(D.NbPlacesOccupees) FROM Depart D JOIN Vol V ON D.NumVol = V.NumVol GROUP BY 1, 2;
-- 16. Billets vendus par mois
SELECT MONTH(DateEmission) AS 'Mois', COUNT(*) FROM Billet GROUP BY 1;
-- 17. Chiffre d'Affaires Total
SELECT SUM(Prix) AS 'CA_Total (DH)' FROM Billet;
-- 18. Moyenne de vols par pilote
SELECT AVG(Nb) AS 'Moyenne_Vols' FROM (SELECT IdEmp, COUNT(*) as Nb FROM Affectation GROUP BY IdEmp) as T;
-- 19. Destinations les plus rentables (Taux occupation)
SELECT L.VilleDest, AVG(NbPlacesOccupees/(NbPlacesLibres+NbPlacesOccupees)) * 100 as 'Taux_Moyen %' FROM Depart D JOIN Vol V ON D.NumVol = V.NumVol JOIN Ligne L ON V.NumLigne = L.NumLigne GROUP BY 1 ORDER BY 2 DESC;
-- 20. Taux d'occupation moyen par avion et vol
SELECT V.NumEnreg, V.NumVol, AVG(D.NbPlacesOccupees / (D.NbPlacesLibres + D.NbPlacesOccupees)) AS 'Occupation' FROM Depart D JOIN Vol V ON D.NumVol = V.NumVol GROUP BY 1, 2;