class write_same_address_test extends test;
    write_same_address_generator gen_a;
    write_same_address_generator gen_b;
    
    bit gen_selected;

    function new(string name = "write_same_address_test");
        super.new(name);
        gen_a = new();
        gen_b = new();
    endfunction

    virtual task configure_test();
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask

endclass