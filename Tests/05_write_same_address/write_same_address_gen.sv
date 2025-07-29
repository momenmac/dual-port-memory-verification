class write_same_address_generator extends generator;
    int counter;

    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();

        repeat (counter) begin
            randomize_transaction();
            addr = tr.addr;
            repeat ($urandom_range(1, 5)) begin
                randomize_transaction();
                tr.addr = addr;
                write();
                randomize_transaction();
                tr.addr = addr; 
                read();
            end
        end
    endtask
endclass