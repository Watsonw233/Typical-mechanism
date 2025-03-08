clear;
%已知数据
l1=0.125;
l3=0.600;
l4=0.150;
l6=0.275;
l61=0.575;
omega1=1;
alpha1=0;
hd=pi/180;
du=180/pi;
%% 调用计算函数
for n1=1:459
    theta1(n1)=-2*pi+5.8119+(n1-1)*hd;
    ll=[l1,l3,l4,l6,l61];
    [theta,omega,alpha]=six_bar(theta1(n1),omega1,alpha1,ll);
    
    s3(n1)=theta(1);
    theta3(n1)=theta(2);
    theta4(n1)=theta(3);
    sE(n1)=theta(4);

    v2(n1)=omega(1);
    omega3(n1)=omega(2);
    omega4(n1)=omega(3);
    vE(n1)=omega(4);

    a2(n1)=alpha(1);
    alpha3(n1)=alpha(2);
    alpha4(n1)=alpha(3);
    aE(n1)=alpha(4);
end

%%
figure(3);
n1=1:459;
t=(n1-1)*2*pi/360;
subplot(2,2,1);
plot(t,theta3*du,'r-.');
grid on;
hold on;
axis auto;
[haxes,hline1,hline2]=plotyy(t,theta4*du,t,sE);
grid on;
hold on;

xlabel('时间/s')
axes(haxes(1));
ylabel('角位移/\circ')
axes(haxes(2));
ylabel('位移/m')
hold on;
grid on;
text(1.15,-0.65,'\theta_3')
text(3.4,0.27,'\theta_4')
text(2.25,-0.15,'s_E')










%%
function[theta,omega,alpha]=six_bar(theta1,omega1,alpha1,ll)
l1=ll(1);
l3=ll(2);
l4=ll(3);
l6=ll(4);
l61=ll(5);
%displacement
s3=sqrt((l1*cos(theta1))^2+(l6+l1*sin(theta1))^2);
theta3=acos(l1*cos(theta1)/s3);
theta4=pi-asin((l61-l3*sin(theta3))/l4);
sE=l3*cos(theta3)+l4*cos(theta4);
theta(1)=s3;
theta(2)=theta3;
theta(3)=theta4;
theta(4)=sE;
%velocity
A=[cos(theta3),-s3*sin(theta3),0,0;
    sin(theta3),s3*cos(theta3),0,0;
    0,-l3*sin(theta3),-l4*sin(theta4),-1;
    0,l3*cos(theta3),l4*cos(theta4),0];
B=[-l1*sin(theta1);l1*cos(theta1);0;0];
omega=A\(omega1*B);
v2=omega(1);
omega3=omega(2);
omega4=omega(3);
vE=omega(4);
%accelerated velocity
At=[omega3*sin(theta3),(v2*sin(theta3)+s3*omega3*cos(theta3)),0,0;
    -omega3*cos(theta3),(-v2*cos(theta3)+s3*omega3*sin(theta3)),0,0;
    0,(l3*omega3*cos(theta3)),(l4*omega4*cos(theta4)),0;
    0,-l3*omega3*sin(theta3),l4*omega4*sin(theta4),0];
Bt=[-l1*omega1*cos(theta1);-l1*omega1*sin(theta1);0;0];
alpha=A\(At*omega+omega1*Bt);
a2=alpha(1);
alpha3=alpha(2);
alpha4=alpha(3);
aE=alpha(4);
end
