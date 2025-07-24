class generator;
    mailbox gen2drv;
    transaction tr;
    transaction temp;
    event drv_done;
    int addr;

    function new();
        this.tr = new();
    endfunction;

    virtual task run();
    int count = TestRegistry::get_int("NoOfTransactions");
    repeat (count) begin
        write();
        read();
    end
    endtask;

    virtual task write();
        assert (tr.randomize() with {we == 1'b1;}) else begin
            $display("[Gem] Randomization failed for write transaction");
            return;
        end
        tmp = new();
        tmp.copy(tr);
        tmp.print("Generator", "Write Transaction");
        addr = tr.addr;
        gen2drv.put(tmp);
        @drv_done;
    endtask;

    virtual task read();
        assert (tr.randomize() with {we == 1'b0; addr == addr }) else begin
            $display("[Gem] Randomization failed for read transaction");
            return;
        end
        tmp = new();
        tmp.copy(tr);
        tmp.print("Generator", "Read Transaction");
        gen2drv.put(tmp);
        @drv_done;
    endtask;

endclass : generator