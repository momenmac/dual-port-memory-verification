class fill_memory_test extends test;
	int gen_selected;
    fill_memory_gen gen;

    function new();
        super.new("fill_memory_test");
        gen = new();
    endfunction


    virtual task configure_test();

        gen_selected = $urandom_range(0, 1);
        if (gen_selected) begin
            e0.agent_a.set_generator(gen);
            e0.agent_b.gen.configure_generator(project_pkg::DISABLED);
        end else begin
            e0.agent_b.set_generator(gen);
            e0.agent_a.gen.configure_generator(project_pkg::DISABLED);
        end
    endtask

endclass