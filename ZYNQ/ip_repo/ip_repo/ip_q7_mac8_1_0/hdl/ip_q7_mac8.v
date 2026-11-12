
`timescale 1 ns / 1 ps

	module ip_q7_mac8 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S_ACTIVATION_AXI
		parameter integer C_S_ACTIVATION_AXI_DATA_WIDTH	= 32,
		parameter integer C_S_ACTIVATION_AXI_ADDR_WIDTH	= 10,

		// Parameters of Axi Slave Bus Interface IN_DMA_AXI
		parameter integer C_IN_DMA_AXI_TDATA_WIDTH	= 64,

		// Parameters of Axi Master Bus Interface OUT_AXI
		parameter integer C_OUT_AXI_TDATA_WIDTH	= 64,
		parameter integer C_OUT_AXI_START_COUNT	= 64
	)
	(
		// Users to add ports here
		

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S_ACTIVATION_AXI
		input wire  s_activation_axi_aclk,
		input wire  s_activation_axi_aresetn,
		input wire [C_S_ACTIVATION_AXI_ADDR_WIDTH-1 : 0] s_activation_axi_awaddr,
		input wire [2 : 0] s_activation_axi_awprot,
		input wire  s_activation_axi_awvalid,
		output wire  s_activation_axi_awready,
		input wire [C_S_ACTIVATION_AXI_DATA_WIDTH-1 : 0] s_activation_axi_wdata,
		input wire [(C_S_ACTIVATION_AXI_DATA_WIDTH/8)-1 : 0] s_activation_axi_wstrb,
		input wire  s_activation_axi_wvalid,
		output wire  s_activation_axi_wready,
		output wire [1 : 0] s_activation_axi_bresp,
		output wire  s_activation_axi_bvalid,
		input wire  s_activation_axi_bready,
		input wire [C_S_ACTIVATION_AXI_ADDR_WIDTH-1 : 0] s_activation_axi_araddr,
		input wire [2 : 0] s_activation_axi_arprot,
		input wire  s_activation_axi_arvalid,
		output wire  s_activation_axi_arready,
		output wire [C_S_ACTIVATION_AXI_DATA_WIDTH-1 : 0] s_activation_axi_rdata,
		output wire [1 : 0] s_activation_axi_rresp,
		output wire  s_activation_axi_rvalid,
		input wire  s_activation_axi_rready,

		// Ports of Axi Slave Bus Interface IN_DMA_AXI
		input wire  in_dma_axi_aclk,
		input wire  in_dma_axi_aresetn,
		output wire  in_dma_axi_tready,
		input wire [C_IN_DMA_AXI_TDATA_WIDTH-1 : 0] in_dma_axi_tdata,
		input wire [(C_IN_DMA_AXI_TDATA_WIDTH/8)-1 : 0] in_dma_axi_tstrb,
		input wire  in_dma_axi_tlast,
		input wire  in_dma_axi_tvalid,

		// Ports of Axi Master Bus Interface OUT_AXI
		input wire  out_axi_aclk,
		input wire  out_axi_aresetn,
		output wire  out_axi_tvalid,
		output wire [C_OUT_AXI_TDATA_WIDTH-1 : 0] out_axi_tdata,
		output wire [(C_OUT_AXI_TDATA_WIDTH/8)-1 : 0] out_axi_tstrb,
		output wire  out_axi_tlast,
		input wire  out_axi_tready
	);
	
	wire [196*32-1:0] act_flat;
    wire              start, busy, done;
    wire [15:0]       n_beats, m_rows;
    
// Instantiation of Axi Bus Interface S_ACTIVATION_AXI
	ip_q7_mac8_slave_lite_v1_0_S_ACTIVATION_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S_ACTIVATION_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S_ACTIVATION_AXI_ADDR_WIDTH)
	) ip_q7_mac8_slave_lite_v1_0_S_ACTIVATION_AXI_inst (
		.S_AXI_ACLK(s_activation_axi_aclk),
		.S_AXI_ARESETN(s_activation_axi_aresetn),
		.S_AXI_AWADDR(s_activation_axi_awaddr),
		.S_AXI_AWPROT(s_activation_axi_awprot),
		.S_AXI_AWVALID(s_activation_axi_awvalid),
		.S_AXI_AWREADY(s_activation_axi_awready),
		.S_AXI_WDATA(s_activation_axi_wdata),
		.S_AXI_WSTRB(s_activation_axi_wstrb),
		.S_AXI_WVALID(s_activation_axi_wvalid),
		.S_AXI_WREADY(s_activation_axi_wready),
		.S_AXI_BRESP(s_activation_axi_bresp),
		.S_AXI_BVALID(s_activation_axi_bvalid),
		.S_AXI_BREADY(s_activation_axi_bready),
		.S_AXI_ARADDR(s_activation_axi_araddr),
		.S_AXI_ARPROT(s_activation_axi_arprot),
		.S_AXI_ARVALID(s_activation_axi_arvalid),
		.S_AXI_ARREADY(s_activation_axi_arready),
		.S_AXI_RDATA(s_activation_axi_rdata),
		.S_AXI_RRESP(s_activation_axi_rresp),
		.S_AXI_RVALID(s_activation_axi_rvalid),
		.S_AXI_RREADY(s_activation_axi_rready),
		.act_flat(act_flat),
		.start(start),
		.n_beats(n_beats),
		.m_rows(m_rows),
        .busy_in(busy),
        .done_in(done)
	);
/*
// Instantiation of Axi Bus Interface IN_DMA_AXI
	ip_q7_mac8_slave_stream_v1_0_IN_DMA_AXI # ( 
		.C_S_AXIS_TDATA_WIDTH(C_IN_DMA_AXI_TDATA_WIDTH)
	) ip_q7_mac8_slave_stream_v1_0_IN_DMA_AXI_inst (
		.S_AXIS_ACLK(in_dma_axi_aclk),
		.S_AXIS_ARESETN(in_dma_axi_aresetn),
		.S_AXIS_TREADY(in_dma_axi_tready),
		.S_AXIS_TDATA(in_dma_axi_tdata),
		.S_AXIS_TSTRB(in_dma_axi_tstrb),
		.S_AXIS_TLAST(in_dma_axi_tlast),
		.S_AXIS_TVALID(in_dma_axi_tvalid)
	);

// Instantiation of Axi Bus Interface OUT_AXI
	ip_q7_mac8_master_stream_v1_0_OUT_AXI # ( 
		.C_M_AXIS_TDATA_WIDTH(C_OUT_AXI_TDATA_WIDTH),
		.C_M_START_COUNT(C_OUT_AXI_START_COUNT)
	) ip_q7_mac8_master_stream_v1_0_OUT_AXI_inst (
		.M_AXIS_ACLK(out_axi_aclk),
		.M_AXIS_ARESETN(out_axi_aresetn),
		.M_AXIS_TVALID(out_axi_tvalid),
		.M_AXIS_TDATA(out_axi_tdata),
		.M_AXIS_TSTRB(out_axi_tstrb),
		.M_AXIS_TLAST(out_axi_tlast),
		.M_AXIS_TREADY(out_axi_tready)
	);
*/
	// Add user logic here

    core core_inst (
        .clk_i             (s_activation_axi_aclk),
        .rstb_i            (s_activation_axi_aresetn),
        .start_i           (start),
        .n_beats_i         (n_beats),
        .m_rows_i          (m_rows),
        .activation_data_i (act_flat),
        .s_tdata_i         (in_dma_axi_tdata),
        .s_tvalid_i        (in_dma_axi_tvalid),
        .s_tlast_i         (in_dma_axi_tlast),
        .s_tready_o        (in_dma_axi_tready),
        .m_tdata_o         (out_axi_tdata),
        .m_tvalid_o        (out_axi_tvalid),
        .m_tlast_o         (out_axi_tlast),
        .m_tready_i        (out_axi_tready),
        .busy_o            (busy),
        .done_o            (done)
    );
    
    assign out_axi_tstrb = {(C_OUT_AXI_TDATA_WIDTH/8){1'b1}};

	// User logic ends

	endmodule
