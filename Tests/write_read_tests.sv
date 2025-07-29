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
  	bit [$clog2(`MEMORY_SIZE) - 1:0] addr_q [$];
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
            addr = $urandom_range(0, `MEMORY_SIZE - 1);
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
  	bit [$clog2(`MEMORY_SIZE) - 1:0] addr_q [$];
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
            addr = $urandom_range(0, `MEMORY_SIZE - 1);
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

