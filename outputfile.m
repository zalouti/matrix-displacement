function outputfile(filename, Element)
element_num = max(size(Element));
fileID = fopen(filename,'w');

fprintf(fileID,'%6s %6s %10s %5s %5s %9s\n','u1','v1', 'theta1', 'u2','v2', 'theta2');
for i = 1: element_num
    fprintf(fileID,'%6.3f %6.3f %6.3f %6.3f %6.3f %6.3f\n', Element(i).displacement);
end
fprintf(fileID,'%7s %7s %7s %7s %7s %7s\n','fx1','fy1', 'Mz1', 'fx2','fy2', 'Mz2');
for i = 1: element_num
    fprintf(fileID,'%7.3f %7.3f %7.3f %7.3f %7.3f %7.3f\n', Element(i).force);
end
end