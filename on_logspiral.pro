PRO ON_LOGSPIRAL



t=(2* !dpi) * (3.0 - indgen(1000)/333.)



x= 0.1* exp(0.2*t) * cos(t)
y= 0.1* exp(0.2*t) * sin(t)
plot, x, y, xrange=[-2,2], yrange=[-1.2,1.2], xstyle=1, ystyle=1




x= -0.1* exp(0.2*t) * cos(t)
y= -0.1* exp(0.2*t) * sin(t)
plot, x, y, xrange=[-2,2], yrange=[-1.2,1.2], xstyle=1, ystyle=1




END
