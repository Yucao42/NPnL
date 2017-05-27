function [ plucker_lines ] = pluckerLines( line_3D_end_pts )
%PLUCKERLINES Plücker coordinates of 3D lines from its endpoints.
%   INPUT:
%     line_3D_end_pts - 4x(2N) matrix of 3D line start- and end-points in
%                       homogeneous coordinates [x; y; z; w]
%   OUTPUT:
%      plucker_lines - 6xN matrix of Plücker coordinates of 3D lines

	%% Input checks
	if (rem(size(line_3D_end_pts,2), 2))
		error('Number of 3D line endpoints has to be an even number.');
	end
	
	if (size(line_3D_end_pts,1) ~= 4)
		error('3D line endpoints have to be homogeneous coordinates - 4-tuples [x; y; z; w].');
	end
	
	%% Method
	pts_start = line_3D_end_pts(:, 1:2:end);
	pts_end   = line_3D_end_pts(:, 2:2:end);
	
	pluck_mat_part1 = repmat(pts_start(:), 1, 4) .* kron(pts_end'  , ones(4, 1));
	pluck_mat_part2 = repmat(pts_end(:)  , 1, 4) .* kron(pts_start', ones(4, 1));
	
	plucker_matrices = pluck_mat_part1 - pluck_mat_part2;
	
	us = [plucker_matrices(2:4:end, 3) plucker_matrices(3:4:end, 1) plucker_matrices(1:4:end, 2)]';
	vs = [plucker_matrices(4:4:end, 1) plucker_matrices(4:4:end, 2) plucker_matrices(4:4:end, 3)]';
	
	plucker_lines = [us; vs];
	return;
end

