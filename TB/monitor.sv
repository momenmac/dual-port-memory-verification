class monitor;
  	string port_name;
    virtual dut_if vif;
    mailbox mon2scb;
//     coverage_collector cov_collector;
  
    function new (string port_name = "");
      this.port_name = port_name;
    endfunction

    task run();
//         $display ("T=%0t [MON] starting ...", $time);
        forever begin
            transaction tr = new();
            @(posedge vif.clk iff (vif.valid && vif.ready));
                tr.we = vif.we;
                tr.addr = vif.addr;

                if(vif.we) begin
                    tr.data = vif.data;
                    tr.print(port_name,"Monitor", "Transaction (Write)");
                end else begin
                    tr.data = vif.q; // Read operation, data is not used
                    tr.print(port_name,"Monitor", "Transaction (Read)");
                end

                mon2scb.put(tr);
//                 cov_collector.sample(tr);
        end
    endtask
    
endclass: monitor