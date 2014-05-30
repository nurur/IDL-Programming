PRO ON_CONVERT_CROP

;; DIMENSION OF THE CROPPED IMAGE 
DIMEN = 1600

;;
incAngle= 30.00
posAngle= 60.00
D       = 16.60
aptCorr =  2.60
pixScale= 0.305 
   

;; Conversion Factors
LAMDA     = 0.6563                    ; micron 
NU        = (2.99E+14)/LAMDA          ; Hertz
Dist      = D*(3.085E+24)             ; cm

CONST   =    3.0E-05
FWHM    =   74.0E+00                  ; FWHM of the filter
LAMC    = 6618.0E+00                  ; Central wavelength of the filter

filterFactor= (FWHM/LAMC/LAMC) 
niiFactor   = 1.7096                  ; NII Correction Factor

;;----------------------------------------------------------------------
path='/brahma/nurur/umd/project2/ngc4254/data/HALPHA/CLEAN/'
file=path + 'ngc4254.ha.sub.mask.fits'

;; Input image
image     = MRDFITS(file, 0, header)
;; Image parameters
PHOTFLAM= SXPAR(header,'PHOTFLAM')
ZPOINT  = SXPAR(header,'ZPOINT')
;;----------------------------------------------------------------------
;;
;; Correction for bad (Negative) pixels
bad  = WHERE(image LT 0.,  nBad, complement=good, ncomplement=nGood) 
PRINT, '                                            '
PRINT, 'Pos pix, Neg pix, Total pix:', nGood, nBad, n_elements(image)
medVal= median(image)
PRINT, 'Median of the Image', median(image)
PRINT, 'if Postitive, median is added else subtracted ... ...'

IF (medVal GT 0.) THEN BEGIN
    image(bad)=image(bad) + medVal
ENDIF ELSE BEGIN
    image(bad)=image(bad) - medVal
ENDELSE

PRINT, '                                            '
PRINT, 'Check again for the negative values ... ... '
PRINT, 'If found, forced them to be small   ... ... '
bad  = WHERE(image LT 0.,  nBad, complement=good, ncomplement=nGood) 
PRINT, 'Pos pix, Neg pix, Total pix:', nGood, nBad, n_elements(image)
                              ;image(bad) = 1.0E-06
PRINT, '                                            '

;;----------------------------------------------------------------------
; Convert COUNT SEC^-1 PIXEL^-1 to ERG SEC^-1 CM^-2 
fluxDensity = image * CONST * PHOTFLAM * filterFactor

;; Correcting for [NII] line
fluxDensity = fluxDensity/niiFactor
;; In unit of 1.0E-12 
fluxDensity = fluxDensity * 1.E+04 
print, max(fluxDensity)

;;----------------------------------------------------------------------
;; Size of the Cropped Image
DIMEN = DIMEN
CENTER= [DIMEN/2,DIMEN/2]

;; RA and DEC of the central pixel of the Original Image
CTYPE= SXPAR(header, 'CTYPE*')
NAXES= SXPAR(header, 'NAXIS*')
CD1_1= SXPAR(header, 'CD1_1')      ; degree/pixel
CD1_2= SXPAR(header, 'CD1_2')      ; degree/pixel
CD2_1= SXPAR(header, 'CD2_1')      ; degree/pixel
CD2_2= SXPAR(header, 'CD2_2')      ; degree/pixel
CDELT= [CD1_1, CD2_2]     
;CDELT= SXPAR(header, 'CDELT*')    ; degree/pixel
CRVAL= SXPAR(header, 'CRVAL*')     ; central pixel in {ra,dec}
CRPIX= SXPAR(header, 'CRPIX*')     ; central pixel in {x,y}

;; CHECK FOR ASTROMETRY CORRECTION
IMGCEN= NAXES/2
GALCEN= CRPIX
PRINT, '                                            '
PRINT, 'GALAXY CENTER: CRPIX 1,2', CRPIX
PRINT, 'IMAGE CENTER : NAXES 1,2', IMGCEN
PRINT, '                                            '

X_OFFSET = 0.
Y_OFFSET = 0.

;; CASE 1 (CRPIX ++)
IF (CRPIX[1] GE IMGCEN[1] AND CRPIX[0] GT IMGCEN[0]) THEN BEGIN
    X_OFFSET = CRPIX[0] - IMGCEN[0]
    Y_OFFSET = CRPIX[1] - IMGCEN[1]
ENDIF 
;; CASE 2 (CRPIX -+)
IF (CRPIX[1] GE IMGCEN[1] AND  CRPIX[0] LT IMGCEN[0]) THEN BEGIN
    X_OFFSET = CRPIX[0] - IMGCEN[0]
    Y_OFFSET = CRPIX[1] - IMGCEN[1]
ENDIF 
;; CASE 3 (CRPIX +-)
IF (CRPIX[1] LE IMGCEN[1] AND CRPIX[0] GT IMGCEN[0]) THEN BEGIN
    X_OFFSET = CRPIX[0] - IMGCEN[0]
    Y_OFFSET = CRPIX[1] - IMGCEN[1] 
ENDIF 
;; CASE 4 (CRPIX --)
IF (CRPIX[1] LE IMGCEN[1] AND  CRPIX[0] LT IMGCEN[0]) THEN BEGIN
    X_OFFSET = CRPIX[0] - IMGCEN[0]
    Y_OFFSET = CRPIX[1] - IMGCEN[1]  
ENDIF 

; RA,DEC OF THE IMAGE CENTER
IMG_RA  = CRVAL[0] - X_OFFSET*(abs(CDELT[0]))
IMG_DE  = CRVAL[1] - Y_OFFSET*(abs(CDELT[0]))

PRINT, 'RA,DEC OF GALAXY CENTER:', CRVAL
PRINT, 'RA,DEC OF IMAGE CENTER :', IMG_RA, IMG_DE
PRINT, '                                            '

;; RANGE OF THE ORIGINAL IMAGE USED TO CREAT CROPPED IMAGE
x1 = ( CRPIX[0]-CENTER[0]     ) - X_OFFSET
x2 = ( CRPIX[0]+CENTER[0] - 1 ) - X_OFFSET
y1 = ( CRPIX[1]-CENTER[1]     ) - Y_OFFSET
y2 = ( CRPIX[1]+CENTER[1] - 1 ) - Y_OFFSET
PRINT, 'X AND Y OFFSET NEEDED  :', X_OFFSET, Y_OFFSET
PRINT, 'X AND Y LIMITING POINTS:', x1,x2,y1,y2

;; CROPPED IMAGE
imConvert= fluxDensity[x1:x2, y1:y2]


;; RA,DEC of the central pixel of the Cropped Image
X        = (IMGCEN[0] - CENTER[0]) *(abs(CDELT[0]))
Y        = (IMGCEN[1] - CENTER[1]) *(abs(CDELT[1]))
CRVAL[0] = IMG_RA - X
CRVAL[1] = IMG_DE - Y
PRINT, CRVAL
;X        = (CRPIX[0]-CENTER[0]) *(abs(CDELT[0]))
;Y        = (CRPIX[1]-CENTER[1]) *(abs(CDELT[1]))
;CRVAL[0] = CRVAL[0] - X
;CRVAL[1] = CRVAL[1] - Y
;PRINT, CRVAL
STOP

SXADDPAR, newHeader, 'NAXIS',  2
SXADDPAR, newHeader, 'NAXIS1',  DIMEN
SXADDPAR, newHeader, 'NAXIS2',  DIMEN
SXADDPAR, newHeader, 'CTYPE1',  CTYPE[0]
SXADDPAR, newHeader, 'CTYPE2',  CTYPE[1]
SXADDPAR, newHeader, 'CRVAL1',  CRVAL[0]
SXADDPAR, newHeader, 'CRVAL2',  CRVAL[1]
SXADDPAR, newHeader, 'CDELT1',  CDELT[0]
SXADDPAR, newHeader, 'CDELT2',  CDELT[1]
SXADDPAR, newHeader, 'CRPIX1',  CENTER[0]
SXADDPAR, newHeader, 'CRPIX2',  CENTER[1]


MWRFITS, imConvert, 'ngc4254.ha.sub.mask.flux.crop.fits', newHeader
print, 'Flux Density min and max:', min(imConvert), max(imConvert)

print, '                                 '       
print, 'Unit conversion is done ... ...'
print, '                                 ' 



END
