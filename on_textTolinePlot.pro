PRO ON_TEXTTOLINEPLOT


readcol, 'fluxCarma.txt', radius, NpixCARMA, fluxCARMA
readcol, 'fluxIram.txt', radius, NpixIRAM,  fluxIRAM

ratio = fluxCARMA/fluxIRAM


!p.multi=[0,1,2]


SET_PLOT, 'ps'  
device, filename='fluxRatio.ps', /color

multiplot
plot, radius, fluxCARMA, linestyle=1, xrange=[0, 170], yrange=[0, 3010], $
ytitle='Cumulative Flux', /xstyle, /ystyle
oplot, radius, fluxIRAM, linestyle=2

plots, [162,0] 
plots, [162,3000], /continue
xyouts, 162, 2400, 'r!D25',  alignment=0.5, charsize=0.8

xyouts,  12, 2700, 'Cumulative flux within concentric circular apertures',$ 
charsize=0.8
xyouts,  12, 2400, 'Dashed Line: IRAM',   charsize=0.8
xyouts,  12, 2200, 'Dotted Line:  CARMA', charsize=0.8


;;------------------------------------------
multiplot &
plot, radius, ratio, psym=0, xrange=[0, 170], yrange=[0, 1.149], $
xtitle='Aperture Radius (arcsec)', $ 
ytitle='Cumu. Flux Ratio', /xstyle, /ystyle


plots, [162,0] 
plots, [162,1.149], /continue
xyouts, 162, 0.90, 'r!D25',  alignment=0.5, charsize=0.8

xyouts,  12, 1.05, $ 
'Cumulative flux ratio within concentric circular apertures: CARMA/IRAM', $ 
charsize=0.8


device, /close


END
