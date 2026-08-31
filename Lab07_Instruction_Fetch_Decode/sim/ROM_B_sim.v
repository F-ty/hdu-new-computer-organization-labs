module ROM_B(
    input  wire        clka,
    input  wire [5:0]  addra,
    output reg  [31:0] douta
);
    reg [31:0] mem [0:63];
    integer i;

    initial begin
        for (i = 0; i < 64; i = i + 1)
            mem[i] = 32'h00000013;
        $readmemh("exp7_test.mem", mem);
    end

    always @(posedge clka) begin
        douta <= mem[addra];
    end
endmodule