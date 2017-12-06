clear
close all

L1 = Link('d', 360, 'a', 0, 'alpha', pi/2);
L2 = Link('d', 0, 'a', 0, 'alpha', -pi/2);
L3 = Link('d', 420, 'a', 0, 'alpha', pi/2);
L4 = Link('d', 0, 'a', 0, 'alpha', -pi/2);
L5 = Link('d', 400, 'a', 0, 'alpha', pi/2);
L6 = Link('d', 0, 'a', 0, 'alpha', -pi/2);
L7 = Link('d', 130, 'a', 0, 'alpha', 0);

bot = SerialLink([L1 L2 L3 L4 L5 L6 L7], 'name', 'KUKA robot');
q=[0 0 0 0.7853981 0 0 0];
bot.plot(q);


goal_T=forward_kin_iiwa(q)
% jacob0(bot,q)

% bot = SerialLink([L1 L2], 'name', 'KUKA robot');
% bot.plot([pi/4 pi/4]);


