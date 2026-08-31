module step_phase(
    input  wire clk,
    input  wire rst_n,
    input  wire step_btn,
    output wire pos_ce,
    output wire neg_ce
);
    reg [1:0] sync_ff;
    reg       btn_d;
    reg       phase;

    wire step_pulse = sync_ff[1] & ~btn_d;

    assign pos_ce = (~phase) & step_pulse;
    assign neg_ce = phase;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sync_ff <= 2'b0;
            btn_d   <= 1'b0;
            phase   <= 1'b0;
        end else begin
            sync_ff <= {sync_ff[0], step_btn};
            btn_d   <= sync_ff[1];

            if (!phase) begin
                if (step_pulse)
                    phase <= 1'b1;
            end else begin
                phase <= 1'b0;
            end
        end
    end
endmodule
