class simultaneous_read_gen extends generator;
    bit write_enable;
    int counter;
    event write_done_event;

    function new();
        super.new();
        write_enable = 0;
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction


    virtual task run();
        if(write_enable)
        begin
            write_all_memory();
            ->write_done_event;
        end
        else
            @write_done_event;

        repeat (counter) begin
            randomize_transaction();
            read();
        end

    endtask

endclass