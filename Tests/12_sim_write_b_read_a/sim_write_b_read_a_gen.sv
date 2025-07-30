class sim_write_b_read_a_gen_b extends generator;
    int counter;
    int delay;
    bit [$clog2(`MEMORY_SIZE)-1:0] addr_q [$];

    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            write();
        end
    endtask
endclass : sim_write_b_read_a_gen_a

class sim_write_b_read_a_gen_b extends generator;
    int counter;
    int delay;

    bit [$clog2(`MEMORY_SIZE)-1:0] addr_q [$];

    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            read();
        end
    endtask
endclass : sim_write_b_read_a_gen_b