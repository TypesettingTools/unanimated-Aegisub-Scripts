script_name="Masquerade"
script_description="Masquerade"
script_author="unanimated"
script_version="2.01"

-- \ko has been removed. much improved version is in 'Apply fade'. alpha shift does a similar thing differently.

--[[

Create Mask
	Creates a mask with the selected shape.
	"create mask on a new line" does te obvious and raises the layer of the current line by 1.

Shift Tags
	Allows you to shift tags by character or by word.
	For the first block, single tags can be moved right.
	For inline tags, each block can be moved left or right.

an8 / q2 (obvious)

Mocha Scale
	Recalculates fscx and fscy for a given font size.
	"tag end" is an option to add the tags at the end of the line instead of beginning.

alpha shift
	Makes text appear letter by letter on frame-by-frame lines using alpha&HFF& like this:
	{alpha&HFF&}text
	t{alpha&HFF&}ext
	te{alpha&HFF&}xt
	tex{alpha&HFF&}t
	text

Alpha Time
	Either select lines that are already timed for alpha timing and need alpha tags, or just one line that needs to be alpha timed.
	In the GUI, split the line by hitting Enter where you want the alpha tags.
	Alpha Text is for when yuo have the lines already timed and just need the tags.
	Alpha Time is for one line. It will be split to equally long lines with alpha tags added.
	If you add "@" to your line first, alpha tags will replace the @, and no GUI will pop up.
	Example text:	This @is @a @test.

Strikealpha
	Replaces strikeout or underline tags with \alpha&H00& or \alpha&HFF&. Also @.
	@	->	{\alpha&HFF&}
	@0	->	{\alpha&H00&}
	{\u1}	->	{\alpha&HFF&}
	{\u0}	->	{\alpha&H00&}
	{\s0}	->	{\alpha&HFF&}
	{\s1}	->	{\alpha&H00&}
	@E3@	->	{\alpha&HE3&}

--]]

function addmask(subs, sel)
	for i=#sel,1,-1 do
	    local l=subs[sel[i]]
	    text=l.text
	    l1=l
	    l1.layer=l1.layer+1
	    if res.masknew then
		if res.mask=="from clip" then
		if not text:match("\\clip") then
		  aegisub.dialog.display({{class="label",label="No clip...",x=1,y=0,width=5,height=2}},{"OK"},{close='OK'}) aegisub.cancel()
		end
		l1.text=l1.text:gsub("\\clip%(([^%)]-)%)","") :gsub("{}","") end
		subs.insert(sel[i]+1,l1) 
	    end
	    l.layer=l.layer-1
	    if text:match("\\2c") then mcol="\\c"..text:match("\\2c(&H[%x]+&)") else mcol="" end
		
		if res.mask=="from clip" then
		  text=text:gsub("\\clip%(([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)","\\clip(m %1 %2 l %3 %2 %3 %4 %1 %4)")
		  if text:match("\\move") then text=text:gsub("\\move","\\pos") mp="\\move" else mp="\\pos" end
		  ctext=text:match("clip%(m ([%d%.%a%s%-]+)")
		  if text:match("\\pos") then
		    pos=text:match("\\pos(%([^%)]+%))")
		    local xx,yy=text:match("\\pos%(([%d%.%-]+),([%d%.%-]+)")
		    xx=round(xx) yy=round(yy)
		    ctext2=ctext:gsub("([%d%.%-]+)%s([%d%.%-]+)",function(a,b) return a-xx.." "..b-yy end)
		  else pos="(0,0)" ctext2=ctext
		  end
		  ctext2=ctext2:gsub("([%d%.]+)",function(a) return round(a) end)
		  l.text="{\\an7\\blur1\\bord0\\shad0\\fscx100\\fscy100"..mcol..mp..pos.."\\p1}m "..ctext2
		  
		else
		atags=""
		org=l.text:match("\\org%([%d%,%.%-]-%)")	if org~=nil then atags=atags..org end
		frz=l.text:match("\\frz[%d%.%-]+")	if frz~=nil then atags=atags..frz end
		frx=l.text:match("\\frx[%d%.%-]+")	if frx~=nil then atags=atags..frx end
		fry=l.text:match("\\fry[%d%.%-]+")	if fry~=nil then atags=atags..fry end
		
		
		l.text=l.text:gsub(".*(\\pos%([%d%,%.%-]-%)).*","%1")
		if l.text:match("\\pos")==nil then l.text="" end
		
		if res["mask"]=="square" then
		  l.text="{\\an5\\bord0\\blur1"..l.text..mcol.."\\p1}m 0 0 l 100 0 100 100 0 100"
		end
		if res["mask"]=="rounded square" then
		  l.text="{\\an7\\bord0\\blur1"..l.text..mcol.."\\p1}m -100 -25 b -100 -92 -92 -100 -25 -100 l 25 -100 b 92 -100 100 -92 100 -25 l 100 25 b 100 92 92 100 25 100 l -25 100 b -92 100 -100 92 -100 25 l -100 -25"
		end
		if res["mask"]=="rounded square 2" then
		  l.text="{\\an7\\bord0\\blur1"..l.text..mcol.."\\p1}m -100 -60 b -100 -92 -92 -100 -60 -100 l 60 -100 b 92 -100 100 -92 100 -60 l 100 60 b 100 92 92 100 60 100 l -60 100 b -92 100 -100 92 -100 60 l -100 -60"
		end
		if res["mask"]=="rounded square 3" then
		  l.text="{\\an7\\bord0\\blur1"..l.text..mcol.."\\p1}m -100 -85 b -100 -96 -96 -100 -85 -100 l 85 -100 b 96 -100 100 -96 100 -85 l 100 85 b 100 96 96 100 85 100 l -85 100 b -96 100 -100 96 -100 85 l -100 -85"
		end
		if res["mask"]=="circle" then
		  l.text="{\\an7\\bord0\\blur1"..l.text..mcol.."\\p1}m -100 -100 b -45 -155 45 -155 100 -100 b 155 -45 155 45 100 100 b 46 155 -45 155 -100 100 b -155 45 -155 -45 -100 -100"
		end
		if res["mask"]=="equilateral triangle" then
		  l.text="{\\an7\\bord0\\blur1"..l.text..mcol.."\\p1}m -122 70 l 122 70 l 0 -141"
		end
		if res["mask"]=="right-angled triangle" then
		  l.text="{\\an7\\bord0\\blur1"..l.text..mcol.."\\p1}m -70 50 l 180 50 l -70 -100"
		end
		if res["mask"]=="alignment grid" then
		  l.text="{\\an7\\bord0\\shad0\\blur0.6"..l.text..atags.."\\p1\\c&H000000&\\alpha&H80&}m -500 -199 l 500 -199 l 500 -201 l -500 -201 m -701 1 l 700 1 l 700 -1 l -701 -1 m -500 201 l 500 201 l 500 199 l -500 199 m -1 -500 l 1 -500 l 1 500 l -1 500 m -201 -500 l -199 -500 l -199 500 l -201 500 m 201 500 l 199 500 l 199 -500 l 201 -500 m -150 -25 l 150 -25 l 150 25 l -150 25"
		end
		if res["mask"]=="alignment grid 2" then
		  l.text="{\\an7\\bord0\\shad0\\blur0.6"..l.text..atags.."\\p1\\c&H000000&\\alpha&H80&}m -500 -199 l 500 -199 l 500 -201 l -500 -201 m -701 1 l 700 1 l 700 -1 l -701 -1 m -500 201 l 500 201 l 500 199 l -500 199 m -1 -500 l 1 -500 l 1 500 l -1 500 m -201 -500 l -199 -500 l -199 500 l -201 500 m 201 500 l 199 500 l 199 -500 l 201 -500 m -150 -25 l 150 -25 l 150 25 l -150 25 m -401 -401 l 401 -401 l 401 401 l -401 401 m -399 -399 l -399 399 l 399 399 l 399 -399"
		end
		if l.text:match("\\pos")==nil then l.text=l.text:gsub("\\p1","\\pos(640,360)\\p1") end
		end
		
	    subs[sel[i]]=l
	end
end

function add_an8(subs, sel, act)
	for z, i in ipairs(sel) do
		local line=subs[i]
		local text=subs[i].text
		if line.text:match("\\an%d") and res.an8~="q2" then
		text=text:gsub("\\(an%d)","\\"..res.an8)
		end
		if line.text:match("\\an%d")==nil and res.an8~="q2" then
		text="{\\"..res.an8.."}" .. text
		text=text:gsub("{\\(an%d)}{\\","{\\%1\\")
		end
		if res.an8=="q2" then
		    if text:match("\\q2") then text=text:gsub("\\q2","")	text=text:gsub("{}","") else
		    text="{\\q2}" .. text	text=text:gsub("{\\q2}{\\","{\\q2\\")
		    end
		end
	line.text=text
	subs[i]=line
	end
end

function alfashift(subs, sel)
    count=1
    for x, i in ipairs(sel) do
        line=subs[i]
	text=line.text
	if not text:match("{\\alpha&HFF&}[%w%p]") then aegisub.dialog.display({{class="label",
		label="Line "..x.." does not \nappear to have alpha FF",x=0,y=0,width=1,height=2}},{"OK"}) aegisub.cancel() end
	if count>1 then
		switch=1
		repeat 
		text=text:gsub("({\\alpha&HFF&})([%w%p])","%2%1")
		text=text:gsub("({\\alpha&HFF&})(%s)","%2%1")
		text=text:gsub("({\\alpha&HFF&})(\\N)","%2%1")
		text=text:gsub("({\\alpha&HFF&})$","")
		switch=switch+1
		until switch>=count
	end
	count=count+1
	line.text=text
        subs[i]=line
    end
end

function esc(str)
str=str
:gsub("%%","%%%%")
:gsub("%(","%%%(")
:gsub("%)","%%%)")
:gsub("%[","%%%[")
:gsub("%]","%%%]")
:gsub("%.","%%%.")
:gsub("%*","%%%*")
:gsub("%-","%%%-")
:gsub("%+","%%%+")
:gsub("%?","%%%?")
return str
end

function strikealpha(subs, sel)
    for x, i in ipairs(sel) do
        local l=subs[i]
	l.text=l.text
	:gsub("\\s1","\\alpha&H00&")
	:gsub("\\s0","\\alpha&HFF&")
	:gsub("\\u1","\\alpha&HFF&")
	:gsub("\\u0","\\alpha&H00&")
	:gsub("@(%x%x)@","{\\alpha&H%1&}")
	:gsub("@0","{\\alpha&H00&}")
	:gsub("@","{\\alpha&HFF&}")
	subs[i]=l
    end
end

function scale(subs, sel)
    for z, i in ipairs(sel) do
	local l=subs[i]
	text=l.text
	    sr=stylechk(subs,l.style)
	    rf=res.fs
	    if text:match("^{[^}]-\\fs%d") then fsize=text:match("^{[^}]-\\fs([%d]+)") else fsize=sr.fontsize end
	    if text:match("^{[^}]-\\fscx%d") then scx=text:match("^{[^}]-\\fscx([%d%.]+)") else scx=sr.scale_x end
	    if text:match("^{[^}]-\\fscy%d") then scy=text:match("^{[^}]-\\fscy([%d%.]+)") else scy=sr.scale_y end
	    skale="{\\fs"..rf.."\\fscx"..round(fsize*scx/rf).."\\fscy"..round(fsize*scy/rf).."}"
	    text=text:gsub("\\fsc?[xy]?[%d%.]+","") :gsub("{}","")
	    text=skale..text
		if res.mend then
		  text=text:gsub("^({\\[^}]-)}{\\","%1\\")
		else
		  text=text:gsub("^{(\\[^}]-)}{(\\[^}]-)}","{%2%1}")
		end
	l.text=text
	subs[i]=l
    end
end

function shiftag(subs,sel,act)
    rine=subs[act]
    tags=rine.text:match("^{\\[^}]-}")
    ftags=rine.text:match("^{(\\[^}]-)}")
    if tags==nil then tags="" end
    if ftags==nil then ftags="" end
    ftags=ftags:gsub("\\pos[^\\}]+","") :gsub("\\move[^\\}]+","") :gsub("\\org[^\\}]+","") 
    :gsub("\\i?clip[^\\}]+","") :gsub("\\fad[^\\}]+","") :gsub("\\an?%d","")
    cstext=rine.text:gsub("^{(\\[^}]-)}","")
    -- remove transforms
	ftags=ftags:gsub("\\t%([^%(%)]+%)","")
	ftags=ftags:gsub("\\t%([^%(%)]-%([^%)]-%)[^%)]-%)","")
    rept={"drept"}
    -- build GUI
    shiftab={
	{x=0,y=0,width=3,height=1,class="label",label="[  Start Tags (Shift Right only)  ]   ",},
	{x=3,y=0,width=1,height=1,class="label",label="[  Inline Tags  ]   ",},
	    }
    ftw=1
    -- regular tags -> GUI
    for f in ftags:gmatch("\\[^\\]+") do lab=f
	  lab=lab:gsub("&","&&")
	  cb={x=0,y=ftw,width=2,height=1,class="checkbox",name="chk"..ftw,label=lab,value=false,realname=f}
	  table.insert(shiftab,cb)	ftw=ftw+1
	  table.insert(rept,f)
    end
    table.insert(shiftab,{x=0,y=ftw+1,width=1,height=1,class="label",label="Shift by letter /",})
    table.insert(shiftab,{x=1,y=ftw+1,width=1,height=1,class="checkbox",name="word",label="word",value=false})
    table.insert(shiftab,{x=0,y=ftw+2,width=2,height=1,class="intedit",name="rept",value=1,min=1})
    itw=1
    -- inline tags
    if cstext:match("{%*?\\[^}]-}") then
      for f in cstext:gmatch("{%*?\\[^}]-}") do lab=f
	if itw==31 then lab="Error: 30 tags max" f="" end
	if itw==32 then break end
	  lab=lab:gsub("&","&&")
	  cb={x=3,y=itw,width=1,height=1,class="checkbox",name="chk2"..itw,label=lab,value=false,realname=f}
	  drept=0 for r=1,#rept do if f==rept[r] then drept=1 end end
	  if drept==0 then
	  table.insert(shiftab,cb)	itw=itw+1
	  table.insert(rept,f)
	  end
      end
    end
	repeat
	    if press=="All Inline Tags" then
		for key,val in ipairs(shiftab) do
		    if val.class=="checkbox" and val.x==3 then val.value=true end
		    if val.class=="checkbox" and val.x<3 then val.value=rez[val.name] end
		end
	    end
	press,rez=aegisub.dialog.display(shiftab,{"Shift Left","Shift Right","All Inline Tags","Cancel"},{ok='Shift Right',close='Cancel'})
	until press~="All Inline Tags"
	if press=="Cancel" then aegisub.cancel() end
	if press=="Shift Right" then R=true else R=false end
	if press=="Shift Left" then L=true else L=false end

	if R then
	  for s=#shiftab,1,-1 do stab=shiftab[s]
	    if rez[stab.name]==true and stab.x==3 then stag=stab.realname etag=esc(stag)
	    rep=0
		repeat
		if not rez.word then
		cstext=cstext
		:gsub(etag.."(%s?[%w%p]%s?)","%1"..stag)
		:gsub(etag.."(%s?\\N%s?)","%1"..stag)
		:gsub(etag.."(%s?{[^}]-}%s?)","%1"..stag)
		:gsub(etag.."(%s?\\N%s?)","%1"..stag)
		:gsub("{%*?(\\[^}]-)}{%*?(\\[^}]-)}","{%1%2}")
		--aegisub.log("\n cstext "..cstext)
		else
		cstext=cstext
		:gsub(etag.."(%s*[^%s]+%s*)","%1"..stag)
		:gsub(etag.."(%s?\\N%s?)","%1"..stag)
		:gsub(etag.."({[^}]-})","%1"..stag)
		:gsub(etag.."(%s?\\N%s?)","%1"..stag)
		end		
		rep=rep+1
		until rep==rez.rept
		
		
	    end
	  end
	elseif L then
	  for key,val in ipairs(shiftab) do
	    if rez[val.name]==true and val.x==3 then stag=val.realname etag=esc(stag)
	    rep=0
		repeat
		if not rez.word then
		cstext=cstext
		:gsub("([%w%p]%s?)"..etag,stag.."%1")
		:gsub("(\\N%s?)"..etag,stag.."%1")
		:gsub("{%*?(\\[^}]-)}{%*?(\\[^}]-)}","{%1%2}")
		else
		cstext=cstext
		:gsub("([^%s]+%s*)"..etag,stag.."%1")
		:gsub("(\\N%s*)"..etag,stag.."%1")
		:gsub("(({[^}]-})%s*)"..etag,stag.."%1")
		:gsub("(\\N%s*)"..etag,stag.."%1")
		end
		rep=rep+1
		until rep==rez.rept
	    end
	  end
	  cstext=cstext:gsub("{%*?(\\[^}]-)}{%*?(\\[^}]-)}","{%1%2}")
	end
	
	cstext=cstext:gsub("({\\[^}]-})",function(tg) return duplikill(tg) end)
	
	startags=""
	for key,val in ipairs(shiftab) do
	    if rez[val.name]==true and val.x==0 then stag=val.realname etag=esc(stag)
		if R then
		startags=startags..stag
		tags=tags:gsub(etag,"")
		end
	    end
	end
	
	if startags~="" and R then
	    cstext="{_T_}"..cstext
	    REP=0
	    if not rez.word then
		repeat
		cstext=cstext
		:gsub("{_T_}([%w%p]%s*)","%1{_T_}")
		:gsub("{_T_}(\\N%s?)","%1{_T_}")
		:gsub("{_T_}({[^}]-}%s*)","%1{_T_}")
		:gsub("{_T_}(\\N%s?)","%1{_T_}")
		REP=REP+1
		until REP==rez.rept
	    else
		repeat
		cstext=cstext
		:gsub("{_T_}(%s*[^%s]+%s*)","%1{_T_}")
		:gsub("{_T_}(%s?\\N%s?)","%1{_T_}")
		:gsub("{_T_}({[^}]-})","%1{_T_}")
		:gsub("{_T_}(%s?\\N%s?)","%1{_T_}")
		REP=REP+1
		until REP==rez.rept
	    end
	    cstext=cstext
	    :gsub("_T_",startags)
	    :gsub("{(%*?\\[^}]-)}{(%*?\\[^}]-)}","{%1%2}")
	end
	
	text=tags..cstext
	text=text:gsub("{(%*?\\[^}]-)}{(%*?\\[^}]-)}","{%1%2}")
	:gsub("^{}","")
	:gsub("({\\[^}]-})",function(tg) return duplikill(tg) end) :gsub("^{%*","{")
	
    rine.text=text
    subs[act]=rine
end

function alfatime(subs,sel)
    -- collect / check text
    for x, i in ipairs(sel) do
	text=subs[i].text
	if x==1 then alfatext=text:gsub("^{\\[^}]-}","") end
	if x~=1 then alfatext2=text:gsub("^{\\[^}]-}","") 
	  if alfatext2~=alfatext then 
	    aegisub.dialog.display({{class="label",label="Text must be the same for all selected lines",x=0,y=0,width=1,height=2}},{"OK"})
	    aegisub.cancel()
	  end
	end
    end
    
    if not alfatext:match("@") then
	-- GUI
	dialog_config={{x=0,y=0,width=5,height=8,class="textbox",name="alfa",value=alfatext },
	{x=0,y=8,width=1,height=1,class="label",
		label="Break the text with 'Enter' the way it should be alpha-timed. (lines selected: "..#sel..")"},}
	pressed,res=aegisub.dialog.display(dialog_config,{"Alpha Text","Alpha Time","Cancel"},{ok='Alpha Text',close='Cancel'})
	if pressed=="Cancel" then aegisub.cancel() end
	data=res.alfa
    else
	data=alfatext:gsub("@","\n")
	pressed="Alpha Time"
    end
	-- sort data into a table
	altab={}	data=data.."\n"
	ac=1
	data2=""
	for al in data:gmatch("(.-\n)") do 
	    al2=al:gsub("\n","{"..ac.."}") ac=ac+1 data2=data2..al2
	    if al~="" then 
	        table.insert(altab,al2) 
	    end
	end
	
    -- apply alpha text
    if pressed=="Alpha Text" then
      for x, i in ipairs(sel) do
        altxt=""
	for a=1,x do altxt=altxt..altab[a] end
	esctxt=esc(altxt)
	line=subs[i]
	text=line.text
	if altab[x]~=nil then
	  tags=text:match("^{\\[^}]-}")
	  text=data2
	  :gsub("\n","")
	  :gsub(esctxt,altxt.."{\\alpha&HFF&}")
	  :gsub("({\\alpha&HFF&}.-){\\alpha&HFF&}","%1")
	  :gsub("{\\alpha&HFF&}$","")
	  :gsub("{(\\[^}]-)}{(\\[^}]-)}","{%1%2}")
	  :gsub("{%d+}","")
	  :gsub("{(\\[^}]-)}{(\\[^}]-)}","{%1%2}")
	  if tags~=nil then text=tags..text end
	end
	line.text=text
	subs[i]=line
      end
    end
    
    -- apply alpha text + split line
    if pressed=="Alpha Time" then
	line=subs[sel[1]]
	start=line.start_time
	endt=line.end_time
	dur=endt-start
	f=dur/#altab
	for a=#altab,1,-1 do
          altxt=""
	  altxt=altxt..altab[a]
	  esctxt=esc(altxt)
	  line.text=line.text:gsub("@","")
	  line2=line
	  tags=line2.text:match("^{\\[^}]-}")
	  line2.text=data2
	  :gsub("\n","")
	  :gsub(esctxt,altxt.."{\\alpha&HFF&}")
	  :gsub("({\\alpha&HFF&}.-){\\alpha&HFF&}","%1")
	  :gsub("{\\alpha&HFF&}$","")
	  :gsub("{(\\[^}]-)}{(\\[^}]-)}","{%1%2}")
	  :gsub("{%d+}","")
	  if tags~=nil then line2.text=tags..line2.text end
	  line2.start_time=start+f*(a-1)
	  line2.end_time=start+f+f*(a-1)
	  subs.insert(sel[1]+1,line2)
	end
	subs.delete(sel[1])
    end
end

function addtag2(tag,text) -- mask version
	tg=tag:match("\\%d?%a+")
	text=text:gsub("^{(\\[^}]-)}","{"..tag.."%1}")
	:gsub("("..tg.."[^\\}]+)([^}]-)("..tg.."[^\\}]+)","%2%1")
	--aegisub.log("\n text "..text)
	return text 
end

function round(num)
	num=math.floor(num+0.5)
	return num
end

function duplikill(tagz)
	tf=""
	if tagz:match("\\t") then 
	    for t in tagz:gmatch("(\\t%([^%(%)]-%))") do tf=tf..t end
	    for t in tagz:gmatch("(\\t%([^%(%)]-%([^%)]-%)[^%)]-%))","") do tf=tf..t end
	    tagz=tagz:gsub("\\t%([^%(%)]+%)","")
	    tagz=tagz:gsub("\\t%([^%(%)]-%([^%)]-%)[^%)]-%)","")
	end
	tags1={"blur","be","bord","shad","xbord","xshad","ybord","yshad","fs","fsp","fscx","fscy","frz","frx","fry","fax","fay"}
	for i=1,#tags1 do
	    tag=tags1[i]
	    tagz=tagz:gsub("\\"..tag.."[%d%.%-]+([^}]-)(\\"..tag.."[%d%.%-]+)","%1%2")
	end
	tagz=tagz:gsub("\\1c&","\\c&")
	tags2={"c","2c","3c","4c","1a","2a","3a","4a","alpha"}
	for i=1,#tags2 do
	    tag=tags2[i]
	    tagz=tagz:gsub("\\"..tag.."&H%x+&([^}]-)(\\"..tag.."&H%x+&)","%1%2")
	end	
	tagz=tagz:gsub("({\\[^}]-)}","%1"..tf.."}")
	return tagz
end

function stylechk(subs,stylename)
    for i=1, #subs do
        if subs[i].class=="style" then
	    local st=subs[i]
	    if stylename==st.name then
		styleref=st
		break
	    end
	end
    end
    return styleref
end

function masquerade(subs,sel,act)
	dialog_config=
	{
	    {x=0,y=0,width=1,height=1,class="label",label="Mask:",},
	    {x=1,y=0,width=1,height=1,class="dropdown",name="mask",
		items={"from clip","square","rounded square","rounded square 2","rounded square 3","circle","equilateral triangle","right-angled triangle","alignment grid","alignment grid 2"},value="square"},
	    {x=0,y=1,width=2,height=1,class="checkbox",name="masknew",label="create mask on a new line",value=true},

	    {x=3,y=0,width=1,height=1,class="dropdown",name="an8",
		items={"q2","an1","an2","an3","an4","an5","an6","an7","an8","an9"},value="an8"},
		
	    --{x=4,y=0,width=1,height=2,class="label",label="::\n::\n::",},
	    
	    {x=5,y=0,width=2,height=1,class="label",label="scaling ",},
	    {x=5,y=1,width=1,height=1,class="label",label="\\fs:",},
	    {x=6,y=1,width=2,height=1,class="intedit",name="fs",value=3,min=1},
	    {x=7,y=0,width=1,height=1,class="checkbox",name="mend",label="tag end",value=false},
	    
	    {x=17,y=0,width=1,height=0,class="label",label="Masquerade v"..script_version},
	} 	
	pressed, res=aegisub.dialog.display(dialog_config,
	{"create mask","shift tags","an8 / q2","mocha scale","alpha shift","alpha time","strikealpha","cancel"},{cancel='cancel'})
	if pressed=="cancel" then aegisub.cancel() end
	if pressed=="create mask" then addmask(subs, sel) end
	if pressed=="strikealpha" then strikealpha(subs, sel) end
	if pressed=="an8 / q2" then add_an8(subs, sel,act) end
	if pressed=="alpha shift" then alfashift(subs, sel) end
	if pressed=="alpha time" then alfatime(subs, sel) end	
	if pressed=="mocha scale" then scale(subs, sel) end
	if pressed=="shift tags" then shiftag(subs,sel,act) end
    aegisub.set_undo_point(script_name)
    return sel, act
end

aegisub.register_macro(script_name, script_description, masquerade)