class write_read_a_generator extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(state == project_pkg::ENABLED) begin
            int count = TestRegistry::get_int("NoOfTransactions");
            repeat (count) begin
                randomize_transaction();
                write();
                randomize_transaction();
                tr.addr = this.addr;
                read();
            end
        end
    endtask
endclass


class write_read_b_generator extends generator;
    function new();
        super.new();
    endfunction

    virtual task run();
        if(state == project_pkg::ENABLED) begin
            int count = TestRegistry::get_int("NoOfTransactions");
            repeat (count) begin
                randomize_transaction();
                write();
                randomize_transaction();
                tr.addr = this.addr;
                read();
            end
        end
    endtask
endclass

class write_a_read_b_generator_a extends generator;
    int counter;
  bit [`ADDR_WIDTH- 1:0] addr_q [$];
  	virtual dut_if vif;


    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
		@(posedge vif.clk);
        for(int i = 0; i < counter; i++) begin
            randomize_transaction();
            tr.addr = addr_q[i];
          	tr.delay = 1;
            write();
        end
    endtask
endclass

class write_a_read_b_generator_b extends generator;
    int counter;
  bit [`ADDR_WIDTH - 1:0] addr_q [$];
  	virtual dut_if vif;

    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
      repeat (2) @(posedge vif.clk);
       for(int i = 0; i < counter; i++) begin
            randomize_transaction();
            tr.addr = addr_q[i];
         	tr.delay =1;
            read();
        end
    endtask
endclass

class write_b_read_a_generator_b extends generator;
    // This gen is responsible for writing to port B
    int counter;
  bit [`ADDR_WIDTH - 1:0] addr_q [$];
  	virtual dut_if vif;


    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
		@(posedge vif.clk);
        for(int i = 0; i < counter; i++) begin
            randomize_transaction();
            tr.addr = addr_q[i];
          	tr.delay = 1;
            write();
        end
    endtask
endclass

class write_b_read_a_generator_a extends generator;
    // This gen is responsible for reading from port A
    int counter;
  	bit [`ADDR_WIDTH - 1:0] addr_q [$];
  	virtual dut_if vif;

    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
      repeat (2) @(posedge vif.clk);
       for(int i = 0; i < counter; i++) begin
            randomize_transaction();
            tr.addr = addr_q[i];
         	tr.delay =1;
            read();
        end
    endtask
endclass



class write_same_address_generator extends generator;
    int counter;

    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();

        repeat (counter) begin
            randomize_transaction();
            addr = tr.addr;
            repeat ($urandom_range(1, 5)) begin
                randomize_transaction();
                tr.addr = addr;
                write();
                randomize_transaction();
                tr.addr = addr; 
                read();
            end
        end
    endtask
endclass


class empty_mem_read_gen extends generator;
    int counter;

    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
        repeat (counter) begin
            randomize_transaction();
 			tr.delay = 0;
            read();
        end
    endtask
endclass


class fill_memory_gen extends generator;
    int addr;
  	int counter; 
    function new();
        super.new();
        counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
        repeat (counter) begin
          	for (int i = 0; i < `MEMORY_DEPTH; i++) begin
                randomize_transaction();
                tr.addr = i;
                write();
                randomize_transaction();
                tr.addr = i;
                read();
            end
          read_all_memory();
        end
    endtask

endclass : fill_memory_gen

class reset_behavior_gen extends generator;
  	event reset_event;

    virtual dut_if vif;
    int reset_delay;
    int count, transaction_count;

    function new();
        super.new();
        this.count = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
        repeat (count) begin
            reset_delay = $urandom_range(10, 70);
          	transaction_count = $urandom_range(1, `MEMORY_DEPTH);

            repeat (transaction_count) begin
                    randomize_transaction();
                    write();
            end 

            repeat (reset_delay) begin @(posedge vif.clk);
            end
            ->reset_event;
            if(TestRegistry::get_int("DebugEnabled")) begin
                $display("%t Reset event triggered after %0d transactions",$time, transaction_count);
            end
            read_all_memory();

        end
    endtask
endclass


class simultaneous_write_gen extends generator;
    bit read_enable;
    int counter;
  
    function new();
        super.new();
        read_enable = 0;
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction


    virtual task run();
        repeat (counter) begin
          	
            randomize_transaction();
            write();
        end
        if(read_enable)
            read_all_memory();
    endtask

endclass


class simultaneous_read_gen extends generator;
    bit write_enable;
    int counter;
    event write_done_event;

    function new();
        super.new();
        write_enable = 0;
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction


    virtual task run();
        if(write_enable)
        begin
            write_all_memory();
            ->write_done_event;
        end
        else
            @write_done_event;

        repeat (counter) begin
            randomize_transaction();
            read();
        end

    endtask

endclass


class sim_write_a_read_b_gen_a extends generator;
    int counter;
    int delay;
    bit [`ADDR_WIDTH-1:0] addr_q [$];
    virtual dut_if vif;

    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
            repeat(8) @(posedge vif.clk);
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            write();
        end
    endtask
endclass : sim_write_a_read_b_gen_a

class sim_write_a_read_b_gen_b extends generator;
    int counter;
    int delay;
    virtual dut_if vif;

    bit [`ADDR_WIDTH-1:0] addr_q [$];

    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
            repeat(8) @(posedge vif.clk);
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            read();
        end
    endtask
endclass : sim_write_a_read_b_gen_b


class sim_write_b_read_a_gen_b extends generator;
    int counter;
    int delay;
    virtual dut_if vif;
    bit [`ADDR_WIDTH-1:0] addr_q [$];

    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
            repeat(8) @(posedge vif.clk);
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            write();
        end
    endtask
endclass : sim_write_b_read_a_gen_b

class sim_write_b_read_a_gen_a extends generator;
    int counter;
    int delay;
    virtual dut_if vif;

    bit [`ADDR_WIDTH-1:0] addr_q [$];

    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
            repeat(8) @(posedge vif.clk);
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            read();
        end
    endtask
endclass : sim_write_b_read_a_gen_a

class write_collision_gen extends generator;
    int counter;
    int delay;
    bit [`ADDR_WIDTH-1:0] addr_q [$];
    bit enable_read;
  	virtual dut_if vif;


    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
        this.delay = TestRegistry::get_int("TransactionDelay");
        this.enable_read = 0; 
    endfunction

    virtual task run();
        for (int i = 0; i < counter; i++) begin
          repeat(8) @(posedge vif.clk);
            randomize_transaction();
            tr.addr = addr_q[i];
            tr.delay = this.delay;
            write();
        end
        if (enable_read)
            read_all_memory();
    endtask
endclass : write_collision_gen