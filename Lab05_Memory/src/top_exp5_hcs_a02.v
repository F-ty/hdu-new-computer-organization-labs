module top_exp5_hcs_a02 (
    input  wire        clk_100m,  // 100MHz, E3
    input  wire        btn_op,    // BT0：按一次执行一次读/写
    input  wire        btn_rst,   // BT1：复位显示扫描和按键消抖，不恢复 RAM 初值
    input  wire [10:0] sw,        // SW[7:0]=地址，SW8=写使能，SW10:SW9=写入数据选择
    output wire [35:0] led,       // LD31~LD0 显示读出数据；LD35~LD32 显示状态
    output reg  [7:0]  an,        // AN7~AN0，低电平有效
    output wire [7:0]  seg        // CA~CG,DP，低电平有效
);

    wire op_pulse;

    btn_onepulse u_btn_onepulse (
        .clk    (clk_100m),
        .rst    (btn_rst),
        .btn_in (btn_op),
        .pulse  (op_pulse)
    );

    wire [7:0] DM_Addr   = sw[7:0];
    wire       Mem_Write = sw[8];
    wire [1:0] data_sel  = sw[10:9];

    reg [31:0] M_W_Data;
    always @(*) begin
        case (data_sel)
            2'b00: M_W_Data = 32'h1111_2222;
            2'b01: M_W_Data = 32'h3333_4444;
            2'b10: M_W_Data = 32'hAAAA_5555;
            2'b11: M_W_Data = 32'hDEAD_BEEF;
            default: M_W_Data = 32'h0000_0000;
        endcase
    end

    wire [31:0] M_R_Data;

    Data_RAM u_data_ram (
        .clk       (clk_100m),
        .op_en     (op_pulse),
        .Mem_Write (Mem_Write),
        .DM_Addr   (DM_Addr),
        .M_W_Data  (M_W_Data),
        .M_R_Data  (M_R_Data)
    );

    // LED：读出数据 + 操作状态
    assign led[31:0] = M_R_Data;
    assign led[32]   = op_pulse;
    assign led[33]   = Mem_Write;
    assign led[35:34]= data_sel;

    // 8 位数码管动态扫描，显示 M_R_Data 的 8 个十六进制数码
    reg [16:0] scan_div;
    wire [2:0] scan_sel = scan_div[16:14];
    reg [3:0]  hex_now;

    always @(posedge clk_100m) begin
        if (btn_rst)
            scan_div <= 17'd0;
        else
            scan_div <= scan_div + 1'b1;
    end

    always @(*) begin
        case (scan_sel)
            3'd0: begin an = 8'b1111_1110; hex_now = M_R_Data[3:0];   end // AN0/TB0，最低位
            3'd1: begin an = 8'b1111_1101; hex_now = M_R_Data[7:4];   end
            3'd2: begin an = 8'b1111_1011; hex_now = M_R_Data[11:8];  end
            3'd3: begin an = 8'b1111_0111; hex_now = M_R_Data[15:12]; end
            3'd4: begin an = 8'b1110_1111; hex_now = M_R_Data[19:16]; end
            3'd5: begin an = 8'b1101_1111; hex_now = M_R_Data[23:20]; end
            3'd6: begin an = 8'b1011_1111; hex_now = M_R_Data[27:24]; end
            3'd7: begin an = 8'b0111_1111; hex_now = M_R_Data[31:28]; end // AN7/TB7，最高位
            default: begin an = 8'b1111_1111; hex_now = 4'h0; end
        endcase
    end

    hex7seg_ca u_hex7seg_ca (
        .hex (hex_now),
        .seg (seg)
    );

endmodule
