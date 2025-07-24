class transaction;
    rand bit [`MEMORY_WIDTH-1:0] data;
    rand bit[`MEMORY_WIDTH-1:0] q;
    rand bit [$clog2(`MEMORY_SIZE)-1:0] addr;
    rand bit we; 
    
    bit clk;      
    bit rst_n;      
    bit valid;  
    bit ready;  
    
    virtual function void copy(transaction t);
        this.data = t.data;
        this.q = t.q;
        this.addr = t.addr;
        this.we = t.we;
        this.clk = t.clk;
        this.rst_n = t.rst_n;
        this.valid = t.valid;
        this.ready = t.ready;
    endfunction;

    function void print(string tag = "" , string description = "");
        $display("[%s] %s: data=%h,    addr=%h,    we=%b,    clk=%b,    rst_n=%b,    valid=%b,    ready=%b,    q=%h",
                 tag, description, data, addr, we, clk, rst_n, valid, ready, q);
    endfunction;

endclass : transaction