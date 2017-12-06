clear all;
close all;

% kuka params
Qmin=[-pi -pi -pi -pi -pi -pi -pi];
Qmax=[pi pi pi pi pi pi pi];


W=eye(7); 
qN=[0 0 0 0 0 0 0];
s=1;
s2=0;

limit_exceeded=false;
Smin=[0 0 0 0 0 0 0];
Smax=[0 0 0 0 0 0 0];

J=jac_iiwa(q);
qSNS=qN'+pinv(J*W)*(s*eps'-J*qN');

condition_variable=false;
for i=1:7
    if q(i)<Qmin(i)||q(i)>Qmax(i)
        condition_variable=true;
        break;
    end
end

if condition_variable
        condition_variable=false;
        limit_exceeded=true;
end


while limit_exceeded
    
    J=jac_iiwa(q);
    qSNS=qN'+pinv(J*W)*(s*eps'-J*qN');
    
    condition_variable=false;
    for i=1:7
        if q(i)<Qmin(i)||q(i)>Qmax(i)
            condition_variable=true;
            break;
        end
    end
    
    
    if condition_variable
        condition_variable=false;
        limit_exceeded=true;
        
        a=pinv(J*W)*eps';
        b=qN'-pinv(J*W)*J*qN';
        
        
        for i=1:7
            Smin(i)=(Qmin(i)-b(i))/a(i);
            Smax(i)=(Qmax(i)-b(i))/a(i);
            if Smin(i)>Smax(i)
                swap_variable=Smin(i);
                Smin(i)=Smax(i);
                Smax(i)=swap_variable;
            end
        end
        
        smax_=min(Smax);
        smin_=max(Smin);
        
        if smin_>smax_ || smax_<0 || smin_>1
            task_scaling=0;
        else
            task_scaling=min([smax_,1]);
        end
        
        if task_scaling>s2
            s=task_scaling;
            W2=W;
            qN2=qN;
        end
        
        j=[most critical join];
        W(j,j)=0;
        
        if qN(j)>Qmax(j); qN(j)=Qmax(j); end
        if qN(j)<Qmin(j); qN(j)=Qmin(j); end
        
        if rank(J*W)<6
            s=s2; W=W2; qN=qN2;
            qSNS=qN'+pinv(J*W)*(s*eps'-J*qN');
            
            limit_exceeded=false;
        end
    end
    
end
        
            
            
            
            
            
            
            
            
            
            
            
            
            
            
            
        
        
        
    
    
    
    
    
    
    



