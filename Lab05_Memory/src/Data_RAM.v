// 实验5：64 x 32 位数据存储器封装模块
// Vivado 中请先生成名为 RAM_B 的 Block Memory Generator IP：
// Single Port RAM, Write Width=32, Write Depth=64, Enable Port Type=Always Enabled,
// 不勾选 Primitives Output Register，Load Init File 选择 ram_init.coe。

module Data_RAM (
    input  wire        clk,        // HCS-A02 板载 100MHz 时钟，E3
    input  wire        op_en,      // 操作脉冲：1 个 clk 周期，高电平有效
    input  wire        Mem_Write,  // 0：读；1：写
    input  wire [7:0]  DM_Addr,    // 字节地址；RAM 实际使用 DM_Addr[7:2] 作为 6 位字地址
    input  wire [31:0] M_W_Data,   // 写入数据
    output wire [31:0] M_R_Data    // 读出数据
);

    // 为了避免用按键直接当 RAM 时钟，这里用 100MHz 作为真正时钟，
    // op_en 只作为“按一次执行一次读/写”的操作使能。
    reg [7:0]  addr_hold = 8'h00;
    reg [31:0] data_hold = 32'h0000_0000;

    wire [5:0]  ram_addr = op_en ? DM_Addr[7:2] : addr_hold[7:2];
    wire [31:0] ram_din  = op_en ? M_W_Data     : data_hold;
    wire [0:0]  ram_we   = {op_en & Mem_Write};

    always @(posedge clk) begin
        if (op_en) begin
            addr_hold <= DM_Addr;
            data_hold <= M_W_Data;
        end
    end

    RAM_B u_ram_b (
        .clka  (clk),       // input clka
        .wea   (ram_we),    // input [0:0] wea
        .addra (ram_addr),  // input [5:0] addra
        .dina  (ram_din),   // input [31:0] dina
        .douta (M_R_Data)   // output [31:0] douta
    );

endmodule
