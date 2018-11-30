function [result ] = experiment()
%% ʵ�����
    %�����ظ�����
    G = 2;
    result = cell(1,4);
    %����ʵ��
    [mean1,div1,runtime1] = exp_1(G);
    [mean2,div2,runtime2] = exp_2(G);
    %��������
    result{1} = mean1;
    result{2} = div1;
    result{3} = runtime1;
    result{4} = mean2;
    result{5} = div2;
    result{6} = runtime2;
    save result;
end

%% ʵ��1
function [mean_c,div_c,runtime] = exp_1(G)
    %ʵ���������
    N = [50,100,150,200,250];%��Ⱥ��ģ
    evaluation = [10000,10000,10000,10000,10000];%��������
    times = length(N);%ʵ�����
    mean_c = cell(1,times);%ʵ����meanԪ������
    div_c = cell(1,times);%ʵ����divԪ������
    runtime = cell(1,times);%ʵ����divԪ������
    
    %����ʵ��
    for i=1:length(N)
        [mean_c{i},div_c{i},runtime{i}] = run(N(i),evaluation(i),G);%������Ⱥ��ģ�������������ظ�����
    end
end

%% ʵ��2
function [mean_c,div_c,runtime] = exp_2(G)
    %ʵ���������
    N = [50,50,50,100,100,100,150,150,150];%��Ⱥ��ģ
    evaluation = [15000,25000,35000,30000,50000,70000,45000,75000,105000];%��������
    times = length(N);%ʵ�����
    mean_c = cell(1,times);%ʵ����meanԪ������
    div_c = cell(1,times);%ʵ����divԪ������
    runtime = cell(1,times);%ʵ����divԪ������
    
    %����ʵ��
    for i=1:length(N)
        [mean_c{i},div_c{i},runtime{i}] = run(N(i),evaluation(i),G);%������Ⱥ��ģ�������������ظ�����
    end
end

%% ����MOEA�㷨��ԭ�Ͷ��ڵ��������ϵ�����
function [mean_c, div_c,runtime] = run(N,evaluation,G)
    %�Ա��㷨�����Ӧ�Ĳ�����һ���ķ���
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
    algorithem_num = length(algorithmsandoperators)/2;%�㷨����
    %��ʱ����
    clection = cell(1,algorithem_num);%PF
    results = zeros(G,algorithem_num,algorithem_num);%Cָ��ֵ
    runtime = zeros(1,algorithem_num);%����ʱ��

    %����G��ʵ��
    for t=1:G
        %�ֱ�����㷨1....9
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
            runtime(i) = runtime(i) + clection{i}.runtime;%����ʱ��runtime
        end
        %����cָ��
        for i=1:algorithem_num
            for j=1:algorithem_num
                if i~=j
                    %�����i���㷨�͵�j���㷨��Cָ��ֵ
                    results(t,i,j) = C(clection{i}.Objs,clection{j}.Objs);
                end
            end
        end
    end
    
    %����cָ��ľ�ֵ
	for i=1:algorithem_num
        for j=1:algorithem_num
            mean_c(i,j) = mean(results(:,i,j));
        end
	end
    
    %��������ʱ��ľ�ֵ
    runtime = runtime/G;
    
    %����cָ��ı�׼��
	for i=1:algorithem_num
        for j=1:algorithem_num
            div_c(i,j) = std(results(:,i,j));
        end
	end
end

