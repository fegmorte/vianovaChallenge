#!/bin/bash
echo "Executing create_pkg.sh..."
cd ${path_cwd}
dir_alert_name=lambda_alert_dist_pkg/
mkdir $dir_alert_name
cp -r $path_cwd/lambda_alert/ $path_cwd/$dir_alert_name
