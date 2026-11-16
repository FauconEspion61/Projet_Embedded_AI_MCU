

proc generate {drv_handle} {
	xdefine_include_file $drv_handle "xparameters.h" "ip_q7_mac8" "NUM_INSTANCES" "DEVICE_ID"  "C_S_ACTIVATION_AXI_BASEADDR" "C_S_ACTIVATION_AXI_HIGHADDR"
}
