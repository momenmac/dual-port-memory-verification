class back_to_back_reads_test extends test;
  	back_to_back_reads_gen gen;
    int gen_selected;

    function new(string name = "back_to_back_reads_test");
        super.new(name);
    	gen = new();
        this.gen_selected = TestRegistry::get_int("GenSelected");
    endfunction

    virtual task configure_test();

        if(this.gen_selected < 0 || this.gen_selected > 1)
            this.gen_selected = $urandom_range(0, 1);
        if(this.gen_selected == 0) begin
            e0.agent_a.set_generator(gen);
            e0.agent_b.gen.configure_generator(project_pkg::DISABLED);
        end
        else begin
            e0.agent_b.set_generator(gen);
            e0.agent_a.gen.configure_generator(project_pkg::DISABLED);
        end
    endtask
endclass