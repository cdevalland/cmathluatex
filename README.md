Cmath pour LuaLaTeX c'est :
  * La syntaxe [Cmath](http://cdeval.free.fr/spip.php?article83) pour LaTeX,
  * Code source plus lisible que le code LaTeX,
  * Fonctionne avec n'importe quel éditeur LaTeX ; utilisation optimisée avec [TeXworks](https://www.tug.org/texworks/),
  * Calcul formel grâce aux appels faciles à [Giac](http://www-fourier.ujf-grenoble.fr/~parisse/giac_fr.html), le moteur de calcul formel de Xcas,
  * Tableaux de valeurs, de signes et de variations automatiques grâce à [Giac](http://www-fourier.ujf-grenoble.fr/~parisse/giac_fr.html),
  * Installation facile : deux lignes de code suffisent (ou une seule avec le package),
  * Fonctionne sous Linux, Window$ et probablement MacO$ (appel aux contributeurs !),
  * Libre et gratuit, sous licence GNU GPL v3. Le code source est accessible [ici](https://github.com/cdevalland/cmathluatex/blob/master/CmathLuaTeX.lua). L'onglet [Issues](https://github.com/cdevalland/cmathluatex/issues) de cette page permet de remonter des bogues, de proposer des améliorations, etc...

## Pourquoi LuaLaTeX ? ##
Parce que LuaLaTeX allie la qualité de LaTeX à la puissance d'un langage de programmation.
Et parce que LuaLaTeX est [l'avenir de LaTeX](http://www.cuk.ch/articles/5663). Je conseille de lire cette [bonne documentation](http://www.ctan.org/tex-archive/info/luatex/lualatex-doc).

## Aperçu de CmathLuaTeX ##

L'objectif de Cmath (qui existe déjà sous Word et OpenOffice/LibreOffice) est de taper ses formules aussi simplement que sur une calculatrice. La version pour LuaLaTeX est dans le même esprit. Ainsi, en tapant :
```
$\Cmath{x_1=(1-√5)/2}$
```
on obtiendra après compilation :

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRR25kZndIbnd0Zmc&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRR25kZndIbnd0Zmc&a=b.jpeg)

Avantage si on utilise TeXworks : le code source sera rendu très lisible en exploitant les caractères disponibles grâce à l'encodage UTF-8.

En tapant :
```
int(1,+:in,1/t^:al,t)=1/(:al-1)
```

puis en appuyant sur la touche F9, TeXworks affiche :
```
$\Cmath{∫(1,+∞,1/t^α,t)=1/(α-1)}$
```

et après compilation :

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRWldOMUxlUGt5c3c&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRWldOMUxlUGt5c3c&a=b.jpeg)

En tapant `n:ap:N` suivi de F9, on obtient
```
$\Cmath{n∈ℕ}$
```
ce qui est plus agréable à lire que `$n\in\mathbb{N}$`.

Avec un autre éditeur, il sera pratique de se créer un raccourci clavier qui entourera ses formules de `$\Cmath{}$`. On ne bénéficiera pas de l'affichage amélioré comme dans TeXworks mais la compilation donnera le même résultat.

Je ne détaille pas sur cette page la syntaxe Cmath. Voir le [memento](https://drive.google.com/file/d/0B6jPgqbuNpgRcHlVQnRQLXBCSm8/edit?usp=sharing) pour l'ensemble des fonctionnalités.

## Intégration de Xcas ##

`CmathLuaTeX` fournit une fonction `xcas(expression)` qui renvoie le résultat au format LaTeX de l'expression passée en paramètre après traitement par Xcas. Plus précisément, `CmathLuaTeX` n'utilise que le moteur de calcul `Giac` de `Xcas` en appelant le programme `icas`. Mais comme tout le monde connaît `Xcas`, j'ai choisi ce nom pour la fonction intégrée à `CmathLuaTeX`.

```
$\Cmath{sin(π/4)=xcas(sin(pi/4))}$
```

donne :

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRYTBNRnlPNHB3NDQ&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRYTBNRnlPNHB3NDQ&a=b.jpeg)

```
$\Cmath{f(x)=(3x-2)/(2x+1)(x-3)=xcas(partfrac((3x-2)/(2x+1)(x-3)))}$
```

donne :

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRWGxaekFBVkJWRkE&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRWGxaekFBVkJWRkE&a=b.jpeg)

Dans le cas ou l'expression à évaluer par Xcas est une affectation ou un "assume", rien n'est renvoyé vers LuaLaTeX mais l'instruction est exécutée et la variable est disponible pour les instructions futures, comme dans une session Xcas.

```
$\Cmath{xcas(restart)}$% efface les variables
Soit le réel $\Cmath{x=π/4}$. $\Cmath{xcas(x:=pi/4)}$

Une valeur approchée de $\Cmath{x}$ est $\Cmath{xcas(evalf(x,20))}$

Une primitive de $\Cmath{t⟼1/t}$ est $\Cmath{t⟼xcas(int(1/t,t))}$. $\Cmath{xcas(assume(t>0))}$

Sur $\Cmath{]0,+∞[}$, cette primitive devient $\Cmath{t⟼xcas(int(1/t,t))}$.

$\Cmath{xcas(A:=[[cos(theta),-sin(theta),0],[sin(theta),cos(theta),0],[0,0,1]])}$

Soit la matrice \[\Cmath{A=xcas(A)}\]

La matrice $\Cmath{A^3=xcas(A)^3}$ vaut $\Cmath{xcas(tlin(A^3))}$.
```

donne :

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRb3RLQkRsX2phS3c&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRb3RLQkRsX2phS3c&a=b.jpeg)

Il est possible de définir des programmes Xcas au sein du code source et de les utiliser ensuite :

```
$\Cmath{xcas(
tabVal(f,xmin,xmax,xpas,nb_decimales):={
  local tab;
  if(nb_decimales==0){
    tab:=seq([simplifier(x),f(x)],x,xmin,xmax,xpas);
  } else {
    tab:=seq([simplifier(x),format(f(x),"f"+string(nb_decimales))],x,xmin,xmax,xpas);
  }
  tab:=prepend(tab,[x,f(x)]);
  return(tran(tab));
}
)}$

-- Tableau de valeurs arrondies à 2 décimales de $\Cmath{x⟼x/(2x-3)}$ sur $\Cmath{[0,5]}$ avec un pas de $\Cmath{1}$ :

$\Cmath{xcas(tabVal(x->x/(2x-3),0,5,1,2))}$

-- Tableau de valeurs exactes de $\Cmath{x⟼cos(x)}$ sur $\Cmath{[0,π]}$ avec un pas de $\Cmath{π/6}$ :

$\Cmath{xcas(tabVal(x->cos(x),0,pi,pi/6,0))}$
```

donne :

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRaExHVjRXMzM5Wkk&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRaExHVjRXMzM5Wkk&a=b.jpeg)

## Tableaux automatisés ##
### Tableaux de valeurs ###
La fonction `TVal(liste_x,fonction,nombre_decimales)` permet de construire un tableau de valeurs. Lorsque le nombre de décimales est omis, les images sont calculées en valeurs exactes :
```
$\Cmath{TVal([-2,-1,0,1,2],x^2)}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRNUluYjFkMVUwd1E&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRNUluYjFkMVUwd1E&a=b.jpeg)

Toute expression comprise par Xcas peut définir la `liste_x`. En particulier, lorsque le pas est constant, l'instruction `seq()` peut être utile :
```
$\Cmath{TVal([seq(-pi+k*pi/3,k=0..6)],sin(x))}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRSEcyclpXQzBCSlU&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRSEcyclpXQzBCSlU&a=b.jpeg)

Il est possible de désigner la fonction sous la forme f(x)=... Dans ce cas, c'est le nom de la fonction qui apparaît dans le tableau et le nom de la variable est détecté automatiquement :
```
$\Cmath{TVal([seq(t,t=-3..3)],g(t)=t/e^t,2)}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRbm1kVFFydW9sZ3M&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRbm1kVFFydW9sZ3M&a=b.jpeg)

Pour afficher un tableau sans images :
```
$\Cmath{TVal([-3,-1,3/2,7/3],f(x)="")}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRYnVPOTdlUUxHM0E&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRYnVPOTdlUUxHM0E&a=b.jpeg)

Si le tableau ne convient pas tout à fait, il est possible, avec TeXworks, d'afficher le code qui est transmis à LuaLaTeX. Pour cela, taper :
```
TVal([-3,-1,3/2,7/3],phi(t)=(t+4)/t)
```
puis, au lieu d'appuyer sur `F9` (pour encadrer la formule de `$\Cmath{}$`), appuyer sur `Ctrl+F9`. TeXworks affiche alors :
```
${\renewcommand{\arraystretch}{1.5}
\newcolumntype{C}[1]{S{>{\centering \arraybackslash}m{#1}}}
\setlength{\cellspacetoplimit}{4pt}
\setlength{\cellspacebottomlimit}{4pt}
\begin{tabular}{|C{1.5cm}|*{4}{C{1cm}|}}
\hline $t$ & $\displaystyle -3$ &$\displaystyle -1$ &$\displaystyle \frac{3}{2}$ &$\displaystyle \frac{7}{3}$ \\
\hline $\phi(t)$ & $\displaystyle \frac{-1}{3}$ &$\displaystyle -3$ &$\displaystyle \frac{11}{3}$ &$\displaystyle \frac{19}{7}$ \\
\hline
\end{tabular}}$ % Traduction CmathLuaTeX de : TVal([-3,-1,3/2,7/3],phi(t)=(t+4)/t,0)
```
qui donnera bien sûr après compilation :

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRWENpTm4ydVFsZE0&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRWENpTm4ydVFsZE0&a=b.jpeg)

L'appel à la fonction `Ctrl+F9` n'est pas limité aux tableaux de valeurs. Elle fonctionne pour toute expression `CmathLuaTeX` et peut servir à rendre le code source portable, à modifier finement les expressions obtenues, etc... tout en gardant dans le commentaire de la dernière ligne l'origine de la commande `CmathLuaTeX` l'ayant engendrée.

### Tableaux de signes ###
La fonction `TSig(liste_x,fonction)` construit le tableau de signes de la fonction en s'appuyant sur l'excellent package [tkz-tab](http://www.altermundus.fr/pages/tab.html). Tout est automatisé :
  * la reconnaissance de la variable utilisée.
  * la définition de l'intervalle d'étude `[x_min,x_max]` en fonction de la `liste_x` fournie.
  * la détection des facteurs contenus dans la `fonction` à étudier (pour les produits et quotients).
  * la recherche des valeurs interdites.
  * et la détermination du signe bien sûr !

```
$\Cmath{TSig([-infinity,+infinity],P(t)=(t-3)(t+2))}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRU2hvTUFLaUNEeDQ&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRU2hvTUFLaUNEeDQ&a=b.jpeg)

Avec un quotient :
```
$\Cmath{TSig([-5,5],(x-3)/(x^2-2))}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRSnhMQmxGWEV5RHM&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRSnhMQmxGWEV5RHM&a=b.jpeg)

Avec des fonctions trigonométriques :
```
$\Cmath{TSig([0,pi],sin(2x)/cos(3x))}$
```
![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRbmFkNFllN3FDQWM&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRbmFkNFllN3FDQWM&a=b.jpeg)

Il faudra parfois indiquer explicitement certaines valeurs interdites qui ne seraient pas détectées autrement :
```
$\Cmath{TSig([0,pi/2,3*pi/2,2*pi],tan(x))}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRMWlHc1cxSnVTRDQ&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRMWlHc1cxSnVTRDQ&a=b.jpeg)

### Tableaux de variations ###
La fonction `TVar(liste_x,fonction,nb_decimales)` construit le tableau de variations d'une fonction en s'appuyant sur [tkz-tab](http://www.altermundus.fr/pages/tab.html). Si `nb_decimales` est précisé, les images sont calculées en valeurs approchées avec `nb_decimales` décimales. La fonction `TVar` :
  * Reconnaît la variable utilisée,
  * Définit l'intervalle d'étude `[x_min,x_max]` en fonction de la `liste_x` fournie,
  * Calcule la dérivée de la fonction et calcule son signe,
  * Trouve les valeurs interdites,
  * Trouve les zones interdites,
  * Calcule les extrema,
  * Calcule les limites si besoin,
  * Reconnaît les prolongements par continuité,
  * et détermine les variations de la fonction bien sûr !

```
$\Cmath{TVar([-infinity,+infinity],f(t)=t^2/(t^2-1))}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRRS1DMGg3dnprc3c&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRRS1DMGg3dnprc3c&a=b.jpeg)

Pour calculer des images supplémentaires, il suffit d'ajouter les valeurs souhaitées dans la `liste_x` :
```
$\Cmath{TVar([0,1,e,+infinity],f(x)=ln(x))}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRZTkwMmNEWW85Nk0&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRZTkwMmNEWW85Nk0&a=b.jpeg)

Avec une zone interdite :
```
$\Cmath{TVar([-infinity,+infinity],f(x)=sqrt(x^2-1))}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRSVJMVnhmSV90NUU&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRSVJMVnhmSV90NUU&a=b.jpeg)

Une fonction trigonométrique :
```
$\Cmath{TVar([0,pi],x(alpha)=1-sin(2*alpha))}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRN0l1WTI5ZzBveW8&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRN0l1WTI5ZzBveW8&a=b.jpeg)

### Les courbes paramétrées ###
La fonction `TVarP(liste_x,fonction_x, fonction_y,nb_decimales)` construit le tableau de variations conjoint des deux fonctions. Si `nb_decimales` est précisé, les images sont calculées en valeurs approchées avec `nb_decimales` décimales. Contrairement aux tableaux de variations d'une fonction, les valeurs des fonctions dérivées aux points remarquables sont calculés.

```
$\Cmath{TVarP([-infinity,+infinity],x(t)=t^2/(t+1)(t-2),y(t)=t^2*(t+2)/(t+1))}$
```

![http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRVnNZRlZZLVVjdDQ&a=b.jpeg](http://drive.google.com/uc?export=view&id=0B6jPgqbuNpgRVnNZRlZZLVVjdDQ&a=b.jpeg)

et comme pour toutes les instructions `CmathLuaTeX`, si l'éditeur utilisé est TeXworks et que l'on veut avoir accès au code généré (pour le modifier ou autre), il suffit après avoir tapé `TVarP([-infinity,+infinity],x(t)=t^2/(t+1)(t-2),y(t)=t^2*(t+2)/(t+1))` d'appuyer sur `Ctrl+F9` pour que TeXworks affiche le code source du tableau :
```
$\begin{tikzpicture}
\tkzTabInit[lgt=2,espcl=2,deltacl=0.5]
{$t$ / 1,$x'(t)$ / 1,$x$ / 2,$y$ / 2,$y'(t)$ / 1}
{$-\infty $,$-4$,$-1$,$0$,$2$,$+\infty $}
\tkzTabLine { ,-,z,+,d,+,z,-,d,-, }
\tkzTabVar {+ / $1$,- / $\frac{8}{9}$,+D- / $+\infty $ / $-\infty $,+ / $0$,-D+ / $-\infty $ / $+\infty $,- / $1$}
\tkzTabVar {+ / $+\infty $,R,-D+ / $-\infty $ / $+\infty $,- / $0$,R,+ / $+\infty $}
\tkzTabIma{1}{3}{2}{$\frac{32}{3}$}
\tkzTabIma{4}{6}{5}{$\frac{16}{3}$}
\tkzTabLine { ,-,\frac{-64}{9},-,d,-,z,+,\frac{44}{9},+, }
\end{tikzpicture}
$ % Traduction CmathLuaTeX de : TVarP([-infinity,+infinity],x(t)=t^2/(t+1)(t-2),y(t)=t^2*(t+2)/(t+1))
```

## Installation ##
_Tous les fichiers cités dans cette partie sont contenus dans l'archive [CmathLuaTeX.zip](https://drive.google.com/file/d/0B6jPgqbuNpgRQTFhSVI2LTcyT3M/view?usp=sharing)._

### Installation sans package ###
Pour utliser `CmathLuaTeX`, ajoutez ces deux lignes dans le préambule de votre fichier tex :
```
\directlua{dofile('CmathLuaTeX.lua')}
\newcommand\Cmath[1]{\directlua{tex.print(Cmath2LaTeX('\detokenize{#1}'))}}
```

et c'est tout... ou presque.

Plus précisément :

1) Il faut que le fichier `CmathLuaTeX.lua` soit accessible à LuaTeX lors de la compilation. Si vous ne changez rien à la commande
```
\directlua{dofile('CmathLuaTeX.lua')}
```
cela suppose que `CmathLuaTeX.lua` est dans le même répertoire que votre fichier tex.
Mais il est probable que vous vouliez placer `CmathLuaTeX.lua` dans un répertoire qui sera accessible à tous vos fichiers tex où qu'ils soient sur le disque. Il faudra dans ce cas donner le chemin d'accès complet à `CmathLuaTeX.lua`. Par exemple sous Linux :
```
\directlua{dofile('/home/mon_repertoire/CmathLuaTeX.lua')}
```
ou sous Window$ :
```
\directlua{dofile('C:/mon_repertoire/CmathLuaTeX.lua')}
```

2) Il est nécessaire de compiler ses documents avec `LuaLaTeX`. Comme les distributions modernes de LaTeX incluent toutes LuaLaTeX (MikTeX, TexLive...), la plupart des éditeurs LaTeX sont configurables pour compiler via LuaLaTeX. Cherchez dans les options. On peut aussi remplacer la commande pdflatex par lualatex et cela fonctionne sans problème la plupart du temps.

3) Certains packages et définitions sont requis par CmathLuaTeX. Voici le "`Document test pour CmathLuaTeX.tex`" , prêt à compiler :
```
\documentclass[a4paper,10pt]{article}
\usepackage{fontspec}
%%%%%%%%%%%% Packages nécessaires à CmathLuaTeX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{amsmath,amssymb,mathrsfs,mathtools}
\usepackage[e]{esvect} % pour de jolis vecteurs
\usepackage{stmaryrd} % pour les intervalles d'entiers
\usepackage{cancel} % pour biffer
\usepackage{tikz} % figures géométriques (nécessaire pour les tableaux de variations et de signes)
\usepackage{tkz-tab} % pour les tableaux de variations et de signes
\usepackage{array,cellspace} % pour les tableaux de valeurs
\newcommand{\bmmax}{2} % Évite de dépasser la limite TeX des 16 polices simultanées. Doit être chargée avant bm.
\usepackage{bm} % pour les formules en gras
%%%%%%%%%%%% Packages facultatifs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\usepackage{metalogo} % pour écrire un joli \LuaTeX ou \LuaLaTeX
\usepackage[scr=boondoxo,scrscaled=1]{mathalfa} % police mathscr moins penchée. La ligne \newcommand{\bmmax}{2} peut être effacée si ce package n'est pas utilisé.
%%%%%%%%%%%% Adobe Zapf Chancery font %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareFontFamily{OT1}{pzc}{}
\DeclareFontShape{OT1}{pzc}{m}{it}{<-> s * [1.2] pzcmi7t}{}
\DeclareMathAlphabet{\mathpzc}{OT1}{pzc}{m}{it} % pour la police Zapf Chancery
%%%%%%%%%%%% Opérateurs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\DeclareMathOperator{\ch}{ch}
\DeclareMathOperator{\sh}{sh}
\renewcommand{\th}{\operatorname{th}}
\DeclareMathOperator{\argch}{argch}
\DeclareMathOperator{\argsh}{argsh}
\DeclareMathOperator{\argth}{argth}
\DeclareMathOperator{\Ima}{Im}
\DeclareMathOperator{\Ker}{Ker}
\renewcommand{\Im}{\operatorname{\mathfrak{Im}}}
\renewcommand{\Re}{\operatorname{\mathfrak{Re}}}
\DeclareMathOperator{\vect}{Vect}
\DeclareMathOperator{\pgcd}{pgcd}
\DeclareMathOperator{\ppcm}{ppcm}
%%%%%%%%%%%% CmathLuaTeX %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\directlua{dofile('CmathLuaTeX.lua')}
\newcommand\Cmath[1]{\directlua{tex.print(Cmath2LaTeX('\detokenize{#1}'))}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\begin{document}
$\Cmath{sin{π/2}=1}$
\end{document}
```

### Installation sous forme d'un package ###
C'est la méthode la plus confortable puisqu'il n'y a pas besoin d'indiquer dans le code source le chemin du fichier CmathLuaTeX.lua ni d'inclure le préambule nécessaire à CmathLuaTeX. Le document précédent devient :
```
\documentclass[a4paper,10pt]{article}
\usepackage{fontspec}
\usepackage{CmathLuaTeX}
\begin{document}
$\Cmath{sin{π/2}=1}$
\end{document}
```

Il suffit pour cela de mettre dans un répertoire visible par la distribution LaTeX les deux fichiers `CmathLuaTeX.lua` et `CmathLuaTeX.sty`. Un endroit facilement accessible est le répertoire désigné par la variable TEXMFHOME. Sous Linux, il s'agit probablement de `/home/votre_login/texmf` (à créer si besoin). On peut connaître le contenu de cette variable grâce à l'instruction `kpsewhich -var-value=TEXMFHOME`. Sous windows, il s'agira probablement d'un répertoire du genre `c:\users\votre_login\texmf`. Sur une clé USB avec texlive pour windows, il s'agit de `texlive/texmf-local`. Créer dans ce répertoire l'arborescence `tex/latex/CmathLuaTeX`. Sur ma machine, j'ai donc placé ces deux fichiers dans le répertoire `~/texmf/tex/latex/CmathLuaTeX`.

Ceci fait, essayez de compiler le petit document ci-dessus.

### Pour utiliser Xcas ###
Xcas doit être installé sur votre ordinateur. Toutefois, comme Bernard Parisse, suite à nos échanges, a fait quelques corrections nécessaires au fonctionnement de `CmathLuaTeX`, il faut impérativement télécharger Xcas en version supérieure ou égale à 1.1.1. La dernière version stable datée de juin 2014 convient très bien : http://www-fourier.ujf-grenoble.fr/~parisse/install_fr. J'en profite pour remercier ici Bernard pour sa grande disponibilité et sa rapidité à résoudre les problèmes.

Les utilisateurs de windows qui n'auraient pas choisi d'installer Xcas dans le répertoire par défaut devront modifier cette ligne du fichier `CmathLuaTeX.lua` pour prendre en compte votre répertoire d'installation (faites une recherche sur "bash") :
```
os.execute('\\xcas\\bash.exe -c "export LANG=fr_FR.UTF-8 ; /xcas/icas.exe giac.in"')
```
Pour cela, il convient d'être prudent. Ce fichier est codé en UTF-8 et le modifier avec un éditeur bas de gamme (notepad par exemple) le rendrait inutilisable.
  1. Installez un éditeur de texte digne de ce nom tel que [Notepad++](http://notepad-plus-plus.org/fr/) ou [Geany](http://www.geany.org/) (c'est celui que j'utilise)
  1. Modifiez cette ligne en changeant le chemin d'accès `c:\xcas\` par le vôtre en respectant la même syntaxe.
  1. Sauvegardez le fichier en vérifiant que vous êtes bien en encodage de caractères UTF-8.

Cela devrait fonctionner.

Pour tester Xcas, compilez ce code :
```
\documentclass[a4paper,10pt]{article}
\usepackage{fontspec}
\usepackage{CmathLuaTeX}
\begin{document}
$\Cmath{sin{π/2}=xcas(sin(pi/2))}$
\end{document}
```

### Pour profiter de TeXworks ###
Le confort d'utilisation de `CmathLuaTeX` sera optimale avec l'excellent éditeur `TeXworks`. Son apparence rustique cache une efficacité redoutable une fois qu'on a pris le temps de le personnaliser : jetez un œil sur les raccourcis clavier prédéfinis dans le fichier `TeXworks/completion/tw-latex.txt` et vous verrez que les possibilités sont infinis ; il suffit de créer son propre fichier de raccourcis dans ce même répertoire et le tour est joué ! Autre avantage tout aussi invisible au premier coup d’œil : la possibilité d'exécuter des scripts en javascript, en python et en lua. Ainsi, il est possible d'exécuter dans TeXworks le même script CmathLuaTeX que celui qui est appelé lors de la compilation par LuaLaTeX. C'est ce qui est fait à l'appel des différentes fonctions via les raccourcis claviers ajoutées à TeXworks (ces raccourcis se retrouvent aussi dans le menu `Scripts, Cmath`) :

| Touches | Action |
|:--------|:-------|
|`F9`     | Compose la formule tapée juste avant le curseur avec la fonction `$\Cmath{}$`. Action réversible en retapant F9.|
|`Maj+F9` | Compose la formule tapée juste avant le curseur avec la fonction `\[\Cmath{}\]`. Action réversible.|
|`Ctrl+F9` | Traduit en LaTeX la formule tapée juste avant le curseur, en mode texte.|
|`Ctrl+Maj+F9` | Traduit en LaTeX la formule tapée juste avant le curseur, en mode hors-texte.|
|`Alt+F9` | Compose la formule tapée juste avant le curseur avec la fonction `\Cmath{`}. Action réversible en retapant F9.|
| Ctrl+`*` | Affiche le symbole ×|
| Ctrl+/  | Affiche le symbole ÷|
| Ctrl+=  | Affiche le symbole ≈|
| Ctrl+R  | Affiche le symbole √|

La touche `F9` provoque une interprétation complète de l'expression par CmathLuaTeX, de la même manière que le ferait LuaLaTeX. Ce qui est affiché en retour est le résultat de cette interprétation. On voit donc tout de suite s'il y a une erreur de syntaxe ou de grammaire. Par ailleurs, un certain nombre de symboles sont traduits en wysiwyg. Par exemple `x:ap:R` devient `$\Cmath{x∈ℝ}$ `.

La combinaison `Ctrl+F9` appelle exactement la même fonction que LuaLaTeX et renvoie le code LaTeX correspondant. Le code produit est donc indépendant de CmathLuaTeX. C'est utile aussi lors des appels à des calculs formels ou des tableaux de signes ou de variations. Cela évite de lancer des appels à XCAS à chaque compilation puisque c'est texworks qui fait cet appel une fois pour toute ; le code renvoyé est du pur LaTeX.

Pour voir en détail comment installer et configurer TeXworks, consulter cette [page](ConfigTeXworks.md).

### Quid de la portabilité ? ###
Comme je l'ai expliqué, il est nécessaire de compiler le code source avec LuaLaTeX. Pourtant, il est possible de convertir toutes les commandes `\Cmath` d'un document en code LaTeX pour obtenir un code source standard et portable. Cela permet, par exemple, de le compiler avec pdfLaTeX, de le publier dans un wiki, un forum, etc...

Je fournis pour cela un script pour TeXworks accessible via le menu `Scripts,Cmath,Document Cmath -> document LaTeX`.

Ce script parcourt le document courant, traduit toutes les commandes `\Cmath` en `LaTeX`, y compris les commandes XCAS, les tableaux de variations, etc...
Le nouveau code est inséré dans un nouveau document. Ce code est totalement indépendant de `CmathLuaTeX` et peut être compilé avec `pdfLaTeX`.

Exemple : ce script exécuté pour le code ci-dessous tapé avec `CmathLuaTeX`
```
\begin{document}
Pour $\Cmath{x∈ℝ}$, on définit la fonction $\Cmath{f}$ par $\Cmath{f(x)=sinx}$.
On a : \[\Cmath{f(π/3)=xcas(sin(pi/3))}\]
\end{document}
```
fera apparaître un nouveau document contenant :
```
\begin{document}
Pour $x\in \mathbb{R} $, on définit la fonction $f$ par $f \left( x\right)  = \sin x$.
On a : \[f \left( \frac{\pi }{3}\right)  = \frac{\sqrt{3}}{2}\]
\end{document}
```

## CmathLuaTeX portable pour windows ##
Dans nos collèges et lycées, les ordinateurs sont pour une majorité sous windows. Voici une méthode qui permet de créer une clé USB prête à l'emploi pour compiler ses textes avec CmathLuaTeX. Aucun droit d'administration ne sont nécessaires. Il suffit d'insérer la clé pour pouvoir commencer à rédiger. Suivez ce lien pour [créer sa clé USB](CmathluatexPortable.md).

## Liste de diffusion ##
Pour rester informé des nouveautés et des mises à jour, inscrivez-vous à cette liste :

L'URL pour s'inscrire est : [mailto:cmathluatex-request@ml.free.fr?subject=subscribe](mailto:cmathluatex-request@ml.free.fr?subject=subscribe)

L'URL pour se désinscrire est : [mailto:cmathluatex-request@ml.free.fr?subject=unsubscribe](mailto:cmathluatex-request@ml.free.fr?subject=unsubscribe)

## Historique des versions ##

**3 janvier 2015 :**
  * Résolution d'un bug sur les tableaux de variations (fichier à mettre à jour : CmathLuaTeX.lua).
  * Création d'un package `CmathLuaTeX.sty` pour une installation encore plus simple.

**20 Août 2014 :**
  * Amélioration des tableaux de variations (fichier à mettre à jour : CmathLuaTeX.lua).


**17 Août 2014 :**
  * Ajout du script TeXworks `Cmath2Latex` (fichiers à mettre à jour : tous les fichiers du répertoire TeXworks/scripts/Cmath/)
  * Meilleure gestion du symbole de la dérivation (fichier à mettre à jour : CmathLuaTeX.lua).

**Juin 2014 :**
  * Première version.

## Qui suis-je ? ##
Christophe Devalland,
Professeur de mathématiques en CPGE ATS au [lycée Blaise Pascal](http://pascal-lyc.spip.ac-rouen.fr/spip.php?rubrique15) de Rouen.
