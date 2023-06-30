function k = element_stiff_mat(EA, EI, l)
k = zeros(6,6);
% k in local coordinates
k(:,1) = [EA/l; 0; 0; -EA/l; 0; 0];
k(:,2) = [0; 12*EI/l^3; 6*EI/l^2; 0; -12*EI/l^3; 6*EI/l^2];
k(:,3) = [0; 6*EI/l^2; 4*EI/l; 0; -6*EI/l^2; 2*EI/l];
k(:,4) = -k(:,1);
k(:,5) = -k(:,2);
k(:,6) = [0; 6*EI/l^2; 2*EI/l; 0; -6*EI/l^2; 4*EI/l];
end