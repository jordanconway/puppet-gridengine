setenv SGE_ROOT /usr/share/gridengine

set ARCH = `$SGE_ROOT/util/arch`

setenv SGE_CELL default
setenv SGE_CLUSTER_NAME mygrid
unsetenv SGE_QMASTER_PORT
unsetenv SGE_EXECD_PORT

set path = ( $SGE_ROOT/bin/$ARCH $path )
unset ARCH
