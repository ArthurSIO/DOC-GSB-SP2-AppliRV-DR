--obtenir matricule des visiteurs qui occupent ou ont occupé le poste délégué régiional --
SELECT v.vis_matricule, vis_nom, tra_role
FROM Visiteur v 
INNER JOIN Travailler t
ON v.vis_matricule=t.vis_matricule
WHERE tra_role = "Délégué";

SELECT vis_matricule, tra_role
FROM Travailler
WHERE tra_role="Délégué";

-- obtenir matricule qui occupe actuellement leposte délégué --
SELECT v.vis_matricule, vis_nom, vis_prenom, t.tra_role, t.jjmmaa
FROM Visiteur v 
INNER JOIN Travailler t
ON v.vis_matricule = t.vis_matricule
WHERE tra_role="Délégué" and jjmmaa=(
	SELECT MAX(jjmmaa)
	FROM Travailler t1
	WHERE t1.vis_matricule=v.vis_matricule
	);

-- obtenir infos au délégué régional avec matricule et mdp renseigné -- AUTHENTIFICATION
SELECT v.vis_matricule, vis_nom, vis_prenom, t.tra_role, t.jjmmaa
FROM Visiteur v 
INNER JOIN Travailler t
ON v.vis_matricule = t.vis_matricule
WHERE tra_role="Délégué" and jjmmaa=(
	SELECT MAX(jjmmaa)
	FROM Travailler t1
	WHERE t1.vis_matricule="b34"
	AND v.vis_mdp = "azerty"
	);

--retourner la LISTE des Praticiens HESITANT --
SELECT p.pra_num, pra_nom, pra_prenom, pra_ville, pra_coefnotoriete,rap_date_visite, rap_coeff_confiance
FROM Praticien p
INNER JOIN RapportVisite r
ON p.pra_num = r.pra_num
WHERE rap_coeff_confiance < 5
AND rap_date_visite = (
	SELECT MAX(rap_date_visite)
	FROM RapportVisite r2
	WHERE r.pra_num=r2.pra_num);
--
select rap_date_visite, p.pra_num, pra_nom, pra_ville, rap_coeff_confiance 
from Praticien p 
inner join RapportVisite rv 
on p.pra_num=rv.pra_num, (
							select max(rap_date_visite)as MAX_DATE 
							from RapportVisite 
							where rap_coeff_confiance <5 
							group by pra_num
							)as MAX
where rv.rap_coeff_confiance=rap_coeff_confiance 
and rv.rap_date_visite=MAX.MAX_DATE;

-- Obtenir la liste des visiteurs (matricule, nom et prenom)--
SELECT vis_matricule, vis_nom, vis_prenom
FROM Visiteur;

-- Obetenir la liste des Rapports rédigés par un visiteur dont on cnnait le mat + le mois connus --
SELECT r.vis_matricule,rap_num, rap_date_visite, rap_bilan, rap_date_saisie, rap_coeff_confiance, rap_lu, pra_num, motif_libelle
FROM RapportVisite r
INNER JOIN Motif_visite mv
ON r.motif_num=mv.motif_num
INNER JOIN Visiteur v
ON v.vis_matricule = r.vis_matricule
WHERE YEAR(rap_date_visite) = 2018 AND MONTH(rap_date_visite) = 05 AND r.vis_matricule = 'a131';

-- enregistrer un rapport lu dont on connait le num et le rédacteur --
UPDATE RapportVisite r
SET rap_lu = 0
WHERE rap_num = 4 AND vis_matricule = 'a131';

-- unpraticien selon le rapport --
SELECT p.pra_num, pra_nom, pra_ville
FROM Praticien p
INNER JOIN RapportVisite r
ON p.pra_num = r.pra_num
WHERE vis_matricule = 'p49' and rap_num=1;

--un motif selon libelle --
SELECT motif_num, motif_libelle
FROM Motif_visite
WHERE motif_libelle = "Sollicitation du Praticien ";

-- ajout attribut avis --
ALTER TABLE RapportVisite
ADD avis VARCHAR(50) DEFAULT 'A corriger';

-- MAJ --
UPDATE RapportVisite
SET avis = 'A corriger';
