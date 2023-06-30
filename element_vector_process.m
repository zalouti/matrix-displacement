function [element_locate_vec, zero_index, non_zero_index] = element_vector_process(element_vec)
    element_locate_vec = element_vec;
    zero_index = find(~element_locate_vec);
    non_zero_index = find(element_locate_vec);
    element_locate_vec(zero_index) = [];
end