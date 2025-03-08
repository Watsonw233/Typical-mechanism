%%

clear;
%已知数据
l1=436.10;l2=1344.13;l3=1117.20;l4=1350.00;
omega1=2*pi*16/60;
alpha1=0;
hd=pi/180;
du=180/pi;

%调用函数 计算并记录数据（原动件转动0-2pi时的从动件角位移，角速度，角加速度） 
for n1=1:361
    theta1=(n1-1+38.85)*hd;
    [theta,omega,alpha]=crank_roker(theta1,omega1,alpha1,l1,l2,l3,l4);
    theta2(n1)=theta(1);theta3(n1)=theta(2);
    omega2(n1)=omega(1);omega3(n1)=omega(2);
    alpha2(n1)=alpha(1);alpha3(n1)=alpha(2);
end

% Omega=du*omega3
% Omega=Omega'
% xlswrite('data3.xlsx',Omega)
% Theta=du*theta3
% Theta=Theta'
% xlswirite('摆杆角位移',Theta)
% Alpha3=alpha3'
% Aet=1489.69*Alpha3
% xlswrite('E点切向加速度',Aet)
%% 图像输出
%%
figure(1)
n1=1:361;
subplot(2,2,1);
plot(n1,theta2*du,n1,theta3*du,'k');
title('角位移线图');
xlabel('曲柄转角\theta_1/\circ')
ylabel('角位移/\circ')
grid on;hold on;
text(310,130,'\theta_3')
text(140,30,'\theta_2')
%%
subplot(2,2,2);
plot(n1,omega2,n1,omega3,'k')
title('角速度线图');
xlabel('曲柄转角\theta_1/\circ')
ylabel('角速度/rad\cdots^{-1}')% '\cdot' ~ '·'
grid on;hold on;
text(250,130,'\omega_2')
text(130,165,'\omega_3')

%
subplot(2,2,3)
plot(n1,alpha2,n1,alpha3,'k')
title('角加速度线图');
xlabel('曲柄转角\theta_1/\circ')
ylabel('角加速度/rad\cdots^{-1}')
grid on;hold on;
text(230,2e4,'\alpha_2')
text(45,4.5e4,'\alpha_3')

%%
% subplot(2,2,4)
% x(1)=0;
% y(1)=0;
% x(2)=l1*cos(70*hd);
% y(2)=l1*sin(70*hd);
% x(3)=l4+l3*cos(theta3(71));
% y(3)=l3*sin(theta3(71));
% x(4)=l4;
% y(4)=0;
% x(5)=0;
% y(5)=0;
% plot(x,y);
% grid on;hold on;
% plot(x(1),y(1),'o');
% plot(x(2),y(2),'o');
% plot(x(3),y(3),'o');
% plot(x(4),y(4),'o');
% title('铰链四杆机构');
% xlabel('mm')
% ylabel('mm')
% axis([-2500 1500 -2000 2000]);%限制图像展示范围
%%
% figure(2)
% m=moviein(20);
% j=0;
% for n1=1:5:360
%     j=j+1;
%     clf;
%     x(1)=0;
%     y(1)=0;
%     x(2)=l1*cos((n1-1)*hd);
%     y(2)=l1*sin((n1-1)*hd);
%     x(3)=l4+l3*cos(theta3(n1));
%     y(3)=l3*sin(theta3(n1));
%     x(4)=l4;
%     y(4)=0;
%     x(5)=0;
%     y(5)=0;
%     plot(x,y);
%     grid on;hold on;
%     plot(x(1),y(1),'o');
%     plot(x(2),y(2),'o');
%     plot(x(3),y(3),'o');
%     plot(x(4),y(4),'o');
%     axis([-1500 3500 -2500 2000]);
%     title('铰链四杆机构');xlabel('mm');ylabel('mm')
%     m(j)=getframe;
% end
% movie(m);


%%
function[theta,omega,alpha]=crank_roker(theta1,omega1,alpha1,l1,l2,l3,l4)
%1. 计算从动件角位移
L=sqrt(l4*l4+l1*l1-2*l1*l4*cos(theta1));
phi=asin((l1./L)*sin(theta1));
beta=acos((-l2*l2+l3*l3+L*L)/(2*l3*L));
if beta<0
    beta=beta+pi;
end
theta3=pi-phi-beta;
theta2=asin((l3*sin(theta3)-l1*sin(theta1))/l2);
theta=[theta2;theta3];

%2. 计算从动件角速度
A=[-l2*sin(theta2), l3*sin(theta3);
    l2*cos(theta2), -l3*cos(theta3)];
B=[l1*sin(theta1); -l1*cos(theta1)];
omega=A\(omega1*B);
omega2=omega(1);omega3=omega(2);

%3. 计算从动件角加速度
A=[-l2*sin(theta2), l3*sin(theta3);
    l2*cos(theta2), -l3*cos(theta3)];
At=[-omega2*l2*cos(theta2), omega3*l3*cos(theta3);
    -omega2*l2*sin(theta2), omega3*l3*sin(theta3)];
B=[l1*sin(theta1); -l1*cos(theta1)];
Bt=[omega1*l1*cos(theta1);omega1*l1*sin(theta1)];
alpha=A\(-At*omega + alpha1*B + omega1*Bt);
end

