function sarsalambda(p)
% Train Sarsa lambda algorithm to solve the mountain car problem
% defined in 'Reinforcement learning: An introduction 2012 R.Sutton'
% PARA
% p.lambda : temporal decay 
% p.gamma : reward decay 
% p.eps : random choice
% p.alpha : learning rate
% p.ntile : number of tiles to discrete the state space
% p.plot : 1 visualise the control while training; 0 train silently;

	if p.plot
		f = figure(1);
	end

    x = logical(zeros(p.ntile * p.ntile, 3)); % features
	w = zeros(size(x));
	steps = zeros(1e7, 1);

    i = 0;
	while true % For each episode
		i = i + 1;
		z = zeros(size(x));
        step = 0;
        % State initialised
        car = Car(rand() * 1.8 - 1.2); 

        % Initialise the action A
        A = 3;

        fprintf('Episode: %d\n', i);
        while true
	        x = getFeatures(car, A, p, x);
        	z(x) = 1; % Replacing traces

	        % Take action A
	        car = takeAction(car, A);
	        R = getReward(car); % Get Reward
	        q = sum(w(x));
	        delta = R - q;
            
            if get(car, 'p') >= 0.6 % End of episode
            	break;
            end


            if rand() < p.eps % Exceptional action
            	A = randi(3);
	        	x = getFeatures(car, A, p, x);
		        q = sum(w(x));
	            delta = delta + p.gamma * q;
            else
            	for a = 1 : 3
		        	x = getFeatures(car, a, p, x);
		            Q(a) = sum(w(x));
		        end

		        [~, A] = max(Q, [], 2); % New on-policy action
	            delta = delta + p.gamma * Q(A);
            end

            w = w + p.alpha * delta * z;
            z = p.gamma * p.lambda * z; % Does not take effects if replace traces

        	step = step + 1;

        	if p.plot && rem(i, p.showevery) == 0
	        	% fprintf('Episode:%d\tStep:%d\tdelta:%.2f\tA:%d\tp:%.2f\tv:%.2f\n', ...
	        	% 	i, step, delta, A, get(car, 'p'), get(car, 'v'));
	            drawCar(f, car);
	        end
	    end

	    steps(i) = step;

    	if p.plot && rem(i, p.showevery) == 0
            drawSpeed(f, steps(1:i));
	    end
	end

end


function drawCar(f, car)
	hold on
	clf(f);
	subplot(2,1,1);
	line([-1.2, 0.6], [0, 0]);
	car.draw();
	axis equal;
	% M(i) = getframe;
	% i = i + 1;
	if get(car, 'p') >= 0.6
		txt1 = 'Right Bound Reached';
		text(get(car, 'p') - 0.4, 0.2, txt1);
	end
	drawnow;
	hold off

end	

function drawSpeed(f, steps)
	clf(f);
	subplot(2,1,2)
    plot(steps)
    drawnow
end

function car = takeAction(car, I)
    switch I
		case 1
			car.left();
		case 2
			car.nothrottle();
		case 3
            car.right();
		otherwise
			ME = MException('Action:Undefined action', ...
					        'action %f not defined', I);
		    throw(ME)
    end
end


function x = getFeatures(car, A, p, x)
	x(:) = 0;
	tilewidth1 = 1.8 / p.ntile;
    t1 = floor((get(car, 'p') + 1.2) / tilewidth1 + 1);
    tilewidth2 = 1.4 / p.ntile;
    t2 = floor((get(car, 'v') + 0.07) / tilewidth2 + 1);
    t = t1 + (t2 - 1) * p.ntile;
	x(t, A) = 1;
end


function R = getReward(car)
	if get(car, 'p') < 0.06
		R = -1.0;
	else 
		R = 0.0;
	end
end