`timescale 1ns/1ps

module rv32i_dmem #(
    parameter MEM_FILE = "data.mem"
)(
    input  wire        clk,
    input  wire        rst_n,
    input  wire        ce,
    input  wire        we,
    input  wire [31:0] addr,
    input  wire [31:0] wdata,
    input  wire [1:0]  size,
    input  wire        load_unsigned,
    output reg  [31:0] rdata
);
    integer i;
    wire [7:0] a = addr[7:0];
    reg [7:0] mem [0:255];
    reg [7:0]  byte_value;
    reg [15:0] half_value;
    reg [31:0] word_value;

    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 8'h00;
        $readmemh(MEM_FILE, mem);
    end

    always @(*) begin
        byte_value = mem[a];
        half_value = {mem[a + 8'd1], mem[a]};
        word_value = {mem[a + 8'd3], mem[a + 8'd2], mem[a + 8'd1], mem[a]};

        case (size)
            2'b00: rdata = load_unsigned ? {24'b0, byte_value}
                                           : {{24{byte_value[7]}}, byte_value};
            2'b01: rdata = load_unsigned ? {16'b0, half_value}
                                           : {{16{half_value[15]}}, half_value};
            default: rdata = word_value;
        endcase
    end

    always @(posedge clk) begin
        if (rst_n && ce && we) begin
            case (size)
                2'b00: begin
                    mem[a] <= wdata[7:0];
                end
                2'b01: begin
                    mem[a]        <= wdata[7:0];
                    mem[a + 8'd1] <= wdata[15:8];
                end
                default: begin
                    mem[a]        <= wdata[7:0];
                    mem[a + 8'd1] <= wdata[15:8];
                    mem[a + 8'd2] <= wdata[23:16];
                    mem[a + 8'd3] <= wdata[31:24];
                end
            endcase
        end
    end
endmodule
