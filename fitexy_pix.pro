PRO FITEXY_PIX
;; FOR INTERFEROMETER + SINGLE DISH DATA 



ITER = 100


;; Read Data 
path='/brahma/nurur/umd/project2/ngc4254/data/ANALYSIS/PLOT_PIX15_IMG06/'
path= path + 'FITT/COMBN/data/UNSH/75AS/'


file2=path + 'pix_com_fuv.dat'
file4=path + 'pix_com_halp.dat'
file6=path + 'pix_com_comb.dat'
file8=path + 'pix_com_midi.dat'



PRINT, '    FITTING FOR CARMA+IRAM DATA            '
PRINT, '                                           '


;; FROM FUV MAP
PRINT, '    ---------------------------------------'
PRINT, '    SFRD DERIVED FROM FUV+24 MICRON MAP    '
PRINT, '    ---------------------------------------'


READCOL, FILE2, XX, SX1, YY, SY1, SXY
FITEXY, XX, YY, A, B, X_SIG=SX1, Y_SIG=SY1, SIGMA_A_B, CHI_SQ, Q

SIGA = SIGMA_A_B[0]
SIGB = SIGMA_A_B[1]
RCHI_SQ = CHI_SQ/(N_ELEMENTS(XX)-2.)
PRINT, A, SIGA, B, SIGB, RCHI_SQ, Q, FORMAT='(6F8.2)'

PRINT, 'FROM BOOTFITEXY '
BOOTFITEXY, XX,YY, SX1, SY1,ITER, A, SIGA, B, SIGB, RCHI, Q, SIGI
;PRINT, A, SIGA, B, SIGB, CHI_SQ, Q, SIGI, FORMAT='(7F8.2)'

stop


;; FROM HALPHA MAP
PRINT, '    -----------------------------------'
PRINT, '    SFRD DERIVED FROM HALPHA MAP       '
PRINT, '    -----------------------------------'


READCOL, FILE4, XX, SX1, YY, SY1, SXY
FITEXY, XX, YY, A, B, X_SIG=SX1, Y_SIG=SY1, SIGMA_A_B, CHI_SQ, Q

SIGA = SIGMA_A_B[0]
SIGB = SIGMA_A_B[1]
RCHI_SQ = CHI_SQ/(N_ELEMENTS(XX)-2.)
PRINT, A, SIGA, B, SIGB, RCHI_SQ, Q, FORMAT='(6F8.2)'


PRINT, 'FROM BOOTFITEXY '
BOOTFITEXY, XX,YY, SX1, SY1,ITER, A, SIGA, B, SIGB, RCHI, Q, SIGI
PRINT, A, SIGA, B, SIGB, CHI_SQ, Q, SIGI, FORMAT='(7F8.2)'


FOR I=0L, 1000-1 DO BEGIN
   SIG0 = 0.001 * I
    SY2  = SQRT(SY1^2 + SIG0^2)
    
    FITEXY, XX, YY, A, B, X_SIG=SX1,Y_SIG=SY2,SIGMA_A_B, CHI_SQ, Q
    
    SIGA = SIGMA_A_B[0]
    SIGB = SIGMA_A_B[1]
    RCHI_SQ = CHI_SQ/(N_ELEMENTS(XX)-2.)
    
  IF (RCHI_SQ GE 1.0 AND RCHI_SQ LT 1.005) THEN BREAK  
ENDFOR
PRINT, A, SIGA, B, SIGB, RCHI_SQ, Q, SIG0, FORMAT='(7F8.2)'


STOP




;; FROM MID-IR MAP
PRINT, '    -----------------------------------'
PRINT, '    SFRD DERIVED FROM OPTICAL + MID-IR '
PRINT, '    -----------------------------------'

SIGA = SIGMA_A_B[0]
SIGB = SIGMA_A_B[1]
RCHI_SQ = CHI_SQ/(N_ELEMENTS(XX)-2.)
PRINT, A, SIGA, B, SIGB, RCHI_SQ, Q, FORMAT='(6F8.2)'


PRINT, 'FROM BOOTFITEXY '
BOOTFITEXY, XX,YY, SX1, SY1,ITER, A, SIGA, B, SIGB, RCHI, Q
PRINT, A, SIGA, B, SIGB, CHI_SQ, Q, FORMAT='(6F8.2)'





;; FROM MID-IR MAP
PRINT, '    -----------------------------------'
PRINT, '    SFRD DERIVED FROM MID-IR           '
PRINT, '    -----------------------------------'


READCOL, FILE8, XX, SX1, YY, SY1, SXY
FITEXY, XX, YY, A, B, X_SIG=SX1, Y_SIG=SY1, SIGMA_A_B, CHI_SQ, Q

SIGA = SIGMA_A_B[0]
SIGB = SIGMA_A_B[1]
RCHI_SQ = CHI_SQ/(N_ELEMENTS(XX)-2.)
PRINT, A, SIGA, B, SIGB, RCHI_SQ, Q, FORMAT='(6F8.2)'


PRINT, 'FROM BOOTFITEXY '
BOOTFITEXY, XX,YY, SX1, SY1,ITER, A, SIGA, B, SIGB, RCHI, Q
PRINT, A, SIGA, B, SIGB, CHI_SQ, Q, FORMAT='(6F8.2)'






END









PRO BOOTFITEXY, XX,YY,SX1,SY1,ITER,A,SIGA,B,SIGB,RCHI,Q,SIGI
;;
NPTS = N_ELEMENTS(XX)
X    = FLTARR(NPTS)
Y    = FLTARR(NPTS)
        
N    = 1

;; DEFINE 2D ARRAYS FOR THE FIT
INCPT    = FLTARR(ITER, N)
INCPT_ERR= FLTARR(ITER, N)
SLOPE    = FLTARR(ITER, N)
SLOPE_ERR= FLTARR(ITER, N)
CHISQ    = FLTARR(ITER, N)
PROB     = FLTARR(ITER, N)


;; DEFINE 2D ARRAYS FOR SCATTER
RR       = FLTARR(ITER, N)
SCATT_INT= FLTARR(ITER, N)
;; DEFINE 1D ARRAYS FOR SCATTER
VAR      = FLTARR(N)
SIGI     = FLTARR(N)



FOR I=0L, ITER-1 DO BEGIN 
    
    ;; RADOMLY RE-SHUFFLE THE ARRAY ELEMENTS
    FOR J=0L, NPTS-1 DO BEGIN 
        K = INT( (NPTS-1) * RANDOMU(SEED) )
        X[J]= XX[K]
        Y[J]= YY[K]
    ENDFOR

    ;; ITERATE THE Y-ERROR BAR 
    FOR II=0L, 1000-1 DO BEGIN
        SIG0 = 0.001 * II
        SY2  = SQRT(SY1^2 + SIG0^2)
        
        FITEXY,X,Y,A0,B0, X_SIG=SX1,Y_SIG=SY2,SIGMA_A_B, CHI_SQ, Q
    
        SIGA = SIGMA_A_B[0]
        SIGB = SIGMA_A_B[1]
        RCHI_SQ = CHI_SQ/(N_ELEMENTS(X)-2.)
        
        IF (RCHI_SQ GE 1.0 AND RCHI_SQ LT 1.01) THEN BREAK  
    ENDFOR
    PRINT, A0, SIGA, B0, SIGB, RCHI_SQ, Q, SIG0, FORMAT='(7F8.2)'


    ;; SAVE RESULTS IN THE 2D ARRAY
    FOR M=0L, N-1 DO BEGIN 
        INCPT[I,M]      =    A0
        INCPT_ERR[I,M]  =  SIGA
        SLOPE[I,M]      =    B0
        SLOPE_ERR[I,M]  =  SIGB
        CHISQ[I,M]      = RCHI_SQ 
        PROB[I,M]       = Q
        SCATT_INT[I,M]  = SIG0
    ENDFOR        
ENDFOR


;; PART 2 
;; FIND THE MEAN AND STDEV  
A      =  MEAN(INCPT[*,0])
SIGA   =  SQRT( TOTAL(INCPT_ERR[*,0])^2 )/(ITER-1.)  
B      =  MEAN(SLOPE[*,0])
SIGB   =  SQRT( TOTAL(SLOPE_ERR[*,0])^2 )/(ITER-1.)
RCHI   =  MEAN(CHISQ[*,0])
Q      =  MEAN( PROB[*,0])   
SIGI   =  MEAN(SCATT_INT[*,0])   
END








PRO JACKKNIFE, XX,YY,ITER,A,SIGA,B,SIGB,SIGI
;; 
NPTS   = N_ELEMENTS(XX)
N    = 6

;; DEFINE THE 2D ARRAY FOR THE FIT
INCPT    = FLTARR(ITER, N)
INCPT_ERR= FLTARR(ITER, N)
SLOPE    = FLTARR(ITER, N)
SLOPE_ERR= FLTARR(ITER, N)


;; DEFINE 2D ARRAYS FOR SCATTER
SCATT_INT= FLTARR(ITER, N)
;; DEFINE 1D ARRAYS FOR SCATTER
VAR      = FLTARR(N)
SIGI     = FLTARR(N)



;; PART 1
FOR I=0L, ITER-1 DO BEGIN
    
    ;; RADOMLY SELECT THE THE ARRAYS
    J1 = INT( (NPTS-1) * RANDOMU(SEED) )
    J2 = INT( (NPTS-1) * RANDOMU(SEED) )
    
    ;IF (J1 GT J2) THEN BEGIN
    ;    J3 = J1
    ;    J1 = J2
    ;    J2 = J3
    ;ENDIF
    IF (J1 LT 200) THEN J1=200


    ;; NEW, SHORTEND DATA ARRAY
    X = XX[0:J1]
    Y = YY[0:J1]
    
    ;; DEFINE 2D ARRAYS FOR SCATTER
    IND = N_ELEMENTS(X)
    RR  = FLTARR(IND, N)
        
    ;; APPLY SIXLIN ON RANDOMIZE ARRAYS
    SIXLIN, X, Y, A, SIGA, B, SIGB
    
    
    ;; CALCULATE INTRINSIC SCATTER
    FOR M=0L, N-1 DO BEGIN
        FOR L=0L, IND-1 DO BEGIN
            RR[L, M] = Y[L] - (A[M] + B[M]*X[L])
        ENDFOR
        VAR[M]   = TOTAL((RR[*,M]-MEAN(RR[*,M]))^2 )/NPTS 
        SIGI[M]  = SQRT( VAR[M] )
    ENDFOR
    
    
    ;; SAVE RESULTS IN THE 2D ARRAY
    FOR M=0L, N-1 DO BEGIN 
        INCPT[I,M]      =    A[M]
        INCPT_ERR[I,M]  = SIGA[M]
        SLOPE[I,M]      =    B[M]
        SLOPE_ERR[I,M]  = SIGB[M]
        SCATT_INT[I,M]  = SIGI[M]
    ENDFOR        
ENDFOR


;; PART 2
;; FIND THE MEAN AND STDEV  
FOR I=0L, N-1 DO BEGIN 
    A[I]    =  MEAN(INCPT[*,I])
    SIGA[I] =  SQRT( TOTAL(INCPT_ERR[*,I])^2 )/(NPTS-1.)  
    B[I]    =  MEAN(SLOPE[*,I])
    SIGB[I] =  SQRT( TOTAL(SLOPE_ERR[*,I])^2 )/(NPTS-1.) 
    SIGI[I] =  SQRT( TOTAL(SCATT_INT[*,I])^2 )/(ITER-1.)
ENDFOR


END
