`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09.11.2026 14:12:49
// Design Name: 
// Module Name: core
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module core #(
    // Parameters of Axi Slave Bus Interface S_ACTIVATION_AXI
    parameter integer C_S_ACTIVATION_AXI_DATA_WIDTH	= 32,

    // Parameters of Axi Slave Bus Interface IN_DMA_AXI
    parameter integer C_IN_DMA_AXI_TDATA_WIDTH	= 64,

    // Parameters of Axi Master Bus Interface OUT_AXI
    parameter integer C_OUT_AXI_TDATA_WIDTH	= 64
)(
    input logic clk_i,
    input logic rstb_i,
    input logic start_i,
    input logic[15:0] n_beats_i,
    input logic[15:0] m_rows_i,
    input logic[C_S_ACTIVATION_AXI_DATA_WIDTH*196-1:0] activation_data_i,
    input logic[C_IN_DMA_AXI_TDATA_WIDTH-1:0] s_tdata_i,
    input logic s_tvalid_i,
    input logic s_tlast_i,
    input logic m_tready_i,
    output logic[C_OUT_AXI_TDATA_WIDTH-1:0] m_tdata_o,
    output logic m_tvalid_o,
    output logic m_tlast_o,
    output logic s_tready_o,
    output logic busy_o,
    output logic done_o
    );
    
    typedef enum{
        IDLE,
        RUN,
        DONE
    }state_t;
    
    genvar i;
    for(i=0; i<8;i++) begin
        
    end
    
    
    
endmodule
