#!/bin/sh

# Allow this script to fail without failing a build
set +e

# Fix permissions on the given directory to allow group read/write of
# regular files and execute of directories.
chgrp -R 0 $1;
find -L $1 -xtype l -exec chgrp 0 {} \;
chmod -R g+rw $1;
find -L $1 -xtype l -exec chmod g+rw {} \;
find $1 -type d -exec chmod g+x {} +
