`timescale 1ns / 1ps

module tb_Data_RAM;

    reg         clk;
    reg         op_en;
    reg         Mem_Write;
    reg  [7:0]  DM_Addr;
    reg  [31:0] M_W_Data;
    wire [31:0] M_R_Data;

    Data_RAM uut (
        .clk       (clk),
        .op_en     (op_en),
        .Mem_Write (Mem_Write),
        .DM_Addr   (DM_Addr),
        .M_W_Data  (M_W_Data),
        .M_R_Data  (M_R_Data)
    );

    initial clk = 1'b0;
    always #5 clk = ~clk;  // 100MHz

    task do_read;
        input [7:0] addr;
        begin
            @(negedge clk);
            DM_Addr   = addr;
            M_W_Data  = 32'h0000_0000;
            Mem_Write = 1'b0;
            op_en     = 1'b1;
            @(negedge clk);
            op_en     = 1'b0;
            repeat (2) @(posedge clk);
            #1;
            $display("READ  byte_addr=0x%02h word_addr=%0d data=0x%08h", addr, addr[7:2], M_R_Data);
        end
    endtask

    task do_write;
        input [7:0]  addr;
        input [31:0] data;
        begin
            @(negedge clk);
            DM_Addr   = addr;
            M_W_Data  = data;
            Mem_Write = 1'b1;
            op_en     = 1'b1;
            @(negedge clk);
            op_en     = 1'b0;
            Mem_Write = 1'b0;
            repeat (2) @(posedge clk);
            #1;
            $display("WRITE byte_addr=0x%02h word_addr=%0d data=0x%08h", addr, addr[7:2], data);
        end
    endtask

    initial begin
        op_en     = 1'b0;
        Mem_Write = 1'b0;
        DM_Addr   = 8'h00;
        M_W_Data  = 32'h0000_0000;

        #30;

        // 读 COE 初始化内容
        do_read(8'h00);   // mem[0]  = 00000820
        do_read(8'h04);   // mem[1]  = 00632020
        do_read(8'h08);   // mem[2]  = 00010FFF
        do_read(8'h0C);   // mem[3]  = 20006789

        // 写入并读回
        do_write(8'h10, 32'hDEAD_BEEF); // byte 0x10 -> word 4
        do_read (8'h10);

        do_write(8'h1C, 32'h1234_5678); // byte 0x1C -> word 7
        do_read (8'h1C);

        $display("Simulation finished.");
        $stop;
    end

endmodule
