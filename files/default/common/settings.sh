SGE_ROOT=/usr/share/gridengine; export SGE_ROOT

ARCH=`$SGE_ROOT/util/arch`

SGE_CELL=default; export SGE_CELL
SGE_CLUSTER_NAME=mygrid; export SGE_CLUSTER_NAME
unset SGE_QMASTER_PORT
unset SGE_EXECD_PORT

PATH=$SGE_ROOT/bin/$ARCH:$PATH; export PATH
unset ARCH
