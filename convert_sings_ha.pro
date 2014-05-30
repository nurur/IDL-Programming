PRO CONVERT_SINGS_HA, INFILE=INFILE, OUTIMAGE, HEAD

;; Conversion Factors
LAMDA   = 0.6563                      ; micron 
NU      = (2.99E+14)/LAMDA            ; Hertz
CONST   =    3.0E-05
FWHM    =   74.0E+00                  ; FWHM of the Filter
LAMC    = 6618.0E+00                  ; Central Wavelength of the Filter

filterFactor= (FWHM/LAMC/LAMC) 
niiFactor   = 1.7096                  ; NII Correction Factor



;; Input Image
image    = MRDFITS(INFILE, 0, head)
;; Image Parameters
PHOTFLAM = SXPAR(head,'PHOTFLAM')
ZPOINT   = SXPAR(head,'ZPOINT')


;; Correction for Negative Pixels
bad  = WHERE(image LT 0.,  nBad, complement=good, ncomplement=nGood) 
PRINT, '                            '
PRINT, 'TOTAL NUMBER OF PIXELS    : ', n_elements(image)
PRINT, 'NUMBER OF POSITIVE PIXELS : ', nGood
PRINT, 'NUMBER OF NEGATIVE PIXELS : ', nBad
PRINT, '                            '

;; Find Median Value of the Pixels
medVAL= median(image)
PRINT, 'MEDIAN OF THE PIXEL VALUES IN THE IMAGE : ', meDVAL
PRINT, 'if Postitive, median VALUE is added, if Negative it is subtracted '


IF (nBad GT 0) THEN BEGIN 
    IF (medVal GT 0.) THEN BEGIN
        image(bad)=image(bad) + medVal
    ENDIF 
    IF (medVal LT 0.) THEN BEGIN
        image(bad)=image(bad) - medVal
    ENDIF
ENDIF

PRINT, '                                            '
PRINT, 'Check Again for the Negative PIXEL Values   '
bad  = WHERE(image LT 0.,  nBad, complement=good, ncomplement=nGood) 
PRINT, 'TOTAL NUMBER OF PIXELS    : ', n_elements(image)
PRINT, 'NUMBER OF POSITIVE PIXELS : ', nGood
PRINT, 'NUMBER OF NEGATIVE PIXELS : ', nBad
PRINT, '                                            '


; Convert COUNT SEC^-1 PIXEL^-1 to ERG SEC^-1 CM^-2
; In Unit of 1.E-15
multiFactor = alog10(CONST) + alog10(PHOTFLAM) + alog10(filterFactor) + 15.
fluxDensity = image * 10^(multiFactor)

;; Correcting for [NII] line
fluxDensity = fluxDensity/niiFactor

;; OUTPUT IMAGE
OUTIMAGE    = FLUXDENSITY
print, 'Flux Density min and max:', min(fluxDensity), max(fluxDensity)



END
