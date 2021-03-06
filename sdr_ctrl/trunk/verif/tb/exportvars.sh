#!/bin/bash

export SNPSLMD_LICENSE_FILE=27000@172.21.9.209 
export SYNOPSYS_HOME=/mnt/vol_NFS_Zener/tools/synopsys/apps/ 
export VCS_HOME=/mnt/vol_NFS_Zener/tools/synopsys/apps/vcs-mx2/M-2017.03 
export PATH=$PATH:$VCS_HOME/linux64/bin 
export LOGNAME=alvargas

PROJECT_PATH=/mnt/vol_NFS_Zener/WD_ESPEC/alvargas/gcastro/Verificacion_proyecto1/sdr_ctrl/trunk
MYLIBPATH_CORE=$PROJECT_PATH/rtl/core
MYLIBPATH_LIB=$PROJECT_PATH/rtl/lib
MYLIBPATH_WB=$PROJECT_PATH/rtl/wb2sdrc
MYRTL_PATH=$PROJECT_PATH/rtl
MYTEST_PATH=$PROJECT_PATH/verif
MYTEST_PATH_MODEL=$PROJECT_PATH/verif/model


#vcs  -timescale=1ns/1ps $MYTEST_PATH_MODEL/mt48lc8m8a2.v $MYRTL_PATH/core/sdrc_bank_ctl.v $MYRTL_PATH/core/sdrc_bank_fsm.v $MYRTL_PATH/core/sdrc_bs_convert.v $MYRTL_PATH/core/sdrc_core.v $MYRTL_PATH/core/sdrc_define.v $MYRTL_PATH/core/sdrc_req_gen.v $MYRTL_PATH/core/sdrc_xfr_ctl.v $MYRTL_PATH/lib/async_fifo.v $MYRTL_PATH/lib/sync_fifo.v $MYRTL_PATH/wb2sdrc/wb2sdrc.v $MYRTL_PATH/top/sdrc_top.v $MYTEST_PATH/tb/tb_core.sv $MYTEST_PATH/tb/tb_top.sv +incdir+$MYLIBPATH_CORE -sverilog -full64 -gui -debug_access+all


vcs  -timescale=1ns/1ps -f ../run/filelist_Proyecto1.f -sverilog -full64 -debug_access+all

#vcs  -timescale=1ns/1ps -f ../run/filelist_top.f -sverilog -gui -full64 -debug_access+all
