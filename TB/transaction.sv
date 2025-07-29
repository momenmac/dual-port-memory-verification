class transaction;
    rand bit [`MEMORY_WIDTH-1:0] data;
    rand bit [$clog2(`MEMORY_SIZE)-1:0] addr;
    rand bit we;
    rand int delay; // Delay in clock cycles 
  
  
  constraint delay_constraint { delay < 10; delay >0;}
    
    virtual function void copy(transaction t);
        this.data = t.data;
        this.addr = t.addr;
        this.we = t.we;
        this.delay = t.delay;
    endfunction

  function void print( string port_name = "",string tag = "" , string description = "", int index = 0);
    $display("{%s} %t [%s][%0d]\t %s:\tdata=%h,\taddr=%h,    we=%b,    delay=%d", port_name,$time, tag,index, description, data, addr, we, delay);
    endfunction

endclass : transaction