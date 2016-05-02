function mountaincar()
	f = figure(1);

	c = Car(0);

	hold on
	set(gcf,'CurrentCharacter','@'); % set to a dummy character

	i = 1;
	% Draw a line to represent the mountain 
	while(true)
		k = get(gcf, 'CurrentCharacter');
		if k~= '@'
			% disp(double(k))
			set(gcf, 'CurrentCharacter', '@');
			if double(k) == 28 
				c.left();
			elseif double(k) == 29 
				c.right();
			else
			    c.nothrottle();
			end

			% fprintf('key:%d\tp: %f\tv:%f\t\n', k, c.getPosition(), c.getVelocity());
		else
		    c.nothrottle();
		end

		clf(f);

		line([-1.2, 0.6], [0, 0]);
		c.draw();
		axis equal;
		drawnow;
		M(i) = getframe;
		i = i + 1;
		if c.getPosition() >= 0.6
			txt1 = 'Right Bound Reached';
			text(c.getPosition() - 0.4, 0.2, txt1);
			break;
		end
	end

	hold off
	% movie2avi(M, 'mountaincar.avi', 'fps', 30);
	v = VideoWriter('mountaincar.mp4');
    open(v);
    writeVideo(v, M);
    close(v);
end
