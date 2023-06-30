function F_fe = fix_end_force(category, value,l)
if category == 3 % distribute load case
    fx1 = 0;
    fx2 = 0;
    fy1 = -value*l/2;
    fy2 = -value*l/2;
    Mz1 = -value*l^2/12;
    Mz2 = value*l^2/12;
    
elseif category == 2 % force load case
    fx1 = 0;
    fx2 = 0;
    fy1 = -value/2;
    fy2 = -value/2;
    Mz1 = -value*l/8;
    Mz2 = value*l/8;
end
F_fe = [fx1; fy1; Mz1; fx2; fy2; Mz2];
end