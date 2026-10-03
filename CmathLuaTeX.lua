--[[
	Cmath pour LuaTeX, version 2026.04.20
    Copyright (C) 2014-2026  Christophe Devalland (christophe.devalland@ac-normandie.fr)

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
]]

os.setlocale("en_US.UTF-8", "numeric") -- le séparateur décimal doit être le point
sin,cos,tan,asin,acos,atan=math.sin,math.cos,math.tan,math.asin,math.acos,math.atan
abs,sqrt,exp,log,ln=math.abs,math.sqrt,math.exp,math.log,math.log
cosh,sinh,tanh=math.cosh,math.sinh,math.tanh
pi,huge=math.pi,math.huge
local lpeg = require "lpeg"
local write = io.write
local match = lpeg.match
local C, P, R, S, V = lpeg.C, lpeg.P, lpeg.R, lpeg.S, lpeg.V
local Carg, Cc, Cp, Ct, Cs, Cg, Cf = lpeg.Carg, lpeg.Cc, lpeg.Cp, lpeg.Ct, lpeg.Cs, lpeg.Cg, lpeg.Cf

-- Syntaxe Cmath
local Espace = S(" \n\t")^0
local Guillemet=P('"')
local SepListe=C(S(',;'))* Espace
local Operateur=C(P('<=>')+P('<=')+P('>=')+P('<>')+P('->')+S('=><')
		+	P(':en')+P('≈')
		+	P(':as')+P('⟼')
		+	P(':ap')+P('∈')
		+	P('|')
		+	P('⟶')
		+	P(':un')+P('∪')
		+	P(':it')+P('∩')
		+	P(':ro')+P('∘')
		+	P(':eq')--+P('~')
		+	P(':co')+P('≡')
		+	P(':pp')+P('∨')
		+	P(':pg')+P('∧')
		+	P(':ve')+P('∧')
		+	P(':pe')+P('⊥')
		+	P(':sd')+P('⊕')
		+	P(':np')+P('∉')
		+	P(':im')+P('⇒')
		+	P(':ev')+P('⟺')
		+	P(':rc')+P('⇐')
		+	P(':ic')+P('⊂')
		+	P(':ni')+P('⊄')
		+	P(':re')+P('⟵')
		+	P(':pr')
		+	P('⩽')+P('⩾')
		+	P('≠')
		) * Espace
				
local TSubstOperateurLaTeX = {	['<=>']='\\Leftrightarrow ', 
		['<=']='\\leqslant ',['⩽']='\\leqslant ',
		['>=']='\\geqslant ',['⩾']='\\geqslant ',
		['<>']='\\neq ', ['≠']='\\neq ',
		['<']=' < ',
		['>']=' > ',
		['=']=' = ',
		[':en']='\\approx ', ['≈']='\\approx ',
		[':ap']='\\in ', ['∈']='\\in ',
		[':as']='\\mapsto ', ['⟼']='\\mapsto ',
		['->']='\\to ',	['⟶']='\\to ',
		['|']='|',
		[':un']='\\cup ', ['∪']='\\cup ',
		[':it']='\\cap ', ['∩']='\\cap ',
		[':ro']='\\circ ', ['∘']='\\circ ',
		[':eq']='\\sim ',
		[':co']='\\equiv ', ['≡']='\\equiv ',
		[':pp']='\\vee ', ['∨']='\\vee ',
		[':pg']='\\wedge ', ['∧']='\\wedge ', [':ve']='\\wedge ',
		[':pe']='\\perp ', ['⊥']='\\perp ',
		[':sd']='\\oplus ', ['⊕']='\\oplus ',
		[':np']='\\notin ', ['∉']='\\notin ',
		[':im']='\\Rightarrow ',	['⇒']='\\Rightarrow ',
		[':ev']='\\Leftrightarrow ',	['⟺']='\\Leftrightarrow ',
		[':rc']='\\Leftarrow ', ['⇐']='\\Leftarrow ',
		[':ic']='\\subset ', ['⊂']='\\subset ',
		[':ni']='\\not\\subset ', ['⊄']='\\not\\subset ',
		[':re']='\\leftarrow ',['⟵']='\\leftarrow ',
		[':pr']='\\mspace{4 mu}\\backslash',
		}
local TSubstOperateurTW = {	['<=>']='⟺',
		['<=']='⩽',
		['>=']='⩾',
		['<>']='≠',
		[':en']='≈',
		[':ap']='∈',
		[':as']='⟼',
		['->']='⟶',
		[':un']='∪',
		[':it']='∩',
		[':ro']='∘',
		--[':eq']='~',
		[':co']='≡',
		[':pp']='∨',
		[':pg']='∧', [':ve']='∧',
		[':pe']='⊥',
		[':sd']='⊕',
		[':np']='∉',
		[':im']='⇒',
		[':ev']='⟺',
		[':rc']='⇐',
		[':ic']='⊂',
		[':ni']='⊄',
		[':re']='⟵'
		}	
						  					  
local Chiffre=R("09")
local Partie_Entiere=Chiffre^1
local Partie_Decimale=(P(".")/",")*(Chiffre^1)
local Nombre = C(Partie_Entiere*Partie_Decimale^-1) * Espace
local Raccourci = 	C( P'...'
		+ 	(P':al'+P'α')
		+ 	(P':be'+P'β')
		+	(P':ga'+P'γ') + (P':GA'+P'Γ')
		+	(P':de'+P'δ') + (P':DE'+P'Δ')
		+	(P':ep'+P'ε')
		+ 	(P':ze'+P'ζ')
		+ 	(P':et'+P'η')
		+	(P':th'+P'θ') +	(P':TH'+P'Θ')
		+	(P':io'+P'ι')
		+ 	(P':ka'+P'κ')
		+ 	(P':la'+P'λ') + (P':LA'+P'Λ')
		+ 	(P':mu'+P'μ')
		+	(P':nu'+P'ν')
		+ 	(P':xi'+P'ξ') +	(P':XI'+P'Ξ')
		+ 	(P':pi'+P'π') + (P':PI'+P'Π')
		+ 	(P':rh'+P'ρ')
		+	(P':si'+P'σ') +	(P':SI'+P'Σ')
		+ 	(P':ta'+P'τ')
		+	(P':up'+P'υ') + (P':UP'+P'Υ')
		+ 	(P':ph'+P'φ') + (P':PH'+P'Φ')
		+	(P':ch'+P'χ') 
		+ 	(P':ps'+P'ψ') + (P':PS'+P'Ψ')
		+	(P':om'+P'ω') + (P':OM'+P'Ω')
		+	(P':in'+P'∞')
		+	(P':ll'+P'ℓ')
		+	(P':pm'+P'±')
		+	(P':dr'+P'∂')
		+	(P':vi'+P'∅')
		+	(P':ex'+P'∃')
		+	(P':qs'+P'∀')
		+	P':oijk'
		+	P':oij'
		+	P':ouv'
		+	(P':Rpe'+P'ℝpe')
		+	(P':Rme'+P'ℝme')
		+	(P':Rp'+P'ℝp')
		+	(P':Rm'+P'ℝm')
		+	(P':Re'+P'ℝe')
		+	(P':R'+P'ℝ')
		+	(P':Ne'+P'ℕe')
		+	(P':N'+P'ℕ')
		+	(P':Ze'+P'ℤe')
		+	(P':Z'+P'ℤ')
		+	(P':Ce'+P'ℂe')
		+	(P':C'+P'ℂ')
		+	(P':Qe'+P'ℚe')
		+	(P':Q'+P'ℚ')
		+	(P':K'+P'𝕂')
		+	(P':U'+P'𝕌')
		+	(P':e'+P'е')
		+	(P':i'+P'і')
		+	P':d'
		- 	Operateur) * Espace

local TSubstRaccourciLaTeX = {	['...']='\\dots ',
		[':al']='\\alpha ', ['α']='\\alpha ',
		[':be']='\\beta ', ['β']='\\beta ',
		[':ga']='\\gamma ', ['γ']='\\gamma ', [':GA']='\\Gamma ', ['Γ']='\\Gamma ', 
		[':de']='\\delta ', ['δ']='\\delta ',[':DE']='\\Delta ', ['Δ']='\\Delta ',
		[':ep']='\\varepsilon ', ['ε']='\\varepsilon ',
		[':ze']='\\zeta ', ['ζ']='\\zeta ',
		[':et']='\\eta ', ['η']='\\eta ',
		[':th']='\\theta ', ['θ']='\\theta ',[':TH']='\\Theta ', ['Θ']='\\Theta ',
		[':io']='\\iota ', ['ι']='\\iota ',
		[':ka']='\\varkappa ', ['κ']='\\varkappa ',
		[':la']='\\lambda ', ['λ']='\\lambda ',[':LA']='\\Lambda ', ['Λ']='\\Lambda ',
		[':mu']='\\mu ', ['μ']='\\mu ',
		[':nu']='\\nu ', ['ν']='\\nu ',
		[':xi']='\\xi ', ['ξ']='\\xi ',[':XI']='\\Xi ', ['Ξ']='\\Xi ',
		[':pi']='\\pi ', ['π']='\\pi ',[':PI']='\\Pi ', ['Π']='\\Pi ',
		[':rh']='\\rho ', ['ρ']='\\rho ',
		[':si']='\\sigma ', ['σ']='\\sigma ',[':SI']='\\Sigma ', ['Σ']='\\Sigma ',
		[':ta']='\\tau ', ['τ']='\\tau ',
		[':up']='\\upsilon ', ['υ']='\\upsilon ',[':UP']='\\Upsilon ', ['Υ']='\\Upsilon ',
		[':ph']='\\varphi ', ['φ']='\\varphi ',[':PH']='\\Phi ', ['Φ']='\\Phi ',
		[':ch']='\\chi ', ['χ']='\\chi ',
		[':ps']='\\psi ', ['ψ']='\\psi ',[':PS']='\\Psi ', ['Ψ']='\\Psi ',
		[':om']='\\omega ', ['ω']='\\omega ',[':OM']='\\Omega ', ['Ω']='\\Omega ',
		[':in']='\\infty ', ['∞']='\\infty ',
		[':ll']='\\ell ', ['ℓ']='\\ell ',
		[':pm']='\\pm ', ['±']='\\pm ',
		[':dr']='\\partial ', ['∂']='\\partial ',
		[':vi']='\\varnothing ', ['∅']='\\varnothing ',
		[':ex']='\\exists ', ['∃']='\\exists ',
		[':qs']='\\forall ', ['∀']='\\forall ',
		[':oijk']='(O\\,{;}\\,\\vv{\\imath}{,}\\,\\vv{\\jmath}{,}\\,\\vv{k} ) ',
		[':oij']='\\left(O\\,{;}\\,\\vv{\\imath}{,}\\,\\vv{\\jmath} \\right) ',
		[':ouv']='\\left(O\\,{;}\\,\\vv{u}{,}\\,\\vv{v} \\right) ',
		[':Rpe']='\\mathbb{R}_{+}^{*} ', ['ℝpe']='\\mathbb{R}_{+}^{*} ',
		[':Rme']='\\mathbb{R}_{-}^{*} ', ['ℝme']='\\mathbb{R}_{-}^{*} ',
		[':Rp']='\\mathbb{R}^{+} ', ['ℝp']='\\mathbb{R}^{+} ',
		[':Rm']='\\mathbb{R}^{-} ', ['ℝm']='\\mathbb{R}^{-} ',
		[':Re']='\\mathbb{R}^{*} ', ['ℝe']='\\mathbb{R}^{*} ',
		[':R']='\\mathbb{R} ', ['ℝ']='\\mathbb{R} ',
		[':Ne']='\\mathbb{N}^{*} ', ['ℕe']='\\mathbb{N}^{*} ',
		[':N']='\\mathbb{N} ', ['ℕ']='\\mathbb{N} ',
		[':Ze']='\\mathbb{Z}^{*} ', ['ℤe']='\\mathbb{Z}^{*} ',
		[':Z']='\\mathbb{Z} ', ['ℤ']='\\mathbb{Z} ',
		[':Ce']='\\mathbb{C}^{*} ', ['ℂe']='\\mathbb{C}^{*} ',
		[':C']='\\mathbb{C} ', ['ℂ']='\\mathbb{C} ',
		[':Qe']='\\mathbb{Q}^{*} ', ['ℚe']='\\mathbb{Q}^{*} ',
		[':Q']='\\mathbb{Q} ', ['ℚ']='\\mathbb{Q} ',
		[':K']='\\mathbb{K} ', ['𝕂']='\\mathbb{K} ',
		[':U']='\\mathbb{U} ', ['𝕌']='\\mathbb{U} ',
		[':e']='\\mathrm{e} ', ['е']='\\mathrm{e} ',
		[':i']='\\mspace{1 mu}\\mathrm{i} ', ['і']='\\mspace{1 mu}\\mathrm{i} ',
		[':d']='{\\mathop{}\\mathopen{}\\mathrm{d}}'
		}

local TSubstRaccourciTW = {	[':al']='α',
		[':be']='β',
		[':ga']='γ', [':GA']='Γ', 
		[':de']='δ', [':DE']='Δ',
		[':ep']='ε',
		[':ze']='ζ',
		[':et']='η',
		[':th']='θ', [':TH']='Θ',
		[':io']='ι',
		[':ka']='κ',
		[':la']='λ',[':LA']='Λ',
		[':mu']='μ',   
		[':nu']='ν',
		[':xi']='ξ',[':Xi']='Ξ',
		[':pi']='π',[':PI']='Π',
		[':rh']='ρ',
		[':si']='σ',[':SI']='Σ',
		[':ta']='τ',
		[':up']='υ',[':UP']='Υ',
		[':ph']='φ',[':PH']='Φ',
		[':ch']='χ',
		[':ps']='ψ',[':PS']='Ψ',
		[':om']='ω',[':OM']='Ω',
		[':in']='∞',
		[':ll']='ℓ',
		[':pm']='±',
		[':dr']='∂',
		[':vi']='∅',
		[':ex']='∃',
		[':qs']='∀',
		[':Rpe']='ℝpe',
		[':Rme']='ℝme',
		[':Rp']='ℝp',
		[':Rm']='ℝm',
		[':Re']='ℝe',
		[':R']='ℝ',
		[':Ne']='ℕe',
		[':N']='ℕ',
		[':Ze']='ℤe',
		[':Z']='ℤ',
		[':Ce']='ℂe',
		[':C']='ℂ',
		[':Qe']='ℚe',
		[':Q']='ℚ',
		[':K']='𝕂',
		[':U']='𝕌',
		[':e']='е',
		[':i']='і'	
		}

local Lettre = R("az")+R("AZ")+P("!")+P("'")+P("′")+P("~")
local Mot=C(Lettre^1+P('∭')+P('∬')+P('∫')+P('√')) - Guillemet
local Op_LaTeX = C(P("\\")*Lettre^1) * Espace
local TermOp = C(S("+-")) * Espace
local FactorOp = C(P("**")+S("* ")+P("×")+P("..")) * Espace
local DiviseOp = C(P("//")+P("/")+P("÷")) * Espace
local PuissanceOp = C(P("^^")+P("^")) * Espace
local IndiceOp = C(P("__")+P("_")) * Espace
local Parenthese_Ouverte = P("(") * Espace
local Parenthese_Fermee = P(")") * Espace
local Accolade_Ouverte = P("{") * Espace
local Accolade_Fermee = P("}") * Espace
local Crochet = C(S("[]")) * Espace
local Intervalle_Entier_Ouvert = P("[[")+P("⟦")
local Intervalle_Entier_Ferme = P("]]")+P("⟧")
local Fonction_sans_eval = P("xcas")+P("TVarP")+P("TVar")+P("TSig")+P("TVal")+P("sysl")+P("GaussSysl")+P("GaussRang")+P("GaussInv")
							+P("tikzPlot")+P("tikzWindow")+P("tikzGrid")+P("tikzAxeX")+P("tikzAxeY")+P("tikzPoint")
							+P("pgfPlot3")+P("codeLua")+P("tikzTangent")
local CaractereSansParentheses=(1-S"()")
local Egal = S('=')* Espace
local CaractereSansParenthesesSep=(1-S"(),;")
local CaractereSansCrochets=(1-S"[]")

-- Substitutions dans les Mots
local TSubstCmathLaTeX =	P'arcsin'/'\\arcsin '
		+	P'arccos'/'\\arccos '
		+	P'arctan'/'\\arctan '
		+	P'argch'/'\\argch '
		+	P'argsh'/'\\argsh '
		+	P'argth'/'\\argth '
		+	P'ppcm'/'\\ppcm '
		+	P'vect'/'\\vect '
		+	P'pgcd'/'\\pgcd '
		+ 	P'cdots'/'\\cdots '
		+ 	P'ldots'/'\\ldots '
		+ 	P'vdots'/'\\vdots '
		+ 	P'ddots'/'\\ddots '
		+	P'sin'/'\\sin '
		+	P'cos'/'\\cos '
		+	P'tan'/'\\tan '
		+	P'exp'/'\\exp '
		+	P'ima'/'\\Ima '
		+	P'arg'/'\\arg '
		+	P'ker'/'\\Ker '
		+	P'dim'/'\\dim '
		+	P'deg'/'\\deg '
		+	P'log'/'\\log '
		+	P'ln'/'\\ln '
		+	P'ch'/'\\ch '
		+	P'sh'/'\\sh '
		+	P'th'/'\\th '
		+	P'card'/'\\card '
		--+	P'′'/"\\mspace{2 mu}'\\mspace{-3 mu}"
		+	P'!'/'\\mspace{2 mu}!'
		+	1

local TSubstCmathTW =	P"'"/'′' + 1	-- le symbole de la dérivation ne doit pas interférer avec l'indicateur de fin de chaîne

function fOperateur(arg1,op,arg2)
	return {'op_binaire',op,arg1,arg2}
end


function fTerm(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fParentheses(arg1)
	return {'()',arg1}
end

function fAccolades(arg1)
	return {'{}',arg1}
end

function fIndice(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fFactor(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fDivise(arg1,op,arg2)
	if string.sub(arg1[1],1,5)=='signe' then -- ramener le signe devant la fraction
		return {arg1[1],{op,arg1[2],arg2}}
	else
		return {op,arg1,arg2}
	end
end

function fPuissance(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fMultImplicite(arg1,arg2)
	if string.sub(arg1[1],1,5)=='signe' then
		return {arg1[1],{'imp*',arg1[2],arg2}}
	elseif arg1[1]=='imp*' and (arg1[3][1]=='√' or arg1[2][1]=='√') then -- rétablir la multiplication implicite pour la racine carrée (ex 2√3 ou √3x). Revoir la grammaire de la racine car ne fonctionne pas pour 2√3x.
		return {'imp*',arg1[2],{'imp*',arg1[3],arg2}}
	else
		return {'imp*',arg1,arg2}
	end
end

function fTexte(arg1)
	return {'text',arg1}
end

function fFonction_sans_eval(arg1,arg2)
	return {'no_eval',arg1,arg2}
end



function fListe(arg1,op,arg2)
	if arg2==nil then arg2={''} end
	if arg1[1]=='liste '..op then
		table.insert(arg1,arg2)
		return arg1
	else
		if arg1=='' then arg1={''} end
		return {'liste '..op,arg1,arg2}
	end
end

function fSans_texte(arg1)
	return {arg1}
end

function fOp_LaTeX(arg1)
	return {'latex',arg1}
end

function fCrochets(arg1,arg2,arg3)
	return {arg1,arg2,arg3}
end

function fRaccourcis(arg1)
	return {'raccourci',arg1}
end

function fFormule_signee(arg1,arg2)
   return {'signe '..arg1,arg2}
end

function fIntervalle_Entier(arg1)
	return {'⟦⟧',arg1}
end

local FonctionsCmath = 	P('abs')+	-- valeur absolue
		P('iiint')+P('∭')+			-- intégrale triple
		P('iint')+P('∬')+			-- intégrale double
		P('int')+P('∫')+			-- intégrale
		P('rac')+P('√')+			-- racine
		P('vec')+					-- vecteur ou coordonnées de vecteurs si liste
		P('cal')+P('scr')+P('frak')+P('pzc')+ -- polices
		P('gra')+					-- gras
		P('ang')+					-- angle
		P('til')+						-- tilde
		P('bar')+					-- barre
		P('sou')+					-- souligné
		P('nor')+					-- norme
		P('acc')+					-- accolades
		P('som')+					-- sommes
		P('pro')+					-- produit
		P('uni')+					-- union
		P('ite')+					-- intersection
		P('psc')+					-- produit scalaire
		P('acs')+					-- accolade supérieure
		P('aci')+					-- accolade inférieure
		P('cnp')+					-- Cnp
		P('ort')+					-- orthogonal d'une partie
		P('aut')+					-- autour
		P('bif')+					-- biffer
		P('sys')+					-- système
		P('mat')+					-- matrice
		P('det')+					-- déterminant
		P('tab')+					-- tableau
		P('tor')+					-- torseur
		P('cro')+					-- crochet
		P('lim')+					-- limite
		P('min')+					-- min
		P('max')+					-- max
		P('sup')+					-- sup
		P('inf')+					-- inf
		P('enc')+					-- encadré
		P('equ')+					-- équivalent à
		P('ten')+					-- tend vers
		P('acd')+					-- accolade droite
		P('sui')+					-- suite
		P('ser')+					-- série
		P('pto')+					-- petit o
		P('gro')+					-- grand o
		P('derp')+					-- dérivée partielle
		P('der')+					-- dérivée physicienne
		P('res')+					-- restreint à
		P('ent')+					-- partie entière inférieure
		P('flo')+					-- partie entière inférieure
		P('cei')+					-- partie entière supérieure
		P('ds')+					-- mode display
		P('ts')+					-- mode text
		P('im')+					-- partie imaginaire
		P('re')						-- partie réelle
												
function construitMatrix(arbre,typeMatrice)
local s='\\begin{'..typeMatrice..'}\n'
local n = nbArg(arbre)
local nb_col = tonumber(Tree2Latex(arbre[1]))
for i=2,n-1 do 
	s=s..Tree2Latex(arbre[i])
	if (i-1)%nb_col==0 then
		s=s..' \\\\\n'
	else
		s=s..' & '
	end
end
s=s..Tree2Latex(arbre[n])..'\n\\end{'..typeMatrice..'}'
return s
end

function construitLimite(arbre,typeLimite)
	local n = nbArg(arbre)
	local s='\\'..typeLimite..' _{'
	if n==2 then
		s=s..Tree2Latex(arbre[1])..'} {'..Tree2Latex(arbre[2])..'} '
	else
		s=s..'\\substack{'..Tree2Latex(arbre[1])..'\\\\ '..Tree2Latex(arbre[2])..'}} {'..Tree2Latex(arbre[3])..'} '
	end
	return s
end

local TraitementFonctionsCmath = 
{ 	['abs']=
	function(arbre) 
		return '\\left\\vert{'..Tree2Latex(arbre)..'} \\right\\vert ' 
	end,

	['vec']=
	function(arbre) 
		if (arbre[1]=='liste ,' or arbre[1]=='liste ;') then
			local s='\\begin{pmatrix}\n'
			local n = nbArg(arbre)
			local nb_col = tonumber(Tree2Latex(arbre[1]))
			for i=1,n-1 do 
				s=s..Tree2Latex(arbre[i])..' \\\\\n'
			end
			s=s..Tree2Latex(arbre[n])..'\n\\end{pmatrix}'
			return s
		else
			return '\\vv{'..Tree2Latex(arbre)..'}' 
		end
	end,
	
	['rac']=
	function(arbre)
		if (arbre[1]=='liste ,' or arbre[1]=='liste ;') then
      local n = nbArg(arbre)
			return '\\sqrt['..Tree2Latex(arbre[1])..']{'..Tree2Latex(arbre[2])..'}'
		else
			return '\\sqrt{'..Tree2Latex(arbre)..'}'
		end
	end,
	
	['√']=
	function(arbre)
		if (arbre[1]=='liste ,' or arbre[1]=='liste ;') then
      local n = nbArg(arbre)
			return '\\sqrt['..Tree2Latex(arbre[1])..']{'..Tree2Latex(arbre[2])..'}'
		else
			return '\\sqrt{'..Tree2Latex(arbre)..'}'
		end
	end,
	
	['int']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\int _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n==4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
		end
		s=s..'}'
		return s
	end,
	
	['∫']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\int _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n==4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
		end
		s=s..'}'
		return s
	end,

	['iint']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\iint _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n>=4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[5])
		end
		s=s..'}'
		return s
	end,
	
	['∬']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\iint _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n>=4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[5])
		end
		s=s..'}'
		return s
	end,

	['iiint']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\iiint _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n>=4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[5])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[6])
		end
		s=s..'}'
		return s
	end,
	
	['∭']=
	function(arbre)
		local s
		local n = nbArg(arbre)
		s='\\iiint _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'} \\mspace{-4 mu} {'..Tree2Latex(arbre[3])
		if n>=4 then
			s=s..'\\mspace{2 mu} {\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[4])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[5])
			s=s..'{\\mathop{}\\mathopen{}\\mathrm{d}}'..Tree2Latex(arbre[6])
		end
		s=s..'}'
		return s
	end,

	['cal']=
	function(arbre) 
		return '\\mathcal{'..Tree2Latex(arbre)..'}' 
	end,
	
	['scr']=
	function(arbre) 
		return '\\mathscr{'..Tree2Latex(arbre)..'}' 
	end,
	
	['frak']=
	function(arbre) 
		return '\\mathfrak{'..Tree2Latex(arbre)..'}' 
	end,
	
	['pzc']=
	function(arbre) 
		return '\\mathpzc{'..Tree2Latex(arbre)..'}' 
	end,
	
	['gra']=
	function(arbre) 
		return '\\bm{'..Tree2Latex(arbre)..'}' 
	end,

	['ang']=
	function(arbre) 
		return '\\widehat{'..Tree2Latex(arbre)..'}' 
	end,

	['til']=
	function(arbre) 
		return '\\widetilde{'..Tree2Latex(arbre)..'}' 
	end,

	['enc']=
	function(arbre) 
		return '\\boxed{'..Tree2Latex(arbre)..'}' 
	end,

	['ten']=
	function(arbre) 
		local n = nbArg(arbre)
		if n==3 then
			return Tree2Latex(arbre[1])..' \\xrightarrow['..Tree2Latex(arbre[2])..']{} '..Tree2Latex(arbre[3])
		else
			return Tree2Latex(arbre[1])..' \\xrightarrow[]{} '..Tree2Latex(arbre[2])
		end
	end,

	['equ']=
	function(arbre) 
		local n = nbArg(arbre)
		if n==3 then
			return Tree2Latex(arbre[1])..' \\underset{'..Tree2Latex(arbre[2])..'}{\\sim} '..Tree2Latex(arbre[3])
		else
			return Tree2Latex(arbre[1])..' \\sim '..Tree2Latex(arbre[2])
		end
	end,

	['sui']=
	function(arbre) 
		local n,nom_var
		if (arbre[1]=='liste ,' or arbre[1]=='liste ;') then
			n = nbArg(arbre)
			if arbre[2][1]=='op_binaire' then
				nom_var=Tree2Latex(arbre[2][3])
				return '\\left( '..Tree2Latex(arbre[1])..'_{'..nom_var..'} \\right) _{'..Tree2Latex(arbre[2])..'}'
			else
				nom_var=Tree2Latex(arbre[2])
				return '\\left( '..Tree2Latex(arbre[1])..'_{'..nom_var..'} \\right) _{'..nom_var..'\\in \\mathbb{N}}'
			end
		else
			return '\\left( '..Tree2Latex(arbre)..'_{n} \\right) _{n\\in \\mathbb{N}}'	
		end
	end,

	['ser']=
	function(arbre) 
		local n,nom_var
		if (arbre[1]=='liste ,' or arbre[1]=='liste ;') then
			n = nbArg(arbre)
			if arbre[2][1]=='op_binaire' then
				nom_var=Tree2Latex(arbre[2][3])
				return '\\sum \\left( '..Tree2Latex(arbre[1])..'_{'..nom_var..'} \\right) _{'..Tree2Latex(arbre[2])..'}'
			else
				nom_var=Tree2Latex(arbre[2])
				return '\\sum '..Tree2Latex(arbre[1])..'_{'..nom_var..'}'
			end
		else
			return '\\sum '..Tree2Latex(arbre)..'_{n}'	
		end
	end,
	
	['pto']=
	function(arbre)
		local n
		if (arbre[1]=='liste ,' or arbre[1]=='liste ;') then
			n = nbArg(arbre)
			return 'o_{'..Tree2Latex(arbre[1])..'} \\left( '..Tree2Latex(arbre[2])..'\\right) '
		else
			return 'o\\left( '..Tree2Latex(arbre)..'\\right) '
		end
	end,

	['gro']=
	function(arbre) 
		local n
		if (arbre[1]=='liste ,' or arbre[1]=='liste ;') then
			n = nbArg(arbre)
			return 'O_{'..Tree2Latex(arbre[1])..'} \\left( '..Tree2Latex(arbre[2])..'\\right) '
		else
			return 'O \\left( '..Tree2Latex(arbre)..'\\right) '
		end
	end,
	
	['der']=
	function(arbre) 
		local n = nbArg(arbre)
		if n==3 then
			return '\\frac{\\textrm{d}^{'..Tree2Latex(arbre[3])..'}'..Tree2Latex(arbre[1])..'}{\\textrm{d}'..Tree2Latex(arbre[2])..'^{'..Tree2Latex(arbre[3])..'}}'
		else
			return '\\frac{\\textrm{d}'..Tree2Latex(arbre[1])..'}{\\textrm{d}'..Tree2Latex(arbre[2])..'}'
		end
	end,

	['derp']=
	function(arbre) 
		local n = nbArg(arbre)
		local noms_var={}
		local ordres_partiels={}
		local ordre=0
		local i,j=1,1
		local s
		arg2=arbre[2][1]
		while i<=string.len(arg2) do
			table.insert(noms_var,string.sub(arg2,i,i))
			j=1
			i=i+1
			while(i<=string.len(arg2) and string.sub(arg2,i,i)==string.sub(arg2,i-1,i-1)) do
				i=i+1
				j=j+1
			end
			ordre=ordre+j
			table.insert(ordres_partiels,j)
		end
		if ordre~=1 then
			s='\\frac{\\partial ^{'..tostring(ordre)..'}'..Tree2Latex(arbre[1])..'}{'
		else
			s='\\frac{\\partial '..Tree2Latex(arbre[1])..'}{'
		end
		i=1
		while(noms_var[i]~=nil) do -- table.getn ne marche pas dans LuaTeX
			s=s..'\\partial '..noms_var[i]
			if ordres_partiels[i]~=1 then
				s=s..'^'..tostring(ordres_partiels[i])
			end
			s=s..' '
			i=i+1
		end
		s=s..'}'
		return s
	end,
	
	['res']=
	function(arbre) 
		local n = nbArg(arbre)
		return Tree2Latex(arbre[1])..'_{|'..Tree2Latex(arbre[2])..'}'
	end,
	
	['bar']=
	function(arbre) 
		return '\\overline{'..Tree2Latex(arbre)..'}' 
	end,

	['sou']=
	function(arbre) 
		return '\\underline{'..Tree2Latex(arbre)..'}' 
	end,

	['nor']=
	function(arbre) 
		return '\\lVert{'..Tree2Latex(arbre)..'}\\rVert' 
	end,

	['acc']=
	function(arbre) 
		return '\\left\\{ '..Tree2Latex(arbre)..'\\right\\} ' 
	end,
	
	['som']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\sum _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'}{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['pro']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\prod _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'}{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['ite']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\bigcap _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'}{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['uni']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\bigcup _{'..Tree2Latex(arbre[1])..'} ^{'..Tree2Latex(arbre[2])..'}{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['psc']=
	function(arbre)
		return '\\left\\langle '..Tree2Latex(arbre)..'\\right\\rangle '
	end,
	
	['acs']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\overbrace{'..Tree2Latex(arbre[1])..'}^{'..Tree2Latex(arbre[2])..'}'
	end,

	['aci']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\underbrace{'..Tree2Latex(arbre[1])..'}_{'..Tree2Latex(arbre[2])..'}'
	end,

	['cnp']=
	function(arbre)
		local n = nbArg(arbre)
		return '\\binom{'..Tree2Latex(arbre[1])..'}{'..Tree2Latex(arbre[2])..'}'
	end,
	
	['ort']=
	function(arbre) 
		return Tree2Latex(arbre)..'^{\\perp}'
	end,
	
	['aut']=
	function(arbre)
		local n = nbArg(arbre)
		for i=n+1,5 do arbre[i]={''} end
		return '{\\prescript{'..Tree2Latex(arbre[4])..'}{'..Tree2Latex(arbre[5])..'}{'..Tree2Latex(arbre[1])..'}}_{'..Tree2Latex(arbre[2])..'}^{'..Tree2Latex(arbre[3])..'}'
	end,
	
	['bif']=
	function(arbre) 
		return '\\cancel{ '..Tree2Latex(arbre)..'} ' 
	end,

--[[	['sysl']=
	function(arbre)
		local s='\\left\\{\n\\begin{alignedat}{'
		local n = nbArg(arbre)
		-- récupérer le nombre de variables
		local nb_var = tonumber(Tree2Latex(arbre[1]))
		s=s..tostring(nb_var+1)..'}\n'
		local premier_terme=true
		-- les variables sont contenues dans arbre[2] à arbre[1+nb_var]
		-- les coefficients sont contenus dans arbre[2+nb_var] à arbre[n]
		for i=2+nb_var,n do 
			local coef=Tree2Latex(arbre[i])
			local val_coef=tonumber(coef)
			local signe=string.sub(coef,1,1)
			if(signe~='-') then
				signe='+'				
			end
			local coef_reduit=coef
			if (coef=='1' or coef=='-1') then
				coef_reduit=string.sub(coef,1,-2)
			end
			local variable=Tree2Latex(arbre[(i-2-nb_var)%(nb_var+1)+2])
			-- si premier terme d'une ligne
			if (i-1-nb_var)%(nb_var+1)==1 then
				if val_coef~=0 then
					s=s..coef_reduit..' '..variable
					premier_terme=false
				end
				s=s..' & '
			else
				-- si dernier terme d'une ligne
				if (i-1-nb_var)%(nb_var+1)==0 then
					s=s..'~=~ & '..coef..' \\\\\n'
					premier_terme=true
				else
					if val_coef~=0 then
						if (signe=='+') then
							if premier_terme==false then
								s=s..'~+~'
							end
							s=s..' & '..coef_reduit..' '..variable..' & '
							premier_terme=false
						else
							s=s..'~-~ & '..string.sub(coef_reduit,2)..' '..variable..' & '
							premier_terme=false
						end
					else
						s=s..' & & '
					end
				end
			end
		end
		s=s..'\\end{alignedat}\n\\right.\n'
		return s
	end]]--
	
	['sys']=
	function(arbre)
		local s='\\begin{cases}\n'
		local n = nbArg(arbre)
		s=s..Tree2Latex(arbre[1])
		for i=2,n do 
			s=s..' \\\\\n'..Tree2Latex(arbre[i])
		end	
		s=s..'\n\\end{cases}'
		return s
	end,

	['acd']=
	function(arbre)
		local s='\\left.\n\\begin{array}{r}\n'
		local n = nbArg(arbre)
		s=s..Tree2Latex(arbre[1])
		for i=2,n do 
			s=s..' \\\\\n'..Tree2Latex(arbre[i])
		end	
		s=s..'\n\\end{array}\n\\right\\}'
		return s
	end,
	
	['mat']=
	function(arbre)
		return construitMatrix(arbre,"pmatrix")
	end,

	['det']=
	function(arbre)
		return construitMatrix(arbre,"vmatrix")
	end,

	['tab']=
	function(arbre)
		return construitMatrix(arbre,"matrix")
	end,

	['tor']=
	function(arbre)
		return construitMatrix(arbre,"Bmatrix")
	end,

	['cro']=
	function(arbre)
		return construitMatrix(arbre,"bmatrix")
	end,
	
	['lim']=
	function(arbre)
		return construitLimite(arbre,'lim')
	end,

	['min']=
	function(arbre)
		return construitLimite(arbre,'min')
	end,

	['max']=
	function(arbre)
		return construitLimite(arbre,'max')
	end,

	['inf']=
	function(arbre)
		return construitLimite(arbre,'inf')
	end,

	['sup']=
	function(arbre)
		return construitLimite(arbre,'sup')
	end,
	
	['ent']=
	function(arbre) 
		return '\\left \\lfloor {'..Tree2Latex(arbre)..'} \\right \\rfloor'
	end,
	
	['flo']=
	function(arbre) 
		return '\\left \\lfloor {'..Tree2Latex(arbre)..'} \\right \\rfloor'
	end,
	
	['cei']=
	function(arbre) 
		return '\\left \\lceil {'..Tree2Latex(arbre)..'} \\right \\rceil'
	end,
	
	['im']=
	function(arbre) 
		return '\\mathfrak{Im}\\,{'..Tree2Latex(arbre)..'}' 
	end,

	['re']=
	function(arbre) 
		return '\\mathfrak{Re}\\,{'..Tree2Latex(arbre)..'}' 
	end,

	['ts']=
	function(arbre) 
		return '{\\textstyle '..Tree2Latex(arbre)..'} ' 
	end,
	
	['ds']=
	function(arbre) 
		return '{\\displaystyle '..Tree2Latex(arbre)..'} ' 
	end
}

function nbArg(liste)
	table.remove(liste,1)
	return #liste
end

function Parentheses_inutiles(Arbre)
	if Arbre[1]=='()' then
		return Arbre[2]
	else
		return Arbre
	end
end

function fCommandes(arg1,arg2,arg3)
	return arg1..','..arg2
end

function fExpressionsXcas(arg1,arg2)
	return string.sub(arg1,1,arg1:len()-1)..string.sub(arg2,2)
end

function fFacteursXcas(arg1)
	return '"'..arg1..'"'
end

--[[ Grammaire Commandes Xcas
local Commandes, ExpressionsXcas, FacteursXcas = V"Commandes", V"ExpressionsXcas", V"FacteursXcas"
local CommandesXcas = P { Commandes,
  Commandes = Cf(ExpressionsXcas * Cg(P(",") * ExpressionsXcas)^0,fCommandes),
  ExpressionsXcas = Cf(FacteursXcas *Cg(FacteursXcas )^0,fExpressionsXcas),
  FacteursXcas = C((1-S'()[]{},')^1+V'ExpressionsXcasParentheses'+V'ExpressionsXcasAccolades'+V'ExpressionsXcasCrochets')/fFacteursXcas,
  ExpressionsXcasParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
  ExpressionsXcasAccolades=P{'{'*((1-S('{}'))+V(1))^0*'}'},
  ExpressionsXcasCrochets=P{'['*((1-S('[]'))+V(1))^0*']'}
}--]]

function Tree2Latex(Arbre)
local op=Arbre[1]
local arg1, arg2 = '',''
if op=='' then return '' end
if (op=='op_binaire') then
	return Tree2Latex(Arbre[3])..TSubstOperateurLaTeX[Arbre[2]]..Tree2Latex(Arbre[4])
elseif (op=='+' or op=='-') then
	return Tree2Latex(Arbre[2])..op..Tree2Latex(Arbre[3])
elseif (op=='*' or op==' ') then
	return Tree2Latex(Arbre[2])..' '..Tree2Latex(Arbre[3])
elseif (op=='×' or op=='**') then
	return Tree2Latex(Arbre[2])..'\\times '..Tree2Latex(Arbre[3])
elseif (op=='..') then
	-- produit scalaire
	return Tree2Latex(Arbre[2])..'\\cdot '..Tree2Latex(Arbre[3])
elseif (op=='//') then
	return Tree2Latex(Arbre[2])..'/'..Tree2Latex(Arbre[3])		
elseif (op=='÷') then
	return Tree2Latex(Arbre[2])..'\\div '..Tree2Latex(Arbre[3])		
elseif (op=='imp*') then
	arg1=Tree2Latex(Arbre[2])
	-- recherche de fonctions cmath
	if arg1==match(C(FonctionsCmath),arg1) then
		return TraitementFonctionsCmath[arg1](Parentheses_inutiles(Arbre[3]))
	else
		return arg1..' '..Tree2Latex(Arbre[3])
	end
elseif (op=='()') then
	return '\\left( '..Tree2Latex(Arbre[2])..'\\right) '
elseif (op=='{}') then
	return '{'..Tree2Latex(Arbre[2])..'}'
elseif (op=='/') then
	return '\\frac{'..Tree2Latex(Parentheses_inutiles(Arbre[2]))..'}{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}'
elseif (op=='^^') then
	return '\\prescript{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}{}{'..Tree2Latex(Arbre[2])..'}{}{}'
elseif (op=='__') then
	return '\\prescript{}{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}{'..Tree2Latex(Arbre[2])..'}{}{}'
elseif (op=='^') then
	arg1=Tree2Latex(Arbre[2])
	if arg1=='\\sin ' or arg1=='\\cos ' or arg1=='\\tan ' or arg1=='\\sh '
		or arg1=='\\ch ' or arg1=='\\th ' or arg1=='\\ln ' or arg1=='\\log 'then 
		if Arbre[3][1]=='imp*' and Arbre[3][3][1]=='()' then
			return arg1..'^{'..Tree2Latex(Parentheses_inutiles(Arbre[3][2]))..'} '..Tree2Latex((Arbre[3][3][2]))
		end
	end
	if Arbre[2][1]=='^' then
		return '{'..arg1..'}^{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}'
	else
		if Arbre[3][1]=='_' then
			return arg1..'^'..Tree2Latex(Parentheses_inutiles(Arbre[3]))
		else
			return arg1..'^{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}'
		end
	end
elseif (op=='_') then
	if Arbre[2][1]=='_' then
		return '{'..Tree2Latex(Arbre[2])..'}_{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}'
	else
		return Tree2Latex(Arbre[2])..'_{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}'	
	end
elseif (op=='text') then
	return '\\textrm{'..Arbre[2]..'}'
elseif (op=='no_eval') then
	if Arbre[2]=='xcas' then
		if Arbre[3]=='restart' then
			return Giac("restart;",'""',"false")
		else
			return Giac(XCAS_var2latex,Arbre[3],"true")
		end
	elseif Arbre[2]=='TVar' then
		return Giac(XCAS_Tableaux,'TVar('..Arbre[3]..')',"false")
	elseif Arbre[2]=='TSig' then
		return Giac(XCAS_Tableaux,'TSig('..Arbre[3]..')',"false")	
	elseif Arbre[2]=='TVarP' then
		return Giac(XCAS_Tableaux,'TVarP('..Arbre[3]..')',"false")
	elseif Arbre[2]=='TVal' then
		return Giac(XCAS_Tableaux,'TVal('..Arbre[3]..')',"false")
	elseif Arbre[2]=='sysl' then
		return Giac(XCAS_Systemes,'sysl('..Arbre[3]..')',"false")
	elseif Arbre[2]=='GaussSysl' then
		return Giac(XCAS_Systemes,'GaussSysl('..Arbre[3]..')',"false")		
	elseif Arbre[2]=='GaussRang' then
		return Giac(XCAS_Systemes,'GaussRang('..Arbre[3]..')',"false")	
	elseif Arbre[2]=='GaussInv' then
		return Giac(XCAS_Systemes,'GaussInv('..Arbre[3]..')',"false")
	elseif Arbre[2]=='tikzPlot' then
		return tikzPlot(Arbre[3])
	elseif Arbre[2]=='pgfPlot3' then
		return pgfPlot3(Arbre[3])
	elseif Arbre[2]=='tikzWindow' then
		return tikzWindow(Arbre[3])
	elseif Arbre[2]=='tikzGrid' then
		return tikzGrid(Arbre[3])
	elseif Arbre[2]=='tikzAxeX' then
		return tikzAxeX(Arbre[3])
	elseif Arbre[2]=='tikzAxeY' then
		return tikzAxeY(Arbre[3])
	elseif Arbre[2]=='tikzPoint' then
		return tikzPoint(Arbre[3])
	elseif Arbre[2]=='codeLua' then
		return codeLua(Arbre[3])
	elseif Arbre[2]=='tikzTangent' then
		return tikzTangent(Arbre[3])		
	else	
		return Arbre[2]..'("'..Arbre[3]..'")'
	end
elseif (op=='latex') then
	return Arbre[2]	
elseif (op=='liste ,' or op=='liste ;') then
	s=Tree2Latex(Arbre[2])
	sep='\\mathpunct{\\mspace{3 mu}'..string.sub(op, -1)..'}'
	for key,value in next,Arbre,2 do s=s..sep..Tree2Latex(value) end
	return s
elseif (op=='[' or op==']') then
	return '\\left'..Arbre[1]..' '..Tree2Latex(Arbre[2])..' \\right'..Arbre[3]..' '
elseif (op=='⟦⟧') then
	return  '\\llbracket '..Tree2Latex(Arbre[2])..' \\rrbracket '
elseif (string.sub(op,1,5)=='signe') then
	return string.sub(op,7)..Tree2Latex(Arbre[2])
elseif (op=='raccourci') then
	return TSubstRaccourciLaTeX[Arbre[2]]
else
	-- Repérer les fonctions usuelles
	return match(Cs(TSubstCmathLaTeX^1),op)
end
end


function Tree2TW(Arbre)
local op=Arbre[1]
local arg1, arg2 = '',''
if op=='' then return '' end
if (op=='op_binaire') then
	arg2=TSubstOperateurTW[Arbre[2]]
	if arg2==nil then arg2=Arbre[2] end
	return Tree2TW(Arbre[3])..arg2..Tree2TW(Arbre[4])
elseif (op=='×' or op=='**') then
	return Tree2TW(Arbre[2])..'×'..Tree2TW(Arbre[3])
elseif (op=='÷') then
	return Tree2TW(Arbre[2])..'÷'..Tree2TW(Arbre[3])		
elseif (op=='//') then
	return Tree2TW(Arbre[2])..'//'..Tree2TW(Arbre[3])		
elseif (op=='imp*') then
	if Arbre[2][1]=='iiint' then Arbre[2]={'∭'} end
	if Arbre[2][1]=='iint' then Arbre[2]={'∬'} end
	if Arbre[2][1]=='int' then Arbre[2]={'∫'} end
	if Arbre[2][1]=='rac' then Arbre[2]={'√'} end
	return Tree2TW(Arbre[2])..Tree2TW(Arbre[3])
elseif (op=='()') then
	return '('..Tree2TW(Arbre[2])..')'
elseif (op=='{}') then
	return '{'..Tree2TW(Arbre[2])..'}'
elseif (op=='^^' or op=='__' or op=='^' or op=='_' or op=='/' or op=='..' or op=='+' or op=='-' or op=='*' or op==' ') then
	return Tree2TW(Arbre[2])..op..Tree2TW((Arbre[3]))
elseif (op=='text') then
	return '"'..Arbre[2]..'"'
elseif (op=='no_eval') then
		return Arbre[2]..'('..Arbre[3]..')'
elseif (op=='latex') then
	return Arbre[2]	
elseif (op=='liste ,' or op=='liste ;') then
	s=Tree2TW(Arbre[2])
	sep=string.sub(op, -1)
	for key,value in next,Arbre,2 do s=s..sep..Tree2TW(value) end
	return s
elseif (op=='[' or op==']') then
	return Arbre[1]..Tree2TW(Arbre[2])..Arbre[3]
elseif (op=='⟦⟧') then
	return  '⟦'..Tree2TW(Arbre[2])..'⟧'
elseif (string.sub(op,1,5)=='signe') then
	return string.sub(op,7)..Tree2TW(Arbre[2])
elseif (op=='raccourci') then
	arg2=TSubstRaccourciTW[Arbre[2]]
	if arg2==nil then arg2=Arbre[2] end
	return arg2
else
	return match(Cs(TSubstCmathTW^1),op)
end
end

function GiacOld(programme,instruction,latex)
-- exécute le programme sans conserver le retour
-- puis exécute l'instruction en renvoyant le résultat
-- conversion en latex selon le booléen latex (pas de conversion pour les tableaux de variations/signes)
local repTMP, giacIn, giacSav, giacOut, commande
if QuelOs()=='linux' then
	repTMP=RepertoireTMP()
	giacIn=repTMP..'giac.in'
	giacSav=repTMP..'giac.sav'
	giacOut=repTMP..'giac.out'
	commande='icas '..giacIn
else -- c'est windows, à compléter pour identifier un Mac
	giacIn='giac.in'
	giacSav='giac.sav'
	giacOut='giac.out'
	commande='\\xcas\\bash.exe -c "export LANG=fr_FR.UTF-8 ; /xcas/icas.exe '..giacIn..'"'
end
local prg=[[
unarchive("]]..giacSav..[["):;
]]..programme..[[
purge(Resultat);
som:=sommet(quote(]]..instruction..[[));
if(som=='sto' or som=='supposons'){
  ]]..instruction..[[;
  Resultat:='""';} else {
  //print("Instruction:"+"]]..instruction..[[");
  Resultat:=(]]..instruction..[[)};
  //print(Resultat);
if(Resultat=='Resultat'){
  Resultat:="Erreur Xcas"};
Sortie:=fopen("]]..giacOut..[[");
if(]]..latex..[[){
  fprint(Sortie,Unquoted,var2latex(Resultat));
} else {
  fprint(Sortie,Unquoted,Resultat);
};
fclose(Sortie);
archive("]]..giacSav..[["):;
]]
local f,err = io.open(giacIn,"w")
if not f then return err end
f:write(prg)
f:close()
os.execute(commande)
io.input(giacOut)
return(io.read("*all"))
end

function Giac(programme, instruction, latex)
    local commande
    
    -- Construction du code à envoyer à Giac
    -- On n'a plus besoin d'archiver/désarchiver ou d'utiliser fopen/fclose
    local prg = programme .. "\n"
    prg = prg .. "purge(Resultat);\n"
    prg = prg .. "som:=sommet(quote(" .. instruction .. "));\n"
    prg = prg .. "if(som=='sto' or som=='supposons'){\n"
    prg = prg .. "  " .. instruction .. ";\n"
    prg = prg .. "  Resultat:='\"\"';} else {\n"
    prg = prg .. "  Resultat:=(" .. instruction .. ")};\n"
    prg = prg .. "if(Resultat=='Resultat'){\n"
    prg = prg .. "  Resultat:=\"Erreur Xcas\"};\n"
    
    -- Au lieu d'écrire dans un fichier, on affiche le résultat dans le terminal (stdout)
    if latex then
        prg = prg .. "print(Unquoted,var2latex(Resultat));\n"
    else
        prg = prg .. "print(Unquoted,Resultat);\n"
    end
    
    prg = instruction
    
    -- Détermination de la commande OS
    if QuelOs() == 'linux' then
        -- Sous Linux, on demande à icas de lire le code directement depuis l'argument en ligne de commande
        -- (L'option -e ou le pipe standard permet souvent d'exécuter un script à la volée)
        -- Si 'icas' accepte l'entrée standard, on peut utiliser echo
        commande = "echo '" .. string.gsub(prg, "'", "'\\''") .. "' | icas"
    else 
        -- Sous Windows
        -- On passe la chaîne de caractères à icas via un pipe ou une commande echo interprétée par bash
        -- Attention à bien échapper les guillemets et apostrophes pour Windows/Bash
        commande = '\\xcas\\bash.exe -c "export LANG=fr_FR.UTF-8 ; echo \'' .. string.gsub(prg, "'", "'\\''") .. '\' | /xcas/icas.exe"'
    end

    -- Exécution de la commande et récupération de la sortie standard
    local handle = io.popen(commande)
    if not handle then 
        return "Erreur d'exécution de la commande Giac" 
    end
    
    local resultat = handle:read("*a") -- Lit tout ce que Giac a "print"
    handle:close()
    
    -- Nettoyage des éventuels sauts de ligne finaux renvoyés par stdout
    resultat = string.gsub(resultat, "^%s*(.-)%s*$", "%1")
    
    return resultat
end

function RepertoireTMP()
-- renvoie le chemin vers un répertoire temporaire accessible en lecture/écriture
local tmpFile=os.tmpname()
local tmpDir=tmpFile
local i=-1
while(string.sub(tmpDir,i,i)~='/') do
	i=i-1
end
tmpDir=(string.sub(tmpDir,1,string.len(tmpDir)+i+1))
os.remove(tmpFile)
return tmpDir
end

function QuelOs()
local conf=package.config
if string.sub(conf,1,1)=='/' then 
	return 'linux'
else
	return 'win'
end
end


-- Pour debug --
function taille(t)
	if type(t)=='table' then
		return taille(t[1])
	else
		return string.len(t)
	end
end

function AfficheArbre(t,n)    
   for key,value in pairs(t) do
	   if type(t[key])=='table' then
			write(" {")
			AfficheArbre(t[key],n+taille(t[key][1])+1)
			write("}\n")
			for i=1,n+1 do write (" ") end
	   else 
			write(""..value.." ")
			n=n+1
	   end
   end
end

-- Grammaire Cmath
local Argument, Membre, Expression, Term, Facteur, Exposant, Indice, MultImplicite, Formule, Formule_signee = V"Argument", V"Membre", V"Expression", V"Term", V"Facteur", V"Exposant", V"Indice", V"MultImplicite", V"Formule", V"Formule_signee"
Cmath2Tree = P { Argument,
  Argument = Cf((Membre * Cg(SepListe * Membre^0)^0)+(Cc('')*Cg(SepListe*Membre)^1)+(Cc('')*Cg(SepListe*Membre^0)^1), fListe),
  Membre = Cf(Expression * Cg(Operateur * Expression)^0, fOperateur),
  Expression = Cf(Term * Cg(TermOp * Term)^0,fTerm),
  Term = Cf(Facteur * Cg(FactorOp * Facteur)^0,fFactor),
  Facteur = Cf(Exposant * Cg(DiviseOp * Exposant)^0,fDivise),
  Exposant = Cf(Indice * Cg(PuissanceOp * Indice)^0,fPuissance),
  Indice = Cf(MultImplicite * Cg(IndiceOp * MultImplicite)^0,fIndice),
  MultImplicite= Cf((Formule_signee+Formule-Fonction_sans_eval) * Cg(Formule-Formule_signee)^0 ,fMultImplicite)+(C(Fonction_sans_eval)*Parenthese_Ouverte*C((V'ExpressionSansEval')^1)*Parenthese_Fermee)/fFonction_sans_eval,
  Formule_signee=(C(S('+-'))*Cg(Formule))/fFormule_signee,
  Formule=V'texte' + V'sans_texte' + V'parentheses' + V'accolades' + V'intervalle_entiers' + V'crochets',
  texte = Guillemet*C((1-Guillemet)^0)/fTexte*Guillemet,
  ExpressionSansEvalParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
  ExpressionSansEval=CaractereSansParentheses^1+V'ExpressionSansEvalParentheses',
  sans_texte=((Nombre+Mot)/fSans_texte+Op_LaTeX/fOp_LaTeX+Raccourci/fRaccourcis),
  parentheses=Parenthese_Ouverte*(Argument/fParentheses)*Parenthese_Fermee,
  accolades=Accolade_Ouverte*(Argument/fAccolades)*Accolade_Fermee,
  intervalle_entiers=(Intervalle_Entier_Ouvert*Argument*Intervalle_Entier_Ferme)/fIntervalle_Entier,
  crochets=(Crochet*Argument*Crochet)/fCrochets
}

-- Fonction appelée depuis LuaTeX
function Cmath2LaTeX(formule)
	-- Construction de l'arbre de la formule
	Arbre=match(Cmath2Tree,formule)
	if not Arbre then 
		return("Erreur de syntaxe : ".. formule)
	else
		-- Construction de la formule
		Formule=Tree2Latex(Arbre)
		-- tex.print n'accepte qu'une seule ligne
		Formule=string.gsub(Formule, "\n", " ")
		return(Formule)
	end
end

-- Fonction appelée depuis TexWorks (F9 et Shift+F9)
function Cmath2TW(formule)
	-- Construction de l'arbre de la formule
	Arbre=match(Cmath2Tree,formule)
	if not Arbre then 
		return("Erreur de syntaxe : ".. formule)
	else
		-- Construction de la formule
		return(Tree2TW(Arbre))
	end
end

-- Fonction appelée depuis TexWorks (Ctrl+F9 et Shift+Ctrl+F9)
function Cmath2LaTeXinTW(formule)
	-- Construction de l'arbre de la formule
	Arbre=match(Cmath2Tree,formule)
	if not Arbre then 
		return("Erreur de syntaxe : ".. formule)
	else
		-- Construction de la formule
		Formule=Tree2Latex(Arbre)
		return(Formule)
	end
end

XCAS_var2latex=[[
var2latex(variable):={
// supprime les mathrm, les cdot et évite la perte des indices
local s;
local j;
if (type(variable)==string){
  return("\\text{"&variable&"}")}
else {
  s:=latex(variable);
  for(j:=inString(s,"\\_");j<>-1;j:=inString(s,"\\_")){
    s:=left(s,j)+"_"+mid(s,j+2);
  }
  for(j:=inString(s,"\\mathrm");j<>-1;j:=inString(s,"\\mathrm")){
    s:=left(s,j)+mid(s,j+7);
  }
  for(j:=inString(s,"\\cdot");j<>-1;j:=inString(s,"\\cdot")){
    s:=left(s,j)+mid(s,j+5);
  }
  return(s);
}
}:;
]]

XCAS_Systemes=XCAS_var2latex..[[
sysl(arguments):={
// systeme : vecteur ou matrice du système.
// Exemple : [x+y=0,y+z=0,x+z=0] ou [ [1,1,0,0],[0,1,1,0],[1,0,1,0] ]
// variables : variables du système. Exemple : [x,y,z]
// operations (facultatif) : matrice des opérations élémentaires à afficher.
local systeme; // vecteur contenant les lignes du système
local variables; // vecteur contenant les variables
local s:="\\left\\{\n\\begin{alignedat}{";
local nb_var;
local nb_lig;
local n,p;
local operations,ligne,L1,L2,coef1,coef2;
if (size(arguments)==3){
  operations:=arguments[2];
  if(operations==[]){
    L1:=-1;//pas d'opérations à afficher
  }else{
    ligne:=0;
    L1:=operations[ligne][0];
    L2:=operations[ligne][1];
    coef1:=operations[ligne][2];
    coef2:=operations[ligne][3];
  }
} else {
  ligne:=-1;//pas de résolution
  L1:=-1;//pas d'opérations à afficher
}
systeme:=arguments[0];
if(type(dim(systeme))==DOM_INT){ // transformer le vecteur en matrice
  systeme:=syst2mat(arguments[0],arguments[1]);
}
variables:=arguments[1];
nb_var:=ncols(systeme)-1;
nb_lig:=nrows(systeme);
if(ligne==-1){
  s:=s+string(nb_var+1)+"}\n";
} else {
  s:=s+string(nb_var+2)+"}\n";
}
for(n:=0;n<nb_lig;n++){
  local premier_terme:=vrai;
  for(p:=0;p<nb_var;p++){
    local coef:=systeme[n][p];
    local v,sig,scoef;
    v:=vCoef(coef);
    sig:=v[0];scoef:=v[1];
    if(coef==0){
      if(ligne<>-1 and n==p and premier_terme==vrai){
        if(p==0){
          s:=s+" 0"+var2latex(variables[p])+" & ";
        } else {
          s:=s+"\\phantom{~+~}& 0"+var2latex(variables[p])+" & ";
        }
        premier_terme:=faux; 
      }else{
        if(p==nb_var-1 and premier_terme==vrai){
          if(p==0){
            s:=s+"0 & ";            
          }else{
            s:=s+" & 0 & ";
          }
        } else {
          if(p==0){
            s:=s+" & ";
          } else {
            s:=s+" & & ";
          }
        }
      }
    } else {
      if(p==0){ //terme de la première colonne ou premier terme non nul 
        s:=s+ifte(sig=="-","-","")+scoef+" "+var2latex(variables[p])+" & ";
        premier_terme:=faux;
      } else {
        if(premier_terme==vrai){
          s:=s+"\\phantom{~+~}&"+ifte(sig=="-","-","")+scoef+" "+var2latex(variables[p])+" & ";
          premier_terme:=faux;
        } else {
          s:=s+"~"+sig+"~ & "+scoef+" "+var2latex(variables[p])+" & ";
        }
      }
    }
  }
  s:=s+"~=~ & "+var2latex(-systeme[n][nb_var]);
  if(ligne<>-1){
    if(n==L1-1){
      // afficher l'opération
      local v,sig1,scoef1,sig2,scoef2;
      v:=vCoef(coef1);sig1:=v[0];scoef1:=v[1];
      v:=vCoef(coef2);sig2:=v[0];scoef2:=v[1];
      s:=s+" & \\qquad L_"+string(L1)+" \\longleftarrow "+ifte(sig1=="+","","-")+scoef1+" L_"+string(L1)+sig2+scoef2+" L_"+string(L2);
      if(nrows(operations)>ligne+1){
        ligne++;
        L1:=operations[ligne][0];
        L2:=operations[ligne][1];
        coef1:=operations[ligne][2];
        coef2:=operations[ligne][3];
      } else {
        //ligne:=-1;
        L1:=-1;
      }
    } else {
      // pas d'opération pour cette ligne
      s:=s+" & ";
    }
  } 
  s:=s+" \\\\\n"; 
}
s:=s+"\\end{alignedat}\n\\right.\n";
return(s);
}:;

vCoef(coef):={
// renvoie un vecteur contenant le signe et le code latex du coef en n'affichant pas 1
local v:=["",""];
if(estNombre(coef)){
  if(coef>=0){
    v[1]:=latex(coef);
    v[0]:="+";
  } else {
    v[1]:=latex(abs(coef));
    v[0]:="-";
  }
  if(abs(coef)==1){
    v[1]:="";
  }
} else {
  if(sommet(-coef)=='id'){
    v[0]:="-";
    v[1]:=var2latex(-coef);
  } else {
    if(sommet(coef)=='id'){
      v[0]:="+";
      v[1]:=var2latex(coef);
    } else {
      if(sommet(coef)=='+' or sommet(coef)=='-'){ // mettre des parenthèses
        v[0]:="+";
        v[1]:="\\left("+var2latex(coef)+"\\right)";
      } else {
        v[0]:="+";
        v[1]:=var2latex(coef);
      }
    }
  }
}
return(v);
}:;

liste_param(solutions,variables):={
local l:=size(variables);
local j;
local param:=[];
for(j:=0;j<l;j++){
  if(solutions[j]==variables[j]){
    param:=append(param,variables[j]);
  }
}
return(param);
}:;

cherchePivot(systeme,n,p,nb_lig,direction):={
// cherche un pivot non nul dans la matrice systeme ayant nb_lig lignes à partir de la ligne n dans la colonne p
// direction : +1 vers le bas, -1 vers le haut
local j, coef;
j:=n;
while((j<nb_lig-1 and direction==1) or (j>0 and direction==-1) and systeme[j][p]==0){
  j:=j+direction;
}
if((j==nb_lig-1 and direction==1) or (j==0 and direction==-1) and systeme[j][p]==0){ // tous les coef nuls
  return(-1);
} else {
  coef:=systeme[j][p];
  if(estNombre(coef) or (j==nb_lig-1 and direction==1) or (j==0 and direction==-1)){ // pas de problème : nombre ou dernière ligne ou 1ère ligne
    return(j);
  } else { // chercher si possible un pivot avec le moins de contraintes (le moins de variables)
    local nb_vars,meilleur_ligne,k;
    nb_vars:=size(listeVariables(coef));
    meilleur_ligne:=[j,nb_vars]; // nb_vars=[ligne,nb de variables]
    for(k:=j+direction;(k<=nb_lig-1 and direction==1) or (k>=0  and direction==-1);k:=k+direction){
      if(systeme[k][p]<>0){
        nb_vars:=size(listeVariables(systeme[k][p]));
        if(nb_vars<meilleur_ligne[1]){
          meilleur_ligne:=[k,nb_vars];
        }
      }      
    }
    return(meilleur_ligne[0]);
  }
}
}:;

estNombre(x):={
//local num:=evalf(x);
local t:=type(evalf(x));
if(t==DOM_FLOAT or t==DOM_COMPLEX){
  return(vrai);
} else {
  return(faux);
}
}:;

listeVariables(s_expression):={
  // renvoie un vecteur contenant la liste des variables de l'expression
  local s:=sommet(s_expression);
  if(s=='id'){
    if(estNombre(s_expression)){
      return([]);
    } else {
      return([s_expression]);
    }
  } else {
    local v:=[];
    local n:=size(s_expression);    
    local k,l; 
    for(k:=0;k<n;k++){
        l:=listeVariables(s_expression[k+1]);
        v:=concat(v,l);        
    }
    v:=supprime_doublons(v);
    return(v);
  }   
}:;


supprime_doublons(liste):={
if (size(liste)>0){
  return(concat(liste[0],supprime_doublons(remove(liste[0],liste))));
} else {
  return([]); 
}
}:;

sysld(arguments):={
// renvoie sysl en mode display
	return "\\["+sysl(arguments)+"\\]\n";
}:;

GaussPivotSysl(systeme,msysteme,variables,fraction,n,p,pivot_nul):={
// systeme : système linéaire au format vecteur
// msysteme : système linéaire au format matrice
// variables : variables du système au format vecteur
// fraction : booléen fraction : vrai (véritable pivot de Gauss Li<-Li+aLj), faux (moins de fractions Li<-aLi+bLj)
// n,p : n°ligne,n°colonne. Point de départ du pivot. Suppose que la méthode du pivot a été utilisé jusqu'à ce point
// pivot_nul : matrice qui indique quels cas de pivot nul ont été traités
local nb_var,nb_lig;
local s:="";
local operations,rang,j,k;
local msys_subst,sys_subst;
local coef,coef1,coef2,diviseur;
local lv,lz,nb_sol;
nb_var:=ncols(msysteme)-1;
nb_lig:=nrows(msysteme);
if(p>=nb_var or n>=nb_lig){ // pivotage terminé, afficher les solutions
  return(GaussAffSolSysl(systeme,msysteme,variables));
} else { // pivoter
  operations:=[];
  afficher("Ligne : "+string(n)+" Colonne : "+string(p));
  k:=cherchePivot(msysteme,n,p,nb_lig,1);
  if(k==-1){ // la colonne ne contient pas la variable
    if(n<nb_lig-1){
      s:=s+"La variable $"+var2latex(variables[p])+"$ est absente à partir de la ligne "+string(n+2)+". Il n'y a donc rien à faire pour l'éliminer.\n\n";
    }
    afficher("Rien à faire pour la colonne "+string(p));
    p++;
    s:=s+GaussPivotSysl(systeme,msysteme,variables,fraction,n,p,pivot_nul);
  } else {
    if(k<>n){ // il faut permuter
      if(estNombre(msysteme[n][p])==faux){
        s:=s+"On échange la ligne "+string(n+1)+" avec la ligne "+string(k+1)+" pour obtenir un pivot toujours non nul :\n";
      } else {
        s:=s+"On échange la ligne "+string(n+1)+" avec la ligne "+string(k+1)+" pour obtenir un pivot non nul :\n";
      }
      msysteme:=rowSwap(msysteme,n,k);
      s:=s+sysld(msysteme,variables);
      afficher ("Echange lignes "+string(n)+" et "+string(k));
      afficher(msysteme);
    }
    coef1:=msysteme[n][p];
    if(not(estNombre(coef1))) {
      // chercher les valeurs qui annulent le pivot
      lv:=listeVariables(coef1); // vecteurs des variables
      lz:=solve(coef1=0,lv[0]); // zéros du coef pour la première variable
      nb_sol:=size(lz);
      if(nb_sol>0 and coefVautZero(pivot_nul,lv[0],lz,nb_sol)==vrai){ // disjonction des cas si au moins une valeur qui annule le pivot
        s:=s+"Le pivot $"+var2latex(coef1)+"$ peut s'annuler. On raisonne donc par disjonction des cas.\n\\begin{itemize}";
        for(j:=0;j<nb_sol;j++){
          if(not(contains(pivot_nul,[lv[0],lz[j] ]))){ //cette racine n'a pas été étudiée avant, le pivot peut s'annuler
            // substituer et résoudre ce cas 
            s:=s+"\n\\item\n"; 
            msys_subst:=simplifier(subst(msysteme,lv[0]=lz[j]));
            sys_subst:=simplifier(subst(systeme,lv[0]=lz[j]));
            s:=s+"Si $"+var2latex(lv[0])+"="+var2latex(lz[j])+"$, alors on est amené à résoudre le système :\n";
            s:=s+sysld(msys_subst,variables,[]);
            //s:=s+"On élimine la variable $"+var2latex(variables[p])+"$ à partir de la ligne "+string(n+2)+" :\\\\\n";
            if(pivot_nul==[]){
              pivot_nul:=[ [lv[0],lz[j] ] ]
            } else {
              pivot_nul:=append(pivot_nul,[lv[0],lz[j] ]);
            }
            s:=s+GaussPivotSysl(sys_subst,msys_subst,variables,fraction,n,p,pivot_nul);
          }
        }
        // dans les autres cas
        s:=s+"\n\\item\n";
        if(nb_sol==1){
          s:=s+"Si $"+var2latex(lv[0])+"\\neq "+var2latex(lz[0])+"$";   
        } else {
          s:=s+"Si $"+var2latex(lv[0])+"\\notin \\left\\{";
          for(j:=0;j<nb_sol-1;j++){
            s:=s+var2latex(lz[j])+"\\mathpunct{;}";
          }
          s:=s+var2latex(lz[nb_sol-1])+"\\right\\}$";
        }        
        s:=s+", alors le pivot est non nul et on continue la résolution.\n\n";       
        s:=s+GaussPivotSysl(systeme,msysteme,variables,fraction,n,p,pivot_nul);
        s:=s+"\n\\end{itemize}\n";
        return(s);
      }
    }    
    // le pivot est non nul
    for(k:=n+1;k<nb_lig;k++){
      coef2:=-msysteme[k][p];
      coef:=simplifier(coef2/coef1);
      if(coef<>0){
        diviseur:=gcd(coef1,coef2);
        afficher("coefs :",coef1,coef2,diviseur);
        msysteme:=simplifier(mRowAdd(coef,msysteme,n,k));
        if(fraction==faux){
          msysteme:=simplifier(mRow(coef1/diviseur,msysteme,k));
          operations:=append(operations,[k+1,n+1,simplifier(coef1/diviseur),simplifier(coef2/diviseur)]);
        } else {
          operations:=append(operations,[k+1,n+1,1,coef]);
        }        
        afficher("L"+string(k+1)+" reçoit "+"L"+string(k+1)+"+"+string(coef)+"*L"+string(n+1));
        afficher(msysteme);
      }
    }
    if(operations<>[]){
      s:=s+"On élimine la variable $"+var2latex(variables[p])+"$ à partir de la ligne "+string(n+2)+" :\n\n";
      s:=s+sysld(msysteme,variables,operations);
    } else {
      if(n<nb_lig-1){
        s:=s+"La variable $"+var2latex(variables[p])+"$ est déjà éliminée à partir de la ligne "+string(n+2)+".\n";
      }
    }
    n++;p++;
    s:=s+GaussPivotSysl(systeme,msysteme,variables,fraction,n,p,pivot_nul);
  }
}
}:;

coefVautZero(pivot_nul,variable,liste_zeros,nb_sol):={
local k;
for(k:=0;k<nb_sol;k++){
  if(not(contains(pivot_nul,[variable,liste_zeros[k] ]))){
    return(vrai);
  }  
}
return(faux);  
}:;

GaussSysl(arguments):={
// arg1 : système linéaire au format [x+y=0,x-y=0]
// arg2 : variables du système au format [x,y]
// arg3 : booléen fraction (facultatif, faux par défaut) : vrai (véritable pivot de Gauss Li<-Li+aLj), faux (moins de fractions Li<-aLi+bLj)
local systeme; // système linéaire au format [x+y=0,x-y=0]
local msysteme; // matrice décrivant le système 
local variables; // vecteur contenant les variables
local fraction;
local s;
systeme:=arguments[0];
variables:=arguments[1];
msysteme:=syst2mat(systeme,variables);
if (size(arguments)==3){
  fraction:=arguments[2];
} else {
  fraction:=faux;
}
s:="Par la méthode du pivot de Gauss, on résout le système :\n"+sysld(systeme,variables);
// pivoter à partir de (0,0)
s:=s+GaussPivotSysl(systeme,msysteme,variables,fraction,0,0,[]);
// affichage des solutions
// s:=s+GaussAffSolSysl(systeme,variables);
return(s);
}:;

GaussAffSolSysl(systeme,msysteme,variables):={
local rang;
local solutions;
local parametres;
local nb_param;
local nb_var;
local nb_lig;
local p;
local s:="";
solutions:=linsolve(systeme,variables);
if(solutions==[]){
  s:=s+"Ce système n'a pas de solution.\n";
} else {
  s:=s+"On obtient alors :\n";
  nb_var:=ncols(msysteme)-1;
  nb_lig:=nrows(msysteme);
  s:=s+"\\[\\left\\{\n\\begin{alignedat}{2}";
  for(p:=0;p<nb_var;p++){
    s:=s+"\n"+var2latex(variables[p])+" && ~=~ & "+var2latex(solutions[p])+"\\\\ ";    
  }
  s:=s+"\n\\end{alignedat}\n\\right.\\]\n";
  rang:=rank(tran(suppress(tran(msysteme),ncols(msysteme)-1))); // calcule le rang de la matrice des coef des inconnues
  if(rang==nb_var){
    s:=s+"La solution de ce système est : $\\left(";
    for(p:=0;p<nb_var;p++){
      s:=s+var2latex(solutions[p])+ifte(p<nb_var-1,"\\mathpunct{,}","\\right)$.");
    }  
  } else {  
    parametres:=liste_param(solutions,variables);
    s:=s+"L'ensemble des solutions de ce système est : $\\left\\{\\left(";
    for(p:=0;p<nb_var;p++){
      s:=s+var2latex(solutions[p])+ifte(p<nb_var-1,"\\mathpunct{,}","\\right)\\mathpunct{,}");
    }
    nb_param:=size(parametres);
    if(nb_param==1){
      s:=s+var2latex(parametres[0])+"\\in\\mathbb{R}\\right\\}$.";
    } else {
      s:=s+"(";  
      for(p:=0;p<nb_param;p++){
        s:=s+var2latex(parametres[p])+ifte(p<nb_param-1,"\\mathpunct{,}",")\\in\\mathbb{R}^{"+string(nb_param)+"}\\right\\}$.\n");
      }
    }
  }
}
return(s);  
}:;


////////////////////////////////////////////////////////////////////////////////////

affMatrice(matrice,operations):={
// matrice 
// Exemple : [ [1,1,0,0],[0,1,1,0],[1,0,1,0] ]
// operations (facultatif) : matrice des opérations élémentaires à afficher.  
local s:="\\[\n\\begin{blockarray}{";
local nb_col;
local nb_lig;
local n,p;
local ligne,L1,L2,coef1,coef2;
if(operations==[]){
  ligne:=-1;//pas de résolution
  L1:=-1;//pas d'opérations à afficher
}else{
  ligne:=0;
  L1:=operations[ligne][0];
  L2:=operations[ligne][1];
  coef1:=operations[ligne][2];
  coef2:=operations[ligne][3];
}
//afficher(matrice);
nb_col:=ncols(matrice);
nb_lig:=nrows(matrice);
s:=s+"(*{"+string(nb_col)+"}{c})l}\n";
for(n:=0;n<nb_lig;n++){
  local coef;
  for(p:=0;p<nb_col;p++){
    coef:=matrice[n][p];
    s:=s+var2latex(coef)+" & ";
  }
  if(ligne<>-1){
    if(n==L1-1){
      // afficher l'opération
      local v,sig1,scoef1,sig2,scoef2;
      v:=vCoef(coef1);sig1:=v[0];scoef1:=v[1];
      v:=vCoef(coef2);sig2:=v[0];scoef2:=v[1];
      s:=s+"L_"+string(L1)+" \\longleftarrow "+ifte(sig1=="+","","-")+scoef1+" L_"+string(L1)+sig2+scoef2+" L_"+string(L2);
      if(nrows(operations)>ligne+1){
        ligne++;
        L1:=operations[ligne][0];
        L2:=operations[ligne][1];
        coef1:=operations[ligne][2];
        coef2:=operations[ligne][3];
      } else {
        //ligne:=-1;
        L1:=-1;
      }
    } else {
      // pas d'opération pour cette ligne
      s:=s+" ";
    }
  } 
  s:=s+" \\\\\n"; 
}
s:=s+"\\end{blockarray}\n\\]\n";
return(s);
}:;

cherchePivotRang(matrice,n,p,nb_lig,nb_col):={
// cherche un pivot non nul dans la matrice à partir de la ligne n et de la colonne p
// renvoie [ligne,-1]  ou [-1,colonne] ou [-1,-1] indiquant la ligne ou la colonne à permuter
local j,k,coef;
j:=cherchePivot(matrice,n,p,nb_lig,1); // chercher le meilleur pivot dans la colonne p
if(j==-1){ //chercher un pivot numerique dans la ligne n
  k:=cherchePivot(tran(matrice),p,n,nb_col,1);
  if(k==-1){ // tous les coef nuls ou dernière ligne de la matrice (pas besoin de pivoter)
    return([-1,-1]);
  } else {
    return([-1,k]);
  }  
} else {
  coef:=matrice[j][p];
  if(estNombre(coef)){ // le pivot ne s'annulera pas
    return([j,-1]);
  } else { // le pivot est un paramètre, voir si on peut trouver du numérique dans la ligne n
    k:=cherchePivot(tran(matrice),p,n,nb_col,1);
    coef:=matrice[n][k];
    if(estNombre(coef)){ // c'est mieux 
      return([-1,k]);
    } else { // c'est pareil
      return([j,-1]);
    }
  }
}
}:;

GaussPivotRang(matrice,n,p,pivot_nul,rang):={
local nb_col,nb_lig;
local s:="";
local operations;
local v,j,k,coef,coef1,coef2,diviseur,lv,lz,nb_sol,matrice_subst;
nb_col:=ncols(matrice);
nb_lig:=nrows(matrice);
if((p>=nb_col) or (n>=nb_lig)){
  return("Le rang de cette matrice vaut "+string(rang)+".\n");
} else {  
  operations:=[];
  afficher("Ligne : "+string(n)+" Colonne : "+string(p));  
  v:=cherchePivotRang(matrice,n,p,nb_lig,nb_col);
  if(v==[-1,-1]){ // tous les coef sont nuls
    //s:=s+"Le pivot de la ligne "+string(n+1)+", colonne "+string(p+1)+" est nul.\\\\\n";
    p++;n++;
    s:=s+GaussPivotRang(matrice,n,p,pivot_nul,rang);
  } else {
    j:=v[0];k:=v[1];
    if(j<>n and k<>p and n<nb_lig-1){ // il faut permuter
      if(j>-1){ //permuter deux lignes
        if(estNombre(matrice[n][p])==faux){
          s:=s+"On échange la ligne "+string(n+1)+" avec la ligne "+string(j+1)+" pour obtenir un pivot toujours non nul :\n";
        } else {
          s:=s+"On échange la ligne "+string(n+1)+" avec la ligne "+string(j+1)+" pour obtenir un pivot non nul :\n";
        }
        matrice:=rowSwap(matrice,n,j);
        s:=s+affMatrice(matrice,[]);
        afficher ("Echange lignes "+string(n)+" et "+string(j));
        afficher(matrice);
      } else { // permuter deux colonnes
        if(estNombre(matrice[n][p])==faux){
          s:=s+"On échange la colonne "+string(p+1)+" avec la ligne "+string(k+1)+" pour obtenir un pivot toujours non nul :\n";
        } else {
          s:=s+"On échange la ligne "+string(p+1)+" avec la ligne "+string(k+1)+" pour obtenir un pivot non nul :\n";
        }
        matrice:=colSwap(matrice,p,k);
        s:=s+affMatrice(matrice,[]);
        afficher ("Echange colonnes "+string(p)+" et "+string(k));
        afficher(matrice);
      } 
    }  
    coef1:=matrice[n][p];
    if(not(estNombre(coef1))) {
      // chercher les valeurs qui annulent le pivot
      lv:=listeVariables(coef1); // vecteurs des variables
      lz:=solve(coef1=0,lv[0]); // zéros du coef pour la première variable
      nb_sol:=size(lz);
      if(nb_sol>0 and coefVautZero(pivot_nul,lv[0],lz,nb_sol)==vrai){ // disjonction des cas si au moins une valeur qui annule le pivot
        s:=s+ifte((n<nb_lig-1)and(p<nb_col-1),"Le pivot ","Le coefficient ");
        s:=s+"$"+var2latex(coef1)+"$ peut s'annuler. On raisonne donc par disjonction des cas.\n\\begin{itemize}";
        for(j:=0;j<nb_sol;j++){
          if(not(contains(pivot_nul,[lv[0],lz[j] ]))){ //cette racine n'a pas été étudiée avant, le pivot peut s'annuler
            // substituer et résoudre ce cas 
            s:=s+"\n\\item\n"; 
            matrice_subst:=simplifier(subst(matrice,lv[0]=lz[j]));
            s:=s+"Si $"+var2latex(lv[0])+"="+var2latex(lz[j])+"$, alors on est amené à chercher le rang de la matrice :\n";
            s:=s+affMatrice(matrice_subst,[]);
            //s:=s+"On élimine la variable $"+var2latex(variables[p])+"$ à partir de la ligne "+string(n+2)+" :\\\\\n";
            if(pivot_nul==[]){
              pivot_nul:=[ [lv[0],lz[j] ] ]
            } else {
              pivot_nul:=append(pivot_nul,[lv[0],lz[j] ]);
            }
            s:=s+GaussPivotRang(matrice_subst,n,p,pivot_nul,rang);
          }
        }
        // dans les autres cas
        s:=s+"\n\\item\n";
        if(nb_sol==1){
          s:=s+"Si $"+var2latex(lv[0])+"\\neq "+var2latex(lz[0])+"$";   
        } else {
          s:=s+"Si $"+var2latex(lv[0])+"\\notin \\left\\{";
            for(j:=0;j<nb_sol-1;j++){
              s:=s+var2latex(lz[j])+"\\mathpunct{;}";
            }
            s:=s+var2latex(lz[nb_sol-1])+"\\right\\}$";
        }        
        s:=s+ifte((n<nb_lig-1)and(p<nb_col-1),", alors le pivot ",", alors le coefficient ");
        s:=s+"$"+var2latex(coef1)+"$ est non nul.\n\n";
        s:=s+GaussPivotRang(matrice,n,p,pivot_nul,rang);
        s:=s+"\n\\end{itemize}\n";
        return(s);
      }
    } 
  // le pivot est non nul ou on est sur la denière ligne     
  for(k:=n+1;k<nb_lig;k++){
    coef2:=-matrice[k][p];
    coef:=simplifier(coef2/coef1);
    if(coef<>0){
      diviseur:=gcd(coef1,coef2);
      afficher("coefs :",coef1,coef2,diviseur);
      matrice:=simplifier(mRowAdd(coef,matrice,n,k));
      matrice:=simplifier(mRow(coef1/diviseur,matrice,k));
      operations:=append(operations,[k+1,n+1,simplifier(coef1/diviseur),simplifier(coef2/diviseur)]);
      afficher("L"+string(k+1)+" reçoit "+"L"+string(k+1)+"+"+string(coef)+"*L"+string(n+1));
      afficher(matrice);
    }
  }
  if(operations<>[]){
      s:=s+"On annule les coefficients sous le pivot de la colonne "+string(p+1)+". On obtient la matrice de même rang :\n";
      s:=s+affMatrice(matrice,operations);
    } else {
      s:=s+"";//"Rien à faire colonne "+string(p+1)+".\\\\\n";
    }
    n++;p++;
    s:=s+GaussPivotRang(matrice,n,p,pivot_nul,rang+1);
  }
}
return(s);
}:;

GaussRang(matrice):={
local s;
s:="Par la méthode du pivot de Gauss, on calcule le rang de la matrice :\n"+affMatrice(matrice,[]);
// pivoter à partir de (0,0)
s:=s+GaussPivotRang(matrice,0,0,[],0);
return(s);
}:;


GaussInv(matrice):={
local s;
s:="Par la méthode de Gauss-Jordan, on calcule l'inverse de la matrice :\n"+affMatrice(matrice,[]);
s:=s+"Sur la matrice\n"
s:=s+affMatriceInv(border(matrice,idn(nrows(matrice))),[]);
s:=s+"on effectue les opérations élémentaires suivantes :\\\\\n";  
// pivoter à partir de (0,0)
s:=s+GaussPivotInv(border(matrice,idn(nrows(matrice))),0,0,[],1);
return(s);
}:;

GaussPivotInv(matrice,n,p,pivot_nul,direction):={
local nb_col,nb_lig;
local s:="";
local operations;
local v,j,k,coef,coef1,coef2,diviseur,lv,lz,nb_sol,matrice_subst,fraction;
fraction:=faux;
nb_col:=ncols(matrice);
nb_lig:=nrows(matrice);
if(n==nb_lig){ // repartir en remontant
  // On sait maintenant si la matrice est inversible
  if(det(matrice)==0){
    s:=s+"La matrice n'est donc pas inversible.\n"; 
  } else {
    return(GaussPivotInv(matrice,n-1,p-1,pivot_nul,-1))
  }  
} else {  
  if(n==0 and direction==-1){ // afficher la matrice inverse
    local matrice_inverse:=matrix(nb_lig,nb_lig,(j,k)->matrice[j][k+nb_lig]);
    for(j:=0;j<nb_lig;j++){
      matrice_inverse[j]:=simplifier(matrice_inverse[j]/matrice[j][j]);
    }
    s:=s+"La matrice inverse est donc "+affMatrice(matrice_inverse,[])+"\n";
    return(s);   
  } else { // pivoter
  operations:=[];
  k:=cherchePivot(matrice,n,p,nb_lig,direction);
  if(k==-1){ // la colonne ne contient pas la variable
    //if(n<nb_lig-1){
    //  s:=s+"La variable $"+var2latex(variables[p])+"$ est absente à partir de la ligne "+string(n+2)+". Il n'y a donc rien à faire pour l'éliminer.\\\\\n";
    //}
    afficher("Rien à faire pour la colonne "+string(p));
    s:=s+GaussPivotInv(matrice,n+direction,p+direction,pivot_nul,direction);
  } else {
    if(k<>n and direction==1){ // il faut permuter
      if(estNombre(matrice[n][p])==faux){
        s:=s+"On échange la ligne "+string(n+1)+" avec la ligne "+string(k+1)+" pour obtenir un pivot toujours non nul :\n";
      } else {
        s:=s+"On échange la ligne "+string(n+1)+" avec la ligne "+string(k+1)+" pour obtenir un pivot non nul :\n";
      }
      matrice:=rowSwap(matrice,n,k);
      s:=s+affMatriceInv(matrice,[]);
      //afficher ("Echange lignes "+string(n)+" et "+string(k));
      //afficher(msysteme);
    }
    coef1:=matrice[n][p];
    if(not(estNombre(coef1))) {
      // chercher les valeurs qui annulent le pivot
      lv:=listeVariables(coef1); // vecteurs des variables
      /*if(degree(coef1,lv[0])>1) { // factoriser les coef de degré >1
        matrice[n,p]=<factor(coef1,lv[0]);
        coef1:=matrice[n][p];
      }*/
      lz:=solve(coef1=0,lv[0]); // zéros du coef pour la première variable
      nb_sol:=size(lz);
      if(nb_sol>0 and coefVautZero(pivot_nul,lv[0],lz,nb_sol)==vrai){ // disjonction des cas si au moins une valeur qui annule le pivot
        local liste_sol:="";
        local nb_nv_sol:=0; // zéros non étudiés avant
        
        for(j:=0;j<nb_sol;j++){
          if(not(contains(pivot_nul,[lv[0],lz[j] ]))){ //cette racine n'a pas été étudiée avant, le pivot peut s'annuler
            // substituer et résoudre ce cas 
            if(nb_nv_sol>0){
              liste_sol:=liste_sol+"\\mathpunct{;}";
            }
            liste_sol:=liste_sol+var2latex(lz[j]);
            nb_nv_sol:=nb_nv_sol+1;
            // ajout des valeurs qui annulent le pivot
            if(pivot_nul==[]){
              pivot_nul:=[ [lv[0],lz[j] ] ]
            } else {
              pivot_nul:=append(pivot_nul,[lv[0],lz[j] ]);
            }
            
          }
        }
        if(nb_nv_sol>0){
          s:=s+"Le pivot $"+var2latex(coef1)+"$ peut s'annuler. On raisonne donc par disjonction des cas.\n\\begin{itemize}";
          // cas non inversibles
          s:=s+"\n\\item\n";
          if(nb_nv_sol==1){
            s:=s+"Si $"+var2latex(lv[0])+"="+liste_sol+"$";   
          } else {
            s:=s+"Si $"+var2latex(lv[0])+"\\in \\left\\{"+liste_sol+"\\right\\}$";
          }        
          s:=s+", alors la matrice n'est pas inversible.\n\n";       
          // dans les autres cas
          s:=s+"\n\\item\n";
          if(nb_nv_sol==1){
            s:=s+"Si $"+var2latex(lv[0])+"\\neq "+liste_sol+"$";   
          } else {
            s:=s+"Si $"+var2latex(lv[0])+"\\notin \\left\\{"+liste_sol+"\\right\\}$";
          }        
          s:=s+", alors le pivot est non nul et on continue la résolution.\n\n";
   
          
          s:=s+GaussPivotInv(matrice,n,p,pivot_nul,direction);
          s:=s+"\n\\end{itemize}\n";
          return(s);
        }
      }    
    } 
    // le pivot est non nul
    for(k:=n+direction;(k<nb_lig and direction==1) or (k>-1 and direction==-1);k:=k+direction){
      coef2:=-matrice[k][p];
      coef:=simplifier(coef2/coef1);
      if(coef<>0){
        diviseur:=gcd(coef1,coef2);
        afficher("coefs :",coef1,coef2,diviseur);
        matrice:=simplifier(mRowAdd(coef,matrice,n,k));
        matrice:=simplifier(mRow(coef1/diviseur,matrice,k));
        operations:=append(operations,[k+1,n+1,simplifier(coef1/diviseur),simplifier(coef2/diviseur)]);
        afficher("L"+string(k+1)+" reçoit "+"L"+string(k+1)+"+"+string(coef)+"*L"+string(n+1));
        //afficher(matrice);
      }
    }
    if(operations<>[]){
      //s:=s+"On élimine la variable $"+var2latex(variables[p])+"$ à partir de la ligne "+string(n+2)+" :\\\\\n";
      operations:=tran(sorta(tran(operations)));
      s:=s+affMatriceInv(matrice,operations);
    } else {
      if(n<nb_lig-1){
        s:=s+"Rien à faire ligne "+string(n+2)+".\n\n";
      }
    }
    s:=s+GaussPivotInv(matrice,n+direction,p+direction,pivot_nul,direction);
  }
  }
}
return(s);
}:;


affMatriceInv(matrice,operations):={
// matrice de taille nx2n, avec un trait vertical au milieu
// operations (facultatif) : matrice des opérations élémentaires à afficher.  
local s:="\\[\n\\begin{blockarray}{";
local nb_col;
local nb_lig;
local n,p;
local ligne,L1,L2,coef1,coef2;
if(operations==[]){
  ligne:=-1;//pas de résolution
  L1:=-1;//pas d'opérations à afficher
}else{
  ligne:=0;
  L1:=operations[ligne][0];
  L2:=operations[ligne][1];
  coef1:=operations[ligne][2];
  coef2:=operations[ligne][3];
}
afficher(matrice);
nb_col:=ncols(matrice);
nb_lig:=nrows(matrice);
s:=s+"(*{"+string(nb_col/2)+"}{c}|*{"+string(nb_col/2)+"}{c})l}\n";
for(n:=0;n<nb_lig;n++){
  local coef;
  for(p:=0;p<nb_col;p++){
    coef:=matrice[n][p];
    s:=s+var2latex(coef)+" & ";
  }
  if(ligne<>-1){
    if(n==L1-1){
      // afficher l'opération
      local v,sig1,scoef1,sig2,scoef2;
      v:=vCoef(coef1);sig1:=v[0];scoef1:=v[1];
      v:=vCoef(coef2);sig2:=v[0];scoef2:=v[1];
      s:=s+"L_"+string(L1)+" \\longleftarrow "+ifte(sig1=="+","","-")+scoef1+" L_"+string(L1)+sig2+scoef2+" L_"+string(L2);
      if(nrows(operations)>ligne+1){
        ligne++;
        L1:=operations[ligne][0];
        L2:=operations[ligne][1];
        coef1:=operations[ligne][2];
        coef2:=operations[ligne][3];
      } else {
        //ligne:=-1;
        L1:=-1;
      }
    } else {
      // pas d'opération pour cette ligne
      s:=s+" ";
    }
  } 
  s:=s+" \\\\\n"; 
}
s:=s+"\\end{blockarray}\n\\]\n";
return(s);
}:;
]]

XCAS_Tableaux=XCAS_var2latex..[[
initCas():={
  complex_mode:=0;
  complex_variables:=0;
  angle_radian:=1;
  all_trig_solutions:=1;
  reset_solve_counter(-1,-1);
  with_sqrt(1);
}:;

trigo(expressionTrigo):={
// renvoie vrai si l'expression dépend d'un paramètre n_1 (solutions d'une équation trigo dans xcas)  
  local n_1;purge(n_1);
  if (subst(expressionTrigo,n_1=0)==expressionTrigo)
    return faux;
  else
    return vrai;
}:;

debutTableau(colonne,hauteurLigne,valX,nb_decimales):={
// colonne est la liste des lignes de la première colonne
// hauteurLigne est la liste des hauteurs des lignes
// valX est la liste des valeurs de x à inscrire dans la première ligne
// renvoie la chaine définissant la première partie du tableau  
  local k,s;
  s:="\\begin{tikzpicture}\n";
  s:=s+"\\tkzTabInit[lgt=2,espcl=2,deltacl=0.5]\n";
  s:=s+"{";
  for(k:=0;k<size(colonne);k++)
  {
    if (k>0){s:=s+","};
    s:=s+colonne[k]+" / "+hauteurLigne[k];
  }  
  s:=s+"}\n{";
  for(k:=0;k<size(valX);k++)
  {
    if (k>0){s:=s+","};
      if(type(nb_decimales)==DOM_INT and type(valX[k])==DOM_FLOAT){
        s:=s+"$"+var2latex(evalf(valX[k],nb_decimales))+"$";
      } else {
        s:=s+"$"+var2latex(valX[k])+"$";
      }
  }
  s:=s+"}\n";
  return(s);
}:;

Elague(IE,liste):={
  local nliste,nIE,k,listeelaguee,expres,m,mini,maxi;
  local n_1;purge(n_1);
  listeelaguee:=[];
  nliste:=size(liste);
  nIE:=size(IE);
  mini:=IE[0];maxi:=IE[nIE-1];
  for(k:=0;k<nliste;k++){
    expres:=liste[k];
    if (trigo(expres)) {
      m:=0;
      while(subst(expres,n_1=m)<=maxi and subst(expres,n_1=m)>=mini) {
        listeelaguee:=concat(listeelaguee,simplify(subst(expres,n_1=m)));
        m:=m+1;
      };
      m:=-1;
      while(subst(expres,n_1=m)<=maxi and subst(expres,n_1=m)>=mini) {
        listeelaguee:=concat(listeelaguee,simplify(subst(expres,n_1=m)));
        m:=m-1;
      }
    } else {
      if(expres>mini and expres<maxi){
        listeelaguee:=concat(listeelaguee,expres);
      }
    }
  }
  return(sort(listeelaguee));
}:;

trouveVI(IE,f):={
  local k,s,o,n,listeVI:=[];
  local x;purge(x);
  s:=sommet(f);
  o:=op(f);
  if (s=='inv') {
    return(solve(o=0,x));
  } else {
  if (s=='*'){
    n:=size(o);
    for(k:=0;k<n;k++)
        listeVI:=concat(listeVI,trouveVI(IE,o[k]));
    return(Elague(IE,listeVI));
  } else {
  if (s=='^'){
    if(evalf(abs(o[1])<1)){
      return(Elague(IE,solve(o[0]=0,x)))
    } else {
      return([]);
    }
  } else {
  if (s=='ln'){
    return(Elague(IE,solve(o=0,x)));
  } else {
  if (s=='id'){
      return([]);
  } else {
  if (type(o)==DOM_LIST){
    for(k:=0;k<size(o);k++)
        listeVI:=concat(listeVI,trouveVI(IE,o[k]));
    return(Elague(IE,listeVI));}
  else {
    return(trouveVI(IE,o));
  }
  }}}}}
}:;


trouveZeros(IE,f):={
  local n:=size(IE);
  local Z,err,k;
  local x;purge(x);
  try {Z:=solve(factor(simplify(f(x)=0)),x);}
  catch(err){
    local xmin:=IE[0];
    local xmax;
    xmax:=IE[n-1];
    if(xmin==-infinity){xmin:=-100}; // garde-fou, en attendant mieux...
    if(xmax==+infinity){xmax:=100};
    Z:=resoudre_numerique(f(x)=0,x,xmin..xmax);
    if(Z==[]){
      // pas de zéro trouvé avec la méthode de l'intervalle, on teste avec une valeur "Guest"
      Z:=append(Z,resoudre_numerique(f(x)=0,x,(xmin+xmax)/2));
      if(Z==[undef]){
        Z:=[]
      }
    }      
  }
  Z:=Elague(IE,Z);  
  return(Z);
}:;

insereValeurs(l1,l2):={
  // insère les valeurs de l2 dans l1 puis trie
  // l2 est supposée appartenir à [min(l1),max(l1)] puisque l2 provient
  // de la fonction Elague qui ne garde que les valeurs dans IE
  local k,l:=l1;
  local n2:=size(l2);
  for(k:=0;k<n2;k++){
    if (not(member(l2[k],l1))){
        l:=append(l,l2[k]);        
        }
    }
  return(trier(l));
}:;

estDefinie(f,x):={
  local y;
  if (abs(x)==+infinity){return(faux)};
  y:=simplifier(f(x));
  if (y==undef){return(faux)};
  if (abs(y)==+infinity) {return(faux)};
  if (im(evalf(f(x)))!=0) {return(faux)};
  return(vrai);
}:;

tabSignes(IE,f,g):={
// f est la fonction dont on étudie le signe
// g est une fonction qui doit exister au point testé pour valider le signe
  local k,x,nIE,a,xi;
  local signes:=[];
  nIE:=size(IE);
  for(k:=0;k<=nIE-2;k++)
  {
    if(estDefinie(f,IE[k]) and estDefinie(g,IE[k])){
      if(abs(f(IE[k]))<1e-10){
        signes:=append(signes,0);
      } else {
        signes:=append(signes,simplifier(f(IE[k])));
      }
    } else {
      if(abs(IE[k])==+infinity){
        signes:=append(signes," ");
      } else {
        signes:=append(signes,"d");
      }
    }
    xi:=x_milieu(IE[k],IE[k+1]);
    if(estDefinie(f,xi) and estDefinie(g,xi)){
      if(f(xi)>0){
        signes:=append(signes,"+");
      } else {
        signes:=append(signes,"-");
      }
    } else {
      signes:=append(signes,"h");
    }
  }
  if(estDefinie(f,IE[nIE-1]) and estDefinie(g,IE[nIE-1])){
    if(abs(f(IE[nIE-1]))<1e-10){
      signes:=append(signes,0);
    } else {
      signes:=append(signes,simplifier(f(IE[nIE-1])));
    }
  } else {
    if(abs(IE[nIE-1])==+infinity){
      signes:=append(signes," ");
    } else {
      signes:=append(signes,"d");
    }
  }
  return(signes);
}:;

calculeImages(IE,f,nb_decimales):={
  local k;
  local images;
  local nIE:=size(IE);
  local x;purge(x);
  if(type(nb_decimales)!=DOM_INT){
    images:=[ [infinity,simplifier(limite(f(x),x,IE[0],1))] ];
  } else {
    //images:=[ [infinity,format(evalf(limite(f(x),x,IE[0],1)),"f"+string(nb_decimales))] ];
    images:=[ [infinity,evalf(limite(f(x),x,IE[0],1),nb_decimales)] ];
  }
  for(k:=1;k<=nIE-2;k++)
  {
    if(type(nb_decimales)!=DOM_INT){
      images:=append(images,[simplifier(limite(f(x),x,IE[k],-1)),simplifier(limite(f(x),x,IE[k],1))]);
    } else {
      images:=append(images,[evalf(limite(f(x),x,IE[k],-1),nb_decimales),evalf(limite(f(x),x,IE[k],1),nb_decimales)]);
    }
  }
  
  if(type(nb_decimales)!=DOM_INT){
    images:=append(images,[simplifier(limite(f(x),x,IE[nIE-1],-1)),infinity]);
  } else {
    images:=append(images,[evalf(limite(f(x),x,IE[nIE-1],-1),nb_decimales),infinity]);
  }
  return(images);
}:;

calculePosition(IE,VI,f,images):={
  // crée une liste avec la position des images, les double-barres, les zones interdites.
  local k,sg,sd,symb,xi;
  local pos:=[];
  local sg:="";
  local nIE:=size(IE);
  for(k:=0;k<=nIE-2;k++){
    symb:=sg;
    xi:=x_milieu(IE[k],IE[k+1]);
    if(member(IE[k],VI) or not(estDefinie(f,IE[k]))){
      // chercher prolongement par continuité
      if (abs(images[k][0])!=+infinity and images[k][0]==images[k][1] and k!=0 and estDefinie(f,xi)){
        // s'il y a une ZI avant ne pas mettre R
        if(right(pos[k-1],1)=="H"){
          if(images[k][1]<=images[k+1][0]){
            symb:=symb+"-";
            sg:="+";
          } else {
            symb:=symb+"+";    
            sg:="-";
          }
        } else {
          if(images[k][1]<=images[k+1][0]){
            symb:=symb+"-";
            sg:="+";        
          } else {
            symb:=symb+"+";
            sg:="-";
          }
          if(symb=="++"){symb:="+"}
          else {if(symb=="--"){symb:="-"}
            else {if(k>0){symb:="R"}}
          }
        }
      } else {
        if(abs(IE[k])!=+infinity and not(estDefinie(f,IE[k]))){symb:=symb+"D";}
        if(not(estDefinie(f,xi))){
          if (k==0){ // impossible de mettre DH en première colonne
            symb:="-"+symb;
          };
          symb:=symb+"H";sg:="";
        } else {
          if(images[k][1]<=images[k+1][0]){
            symb:=symb+"-";
            sg:="+";
          } else {
            symb:=symb+"+";    
            sg:="-";
          }
        }
      }
    } else {
      if(images[k][1]<=images[k+1][0]){
        symb:=symb+"-";
        sg:="+";        
      } else {
        symb:=symb+"+";
        sg:="-";
      }
      if(symb=="++"){symb:="+"}
      else {if(symb=="--"){symb:="-"}
        else {if(k>0){symb:="R"}}
      }
    }
    pos:=append(pos,symb);
  }    
  // dernier point
  symb:=sg;
  if(member(IE[nIE-1],VI) or not(estDefinie(f,IE[nIE-1]))){
      if(abs(IE[k])!=+infinity){
        symb:=symb+"D";
        if (sg==""){ // impossible de mettre D
          symb:=symb+"+"};
      }
  }
  return(pos:=append(pos,symb));
}:;


noeudsNonExtrema(pos):={
  // renvoie une liste contenant les noeuds des images à calculer dans le tableau
  local k;
  local npos:=size(pos);
  local noeuds:=[0];
  for(k:=1;k<=npos-2;k++){
    if (pos[k]=="R"){
      local nmin,nmax;
      nmin:=k-1;
      nmax:=k+1;
      while(pos[nmin]=="R"){nmin--;}
      while(pos[nmax]=="R"){nmax++;}
      noeuds:=append(noeuds,[nmin+1,nmax+1,k+1]);
    } else {
      noeuds:=append(noeuds,0);
    }
  }
  noeuds:=append(noeuds,0);
}:;

ligneSignes(signes):={
local n,sTkzTabLine,j,k;
n:=size(signes);
sTkzTabLine:="\\tkzTabLine {";
for(k:=0;k<n;k++){
  j:=type(signes[k]);
  if(type(signes[k])==DOM_STRING){
    sTkzTabLine+=signes[k];    
    } else {
    if (signes[k]==0){
      sTkzTabLine+="z";
      } else {
      sTkzTabLine+="t";      
      }
    }
    if (k<n-1){
      sTkzTabLine+=",";
    }
  }
  sTkzTabLine+="}\n";
  return(sTkzTabLine);
}:;

ligneVariations(positions,images):={
local n,sTkzTabVar,pos,k;
n:=size(positions);
sTkzTabVar:="\\tkzTabVar {";
for(k:=0;k<n;k++){
  pos:=positions[k];
  sTkzTabVar:=sTkzTabVar+pos;
  if (pos!="R"){
    if(pos=="+" or pos=="-"){
      if(k==0){
        sTkzTabVar:=sTkzTabVar+" / $"+var2latex(images[0][1])+"$";        
      } else {
        sTkzTabVar:=sTkzTabVar+" / $"+var2latex(images[k][0])+"$";      
      }
    } else {
    if(left(pos,1)=="-" or left(pos,1)=="+"){
      if(k==0){
        sTkzTabVar:=sTkzTabVar+"/ ";        
      } else {
       sTkzTabVar:=sTkzTabVar+" / $"+var2latex(images[k][0])+"$";      
      }
    };
    if(right(pos,1)=="-" or right(pos,1)=="+"){
      if(k==n-1){
        sTkzTabVar:=sTkzTabVar+"/ ";        
      } else {
        sTkzTabVar:=sTkzTabVar+" / $"+var2latex(images[k][1])+"$";      
      }
    }
  }   
  };
  if (k<n-1){
    sTkzTabVar+=",";
  }
}
sTkzTabVar+="}\n";
return(sTkzTabVar);
}:;


lignesImages(noeuds,images):={
  local k,n;
  local sTkzTabIma:="";
  n:=size(noeuds);
  for(k:=0;k<n;k++){
    if(size(noeuds[k])==3){
      sTkzTabIma:=sTkzTabIma+"\\tkzTabIma{"+noeuds[k][0]+"}";
      sTkzTabIma:=sTkzTabIma+"{"+noeuds[k][1]+"}";
      sTkzTabIma:=sTkzTabIma+"{"+noeuds[k][2]+"}";
      sTkzTabIma:=sTkzTabIma+"{$"+var2latex(images[k][0])+"$}\n";
    }
  }
  return(sTkzTabIma);
}:;

x_milieu(x1,x2):={
  if(x1==-infinity and abs(x2)==+infinity){return(0)};
  if(x1==-infinity){return(x2-1)}
  if(abs(x2)==+infinity){return(x1+1)}  
  return((x1+x2)/2);
}:;

sontDefinies(f,liste_zeros):={
  local k,n,liste:=[];
  n:=size(liste_zeros);
  for(k:=0;k<n;k++){
    if(estDefinie(f,liste_zeros[k])){
      liste:=append(liste,liste_zeros[k]);
    }
  }
  return(liste);
}:;

identifier_fonc(expression_fonc):={
  //renvoie [fonction, [nom variable,nom variable latex], [nom fonction, nom fonction latex],
  // [nom dérivée, nom dérivée latex] ] au format LaTeX
  local x,membres,g,d,fonc,variable,commande;
  if (sommet(expression_fonc)=='='){
    membres:=op(expression_fonc);
    g:=membres[0];
    d:=membres[1];
    fonc:=op(g)[0];
    variable:=op(g)[1];
    commande:="unapply(d,"+variable+")";
    return([execute(commande),[variable,latex(variable)],[fonc,var2latex(fonc)],[fonc+"'",var2latex(fonc)+"'"] ]);
  } else {
    g:=unapply(expression_fonc,x);
    variable:=op(g)[0];
    return([g,[variable,"x"],["x->"+expression_fonc,"x\\mapsto "+var2latex(expression_fonc)],["(x->"+expression_fonc+")'","\\left( x\\mapsto "+var2latex(expression_fonc)+"\\right) '"] ])
  }
}:;


listeFacteurs(expression_pro):={
  local k,s,o;
  local numerateur;
  local denominateur:=[];
  o:=[op(expression_pro)];
  s:=sommet(expression_pro);
  if (s=='*'){
    numerateur:=o;
  } else {
    numerateur:=[expression_pro];
  }
  // extraire le dénominateur et regrouper les facteurs constants
  for(k:=0;k<size(numerateur);k++)
  {
    if(sommet(numerateur[k])=='inv'){
      if(sommet(op(numerateur[k]))=='*'){
        denominateur:=append(denominateur,op(op(numerateur[k])));
      } else {
        denominateur:=append(denominateur,op(numerateur[k]));
      }
      //execute("numerateur:=subsop(numerateur,'"+string(k)+"=NULL')");
      numerateur:=suppress(numerateur,k);
      k--;
    };
    if(k<size(numerateur)-1){
      if(type(evalf(numerateur[k]))==DOM_FLOAT and sommet(numerateur[k+1])!='inv'){
        numerateur[k+1]:=numerateur[k]*numerateur[k+1];
        //execute("numerateur:=subsop(numerateur,"+string(k+1)+"="+string(numerateur[k]*numerateur[k+1])+")");
        //execute("numerateur:=subsop(numerateur,'"+string(k)+"=NULL')");
        numerateur:=suppress(numerateur,k);
        k--;
      }
    }
  };
  for(k:=0;k<size(denominateur);k++){
    if(type(evalf(denominateur[k]))==DOM_FLOAT){
      if(k<size(denominateur)-1){
        denominateur[k+1]:=denominateur[k]*denominateur[k+1];
        //execute("denominateur:=subsop(denominateur,"+string(k+1)+"="+string(denominateur[k]*denominateur[k+1])+")");
        //execute("denominateur:=subsop(denominateur,'"+string(k)+"=NULL')");
        denominateur:=suppress(denominateur,k);
        k--;
      }
    }
  };
  return(numerateur,denominateur);
}:;

ligneSignesTVP(signes,nb_decimales):={
local n,sTkzTabLine,j,k;
n:=size(signes);
sTkzTabLine:="\\tkzTabLine {";
for(k:=0;k<n;k++){
  j:=type(signes[k]);
  if(type(signes[k])==DOM_STRING){
    sTkzTabLine+=signes[k];    
    } else {
    if (signes[k]==0){
      sTkzTabLine+="z";
      } else {
        if(type(nb_decimales)==DOM_STRING) {
          sTkzTabLine:=sTkzTabLine+var2latex(signes[k]);
        } else {
          sTkzTabLine:=sTkzTabLine+var2latex(evalf(signes[k],nb_decimales));
        }
      }
    }
    if (k<n-1){
      sTkzTabLine+=",";
    }
  }
  sTkzTabLine+="}\n";
  return(sTkzTabLine);
}:;

TVar(arguments):={
local VI; // liste des valeurs interdites de f
local fp; // f'
local Zeros_fp; // liste des racines de f'
local ValeursX; // liste des valeurs de x à faire apparaître dnas la 1ère ligne
local sTkzTab; // ce qui sera renvoyé vers LuaTeX
local Signes_fp; // liste des signes de f'
local sTkzTabLine; // ligne des signes de f'
local Variationsf; // liste des variations de f
local sTkzTabVar; // ligne des variations de f
local Imagesf; // liste des images de f
local NoeudsNonExtremaf; // liste des images de f qui ne sont pas des extrema
local sTkzTabIma; // lignes des images de f
local k,n,j;
local id_fonction, nom_variable, nom_fonction, nom_derivee;
local a;
local IE:=arguments[0];
local f:=arguments[1];
local nb_decimales;
local x;purge(x);
if (size(arguments)==3){
  nb_decimales:=arguments[2];
} else {
  nb_decimales:="";
}
initCas();
id_fonction:=identifier_fonc(f);
f:=id_fonction[0];
nom_variable:=id_fonction[1][1];
nom_fonction:=id_fonction[2][1];
nom_derivee:=id_fonction[3][1];
//unapply(f,x);
fp:=function_diff(f);
IE:=sort(IE);
VI:=trouveVI(IE,f(x));
ValeursX:=insereValeurs(IE,VI);
Zeros_fp:=trouveZeros(IE,fp);
Zeros_fp:=sontDefinies(f,Zeros_fp);
ValeursX:=insereValeurs(ValeursX,Zeros_fp);
ValeursX:=sort([op(set[op(ValeursX)])]);
ValeursX:=simplifier(ValeursX);
// construction de la structure du tableau
sTkzTab:=debutTableau(["$"+nom_variable+"$","$"+nom_derivee+"("+nom_variable+")"+"$","$"+nom_fonction+"$"],[1,1,2],ValeursX,nb_decimales);
// construction du signe de f'
Signes_fp:=tabSignes(ValeursX,fp,f);
sTkzTabLine:=ligneSignes(Signes_fp);
sTkzTab+=sTkzTabLine;
// construction des variations de f
Imagesf:=calculeImages(ValeursX,f,nb_decimales);
Variationsf:=calculePosition(ValeursX,VI,f,Imagesf);
afficher(ValeursX,VI,f,Imagesf);
sTkzTabVar:=ligneVariations(Variationsf,Imagesf);
sTkzTab+=sTkzTabVar;
// construction des images de f
NoeudsNonExtremaf:=noeudsNonExtrema(Variationsf);
sTkzTabIma:=lignesImages(NoeudsNonExtremaf,Imagesf);
sTkzTab+=sTkzTabIma;
sTkzTab+="\\end{tikzpicture}\n";
return(sTkzTab);
}:;

TSig(IE,f):={
// IE=intervalle d'étude
// f=fonction
local VI; // liste des valeurs interdites de f
local Zerosf; // liste des racines de f
local ValeursX; // liste des valeurs de x à faire apparaître dnas la 1ère ligne
local sTkzTab; // ce qui sera renvoyé vers LuaTeX
local Signes; // liste des signes des facteurs de f
local sTkzTabLine; // lignes des signes des facteurs de f
local facteur, facteurs; // de f
local colonne; // contenu de la première colonne
local hauteurs_lignes;
local id_fonction, nom_variable, nom_fonction;
local k;
local denominateur;
local x;
local nb_facteurs;
purge(x);
initCas();
id_fonction:=identifier_fonc(f);
f:=id_fonction[0];
nom_variable:=id_fonction[1][0];
nom_fonction:=id_fonction[2][0];
IE:=sort(IE);
VI:=trouveVI(IE,f(x));
ValeursX:=insereValeurs(IE,VI);
Zerosf:=trouveZeros(IE,f);
ValeursX:=insereValeurs(ValeursX,Zerosf);
ValeursX:=simplifier(ValeursX);
facteurs:=execute("listeFacteurs(f("+nom_variable+"))");
nb_facteurs:=0;
if (size(facteurs[1])>0){
  // il y a un dénominateur, augmenter la hauteur de la dernière ligne
  denominateur:=vrai;
} else {
  denominateur:=faux;
}
facteurs:=op(facteurs[0]),op(facteurs[1]);
if (size(facteurs)==1){ 
  facteurs:=NULL;
} else {
  nb_facteurs:=size(facteurs);
};
// construction de la structure du tableau
colonne:=append([nom_variable],facteurs);
if(type(nom_fonction)==DOM_STRING){
  colonne:=append(colonne,"$\\displaystyle "+var2latex(f(x))+"$");
} else {
  colonne:=append(colonne,"$"+id_fonction[2][1]+"("+id_fonction[1][1]+")$");
}
for(k:=0;k<size(colonne)-1;k++)
  colonne[k]:="$"+latex(colonne[k])+"$";
hauteurs_lignes:=makelist(1,1,size(colonne)-1);
if (denominateur){
  hauteurs_lignes:=append(hauteurs_lignes,2);
} else {
  hauteurs_lignes:=append(hauteurs_lignes,1);
}
sTkzTab:=debutTableau(colonne,hauteurs_lignes,ValeursX,"");
// construction du signe des facteurs
for(k:=0;k<nb_facteurs;k++){
  facteur:=execute("unapply(facteurs[k],"+nom_variable+")");
  Signes:=tabSignes(ValeursX,facteur,x->1);
  sTkzTabLine:=ligneSignes(Signes);
  sTkzTab+=sTkzTabLine;
}
// construction du signe de f s'il y a au moins 2 facteurs
Signes:=tabSignes(ValeursX,f,x->1);
sTkzTabLine:=ligneSignes(Signes);
sTkzTab+=sTkzTabLine;
sTkzTab+="\\end{tikzpicture}\n";
return(sTkzTab);
}:;

TVarP(arguments):={
// IE=intervalle d'étude
// f=fonction
local VIf; // liste des valeurs interdites de f
local VIg; // liste des valeurs interdites de g
local fp; // f'
local gp; // g'
local Zeros_fp; // liste des racines de f'
local Zeros_gp; // liste des racines de g'
local ValeursX; // liste des valeurs de x à faire apparaître dnas la 1ère ligne
local sTkzTab; // ce qui sera renvoyé vers LuaTeX
local Signes_fp; // liste des signes de f'
local Signes_gp; // liste des signes de g'
local Variationsf; // liste des variations de f
local Variationsg; // liste des variations de g
local Imagesf; // liste des images de f
local Imagesg; // liste des images de g
local NoeudsNonExtremaf; // liste des images de f qui ne sont pas des extrema
local NoeudsNonExtremag; // liste des images de g qui ne sont pas des extrema
local sTkzTabLine; // ligne des signes de f' ou g'
local sTkzTabVar; // ligne des variations de f ou g
local sTkzTabIma; // lignes des images de f ou g
local k,n,j;
local id_fonctionf, nom_variablef, nom_fonctionf, nom_deriveef;
local id_fonctiong, nom_variableg, nom_fonctiong, nom_deriveeg;
local IE:=arguments[0];
local f:=arguments[1];
local g:=arguments[2];
local nb_decimales;
local x;purge(x);

if (size(arguments)==4){
  nb_decimales:=arguments[3];
} else {
  nb_decimales:="";
}
initCas();
id_fonctionf:=identifier_fonc(f);
f:=id_fonctionf[0];
nom_variablef:=id_fonctionf[1][1];
nom_fonctionf:=id_fonctionf[2][1];
nom_deriveef:=id_fonctionf[3][1];
id_fonctiong:=identifier_fonc(g);
g:=id_fonctiong[0];
nom_variableg:=id_fonctiong[1][1];
nom_fonctiong:=id_fonctiong[2][1];
nom_deriveeg:=id_fonctiong[3][1];
fp:=function_diff(f);
gp:=function_diff(g);
IE:=sort(IE);
VIf:=trouveVI(IE,f(x));
ValeursX:=insereValeurs(IE,VIf);
VIg:=trouveVI(IE,g(x));
ValeursX:=insereValeurs(ValeursX,VIg);
Zeros_fp:=trouveZeros(IE,fp);
Zeros_fp:=sontDefinies(f,Zeros_fp);
ValeursX:=insereValeurs(ValeursX,Zeros_fp);
Zeros_gp:=trouveZeros(IE,gp);
Zeros_gp:=sontDefinies(g,Zeros_gp);
ValeursX:=insereValeurs(ValeursX,Zeros_gp);
ValeursX:=sort([op(set[op(ValeursX)])]);
ValeursX:=simplifier(ValeursX);
// construction de la structure du tableau
sTkzTab:=debutTableau(["$"+nom_variablef+"$",
      "$"+nom_deriveef+"("+nom_variablef+")"+"$","$"+nom_fonctionf+"$",
      "$"+nom_fonctiong+"$","$"+nom_deriveeg+"("+nom_variableg+")"+"$"],
      [1,1,2,2,1],ValeursX,nb_decimales);
// construction du signe de f'
Signes_fp:=tabSignes(ValeursX,fp,f);
sTkzTabLine:=ligneSignesTVP(Signes_fp,nb_decimales);
sTkzTab+=sTkzTabLine;
// construction des variations de f
Imagesf:=calculeImages(ValeursX,f,nb_decimales);
Variationsf:=calculePosition(ValeursX,VIf,f,Imagesf);
sTkzTabVar:=ligneVariations(Variationsf,Imagesf);
sTkzTab+=sTkzTabVar;
// construction des images de f
NoeudsNonExtremaf:=noeudsNonExtrema(Variationsf);
sTkzTabIma:=lignesImages(NoeudsNonExtremaf,Imagesf);
sTkzTab+=sTkzTabIma;
// construction des variations de g
Imagesg:=calculeImages(ValeursX,g,nb_decimales);
Variationsg:=calculePosition(ValeursX,VIg,g,Imagesg);
sTkzTabVar:=ligneVariations(Variationsg,Imagesg);
sTkzTab+=sTkzTabVar;
// construction des images de g
NoeudsNonExtremag:=noeudsNonExtrema(Variationsg);
sTkzTabIma:=lignesImages(NoeudsNonExtremag,Imagesg);
sTkzTab+=sTkzTabIma;
// construction du signe de g'
Signes_gp:=tabSignes(ValeursX,gp,g);
sTkzTabLine:=ligneSignesTVP(Signes_gp,nb_decimales);
sTkzTab+=sTkzTabLine;
sTkzTab+="\\end{tikzpicture}\n";
return(sTkzTab);
}:;

TVal(arguments):={
// IE=intervalle d'étude
// f=fonction
// nombre de décimales souhaitées. Si 0 alors valeurs exactes
local k,n,j,s;
local id_fonctionf, nom_variablef, nom_fonctionf, nom_deriveef;
local IE:=arguments[0];
local f:=arguments[1];
local nb_decimales;
if (size(arguments)==3){
  nb_decimales:=arguments[2];
} else {
  nb_decimales:="";
}
s:="{\\renewcommand{\\arraystretch}{1.5}\n\\newcolumntype{C}[1]{S{>{\\centering \\arraybackslash}m{#1}}}\n\\setlength{\\cellspacetoplimit}{4pt}\n\\setlength{\\cellspacebottomlimit}{4pt}\n\\begin{tabular}{|C{1.5cm}|*{";
initCas();
id_fonctionf:=identifier_fonc(f);
f:=id_fonctionf[0];
nom_variablef:=id_fonctionf[1][0];
nom_fonctionf:=id_fonctionf[2][0];
n:=size(IE);
s:=s+string(n)+"}{C{1cm}|}}\n\\hline $"+nom_variablef+"$ & ";
for(k:=0;k<n-1;k++){
  s:=s+"$\\displaystyle "+var2latex(simplifier(IE[k]))+"$ &";
}
s:=s+"$\\displaystyle "+var2latex(simplifier(IE[k]))+"$ \\\\\n\\hline $"
if(type(nom_fonctionf)==DOM_STRING){
  s:=s+"\\displaystyle "+var2latex(f(x))+"$ & ";
} else {
  s:=s+id_fonctionf[2][1]+"("+id_fonctionf[1][1]+")$ & ";
}
for(k:=0;k<n-1;k++)
{
  if(type(nb_decimales)!=DOM_INT){
    s:=s+"$\\displaystyle "+var2latex(simplifier(f(IE[k])))+"$ &";
  } else {
    s:=s+"$\\displaystyle "+var2latex(format(f(IE[k]),"f"+string(nb_decimales)))+"$ &";
  }
}
if(type(nb_decimales)!=DOM_INT){
  s:=s+"$\\displaystyle "+var2latex(simplifier(f(IE[k])))+"$ \\\\\n\\hline\n\\end{tabular}}";
} else {
  s:=s+"$\\displaystyle "+var2latex(format(f(IE[k]),"f"+string(nb_decimales)))+"$ \\\\\n\\hline\n\\end{tabular}}";
}
return(s);
}:;

purge(x);
]]

-- fonction qui exécute du code Lua et renvoie la chaine vide
-- peut permettre de définir des fonctions
function codeLua(arg)
	assert(load(arg))()
	return ""
end

function eval(arg)
	if(type(arg)=='string') then
		return assert(load('return '..arg))()
	else
		return arg
	end
end

-------------------------------------
-- Fonctions pour tracés avec TikZ --
-------------------------------------

-- Paramètres par défaut
local xmin=-5
local xmax=5
local x1cm=1
local ymin=-5
local ymax=5
local y1cm=1

-- Initialise la fenêtre
function tikzWindow(arg)
	-- grammaire des arguments
	local Options, Option, argument = V'Options', V'Option', V'argument'
	local ExpressionEntreParentheses=V'ExpressionEntreParentheses'
	local ExpressionEntreCrochets=V'ExpressionEntreCrochets'
	local OptionsWindow = P { Options,
		Options = C(Option * Cg(P(SepListe) * Option)^0),
		Option = P'xmin'*Egal*C(argument)/function(...) xmin=eval(...) end 
				+  P'xmax'*Egal*C(argument)/function(...) xmax=eval(...) end
				+  P'ymin'*Egal*C(argument)/function(...) ymin=eval(...) end
				+  P'ymax'*Egal*C(argument)/function(...) ymax=eval(...) end
				+  P'x1cm'*Egal*C(argument)/function(...) x1cm=eval(...) end
				+  P'y1cm'*Egal*C(argument)/function(...) y1cm=eval(...) end
				+  C(ExpressionEntreCrochets)/function(...) optionsTikz=... end,
		argument=(CaractereSansParenthesesSep^1*(ExpressionEntreParentheses*argument^0)^0)*Espace,
		ExpressionEntreParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
		ExpressionEntreCrochets=P{'['*(CaractereSansCrochets+V(1))^0*']'}
	}
	match(OptionsWindow,arg)
	return ""
end

local ExpressionEntreCrochets=P{'('*(CaractereSansCrochets+V(1))^0*')'}

-- crée une liste de coordonnées 2D utilisable avec PGFplots
function tikzPlot(arg)
	local pVariable,pSamples,pFunction,pType,pDomaine
	local a=xmin
	local b=xmax	
	local optionsTikz=""
	-- grammaire des arguments
	local Options, Option, argument = V'Options', V'Option', V'argument'
	local ExpressionEntreParentheses=V'ExpressionEntreParentheses'
	local ExpressionEntreCrochets=V'ExpressionEntreCrochets'
	local OptionsPlot = P { "Options",
		Options = C(Option * Cg(P(SepListe) * Option)^0),
		Option = P'variable'*Egal*C(argument)/function(...) pVariable=... end 
				+  P'type'*Egal*C(argument)/function(...) pType=... end
				+  P'function'*Egal*C(argument)/function(...) pFunction=... end
				+  P'domain'*Egal*C(argument)/function(...) pDomaine=... end
				+  P'samples'*Egal*C(argument)/function(...) pSamples=... end
				+  C(ExpressionEntreCrochets)/function(...) optionsTikz=... end,
		--argument=(CaractereSansParenthesesSep^1*(ExpressionEntreParentheses*argument^0)^0)*Espace,
    argument = (ExpressionEntreParentheses + CaractereSansParenthesesSep)^1 * Espace,
		ExpressionEntreParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
		ExpressionEntreCrochets=P{'['*(CaractereSansCrochets+V(1))^0*']'}
	}
	match(OptionsPlot,arg)
	--print(variable,type,fonction,domaine,samples)
	if pDomaine~=nil then
		local patDomain=C(P(1-P':')^1)/function(...) a=eval(...) end*P':'*C(P(1-P':')^1)/function(...) b=eval(...) end
		match(patDomain,pDomaine)
	end
	if pVariable==nil then pVariable='x' end
	if pFunction==nil then pFunction=0 end
	if pSamples==nil then pSamples=50 end
	local code_fonction = "f_draw_tikz = function("..pVariable..") return "..pFunction.." end"
	local draw=''
	assert(load(code_fonction))()
	local x,x_f,y_f,x_f_before,y_f_before
	local join=false -- tant qu'on ne détecte pas de discontinuité
	local clip=false -- pas besoin de limiter l'affichage
	local coordinates=""
	for x=a,b,(b-a)/(pSamples-1) do
		if pType=='polar' then
			x_f=f_draw_tikz(x)*cos(x)
			y_f=f_draw_tikz(x)*sin(x)
		elseif pType=='parametric' then
			x_f,y_f=f_draw_tikz(x) -- f doit renvoyer un couple
		else -- cartesian
			x_f=x
			y_f=f_draw_tikz(x)
		end
		-- y_f~=y_f seule façon de tester nan (=not a number, valeur interdite pour une racine par exemple)
		if y_f>ymax or y_f<ymin or y_f~=y_f or x_f>xmax or x_f<xmin or x_f~=x_f then
		-- on sort de la fenêtre ou non défini
			if join==true then
				if abs(y_f)~=huge and abs(x_f)~=huge and y_f==y_f and x_f==x_f then
					-- ce n'est pas une valeur interdite
					-- prendre en compte ce point mais limiter la fenêtre d'affichage
					clip=true
					coordinates = coordinates .."("..x_f/x1cm..","..y_f/y1cm..")"
				end
				-- stopper la courbe
				join=false
			else
				-- encore une valeur interdite
				-- ne pas tenir compte de ce point		
			end
		else
		-- le point est dans la fenêtre
			if join==false then
				-- on reprend le tracé
				join=true
				-- voir si le point juste avant était une discontinuité
				if y_f_before~=nil and x_f_before~=nil and math.abs(y_f_before)~=math.huge and math.abs(x_f_before)~=math.huge and y_f_before==y_f_before and x_f_before==x_f_before then
					-- ce n'est pas une valeur interdite
					-- prendre en compte ce point mais limiter la fenêtre d'affichage (déjà fait avant)
					if coordinates~='' then
						draw = draw .. "\\draw "..optionsTikz.." plot coordinates{"..coordinates.."};\n"
						coordinates=''
					end
					coordinates = coordinates .."("..x_f_before/x1cm..","..y_f_before/y1cm..")"
--					coordinates = coordinates .."("..x_f/x1cm..","..y_f/y1cm..")"
				--else
					-- ne pas tenir compte du point précédent
					--coordinates = coordinates .."("..x_f/x1cm..","..y_f/y1cm..")"
				end
			end
			coordinates = coordinates .."("..x_f/x1cm..","..y_f/y1cm..")"
			--end
		end
		x_f_before=x_f
		y_f_before=y_f
	end
	draw = draw .. "\\draw "..optionsTikz.." plot coordinates{"..coordinates.."};"
	if clip==true then 
		draw="\\clip ("..xmin/x1cm..","..ymin/y1cm..") rectangle ("..xmax/x1cm..","..ymax/y1cm..");\n"..draw
	end
	return draw
end

function tikzGrid(arg)
	local gXstep=1
	local gYstep=1
	local gXmin=xmin
	local gXmax=xmax
	local gYmin=ymin
	local gYmax=ymax
	local optionsTikz=""
	-- grammaire des arguments
	local Options, Option, argument = V'Options', V'Option', V'argument'
	local ExpressionEntreParentheses=V'ExpressionEntreParentheses'
	local ExpressionEntreCrochets=V'ExpressionEntreCrochets'
	local OptionsGrid = P { Options,
		Options = C(Option * Cg(P(SepListe) * Option)^0),
		Option = P'xstep'*Egal*C(argument)/function(...) gXstep=eval(...) end 
				+ P'ystep'*Egal*C(argument)/function(...) gYstep=eval(...) end 
				+ P'xmin'*Egal*C(argument)/function(...) gXmin=eval(...) end
				+ P'xmax'*Egal*C(argument)/function(...) gXmax=eval(...) end
				+ P'ymin'*Egal*C(argument)/function(...) gYmin=eval(...) end
				+ P'ymax'*Egal*C(argument)/function(...) gYmax=eval(...) end
				+ C(ExpressionEntreCrochets)/function(...) optionsTikz=... end,
		argument=(CaractereSansParenthesesSep^1*(ExpressionEntreParentheses*argument^0)^0)*Espace,
		ExpressionEntreParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
		ExpressionEntreCrochets=P{'['*(CaractereSansCrochets+V(1))^0*']'}
	}
	match(OptionsGrid,arg)
	local grid="\\draw "..optionsTikz.." ("..gXmin/x1cm..","..gYmin/y1cm..") grid [xstep="..gXstep/x1cm..",ystep="..
				gYstep/y1cm.."] ("..gXmax/x1cm..","..gYmax/y1cm..");"
	
	return grid
end

function tikzAxeX(arg)
	local step=1
	local aXmin=xmin
	local aXmax=xmax
	local tick=true
	local size=""
	local position="below"
	local label="x"
	local optionsTikz=""
	local rightspace=0
	local trig=false
	local digits=3
	local zero=true
	local tickxmin=xmin
	local tickxmax=xmax
	local signe_p=""
	-- grammaire des arguments
	local Options, Option, argument = V'Options', V'Option', V'argument'
	local ExpressionEntreParentheses=V'ExpressionEntreParentheses'
	local ExpressionEntreCrochets=V'ExpressionEntreCrochets'
	local OptionsAxe = P { Options,
		Options = C(Option * Cg(P(SepListe) * Option)^0),
		Option = P'step'*Egal*C(argument)/function(...) step=eval(...) end 
				+ P'xmin'*Egal*C(argument)/function(...) aXmin=eval(...) end
				+ P'xmax'*Egal*C(argument)/function(...) aXmax=eval(...) end
				+ P'trig'*Egal*C(argument)/function(...) trig=eval(...) end
				+ P'digits'*Egal*C(argument)/function(...) digits=eval(...) end
				+ P'zero'*Egal*C(argument)/function(...) zero=eval(...) end
				+ C(ExpressionEntreCrochets)/function(...) optionsTikz=... end
				+ P'tick'*Egal*C(argument)/function(...) tick=eval(...) end
				+ P'position'*Egal*C(argument)/function(...) position=... end
				+ P'rightspace'*Egal*C(argument)/function(...) rightspace=... end
				+ P'tickxmin'*Egal*C(argument)/function(...) tickxmin=eval(...) end
				+ P'tickxmax'*Egal*C(argument)/function(...) tickxmax=eval(...) end
				+ P'label'*Egal*C(argument)/function(...) label=... end,
		argument=(CaractereSansParenthesesSep^1*(ExpressionEntreParentheses*argument^0)^0)*Espace,
		ExpressionEntreParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
		ExpressionEntreCrochets=P{'['*(CaractereSansCrochets+V(1))^0*']'}
	}
	match(OptionsAxe,arg)
	local axe="\\draw "..optionsTikz.." ("..aXmin/x1cm..",0) -- ("..aXmax/x1cm+rightspace..
	",0) node [right] {$"..Cmath2LaTeX(label).."$};\n"
	if tick==true then
		local x
		--local nbdigits="%."..string.format( "%.0f", digits).."f"
		for x=tickxmin,tickxmax+step/1e10,step do
			x=round(x,digits)
			if x~=0 or (zero==true) then
				axe=axe.."\\draw [thick] ("..x/x1cm..",2pt)--("..x/x1cm..",-2pt) node ["..position.."] {\\small "
				if trig==true and x~=0 then
					local signe_p=""
					local p,q
					p,q=rational(x/math.pi,1e-3)
					if p<0 then 
						signe_p="-"
						p = -p
					end
					if q==1 then
						if p==1 then
							axe=axe.."$"..signe_p.."\\pi$};\n"
						else
							axe=axe.."$"..signe_p..string.format("%.0f", p).."\\pi$};\n"
						end
					else
						if p==1 then
							axe=axe.."$"..signe_p.."\\frac{\\pi}{"..string.format("%.0f", q).."}$};\n"
						else
							axe=axe.."$"..signe_p.."\\frac{"..string.format("%.0f", p).."\\pi}{"..string.format("%.0f", q).."}$};\n"
						end
					end
				else
					--local nb = nbdigits(x,digits)
					axe=axe.."$"..string.format("%."..nbdigits(x,digits).."f", x).."$};\n"
					--axe=axe.."$"..tostring(x).."$};\n"
				end
			end		
		end
	end
	--tex.print(axe)
	return axe
end

function tikzAxeY(arg)
	local step=1
	local aXmin=xmin
	local aXmax=xmax
	local aYmin=ymin
	local aYmax=ymax
	local tick=true
	local size=""
	local position="right=3pt"
	local label="y"
	local optionsTikz=""
	local upspace=0
	local trig=false
	local digits=3
	local zero=true
	local tickymin=ymin
	local tickymax=ymax
	-- grammaire des arguments
	local Options, Option, argument = V'Options', V'Option', V'argument'
	local ExpressionEntreParentheses=V'ExpressionEntreParentheses'
	local ExpressionEntreCrochets=V'ExpressionEntreCrochets'
	local OptionsAxe = P { Options,
		Options = C(Option * Cg(P(SepListe) * Option)^0),
		Option = P'step'*Egal*C(argument)/function(...) step=eval(...) end 
				+ P'ymin'*Egal*C(argument)/function(...) aYmin=eval(...) end
				+ P'ymax'*Egal*C(argument)/function(...) aYmax=eval(...) end
				+ P'trig'*Egal*C(argument)/function(...) trig=eval(...) end
				+ P'digits'*Egal*C(argument)/function(...) digits=eval(...) end
				+ P'zero'*Egal*C(argument)/function(...) zero=eval(...) end
				+ C(ExpressionEntreCrochets)/function(...) optionsTikz=... end
				+ P'tick'*Egal*C(argument)/function(...) tick=eval(...) end
				+ P'position'*Egal*C(argument)/function(...) position=... end
				+ P'upspace'*Egal*C(argument)/function(...) upspace=... end
				+ P'tickymin'*Egal*C(argument)/function(...) tickymin=eval(...) end
				+ P'tickymax'*Egal*C(argument)/function(...) tickymax=eval(...) end
				+ P'label'*Egal*C(argument)/function(...) label=... end,
		argument=(CaractereSansParenthesesSep^1*(ExpressionEntreParentheses*argument^0)^0)*Espace,
		ExpressionEntreParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
		ExpressionEntreCrochets=P{'['*(CaractereSansCrochets+V(1))^0*']'}
	}
	match(OptionsAxe,arg)
	local axe="\\draw "..optionsTikz.." (0,"..aYmin/y1cm..") -- (0,"..aYmax/y1cm+upspace..
	") node [above] {$"..Cmath2LaTeX(label).."$};\n"
	if tick==true then
		local y
		for y=tickymin,tickymax+step/1e10,step do
			y=round(y,digits)
			if y~=0 or (zero==true) then
				axe=axe.."\\draw [thick] (2pt,"..y/y1cm..")--(-2pt,"..y/y1cm..") node ["..position.."] {\\small "
				if trig==true and y~=0 then
					local signe_p=""
					local p,q
					p,q=rational(y/math.pi,1e-3)
					if p<0 then 
						signe_p="-"
						p = -p
					end
					if q==1 then
						if p==1 then
							axe=axe.."$"..signe_p.."\\pi$};\n"
						else
							axe=axe.."$"..signe_p..string.format("%.0f", p).."\\pi$};\n"
						end
					else
						if p==1 then
							axe=axe.."$"..signe_p.."\\frac{\\pi}{"..string.format("%.0f", q).."}$};\n"
						else
							axe=axe.."$"..signe_p.."\\frac{"..string.format("%.0f", p).."\\pi}{"..string.format("%.0f", q).."}$};\n"
						end
					end
				else
					axe=axe.."$"..string.format("%."..nbdigits(y,digits).."f", y).."$};\n"
					--axe=axe.."$"..tostring(x).."$};\n"
				end
			end		
		end
	end
	return axe
end

function tikzPoint(arg)
	local position="above"
	local x,y,z,a,tFunction
	local size=1.5
	local name=""
	local tType=""
	local pointColor='black'
	local labelColor='black'
  local label=""
	-- grammaire des arguments
	local Options, Option, argument = V'Options', V'Option', V'argument'
	local ExpressionEntreParentheses=V'ExpressionEntreParentheses'
	local ExpressionEntreCrochets=V'ExpressionEntreCrochets'
	local OptionsPoint = P { Options,
		Options = C(Option * Cg(P(SepListe) * Option)^0),
		Option = P'variable'*Egal*C(argument)/function(...) a=eval(...) end 
				+ P'function'*Egal*C(argument)/function(...) tFunction=... end
				+ P'x'*Egal*C(argument)/function(...) x=eval(...) end 
				+ P'y'*Egal*C(argument)/function(...) y,z=eval(...) end
				--+ C(ExpressionEntreCrochets)/function(...) optionsTikz=... end
				+ P'size'*Egal*C(argument)/function(...) size=eval(...) end
				+ P'pointColor'*Egal*C(argument)/function(...) pointColor=... end
				+ P'labelColor'*Egal*C(argument)/function(...) labelColor=... end
				+ P'position'*Egal*C(argument)/function(...) position=... end
				+ P'label'*Egal*C(argument^1)/function(...) label=... end
				+ P'type'*Egal*C(argument)/function(...) tType=... end
				+ P'name'*Egal*C(argument)/function(...) name=... end,
		argument=(CaractereSansParenthesesSep^1*(ExpressionEntreParentheses*argument^0)^0)*Espace,
		ExpressionEntreParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
		ExpressionEntreCrochets=P{'['*(CaractereSansCrochets+V(1))^0*']'},
	}
	match(OptionsPoint,arg)
	if a~=nil then
		-- point sur courbe
		x,y=_G[tFunction](a)
		if y==nil then
			if tType=="polar" then
				y=x*sin(a)
				x=x*cos(a)
			else
				y=x
				x=a
			end
		end
	end	
	--print(x,y)
	if z~=nil then -- courbe paramétrée
		y=z
	end
	local point=""
	if name~="" then
		point="\\coordinate ("..name..") at ("..x/x1cm..","..y/y1cm..");\n"
	end
	if size~=0 then
		point=point.."\\fill ["..pointColor..",even odd rule] ("..x/x1cm..","..y/y1cm..") circle ("..
		size.."pt) circle ("..size/2 .."pt);\n"
		point=point.."\\fill["..pointColor.."!50] ".." ("..x/x1cm..","..y/y1cm..") circle ("..size/2 .."pt);\n"
	end
  if label~="" then
    point=point.."\\draw ["..labelColor.."] ("..x/x1cm..","..y/y1cm..") node ["..position.."] {$"..Cmath2LaTeX(label).."$};\n"
  end
	return point
end

function tikzTangent(arg)
	local a, tFunction
	local k=1
	local direction=1
	local tXmin, tXmax=nil, nil
	local tType=""
	local optionsTikz=""
	local label=""
	local position="above"
	-- grammaire des arguments
	local Options, Option, argument = V'Options', V'Option', V'argument'
	local ExpressionEntreParentheses=V'ExpressionEntreParentheses'
	local ExpressionEntreCrochets=V'ExpressionEntreCrochets'
	local OptionsAxe = P { Options,
		Options = C(Option * Cg(P(SepListe) * Option)^0),
		Option = P'variable'*Egal*C(argument)/function(...) a=eval(...) end 
				+ P'function'*Egal*C(argument)/function(...) tFunction=... end
				+ P'k'*Egal*C(argument)/function(...) k=eval(...) end
				+ P'direction'*Egal*C(argument)/function(...) direction=eval(...) end
				+ P'xmin'*Egal*C(argument)/function(...) tXmin=eval(...) end
				+ P'xmax'*Egal*C(argument)/function(...) tXmax=eval(...) end
				+ P'position'*Egal*C(argument)/function(...) position=... end
				+ P'type'*Egal*C(argument)/function(...) tType=... end
				+ P'label'*Egal*C(argument^1)/function(...) label=... end				
				+ C(ExpressionEntreCrochets)/function(...) optionsTikz=... end,
		argument=(CaractereSansParenthesesSep^1*(ExpressionEntreParentheses*argument^0)^0)*Espace,
		ExpressionEntreParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
		ExpressionEntreCrochets=P{'['*(CaractereSansCrochets+V(1))^0*']'}
	}
	match(OptionsAxe,arg)
	if direction<0 then 
		direction=-1
	else
		direction=1
	end
	local x,y=_G[tFunction](a)
	local dxp,dyp=derivee(a,_G[tFunction],direction)
	local dxm,dym=0,0
	if y==nil then
		if tType=="polar" then
			y=x*sin(a)
			x=x*cos(a)
			dxp=dyp*cos(a)-direction*y
			dyp=dyp*sin(a)+direction*x
		else
			y=x
			x=a
		end
	end
	if tXmin~=nil then
		dxm=x-tXmin
		dym=dyp*dxm/dxp
	end
	if tXmax~=nil then
		dyp=dyp*(tXmax-x)/dxp
		dxp=(tXmax-x)
	end
	if label~='' then label=Cmath2LaTeX(label) end
	local tangent="\\draw "..optionsTikz.." ("..(x-dxm*k)/x1cm..","..(y-dym*k)/y1cm..") -- ("..(x+dxp*k)/x1cm..","..(y+dyp*k)/y1cm..") node [midway,"..position.."] {$"..label.."$};\n"
	return tangent
end

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

function nbdigits(x,digits)
	-- élimine les zéros inutiles jusqu'à digits chiffres après la virgule
	local n=0
	while round(x,n)~=x and n<digits do
		n=n+1
	end
	return string.format("%.0f",n)
end

function rational(x,eps)
--Retourne le rationnel qui approxime 'x' tel que 'abs(p/q-x)<=ep'
  local q=1
  local p
  while (math.abs(round(q*x)-q*x)>eps) do
	q=q+1
  end
  return round(q*x),q
end

function derivee(t,f,direction)
-- renvoie les coordonnées du vecteur dérivée de f en t
	local x,y,x2,y2
	local eps=10^-10
	x,y=f(t)
	x2,y2=f(t+direction*eps)
	if y~=nil then
		-- paramétrique
		return (x2-x)/eps,(y2-y)/eps
	else
		return direction,(x2-x)/eps
	end
end

-- crée une liste de coordonnées 3D utilisable avec PGFplots
function pgfPlot3(arg)
	local pVariable="x"
	local pFunction
	local pxDomaine,pyDomaine,pxSamples, pySamples
	local optionsPGF
	-- grammaire des arguments
	local Options, Option, argument = V'Options', V'Option', V'argument'
	local ExpressionEntreParentheses=V'ExpressionEntreParentheses'
	local ExpressionEntreCrochets=V'ExpressionEntreCrochets'
	local OptionsPlot = P { Options,
		Options = C(Option * Cg(P(SepListe) * Option)^0),
		Option = P'function'*Egal*C(argument)/function(...) pFunction=... end
				+  P'xdomain'*Egal*C(argument)/function(...) pxDomaine=... end
				+  P'ydomain'*Egal*C(argument)/function(...) pyDomaine=... end
				+  P'xsamples'*Egal*C(argument)/function(...) pxSamples=... end
				+  P'ysamples'*Egal*C(argument)/function(...) pySamples=... end
				+  C(ExpressionEntreCrochets)/function(...) optionsPGF=... end,
		argument=(CaractereSansParenthesesSep^1*(ExpressionEntreParentheses*argument^0)^0)*Espace,
		ExpressionEntreParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
		ExpressionEntreCrochets=P{'['*(CaractereSansCrochets+V(1))^0*']'}
	}
	match(OptionsPlot,arg)
	--print(variable,type,fonction,domaine,samples)
	local xmin,ymin,xmax,ymax
	if pxDomaine~=nil then
		local patDomain=C(P(1-P':')^1)/function(...) xmin=eval(...) end*P':'*C(P(1-P':')^1)/function(...) xmax=eval(...) end
		match(patDomain,pxDomaine)
	else
		xmin=-5
		xmax=5
	end
	if pyDomaine~=nil then
		local patDomain=C(P(1-P':')^1)/function(...) ymin=eval(...) end*P':'*C(P(1-P':')^1)/function(...) ymax=eval(...) end
		match(patDomain,pyDomaine)
	else
		ymin=xmin
		ymax=xmax
	end
	if pFunction==nil then pFunction=0 end
	if pxSamples==nil then pxSamples=10 end
	if pySamples==nil then pySamples=pxSamples end
	local code_fonction = "f_draw_pgf =".. pFunction
	assert(load(code_fonction))()
	local x,y,x_f,y_f,z_f
	local coordinates="\\addplot3 "..optionsPGF.." coordinates {"
	local stepx,stepy
	if pxSamples==1 then
		xstep=0
	else
		xstep=(xmax-xmin)/(pxSamples-1)
	end
	if pySamples==1 then
		ystep=0
	else
		ystep=(ymax-ymin)/(pySamples-1)
	end
	--print("xdomaine="..pxDomaine.." xmin="..xmin.." f="..x_f)
	for y=ymin,ymax,ystep do
		coordinates=coordinates.."\n"
		for x=xmin,xmax,xstep do
			x_f,y_f,z_f=f_draw_pgf(x,y)
			coordinates=coordinates.."("..x_f..","..y_f..","..z_f..") "		
		end
		coordinates=coordinates.."\n"	
	end
	coordinates=coordinates.."};"
	return coordinates
end

--[[
-- debug
Formule="1/2"
Arbre=match(Cmath2Tree,Formule)
if not Arbre then 
	print("Erreur de syntaxe")
else
print('Arbre')
AfficheArbre(Arbre,0)
print('\nLatex')
l=Tree2Latex(Arbre)
print(l)
print('\nTW')
Arbre=match(Cmath2Tree,Formule)
l=Tree2TW(Arbre)
print(l)
end
]]--
