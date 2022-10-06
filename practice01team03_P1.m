% Ilan Halioua - 100472908
% Ismael Barroso - 100472715
% Laura Sancho - 100472322


%PROBLEM 1:

%SHOWS:

% expressions of the number before
% expressions of the number on base 2
% expressions of the number after

% the absolute error (= abs(real val - aprox))
% the relative error (= absolute err/real val)

clear all
clc
format long

s = input('Introduce the sign of the number (0 for + / 1 for -): '); % 0 (+) / 1 (-)
m = input('Introduce a 3 digit mantissa: ');
e = input('Introduce an exponent between -1 and 1: ');

if s == 0
    fprintf('\nExpression of the number introduced in decimal base: +0.%d*10^(%d)\n',m,e);
else
    fprintf('\nExpression of the number introduced in decimal base: -0.%d*10^(%d)\n',m,e);
end

n = (m*10^(-3))*10^e;

if (n<=2^(-5))% This part is to control underflow and overflow errors
    fprintf("\nThere was an underflow error: Number too small\nNumber in binary is out of the exponent range (-4, 4). The program has interpreted this number to be 0.\n");
    fprintf("\nThe relative error is 100%% \n");
elseif (n>=9.97)
    fprintf("\nThere was an overflow error: Number too large\nNumber back to decimal after rounding its binary representation \nmakes it out of the exponent range (-1, 1)\n");
else 
    % Decimal to binary conversion is performed in two steps. First, converting the integer part of the number. Second, converting its fractional part:
        
    int = fix(n); % Integer part
    fract = n - int; % Decimal part
    
    intbin=[];
    fractbin=[];
    cont = 1;
    % Convert our number to vector with its digits in binary
    while int>0
        res=rem(int,2);
        intbin(cont)=res;
        int=floor(int/2);
        cont=cont+1;
    end
    intbin=fliplr(intbin);% Flip it because the "units" appear in first position

    maxlengthfract=8-length(intbin);
    binVect = [];% Vector to concatenate integer and fractional part in binary in one single vector
    for i = 1:maxlengthfract

        fract=fract*2;
        if fract>=1
            fractbin(i)=1;
            fract = fract - 1; %floor(fract) in this case is always '1'
        else
            fractbin(i)=0;
        end
        
        % Search 9th digit to round binary number
        if i == maxlengthfract % Last iteration of the for loop
            fract=fract*2;
            if fract>=1
                binVect = [intbin, fractbin];
                binVect = BinRound(binVect);% Here we call the function 
            else
                binVect = [intbin, fractbin];
            end
        end
        
    end

    % Once we have rounded the number in binary now we split it again into vectors
    for i = 1:length(intbin)
        intbin(i) = binVect(i);
    end
    t=1;
    for j=length(intbin)+1:8
        fractbin(t) = binVect(j);
        t=t+1;
    end

    % Now convert vectors to numbers in order to show them in screen
    intdec=0;
    fractdec=0;
    flip_intbin=fliplr(intbin);% We flip the vectors because its position changes in each iteration
    flip_fractbin=fliplr(fractbin); 
    k=0;

    for i=1:length(flip_intbin)
        intdec=intdec+flip_intbin(i)*10^(k);
        k=k+1;
    end
    % Now intdec is intbin but as a number, not a vector

    k=0;
    for i=1:length(flip_fractbin)
        fractdec=fractdec+flip_fractbin(i)*10^(k);
        k=k+1;
    end
    % Now fractdec is fractbin but as a number, not a vector

    % Show the number in binary with the requirements of the problem
    express = intdec*10^(length(flip_fractbin))+fractdec;
    
    %Usefull to express correctly at screen the numbers which integer part is 0:
    new_express = num2str(express); % In order to be able to apply length() function to new_express
    length_final = length(fractbin) - length(new_express); 

    if int ~= 0
        if s == 0
            fprintf('\nThe expression in binary is +0.%d*2^(%d)\n', express, length(flip_intbin));
        else
            fprintf('\nThe expression in binary is -0.%d*2^(%d)\n', express, length(flip_intbin));
        end
    else
        if s == 0
            fprintf('\nThe expression in binary is +0.%d*2^(%d)\n', express, -length_final);
        else
            fprintf('\nThe expression in binary is -0.%d*2^(%d)\n', express, -length_final);
        end
    end
    
    % Finally changing base from binary to decimal

    q=-length(flip_fractbin);
    decimal_num=0;
    vect=[flip_fractbin, flip_intbin];
    for p=1:length(vect)
        decimal_num=decimal_num+vect(p)*2^(q);
        q=q+1;
        
    end

    % For just displaying the number instead of a decimal as an integer
    if e==1
        shownum=floor(round(decimal_num*10^(2),3,"significant"));
    elseif e==0
        shownum=floor(round(decimal_num*10^(3),3,"significant"));
    else
        shownum=floor(round(decimal_num*10^(4),3,"significant"));
    end
    
    if s == 0
        fprintf('\nLastly the conversion to decimal base is: +0.%d*10^(%d)\n', shownum, e);
    else
        fprintf('\nLastly the conversion to decimal base is: -0.%d*10^(%d)\n', shownum, e);
    end

    % Reversing the last step and converting it to its decimal version
    % (equivalent to the variable 'n' at the beggining)

    if e==1
        new_n = shownum/100;
    elseif e==0
        new_n = shownum/1000;
    else
        new_n = shownum/10000;
    end
    
    Eabs = abs(n-new_n);
    Erel = Eabs/n;
    fprintf('\nThe absolute error is %.4f and the relative error is %.4f\n', Eabs, Erel);
    
end

%% Function of roundoff in binary:

function rounded = BinRound(fractbin)
sum = 0;
carry = 1;
for i = 8:-1:1

    sum = fractbin(i) + carry;
    
    if sum == 1
        rounded(i) = 1;
        carry = 0;
    end

    if sum == 2
        rounded(i) = 0;
        carry = 1;
    end
end
end

