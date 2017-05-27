function [ T ] = getTransformationMatrix( rotX_rad, rotY_rad, rotZ_rad, shiftX, shiftY, shiftZ )
%GETTRANSFORMATIONMATRIX Returns a 3x4 transformation matrix based on input
% rotation angles and shift distances.

	Rm = getRotationMatrix(rotX_rad, rotY_rad, rotZ_rad);
	tv = getTranslationVector(shiftX, shiftY, shiftZ);

	T = Rm * [eye(3) tv];

end

