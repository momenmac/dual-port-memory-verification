class transaction;
    rand bit [`MEMORY_WIDTH-1:0] data;
    rand bit [$clog2(`MEMORY_SIZE)-1:0] addr;
    rand bit we;
    rand int delay; // Delay in clock cycles 
    
    virtual function void copy(transaction t);
        this.data = t.data;
        this.addr = t.addr;
        this.we = t.we;
        this.delay = t.delay;
    endfunction;

    function void print(string tag = "" , string description = "");
        $display("[%s] %s: data=%h,    addr=%h,    we=%b,    delay=%d",
                 tag, description, data, addr, we, delay);
    endfunction;

endclass : transaction