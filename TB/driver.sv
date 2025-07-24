class driver;
    virtual dut_if vif;
    event drv_done;
    mailbox gen2drv;

    task run();
        $display ("T=%0t [DRV] starting ...", $time);
        forever begin
            transaction tr;
            @(posedge vif.clk);
            gen2drv.get(tr);
            vif.data <= tr.data;
            vif.addr <= tr.addr;
            vif.we <= tr.we;
            vif.valid <= tr.valid;
            tr.print("Driver", "Transaction Received");

            if(tr.valid) begin
                wait(vif.ready);
            end
            -> drv_done;
        end
    endtask;

endclass : driver