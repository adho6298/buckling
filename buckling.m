function [] = buckling(Shape)
% Calculates Stiffness/Slenderness Ratio, Failure Type, and Critical Force
% By Adam Hosburgh

% Run by first giving the parameters 'rod' or 'beam'
% like this: 
% buckling('rod') 
% or 
% buckling('beam') 

% Input check
if strcmp(Shape, 'rod')
    disp('Calculating Stiffness Ratio for a Rod');

elseif strcmp(Shape, 'beam')
    disp('Calculating Stiffness Ratio for a Beam');

else 
    disp('Please call function with type ''rod'' or ''beam''');
    return;
end


% Chosing an Evaluation Method
disp(' ');
disp('Would you like Theoretical, AISC or Conservative values for Effective Length?');
Eval_Method = input(' [1] Theoretical\n [2] AISC\n [3] Conservative');

% Chosing a Support Type 
disp('Please Choose a support type:');
Support = input(' [1] Rounded-Rounded\n [2] Pinned-Pinned\n [3] Fixed-Free\n [4] Fixed-Pinned\n [5] Fixed-Fixed');

disp('');
disp('Calculating for:')
% Big Switch inputting the users choices for Eval Method and Supports
switch Eval_Method
    case 1
        disp(' Theoretical');
    switch Support
        case 1
            L_eff = 1;
            disp(' Rounded-Rounded');
        case 2
            L_eff = 1;
            disp(' Pinned-Pinned');
        case 3 
            L_eff = 2;
            disp(' Fixed-Free');
        case 4
            L_eff = 0.707;
            disp(' Fixed-Pinned');
        case 5
            L_eff = 0.5;
            disp(' Fixed-Fixed');
    end
    case 2
        disp(' ASCI');
    switch Support
        case 1
            L_eff = 1;
            disp(' Rounded-Rounded');
        case 2
            L_eff = 1;
            disp(' Pinned-Pinned');
        case 3 
            L_eff = 2.1;
            disp(' Fixed-Free');
        case 4
            L_eff = 0.80;
            disp(' Fixed-Pinned');
        case 5
            L_eff = 0.65;
            disp(' Fixed-Fixed');
    end
    case 3
        disp(' Conservative');
    switch Support
        case 1
            L_eff = 1;
            disp(' Rounded-Rounded');
        case 2
            L_eff = 1;
            disp(' Pinned-Pinned');
        case 3 
            L_eff = 2.4;
            disp(' Fixed-Free');
        case 4
            L_eff = 1;
            disp(' Fixed-Pinned');
        case 5
            L_eff = 1;
            disp(' Fixed-Fixed');
    end
end
disp(' ');

% Rod Calculation
if strcmp(Shape, 'rod')

    L = input('Input Length of Rod: ');
    L = L*L_eff;    % Multiplying by effective length

    D = input('Input Diameter of Rod: ');
    R = D/2;

    A = pi*(R^2);   % Calculating Cross Sectional Area
    disp('');
    disp('Area of Rod is: ');
    disp(A);
        
    I = (pi * R^4)/4;   % Calculating Moment of Inertia for Rod
    disp('Moment of Inertia of Rod is: ')
    disp(I);

% Beam Calculation
elseif strcmp(Shape, 'beam')

    L = input('Input Length of Beam: ');
    L = L*L_eff;    % Multiplying by effective length

    B = input('Input Base of Beam (big side): ');
    H = input('Input Width of Beam (small side): ');

    A = B*H;    % Calculating Cross Sectional Area
    disp('');
    disp('Area of Beam: ');
    disp(A);

    I = (B*H^3)/12;   % Calculating Moment of Inertia for Beam
    disp('Moment of Inertia of the Beam is: ')
    disp(I);
end

% Stiffness output 
Sr = L / (sqrt(I/A));
disp('Stiffness / Slenderness Ratio is: ');
disp(Sr);

disp('Failure mode:');
if Sr > 10
    disp('   Buckling');
elseif Sr < 10
    disp('   Compression')
else
    disp('   Sr = 10. Figure it out bro idk');
end
disp(' ');
disp('Find Critical Load?');
crit_load_choice = input(' [1] Yes\n [2] No (Quit)');

    
switch crit_load_choice
    case 1
        disp(' ');
        E = input('Enter Modulus of Elasticity:');
        Syc = input('Enter Syc or (Compressive Yield Stress)');
        
        Sr_Check = pi*sqrt((2*E)/Syc);
        
        disp(' ');
        if Sr < Sr_Check
            disp('Calculating using Johnson Method');
            Pcr = A * (Syc - ((1/E)*((Syc * Sr)/(2 * pi))^2));
            disp('Critical Force = ')
            disp(Pcr);

        
        elseif Sr > Sr_Check 
            disp('Calculating using Euler Method');
            Pcr = A * ((pi^2 * E)/(Sr^2));
            disp('Critical Force = ')
            disp(Pcr);
        end
        
        disp('Factor of Saftey = ')
        Saftey = Syc/Pcr; 
        disp(Saftey); 

    case 2
        return
end




