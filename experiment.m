function [result ] = experiment()
%% 实验设计
    %设置重复次数
    G = 2;
    result = cell(1,4);
    %运行实验
    [mean1,div1,runtime1] = exp_1(G);
    [mean2,div2,runtime2] = exp_2(G);
    %四舍五入
    result{1} = mean1;
    result{2} = div1;
    result{3} = runtime1;
    result{4} = mean2;
    result{5} = div2;
    result{6} = runtime2;
    save result;
end

%% 实验1
function [mean_c,div_c,runtime] = exp_1(G)
    %实验参数设置
    N = [50,100,150,200,250];%种群规模
    evaluation = [10000,10000,10000,10000,10000];%迭代次数
    times = length(N);%实验个数
    mean_c = cell(1,times);%实验结果mean元胞数组
    div_c = cell(1,times);%实验结果div元胞数组
    runtime = cell(1,times);%实验结果div元胞数组
    
    %进行实验
    for i=1:length(N)
        [mean_c{i},div_c{i},runtime{i}] = run(N(i),evaluation(i),G);%设置种群规模，迭代次数，重复次数
    end
end

%% 实验2
function [mean_c,div_c,runtime] = exp_2(G)
    %实验参数设置
    N = [50,50,50,100,100,100,150,150,150];%种群规模
    evaluation = [15000,25000,35000,30000,50000,70000,45000,75000,105000];%迭代次数
    times = length(N);%实验个数
    mean_c = cell(1,times);%实验结果mean元胞数组
    div_c = cell(1,times);%实验结果div元胞数组
    runtime = cell(1,times);%实验结果div元胞数组
    
    %进行实验
    for i=1:length(N)
        [mean_c{i},div_c{i},runtime{i}] = run(N(i),evaluation(i),G);%设置种群规模，迭代次数，重复次数
    end
end

%% 分析MOEA算法在原油短期调度问题上的性能
function [mean_c, div_c,runtime] = run(N,evaluation,G)
    %对比算法与其对应的产生下一代的方法
    algorithmsandoperators = {'NSGAII','DE',...
        'NSGAIII','DE',...
        'IBEA','EAreal',...
        'ARMOEA','FEP',...
        'RVEA','DE',...
        'MOEAD','DE',...
        'KnEA','DE',...
        'GrEA','DE',...
        'BBMOPSO','BBPSO'};
    mean_c = zeros(9);
    div_c = zeros(9);
    algorithem_num = length(algorithmsandoperators)/2;%算法个数
    %临时数据
    clection = cell(1,algorithem_num);%PF
    results = zeros(G,algorithem_num,algorithem_num);%C指标值
    runtime = zeros(1,algorithem_num);%运行时间

    %运行G次实验
    for t=1:G
        %分别调用算法1....9
        for i=1:algorithem_num
            main('-algorithm', str2func(algorithmsandoperators{2*i-1}),...
                    '-problem', @DMOPs2_OS, ...
                    '-N', N,...
                    '-run', t,...
                    '-operator', str2func(algorithmsandoperators{2*i}),...
                    '-evaluation',evaluation, ...
                    '-D', 50,...
                    '-mode',3,...
                    '-outputFcn',@RecordResult);
            clection{i}=load(sprintf('%s.mat',algorithmsandoperators{2*i-1}));%PF
            runtime(i) = runtime(i) + clection{i}.runtime;%运行时间runtime
        end
        %计算c指标
        for i=1:algorithem_num
            for j=1:algorithem_num
                if i~=j
                    %计算第i中算法和第j中算法的C指标值
                    results(t,i,j) = C(clection{i}.Objs,clection{j}.Objs);
                end
            end
        end
    end
    
    %计算c指标的均值
	for i=1:algorithem_num
        for j=1:algorithem_num
            mean_c(i,j) = mean(results(:,i,j));
        end
	end
    
    %计算运行时间的均值
    runtime = runtime/G;
    
    %计算c指标的标准差
	for i=1:algorithem_num
        for j=1:algorithem_num
            div_c(i,j) = std(results(:,i,j));
        end
	end
end

