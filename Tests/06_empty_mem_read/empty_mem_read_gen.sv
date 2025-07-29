class empty_mem_read_gen extends generator;
    int counter;

    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
        repeat (counter) begin
            randomize_transaction();
            read();
        end
    endtask
endclass