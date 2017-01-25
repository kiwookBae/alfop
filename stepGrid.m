function [nextState, reward, terminal] = stepGrid(currentState, action)

%North
if action == 1
    if currentState <13
        nextState = currentState;
        reward = -1;
    elseif currentState>37 && currentState<48
        nextState = 37;
        reward = -100;
    else
        nextState = currentState-12;
        reward = -1;
    end
    
    if nextState == 48
        terminal = 1;
    else
        terminal = 0;
    end
end
%East
if action == 2
    if mod(currentState,12)==0
        nextState = currentState;
        reward = -1;
    elseif currentState>37 && currentState<48
        nextState = 37;
        reward = -100;
    else
        nextState = currentState+1;
        reward = -1;
    end    
    if nextState == 48
        terminal = 1;
    else
        terminal = 0;
    end
end
%South
if action == 3
    if currentState==37
        nextState = currentState;
        reward = -1;
    elseif currentState>37 && currentState<48
        nextState = 37;
        reward = -100;
    else
        nextState = currentState+12;
        reward = -1;
    end    
    if nextState == 48
        terminal = 1;
    else
        terminal = 0;
    end
end
%West
if action == 4
    if mod(currentState,12)==1
        nextState = currentState;
        reward = -1;
    elseif currentState>37 && currentState<48
        nextState = 37;
        reward = -100;
    else
        nextState = currentState-1;
        reward = -1;
    end    
    if nextState == 48
        terminal = 1;
    else
        terminal = 0;
    end
end

end