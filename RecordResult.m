function [ ] = RecordResult( Global )
%% 结果记录
    clc;%清空命令行
	method = func2str(Global.algorithm);
	question = func2str(Global.problem);
    fprintf('run: %d\n',Global.run);
    fprintf('%s with %s on %s\n',method,func2str(Global.operator),question);
    fprintf('N: %d     evaluation: %d\n',Global.N,Global.evaluation);
    fprintf('status: (%6.2f%%), %.2fs passed...\n',Global.evaluated/Global.evaluation*100,Global.runtime);
	if Global.evaluated >= Global.evaluation
        Objs = unique(Global.result{1,2}.objs,'rows');
        runtime = Global.runtime;
        save(method,'Objs','runtime');
 	end
end