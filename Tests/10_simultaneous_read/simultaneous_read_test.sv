class simultaneous_read_test extends test;
    int gen_selected_write;

    simultaneous_read_gen gen_a;
    simultaneous_read_gen gen_b;
    event write_done_event;

    function new(string name = "simultaneous_read_test");
        super.new(name);
        this.gen_a = new();
        this.gen_b = new();
        this.gen_selected_write = TestRegistry::get_int("GenSelected");
    endfunction

    virtual task configure_test();
        gen_a.write_done_event = this.write_done_event;
        gen_b.write_done_event = this.write_done_event;

        if(this.gen_selected_write < 0 || this.gen_selected_write > 1)
            this.gen_selected_write = $urandom_range(0, 1);

        if (this.gen_selected_write)
            gen_a.write_enable = 1;
        else 
            gen_b.write_enable = 1;

        env0.agent_a.set_generator(this.gen_a);
        env0.agent_b.set_generator(this.gen_b);
    endtask

endclass