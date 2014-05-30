PRO ON_ERRORBAR

loadct, 13

!p.multi=[0,2,2]

;; Fixed Error Bar
;; Linear Plot
err = FLTARR(2,10)  
xerr= 0.5 + FLTARR(10)  
yerr= 0.5 + FLTARR(10)  

x= 0.01+FINDGEN(10)
y= x

;multiplot
ploterror, x, y,  XERR, YERR , xrange=[0.01, 10], yrange=[0.01,10], $
/xstyle, /ystyle


;; Log-Log Plot
xerr= 0.434294*xerr/x 
yerr= 0.434294*yerr/y 
x= alog10(x)
y= x

;multiplot &
ploterror, x, y,  XERR, YERR, xrange=[-0.1, 1], yrange=[-0.1,1], $
/xstyle, /ystyle



;;------------------------------------------------------------------
;;------------------------------------------------------------------
;; Variable Error Bar
;; Linear Plot
err = FLTARR(2,10)  
xerr= FINDGEN(10)/10.  * RANDOMN(SEED) + 0.5
yerr= xerr + 0.5

x= 0.01+FINDGEN(10)
y= x

;multiplot &
ploterror, x, y,  XERR, YERR , xrange=[0.01, 10], yrange=[0.01,10], $
/xstyle, /ystyle
 

;; Log-Log Plot
xerr= 0.434294*xerr/x 
yerr= 0.434294*yerr/y 
x= alog10(x)
y= x

;multiplot &
ploterror, x, y,  XERR, YERR, xrange=[-0.1, 1], yrange=[-0.1,1], $
/xstyle, /ystyle;, /xlog, /ylog 





END
