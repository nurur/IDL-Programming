PRO BOOTSTRAP, XX,YY,ITER,NFIT,A,SIGA,B,SIGB, SIGI=SIGI, RR=RR 

;;
NPTS = N_ELEMENTS(XX)
X    = FLTARR(NPTS)
Y    = FLTARR(NPTS)
        
N    = NFIT

;; DEFINE 2D ARRAYS FOR THE FIT
INCPT    = FLTARR(ITER, N)
INCPT_ERR= FLTARR(ITER, N)
SLOPE    = FLTARR(ITER, N)
SLOPE_ERR= FLTARR(ITER, N)

;; DEFINE 2D ARRAYS FOR SCATTER
RR       = FLTARR(NPTS, N)
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


    ;; APPLY SIXLIN ON RANDOMIZE ARRAYS
    SIXLIN, X,Y, A, SIGA, B, SIGB



    ;; CALCULATE OBSERVED SCATTER IN THE DATA
    FOR M=0L, N-1 DO BEGIN
        
        
        LTYPE = FLTARR(5, NPTS)
        DIMEN = SIZE(LTYPE)
        
        FOR I1=0L, NPTS-1 DO BEGIN      
            LTYPE[0,I1] = (A[M]-SIGA[M]) + (B[M]+SIGB[M]) * X[I1]
            LTYPE[1,I1] = (A[M]+SIGA[M]) + (B[M]-SIGB[M]) * X[I1]
            LTYPE[2,I1] = (A[M])         + (B[M])         * X[I1]
            LTYPE[3,I1] = (A[M]+SIGA[M]) + (B[M])         * X[I1]
            LTYPE[4,I1] = (A[M]-SIGA[M]) + (B[M])         * X[I1]
        ENDFOR
        
        
        SUM=0
        FOR N1=0L, DIMEN[1]-1 DO BEGIN
            
            FOR N2=0L, NPTS-1 DO BEGIN
               ;RR[N2,M] = Y[N2] - (A[M] + B[M]*X[N2])
                RR[N2,M] = Y[N2] - LTYPE[N1, N2] 
            ENDFOR
            
            VAR[M] = TOTAL((RR[*,M]-MEAN(RR[*,M]))^2)/(NPTS-1.)            
            SUM    = SUM + VAR[M]
        ENDFOR        
        
        SIGI[M]  = SQRT( SUM/DIMEN[1] )
    ENDFOR
    ;PRINT, SIGI[2]



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
    SIGA[I] =  SQRT( TOTAL(INCPT_ERR[*,I])^2 )/(ITER-1.)  
    B[I]    =  MEAN(SLOPE[*,I])
    SIGB[I] =  SQRT( TOTAL(SLOPE_ERR[*,I])^2 )/(ITER-1.)
    SIGI[I] =  SQRT( TOTAL(SCATT_INT[*,I])^2 )/(ITER-1.)
ENDFOR


END
