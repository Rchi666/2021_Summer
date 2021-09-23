x0 = [0.1;0.05];
A = [];
b = [];
Aeq = [];
beq = [];
ub = [0.5;0.5];
lb = [0.001;0.001];
options = optimset ('display', 'off', 'Algorithm', 'sqp');
[xans,fval,exitflag]=fmincon(@(xans)obj(xans), x0, A, b, Aeq, beq, lb, ub,... 
    @(xans)nonlcon(xans), options);

function f = obj(xans)
    rho = 7860;
    f = 6*rho*pi*(xans(1,:).^2)*9.14 + 4*rho*pi*(xans(2,:).^2)*9.14*sqrt(2);
end
% target function

function [g,geq] = nonlcon(xans)
    %variable definition
    x = [18.28;18.28;9.14;9.14;0;0];    % x position of each node
    y = [9.14;0;9.14;0;9.14;0];         % y posotion of each node
    nodei = [3;1;4;2;3;1;4;3;2;1];      % specific node of each element (first)
    nodej = [5;3;6;4;4;2;5;6;3;4];      % specific node of each element (second)
    force = 10^7;
    sigmay = 250*10^6;                  % define global yield streagth

    global E;
    global rho;
    E = 200*10^9;                       % defnie global yound's modulus
    rho = 7860;                         % define global density

    for i = 1:6
        Ar(i) = pi*(xans(1,:)).^2;     % calculate Ar1...6
    end
    for i = 7:10
        Ar(i) = pi*(xans(2,:)).^2;     % calculate Ar7...10
    end 
    
    for i = 1:10
        L0(i)=((x(nodej(i))-x(nodei(i)))^2+(y(nodej(i))-y(nodei(i)))^2)^(1/2);
    end
    L = L0';                        % calculate length of each element

    for i = 1:10
        cos0(i)=(x(nodej(i))-x(nodei(i)))/L0(i);
        sin0(i)=(y(nodej(i))-y(nodei(i)))/L0(i);
    end
    c = cos0';
    s = sin0';                      % calculate sin/cos of each element

    kn = zeros(12);                 % define kn as 12*12 matrix and calculate k
    for i = 1:10
        k0(:,:,i) = E*Ar(i)/L(i)*[c(i)^2 c(i)*s(i) -c(i)^2 -c(i)*s(i);...
                                  c(i)*s(i) s(i)^2 -c(i)*s(i) -s(i)^2;...
                                  -c(i)^2 -c(i)*s(i) c(i)^2 c(i)*s(i);...
                                  -c(i)*s(i) -s(i)^2 c(i)*s(i) s(i)^2];   %Matrix to indicate stiffness 
        %k(:,:,i) = [c(i)^2 c(i)*s(i) -c(i)^2 -c(i)*s(i);c(i)*s(i) s(i)^2 -c(i)*s(i) -s(i)^2;-c(i)^2 -c(i)*s(i) c(i)^2 c(i)*s(i);-c(i)*s(i) -s(i)^2 c(i)*s(i) s(i)^2];   %Matrix before given EA/L
        no(1) = nodei(i)*2-1;
        no(2) = nodei(i)*2;
        no(3) = nodej(i)*2-1;
        no(4) = nodej(i)*2;
        for a = 1:4
            for b = 1:4
                kn(no(a),no(b)) = kn(no(a),no(b)) + k0(a,b,i);
            end
        end
        %in order to sum numbers from matrixs
    end
    
    F = zeros(12,1);
    F(4) = -force;
    F(8) = -force;                  % assign force to matrix

    kr = kn(1:8,1:8);               % reduced kr from kn
    Fr = F(1:8,1);                  % reduced Fr from F
    Qr = kr\Fr;                     % reduced Q as kr inverse by Fr
    %Q = zeros(12,1);                % assign Q as 12*1 matrix
    Q = Qr;
    Q(9:12) = 0;
    disp(Q);
    sigman = zeros(10,1);
    for i = 1:10
        no(1) = nodei(i)*2-1;
        no(2) = nodei(i)*2;
        no(3) = nodej(i)*2-1;
        no(4) = nodej(i)*2;
        sigman(i) = E/L(i)*[-c(i) -s(i) c(i) s(i)]*[Q(no(1));Q(no(2));Q(no(3));Q(no(4))];
    end
    disp(sigman);
    kre = kn(9:12,1:12);
    rnew = kre*Q

for i = 1:6
    g(i) = abs(sigman(i))-sigmay;
end
for i = 7:10
    g(i) = abs(sigman(i))-sigmay;
end
g(11) = sqrt((Q(3))^2+(Q(4))^2)-0.02;
geq = [];
end