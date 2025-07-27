class write_read_a_test extends test;
  	write_read_a_generator gen_a;  
    function new(string name = "write_read_a_test");
        super.new(name);
    endfunction

    virtual task configure_test();
       	gen_a = new();
        gen_a.configure_generator(project_pkg::ENABLED);
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.gen.configure_generator(project_pkg::DISABLED);
    endtask

endclass

class write_read_b_test extends test;
      write_read_b_generator gen_b;

    function new(string name = "write_read_b_test");
        super.new(name);
    endfunction

    virtual task configure_test();
        gen_b = new();
        gen_b.configure_generator(project_pkg::ENABLED);
        e0.agent_b.set_generator(gen_b);
      e0.agent_a.port_name = "test";
        e0.agent_a.gen.configure_generator(project_pkg::DISABLED);
    endtask
endclass
