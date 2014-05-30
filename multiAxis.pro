PRO MULTIAXIS
;; Pixel Scale 3.0 arcsec


NAPT = 70



;; Galaxy Parameters---------------------------------------------------
ba       = 0.87
axisRatio= 1./ba
posAngle = 60.00
incAngle = 30.00

;; Distance
D        = 16.60                        ; Mpc
distCM   = D*(3.085E+24)                ; cm
distKP   = D*(1.E+03)                   ; kpc

;; Conversion Factors
incFactor = cos(incAngle*!dpi/180.) 
fluxFactor= alog10(1.0E-15)

;; Image Parameters ---------------------------------------------------
pixScale = 3.0                                      ; arcsec   
oneStared= 4.2545E+10                               ; staredian        
pixLength= distKP   * (pixScale/3600.)*!dpi/180.    ; kpc
skyArea  = distKP^2 * (pixScale^2/oneStared)        ; projected sky area
depArea  = skyArea/incFactor                        ; de-projected area




;; PLOT
SET_PLOT, 'ps'  
DEVICE, FILENAME='diffratio.ps', /color, /TT_FONT, $ 
/INCHES, XSIZE=6.5, YSIZE=6.5, XOFFSET=1.0, YOFFSET=2.25



!p.multi=[0,2,2]





SCALE1=[75, 90, 105, 120, 135, 150, 165, 180, 195, 210, 225]
SCALE2=SCALE1 * 80.4/1000.
DUV  =[0.72, 0.69, 0.66, 0.62, 0.59, 0.55, 0.52, 0.48, 0.45, 0.42, 0.39]
DHA  =[0.55, 0.50, 0.45, 0.40, 0.35, 0.30, 0.25, 0.21, 0.18, 0.15, 0.13]
DMI  =[0.68, 0.62, 0.56, 0.50, 0.44, 0.38, 0.34, 0.30, 0.25, 0.22, 0.19]



X1 =    5.
X2 =   20.
Y1 =   0.0
Y2 =   1.0

PLOT, SCALE2, DUV, /NODATA, PSYM=psym, $ 
xrange=[X1, X2], yrange=[Y1, Y2],      $ 
YSTYLE=1, $
XSTYLE=8, $
XTICKINTERVAL=5,   YTICKINTERVAL=0.2,  $ 
XCHARSIZE=0.9, YCHARSIZE=0.9,          $
xtitle='Median Filter Width (kpc)',    $
ytitle=textoidl('Diffuse Fraction')


xyouts, +170, +0.90, textoidl(' FUV map'), CHARSIZE =0.7,     COLOR=75
xyouts, +170, +0.85, textoidl(' H\alpha map'), CHARSIZE =0.7, COLOR=150
xyouts, +170, +0.80, textoidl(' 24 \mum map'), CHARSIZE =0.7, COLOR=255


OPLOT, SCALE2, DUV, LINESTYLE=0, THICK=3, COLOR=75
OPLOT, SCALE2, DHA, LINESTYLE=0, THICK=3, COLOR=150
OPLOT, SCALE2, DMI, LINESTYLE=0, THICK=3, COLOR=255





AXIS, XAXIS=1, XRANGE=[62.19, 248.76],$
XSTYLE=1, $
XTICKINTERVAL=25, $
XTITLE='Median Filter Width (Pixel)', $ 
XCHARSIZE=0.6, YCHARSIZE=0.6,         $ 
/SAVE
OPLOT, SCALE1;, DMI, LINESTYLE=0, THICK=3, COLOR=255






;; PLOT Y-AXIS TO THE LEFT
;AXIS, YAXIS=0, YRANGE=[Y1, Y2], YSTYLE=1, YTICKS=8, YMINOR=4 

;; PLOT Y-AXIS TO THE RIGHT
;YY= []
;AXIS, YAXIS=1, YRANGE=[Y11, Y22], YTICKV=YY, YSTYLE=1, YTICKS=8, YMINOR=4






device, /close




END
