## Cmath pour LuaLaTeX c'est :
* La syntaxe [Cmath](http://cdeval.free.fr/spip.php?article83) pour LaTeX,
* Un code source très lisible,
* Du calcul formel grâce aux appels faciles à [Giac](http://www-fourier.ujf-grenoble.fr/~parisse/giac_fr.html), le moteur de calcul formel de Xcas,
* Des tableaux de valeurs, de signes et de variations automatiques grâce à [Giac](http://www-fourier.ujf-grenoble.fr/~parisse/giac_fr.html),
* La résolution de systèmes linéaires, les calculs de rangs et d'inverses d'une matrice,
* Des tracés de courbes via Tikz et les capacités de calculs de Lua.
* Une installation facile : deux lignes de code suffisent (ou une seule avec le package),
* Fonctionne avec n'importe quel éditeur LaTeX,
* Utilisation optimisée avec l'éditeur [TeXworks](https://www.tug.org/texworks/),
* Fonctionne sous Linux, Window$ et probablement MacO$ (si quelqu'un veut faire le test !),
* Libre et gratuit, sous licence GNU GPL v3. Le code source est accessible [ici](https://github.com/cdevalland/cmathluatex/blob/master/CmathLuaTeX.lua). L'onglet [Issues](https://github.com/cdevalland/cmathluatex/issues) de cette page permet de remonter des bogues, de proposer des améliorations, etc... 

### Pour utiliser CmathLuaTeX

* Télécharger l'archive contenant les fichiers grâce au bouton "Clone or Download"
* Décompresser l'archive
* Lire la [documentation](https://github.com/cdevalland/cmathluatex/blob/master/Documentation/Documentation%20CmathLuaTeX.pdf) et suivre les instructions d'installation.

### Pour participer au développement
Toute aide est la bienvenue, même s'il ne s'agit que d'améliorer la documentation, signaler des problèmes, etc...
Pour proposer des modifications sur les fichiers : installer git, cloner localement le projet puis "pusher" les modifications.

### Liste de diffusion

Pour rester informé des nouveautés et des mises à jour, inscrivez-vous à la liste cmathluatex :

l'URL pour s'inscrire est : [cmathluatex-request@ml.free.fr?subject=subscribe](mailto:cmathluatex-request@ml.free.fr?subject=subscribe)

L'URL pour se désinscrire est : [cmathluatex-request@ml.free.fr?subject=unsubscribe](mailto:cmathluatex-request@ml.free.fr?subject=unsubscribe)

### Historique des versions

2 juillet 2018 :

	Mise à jour suite aux nouvelles versions de Giac.

6 octobre 2016 :

	Ajout de résolution de systèmes linéaires, de calculs de rang et d'inverse de matrices, de tracé de courbes.

3 janvier 2015 :

    Résolution d'un bug sur les tableaux de variations (fichier à mettre à jour : CmathLuaTeX.lua).
    Création d'un package CmathLuaTeX.sty pour une installation encore plus simple.

20 Août 2014 :

    Amélioration des tableaux de variations (fichier à mettre à jour : CmathLuaTeX.lua).

17 Août 2014 :

    Ajout du script TeXworks Cmath2Latex.
    Meilleure gestion du symbole de la dérivation (fichier à mettre à jour : CmathLuaTeX.lua).

Juin 2014 :

    Première version.

###Qui suis-je ?

Christophe Devalland, Professeur de mathématiques en [CPGE ATS au lycée Blaise Pascal de Rouen](http://pascal-lyc.spip.ac-rouen.fr/spip.php?rubrique15).
