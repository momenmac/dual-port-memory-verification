class read_collision_test extends test;
    read_collision_gen gen_a;
    read_collision_gen gen_b;
  	bit [`ADDR_WIDTH-1:0] addr_q [$];
    int counter;
    int addr;
    int gen_selected_write;
    event write_done_event;

    function new(string name = "read_collision_test");
        super.new(name);
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.gen_selected_write = TestRegistry::get_int("GenSelected");
    endfunction

    virtual task configure_test();
        this.gen_a = new();
        this.gen_b = new();
        
        this.gen_a.write_done_event = this.write_done_event;
        this.gen_b.write_done_event = this.write_done_event;

        if(this.gen_selected_write < 0 || this.gen_selected_write > 1)
            this.gen_selected_write = $urandom_range(0, 1);

        if(this.gen_selected_write == 0)
            this.gen_a.enable_write = 1;
        else
            this.gen_b.enable_write = 1;

        repeat (this.counter) begin
            this.addr = $urandom_range(0, `MEMORY_DEPTH - 1);
            this.addr_q.push_back(this.addr);
        end

        this.gen_a.addr_q = this.addr_q;
        this.gen_b.addr_q = this.addr_q;

        this.gen_a.vif = e0.vif_a;
        this.gen_b.vif = e0.vif_b;

        e0.agent_a.set_generator(this.gen_a);
        e0.agent_b.set_generator(this.gen_b);
    endtask
endclass