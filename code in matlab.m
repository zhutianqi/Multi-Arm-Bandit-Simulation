function main

std = 1;% variance = 1
rounds = 1000;% 1000 steps per 10 machines
arms = normrnd(0,1,[10 1]);% generate seed ie. means for 10 machines

epsilon_greedy_1 = zeros(2000,rounds);% run both algorithms 2000 times and take average(based on book)
 for iter = 1:2000
   epsilon_greedy_1(iter,:) = epsilon_greedy(10,arms,std,rounds,0.1);
 end
 
 UCB_1 = zeros(2000,rounds);
 for iter = 1:2000
     UCB_1(iter,:) = UCB(10,arms,std,rounds);
 end
 
 
%plot figuren n  
figure
plot(mean(UCB_1(:,:)),'c');
hold on;
plot(mean(epsilon_greedy_1(:,:)),'b');
axis([0 1000 -1 3])
ylabel('Average reward');
xlabel('Steps');
legend('UCB with C=2','\epsilon-greedy with \epsilon=0.1');
title('Comparision between UCB and \epsilon-greedy');

end

function [reward]= UCB(k, arms,std,rounds)
%     Input: 
%         k:  number of arms
%         std:  standard deviation
%         rounds: steps
%     Output: 
%         reward: reward for each step
%         pulls: count pulls for each arm


pulls = zeros(k,1);          % initialization
reward = zeros(1,rounds); 
average = zeros(k,1);    %record average reward

% Play each machine once
for i=1:k
    pulls(i) = pulls(i) + 1;
    average(i) = normrnd(arms(i),std);
    reward(1,i) = average(i);
end

% play machine j that maximize UCB rules
for i = k+1:rounds
    % select the arm to pull
    temp = zeros(k,1);
    index = 1;
    m = 0;
    for j=1:k
        temp(j) = average(j,1) + 2*sqrt(2*log(i)/pulls(j,1));
        if m < temp(j)
            m = temp(j);
            index = j;
        end
    end
    
    % play arm with selected index
    res=  normrnd(arms(index),std);
    average(index) = (average(index) * pulls(index) + res)/(pulls(index)+1);
    reward(1,i) = res;
    pulls(index) = pulls(index) + 1;
    
end
end

function [reward]=epsilon_greedy(k, arms,std, rounds, epsilon)
%     Input :
%         arms: the mean reward for each arm
%         k: number of arms
%         std: standard deviation
%         rounds: steps
%         epsilon: parameter for epsilon greedy 
%     Output: 
%         reward: reward for each round 
%         pulls: number of pulls for each arm

pulls = zeros(k,1);          % initialize
reward = zeros(1,rounds);     
average = zeros(k,1);
for i=1:k
    average(i,1) = normrnd(arms(i),1);
end

for iter=1:rounds
    if rand < epsilon
        % randomly pull one of arm
        index = randi(k);
        result= normrnd(arms(index,1),std);
        average(index,1) = (average(index,1)*pulls(index,1)+ result)/(pulls(index,1)+1);
        reward(1,iter) = result;
        pulls(index,1) = pulls(index,1) + 1;
    else
        % pull the arm with highest average award
        idx=1;
        m=0;
        for j=1:k
            if average(j,1) > m
                m = average(j,1);
                idx = j;
            end
        end
        
        % pull the arms with idx
        
        res=normrnd(arms(idx,1),std);
        average(idx,1) = (average(idx,1)*pulls(idx,1)+ res)/(pulls(idx,1)+1);
        reward(1,iter) =  res;
        pulls(idx,1) = pulls(idx,1) + 1;
        
    end
    
end
end