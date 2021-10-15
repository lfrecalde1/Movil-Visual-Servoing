%% Propuesta de una ley de control basado en optimizacion %%
clc, clear all, close all;
 
%% Definicion de los tiempos del sistema
ts = 0.1;
t_final = 50;

%% Generacion del vector de tiempos del sistema
t =[0:ts:t_final];


%% Definicion de constantes del sistema
a = 0.1;
%% Generacion del vector de constantes del sistema
x = -0.7142;
y = -0.1399;
z = 0.0025;
th(1) = 4*(pi/180);

%% Desplazamiento del punto de interes del sistema
hx = x + a*cos(th(1));
hy = y + a*sin(th(1));
hz = z;

%% Generacionn del vector de estados generales del sistema
h = [hx;hy;hz;th(1)];

%% Senales de control

%% Definicion de los parametros de la camara
%% Defincion de la distancia focal del sistema
f = 0.015;
uo = 512;
vo = 512;
pw = 1e-05;

param = [f; uo; vo; pw];

%% Matrix para la imagen no se considera distorison de lentes
K = [1/pw, 0, uo;...
     0, 1/pw, vo;...
     0, 0,        1];
 
%% COnversion al plano de la imagen 
F = [f, 0, 0, 0;...
     0, f, 0, 0;...
     0, 0, 1, 0];
 

%% Objeto en el espacio 
P = [1, 1,1,1,1;...
     -0.05, 0.05,0.05,-0.05,-0.05;...   
     0.1, 0.1,0.05,0.05,0.1];
 
p(:,1) = cemera(K, F, P, h);

%% definicion de los pixeles deseados del sistema
pd = [978.2503  197.3365  678.7556  215.9388  678.7556  377.3047  978.2503  358.7024  978.2503  197.3365]';


%% Simulacion
for k=1:length(t)-1
   %% definion de vectores generales
   pe(:,k) = pd-p(:,k);
   
   qref = control(param, pd, p(:,k), P, h(:,k));
   
   u(k) = qref(1);
   w(k) = qref(2);
   
   v = [u(k);w(k)];
   %% Evolucion del sistema
   h(:,k+1) =  Cinematica(h(:,k), v, ts);
   
   %% Evolucion de los pixeles
   p(:,k+1) = cemera(K, F, P, h(:,k+1));
    
end
figure
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 2]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 10 4]);

plot3(h(1,:),h(2,:),h(3,:),'-','Color',[226,76,44]/255,'linewidth',1); hold on;
plot3(P(1,:),P(2,:),P(3,:),'Color',[100,76,44]/255,'linewidth',1); hold on;
grid on;
legend({'$h$','$P$'},'Interpreter','latex','FontSize',11,'Orientation','horizontal');
legend('boxoff')
title('$\textrm{Evolucion del sistema}$','Interpreter','latex','FontSize',9);
ylabel('$[m]$','Interpreter','latex','FontSize',9);
xlabel('$[m]$','Interpreter','latex','FontSize',9);
xlim([-1 1])
ylim([-1 1])
zlim([0 1])
print -dpng Sistema
print -depsc Sistema

figure
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 2]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 10 4]);
plot(t(1,1:length(u)),u,'Color',[223,67,85]/255,'linewidth',1); hold on
plot(t(1,1:length(w)),w,'Color',[56,171,217]/255,'linewidth',1); hold on
grid on;
legend({'$\mu$','$\omega$'},'Interpreter','latex','FontSize',11,'Orientation','horizontal');
legend('boxoff')
title('$\textrm{Control Valores velocidad}$','Interpreter','latex','FontSize',9);
ylabel('$[m/s][rad/s]$','Interpreter','latex','FontSize',9);
xlabel('$\textrm{Time}[s]$','Interpreter','latex','FontSize',9);
print -dpng Control
print -depsc Control

figure
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 2]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 10 4]);
set(gca,'Ydir','reverse')

plot(p(1,:),p(2,:),'--','Color',[223,67,85]/255,'linewidth',1); hold on
plot(p(3,:),p(4,:),'--','Color',[56,171,217]/255,'linewidth',1); hold on
plot(p(5,:),p(6,:),'--','Color',[46,188,89]/255,'linewidth',1); hold on
plot(p(7,:),p(8,:),'--','Color',[56,10,217]/255,'linewidth',1); hold on

plot(pd(1,:),pd(2,:),'x','Color',[223,67,85]/255,'linewidth',1); hold on
plot(pd(3,:),pd(4,:),'x','Color',[56,171,217]/255,'linewidth',1); hold on
plot(pd(5,:),pd(6,:),'x','Color',[46,188,89]/255,'linewidth',1); hold on
plot(pd(7,:),pd(8,:),'x','Color',[56,10,217]/255,'linewidth',1); hold on
grid on;
legend({'$P_1$','$P_2$','$P_3$','$P_4$','$P_{1d}$','$P_{2d}$','$P_{3d}$','$P_{4d}$'},'Interpreter','latex','FontSize',11,'Orientation','horizontal');
legend('boxoff')
title('$\textrm{Evolucion Pixels}$','Interpreter','latex','FontSize',9);
ylabel('$v$','Interpreter','latex','FontSize',9);
xlabel('$u$','Interpreter','latex','FontSize',9);
xlim([0 1200])
ylim([0 1000])
set(gca,'Ydir','reverse')
print -dpng pixel
print -depsc pixel

figure
set(gcf, 'PaperUnits', 'inches');
set(gcf, 'PaperSize', [4 2]);
set(gcf, 'PaperPositionMode', 'manual');
set(gcf, 'PaperPosition', [0 0 10 4]);
plot(t(1:length(pe)),pe,'linewidth',1); hold on;
grid on;
legend({'$\tilde{P}$'},'Interpreter','latex','FontSize',11,'Orientation','horizontal');
legend('boxoff')
title('$\textrm{Evolution of Control Errors}$','Interpreter','latex','FontSize',9);
ylabel('$[m]$','Interpreter','latex','FontSize',9);
print -dpng error
print -depsc error