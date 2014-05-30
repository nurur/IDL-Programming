
PRO GETPSF, IMAGE, HEAD, NEWFWHM=NEWFWHM,SIZE=SIZE,PSFFWHM=PSFFWHM,PSF=PSF 
;
;
GETPIX, HEAD, PIXEL=PIXEL

oldBMAJ = SXPAR(HEAD,'BMAJ')
oldBMIN = SXPAR(HEAD,'BMIN')

oldFWHM = SQRT(oldBMAJ * oldBMIN)        ; IN ARCSEC


oldBEAM = 1.1331*oldFWHM^2   
newBEAM = 1.1331*newFWHM^2   

;; FIND EFFECTIVE FWHM IN ARCSEC
PSFFWHM = SQRT(newFWHM^2 - oldFWHM^2)    ; IN ARCSEC
;; IN PIXEL
PSFFWHM = NINT(PSFFWHM/PIXEL)            ; IN PIXEL 


PRINT, '                                     '
PRINT, 'INSIDE PROCEDURE *** getFWHM.PRO *** '
PRINT, 'OLD BEAM SIZE, NEW BEAM SIZE                  : ', OLDFWHM, NEWFWHM, $
FORMAT='(A, 2F8.2)' 
PRINT, 'TOTAL NUMBER OF PIXELS FOR THE FWHM OF THE PSF: ', PSFFWHM,          $
FORMAT='(A, F8.2)' 
PRINT, 'INSIDE PROCEDURE ***             *** '
PRINT, '                                     '


newBMAJ = NEWFWHM
newBMIN = NEWFWHM

SXDELPAR, HEAD, 'BMAJ'
SXDELPAR, HEAD, 'BMIN'
SXADDPAR, HEAD, 'BMAJ',  newBMAJ
SXADDPAR, HEAD, 'BMIN',  newBMIN


;; GENERATE PSF
PSF  = PSF_GAUSSIAN(NPIXEL=SIZE, FWHM=PSFFWHM)
PSF  = PSF/total(PSF) 
HELP, PSF


END
