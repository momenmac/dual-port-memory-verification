class  write_b_read_a_test extends test;
    write_b_read_a_generator_a gen_a;
    write_b_read_a_generator_b gen_b;
  	bit [$clog2(`MEMORY_DEPTH) - 1:0] addr_q [$];
  	int addr;
    int counter = 0;


    function new(string name = "write_a_read_b_test");
        super.new(name);
        gen_a = new();
        gen_b = new();
    endfunction

    virtual task configure_test();
      	counter = TestRegistry::get_int("NoOfTransactions");
      	repeat (counter) begin
            addr = $urandom_range(0, `MEMORY_DEPTH - 1);
            addr_q.push_back(addr);
        end
      	gen_a.addr_q = addr_q;
		gen_b.addr_q = addr_q;
      	gen_a.vif = e0.vif_a;
      	gen_b.vif = e0.vif_b;
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask
endclass