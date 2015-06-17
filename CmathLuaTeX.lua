--[[
Cmath pour LuaTeX, version 2015.06.17
    Copyright (C) 2014  Christophe Devalland (christophe.devalland@ac-rouen.fr)

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
--]]

local lpeg = require "lpeg"
local write = io.write
match = lpeg.match
local C, P, R, S, V = lpeg.C, lpeg.P, lpeg.R, lpeg.S, lpeg.V
local Carg, Cc, Cp, Ct, Cs, Cg, Cf = lpeg.Carg, lpeg.Cc, lpeg.Cp, lpeg.Ct, lpeg.Cs, lpeg.Cg, lpeg.Cf

-- Syntaxe Cmath
local Espace = S(" \n\t")^0
local Guillemet=P('"')
local SepListe=C(S(',;'))* Espace
local Operateur=C(	P('<=>')+P('<=')+P('>=')+P('<>')+P('->')+S('=><')
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
		+	P('⩽')+P('⩾')
		+	P('≠')
		) * Espace
				
local TSubstOperateurLaTeX = {	['<=>']='\\Leftrightarrow ', 
		['<=']='\\leqslant ',['⩽']='\\leqslant ',
		['>=']='\\geqslant ',['⩾']='\\geqslant ',
		['<>']='\\\neq ', ['≠']='\\neq ',
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
		[':re']='\\leftarrow ',['⟵']='\\leftarrow '
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
		[':xi']='\\xi ', ['ξ']='\\xi ',[':Xi']='\\Xi ', ['Ξ']='\\Xi ',
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
		[':e']='\\mathrm{e} ', ['е']='\\mathrm{e} ',
		[':i']='\\mathrm{i} ', ['і']='\\mathrm{i} ',
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
		[':e']='е',
		[':i']='і'	
		}

local Lettre = R("az")+R("AZ")+P("!")+P("'")+P("′")
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
local Fonction_sans_eval = P("xcas")+P("TVarP")+P("TVar")+P("TSig")+P("TVal")
local CaractereSansParentheses=(1-S"()")

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
		+	P'′'/"'"
		+	1

local TSubstCmathTW =	P"'"/'′' + 1	-- le symbole de la dérivation ne soit pas interférer avec l'indicateur de fin de chaîne

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
	elseif arg1[1]=='imp*' and arg1[2][1]=='√' then -- rétablir la multiplication implicite pour la racine carrée
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
		P('til')+					-- tilde
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


-- Grammaire Commandes Xcas
local Commandes, ExpressionsXcas, FacteursXcas = V"Commandes", V"ExpressionsXcas", V"FacteursXcas"
local CommandesXcas = P { Commandes,
  Commandes = Cf(ExpressionsXcas * Cg(P(",") * ExpressionsXcas)^0,fCommandes),
  ExpressionsXcas = Cf(FacteursXcas *Cg(FacteursXcas )^0,fExpressionsXcas),
  FacteursXcas = C((1-S'()[]{},')^1+V'ExpressionsXcasParentheses'+V'ExpressionsXcasAccolades'+V'ExpressionsXcasCrochets')/fFacteursXcas,
  ExpressionsXcasParentheses=P{'('*(CaractereSansParentheses+V(1))^0*')'},
  ExpressionsXcasAccolades=P{'{'*((1-S('{}'))+V(1))^0*'}'},
  ExpressionsXcasCrochets=P{'['*((1-S('[]'))+V(1))^0*']'}
}


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
		return arg1..'^{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}'
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
			return Giac("",Arbre[3],"true")
		end
	elseif Arbre[2]=='TVar' then
		return Giac(XCAS_Tableaux,'TVar('..Arbre[3]..')',"false")
	elseif Arbre[2]=='TSig' then
		return Giac(XCAS_Tableaux,'TSig('..Arbre[3]..')',"false")	
	elseif Arbre[2]=='TVarP' then
		return Giac(XCAS_Tableaux,'TVarP('..Arbre[3]..')',"false")
	elseif Arbre[2]=='TVal' then
		return Giac(XCAS_Tableaux,'TVal('..Arbre[3]..')',"false")
	else	
		return Arbre[2]..'("'..Arbre[3]..'")'
	end
elseif (op=='latex') then
	return Arbre[2]	
elseif (op=='liste ,' or op=='liste ;') then
	s=Tree2Latex(Arbre[2])
	sep='\\mathpunct{'..string.sub(op, -1)..'}'
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

function Giac(programme,instruction,latex)
-- exécute le programme sans conserver le retour
-- puis exécute l'instruction en renvoyant le résultat
-- conversion en latex selon le booléen latex (pas de conversion pour les tableaux de variations/signes)
local prg=[[
unarchive("giac.sav"):;
]]..programme..[[
purge(Resultat);
som:=sommet(quote(]]..instruction..[[));
if(som=='sto' or som=='supposons'){
  ]]..instruction..[[;
  Resultat:='""'} else {
  Resultat:=(]]..instruction..[[)};
if(Resultat=='Resultat'){
  Resultat:="Erreur Xcas"};
Sortie:=fopen("giac.out");
if(]]..latex..[[){
  fprint(Sortie,Unquoted,latex(Resultat));
} else {
  fprint(Sortie,Unquoted,Resultat);
};
fclose(Sortie);
archive("giac.sav"):;
]]
local f,err = io.open("giac.in","w")
if not f then return print(err) end
f:write(prg)
f:close()
if QuelOs()=='linux' then
	os.execute('icas giac.in')
else 
	-- c'est windows, à compléter pour identifier un Mac
	os.execute('\\xcas\\bash.exe -c "export LANG=fr_FR.UTF-8 ; /xcas/icas.exe giac.in"')
end
io.input("giac.out")
return(io.read("*all"))
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
			write(""..value.."")
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

XCAS_Tableaux=[[
initCas():={
  complex_mode:=0;
  complex_variables:=0;
  angle_radian:=1;
  all_trig_solutions:=1;
  reset_solve_counter(-1,-1);
  with_sqrt(1);
}:;

trigo(expression):={
// renvoie vrai si l'expression dépend d'un paramètre n_1 (solutions d'une équation trigo dans xcas)  
  if (subst(expression,n_1=0)==expression)
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
  for(k:=0;k<size(colonne);k++){
    if (k>0){s:=s+","};
    s:=s+colonne[k]+" / "+hauteurLigne[k];
  }  
  s:=s+"}\n{";
  for(k:=0;k<size(valX);k++){
    if (k>0){s:=s+","};
      if(type(nb_decimales)==DOM_INT and type(valX[k])==DOM_FLOAT){
        s:=s+"$"+latex(evalf(valX[k],nb_decimales))+"$";
      } else {
        s:=s+"$"+latex(valX[k])+"$";
      }
  }
  s:=s+"}\n";
  return(s);
}:;

trouveVI(IE,f):={
  local k,s,o,n,listeVI:=[];
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

Elague(IE,liste):={
  local nliste,nIE,k,listeelaguee,expression,m,mini,maxi;
  listeelaguee:=[];
  nliste:=size(liste);
  nIE:=size(IE);
  mini:=IE[0];maxi:=IE[nIE-1];
  for(k:=0;k<nliste;k++){
    expression:=liste[k];
    if (trigo(expression)) {
      m:=0;
      while(subst(expression,n_1=m)<=maxi and subst(expression,n_1=m)>=mini) {
        listeelaguee:=concat(listeelaguee,simplify(subst(expression,n_1=m)));
        m:=m+1;
      };
      m:=-1;
      while(subst(expression,n_1=m)<=maxi and subst(expression,n_1=m)>=mini) {
        listeelaguee:=concat(listeelaguee,simplify(subst(expression,n_1=m)));
        m:=m-1;
      }
    } else {
      if(expression>mini and expression<maxi){
        listeelaguee:=concat(listeelaguee,expression);
      }
    }
    
  }
  return(sort(listeelaguee));
}:;

trouveZeros(IE,f):={
  local n:=size(IE);
  local Z,err,k;
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
  for(k:=0;k<=nIE-2;k++){
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
  if(type(nb_decimales)!=DOM_INT){
    images:=[ [infinity,simplifier(limite(f(x),x,IE[0],1))] ];
  } else {
    images:=[ [infinity,evalf(limite(f(x),x,IE[0],1),nb_decimales)] ];
  }

  for(k:=1;k<=nIE-2;k++){
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
          if (k==0){// impossible de mettre DH en première colonne
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
        if (sg==""){// impossible de mettre D
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
        sTkzTabVar:=sTkzTabVar+" / $"+latex(images[0][1])+"$";        
      } else {
        sTkzTabVar:=sTkzTabVar+" / $"+latex(images[k][0])+"$";      
      }
    } else {
    if(left(pos,1)=="-" or left(pos,1)=="+"){
      if(k==0){
        sTkzTabVar:=sTkzTabVar+"/ ";        
      } else {
       sTkzTabVar:=sTkzTabVar+" / $"+latex(images[k][0])+"$";      
      }
    };
    if(right(pos,1)=="-" or right(pos,1)=="+"){
      if(k==n-1){
        sTkzTabVar:=sTkzTabVar+"/ ";        
      } else {
        sTkzTabVar:=sTkzTabVar+" / $"+latex(images[k][1])+"$";      
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
      sTkzTabIma:=sTkzTabIma+"{$"+latex(images[k][0])+"$}\n";
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

identifier(expression):={
  //renvoie [fonction, [nom variable,nom variable latex], [nom fonction, nom fonction latex],
  // [nom dérivée, nom dérivée latex] ] au format LaTeX
  local x,membres,g,d,fonc,variable,commande;
  if (sommet(expression)=='='){
    membres:=op(expression);
    g:=membres[0];
    d:=membres[1];
    fonc:=op(g)[0];
    variable:=op(g)[1];
    commande:="unapply(d,"+variable+")";
    return([execute(commande),[variable,latex(variable)],[fonc,latex(fonc)],[fonc+"'",latex(fonc)+"'"] ]);
  } else {
  return([unapply(expression,x),["x","x"],["x->"+expression,"x\\mapsto "+latex(expression)],["(x->"+expression+")'","\\left( x\\mapsto "+latex(expression)+"\\right) '"] ])
  }
}:;

listeFacteurs(expression):={
  local k,s,o;
  local numerateur;
  local denominateur:=[];
  o:=[op(expression)];
  s:=sommet(expression);
  if (s=='*'){
    numerateur:=o;
  } else {
    numerateur:=[expression];
  }
  // extraire le dénominateur et regrouper les facteurs constants
  for(k:=0;k<size(numerateur);k++){
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
          sTkzTabLine:=sTkzTabLine+latex(signes[k]);
        } else {
          sTkzTabLine:=sTkzTabLine+latex(evalf(signes[k],nb_decimales));
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
local Variations_f; // liste des variations de f
local sTkzTabVar; // ligne des variations de f
local Images_f; // liste des images de f
local NoeudsNonExtrema_f; // liste des images de f qui ne sont pas des extrema
local sTkzTabIma; // lignes des images de f
local k,n,j;
local id_fonction, nom_variable, nom_fonction, nom_derivee;
local a;
local IE:=arguments[0];
local f:=arguments[1];
local nb_decimales;
if (size(arguments)==3){
  nb_decimales:=arguments[2];
} else {
  nb_decimales:="";
}
initCas();
id_fonction:=identifier(f);
f:=id_fonction[0];
nom_variable:=id_fonction[1][1];
nom_fonction:=id_fonction[2][1];
nom_derivee:=id_fonction[3][1];
//unapply(f,x);
fp:=function_diff(f);
IE:=trier(IE);
VI:=trouveVI(IE,f(x));
ValeursX:=insereValeurs(IE,VI);
Zeros_fp:=trouveZeros(IE,fp);
Zeros_fp:=sontDefinies(f,Zeros_fp);
ValeursX:=insereValeurs(ValeursX,Zeros_fp);
ValeursX:=trier([op(set[op(ValeursX)])]);
ValeursX:=simplifier(ValeursX);
// construction de la structure du tableau
sTkzTab:=debutTableau(["$"+nom_variable+"$","$"+nom_derivee+"("+nom_variable+")"+"$","$"+nom_fonction+"$"],[1,1,2],ValeursX,nb_decimales);
// construction du signe de f'
Signes_fp:=tabSignes(ValeursX,fp,f);
sTkzTabLine:=ligneSignes(Signes_fp);
sTkzTab+=sTkzTabLine;
// construction des variations de f
Images_f:=calculeImages(ValeursX,f,nb_decimales);
Variations_f:=calculePosition(ValeursX,VI,f,Images_f);
print(ValeursX,VI,f,Images_f);
sTkzTabVar:=ligneVariations(Variations_f,Images_f);
sTkzTab+=sTkzTabVar;
// construction des images de f
NoeudsNonExtrema_f:=noeudsNonExtrema(Variations_f);
sTkzTabIma:=lignesImages(NoeudsNonExtrema_f,Images_f);
sTkzTab+=sTkzTabIma;
sTkzTab+="\\end{tikzpicture}\n";
return(sTkzTab);
}:;

TSig(IE,f):={
// IE=intervalle d'étude
// f=fonction
local VI; // liste des valeurs interdites de f
local Zeros_f; // liste des racines de f
local ValeursX; // liste des valeurs de x à faire apparaître dnas la 1ère ligne
local sTkzTab; // ce qui sera renvoyé vers LuaTeX
local Signes; // liste des signes des facteurs de f
local sTkzTabLine; // lignes des signes des facteurs de f
local Images_f; // liste des images de f
local facteur, facteurs; // de f
local colonne; // contenu de la première colonne
local hauteurs_lignes;
local id_fonction, nom_variable, nom_fonction;
local k;
local denominateur;

initCas();
id_fonction:=identifier(f);
f:=id_fonction[0];
nom_variable:=id_fonction[1][0];
nom_fonction:=id_fonction[2][0];
IE:=trier(IE);
VI:=trouveVI(IE,f(x));
ValeursX:=insereValeurs(IE,VI);
Zeros_f:=trouveZeros(IE,f);
ValeursX:=insereValeurs(ValeursX,Zeros_f);
ValeursX:=simplifier(ValeursX);
facteurs:=execute("listeFacteurs(f("+nom_variable+"))");
if (size(facteurs[1])>0){
  // il y a un dénominteur, augmenter la hauteur de la dernière ligne
  denominateur:=vrai;
} else {
  denominateur:=faux;
}
facteurs:=op(facteurs[0]),op(facteurs[1]);
if (size(facteurs)==1){ facteurs:=NULL };
// construction de la structure du tableau
colonne:=append([nom_variable],facteurs);
if(type(nom_fonction)==DOM_STRING){
  colonne:=append(colonne,"$\\displaystyle "+latex(f(x))+"$");
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
for(k:=0;k<size(facteurs);k++){
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
local VI_f; // liste des valeurs interdites de f
local VI_g; // liste des valeurs interdites de g
local fp; // f'
local gp; // g'
local Zeros_fp; // liste des racines de f'
local Zeros_gp; // liste des racines de g'
local ValeursX; // liste des valeurs de x à faire apparaître dnas la 1ère ligne
local sTkzTab; // ce qui sera renvoyé vers LuaTeX
local Signes_fp; // liste des signes de f'
local Signes_gp; // liste des signes de g'
local Variations_f; // liste des variations de f
local Variations_g; // liste des variations de g
local Images_f; // liste des images de f
local Images_g; // liste des images de g
local NoeudsNonExtrema_f; // liste des images de f qui ne sont pas des extrema
local NoeudsNonExtrema_g; // liste des images de g qui ne sont pas des extrema
local sTkzTabLine; // ligne des signes de f' ou g'
local sTkzTabVar; // ligne des variations de f ou g
local sTkzTabIma; // lignes des images de f ou g
local k,n,j;
local id_fonction_f, nom_variable_f, nom_fonction_f, nom_derivee_f;
local id_fonction_g, nom_variable_g, nom_fonction_g, nom_derivee_g;

local IE:=arguments[0];
local f:=arguments[1];
local g:=arguments[2];
local nb_decimales;
if (size(arguments)==4){
  nb_decimales:=arguments[3];
} else {
  nb_decimales:="";
}
initCas();
id_fonction_f:=identifier(f);
f:=id_fonction_f[0];
nom_variable_f:=id_fonction_f[1][1];
nom_fonction_f:=id_fonction_f[2][1];
nom_derivee_f:=id_fonction_f[3][1];
id_fonction_g:=identifier(g);
g:=id_fonction_g[0];
nom_variable_g:=id_fonction_g[1][1];
nom_fonction_g:=id_fonction_g[2][1];
nom_derivee_g:=id_fonction_g[3][1];
fp:=function_diff(f);
gp:=function_diff(g);
IE:=trier(IE);
VI_f:=trouveVI(IE,f(x));
ValeursX:=insereValeurs(IE,VI_f);
VI_g:=trouveVI(IE,g(x));
ValeursX:=insereValeurs(ValeursX,VI_g);
Zeros_fp:=trouveZeros(IE,fp);
Zeros_fp:=sontDefinies(f,Zeros_fp);
ValeursX:=insereValeurs(ValeursX,Zeros_fp);
Zeros_gp:=trouveZeros(IE,gp);
Zeros_gp:=sontDefinies(g,Zeros_gp);
ValeursX:=insereValeurs(ValeursX,Zeros_gp);
ValeursX:=trier([op(set[op(ValeursX)])]);
ValeursX:=simplifier(ValeursX);
// construction de la structure du tableau
sTkzTab:=debutTableau(["$"+nom_variable_f+"$",
      "$"+nom_derivee_f+"("+nom_variable_f+")"+"$","$"+nom_fonction_f+"$",
      "$"+nom_fonction_g+"$","$"+nom_derivee_g+"("+nom_variable_g+")"+"$"],
      [1,1,2,2,1],ValeursX,nb_decimales);
// construction du signe de f'
Signes_fp:=tabSignes(ValeursX,fp,f);
sTkzTabLine:=ligneSignesTVP(Signes_fp,nb_decimales);
sTkzTab+=sTkzTabLine;
// construction des variations de f
Images_f:=calculeImages(ValeursX,f,nb_decimales);
Variations_f:=calculePosition(ValeursX,VI_f,f,Images_f);
sTkzTabVar:=ligneVariations(Variations_f,Images_f);
sTkzTab+=sTkzTabVar;
// construction des images de f
NoeudsNonExtrema_f:=noeudsNonExtrema(Variations_f);
sTkzTabIma:=lignesImages(NoeudsNonExtrema_f,Images_f);
sTkzTab+=sTkzTabIma;
// construction des variations de g
Images_g:=calculeImages(ValeursX,g,nb_decimales);
Variations_g:=calculePosition(ValeursX,VI_g,g,Images_g);
sTkzTabVar:=ligneVariations(Variations_g,Images_g);
sTkzTab+=sTkzTabVar;
// construction des images de g
NoeudsNonExtrema_g:=noeudsNonExtrema(Variations_g);
sTkzTabIma:=lignesImages(NoeudsNonExtrema_g,Images_g);
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
local id_fonction_f, nom_variable_f, nom_fonction_f, nom_derivee_f;
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
id_fonction_f:=identifier(f);
f:=id_fonction_f[0];
nom_variable_f:=id_fonction_f[1][0];
nom_fonction_f:=id_fonction_f[2][0];
n:=size(IE);
s:=s+string(n)+"}{C{1cm}|}}\n\\hline $"+nom_variable_f+"$ & ";
for(k:=0;k<n-1;k++){
  s:=s+"$\\displaystyle "+latex(simplifier(IE[k]))+"$ &";
}
s:=s+"$\\displaystyle "+latex(simplifier(IE[k]))+"$ \\\\\n\\hline $"
if(type(nom_fonction_f)==DOM_STRING){
  s:=s+"\\displaystyle "+latex(f(x))+"$ & ";
} else {
  s:=s+id_fonction_f[2][1]+"("+id_fonction_f[1][1]+")$ & ";
}
for(k:=0;k<n-1;k++){
  if(type(nb_decimales)!=DOM_INT){
    s:=s+"$\\displaystyle "+latex(simplifier(f(IE[k])))+"$ &";
  } else {
    s:=s+"$\\displaystyle "+latex(format(f(IE[k]),"f"+string(nb_decimales)))+"$ &";
  }
}
if(type(nb_decimales)!=DOM_INT){
  s:=s+"$\\displaystyle "+latex(simplifier(f(IE[k])))+"$ \\\\\n\\hline\n\\end{tabular}}";
} else {
  s:=s+"$\\displaystyle "+latex(format(f(IE[k]),"f"+string(nb_decimales)))+"$ \\\\\n\\hline\n\\end{tabular}}";
}
return(s);
}:;

purge(x);
]]
