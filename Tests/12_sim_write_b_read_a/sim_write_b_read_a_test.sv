class sim_write_b_read_a_test extends test;

    sim_write_b_read_a_gen_a gen_a;
    sim_write_b_read_a_gen_b gen_b;
    int counter;
  	bit [`ADDR_WIDTH-1:0] addr_q [$];
    int addr;

    function new(string name = "sim_write_b_read_a");
        super.new(name);
        this.gen_a = new();
        this.gen_b = new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task configure_test();
        repeat (counter) begin
            addr = $urandom_range(0, `MEMORY_DEPTH - 1);
            addr_q.push_back(addr);
        end
        gen_a.addr_q = this.addr_q;
        gen_b.addr_q = this.addr_q;
        
        this.gen_a.vif = e0.vif_a;
      	this.gen_b.vif = e0.vif_b;


        e0.agent_a.set_generator(this.gen_a);
        e0.agent_b.set_generator(this.gen_b);
    endtask

endclass
