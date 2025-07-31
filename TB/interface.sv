interface dut_if (input clk, input rst_n);
    logic [`DATA_WIDTH-1:0] data;
    logic [`DATA_WIDTH-1:0] q;
    logic [`ADDR_WIDTH-1:0] addr = 0;
    logic we = 0;
    logic valid = 0;
    logic ready;
endinterface