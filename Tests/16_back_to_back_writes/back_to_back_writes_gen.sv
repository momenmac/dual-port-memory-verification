class back_to_back_writes_gen extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(state == project_pkg::ENABLED) begin
            int count = TestRegistry::get_int("NoOfTransactions");
            repeat (count) begin
                randomize_transaction();
              	tr.delay = 0;
                write();
                $display("Back to back write at address: %0d", tr.addr);
            end
            read_all_memory();
        end
    endtask
endclass