PRO ON_PSYM

;PSYM - The following integer values of PSYM will create the corresponding 
;plot symbols
;0 	circle
;1 	downward arrow (upper limit), base of arrow begins at plot value
;2 	upward arrow (lower limt)
;3 	5 pointed star
;4 	triangle
;5 	upside down triangle
;6 	left pointing arrow
;7 	right pointing arrow
;8 	square (custom)
;9 	Undefined


; 1
; Make a vector of 32 points, A[i] = 2pi/16:  
A = FINDGEN(17) * (!PI*2/16.)  
; Define the symbol to be a unit circle with 32 points,   
; and set the filled flag:  
USERSYM, 0.3*COS(A), 0.3*SIN(A), /FILL  

psym = 8
PLOT, X, Y, psym=psym, color=255




; 2
PLOTSYM, 0, 0.5, /FILL
OPLOT, X, Y, psym=psym, color=255




END
