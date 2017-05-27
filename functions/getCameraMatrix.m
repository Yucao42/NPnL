function [ C ] = getCameraMatrix( varargin )
%GETCAMERAMATRIX Returns a 3x3 camera matrix based on input parameters.

	% process parameters
	switch nargin
		case 3
			aspectR   = 1.0;
			skewAngle = 0.0;
		case 4
			aspectR   = varargin{4};
			skewAngle = 0.0;
		case 5
			aspectR   = varargin{4};
			skewAngle = varargin{5};
		otherwise
			error('getCameraMatrix expects 3 - 5 input parameters, %d given.', nargin);
	end
	
	focalL     = varargin{1};
	principalX = varargin{2};
	principalY = varargin{3};

	% build the matrix
	skewFact   = aspectR * focalL * tan(skewAngle);

	C = [ ...
		focalL    skewFact     principalX; ...
			0    aspectR*focalL  principalY; ...
			0          0             1       ...	     
	];

end

