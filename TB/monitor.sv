class monitor;
    virtual dut_if vif;
    mailbox mon2scb;

    task run();
        $display ("T=%0t [MON] starting ...", $time);
        forever begin
            transaction tr = new();
            @(posedge vif.clk);
                tr.data = vif.data;
                tr.addr = vif.addr;
                tr.we = vif.we;
                tr.valid = vif.valid;
                tr.ready = vif.ready;
                tr.q = vif.q;
                item.print("Monitor", "Transaction Captured");
                mon2scb.put(tr);
                //cov_collector.sample(tr);
        end
    endtask;

    //coverage collection

endclass: monitor