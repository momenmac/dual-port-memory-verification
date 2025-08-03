module tb;
    logic clk;
    logic rst_n;
    string argv;
  	event reset_event;

    dut_if port_a_interface(clk, rst_n);
    dut_if port_b_interface(clk, rst_n);

    DP_MEM dut (
        .wr_data_a(port_a_interface.data),
        .wr_data_b(port_b_interface.data),
        .addr_a(port_a_interface.addr),
        .addr_b(port_b_interface.addr),
        .op_a(port_a_interface.we),
        .op_b(port_b_interface.we),
        .clk(clk),
        .rstn(rst_n),
        .valid_a(port_a_interface.valid),
        .valid_b(port_b_interface.valid),
        .ready_a(port_a_interface.ready),
        .ready_b(port_b_interface.ready),
        .rd_data_a(port_a_interface.q),
        .rd_data_b(port_b_interface.q)
    );

    initial begin
        rst_n = 1'b1;
        clk =0;
        forever #5 clk = ~clk;
    end

    task system_reset();
        rst_n = 1'b0;
        repeat ($urandom_range(5, 30)) @(posedge clk);
        rst_n = 1'b1;
    endtask
  
  initial begin
          $dumpfile("dump.vcd"); $dumpvars;

  end
    initial begin
        string test_name;
        test t;
      	int transaction_count = 10;
        int transaction_delay = 1;
        int gen_selected = -1;
        int debug_enabled = 1;
      	rst_n = 1'b0;

      if($value$plusargs("test=%s", argv)) begin
            test_name = argv;
        end else begin
            $display("No test case specified, running default test.");
            test_name = "default";
        end
      
      if($value$plusargs("NoTransactions=%s", argv))
        transaction_count = argv.atoi();

      if($value$plusargs("TransactionDelay=%s", argv))
        transaction_delay = argv.atoi();

      if($value$plusargs("GenSelected=%s", argv))
        gen_selected = argv.atoi();

      if($value$plusargs("DebugEnabled=%s", argv))
        debug_enabled = argv.atoi();

        TestRegistry::set_int("NoOfTransactions", transaction_count);
        TestRegistry::set_int("TransactionDelay", transaction_delay);
        TestRegistry::set_int("DebugEnabled",debug_enabled);
        TestRegistry::set_int("GenSelected", gen_selected);

        $display("Test Name: %s", test_name);
        $display("Transaction Count: %d", transaction_count); 
        $display("Transaction Delay: %d", transaction_delay);
        $display("Generator Selected: %d", gen_selected);

      	t = test_factory::create_test(test_name);
      	t.e0.reset_event = reset_event;
      
        t.e0.vif_a = port_a_interface;
        t.e0.vif_b = port_b_interface;
      
      	repeat ($urandom_range(5, 30)) @(posedge clk);
      	system_reset();
        repeat ($urandom_range(0, 30)) @(posedge clk);
        t.run();
    end


  initial
  	forever
      begin
        @(reset_event);
        system_reset();
    end


endmodule : tb