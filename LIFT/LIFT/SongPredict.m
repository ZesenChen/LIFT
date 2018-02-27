feature('DefaultCharacterSet', 'UTF8');
sty = importdata('E:/Graduation design/display/sty.txt');
emt = importdata('E:/Graduation design/display/emt.txt');
sce = importdata('E:/Graduation design/display/sce.txt');
song_sty = importdata('E:/Graduation design/display/song_style.txt');
song_emt = importdata('E:/Graduation design/display/song_emotion.txt');
song_sce = importdata('E:/Graduation design/display/song_scene.txt');

lyricfile = {'E:/Graduation design/MLKNN/lyric2k5_style.mat', ...
             'E:/Graduation design/MLKNN/lyric2k5_emotion.mat', ...
             'E:/Graduation design/MLKNN/lyric2k5_scene.mat'};
Result = {'STYLE.txt','EMOTION.txt','SCENE.txt'};
tag = {'";"predict style":"','";"predict emotion":"','";"predict scene":"'};
svm.type = 'Linear';
svm.para = [];
for circle = 1:1:3
    switch circle
    case 1
        svmmodel = load('stylemodel.mat');
    case 2
        svmmodel = load('emotionmodel.mat');
    otherwise
        svmmodel = load('scenemodel.mat');
    end
    Models = svmmodel.Models;
    P_Centers = svmmodel.P_Centers;
    N_Centers = svmmodel.N_Centers;
    dataset = load(lyricfile{circle});
    target = dataset.target;
    data = dataset.data;
    [train_data,train_target,test_data,test_target,test_num] = ...
    DataDiv(data, target, 0.1);
    [HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Outputs, ...
     Pre_Labels]=liftpredict(test_data,test_target,ratio,svm,Models,P_Centers, ...
     N_Centers);
    labels = Pre_Labels';
    [row,col] = size(labels);
    disp(['E:/Graduation design/LIFT/LIFT/result/',Result{circle}]);
    fp = fopen(['E:/Graduation design/LIFT/LIFT/result/',Result{circle}],'wt');
    for i = 1:1:row
        song_name = song_sty{test_num(i)};
        %disp(song_name);
        fprintf(fp,'%s',['{"song":"',song_name,tag{circle}]);
        %fp = fopen(filename,'wt');
        for j = 1:1:col
            if(labels(i,j) == 1)
                if(circle==1)
                    temp = [sty{j},';'];
                elseif(circle==2)
                    temp = [emt{j},';'];
                else
                    temp = [sce{j},';'];
                end
                fprintf(fp,'%s',temp);
            end
        %fclose(fp);
        end
        fprintf(fp,'%s','";"true labels":"');
        for k =1:1:col
            if(test_target(k,i) == 1)
                if(circle==1)
                    temp = [sty{k},';'];
                elseif(circle==2)
                    temp = [emt{k},';'];
                else
                    temp = [sce{k},';'];
                end
                fprintf(fp,'%s',temp);
            end
        end
        fprintf(fp,'%s\n','"}');
    end
    %fclose(fp);
    fclose(fp);
    disp('===============================================');
    disp('Hamming Loss:');
    disp(HammingLoss);
    disp('Ranking Loss:');
    disp(RankingLoss);
    disp('One Error:');
    disp(OneError);
    disp('Coverage:');
    disp(Coverage);
    disp('Average Precision:');
    disp(Average_Precision);
    disp([Result{circle},' has been finished.']);
    disp('===============================================');
end
