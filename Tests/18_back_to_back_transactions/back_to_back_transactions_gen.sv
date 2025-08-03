class back_to_back_transactions_gen extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(state == project_pkg::ENABLED) begin
            int count = TestRegistry::get_int("NoOfTransactions");
            for (int i = 0; i < count; i++) begin
                randomize_transaction();
                if(i+1 < count) // Last transaction will get a random delay
                    tr.delay = 0;
                if($urandom_range(0, 1) == 1) // Randomly choose to write or read
                    write();
                else
                    read();
            end
        end
    endtask
endclass