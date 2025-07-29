class write_read_a_test extends test;
  	write_read_a_generator gen_a;  
    function new(string name = "write_read_a_test");
        super.new(name);
    	gen_a = new();
    endfunction

    virtual task configure_test();
        gen_a.configure_generator(project_pkg::ENABLED);
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.gen.configure_generator(project_pkg::DISABLED);
    endtask
endclass