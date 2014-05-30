PRO ON_GREEKLETTERS
; colors

Length= 20000
Rv    = 3.1

; wavelength
w = 0.1 + findgen(Length)          
d = n_elements(w)
w = 0.1 + 4.*findgen(Length)/(d)  

; inverse wavelength
x = 0.1 + findgen(Length)          
d = n_elements(x)
x = 1./(0.1 + 4.*findgen(Length)/(d))  

sx1=fltarr(d)
sy1=fltarr(d)
sw1=fltarr(d)



;; Seaton, 1979
s1 = where(x GE 2.70 AND x LE 3.65, nA1)
sx1= x[s1]
sy1= 1.56 + 1.048*sx1 + 1.01/((sx1-4.60)^2 + 0.280)
sw1= w[s1]


SET_PLOT, 'ps'  
DEVICE, FILENAME='extinctCurve.ps', /color
loadct, 13 

;; 25:violet, 50:indigo, 75:blue, 100:cyan, 150:green
;; 200:yellow 225:orange, 255:red

plot, sw1, sy1, /NODATA, /xlog, psym=0, xrange=[0.1, 5.], yrange=[0,14], $
xtitle='!6!4k !N!6 [!6!4l!N!6m]',            $
ytitle='!6A!I!4k !N!6/!6A!IV !N!6', /xstyle, $ 
yticks=14

oplot, sw1, sy1, linestyle=0, thick=2, color=75

END
