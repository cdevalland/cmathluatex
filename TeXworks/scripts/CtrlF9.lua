--[[TeXworksScript
Title: Formule Cmath (mode texte) -> LaTeX
Shortcut: Ctrl+F9
Description: Convertit la formule Cmath au format $LaTeX$
Author: Christophe Devalland
Version: 1
Date: 2014-12-25
Script-Type: standalone
Context: TeXDocument
]]

-- renvoie le chemin d'accès au répertoire des scripts
local cheminScriptsTexWorks=TW.script.fileName
local i=-1
while(string.sub(cheminScriptsTexWorks,i,i)~='/') do
	i=i-1
end
cheminScriptsTexWorks=(string.sub(cheminScriptsTexWorks,1,string.len(cheminScriptsTexWorks)+i+1))
dofile(cheminScriptsTexWorks.."CmathTeXworks.lua")
dofile(cheminScriptsTexWorks.."CmathLuaTeX.lua")
creeFormule("CtrlF9")
