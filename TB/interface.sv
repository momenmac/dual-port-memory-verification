interface dut_if (input clk, input rst_n);
    logic [`MEMORY_WIDTH-1:0] data;
    logic [`MEMORY_WIDTH-1:0] q;
    logic [$clog2(`MEMORY_SIZE)-1:0] addr;
    logic we;

    logic valid;
    logic ready;
endinterface