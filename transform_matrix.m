function transform_mat = transform_matrix(alpha)
transform_mat3D = [cos(alpha), -sin(alpha), 0;
    sin(alpha), cos(alpha), 0;
    0, 0, 1];
transform_mat = kron(eye(2),transform_mat3D);
end