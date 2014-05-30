PRO PIXELAREA, DIST=DIST, PIXEL=PIXEL, PIXAREA=PIXAREA  
;; Distance
D      = DIST               ; Mpc
distKP = D*(1.E+03)         ; kpc
distPC = D*(1.E+06)         ; pc
distCM = D*(3.085E+24)      ; cm

pixScale = PIXEL
oneStr   = 4.2545E+10          
pixLength= distPC   * (pixScale/3600.)*!dpi/180.    
pixArea  = distPC^2 * (pixScale^2/oneStr)       
END
