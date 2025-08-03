class back_to_back_reads_gen extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(state == project_pkg::ENABLED) begin
            int count = TestRegistry::get_int("NoOfTransactions");
            write_all_memory();
            for (int i = 0; i < count; i++) begin
                randomize_transaction();
                if(i+1 < count) // Last transaction will get a random delay
                    tr.delay = 0; 
                read();
            end
        end
    endtask
endclass