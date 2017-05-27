function [ reprojErr ] = reprojErr_lines( lines2D, line2DEndPts )
%REPROJERR_LINES Computes reprojection error of lines / line segments.
%   This function computes a reprojection error of line segments to lines,
%   based on: C.J.Taylor and D.J.Kriegman: "Structure and Motion from Line
%   Segments in Multiple Images".
%
%		The return value is a scalar (number) - a sum of individual
%		reprojection errors between the pairs lines2D(i) - line2DEndPts(j,j+1).

	if(size(lines2D, 1) ~= 3)
		error('reprojErr_lines:argin', 'The 1st input argument has to be of size 3xN.');
	end

	if((size(line2DEndPts, 1) ~= 3) || rem(size(line2DEndPts, 2), 2))
		error('reprojErr_lines:argin', 'The 2nd input argument has to be of size 3xN, where N is even.');
	end
	
	if((2 * size(lines2D, 2)) ~= size(line2DEndPts, 2))
		error('reprojErr_lines:argin', 'The 2nd argument has to contain twice as much elements as the 1st argument (endpoints of line segments).');
	end
	
	% normalize line2DEndPts to [x; y; 1]
	for i = 1:3
		line2DEndPts(i,:) = line2DEndPts(i,:) ./ line2DEndPts(3,:);
	end

	% compute the reprojection error
	reprojErr = 0;

	NLINES = size(lines2D, 2);
	for lineNr = 1:NLINES
		idx = 2*lineNr-1 : 2*lineNr;
		m = lines2D(:, lineNr);
		A = line2DEndPts(:, idx)';
		lineLen = sqrt((A(1,1) - A(2,1))^2 + (A(1,2) - A(2,2))^2);
		B = (lineLen / (3 * (m(1)^2 + m(2)^2))) * [1.0  0.5; 0.5  1.0];
		err = m' * (A' * B * A) * m;
		reprojErr = reprojErr + abs(err);
	end

end
