class write_read_a_generator extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(state == project_pkg::ENABLED) begin
            int count = TestRegistry::get_int("NoOfTransactions");
            repeat (count) begin
              randomize_transaction();
              tr.addr = 1;
                write();
                read();
            end
        end
    endtask
endclass

class write_read_b_generator extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(state == project_pkg::ENABLED) begin
            int count = TestRegistry::get_int("NoOfTransactions");
            repeat (count) begin
                randomize_transaction();
                write();
                read();
            end
        end
    endtask
endclass