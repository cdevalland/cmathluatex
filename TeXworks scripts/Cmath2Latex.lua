--[[TeXworksScript
Title: Document Cmath -> Document LaTeX
Description: Convertit toutes les formules Cmath au format LaTeX dans un nouveau document
Author: Christophe Devalland
Version: 1
Date: 2014-12-25
Script-Type: standalone
Context: TeXDocument
]]

local lpeg = require "lpeg"
match = lpeg.match
local C, P, R, S, V = lpeg.C, lpeg.P, lpeg.R, lpeg.S, lpeg.V
local Carg, Cc, Cp, Ct, Cs, Cg, Cf = lpeg.Carg, lpeg.Cc, lpeg.Cp, lpeg.Ct, lpeg.Cs, lpeg.Cg, lpeg.Cf
function cheminCmathLuaTeX()
-- renvoie le chemin d'accès à CmathLuaTeX présent dans le répertoire des scripts
local chemin=TW.script.fileName
local i=-1
while(string.sub(chemin,i,i)~='/') do
	i=i-1
end
chemin=(string.sub(chemin,1,string.len(chemin)+i+1))..'CmathLuaTeX.lua'
return chemin
end
dofile(cheminCmathLuaTeX())
local ExpressionsEntreAccolades=P{'{'*((1-S('{}'))+V(1))^0*'}'}
local FormuleCmath=(P'$\\Cmath{'/'$'+P'\\[\\Cmath{'/'\\['+P'\\Cmath{'/'')*((((1-S('{}'))+ExpressionsEntreAccolades)^0)/Cmath2LaTeXinTW)*(P'}$'/'$'+P'}\\]'/'\\]'+P'}'/'')
local txt = TW.target.text
local targetDocument = TW.app.newFile()
-- recherche formules Cmath et traduction LaTeX
targetDocument.insertText(match(Cs((FormuleCmath+C(1))^0),txt))
