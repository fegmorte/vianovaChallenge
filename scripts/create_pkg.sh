#!/bin/bash
echo "Executing create_pkg.sh..."
cd $path_cwd

dir_name=lambda_dist_pkg/
mkdir $dir_name

cp -r $path_cwd/lambda_function/ $path_cwd/$dir_name
