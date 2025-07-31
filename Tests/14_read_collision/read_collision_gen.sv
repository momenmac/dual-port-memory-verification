class read_collision_gen extends generator;
    int counter;
    event write_done_event;
  	bit [`ADDR_WIDTH-1:0] addr_q [$];
    bit enable_write;
    int delay;
    virtual dut_if vif;

    function new();
        super.new();
        enable_write = 0;
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
        if(enable_write)
        begin
            write_all_memory();
            ->write_done_event;
        end
        else
          @(write_done_event);
      
      repeat(20) @(posedge vif.clk);

        for (int i = 0; i < counter; i++) begin
            repeat(8) @(posedge vif.clk);
            randomize_transaction();
            tr.addr = addr_q[i];
          	tr.delay = 1;
            read();
        end

    endtask
endclass : read_collision_gen