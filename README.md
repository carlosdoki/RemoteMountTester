# RemoteMountTester
This is a simple ksh script for testing network mount points. This will test if it is possible to creat a file on the target directory and also measure how long it takes for writing. Also it will report back if deletion of the file failed. 

## How to use this script

1. Download the release package and unzip it under <machine-agent-home>/monitors.
2. Change the contents of the file directories.conf. One mount point per line. Script will treat names with spaces properly.

## Features

1. Script will create a 12 MB text file on the target directories
2. It will measure: time for creating file, if creation was successful and if the deletion of the created file was successful
3. It will create 3 metrics for each of the monitored mount points