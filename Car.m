classdef Car<handle
    properties (Access = private)
        p % Position
        v % Velosity
    end
    
    methods (Access = public)
        function obj = Car(p)
            obj.p = p;	
            obj.v = 0;
            obj.updateVelocity(0);
        end

        function obj = left(obj)
        	obj.updateVelocity(-1);
        	obj.updatePosition();
        end

        function obj = right(obj)
        	obj.updateVelocity(1);
        	obj.updatePosition();
        end

        function obj = nothrottle(obj)
        	obj.updateVelocity(0);
        	obj.updatePosition();
        end

        function obj = draw(obj)
            rectangle('Position', [obj.p - 0.03, 0, 0.06, 0.03]);
        end

        function p = getPosition(obj)
            p = obj.p;
        end

        function v = getVelocity(obj)
        	v = obj.v;
        end

	end

	methods (Access = private)
	    function a = bound(obj, a, low, high)
            if a < low
            	a = low;
            elseif a > high
            	a = high;
            end
	    end

        function obj = updateVelocity(obj, throttle)
        	% throttle: -1 left throttle; 0 no throttle; 1 right throttle
            v = obj.v + 0.001 * throttle - 0.0025 * cos(3 * obj.p);
            obj.v = obj.bound(v, -0.07, 0.07);
        end

        function obj = updatePosition(obj)
        	obj.p = obj.bound(obj.p + obj.v, -1.2, 0.6);
        end
	end
end