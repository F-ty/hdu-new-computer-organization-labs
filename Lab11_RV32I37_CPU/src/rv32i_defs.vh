`ifndef RV32I_DEFS_VH
`define RV32I_DEFS_VH

// ALU operation codes
`define ALU_ADD   4'd0
`define ALU_SUB   4'd1
`define ALU_SLL   4'd2
`define ALU_SLT   4'd3
`define ALU_SLTU  4'd4
`define ALU_XOR   4'd5
`define ALU_SRL   4'd6
`define ALU_SRA   4'd7
`define ALU_OR    4'd8
`define ALU_AND   4'd9

// Controller states
`define ST_FETCH      5'd1
`define ST_DECODE     5'd2
`define ST_EXEC_ALU   5'd3
`define ST_WB_ALU     5'd4
`define ST_WB_LUI     5'd5
`define ST_WB_AUIPC   5'd6
`define ST_EXEC_ADDR  5'd7
`define ST_MEM_RD     5'd8
`define ST_WB_LOAD    5'd9
`define ST_MEM_WR     5'd10
`define ST_JAL        5'd11
`define ST_JALR       5'd12
`define ST_BRANCH     5'd13

// Register write data selection
`define WDATA_ALUOUT  3'd0
`define WDATA_IMMU    3'd1
`define WDATA_MDR     3'd2
`define WDATA_PC      3'd3
`define WDATA_AUIPC   3'd4

// PC source selection
`define PC_PLUS4      2'd0
`define PC_RELATIVE   2'd1
`define PC_ALUOUT     2'd2

`endif
