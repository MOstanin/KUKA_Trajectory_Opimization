
hold on
title('A-A')
xlabel('X');
ylabel('Y');
set(gca,'FontSize',12);

for i=15:15:360
   for j=0:5
%                distant from center to point
       if mod(i/15,2)==0 
           l=exp(j*(log(10/1.4)/5));
           x=cos(i*pi/180)*l;
           y=sin(i*pi/180)*l;
       else
           l=exp(j*(log(10)/5));
           x=cos(i*pi/180)*l;
           y=sin(i*pi/180)*l;
       end
       
       plot(x,y,'ob','LineWidth',1)
   end
end

plot(0,0,'*g','LineWidth',4)