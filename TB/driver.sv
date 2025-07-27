class driver;
  	string port_name;
    virtual dut_if vif;
    mailbox gen2drv;
  
    function new (string port_name = "");
      this.port_name = port_name;
    endfunction

    task run();
//         $display ("T=%0t [DRV] starting ...", $time);
        forever begin
            transaction tr;
            gen2drv.get(tr);
            vif.data <= tr.data;
            vif.addr <= tr.addr;
            vif.we <= tr.we;
            vif.valid <= 1'b1;
          tr.print(port_name,"Driver", "Transaction Received");
            @(posedge vif.clk iff  vif.ready);


            
            // handle delays and reset
            if(tr.delay >0) begin
                vif.valid <= 1'b0;
                fork
                    begin
                        repeat(tr.delay) @(posedge vif.clk);
                    end
                    begin
                        @(negedge vif.rst_n);
                    end
                join_any
                disable fork;
            end
        end
    endtask

endclass : driver