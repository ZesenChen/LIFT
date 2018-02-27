feature('DefaultCharacterSet', 'UTF-8');
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
tag = {'style:','emotion:','scene:'};
model = {'stylemodel.mat', 'emotionmodel.mat', 'scenemodel.mat'};
test_path = {'E:/Graduation design/display/style_test/', ...
             'E:/Graduation design/display/emotion_test/', ...
             'E:/Graduation design/display/scene_test/'};
TrainDataPath = {'lyric_style.mat','lyric_emotion.mat','lyric_scene.mat'};
%==========================================================================
%∏Ë«˙…Ë÷√|‘§≤‚±Í«©…Ë÷√
predict_tag = 3;%style:1;emotion:2;scene:3
song = 116;

%==========================================================================
switch predict_tag
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
svm.type = 'Linear';
svm.para = [];
ratio = 0.1;
song_path = [test_path{predict_tag},num2str(song-1),'.mat'];
test_song = load(song_path);
data = test_song.data;
target = test_song.target;
[HammingLoss,RankingLoss,OneError,Coverage,Average_Precision,Outputs, ...
Pre_Labels]=liftpredict(data,target,ratio,svm,Models,P_Centers, ...
N_Centers);
%disp(Pre_Labels);
if(predict_tag==1)
    fprintf('song:');
    disp(song_sty{song});
    fprintf('predict style:');
    for i =1:1:22
        if(Pre_Labels(i)==1)
            fprintf(sty{i});
            fprintf(' ');
        end
    end
    fprintf('\ntrue style:');
    for i =1:1:22
        if(target(i)==1)
            fprintf(sty{i});
            fprintf(' ');
        end
    end
elseif(predict_tag==2)
    fprintf('song:');
    disp(song_emt{song});
    fprintf('predict emotion:');
    for i =1:1:16
        if(Pre_Labels(i)==1)
            fprintf(emt{i});
            fprintf(' ');
        end
    end
    fprintf('\ntrue emotion:');
    for i =1:1:16
        if(target(i)==1)
            fprintf(emt{i});
            fprintf(' ');
        end
    end
else
    fprintf('song:');
    disp(song_sce{song});
    fprintf('predict scene:');
    for i =1:1:16
        if(Pre_Labels(i)==1)
            fprintf(sce{i});
            fprintf(' ');
        end
    end
    fprintf('\ntrue scene:');
    for i =1:1:16
        if(target(i)==1)
            fprintf(sce{i});
            fprintf(' ');
        end
    end
end
fprintf('\n');