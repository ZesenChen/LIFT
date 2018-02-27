function [train_data, train_target, test_data, test_target] = SplitData(index, data, target)
%UNTITLED4 此处显示有关此函数的摘要
%   此处显示详细说明
test_data = data;
test_target = target;
train_data = test_data(index,:);
train_target = test_target(index,:);
test_data(index,:) = [];
test_target(index,:) = [];
end

