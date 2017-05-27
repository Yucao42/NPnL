================================================================================
           Camera Pose Estimation from Line Correspondences
================================================================================
Author: Bronislav Přibyl, ipribyl@fit.vutbr.cz

Date of last modification: 2016-01-14

Description:
This is a Matlab implementation of an algorithm for camera pose estimation.
The input is the intrinsic camera parameters (i.e. the camera has to be
geometrically calibrated), the 3D lines seen by the camera and the corresponding
2D lines in the normalized image plane. Thanks to the parametrization of 3D
lines using Plücker coordinates, their projection into a plane is a linear
operation and a line projection matrix can be thus estimated using Linear Least
Squares method. The camera pose parameters are then extracted from the line
projection matrix. The output of the algorithm are the extrinsic camera
parameters - camera position and orientation with respect to the world
coordinate system. An algebraic approach to handle mismatched line
correspondences is also included.


The proposed method is implemented in functions:
* linePoseEstim.m - basic version for outlier-free cases
* linePoseEstimAOR.m - version with Algebraic Outlier Rejection for cases with
                       outliers

To see how to call it the functions, please see the scripts test_simple9.m and
test_AOR.m.

* test_simple9.m
  - The method is run on predefined 9 lines.

* test_random.m
  - The method is run on N randomly generated lines.

* test_VGG.m
  - The method can be run on real-world image sequences from the VGG multiview dataset.
  - Please uncomment the dataset of your choice at the beginning of the script.
  - As a result, you will see images with reprojected 3D lines using both ground-truth and estimated camera pose.
  
* test_AOR.m
  - The method is run on N randomly generated perturbed with slight image noise.
    M out of N lines are outliers which are perturbed with strong image noise.


Other details can be found in our paper 

PŘIBYL Bronislav, ZEMČÍK Pavel and ČADÍK Martin. Camera Pose Estimation from
Lines using Plücker Coordinates. In: British Machine Vision Conference 2015.
Swansea, 2015. URL http://www.fit.vutbr.cz/~ipribyl/pubs.php.en?id=10659.

If you use this code in an academic work, you can cite our paper as folows:

@INPROCEEDINGS{
   author = {Bronislav P{\v{r}}ibyl and Pavel Zem{\v{c}}{\'{i}}k and
	Martin {\v{C}}ad{\'{i}}k},
   title = {Camera Pose Estimation from Lines using Pl{\"{u}}cker
	Coordinates},
   pages = {UKNOWN AT THE MOMENT},
   booktitle = {British Machine Vision Conference 2015},
   year = {2015},
   location = {Swansea, GB},
   ISBN = {UKNOWN AT THE MOMENT},
   language = {english},
   url = {http://www.fit.vutbr.cz/research/view_pub.php.en?id=10659}
}

