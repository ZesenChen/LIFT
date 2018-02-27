function [train_data,train_target,test_data,test_target,test_num] = DataDiv(data, target, ratio)
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
train_data = [];
train_target = [];
test_data = [];
test_target = [];
test_num = [];
[drow, dcol] = size(data);
[row, col] = size(target);
target(target==0) = -1;
if(drow ~= row)
    target = target';
end
while 1
    for i = 1:row
        if(rand() < ratio)
            test_data = [test_data; data(i,:)];
            test_target = [test_target; target(i,:)];
            test_num = [test_num,i];
        else
            train_data = [train_data; data(i,:)];
            train_target = [train_target; target(i,:)];
        end
    end
    tempsum = sum(train_target);
    [temprow,tempcol] = size(train_target);
    if(sum(tempsum==-temprow)==0 && sum(tempsum==temprow)==0)
        break;
    end
end
train_target = train_target';
test_target = test_target';
end

