function [ qSNS ] = inv_kin_iiwa_del_qSNS( q, eps, qN )
%inv_kin_iiwa_del_qSNS cal delta q for inv_kin_iiwa
%   Calculated delta q by SNS algorithm

if nargin==2
    qN=[0 0 0 0 0 0 0];
end


% kuka params
eye_vec=[170 130 170 130 170 130 175];
Qmin=(-pi*eye_vec/180 - q)/0.1;
Qmax=(pi*eye_vec/180 - q)/0.1;

speed=[85 85 100 75 130 135 135]*pi/180;
% speed=0.2;
for i=1:7
    Qmin(i)=max(Qmin(i),-speed(i));
    Qmax(i)=min(Qmax(i),speed(i));
end
Qmin=round(Qmin,5);
Qmax=round(Qmax,5);

W=eye(7);

s=1;
s2=0;

Smin=[0 0 0 0 0 0 0];
Smax=[0 0 0 0 0 0 0];

J=jac_iiwa2(q);

JW=J*W;
limit_exceeded=true;

while limit_exceeded
    limit_exceeded=false;

    J2=pinv(JW);
    qSNS=qN'+J2*(s*eps'-J*qN');
    
    condition_variable=false;
    for i=1:7
        if qSNS(i)<Qmin(i)||qSNS(i)>Qmax(i)
            condition_variable=true;
            break;
        end
    end
    
    
    if condition_variable
        limit_exceeded=true;
        
        a=J2*eps';
        b=qSNS-a;
        
        for c=1:7
            if W(c,c)~=0
                Smin(c)=-1;
                Smax(c)=1;
            else
                Smin(c)=(Qmin(c)-b(c))/a(c);
                Smax(c)=(Qmax(c)-b(c))/a(c);
                if Smin(c)>Smax(c)
                    swap_variable=Smin(c);
                    Smin(c)=Smax(c);
                    Smax(c)=swap_variable;
                end
            end
        end
        
        smax_=min(Smax);
        smin_=max(Smin);
        for i=1:7
            if smax_==Smax(i); j=i; end
        end
        
        if smin_>smax_ || smax_<0 || smin_>1
            task_scaling=0;
        else
            task_scaling=min([smax_,1]);
        end
        
        if task_scaling>=s2
            s2=task_scaling;
            W2=W;
            qN2=qN;
        end
        
%        	max_j=0;
%         for i=1:7
%             if round(qSNS(i),5)~=0
%                 if max_j<(qSNS(i))^2 && (W(i,i)~=0)
%                     max_j=(qSNS(i))^2; j=i;
%                 end
%             end
%         end
        
%         j=most critical join;
        W(j,j)=0;
        
        if qSNS(j)>Qmax(j); qN(j)=Qmax(j); end
        if qSNS(j)<Qmin(j); qN(j)=Qmin(j); end
        JW=J*W;
        r=rank(JW);
        if r<6
            s=s2; W=W2; qN=qN2;
            qSNS=qN'+pinv(J*W)*(s*eps'-J*qN');
            limit_exceeded=false;
        end
    end
    
end

end

