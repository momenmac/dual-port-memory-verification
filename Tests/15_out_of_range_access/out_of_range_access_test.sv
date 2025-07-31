class out_of_range_access_test extends test;

    int gen_selected_read;

    
    out_of_range_access_gen gen_a;
    out_of_range_access_gen gen_b;

    function new(string name = "out_of_range_access_test");
        super.new(name);
        this.gen_a = new();
        this.gen_b = new();
        this.gen_selected_read = TestRegistry::get_int("GenSelected");
    endfunction

    virtual task configure_test();
        
        if(this.gen_selected_read < 0 || this.gen_selected_read > 1)
            this.gen_selected_read = $urandom_range(0, 1);
        
        if (gen_selected_read)
            gen_a.read_enable = 1;
        else 
            gen_b.read_enable = 1;

        e0.agent_a.set_generator(this.gen_a);
        e0.agent_b.set_generator(this.gen_b);
    endtask
endclass
