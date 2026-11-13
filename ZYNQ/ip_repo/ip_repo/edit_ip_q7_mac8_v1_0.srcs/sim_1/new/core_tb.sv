`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Testbench SIMPLE du core :
//
// Cas : n_beats = 2 (donc N = 16 entrees), m_rows = 2 (donc 2 neurones).
//
//   Activations (octets, poids faible en premier) :
//     beat 0 : a0..a7  = 1 2 3 4 5 6 7 8        -> act[63:0]   = 64'h0807060504030201
//     beat 1 : a8..a15 = 1 1 1 1 1 1 1 1        -> act[127:64] = 64'h0101010101010101
//
//   Poids :
//     neurone 0 : beat 0 = 1 1 1 1 1 1 1 1   et  beat 1 = 1 1 1 1 1 1 1 1
//     neurone 1 : beat 0 = 2 2 2 2 2 2 2 2   et  beat 1 = -1 -1 -1 -1 -1 -1 -1 -1
//
//   Resultats attendus (calcul a la main) :
//     neurone 0 : dot = (1+2+...+8)*1 + 8*1*1       = 36 + 8  = 44   sw = 8 + 8   = 16
//     neurone 1 : dot = (1+2+...+8)*2 + 8*1*(-1)    = 72 - 8  = 64   sw = 16 - 8  = 8
//     resultat 64 bits = {sw, dot}
//
// Pour comprendre : lance la simulation, lis le tableau affiche dans la console
// (une ligne par front d'horloge) et regarde le chronogramme.
//////////////////////////////////////////////////////////////////////////////////
module tb_core_simple;

    // ---------------- signaux, tous a 0 au depart ----------------
    logic                clk      = 1'b0;
    logic                rstb     = 1'b0;      // reset actif : le core est fige
    logic                start    = 1'b0;
    logic [15:0]         n_beats  = 16'd0;
    logic [15:0]         m_rows   = 16'd0;
    logic [196*32-1:0]   act      = '0;        // les 196 registres d'activations
    logic [63:0]         s_tdata  = 64'd0;     // flux d'entree : 8 poids par beat
    logic                s_tvalid = 1'b0;
    logic                s_tlast  = 1'b0;
    logic                s_tready;             // sortie du core
    logic [63:0]         m_tdata;              // flux de sortie : {sw, dot}
    logic                m_tvalid;
    logic                m_tlast;
    logic                m_tready = 1'b0;      // le "DMA" de sortie n'est PAS pret au depart
    logic                busy, done;

    always #5 clk = ~clk;                      // periode 10 ns (100 MHz)

    core dut (
        .clk_i             (clk),
        .rstb_i            (rstb),
        .start_i           (start),
        .n_beats_i         (n_beats),
        .m_rows_i          (m_rows),
        .activation_data_i (act),
        .s_tdata_i         (s_tdata),
        .s_tvalid_i        (s_tvalid),
        .s_tlast_i         (s_tlast),
        .m_tready_i        (m_tready),
        .m_tdata_o         (m_tdata),
        .m_tvalid_o        (m_tvalid),
        .m_tlast_o         (m_tlast),
        .s_tready_o        (s_tready),
        .busy_o            (busy),
        .done_o            (done)
    );

    // ------------------------------------------------------------------
    // Affichage : une ligne par front montant d'horloge.
    // Les valeurs affichees sont celles que le core VOIT au front (avant qu'il
    // ne les mette a jour).
    // ------------------------------------------------------------------
    always @(posedge clk)
        $display("%4d ns | %-4s | start=%b | s_tvalid=%b s_tready=%b | beat_cnt=%0d row_cnt=%0d | acc_dot=%3d acc_sw=%3d | res_valid=%b | m_tvalid=%b m_tready=%b | busy=%b done=%b",
                 $time, dut.state_c.name(), start, s_tvalid, s_tready,
                 dut.beat_cnt, dut.row_cnt, dut.acc_dot, dut.acc_sw,
                 dut.res_valid, m_tvalid, m_tready, busy, done);

    // ------------------------------------------------------------------
    // Le "DMA" de sortie : il note chaque resultat qu'il PREND (m_tvalid et
    // m_tready a 1 au meme front).
    // ------------------------------------------------------------------
    logic [63:0] res [0:1];
    int          n_res = 0;
    always @(posedge clk)
        if (m_tvalid && m_tready) begin
            res[n_res] = m_tdata;
            $display("         >>> resultat %0d pris par le DMA : sw=%0d dot=%0d  (m_tlast=%b)",
                     n_res, $signed(m_tdata[63:32]), $signed(m_tdata[31:0]), m_tlast);
            n_res = n_res + 1;
        end

    // Le DMA de sortie se fait attendre : il devient pret 4 cycles APRES que le
    // premier resultat soit disponible. Pendant ce temps le core doit bloquer
    // l'entree (s_tready = 0).
    initial begin
        wait (m_tvalid);
        repeat (4) @(posedge clk);
        #1 m_tready = 1'b1;
    end

    initial begin
        // 1) Reset : on le maintient 3 cycles, puis on le relache
        repeat (3) @(posedge clk);
        #1 rstb = 1'b1;

        // 2) Configuration, comme le CPU le ferait avant de lancer le calcul
        @(posedge clk); #1;
        n_beats = 16'd2;
        m_rows  = 16'd2;
        act[63:0]   = 64'h0807060504030201;     // beat 0 des activations = données d'activations traitées lors du premier transfert DMA
        act[127:64] = 64'h0101010101010101;     // beat 1 des activations = """" deuxième transfert DMA

        // 3) start passe a 1 : le core detecte le FRONT MONTANT et passe en RUN
        @(posedge clk); #1;
        start = 1'b1;
        repeat (2) @(posedge clk);              // on laisse le core passer en RUN
        #1;

        // 4) Neurone 0, beat 0 : poids = 1 partout
        s_tdata  = 64'h0101010101010101;
        s_tvalid = 1'b1;                        // "j'ai une donnee valide"
        @(posedge clk);                         // front : transfert si s_tready = 1
        while (!s_tready) @(posedge clk);       // sinon on attend qu'il le soit
        #1;

        // 5) Neurone 0, beat 1 : poids = 1 partout. C'est le DERNIER beat de la ligne :
        //    le core va ranger le resultat dans res_* et mettre res_valid a 1.
        s_tdata  = 64'h0101010101010101;
        @(posedge clk);
        while (!s_tready) @(posedge clk);
        #1;

        // 6) Neurone 1, beat 0 : poids = 2 partout. On presente la donnee tout de suite,
        //    mais le resultat du neurone 0 n'est pas encore pris (m_tready = 0) :
        //    le core refuse (s_tready = 0) et le beat reste en attente.
        s_tdata  = 64'h0202020202020202;
        @(posedge clk);
        while (!s_tready) @(posedge clk);        // <- plusieurs cycles d'attente ici
        #1;

        // 7) Neurone 1, beat 1 : poids = -1 partout (0xFF en complement a 2)
        s_tdata  = 64'hFFFFFFFFFFFFFFFF;
        s_tlast  = 1'b1;                        // dernier beat de tout le transfert
        @(posedge clk);
        while (!s_tready) @(posedge clk);
        #1;

        // 8) Plus de donnees a envoyer
        s_tvalid = 1'b0;
        s_tlast  = 1'b0;

        // 9) On attend que le core ait fini (done = 1), puis quelques cycles de plus
        wait (done);
        repeat (3) @(posedge clk);
        #1;

        // 10) Verification contre les valeurs calculees a la main
        $display("");
        if (n_res == 2 && res[0] === 64'h0000_0010_0000_002C
                       && res[1] === 64'h0000_0008_0000_0040)
            $display("PASS : neurone 0 -> {sw=16, dot=44}, neurone 1 -> {sw=8, dot=64}");
        else
            $display("FAIL : %0d resultat(s), res0=%h (attendu 000000100000002c), res1=%h (attendu 0000000800000040)",
                     n_res, res[0], res[1]);
        $finish;
    end

    // garde-fou
    initial begin
        #5000;
        $display("FAIL : timeout");
        $finish;
    end

endmodule
