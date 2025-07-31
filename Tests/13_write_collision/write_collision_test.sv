class write_collision_test extends test;
    write_collision_gen gen_a;
    write_collision_gen gen_b;
  	bit [`ADDR_WIDTH-1:0] addr_q [$];
    int counter;
    int addr;
    int gen_selected_read;

    function new(string name = "write_collision_test");
        super.new(name);
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.gen_selected_read = TestRegistry::get_int("GenSelected");

    endfunction

    virtual task configure_test();
        this.gen_a = new();
        this.gen_b = new();


        if(this.gen_selected_read < 0 || this.gen_selected_read > 1)
            this.gen_selected_read =  $urandom_range(0, 1);

        if(this.gen_selected_read == 0)
            this.gen_a.enable_read = 1;
        else
            this.gen_b.enable_read = 1;

        repeat (this.counter) begin
            this.addr = $urandom_range(0, `MEMORY_DEPTH-1);
            this.addr_q.push_back(this.addr);
        end

        this.gen_a.addr_q = this.addr_q;
      	this.gen_a.vif = e0.vif_a;
      	this.gen_b.vif = e0.vif_b;
      
        this.gen_b.addr_q = this.addr_q;

        e0.agent_a.set_generator(this.gen_a);
        e0.agent_b.set_generator(this.gen_b);
    endtask

endclass