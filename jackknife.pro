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
