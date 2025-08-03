class transaction;
    rand bit [`DATA_WIDTH-1:0] data;
    rand bit [`ADDR_WIDTH-1:0] addr;
    rand bit we;
    rand int delay; // Delay in clock cycles 
    bit is_start = 0; 
  
  constraint delay_constraint { delay < 10; delay >0;}
    
  virtual function void copy(transaction t);
      this.data = t.data;
      this.addr = t.addr;
      this.we = t.we;
      this.delay = t.delay;
      this.is_start = t.is_start;
  endfunction

  function void print( string port_name = "",string tag = "" , string description = "", int index = 0);
    if(TestRegistry::get_int("DebugEnabled") == 1)
      $display("{%s} %t [%s][%0d]\t %s (%s):\tdata=%h,\taddr=%h,    we=%b,    delay=%d", port_name,$time, tag,index, description, is_start ? "START" : "END", data, addr, we, delay);
  endfunction

endclass : transaction