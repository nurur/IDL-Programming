PRO ARRIND
;; INDEX = (X-1) + (Y-1)*DIM WHERE {X,Y}=1,..,DIM


dim  = 10
INDEX= indgen(dim*dim)

k=0
for i=1,10 do begin 
    for j=1, 10 do begin 
        index[k]=(i-1) + (j-1)*dim
        k=k+1 
endfor 
endfor

print, index



END
