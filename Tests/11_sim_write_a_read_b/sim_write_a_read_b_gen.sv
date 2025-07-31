class sim_write_a_read_b_gen_a extends generator;
    int counter;
    int delay;
    bit [`ADDR_WIDTH-1:0] addr_q [$];
    virtual dut_if vif;

    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
            repeat(8) @(posedge vif.clk);
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            write();
        end
    endtask
endclass : sim_write_a_read_b_gen_a

class sim_write_a_read_b_gen_b extends generator;
    int counter;
    int delay;
    virtual dut_if vif;

    bit [`ADDR_WIDTH-1:0] addr_q [$];

    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
            repeat(8) @(posedge vif.clk);
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            read();
        end
    endtask
endclass : sim_write_a_read_b_gen_b