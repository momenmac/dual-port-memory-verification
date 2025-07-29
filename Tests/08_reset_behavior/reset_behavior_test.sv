class reset_behavior_test extends test;
    reset_behavior_gen gen;
	int gen_selected;
    
    function new();
        super.new("reset_behavior_test");
        gen = new();
    endfunction


    virtual task configure_test();
      	gen.reset_event = e0.reset_event;
        gen.vif = e0.vif_a;
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

