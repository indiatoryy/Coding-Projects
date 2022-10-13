%% Integrator Lab: Solving First Order ODEs in MATLAB
% This lab will teach you to numerically solve first order ODEs using a built 
% in MATLAB integrator, |ode45|.  |ode45| is a good, general purpose tool for 
% integrating first order equations (and first order systems). It is not always 
% the right algorithm, but it is usually the right algorithm to try first.
% 
% You will learn how to use the |ode45| routine, how to interpolate between 
% points, and how MATLAB handles data structures.
% 
% Opening the m-file lab2.m in the MATLAB editor, step through each part using 
% cell mode to see the results. Compare the output with the PDF, which was generated 
% from this m-file.
% 
% There are six exercises in this lab that are to be handed in at the end of 
% the lab. Write your solutions in the template, including appropriate descriptions 
% in each step. Save the .m file and submit it online using Quercus.
%% Student Information
% Student Name: India Tory
% 
% Student Number: 1006944121
%% Set up an inline function representation of an ODE and solve it
% MATLAB has many built in routines for solving differential equations of the 
% form
% 
% |y' = f(t,y)|
% 
% We will solve them using |ode45|, a high precision integrator. To do this, 
% we will need to construct an inline function representation of |f|, an initial 
% condition, and specify how far we want MATLAB to integrate the problem. Once 
% we have set these, we pass the information to |ode45| to get the solution.
% 
% For a first example, we will solve the initial value problem
% 
% |y' = y, y(0) = 1|
% 
% which has as its answer |y = e^t|. 

% Set up the right hand side of the ODE as an inline function
f = @(t,y) y; 

% The initial conditions
t0 = 0;
y0 = 1;

% The time we will integrate until
t1 = 2;

soln = ode45(f, [t0, t1], y0);
%% Examining the output
% When we execute the |ode45|, it returns a data structure, stored in soln. 
% We can see the pieces of the data structure with a display command:

disp(soln);
%% Understanding the components of the solution data structure
% The most important elements of the data structure are stored in the |x| and 
% |y| components of the structure; these are vectors. Vectors |x| and |y| contain 
% the points at which the numerical approximation to the initial value problem 
% has been computed. In other words, |y(j)| is the approximate value of the solution 
% at |x(j)|.
% 
% *NOTE:* Even though we may be studying a problem like |u(t)| or |y(t)|, MATLAB 
% will always use |x| for the independent variable and |y| for the dependent variable 
% in the data structure.
% 
% Pieces of the data structure can be accessed using a period, as in C/C++ or 
% Java. See the examples below:

% Display the values of |t| at which |y(t)| is approximated
fprintf(' Vector of t values: ');
disp(soln.x);
% Display the the corresponding approximations of |y(t)|
fprintf(' Vector of y values: ');
disp(soln.y);

% Display the approximation of the solution at the 3rd point:
fprintf(' Third element of the vector of t values: %g\n',soln.x(3));
fprintf(' Third element of the vector of y values: %g\n',soln.y(3));
%% Visualizing and comparing the solution
% We can now visualize the solution at the computed data points and compare 
% with the exact solution.

% Construct the exact solution
tt = linspace(0,2,50);
yy = exp(tt);

% Plot both on the same figure, plotting the approximation with x's
plot(tt, yy, soln.x, soln.y, 'x', 'MarkerSize',10, 'LineWidth', 2);
% NOTE: the MarkerSize and LineWidth are larger than their defaults of 6
% and 1, respectively.  This makes the print out more readable.

% Add a label to the axis and a legend
xlabel('t');
legend('Exact', 'Numerical','Location','Best');
%% Exercise 1
% Objective: Solve an initial value problem and plot both the numerical approximation 
% and the corresponding exact solution.
% 
% Details: Solve the IVP
% 
% |y' = y tan t + sin t, y(0) = -1/2|
% 
% from |t = 0| to |t = pi|.
% 
% Compute the exact solution (by hand), and plot both on the same figure for 
% comparison, as above.
% 
% Your submission should show the construction of the inline function, the use 
% of ode45 to obtain the solution, a construction of the exact solution, and a 
% plot showing both. In the comments, include the exact solution.
% 
% Label your axes and include a legend.

f = @(t,y) y.*tan(t) + sin(t);

t0 = 0;
t1 = pi;
y0 = -1/2;

soln1 = ode45(f, [t0, t1], y0);

% General: ((1/2)sin^2(t)+C)/cos(t)
% Exact: -cos(t)/2

tt1 = linspace(0,pi);
yy1 = ((1/2).* sin(tt1).^2 - 1/2) ./ (cos(tt1));

% Plot both on the same figure, plotting the approximation with x's
plot(tt1, yy1, soln1.x, soln1.y, 'x', 'MarkerSize',10, 'LineWidth', 2);

% Add a label to the axis and a legend
xlabel('t');
title('Exercise 1')
legend('Exact', 'Numerical','Location','Best');
%% Computing an approximation at a specific point
% As you should be able to see by examining |soln.x|, ode45 returns the solution 
% at a number of points between |t0| and |t1|. But sometimes we want to know the 
% solution at some intermediate point.
% 
% To obtain this value, we need to interpolate it in a consistent way. Fortunately, 
% MATLAB provides a convenient function, |deval|, specifically for this.

% Compute the solution at t = .25:
deval(soln, .25)

% Compute the solution at t = 1.6753:
fprintf(' Solution at 1.6753: %g\n', deval(soln, 1.6753));

% Compute the solution at 10 grid points between .45 and 1.65:
tinterp = linspace(.45, 1.65, 10);
deval(soln, tinterp)

% Alternatively:
deval(soln, linspace(.45, 1.65, 10))
%% Exercise 2
% Objective: Interpolate a solution at a number of grid points
% 
% Details: For the solution you computed in exercise 1, use deval to compute 
% the interpolated values at 10 grid points between 2 and 3.

% Compute the solution at 10 grid points between 2 and 3:
tinterp = linspace(2, 3, 10);
deval(soln1, tinterp)
%% Errors, Step Sizes, and Tolerances
% As you may have noticed, in contrast to the IODE software, at no point do 
% we set a step size for our solution. Indeed, the step size is set adaptively 
% to conform to a specified error tolerance. 
% 
% Roughly speaking, given the solution at |(t_j, y_j)|, |ode45| computes two 
% approximations of the solution at |t_{j+1} = t_j + h|; one is of greater accuracy 
% than the other. If the difference is below a specified tolerance, the step is 
% accepted and we continue. Otherwise the step is rejected and the smaller step 
% size, |h|, is used; it is often halved.
% 
% We can compute the global truncation error at each solution point, figure 
% out the maximum error, and visualize this error (on a linear-log scale):

% Compute the exact solution
yexact = exp(soln.x);

% Compute the point-wise error; note the use of MATLAB's vectorization
err = abs(yexact - soln.y);

disp(err);

fprintf('maximum error: %g \n', max(err));

semilogy(soln.x, err, 'LineWidth', 2);
xlabel('t');
ylabel('error');
%% Exercise 3
% Objective: Examine the error of a solution generated by |ode45|
% 
% Details: For your solution to exercise 1, compute the point-wise error, identify 
% the maximum value of the error, and visualize the error on a linear-log plot 
% (use semilogy to plot the log of the error vs. t). Write in the comments where 
% the error is largest, and give a brief (1-2 sentences) explanation of why it 
% is largest there. Make sure to label your axes.

% Compute the exact solution
yexact = ((1/2).* sin(soln1.x).^2 - 1/2) ./ (cos(soln1.x));

% Compute the point-wise error
err = abs(yexact - soln1.y);
disp(err);

% Display maximum error
fprintf('maximum error: %g \n', max(err));

semilogy(soln1.x, err, 'LineWidth', 2);
title('Exercise 3');
xlabel('t');
ylabel('error');
%% Exercise 4
% Objective: Solve and visualize a nonlinear ode using ode45
% 
% Details: Solve the IVP
% 
% |y' = 1 / y^2 , y(1) = 1|
% 
% from |t=1| to |t=10| using |ode45|. Find the exact solution and compute the 
% maximum point-wise error. Then plot the approximate solution and the exact solution 
% on the same axes.
% 
% Your solution should show the definition of the inline function, the computation 
% of its solution in this interval, the computation of the exact solution at the 
% computed grid points, the computation of the maximum error, and a plot of the 
% exact and approximate solutions. Your axes should be appropriately labeled and 
% include a legend.

% General: y = (3t + c) ^(1/3)
% Exact: y(t) = (3t - 2) ^(1/3)

f = @(t,y) 1 ./ y.^2;
fy = @(t) (3*t - 2) .^ (1/3);

% conditions
t0 = 1;
t1 = 10;
y0 = 1;

soln4 = ode45(f, [t0, t1], y0);

tt1 = linspace(t0, t1);
yy1 = fy(tt1);
yexact = fy(soln4.x);

err = abs(yexact - soln4.y);
disp(err);

% Display maximum error
fprintf('maximum error: %g \n', max(err));

% Plot both on the same figure, plotting the approximation with x's
plot(tt1, yy1, soln4.x, soln4.y, 'x', 'MarkerSize',10, 'LineWidth', 2);

% Add a label to the axis and a legend
xlabel('t');
title('Exercise 4')
legend('Exact', 'Numerical','Location','Best');
%% Exercise 5
% Objective: Solve and visualize an ODE that cannot be solved by hand with |ode45|.
% 
% Details: Solve the IVP
% 
% |y' = 1 - t y / 2, y(0) = -1|
% 
% from |t=0| to |t=10|. 
% 
% Your solution should show you defining the inline function, computing the 
% solution in this interval, and plotting it.
% 
% Your axes should be appropriately labeled

% function
f = @(t, y) 1 - (t .* y) ./ 2;

% initial conditions
t0 = 0;
t1 = 10;
y0 = -1;

% solving
soln5 = ode45(f, [t0, t1], y0);

% graphing
plot(soln5.x, soln5.y, 'x', 'MarkerSize',10, 'LineWidth', 2);
title('Exercise 5');
xlabel('x');
ylabel('y');
legend('Numerical', 'Location', 'Best');
%% Exercise 6 - When things go wrong
% Objective: Solve an ode and explain the warning message
% 
% Details: Solve the IVP:
% 
% |y' = y^3 - t^2, y(0) = 1|
% 
% from |t=0| to |t=1|. 
% 
% Your solution should show you defining the inline function, and computing 
% the solution in this interval.
% 
% If you try to plot the solution, you should find that the solution does not 
% make it all the way to t = 1.
% 
% In the comments explain why MATLAB generates the warning message that you 
% may see, or fails to integrate all the way to t=1. HINT: Try plotting the direction 
% field for this with IODE.

% function
f = @(t, y) y.^3 - t.^2;

% initial conditions
t0 = 0;
t1 = 1;
y0 = 1;

% solution
soln6 = ode45(f, [t0, t1], y0);

% from hint: plotting direction field
plot(soln6.x, soln6.y);
title('Exercise 6')

% MATLAB generates a warning because the slope of the solution is increasing to
% + infinity as the particular solution approaches t=1. It does not,
% however, give an error.