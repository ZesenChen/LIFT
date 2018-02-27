%This is an examplar file on how the LIFT program could be used (The main function is "LIFT.m")
%
%Type 'help LIFT' under Matlab prompt for more detailed information
%
%N.B.: Please ensure that libsvm package [1] (as attached) is put under the matlab path before envoking the LIFT function.
%
%[1] C.-C. Chang and C.-J. Lin. LIBSVM: a library for support vector machines, Technical Report, 
%2001. [http://www.csie.ntu.edu.tw/~cjlin/libsvm]


% Loading the file containing the necessary inputs for calling the LIFT function
load('sample data.mat'); 

%Set the ratio parameter used by LIFT
ratio=0.1;

% Set the kernel type used by Libsvm
svm.type='Linear';
svm.para=[];

% Calling the main function LIFT
[HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Outputs,Pre_Labels]=LIFT(train_data,train_target,test_data,test_target,ratio,svm);