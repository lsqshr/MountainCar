function mountaincardemo()
	f = figure(1);
	c = Car(0);
	hold on
	set(gcf,'CurrentCharacter','@'); % set to a dummy character

	i = 1;
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

			% fprintf('key:%d\tp: %f\tv:%f\t\n', k, get(car, 'p'), c.getVelocity());
		else
		    c.nothrottle();
		end

		drawCar(f, c, false);
	end

	hold off
end

function drawCar(f, car, flat)
	hold on
	clf(f);
	subplot(2,1,1);
	if flat
		line([-1.2, 0.6], [0, 0]);
		car.draw();
	else
		R = 5;
		viscircles([0,0], R);
		p = get(car, 'p');
		d = (p + 1.2) / 1.8;
		theta = d * pi;
		x = - cos(theta) * R;
		y = - sin(theta) * R;
		viscircles([x, y], 0.4);
	end
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
