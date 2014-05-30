PRO ON_WRITEHEADER

path='/brahma/nurur/umd/project2/ngc4254/data/IRAM/'
file1=path + 'ngc4254.mom0.fits'
file2=path + 'ngc4254.mom0.flux.fits'

image1 = MRDFITS(file1, 0, header1)
image2 = MRDFITS(file2, 0, header2)


BSCALE  = SXPAR(HEADER1,'BSCALE')
BZERO   = SXPAR(HEADER1,'BZERO')
BLANK   = SXPAR(HEADER1,'BLANK')
CDELT   = SXPAR(HEADER1,'CDELT*')
CRPIX   = SXPAR(HEADER1,'CRPIX*')
CRVAL   = SXPAR(HEADER1,'CRVAL*')
CTYPE   = SXPAR(HEADER1,'CTYPE*')
CELLSCAL= SXPAR(HEADER1,'CELLSCAL')



print, cdelt 
print, crpix 
print, crval
print, cellscal

SXADDPAR, HEADER2, 'BSCALE', BSCALE
SXADDPAR, HEADER2, 'BZERO',  BZERO


print, '                                 '       
print, 'Copying Header Info is done ... ...'
print, '                                 ' 



END
