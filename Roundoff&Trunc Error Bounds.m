% Ilan Halioua - 100472908
% Ismael Barroso - 100472715
% Laura Sancho - 100472322

% PROBLEM 2

clear
clc
format long

k = input("Introduce a value for 'k' (k>=2): "); % Greater k -> more difference between S1 up and down
b = input("\nIntroduce a value for 'b' (>= 1): ");
a = input("\nIntroduce a value for 'a' (> b): ");

fprintf("\n-----------------------------------------------\n");

fprintf("\nSum: ");
disp(Sum(k,a,b));
fprintf("\nInverse Sum: ");
disp(InvSum(k,a,b));

fprintf("\nRoundoffErr: ");
disp(RoundoffErr(k,a,b)); 
fprintf("\nRoundoffErr Inverse: ");
disp(RoundoffErrInv(k,a,b));

fprintf("\nTruncation Error: ");
disp(TruncErr(k,a));

fprintf("\nTotal Error Up: ");
disp(totalErrorUp(k,a,b));
fprintf("\nTotal Error Down: ");
disp(totalErrorDown(k,a,b));


fprintf("\n-----------------------------------------------\n");

%Program that asks for value of a and plots family of curves
%1 graph for totalErrorUp and 1 graph for totalErrorDown

%plot(k,totalErrorUp/Down -> For each b)

%number of curves = a - 1 in each graph
%Each curve with its value of b => (1,a-1);

a = input("\nIntroduce a value for 'a': ");

fprintf("\n-----------------------------------------------\n");

for b = 1:a-1

    K = []; % (x axis)
    for e = 1:1:16
        K(e) = log2(2^e);
    end
    
    TEUP = []; % (y axis)
    for i = 1:length(K) 
        TEUP(i) = log2(totalErrorUp(K(i),a,b));
    end
    figure(1);
    plot(K,TEUP);
    hold on
    xlabel("K values");
    ylabel("Total Error of Sum (UP)");
end
hold off

for b = 1:a-1

    K = []; % (x axis)
    for e = 1:1:16
        K(e) = log2(2^e);
    end
    
    TEDW = []; % (y axis)
    for i = 1:length(K)
        TEDW(i) = log2(totalErrorDown(K(i),a,b));
    end
    figure(2);
    plot(K,TEDW);
    hold on
    xlabel("K values");
    ylabel("Total Error of Sum (DOWN)");
end
hold off

%-----EXTRA:-----

K = [];
for e = 1:1:16
    K(e) = log2(2^e);
end

REU = [];
for i = 1:length(K)
    REU(i) = log2(RoundoffErr(K(i),a,25));
end
figure(3);
plot(K,REU);
xlabel("K values");
ylabel("Roundoff Error of Sum (UP)");

%-----

K = [];
for e = 1:1:16
    K(e) = log2(2^e);
end

RED = [];
for i = 1:length(K)
    RED(i) = log2(RoundoffErrInv(K(i),a,25));
end
figure(4);
plot(K,RED);
xlabel("K values");
ylabel("Roundoff Error of Sum (DOWN)");

%-----

K = [];
for e = 1:1:16
    K(e) = log2(2^e);
end

TE = [];
for i = 1:length(K)
    TE(i) = log2(TruncErr(K(i),a));
end
figure(5);
plot(K,TE);
xlabel("K values");
ylabel("Truncation Error of Sum");

%----

%% Interpretation of the results:

fprintf("\nINTERPRETATION OF THE RESULTS:\n");

fprintf("\nThe 'upwards' Sum, at the beginning adds large quantities that each time become much smaller than the previous one.\n"); 
fprintf("It is doing a large sum while adding very small numbers to it, and we know that MATLAB neglects the small quantity if the relative difference is greater than eps.\n");
fprintf("(Largest roundoff error with this method).\n")
fprintf("\nOn the contrary, in the inverse sum, at the beginning, it adds very small quantities but of the same or similar magnitude (thinking of high k values),\n");
fprintf("so MATLAB does not neglect so many numbers when adding the fractions. And therefore with this method there is not so much error from eps.\n"); 
fprintf("(Less roundoff error with this method than the other).\n");

fprintf("\nThe fact that 'a' is greater that 'b' which is greater or equal to 1, affects also the roundoff error (->total error)\n");
fprintf("as b could be insignificant with respect to a*n for high values of a/n which would increase the error due to the machine epsilon of MATLAB.\n");
fprintf("This has been considered in our bound for the Roundoff error for both methods of computing S1.\n");

fprintf("\nConclusion:")
fprintf("\nFor decreasing as much as possible the Trunctation error throughout the process, a larger value of k (and a) is better.\n"); % (k and a)
fprintf("Whereas for decreasing the Roundoff error, a lower value of k (as well as a and b) is a better choice.\n"); % (a and b also affect)
fprintf("This comes from the fact that when k increases, the roundoff error also increases while the truncation error decreases. \n");

fprintf("\nMoreover, we also have realised that the difference between the roundoff error of S1 to some value k, and the one of S1 to k + 1,\n");
fprintf("is very different for low values of k, while for very large 'k's they get very similar, since the roundoff error of the individual terms of S1 get closer and closer as k increases.\n");
fprintf("Similarly, but at a greater scale, the truncation error of S1 to some value k, is very different to the one for k + 1 for small values of k.\n");
fprintf("While for very large values of k, the truncation error continues decreasing but at a more constant rate.\n");

fprintf("\nNevertheless, as we have seen throughout the process, the roundoff error does a very small contribution to the total error.\n");
fprintf("As we can see in the graphs, when 'k' increases, the total error decreases, which has the same behaviour as the truncation error.\n");
fprintf("This occurs because the truncation error decreases much faster than what the roundoff error increases as k gets larger.\n");
fprintf("Showing how it is in fact the Truncation error in S1 which contributes mostly to the total error,\n");
fprintf("and therefore for S1, it is indeed a larger value of k a better option.\n");

fprintf("\n-----------------------------------------------\n");
fprintf("\nNAMES OF THE FUNCTIONS CREATED IN THE PROGRAM:\n")

fprintf("\n- Sum(k,a,b)");
fprintf("\n- InvSum(k,a,b)");
fprintf("\n- RoundoffErr(k,a,b)");
fprintf("\n- RoundoffErrInv(k,a,b)");
fprintf("\n- TruncErr(k,a)");
fprintf("\n- totalErrorUp(k,a,b)");
fprintf("\n- totalErrorDown(k,a,b)");

%% FUNCTIONS:


function y = totalErrorUp(k,a,b)
%USING LEFT TO RIGHT SUM!!!
y = RoundoffErr(k,a,b) + TruncErr(k,a);
end

function y = totalErrorDown(k,a,b)
%USING RIGHT TO LEFT SUM!!!
y = RoundoffErrInv(k,a,b) + TruncErr(k,a);
end

function y = TruncErr(k,a)
%TRUNCATION ERROR BOUND FOR BOTH METHODS (SUM & INVSUM)
y = 1/(a*k*(k+1));
end

function y = RoundoffErr(k,a,b)
%LEFT TO RIGHT SUM

y = 8*eps*Sum(k,a,b);

end

function y = RoundoffErrInv(k,a,b)
%RIGHT TO LEFT SUM

y = 8*eps*InvSum(k,a,b);

end

function y = Sum(k,a,b)
%LEFT TO RIGHT SUM
y = 0;
for n = 1:1:k
    y = y + (1/((a*n + b)*(a*n + (b + 1))));
end
end

function y = InvSum(k,a,b)
%RIGHT TO LEFT SUM
y = 0;
for n = k:-1:1
    y = y + (1/((a*n + b)*(a*n + (b + 1))));
end
end
