class generator;
    mailbox gen2drv;
    transaction tr;
    transaction temp;
    int addr;
    bin active;

    function new();
        this.tr = new();
        this.active = 1;
    endfunction;

    virtual task run();
    if(active)begin
        int count = TestRegistry::get_int("NoOfTransactions");
        repeat (count) begin
            randomize_transaction();
            write();
            read();
        end
    end
    endtask;

    task randomize_transaction();
        assert (tr.randomize()) else begin
            $error("[Gen] Randomization failed for transaction");
            return;
        end
    endtask;

    virtual task write();
        tr.we = 1'b1; 
        tmp = new();
        tmp.copy(tr);
        tmp.print("Generator", "Write Transaction");
        addr = tr.addr;
        gen2drv.put(tmp);
    endtask;


    virtual task read();
        tr.we = 1'b0;
        tmp = new();
        tmp.copy(tr);
        tmp.print("Generator", "Read Transaction");
        gen2drv.put(tmp);
    endtask;

endclass : generator