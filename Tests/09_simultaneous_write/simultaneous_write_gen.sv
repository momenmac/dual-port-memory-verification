class simultaneous_write_gen extends generator;
    bit read_enable;
    int counter;

    function new();
        super.new();
        read_enable = 0;
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction


    virtual task run();
        repeat (counter) begin
            randomize_transaction();
            write();
        end
        if(read_enable)
            read_all_memory();
    endtask

endclass