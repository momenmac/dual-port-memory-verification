class driver;
    virtual dut_if vif;
    mailbox gen2drv;

    task run();
        $display ("T=%0t [DRV] starting ...", $time);
        forever begin
            transaction tr;
            gen2drv.get(tr);
            vif.data <= tr.data;
            vif.addr <= tr.addr;
            vif.we <= tr.we;
            vif.valid <= 1'b1;
            tr.print("Driver", "Transaction Received");
            @(posedge vif.clk iff vif.ready);

            // todo: handle reset case
            
            if(tr.delay >0) begin
                vif.valid <= 1'b0;
                repeat(tr.delay) @(posedge vif.clk);
            end
        end
    endtask;

endclass : driver