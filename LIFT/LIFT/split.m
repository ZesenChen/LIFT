function cross_index = split(X)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
[row, col] = size(X);
index = 1:row;
for i = row:-1:1
    sw = unidrnd(i);
    tmp = index(i);
    index(i) = index(sw);
    index(sw) = tmp;
end
k = floor(row/10);
cross_index = {};
for i = 1:9
    cross_index{i} = index((i-1)*k+1:i*k);
end
cross_index{10} = index(9*k+1:row);
end

