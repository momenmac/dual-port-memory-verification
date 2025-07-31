class sim_write_a_read_b_test extends test;

    sim_write_a_read_b_gen_a gen_a;
    sim_write_a_read_b_gen_b gen_b;
    int counter;
    bit [`ADDR_WIDTH-1:0] addr_q [$];
    int addr;
    int delay;

    function new(string name = "sim_write_a_read_b");
        super.new(name);
        this.gen_a = new();
        this.gen_b = new();
        this.delay = 1;
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task configure_test();
        repeat (counter) begin
            addr = $urandom_range(0, `MEMORY_DEPTH - 1);
            addr_q.push_front(addr);
        end

        gen_a.addr_q = this.addr_q;
        gen_b.addr_q = this.addr_q;


        gen_a.vif = e0.vif_a;
        gen_b.vif = e0.vif_b;

        e0.agent_a.set_generator(this.gen_a);
        e0.agent_b.set_generator(this.gen_b);
    endtask

endclass