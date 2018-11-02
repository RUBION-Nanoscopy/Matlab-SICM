function I = ACApproachCurve(C, time, f, d, T)

    % Calculates
    % int_0^T (AppCurve((z+d*sin(2*pi*f*t),C,0))*sin(2*pi*f*t) dt
    % (Hoffentlich)
    
    % für 0
    I = ones(numel(time),1);
    
    K = 2*pi*f;
    
    v=0.1;% pro sekunde
    
    for i=1:numel(time)
        Z=(2-v*time(i))+2*d;
        
        
        A=sqrt(C^2+2*C*Z-d^2+Z^2);
        
        B = C+Z;
    
        
        nenner = 1/(d*K*A);
    
        t=time(i)-T/2;
        zaehler0 = 2*C*B*atan((B*tan(t*K/2)+d)/A)-A*K*C+d*cos(K*t);
        
        t=time(i)+T/2;
        zaehlerT = 2*C*B*atan((B*tan(t*K/2)+d)/A)-A*K*C+d*cos(K*t);
        
        
  
        I(i)=zaehlerT*nenner - zaehler0*nenner;
    end