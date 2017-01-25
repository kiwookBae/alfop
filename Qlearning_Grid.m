<<<<<<< HEAD
itr = 100000;
=======
itr = 100;
>>>>>>> sth

epsilon = 0.1;
QQlearning = zeros(48,4);
count = zeros(48,4);
rewardSum=zeros(itr,1);

for i=1:itr
    state = 37;
    [a, b] = max(QQlearning(state,:),[],2);
    egreedy = zeros(1,4);
    for k = 1:size(egreedy,2)
        if k==b
            egreedy(k) = 1-epsilon+epsilon/4;
        else
            egreedy(k) = epsilon/4;
        end
    end
    %e-greedy policy
    rnd = rand(1);
    if rnd<egreedy(1)
        action = 1;
    elseif rnd<egreedy(1)+egreedy(2) 
        action = 2;
    elseif rnd<egreedy(1)+egreedy(2)+egreedy(3)
        action = 3;
    else
        action = 4;
    end
    terminal = 0;

    while terminal==0
        count(state,action) = count(state,action)+1;
        [nextState, reward, terminal] = stepGrid(state,action);
        rewardSum(i)=rewardSum(i)+reward;
        if terminal~=0
            delta = reward+0-QQlearning(state,action);
            QQlearning(state,action) = QQlearning(state,action)+1/count(state, action)*delta;
            break
        end
        [a, b] = max(QQlearning(nextState,:),[],2);
        delta = reward+QQlearning(nextState,b)-QQlearning(state,action);
        QQlearning(state,action) = QQlearning(state,action)+1/count(state, action)*delta;

        egreedy = zeros(1,4);
        for k = 1:size(egreedy,2)
            if k==b
                egreedy(k) = 1-epsilon+epsilon/4;
            else
                egreedy(k) = epsilon/4;
            end
        end
        %e-greedy policy
        rnd = rand(1);
        if rnd<egreedy(1)
            nextAction = 1;
        elseif rnd<egreedy(1)+egreedy(2) 
            nextAction = 2;
        elseif rnd<egreedy(1)+egreedy(2)+egreedy(3)
            nextAction = 3;
        else
            nextAction = 4;
        end
        
        state = nextState;
        action = nextAction;
    end
    i=i+1;
end

[QSpace, policySpace] = max(QQlearning,[],2);
gridQSpace = [QSpace(1:12,1)';QSpace(13:24,1)';QSpace(25:36,1)';QSpace(37:48,1)'];
gridpolicySpace = [policySpace(1:12,1)';policySpace(13:24,1)';policySpace(25:36,1)';policySpace(37:48,1)'];
surf(gridQSpace)
title('Qlearning')