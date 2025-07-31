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