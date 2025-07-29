class write_read_a_generator extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(state == project_pkg::ENABLED) begin
            int count = TestRegistry::get_int("NoOfTransactions");
            repeat (count) begin
                randomize_transaction();
                write();
                randomize_transaction();
                tr.addr = this.addr;
                read();
            end
        end
    endtask
endclass