function [HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Outputs,Pre_Labels]=liftpredict(test_data,test_target,ratio,svm,Models,P_Centers,N_Centers)
    [test_data_num,tempvalue] = size(test_data);
    [test_target_num,tempvalue] = size(test_target);
    if(test_target_num == test_data_num)
        test_target = test_target';
    end
    test_target(test_target==0)=-1;
    if(nargin<6)
        svm.type='Linear';
        svm.para=[];
    end
    
    if(nargin<5)
        ratio=0.1;
    end
    
    if(nargin<4)
        error('Not enough input parameters, please type "help LIFT" for more information');
    end
    
    %[num_train,dim]=size(train_data);
    [num_class,num_test]=size(test_target);
    
    %P_Centers=cell(num_class,1);
    %N_Centers=cell(num_class,1);
    
    %Find key instances of each label
    
    switch svm.type
        case 'RBF'
            gamma=num2str(svm.para);
            str=['-t 2 -g ',gamma,' -b 1'];
        case 'Poly'
            gamma=num2str(svm.para(1));
            coef=num2str(svm.para(2));
            degree=num2str(svm.para(3));
            str=['-t 1 ','-g ',gamma,' -r ', coef,' -d ',degree,' -b 1'];
        case 'Linear'
            str='-t 0 -b 1';
        otherwise
            error('SVM types not supported, please type "help LIFT" for more information');
    end
    
    %Perform representation transformation and testing
    Pre_Labels=[];
    Outputs=[];
    for i=1:num_class        
        centers=[P_Centers{i,1};N_Centers{i,1}];
        num_center=size(centers,1);
        
        data=[];
        
        if(num_center>=5000)
            error('Too many cluster centers, please try to decrease the number of clusters (i.e. decreasing the value of ratio) and try again...');
        else
            blocksize=5000-num_center;
            num_block=ceil(num_test/blocksize);
            for j=1:num_block-1
                low=(j-1)*blocksize+1;
                high=j*blocksize;
                
                tmp_mat=[centers;test_data(low:high,:)];
                Y=pdist(tmp_mat);
                Z=squareform(Y);
                data=[data;Z((num_center+1):(num_center+blocksize),1:num_center)];                
            end
            
            low=(num_block-1)*blocksize+1;
            high=num_test;
            
            tmp_mat=[centers;test_data(low:high,:)];
            Y=pdist(tmp_mat);
            Z=squareform(Y);
            data=[data;Z((num_center+1):(num_center+high-low+1),1:num_center)];
        end
        
        testing_instance_matrix=data;
        testing_label_vector=test_target(i,:)';
        
        [predicted_label,accuracy,prob_estimates]=svmpredict(testing_label_vector,testing_instance_matrix,Models{i,1},'-b 1');
        if(isempty(predicted_label))
            predicted_label=train_target(i,1)*ones(num_test,1);
            if(train_target(i,1)==1)
                Prob_pos=ones(num_test,1);
            else
                Prob_pos=zeros(num_test,1);
            end
            Outputs=[Outputs;Prob_pos'];
            Pre_Labels=[Pre_Labels;predicted_label'];
        else
            pos_index=find(Models{i,1}.Label==1);
            Prob_pos=prob_estimates(:,pos_index);
            Outputs=[Outputs;Prob_pos'];
            Pre_Labels=[Pre_Labels;predicted_label'];
        end
    end
    HammingLoss=Hamming_loss(Pre_Labels,test_target);
    %RankingLoss=1
    RankingLoss=Ranking_loss(Outputs,test_target);
    OneError=One_error(Outputs,test_target);
    Coverage=coverage(Outputs,test_target);
    Average_Precision=Average_precision(Outputs,test_target);