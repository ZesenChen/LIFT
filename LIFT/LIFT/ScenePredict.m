svm.type = 'Linear';
svm.para = [];
ratio = 0.1;
%tmp = load('scene.mat');
%data = train_data;
%target = train_target;
%cross_index = split(data);
tmpAcc = [];
tmpStd = [];
acc = {};
for i=1:18
    acc{i} = [];
end
tagid = [0,1,4,5,10,11,12,13,16];
tagid1 = [1,11,12,13,16];
for k=1:5
    disp(tagid1(k));
    filename = ['train_model_',num2str(tagid1(k)+1),'.mat'];
    tmp = load(filename);
    data = tmp.train_data;
    target = tmp.train_target;
    cross_index = split(data);
    for i=1:10
        %[tmp, data_num] = size(cross_index{i});
        disp(['the ',num2str(i),'th cross_valid.']);
        [test_data, test_target, train_data, train_target] = SplitData(cross_index{i}, data, target);
        train_target = train_target';
        test_target = test_target';
        [num_class, num_test] = size(test_target);
        [a,b,c,d,e,f,Pre_Labels]=LIFT(train_data,train_target,test_data,test_target,ratio,svm);
        tmpacc = sum(Pre_Labels(1,:)==test_target(1,:))/num_test;
        acc{k} = [acc{k},tmpacc];
    end
    tmpAcc = [tmpAcc,mean(acc{k})];
    tmpStd = [tmpStd,std(acc{k})];
end