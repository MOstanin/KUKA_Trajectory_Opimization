
hold on
title('A-A')
xlabel('X');
ylabel('Y');
set(gca,'FontSize',12);

sigma=1;
num=20;
del=sigma/num;


for i=-num:num
   for j=-num:num
       if ~(i==0 && j==0)
           x=del*i;
           y=del*j;
           if x^2+y^2<=sigma^2
               plot(x,y,'ob','LineWidth',1);
           end
       end
   end
end

plot(0,0,'*g','LineWidth',4)