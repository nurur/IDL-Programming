PRO MJS2JP, HEAD, FWHM=FWHM, CONFAC
;
; CONVERT 'MILLION JY/STR' TO JY/PIX
;
EXTAST, HEAD, AST, NOPARAMS
;
GETPIX, HEAD, PIXEL=PIXEL

PIXAREA= PIXEL *PIXEL
CONFAC = 1.E+06*(PIXAREA/4.2545E+10)

END