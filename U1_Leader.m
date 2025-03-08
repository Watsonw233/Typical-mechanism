%%
clear;
%已知数据
l1=0.12;
l3=0.6;
l4=0.38;
omega1=1;
alpha1=0;
hd=pi/180;
du=180/pi;


%% 调用计算函数 形成数据矩阵
for n1=1:400
    theta1(n1)=n1*hd;
    [theta3(n1),s3(n1),omega3(n1),v23(n1),alpha3(n1),a2(n1)]=leader(theta1(n1),omega1,alpha1,l1,l4);
end
%%
figure(1);
n1=1:400;

subplot(2,2,1);
plot(n1,theta3*du);
grid on;
hold on;
axis auto;
[haxes,hline1,hline2]=plotyy(n1,theta3*du,n1,s3);
grid on;
hold on;

title('角位移及位移线图');
xlabel('曲柄转角 \theta_1/\circ')
axes(haxes(1));
ylabel('角位移/\circ')
axes(haxes(2));
ylabel('位移/m')
hold on;
grid on;

subplot(2,2,2);
plot(n1,omega3);
grid on;
hold on;
axis auto;
[haxes,hline1,hline2]=plotyy(n1,omega3,n1,v23);
grid on;
hold on;

title('角速度及速度线图');
xlabel('曲柄转角\theta_1/\circ')
axes(haxes(1));
ylabel('角速度/rad\cdots^{-1}')
axes(haxes(2));
ylabel('速度/m\cdot^{-1}')
hold on;
grid on;

subplot(2,2,3);
plot(n1,alpha3);
grid on;
hold on;
axis auto;
[haxes,hline1,hline2]=plotyy(n1,alpha3,n1,a2);
grid on;
hold on;
title('角加速度及加速度线图');
xlabel('曲柄转角\theta_1/\circ')
axes(haxes(1));
ylabel('角加速度/rad\cdots^{-2}')
axes(haxes(2));
ylabel('加速度/m\cdots^{-2}')
hold on;
grid on;


subplot(2,2,4);
n1=1;
x(1)=(s3(n1)*1000-50)*cos(theta3(n1));
y(1)=(s3(n1)*1000-50)*sin(theta3(n1));
x(2)=0;
y(2)=0;
x(3)=0;
y(3)=l4*1000+50;
x(4)=0;
y(4)=l4*1000;
x(5)=l1*1000*cos(theta1(n1));
y(5)=l1*1000*sin(theta1(n1))+l4*1000;
x(6)=(s3(n1)*1000+50)*cos(theta3(n1));
y(6)=(s3(n1)*1000+50)*sin(theta3(n1));
x(7)=l3*1000*cos(theta3(n1));
y(7)=l3*1000*sin(theta3(n1));
x(10)=(s3(n1)*1000-50)*cos(theta3(n1));
y(10)=(s3(n1)*1000-50)*sin(theta3(n1));
x(11)=x(10)+25*cos(pi/2-theta3(n1));
y(11)=y(10)-25*sin(pi/2-theta3(n1));
x(12)=x(11)+100*cos(theta3(n1));
y(12)=y(11)+100*sin(theta3(n1));
x(13)=x(12)-50*cos(pi/2-theta3(n1));
y(13)=y(12)+50*sin(pi/2-theta3(n1));
x(14)=x(10)-25*cos(pi/2-theta3(n1));
y(14)=y(10)+25*sin(pi/2-theta3(n1));
x(15)=x(10);
y(15)=y(10);
    i=1:5
    plot(x(i),y(i));
    grid on;
    hold on;
    i=6:7
    plot(x(i),y(i));
    grid on;
    hold on;
    i=10:15
    plot(x(i),y(i));
    grid on;
    hold on;
    plot(x(4),y(4),'o');
    plot(x(2),y(2),'o');
    plot(x(5),y(5),'o');
    title('导杆机构仿真');
    xlabel(' mm');
    ylabel('mm');
    axis equal;





%% 定义计算子函数
function[theta3,s3,omega3,v23,alpha3,a2]=leader(theta1,omega1,alpha1,l1,l4)
%displacement
s3=sqrt((l1*cos(theta1))^2+(l4+l1*sin(theta1))^2);
theta3=acos((l1*cos(theta1))/s3);
%velocity
A=[cos(theta3),-s3*sin(theta3);
    sin(theta3),s3*cos(theta3)];
B=[-l1*sin(theta1);l1*cos(theta1)];
omega=A\(omega1*B);
v23=omega(1);
omega3=omega(2);
%accelerated velocity
At=[-omega3*sin(theta3),(-v23*sin(theta3)-s3*omega3*cos(theta3));
    omega3*cos(theta3),(v23*cos(theta3)-s3*omega3*sin(theta3))];
Bt=[-l1*omega1*cos(theta1);-l1*omega1*sin(theta1)];
alpha=A\(omega1*Bt-At*omega);
a2=alpha(1);
alpha3=alpha(2);

end
% ?原动件角加速度为0，未考虑不为0状况 因此不具有普适性？<科氏加速度>

%%


