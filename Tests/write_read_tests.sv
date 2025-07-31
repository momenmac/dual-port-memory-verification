class write_read_a_test extends test;
  	write_read_a_generator gen_a;  
    function new(string name = "write_read_a_test");
        super.new(name);
    	gen_a = new();
    endfunction

    virtual task configure_test();
        gen_a.configure_generator(project_pkg::ENABLED);
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.gen.configure_generator(project_pkg::DISABLED);
    endtask
endclass

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

class  write_a_read_b_test extends test;
    write_a_read_b_generator_a gen_a;
    write_a_read_b_generator_b gen_b;
  	bit [`ADDR_WIDTH- 1:0] addr_q [$];
  	int addr;
    int counter = 0;


    function new(string name = "write_a_read_b_test");
        super.new(name);
        gen_a = new();
        gen_b = new();
    endfunction

    virtual task configure_test();
        counter = TestRegistry::get_int("NoOfTransactions");
      	repeat (counter) begin
          	addr = $urandom_range(0, `MEMORY_DEPTH - 1);
            addr_q.push_back(addr);
        end
      	gen_a.addr_q = addr_q;
		gen_b.addr_q = addr_q;
      	gen_a.vif = e0.vif_a;
      	gen_b.vif = e0.vif_b;
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask
endclass

class  write_b_read_a_test extends test;
    write_b_read_a_generator_a gen_a;
    write_b_read_a_generator_b gen_b;
  	bit [ `ADDR_WIDTH - 1:0] addr_q [$];
  	int addr;
    int counter = 0;


    function new(string name = "write_a_read_b_test");
        super.new(name);
        gen_a = new();
        gen_b = new();
    endfunction

    virtual task configure_test();
      	counter = TestRegistry::get_int("NoOfTransactions");
      	repeat (counter) begin
          	addr = $urandom_range(0, `MEMORY_DEPTH - 1);
            addr_q.push_back(addr);
        end
      	gen_a.addr_q = addr_q;
		gen_b.addr_q = addr_q;
      	gen_a.vif = e0.vif_a;
      	gen_b.vif = e0.vif_b;
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask
endclass


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



class empty_mem_read_test extends test;
    empty_mem_read_gen gen_a;
    empty_mem_read_gen gen_b;

    function new(string name = "empty_mem_read_test");
        super.new(name);
        gen_a = new();
        gen_b = new();
    endfunction
    
  virtual task configure_test();
        e0.agent_a.set_generator(gen_a);
        e0.agent_b.set_generator(gen_b);
    endtask
endclass


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

class simultaneous_write_test extends test;
    int gen_selected_read;

    simultaneous_write_gen gen_a;
    simultaneous_write_gen gen_b;

    function new(string name = "simultaneous_write_test");
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

        e0.agent_a.set_generator(this.gen_a);
        e0.agent_b.set_generator(this.gen_b);
    endtask

endclass



class sim_write_a_read_b_test extends test;

    sim_write_a_read_b_gen_a gen_a;
    sim_write_a_read_b_gen_b gen_b;
    int counter;
    bit [`ADDR_WIDTH-1:0] addr_q [$];
    int addr;
    int delay;

    function new(string name = "sim_write_a_read_b");
        super.new(name);
        this.gen_a = new();
        this.gen_b = new();
        this.delay = 1;
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task configure_test();
        repeat (counter) begin
            addr = $urandom_range(0, `MEMORY_DEPTH - 1);
            addr_q.push_front(addr);
        end
      
      	gen_a.addr_q = this.addr_q;
        gen_b.addr_q = this.addr_q;

        gen_a.vif = e0.vif_a;
        gen_b.vif = e0.vif_b;

        e0.agent_a.set_generator(this.gen_a);
        e0.agent_b.set_generator(this.gen_b);
    endtask

endclass

class sim_write_b_read_a_test extends test;

    sim_write_b_read_a_gen_a gen_a;
    sim_write_b_read_a_gen_b gen_b;
    int counter;
  	bit [`ADDR_WIDTH-1:0] addr_q [$];
    int addr;

    function new(string name = "sim_write_b_read_a");
        super.new(name);
        this.gen_a = new();
        this.gen_b = new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task configure_test();
        repeat (counter) begin
            addr = $urandom_range(0, `MEMORY_DEPTH - 1);
            addr_q.push_back(addr);
        end
        gen_a.addr_q = this.addr_q;
        gen_b.addr_q = this.addr_q;
        
        this.gen_a.vif = e0.vif_a;
      	this.gen_b.vif = e0.vif_b;


        e0.agent_a.set_generator(this.gen_a);
        e0.agent_b.set_generator(this.gen_b);
    endtask

endclass



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