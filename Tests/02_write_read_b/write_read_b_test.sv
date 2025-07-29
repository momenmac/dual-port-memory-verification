class write_read_b_test extends test;
      write_read_b_generator gen_b;

    function new(string name = "write_read_b_test");
        super.new(name);
        gen_b = new();
    endfunction

    virtual task configure_test();
        gen_b.configure_generator(project_pkg::ENABLED);
        e0.agent_b.set_generator(gen_b);
        e0.agent_a.port_name = "test";
        e0.agent_a.gen.configure_generator(project_pkg::DISABLED);
    endtask
endclass