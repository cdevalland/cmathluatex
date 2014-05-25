-- Cmath pour LuaTeX
-- version 2014.05.09
-- Christophe Devalland
-- christophe.devalland@ac-rouen.fr
-- http://cdeval.free.fr
-- Packages nécessaires au bon fonctionnement :
-- \usepackage[e]{esvect} %Typesetting vectors with beautiful arrow


local lpeg = require "lpeg"
-- local table = require "table"
local write = io.write
match = lpeg.match
local C, P, R, S, V = lpeg.C, lpeg.P, lpeg.R, lpeg.S, lpeg.V
local Carg, Cc, Cp, Ct, Cs, Cg, Cf = lpeg.Carg, lpeg.Cc, lpeg.Cp, lpeg.Ct, lpeg.Cs, lpeg.Cg, lpeg.Cf

-- Syntaxe Cmath
local Espace = S(" \n\t")^0
local Guillemet=P('"')
local SepListe=C(S(',;'))
local Operateur=C(	P('<=>')+P('<=')+P('>=')+P('<>')+P('->')+S('=><')
				+	P(':en')+P('≈')
				+	P(':as')+P('⟼')
				+	P(':ap')+P('∈')
				+	P('...')
				+	P('|')
				+	P('⟶')
				+	P(':un')+P('∪')
				+	P(':it')+P('∩')
				+	P(':ro')+P('∘')
				+	P(':eq')+P('~')
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
				+	P('⩽')+P('⩾')
				+	P('≠ ')
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
							[':as']='\\longmapsto ', ['⟼']='\\longmapsto ',
							['->']='\\to ',	['⟶']='\\to ',
							['...']='\\dots ',
							['|']='|',
							[':un']='\\cup ', ['∪']='\\cup ',
							[':it']='\\cap ', ['∩']='\\cap ',
							[':ro']='\\circ ', ['∘']='\\circ ',
							[':eq']='\\sim ', ['~']='\\sim ',
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
							[':ni']='\\subsetneq ', ['⊄']='\\subsetneq '
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
							[':eq']='~',
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
							[':ni']='⊄'
						  }	
						  					  
local Chiffre=R("09")
local Partie_Entiere=Chiffre^1
local Partie_Decimale=(P(".")/",")*(Chiffre^1)
local Nombre = C(Partie_Entiere*Partie_Decimale^-1) * Espace
local Raccourci = 	C((P':al'+P'α')
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
					+ 	(P':xi'+P'ξ') +	(P':Xi'+P'Ξ')
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

local TSubstRaccourciLaTeX = {	[':al']='\\alpha ', ['α']='\\alpha ',
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
					[':oijk']='\\left(O\\,{;}\\,\\vv{\\imath}{,}\\,\\vv{\\jmath}\\,\\vv{k} \\right) ',
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
					[':i']='\\ ', ['і']='\\mathrm{i} ',
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

local Lettre = R("az")+R("AZ")					
local Mot=C(Lettre^1+P('∭')+P('∬')+P('∫')+P('√')) - Guillemet
local Op_LaTeX = C(P("\\")*Lettre^1) * Espace
local TermOp = C(S("+-")) * Espace
local FactorOp = C(P("**")+S("* ")+P("×")+P("..")) * Espace
local DiviseOp = C(P("//")+P("/")+P("÷")) * Espace
local PuissanceOp = C(S("^")) * Espace
local IndiceOp = C(S("_")) * Espace
local Parenthese_Ouverte = P("(") * Espace
local Parenthese_Fermee = P(")") * Espace
local Accolade_Ouverte = P("{") * Espace
local Accolade_Fermee = P("}") * Espace
local Crochet = C(S("[]")) * Espace
local Intervalle_Entier_Ouvert = P("[[")+P("⟦")
local Intervalle_Entier_Ferme = P("]]")+P("⟧")
local Fonction_sans_eval = P("xcas")
local CaractereSansParentheses=(1-S"()")

-- Substitutions 
local TSubstCmath =		P'arcsin'/'\\arcsin '
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
					+	P'inf'/'\\inf '
					+	P'ln'/'\\ln '
					+	P'ch'/'\\ch '
					+	P'sh'/'\\sh '
					+	P'th'/'\\th '
					+	P'card'/'\\card '
					+	1

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
	return {op,arg1,arg2}
end

function fPuissance(arg1,op,arg2)
	return {op,arg1,arg2}
end

function fMultImplicite(arg1,arg2)
	if string.sub(arg1[1],1,5)=='signe' then
		return {arg1[1],{'imp*',arg1[2],arg2}}
	else
		return {'imp*',arg1,arg2}
	end
end

function fTexte(arg1)
	return {'text',arg1}
end

function fFonction_sans_eval(arg1,arg2,arg3,arg4)
	return {'no_eval',arg1,arg2}
end



function fListe(arg1,op,arg2)
	if arg2==nil then arg2={''} end
	if arg1[1]=='liste '..op then
		table.insert(arg1,arg2)
		return arg1
	else
		--print(arg1..op)
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
	return {'raccourci',arg1} --match(Cs(Raccourci),arg1)
end

function fFormule_signee(arg1,arg2)
   return {'signe '..arg1,arg2}
end


function fIntervalle_Entier(arg1)
	return {'⟦⟧',arg1}
end


local FonctionsCmath = 	P('abs')+ 			-- valeur absolue
						P('iiint')+P('∭')+	-- intégrale triple
						P('iint')+P('∬')+	-- intégrale double
						P('int')+P('∫')+	-- intégrale
						P('rac')+P('√')+	-- racine
						P('vec')+			-- vecteur ou coordonnées de vecteurs si liste
						P('cal')+P('scr')+P('frak')+P('pzc')+ -- polices
						P('ang')+
						P('til')+
						P('bar')+
						P('sou')+
						P('nor')+
						P('acc')+
						P('som')+
						P('pro')+
						P('uni')+
						P('ite')+
						P('psc')+
						P('acs')+
						P('aci')+
						P('cnp')+
						P('aut')+
						P('bif')+
						P('sys')
												

local TraitementFonctionsCmath = 
{ 	['abs']=
	function(arbre) 
		return '\\left\\vert{'..Tree2Latex(arbre)..'} \\right\\vert ' 
	end,

	['vec']=
	function(arbre) 
		return '\\vv{'..Tree2Latex(arbre)..'}' 
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
	
	['ang']=
	function(arbre) 
		return '\\widehat{'..Tree2Latex(arbre)..'}' 
	end,

	['til']=
	function(arbre) 
		return '\\widetilde{'..Tree2Latex(arbre)..'}' 
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
		return '\\prescript{'..Tree2Latex(arbre[4])..'}{'..Tree2Latex(arbre[5])..'}{'..Tree2Latex(arbre[1])..'}_{'..Tree2Latex(arbre[2])..'}^{'..Tree2Latex(arbre[3])..'}'
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

function fExpressionsXcas(arg1,arg2,arg3)
	return string.sub(arg1,1,arg1:len()-1)..string.sub(arg2,2)
end

function fFacteursXcas(arg1,arg2,arg3)
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
elseif (op=='//' or op=='÷') then
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
elseif (op=='^' or op=='_') then
	return Tree2Latex(Arbre[2])..op..'{'..Tree2Latex(Parentheses_inutiles(Arbre[3]))..'}'
elseif (op=='text') then
	return '\\textrm{'..Arbre[2]..'}'
elseif (op=='no_eval') then
	if Arbre[2]=='xcas' then
		return Giac(match(CommandesXcas,Arbre[3]))
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
--elseif (match(Operateur,op)) then
--	return Tree2Latex(Arbre[2])..TSubstOperateur[op]..Tree2Latex(Arbre[3])
elseif (op=='raccourci') then
	return TSubstRaccourciLaTeX[Arbre[2]]
else
	-- Repérer les fonctions usuelles
	return match(Cs(TSubstCmath^1),op)
	-- return op
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
elseif (op=='//' or op=='÷') then
	return Tree2TW(Arbre[2])..'÷'..Tree2TW(Arbre[3])		
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
elseif (op=='^' or op=='_' or op=='/' or op=='..' or op=='+' or op=='-' or op=='*' or op==' ') then
	return Tree2TW(Arbre[2])..op..Tree2TW((Arbre[3]))
elseif (op=='text') then
	return Arbre[2]
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
--elseif (match(Operateur,op)) then
--	return Tree2Latex(Arbre[2])..TSubstOperateur[op]..Tree2Latex(Arbre[3])
elseif (op=='raccourci') then
	arg2=TSubstRaccourciTW[Arbre[2]]
	if arg2==nil then arg2=Arbre[2] end
	return arg2
else
	--return match(Cs(TSubstCmath^1),op)
	return op
end
end


function Giac(formule)
local prg=[[
Sortie:=fopen("giac.out");
Resultat:=(instructions)->{
  local j,n;
  if (type(instructions)==DOM_LIST){
    n:=dim(instructions);
    for(j:=0;j<=n-2;j++)
      execute(instructions[j]);
    return(latex(eval(execute(instructions[n-1]))));
    }
  else {
    return(latex(execute(instructions)));
  }
}(]]..formule..[[);
fprint(Sortie,Unquoted,Resultat);
fclose(Sortie);
]]
local f,err = io.open("giac.in","w")
if not f then return print(err) end
f:write(prg)
f:close()
if QuelOs()=='linux' then
	os.execute("icas giac.in")
else --windows, à modifier pour identifier un Mac
	os.execute("c:\\xcas\\rxvt.exe c:/xcas/icas.exe giac.in")
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
function AfficheArbre(t,n)    
   for key,value in pairs(t) do
	   if type(t[key])=='table' then
			write(" {")
			AfficheArbre(t[key],n+string.len(t[key][1])+1)
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
		return(Tree2Latex(Arbre))
	end
end

-- Fonction appelée depuis TexWorks
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
