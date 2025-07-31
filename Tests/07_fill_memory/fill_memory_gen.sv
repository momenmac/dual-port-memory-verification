
class fill_memory_gen extends generator;
    int addr;
  	int counter; 
    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
        repeat (counter) begin
          	for (int i = 0; i < `MEMORY_DEPTH; i++) begin
                randomize_transaction();
                tr.addr = i;
                write();
                randomize_transaction();
                tr.addr = i;
                read();
            end
        end
        read_all_memory();
    endtask

endclass : fill_memory_gen