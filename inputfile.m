function [joint_num, element_num, displacement_num, force_num, Joint, Element, Force] = inputfile(filename)
% define data structures: force, joint, element
% use array of struct to store datas

% force {kind, category, element_exert, Mz, distance}
field1 = 'kind'; value1 = 0; % with 1 for joint and 2 for element
field2 = 'category'; value2 = 0;
% with 1 for force in x, 2 for force in y, 3 for momentum/distribute, xyz is local coordinate
field3 = 'exert_index'; value3 = 0; % exert index for element or joint
field4 = 'value'; value4 = 0; % the magnitude of force, with kN for force and kNm for momentum
field5 = 'distance'; value5 = 0; % exert distance from frist joint, unit m(only for element)
force = struct(field1, value1, field2, value2, field3, value3, field4, value4, field5, value5);

% joint {x, y, label, disp}
field1 = 'x';  value1 = 0;% x coordinate, unit m
field2 = 'y';  value2 = 0;% y coordinate, unit m
field3 = 'disp'; value3 = zeros(3,1); % displacement label of this joint
joint = struct(field1, value1, field2, value2, field3, value3);

% element {1stjoint, 2ndjoint, EI, EA, l, alpha, element_vec}
field1 = 'joint1'; value1 = 0;% first joint, local 1
field2 = 'joint2'; value2 = 0;% second joint, local 2
field3 = 'EI'; value3 = 0;
field4 = 'EA'; value4 = 0;
field5 = 'l'; value5 = 0;
field6 = 'alpha'; value6 = 0;% angle between local coordinate and global coordinate
field7 = 'element_vec'; value7 = zeros(6,1);
field8 = 'k'; value8 = zeros(6,6);
field9 = 'force'; value9 = zeros(6,1);
field10 = 'fix_end'; value10 = zeros(6,1);
field11 = 'displacement'; value11 = zeros(6,1);
element = struct(field1, value1, field2, value2, field3, value3, field4, value4, field5, value5,...
    field6, value6, field7, value7, field8, value8, field9, value9, field10, value10, field11, value11);

% file read
fileID = fopen(filename);
cnt = 0;
while ~feof(fileID)
    cnt= cnt + 1;
    line = fgetl(fileID);
    if cnt == 1
        c = textscan(line, '%d, %d, %d, %d');
        joint_num = c{1};
        element_num = c{2};
        displacement_num = c{3};
        force_num = c{4};
        Force = repmat(force, 1, force_num);
        Joint = repmat(joint, 1, joint_num);
        Element = repmat(element, 1, element_num);
    elseif cnt >=2 && cnt <= 1+ joint_num
        c = textscan(line, '%f, %f, %d, %d, %d');
        Joint(cnt - 1).x = c{1};
        Joint(cnt - 1).y = c{2};
        Joint(cnt - 1).disp = [c{3}, c{4}, c{5}]';
    elseif cnt > 1 + joint_num && cnt <= 1 + joint_num + element_num
        c = textscan(line, '%d, %d, %f, %f');
        element_index = cnt - 1 - joint_num;
        Element(element_index).joint1 = Joint(c{1});
        Element(element_index).joint2 = Joint(c{2});
        Element(element_index).EA = c{3};
        Element(element_index).EI = c{4};
        Element(element_index).l = norm([Joint(c{1}).x,Joint(c{1}).y] - [Joint(c{2}).x,Joint(c{2}).y]);
        Element(element_index).alpha = atan((Joint(c{2}).y - Joint(c{1}).y)/(Joint(c{2}).x - Joint(c{1}).x));
        Element(element_index).element_vec = [Joint(c{1}).disp; Joint(c{2}).disp];
        Element(element_index).k = element_stiff_mat(Element(element_index).EA, ...
            Element(element_index).EI, Element(element_index).l);
        Element(element_index).fix_end = zeros(6,1);
    else
        c = textscan(line, '%d, %d, %d, %f, %f');
        force_index = cnt - 1 - joint_num - element_num;
        Force(force_index).kind = c{1};
        Force(force_index).exert_index = c{2};
        Force(force_index).category = c{3};
        Force(force_index).value = c{4};
        Force(force_index).distance = c{5};
    end
end
fclose(fileID);
end