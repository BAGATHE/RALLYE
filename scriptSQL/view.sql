CREATE VIEW ClassementPilotesParRallye AS
SELECT 
    p.nom AS Nom_Pilote,
    c.intituler AS Categorie,
    r.intituler AS Rallye,
    SEC_TO_TIME(SUM(TIME_TO_SEC(rs.chronometre))) AS Temps_Total
FROM 
    Pilote p
JOIN 
    RallyeSpecial rs ON p.idPilote = rs.idPilote
JOIN 
    Rallye r ON rs.idRallye = r.idRallye
JOIN 
    Categorie c ON p.idCategorie = c.idCategorie
GROUP BY 
    p.idPilote, r.idRallye
ORDER BY 
    r.intituler ASC, Temps_Total ASC;





CREATE VIEW ClassementAvecPoints AS
SELECT 
    classement.Nom_Pilote,
    classement.Categorie,
    classement.Rallye,
    classement.Temps_Total,
    CASE
        WHEN classement.Classement <= 10 THEN
            CASE classement.Classement
                WHEN 1 THEN 30
                WHEN 2 THEN 25
                WHEN 3 THEN 20
                WHEN 4 THEN 15
                WHEN 5 THEN 12
                WHEN 6 THEN 10
                WHEN 7 THEN 8
                WHEN 8 THEN 6
                WHEN 9 THEN 4
                WHEN 10 THEN 3
            END
        ELSE 0
    END AS Points
FROM (
    SELECT 
        Nom_Pilote,
        Categorie,
        Rallye,
        SEC_TO_TIME(SUM(TIME_TO_SEC(Temps_Total))) AS Temps_Total,
        ROW_NUMBER() OVER(PARTITION BY Rallye ORDER BY Temps_Total) AS Classement
    FROM 
        ClassementPilotesParRallye
    GROUP BY 
        Nom_Pilote, Categorie, Rallye
) AS classement;



CREATE VIEW ClassementParCategorie AS
SELECT 
    Categorie,
    SUM(Points) AS Total_Points
FROM 
    ClassementAvecPoints
GROUP BY 
    Categorie
ORDER BY 
    Total_Points DESC;
