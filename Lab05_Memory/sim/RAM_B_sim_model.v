// 只用于没有生成 Vivado IP 时的仿真模型。
// 如果工程里已经有 Block Memory Generator 生成的 RAM_B IP，不要再加入本文件，避免模块重名。
module RAM_B (
    input  wire        clka,
    input  wire [0:0]  wea,
    input  wire [5:0]  addra,
    input  wire [31:0] dina,
    output reg  [31:0] douta
);
    reg [31:0] mem [0:63];
    integer i;

    initial begin
        mem[0]  = 32'h0000_0820;
        mem[1]  = 32'h0063_2020;
        mem[2]  = 32'h0001_0FFF;
        mem[3]  = 32'h2000_6789;
        mem[4]  = 32'hFFFF_0000;
        mem[5]  = 32'h0000_FFFF;
        mem[6]  = 32'h8888_8888;
        mem[7]  = 32'h9999_9999;
        mem[8]  = 32'hAAAA_AAAA;
        mem[9]  = 32'hBBBB_BBBB;
        mem[10] = 32'hCCCC_CCCC;
        mem[11] = 32'hDDDD_DDDD;
        mem[12] = 32'hEEEE_EEEE;
        mem[13] = 32'hFFFF_FFFF;
        mem[14] = 32'h1234_5678;
        mem[15] = 32'h8765_4321;
        for (i = 16; i < 64; i = i + 1)
            mem[i] = 32'h0000_0000;
        douta = 32'h0000_0000;
    end

    always @(posedge clka) begin
        if (wea[0])
            mem[addra] <= dina;
        douta <= mem[addra];  // Read First 行为：写周期输出旧值，下一次读可读到新值
    end
endmodule
