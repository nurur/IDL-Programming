PRO FIXFLUX, IMAGE1, HEAD1, IMAGE2, HEAD2, CFAC
;;
;; FLX1 * AREA1 = (CFAC * FLX2) * AREA2 
;; FLX2 IS THE OUTPUT OF HASTROM.PRO
;;
;; IMAGE1 -- ORIGINAL IMAGE
;; IMAGE2 -- MODIFIED IMAGE, I.E. IMAGE AFTER APPLYING HASTOM TO IMAGE1 
;; FINAL IMAGE IN THE MAIN PROCEDURE SHOULD BE MULTIPLIED BY CFAC
;;
GETPIX, HEAD1, PIXEL=PIX1
GETPIX, HEAD2, PIXEL=PIX2
;print, pix1, pix2


AREA1 = PIX1*PIX1
AREA2 = PIX2*PIX2
AREA_RATIO = AREA1/AREA2

TOT1 = TOTAL( IMAGE1[ WHERE(IMAGE1 GT 0., NGOOD) ])
TOT2 = TOTAL( IMAGE2[ WHERE(IMAGE2 GT 0., NGOOD) ])
TOT_RATIO  = (TOT1/TOT2)


;print, tot1, area1, tot2, area2


PRINT, '                                                '
PRINT, '*** IMAGE CONTRACTION OR EXPANSION ***          '
IF (TOT1 GT TOT2) THEN PRINT, 'CONTRCTING IMAGE ...     ' 
IF (TOT1 GT TOT2) THEN CFAC= TOT_RATIO * AREA_RATIO ;CONTRACTION
IF (TOT1 GT TOT2) THEN PRINT, 'THE CORRECTION FACTOR IS:',CFAC,FORMAT='(A,F10.6)' 


IF (TOT2 GT TOT1) THEN PRINT, 'EXPANDING IMAGE ...      ' 
IF (TOT2 GT TOT1) THEN CFAC= TOT_RATIO * AREA_RATIO ;EXPANSION
IF (TOT2 GT TOT1) THEN PRINT, 'THE CORRECTION FACTOR IS:',CFAC,FORMAT='(A,F10.6)' 
PRINT, '                                                '


IF (TOT2 EQ TOT1) THEN PRINT, 'EQAUL IMAGE SIZE ...     ' 
IF (TOT2 EQ TOT1) THEN CFAC= TOT_RATIO * AREA_RATIO ;NOTHING
IF (TOT2 EQ TOT1) THEN PRINT, 'THE CORRECTION FACTOR IS:',CFAC,FORMAT='(A,F10.6)' 
PRINT, '                                                '


END
