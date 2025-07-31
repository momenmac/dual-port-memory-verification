class back_to_back_writes_test extends test;
  	back_to_back_writes_gen gen_a;  
    function new(string name = "back_to_back_writes_test");
        super.new(name);
    	gen_a = new();
    endfunction

    virtual task configure_test();
        gen_a.configure_generator(project_pkg::ENABLED);
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.gen.configure_generator(project_pkg::DISABLED);
    endtask
endclass