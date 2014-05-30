
PRO IMOFFSETS, HEAD, X, Y
;
;
NAXIS= SXPAR(head, 'NAXIS*')
CRVAL= SXPAR(head, 'CRVAL*')    ; central pixel in {ra,dec}
CRPIX= SXPAR(head, 'CRPIX*')    ; central pixel in {x,y}

;RESULT= LOGICAL_TRUE( SXPAR(header, 'CDELT1') )
;IF (RESULT GT 0) THEN BEGIN
;    PRINT, 'CDELT IS AVAILABLE IN THE HEAD'
;    PRINT, '                                   '
;
;    CDELT = SXPAR(header, 'CDELT*')
;    DEL_RA = ABS( CDELT[0] )
;    DEL_DE = ABS( CDELT[1] )
;ENDIF
;
;IF (RESULT EQ 0) THEN BEGIN
;    PRINT, 'CDELT IS NOT AVAILABLE IN THE HEAD, USING CD*_* PARAMETERS INSTEAD'
;    PRINT, '                                   '
;    CD1_1= SXPAR(header, 'CD1_1') ; degree/pixel
;    CD1_2= SXPAR(header, 'CD1_2') ; degree/pixel
;    CD2_1= SXPAR(header, 'CD2_1') ; degree/pixel
;    CD2_2= SXPAR(header, 'CD2_2') ; degree/pixel
;    ;;
;    DEL_RA = ABS( CD1_1 )
;    DEL_DE = ABS( CD2_2 )
;ENDIF

EXTAST, HEAD, AST, NOPARAMS
PRINT, 'IMOFFSETS: ASTROMETRY PARAMETER TYPE', NOPARAMS

IF (NOPARAMS EQ 1 OR NOPARAMS EQ 3) THEN BEGIN 
    CDELT = SXPAR(HEAD, 'CDELT*')
    DEL_RA = ABS( CDELT[0] ) ; IN DEGREE
    DEL_DE = ABS( CDELT[1] ) ; IN DEGREE
ENDIF


IF (NOPARAMS EQ 2) THEN BEGIN 
     DEL_RA = ABS(AST.CD[0]) ; IN DEGREE
     DEL_DE = ABS(AST.CD[3]) ; IN DEGREE
ENDIF



X   = FLTARR(NAXIS[0])
Y   = FLTARR(NAXIS[1])
  
NX2 = CEIL(NAXIS[0]/2.)
TMP = FLTARR(NX2)
FOR I=0L, NX2-1 DO BEGIN
    TMP[I] = (-DEL_RA*I) * 3600. 
ENDFOR 
X[0:NX2-1] = REVERSE(TMP)

FOR I=NX2, NAXIS[0]-1 DO BEGIN
    J = I-NX2+1
    X[I] = (+DEL_RA*J) * 3600.
ENDFOR 


NY2 = CEIL(NAXIS[1]/2.)
TMP = FLTARR(NY2)
FOR I=0L, NY2-1 DO BEGIN
    TMP[I] = (-DEL_DE*I) * 3600. 
ENDFOR 
Y[0:NY2-1] = REVERSE(TMP)

FOR I=NY2, NAXIS[1]-1 DO BEGIN
    J = I-NY2+1
    Y[I] = (+DEL_DE*J) * 3600.
ENDFOR 



;FOR i=0, NAXIS[0]-1 DO BEGIN
;;   print, X[i] 
;ENDFOR 


END
