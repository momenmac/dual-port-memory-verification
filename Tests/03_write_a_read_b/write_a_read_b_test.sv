class  write_a_read_b_test extends test;
    write_a_read_b_generator_a gen_a;
    write_a_read_b_generator_b gen_b;
    int counter = 0;
  	bit [$clog2(`MEMORY_SIZE) - 1:0] addr_q [$];
  	int addr;


    function new(string name = "write_a_read_b_test");
        super.new(name);
    endfunction

    virtual task configure_test();
        counter = TestRegistry::get_int("NoOfTransactions");
      	repeat (counter) begin
            addr = $urandom_range(0, `MEMORY_SIZE - 1);
            addr_q.push_back(addr);
        end
        gen_a = new();
        gen_b = new();
      	gen_a.addr_q = addr_q;
		gen_b.addr_q = addr_q;
        gen_a.counter = counter;
        gen_b.counter = counter;
      	gen_a.vif = e0.vif_a;
      	gen_b.vif = e0.vif_b;
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask
endclass