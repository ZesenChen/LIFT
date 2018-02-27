base_path = 'E:/Graduation design/Exp_Dataset/CAL500.mat'

%disp(path);
%path = 'E:/Graduation design/Exp_Dataset/genbase.mat'
dataset = load(base_path);
target = dataset.target;
data = dataset.data;
ratio=0;
svm.type='Linear';
svm.para=[];
RATIO = [];
fp = fopen('D:/RESULT.txt','wt');
for ratio = 0.1:0.1:0.5
    disp(ratio);
    HLoss = [];
    RLoss = [];
    OError = [];
    Cov = [];
    AvePre = [];
    HL = [];
    RL = [];
    OE = [];
    CO = [];
    AV = [];
    RATIO = [RATIO,ratio];
    for i = 1:1:5
        [train_data,train_target,test_data,test_target] = DataDiv(data, target, 0.1);
        [HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Outputs, ...
        Pre_Labels]=LIFT(train_data,train_target,test_data,test_target,ratio,svm);
        %RATIO = [RATIO,ratio];
        HLoss = [HLoss,HammingLoss];
        RLoss = [RLoss,RankingLoss];
        OError = [OError,OneError];
        Cov = [Cov,Coverage];
        AvePre = [AvePre,Average_Precision];
    end
    HL = [mean(HLoss),var(HLoss)];
    RL = [mean(RLoss),var(RLoss)];  
    OE = [mean(OError),var(OError)];
    CO = [mean(Cov),var(Cov)];
    AV = [mean(AvePre),var(AvePre)];
    fprintf(fp,'%f\n',ratio);
    fprintf(fp,'%s','HL');
    fprintf(fp,'%f\n',HL);
    fprintf(fp,'%s','RL');
    fprintf(fp,'%f\n',RL);
    fprintf(fp,'%s','OE');
    fprintf(fp,'%f\n',OE);
    fprintf(fp,'%s','CO');
    fprintf(fp,'%f\n',CO);
    fprintf(fp,'%s','AV');
    fprintf(fp,'%f\n',AV);
end
fclose(fp);