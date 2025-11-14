clear; clc; close all;

u = (1.1*4+0.8*(4^3))/0.1; %  y = 4 y' = 0 y'' = 0
% y''+1.9*y'+1.1*y+0.8y^3=0.1*u

sim_name = ['cv7_sim'];

set_param(sim_name,'FastRestart','on');

tic
numgen=30	;% number of generations
lpop=30;	% number of chromosomes in population
lstring=3;	% number of genes in a chromosome
M=10000;          % maximum of the search space

%parameters
a = 4; 
b = 2.3;
c = 0.0138;

Space=[zeros(1,lstring); ones(1,lstring)*M];

Delta=Space(2,:)/100;   

Pop=genrpop(lpop,Space);
%evolutions=zeros(1,numgen);

Fit = [];
Fit_a = [];
Fit_b = [];
Fit_c = [];

% -----------------------------------------------------------------
% 1. CAST: robustny PID – optimalizacia pre vsetky tri pracovne body
% -----------------------------------------------------------------

for gen=1:numgen

    for j=1:lpop
        disp(gen+"/"+numgen+" "+ j)
        P = Pop(j,1);
        I = Pop(j,2);
        D = Pop(j,3);

        try
            % pre hodnoty a
            a0=1; a1=2; a2=1; b0=0.1; c0=1;
            out=sim(sim_name);
            Fit_a(j) = sum(a*abs(out.e.Data)+b*abs(out.de.Data)+c*abs(out.u.Data)); 

            % pre hodnoty b
            a0=1.4; a1=2; a2=1; b0=0.2; c0=0.9;
            out=sim(sim_name);
            Fit_b(j) = sum(a*abs(out.e.Data)+b*abs(out.de.Data)+c*abs(out.u.Data)); 

            % pre hodnoty c
            a0=1.1; a1=0.1; a2=4; b0=0.1; c0=1.1;
            out=sim(sim_name);
            Fit_c(j) = sum(a*abs(out.e.Data)+b*abs(out.de.Data)+c*abs(out.u.Data)); 

            % dokopy
            Fit(j) = Fit_a(j) + Fit_b(j) + Fit_c(j);

%             Fit(j) = Fit_a(j);

        catch
            Fit(j) = 10e50;
        end
    end

%     GA
    Best=selbest(Pop,Fit,[1 1]);
    Old=selrand(Pop,Fit,9);
    Work1 = selsus(Pop,Fit,10);
    Work2 = selsus(Pop,Fit,9);
    Work1=crossov(Work1,1,0);
    Work2=mutx(Work2,0.1,Space);
    Work2=muta(Work2,0.2,Delta,Space);
    Pop=[Best;Old;Work1;Work2];

    evolution(gen)=min(Fit);
    evolution_a(gen) = min(Fit_a);
    evolution_b(gen) = min(Fit_b);
    evolution_c(gen) = min(Fit_c);

end
toc

plot(evolution,'k');
hold on
plot(evolution_a,'r');
plot(evolution_b,'g');
plot(evolution_c,'b');
legend ('sum','a','b', 'c');
title('evolution');
xlabel('generation');
ylabel('fitness');
hold off

fprintf('Best parameters >> P: %.4f I: %.4f D: %.4f \n',Best(1,1),Best(1,2),Best(1,3));

%1  Best parameters >> P: 5204.8878 I: 58.7126 D: 665.1890 

P = Best(1,1);
I = Best(1,2);
D = Best(1,3);

figure
% pre hodnoty a
a0=1; a1=2; a2=1; b0=0.1; c0=1;
out=sim(sim_name);
ya = out.y.Data;
plot(out.y.Data,'r');
hold on

% pre hodnoty b
a0=1.4; a1=2; a2=1; b0=0.2; c0=0.9;
out=sim(sim_name);
yb = out.y.Data;
plot(out.y.Data,'g');

% pre hodnoty c
a0=1.1; a1=0.01; a2=4; b0=0.1; c0=1.1;
out=sim(sim_name);
yc = out.y.Data;
plot(out.y.Data,'b');
plot((ya+yb+yc)/3, 'y-.');
plot(out.w.Data,'k');
title('priebeh regulovanej veliciny');
hold off

figure
% pre hodnoty a
a0=1; a1=2; a2=1; b0=0.1; c0=1;
out=sim(sim_name);
ua = out.u.Data;
plot(ua,'r');
hold on

% pre hodnoty b
a0=1.4; a1=2; a2=1; b0=0.2; c0=0.9;
out=sim(sim_name);
ub = out.u.Data;
plot(ub,'g');

% pre hodnoty c
a0=1.1; a1=0.01; a2=4; b0=0.1; c0=1.1;
out=sim(sim_name);
uc = out.u.Data;
plot(uc,'b');
title('akcny zasah');

set_param(sim_name,'FastRestart','off');

%% ------------------------------------------------------------
% DRUHA CAST - PID optimalizovany len pre pracovny bod (a)
% ------------------------------------------------------------

disp('Spustam druhu cast - optimalizacia len pre pracovny bod (a)...');

set_param(sim_name,'FastRestart','on');

numgen2 = 30; 
lpop2 = 30; 
Space2 = [zeros(1,lstring); ones(1,lstring)*M];
Delta2 = Space2(2,:)/100;
Pop2 = genrpop(lpop2,Space2);
Fit2 = [];

for gen=1:numgen2
    for j=1:lpop2
        disp("Exp2 " + gen + "/" + numgen2 + " " + j)
        P = Pop2(j,1);
        I = Pop2(j,2);
        D = Pop2(j,3);

        try
            % len pracovny bod (a)
            a0=1; a1=2; a2=1; b0=0.1; c0=1;
            out=sim(sim_name);
            Fit2(j) = sum(a*abs(out.e.Data)+b*abs(out.de.Data)+c*abs(out.u.Data)); 
        catch
            Fit2(j) = 10e50;
        end
    end

    Best2=selbest(Pop2,Fit2,[1 1]);
    Old2=selrand(Pop2,Fit2,9);
    Work1_2 = selsus(Pop2,Fit2,10);
    Work2_2 = selsus(Pop2,Fit2,9);
    Work1_2=crossov(Work1_2,1,0);
    Work2_2=mutx(Work2_2,0.1,Space2);
    Work2_2=muta(Work2_2,0.2,Delta2,Space2);
    Pop2=[Best2;Old2;Work1_2;Work2_2];

    evolution2(gen)=min(Fit2);
end

% pridanie do grafu evolucie
figure
plot(evolution,'k'); hold on
plot(evolution2,'m');
legend('robustny PID','len pre bod (a)');
title('Porovnanie evolucie fitness');
xlabel('Generacia');
ylabel('Fitness');
hold off

fprintf('Best parameters pre bod (a) >> P: %.4f I: %.4f D: %.4f \n',Best2(1,1),Best2(1,2),Best2(1,3));

P = Best2(1,1);
I = Best2(1,2);
D = Best2(1,3);

% simulacie s tymto PID pre body a,b,c
figure
a0=1; a1=2; a2=1; b0=0.1; c0=1;
out=sim(sim_name);
ya2 = out.y.Data;
plot(out.y.Data,'r'); hold on;

a0=1.4; a1=2; a2=1; b0=0.2; c0=0.9;
out=sim(sim_name);
yb2 = out.y.Data;
plot(out.y.Data,'g');

a0=1.1; a1=0.01; a2=4; b0=0.1; c0=1.1;
out=sim(sim_name);
yc2 = out.y.Data;
plot(out.y.Data,'b');
plot((ya2+yb2+yc2)/3, 'y-.');
plot(out.w.Data,'k');
title('Priebeh regulovanej veliciny - PID pre bod (a)');
legend('a','b','c','priemer','ziadana hodnota');
hold off

figure
a0=1; a1=2; a2=1; b0=0.1; c0=1;
out=sim(sim_name);
ua2 = out.u.Data;
plot(ua2,'r'); hold on;

a0=1.4; a1=2; a2=1; b0=0.2; c0=0.9;
out=sim(sim_name);
ub2 = out.u.Data;
plot(ub2,'g');

a0=1.1; a1=0.01; a2=4; b0=0.1; c0=1.1;
out=sim(sim_name);
uc2 = out.u.Data;
plot(uc2,'b');
title('Akcny zasah - PID pre bod (a)');
legend('a','b','c');
hold off

set_param(sim_name,'FastRestart','off');