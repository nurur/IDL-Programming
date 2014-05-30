PRO GRID

SET_PLOT, 'ps'  
DEVICE, FILENAME='grid.ps', $ 
ENCAPSULATED=0, $ 
/COLOR,         $ 
/TT_FONT,       $ 
/INCHES,        $
XSIZE=5.0,   YSIZE=6.5, $ 
XOFFSET=1.0, YOFFSET=2.25
 
; Make a vector of 32 points, A[i] = 2pi/16:  
A = FINDGEN(17) * (!PI*2/16.)  
; Define the symbol to be a unit circle with 32 points,   
; and set the filled flag:  
USERSYM, 0.3*COS(A), 0.3*SIN(A), /FILL  

psym = 8

!P.MULTI=[0,1,2]


MAIN   ='/brahma/nurur/umd/project2/ngc4254/data/ANALYSIS/CHECK/MONTE/'
readcol, 'syn_data1.dat', A, chi


plotsym, 0, 0.15, /fill
plot, A, chi, psym=psym, /NODATA, $ 
XRANGE=[0.,5], /XSTYLE,     $
YRANGE=[0.,5], /YSTYLE,     $
XGRIDSTYLE=0, YGRIDSTYLE=0, $
XTICKLEN=1, YTICKLEN=1, $
XTICKINTERVAL=1, YTICKINTERVAL=1, $
XMINOR=1, YMINOR=1,               $
xtitle=textoidl('\Sigma_{gas}'), ytitle=textoidl('\Sigma_{sfr}')

plot, A, chi, psym=psym, /NODATA, $
XRANGE=[0., 5], /XSTYLE,    $
YRANGE=[0., 5], /YSTYLE,    $
XGRIDSTYLE=0, YGRIDSTYLE=0, $
XTICKLEN=1, YTICKLEN=1,     $
XTICKINTERVAL=1, YTICKINTERVAL=1, $
XMINOR=1, YMINOR=1,               $
xtitle=textoidl('\Sigma_{gas}_'), ytitle=textoidl('\Sigma_{sfr}')





DEVICE, /CLOSE



END
