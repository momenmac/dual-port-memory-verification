class write_collision_gen extends generator;
    int counter;
    int delay;
    bit [`ADDR_WIDTH-1:0] addr_q [$];
    bit enable_read;
  	virtual dut_if vif;


    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
        this.enable_read = 0; 
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
            repeat(18) @(posedge vif.clk);
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            write();
        end
        if (enable_read)
            read_all_memory();
    endtask
endclass : write_collision_gen