% initialization stage, construct basic data structure
[joint_num, element_num, displacement_num, force_num, Joint, Element, Force] = inputfile("test1.txt");
% [joint_num, element_num, displacement_num, force_num, Joint, Element, Force] = inputfile("test2.txt");

% construct the stiffness matrix K with element locate vector
K = zeros(displacement_num, displacement_num);
k = zeros(6,6);
P = zeros(displacement_num, 1);

for i = 1 : element_num
    % this k indicates k in global coordinates
    T = transform_matrix(Element(i).alpha);
    k = T' * Element(i).k * T;
    [element_locate_vec, zero_index, non_zero_index] = element_vector_process(Element(i).element_vec); 
    K(element_locate_vec, element_locate_vec) = K(element_locate_vec, element_locate_vec) ...
        + k(non_zero_index, non_zero_index);
end

% construct the Joint load vector P

for i = 1 : force_num
    if Force(i).kind == 2 % force exert on element
        T = transform_matrix(Element(Force(i).exert_index).alpha);
        
        % get element locate vector, erase zero part
        [element_locate_vec, zero_index, non_zero_index] = element_vector_process(Element(Force(i).exert_index).element_vec); 
        Element(Force(i).exert_index).fix_end = fix_end_force(Force(i).category, Force(i).value, Element(Force(i).exert_index).l);
        force_fe = T' * Element(Force(i).exert_index).fix_end;
        P_element = - force_fe;% every fix end to element equivalent load vector and add them
        P(element_locate_vec) = P(element_locate_vec) + P_element(non_zero_index);   
    elseif Force(i).kind == 1 % force exert on joint
        disp_index = Joint(Force(i).exert_index).disp(Force(i).category);
        P(disp_index, 1) = P(disp_index, 1) + Force(i).value;
    end
end

Delta = K\P;
Delta_e = zeros(6,1);

% convert to the element coordinate
for i = 1 : element_num
    T = transform_matrix(Element(i).alpha);
    [element_locate_vec, zero_index, non_zero_index] = element_vector_process(Element(i).element_vec);
    Delta_e(non_zero_index) = Delta(element_locate_vec);
    Delta_e(zero_index) = zeros(max(size(zero_index)),1);
    Element(i).displacement = T * Delta_e;
    Element(i).force = Element(i).k * Element(i).displacement + Element(i).fix_end;
end

figure(1)
FNplot(Element);
figure(2)
FQplot(Element,Force);
figure(3)
Mplot(Element,Force);

outputfile("output1.txt",Element)
% outputfile("output2.txt",Element)