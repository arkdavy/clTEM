#!/bin/bash

# install easybuild (EB)
pip install easybuild --user

# init the module tool (also add this line into ~/.bashrc)
# It could be that there are other ways to allow for the 'module' command be available via a different root,
# one has to double-check it when working with particular distribution. I do it this way on my ubuntu laptop
# if the 'module' comand is already available, ignore this line
source /etc/profile.d/lmod8.4.sh

# create the directory where the modules are to be installed
mkdir -p ${HOME}/easybuild/local_installpath/modules/Core
# dirctory where EB sources will endup
mkdir -p ${HOME}/easybuild/ebsrcs
# directory where EB logfiles are stored 
mkdir -p ${HOME}/easybuild/eblogs/log
# directory where EB temp files are stored 
mkdir -p ${HOME}/easybuild/eblogs/tmp

# create EB config directory
mkdir -p ~/.config/easybuild/

# add the EB config (change "/home/adavydov" to your ${HOME} value) (having no spaces after "=" is important)
cat <<EOT >> ~/.config/easybuild/config.cfg
[MAIN]

[basic]

[config]
module-naming-scheme =HierarchicalMNS
sourcepath           =/home/adavydov/easybuild/ebsrcs
suffix-modules-path  =
tmp-logdir           =/home/adavydov/easybuild/eblogs/log
tmpdir               =/home/adavydov/easybuild/eblogs/tmp
umask                =022

[override]
umask=022
EOT

# add EB modules location to the initial modulepath (also add this line to ~/.bashrc)
export MODULEPATH=${HOME}/easybuild/local_installpath/modules/Core:${MODULEPATH}

# easybuild installation settings, only needed for EB installs
export EASYBUILD_INSTALLPATH=${HOME}/easybuild/local_installpath
export EASYBUILD_REPOSITORYPATH=${EASYBUILD_INSTALLPATH}/ebfiles_repo
export EASYBUILD_BUILDPATH=${HOME}/easybuild/build

eb clTEM-0.3.4-fosscuda-2020b.eb --robot --robot-path=`pwd`:${EASYBUILD_ROBOT_PATHS} --rebuild --cuda-compute-capabilities='3.5,3.7,5.0,5.2,5.3,6.0,6.1,6.2,7.0,7.2,7.5,8.0,8.6' 

# if the installation successfully complete, and MODULEPATH is set as above, loading the module is achieved by
# module purge
# module load GCC/10.2.0  CUDA/11.1.1  OpenMPI/4.0.5
# module load clTEM/0.3.4



