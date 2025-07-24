class monitor;
    virtual dut_if vif;
    mailbox mon2scb;
    coverage_collector cov_collector;

    task run();
        $display ("T=%0t [MON] starting ...", $time);
        forever begin
            transaction tr = new();
            @(posedge vif.clk iff (vif.valid && vif.ready));
                tr.we = vif.we;
                tr.addr = vif.addr;

                if(vif.we) begin
                    tr.data = vif.data;
                end else begin
                    tr.data = vif.q; // Read operation, data is not used
                end

                tr.print("Monitor", "Transaction Captured");
                mon2scb.put(tr);
                cov_collector.sample(tr);
        end
    endtask;
    
endclass: monitor