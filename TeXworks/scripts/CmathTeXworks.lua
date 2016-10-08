--[[
Author: Christophe Devalland
Version: 2016-03-05
]]

function estFormule(txt)
	local f=true
	local i,fonction
	for i,fonction in pairs({"GaussSysl","GaussRang","GaussInv","tikzPlot","tikzWindow","tikzGrid",
		"tikzAxeX","tikzAxeY","tikzAxeX","tikzAxeY","tikzPoint","tikzTangent","codeLua"}) do
		if string.find(txt,fonction)==1 then
			f=false
		end
	end
	return f
end

function creeFormule(touche)
	local txt = TW.target.selection
	if txt==nil then txt="" end
	local len = string.len(txt)
	local pos = TW.target.selectionStart
	local prefix={["F9"]="$",["MajF9"]="\\[",["CtrlF9"]="$",["MajCtrlF9"]="\\[",["AltF9"]=""}
	local suffix={["F9"]="$",["MajF9"]="\\]",["CtrlF9"]="$",["MajCtrlF9"]="\\]",["AltF9"]=""}
	-- selectionner si besoin
	if len==0 then 
		repeat 
			pos=pos-1
			len=len+1
			TW.target.selectRange(pos,len)
			txt = TW.target.selection
		until (pos==0 or string.match(txt,"[ \n\t]")~=nil)
		if pos>0 then
		pos=pos+1
		len=len-1
		end
		TW.target.selectRange(pos,len)
		txt = TW.target.selection
	end
	if txt~=nil then
		if estFormule(txt)==false then
			prefix[touche]=""
			suffix[touche]=""
		end
		if touche=="MajCtrlF9" or touche=="CtrlF9" then
			Formule=Cmath2LaTeXinTW(txt)
			pos = TW.target.selectionStart
			TW.target.selectRange(pos,len)
			TW.target.insertText(prefix[touche] .. Formule .. suffix[touche] .. " % Traduction CmathLuaTeX de : " .. txt)
		else	
			-- si déjà entouré de cmath, revenir en arrière
			if string.sub(txt,1,string.len(prefix[touche])+6)==prefix[touche]..'\\Cmath' then
				TW.target.insertText(string.sub(txt,string.len(prefix[touche])+8,string.len(txt)-string.len(suffix[touche])-1))
			else
				Formule=Cmath2TW(txt)
				pos = TW.target.selectionStart
				TW.target.selectRange(pos,len)
				TW.target.insertText(prefix[touche] .. '\\Cmath{'..Formule .. '}'..suffix[touche])
			end
		end
	end
end
