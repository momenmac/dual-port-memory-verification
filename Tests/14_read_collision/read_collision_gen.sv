class read_collision_gen extends generator;
    int counter;
    event write_done_event;
    bit [$clog2(`MEMORY_SIZE)-1:0] addr_q [$];
    bit enable_write;
    int delay;

    function new();
        super.new();
        enable_write = 0;
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.write_done_event = new();
    endfunction

    virtual task run();
        if(enable_write)
        begin
            write_all_memory();
            ->write_done_event;
        end
        else
            @write_done_event;

        for (int i = 0; i < counter; i++) begin
            randomize_transaction();
            tr.addr = addr_q[i];
            read();
        end

    endtask
endclass : read_collision_gen