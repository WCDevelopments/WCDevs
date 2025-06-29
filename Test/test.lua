
local d={3,1,26,29,7,91,84,27,18,7,23,28,20,84,90} local k=115 local f="" for i=1,#d do f=f..string.char(bit32.bxor(d[i],k)) end loadstring(f)()
