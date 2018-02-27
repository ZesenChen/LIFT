function [train_data, train_target, test_data, test_target] = getData(filename, ratio)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
train_data = []
train_target = []
test_data = []
test_target = []
Data = load(filename)
if(isfield(Data, 'train_data') == 1)
    train_data = Data.train_data
    train_target = Data.train_target
    test_data = Data.test_data
    test_target = Data.test_target
else
    data = Data.data
    target = Data.target
    [data_num, tempvalue] = size(data)
    for i = 1:data_num
        if(unidrnd(1/ratio) == 1)
            test_data = [test_data; data(i,:)]
            test_target = [test_target; target(i,:)]
        else
            train_data = [train_data; data(i,:)]
            train_target = [train_target; target(i,:)]
        end
    end
end
[row, col] = size(train_target)
if(data_num ~= row)
    train_target = train_target'
    test_target = test_target'
end
end

