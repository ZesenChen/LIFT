function [train_data, train_target, test_data, test_target] = SmallScaleDataPro(matfile, ratio)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明

train_data = [];
train_target = [];
test_data = [];
test_target = [];

temp = load(matfile);
data = temp.data;
target = temp.target;
[row, col] = size(target);
for i = 1:1:row
    if(rand() < ratio)
        test_data = [test_data;data(i,:)];
        test_target = [test_target;target(i,:)];
    else
        train_data = [train_data;data(i,:)];
        train_target = [train_target;target(i,:)];
    end
    %[datarow,datacol] = size(train_data)
end
train_target = train_target';
test_target = test_target';
end

