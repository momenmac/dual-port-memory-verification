class empty_mem_read_test extends test;
    empty_mem_read_gen gen_a;
    empty_mem_read_gen gen_b;

    function new(string name = "empty_mem_read_test");
        super.new(name);
        gen_a = new();
        gen_b = new();
    endfunction
    
  virtual task configure_test();
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask
endclass
