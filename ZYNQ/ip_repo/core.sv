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
    
    typedef enum logic[1:0]{
        IDLE,
        RUN,
        DONE
    }state_t;
    
    logic start_q;
    logic[15:0] beat_cnt;
    logic[15:0] row_cnt;
    logic signed [31:0] acc_dot;
    logic signed [31:0] acc_sw;
    logic signed [31:0] res_dot, res_sw;
    logic res_valid, res_last;
    
    state_t state_c, state_n;
    
    wire start_rise = start_i & ~start_q;
    wire accept     = s_tvalid_i && s_tready_o;      // un poids est transféré ce cycle
    wire last_beat  = (beat_cnt == n_beats_i - 1);   // dernier beat de la ligne
    wire take       = res_valid && m_tready_i;       // le DMA prend le résultat
    
    logic signed [7:0]  a_lane [8];
    logic signed [7:0]  w_lane [8];
    logic signed [15:0] prod   [8];
    logic signed [31:0] beat_dot, beat_sw;
    
    wire [63:0] act_beat = activation_data_i[64*beat_cnt +: 64];
    
    // logique de transition de la FSM
    always_ff @(posedge clk_i, negedge rstb_i) begin
        if(rstb_i == 1'b0) begin
            state_c <= IDLE;
        end
        else begin
            state_c <= state_n;
        end
    end
    
    // logique combinatoire de la FSM
    
    always_comb begin
        case(state_c)
            IDLE: begin
                if(start_i & ~start_q) state_n = RUN;
                else state_n = IDLE;
            end
            RUN: begin
                if(res_valid && res_last && m_tready_i) state_n = DONE;
                else state_n = RUN;
            end
            DONE: begin
                if(start_i & ~start_q) state_n = RUN;
                else state_n = DONE;
            end
            default: state_n = IDLE;
        endcase
    end
    
    // logique de données
    always_ff @(posedge clk_i, negedge rstb_i) begin
        if (!rstb_i) begin
            //tous les registres à 0
            start_q   <= 1'b0;
            beat_cnt  <= '0;
            row_cnt   <= '0;
            acc_dot   <= '0;
            acc_sw    <= '0;
            res_dot   <= '0;
            res_sw    <= '0;
            res_valid <= 1'b0;
            res_last  <= 1'b0;
        end else begin
            start_q <= start_i;
            if (start_rise && state_c != RUN) begin
                //initialisation de la couche
                beat_cnt <= '0;
                row_cnt <= '0;
                acc_dot <= '0;
                acc_sw <= '0;
                res_valid <= '0;
            end else begin
                if (accept) begin
                    if (last_beat) begin
                        // fin de ligne
                        res_dot <= acc_dot + beat_dot;
                        res_sw <= acc_sw + beat_sw;
                        res_valid <= '1;
                        res_last <= (row_cnt == m_rows_i - 1);
                        beat_cnt <= '0;
                        acc_dot <= '0;
                        acc_sw  <= '0;
                        row_cnt <= row_cnt + 1;
                        
                    end else begin
                        // beat normal
                        acc_dot  <= acc_dot + beat_dot;
                        acc_sw   <= acc_sw + beat_sw;
                        beat_cnt <= beat_cnt + 1;
                    end
                end
                if (take) res_valid <= 1'b0;
            end
        end
    end
    
    assign busy_o     = (state_c == RUN);
    assign done_o     = (state_c == DONE);
    assign s_tready_o = (state_c == RUN) && !res_valid;
    assign m_tvalid_o = res_valid;
    assign m_tlast_o  = res_last;
    assign m_tdata_o  = {res_sw, res_dot};
    
   
    
    genvar i;
    for(i=0; i<8;i++) begin
        assign a_lane[i] = act_beat[8*i +: 8];
        assign w_lane[i] = s_tdata_i[8*i +: 8];
        assign prod[i]   = a_lane[i] * w_lane[i];
    end
    
    always_comb begin
        beat_dot = '0;
        beat_sw  = '0;
        for (int k = 0; k < 8; k++) begin
            beat_dot += 32'(prod[k]);
            beat_sw  += 32'(w_lane[k]);
        end
    end
    
    
    
endmodule
