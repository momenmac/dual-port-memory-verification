class driver;
  	string port_name;
    virtual dut_if vif;
    mailbox gen2drv;
    int index = 0;
  	event gen_done;

    function new (string port_name = "");
      this.port_name = port_name;
    endfunction

    task run();
//         $display ("T=%0t [DRV] starting ...", $time);
		fork
            begin
              forever begin
              transaction tr;

              gen2drv.get(tr);
              vif.data <= tr.data;
              vif.addr <= tr.addr;
              vif.we <= tr.we;
              vif.valid <= 1'b1;
            tr.print(port_name,"Driver", "Transaction Received", index);
            if(!tr.we)
              index++;
              @(posedge vif.clk iff  vif.ready);



              // handle delays and reset
                  fork
                      begin
                        repeat(tr.delay) begin
                          vif.valid <= 1'b0;
                          @(posedge vif.clk);


                        end
                      end
                      begin
                          @(negedge vif.rst_n);
                          vif.valid <= 1'b0;
                        $display("driver resest");
                      end
                  join_any
                  disable fork;

          end
                    end
                  begin
                              @(gen_done);
						$display("gen_ended");
                    			vif.valid <=0;
                  end
                join_any;
    endtask

endclass : driver