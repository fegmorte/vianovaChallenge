#!/bin/sh
echo "Executing create_pkg.sh..."
cd ${path_cwd}
dir_func_name=lambda_dist_pkg/
mkdir $dir_func_name
cp -r $path_cwd/lambda_function/ $path_cwd/$dir_func_name