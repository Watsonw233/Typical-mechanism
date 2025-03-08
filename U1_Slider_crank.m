%%
clear;
l1=100;
l2=300;
e=0;%偏置距离
hd=pi/180;
du=180/pi;
omega1=10;
alpha1=0;

%% 调用计算函数 形成数据矩阵
for  n1=1:720
    theta1(n1)=(n1-1)*hd;
    [theta2(n1),s3(n1),omega2(n1),v3(n1),alpha2(n1),a3(n1)]=slider_crank(theta1(n1),omega1,alpha1,l1,l2,e);
end
%% 图像输出
figure(1);
n1=1:720;
subplot(2,2,1);
[AX,H1,H2]=plotyy(theta1*du,theta2*du,theta1*du,s3);
set(get(AX(1),'ylabel'),'String','连杆角位移/\circ')%'String'用于引出对后续'--'识别
set(get(AX(2),'ylabel'),'String','滑块位移/mm')
title('位移线图');
xlabel('曲柄转角\theta_1/\circ')
grid on;

subplot(2,2,2);
[AX,H1,H2]=plotyy(theta1*du,omega2,theta1*du,v3);
title('速度线图');
xlabel('曲柄转角\theta_1/\circ')
ylabel('连杆角速度/rad\cdots^{-1}')
set(get(AX(2),'ylabel'),'String','滑块速度/mm\cdots^{-1}')
grid on;

subplot(2,2,3);
[AX,H1,H2]=plotyy(theta1*du,alpha2,theta1*du,a3);
title('加速度线图');
xlabel('曲柄转角\theta_1/\circ')
ylabel('连杆角加速度/rad\cdots^{-2}')
set(get(AX(2),'ylabel'),'String','滑块角速度/mm\cdots^{-1}')
grid on;

%%
subplot(2,2,4);
x(1)=0;
y(1)=0;
x(2)=l1*cos(70*hd);
y(2)=l1*sin(70*hd);
x(3)=s3(70);
y(3)=e;
x(4)=s3(70);
y(4)=0;
x(5)=0;
y(5)=0;
x(6)=x(3)-40;
y(6)=y(3)+10;
x(7)=x(3)+40;
y(7)=y(3)+10;
x(8)=x(3)+40;
y(8)=y(3)-10;
x(9)=x(3)-40;
y(9)=y(3)-10;
x(10)=x(3)-40;
y(10)=y(3)+10;

i=1:5;
plot(x(i),y(i));
grid on;
hold on;
i=6:10;               
plot(x(i),y(i));
title('曲柄滑块机构'); 
grid on;
hold on;
xlabel('mm')
ylabel('mm')
axis([-50 400 -20 130]);
plot(x(1),y(1),'o');
plot(x(2),y(2),'o');
plot(x(3),y(3),'o');

%% 运动仿真
figure(2)
m=moviein(20);
j=0;
for n1=1:5:360
    j=j+1;
    clf;
    %
    x(1)=0;
    y(1)=0;
    x(2)=l1*cos(n1*hd);
    y(2)=l1*sin(n1*hd);
    x(3)=s3(n1);
    y(3)=e;
    x(4)=(l1+l2+50);  %% ???
    y(4)=0;
    x(5)=0;
    y(5)=0;
    x(6)=x(3)-40;
    y(6)=y(3)+10;
    x(7)=x(3)+40;
    y(7)=y(3)+10;
    x(8)=x(3)+40;
    y(8)=y(3)-10;
    x(9)=x(3)-40;
    y(9)=y(3)-10;
    x(10)=x(3)-40;
    y(10)=y(3)+10;
    %
    i=1:3;
    plot(x(i),y(i));
    grid on;hold on;
    i=4:5;              %%  ????
    plot(x(i),y(i));
    i=6:10;
    plot(x(i),y(i));
    plot(x(1),y(1),'o');
    plot(x(2),y(2),'o');
    plot(x(3),y(3),'o');
    
    title('曲柄滑块机构');
    xlabel('mm')
    ylabel('mm')
    axis([-150 450 -150 150]);
    m(j)=getframe;
end
movie(m)












%% 定义计算子函数
function[theta2,s3,omega2,v3,alpha2,a3]=slider_crank(theta1,omega1,alpha1,l1,l2,e)
%displacement
theta2=asin((e-l1*sin(theta1))/l2);
s3=l1*cos(theta1)+l2*cos(theta2);
%velocity
A=[l2*sin(theta2) 1;
    -l2*cos(theta2) 0];
B=[-l1*sin(theta1);l1*cos(theta1)];
omega=A\(omega1*B);
omega2=omega(1);
v3=omega(2);
%accelerated velocity
At=[omega2*l2*cos(theta2),0;
    omega2*l2*sin(theta2),0];
Bt=[-omega1*l1*cos(theta1);-omega1*l1*sin(theta1)];
alpha=A\(omega1*Bt+alpha1*B-At*omega);
alpha2=alpha(1);
a3=alpha(2);
end

















