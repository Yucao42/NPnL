function [ w ] = filterOutliers( lines_3D, lines_2D, w_in, reproj_err_th, focal )
%FILTEROUTLIERS Algebraic Outlier Rejection of mismatched lines.
%		INPUT: 
%   lines_3D - 6xN matrix of 3D lines Plücker coordinates
%   lines_2D - 3xN matrix of 2D lines in the normalized image plane
%   w_in - Nx1 vector of weights of lines
%   reproj_err_th - threshold for maximal line reprojection error
%   focal - focal length of the camera [px] (used to compute error threshold which depends on focal)
%
%		OUTPUT:
%		w - Nx1 vector of 0/nonzero weights
%
% Algebraic outlier rejection based on the paper: L. Ferraz, X. Binefa,
% F. Moreno-Noguer: Very Fast Solution to the PnP Problem with
% Algebraic Outlier Rejection, CVPR 2014.
%
% Line reprojection error is the one defined in: C.J.Taylor and D.J.Kriegman:
% "Structure and Motion from Line Segments in Multiple Images".
%


%% Input checks
	if (size(lines_3D,2) ~= size(lines_2D,2))
		error('filterOutliers:linecount', 'number of image lines and world lines is not equal');
	end
	
	if (size(lines_3D,2) ~= length(w_in))
		error('filterOutliers:weightcount', 'number of lines and weights is not equal');
	end
	
	NLINES = size(lines_3D, 2);
	
	
	%% Initialize
	
	% assemble the system of linear equations Mp = 0;  p = P(:)
	M = getMeasurementMatrix(lines_3D, lines_2D);

	% diagonal matrix of weights
	W = diag([w_in; w_in]); 
	
	err_max = Inf;
	err_th = 0;
	err_max_th = 1.4 * reproj_err_th / abs(focal);
	
	
	%% Iterate
	iter=0;
	
	while(err_th <= err_max)
		iter = iter+1;

		[~, ~, V] = svd(W * M, 'econ');
		projMatLines = V(:,end);

		residual = M * projMatLines;
		errors = zeros(NLINES, 1);
		for i = 1:NLINES
			errors(i) = norm([residual(i) residual(NLINES+i)]);
		end

		switch(iter)
			case {1 2 3 4 5 6 7}
				err_quantile = 1 - 0.1 * iter;
			otherwise
				err_quantile = 0.25;
		end
				
		err_th = quantile(errors, err_quantile);

		% check if enough correspondences (at least 9) are available
		if(sum(errors <= err_th) < 9)
			errors_sorted = sort(errors);
			err_th = errors_sorted(9);
		end

		% assign 0/nonzero weights
		w = w_in;
		w(errors > max(err_th, err_max_th)) = 0;
		W = diag([w; w]);

		% stopping criterion
		if(err_th >= err_max)
			break;
		else
			err_max = err_th;
		end

	end % while

	return;
end
