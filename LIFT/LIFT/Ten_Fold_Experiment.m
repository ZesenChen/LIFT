base_path = 'F:\LIFT\LIFT\';
set = {'recreation.mat'};
finaldata = [];
for jj = 1:1
    path = [base_path,set{jj}];
    dataset = load(path);
    if(isfield(dataset,'train_data'))
        data = [dataset.train_data; dataset.test_data];
        target = [dataset.train_target, dataset.test_target];
    else
        data = dataset.data;
        target = dataset.target;
    end

    [data_num,tmp] = size(data);
    for i = data_num:-1:1
        swap_num = randint(1,1,[1,i]);
        tmpd = data(i,:);
        tmpt = target(:,i);
        data(i,:) = data(swap_num,:);
        target(:,i) = target(:,swap_num);
        data(swap_num,:) = tmpd;
        target(:,swap_num) = tmpt;
    end
    %交叉验证次数
    fold_num = 5;
    test_num = round(data_num/fold_num);
    test_instance = cell(fold_num,1);
    for i = 1:fold_num-1
        test_instance{i,1} = (i-1)*test_num+1:i*test_num;
    end
    test_instance{fold_num,1} = 4*test_num+1:data_num;

    ratio = 0.1;
    svm.type = 'Linear';
    svm.para = [];
    hl = [];
    rl = [];
    oe = [];
    co = [];
    ap = [];
    for i = 1:fold_num
        train_data = data;
        train_target = target;
        test_data = data(test_instance{i,1},:);
        test_target = target(:,test_instance{i,1});
        train_data(test_instance{i,1},:) = [];
        train_target(:,test_instance{i,1}) = [];
        [HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Outputs,Pre_Labels]=LIFT(train_data,train_target,test_data,test_target,ratio,svm);
        hl = [hl,HammingLoss];
        rl = [rl,RankingLoss];
        oe = [oe,OneError];
        co = [co,Coverage];
        ap = [ap,Average_Precision];
    end
    mean_hl = mean(hl);
    mean_rl = mean(rl);
    mean_oe = mean(oe);
    mean_co = mean(co);
    mean_ap = mean(ap);
    finaldata = [finaldata;[mean_hl, ...
                       mean_rl, ...
                       mean_oe, ...
                       mean_co, ...
                       mean_ap]];
    disp(['HammingLoss = ',num2str(mean_hl)]);
    disp(['RankingLoss = ',num2str(mean_rl)]);
    disp(['OneError = ',num2str(mean_oe)]);
    disp(['Coverage = ',num2str(mean_co)]);
    disp(['AveragePrecision = ',num2str(mean_ap)]);
end