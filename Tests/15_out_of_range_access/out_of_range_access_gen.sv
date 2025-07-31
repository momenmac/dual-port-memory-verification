class out_of_range_access_gen extends generator;
    bit read_enable;
    int counter;

    function new();
        super.new();
        read_enable = 0;
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction


    virtual task run();
        repeat (counter) begin
            tr.randomize() with {
                tr.addr >= `MEMORY_DEPTH;
            };
            $display("Out of range access at address: %0d", tr.addr);
            write();
        end
        if(read_enable)
            read_all_memory();
    endtask

endclass