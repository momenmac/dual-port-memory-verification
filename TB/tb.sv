module tb;
    logic clk;
    logic rst_n;
    string argv;
  	event reset_event;

    dut_if port_a_interface(clk, rst_n);
    dut_if port_b_interface(clk, rst_n);

    dpram dut (
        .data_a(port_a_interface.data),
        .data_b(port_b_interface.data),
        .addr_a(port_a_interface.addr),
        .addr_b(port_b_interface.addr),
        .we_a(port_a_interface.we),
        .we_b(port_b_interface.we),
        .clk(clk),
        .rst_n(rst_n),
        .valid_a(port_a_interface.valid),
        .valid_b(port_b_interface.valid),
        .ready_a(port_a_interface.ready),
        .ready_b(port_b_interface.ready),
        .q_a(port_a_interface.q),
        .q_b(port_b_interface.q)
    );

    initial begin
        rst_n = 1'b1;
        clk =0;
        forever #5 clk = ~clk;
    end

    task system_reset();
        rst_n = 1'b0;
        repeat (5) @(posedge clk);
        rst_n = 1'b1;
    endtask
  
  initial begin
          $dumpfile("dump.vcd"); $dumpvars;

  end

    initial begin
        string test_name;
        test t;
      	int NoOfTransactions = 10;
      	rst_n = 1'b0;

      if($value$plusargs("test=%s", argv)) begin
        $display("argv = %s", argv);
            test_name = argv;
        end else begin
            $display("No test case specified, running default test.");
            test_name = "default";
        end
      
      if($value$plusargs("NoTransactions=%s", argv))
        NoOfTransactions = argv.atoi();
        
        
        TestRegistry::set_int("NoOfTransactions", NoOfTransactions);

      	t = test_factory::create_test(test_name);
      	t.e0.reset_event = reset_event;
      
        t.e0.vif_a = port_a_interface;
        t.e0.vif_b = port_b_interface;
      
      	repeat (5) @(posedge clk);
      	system_reset();
        t.run();
    end

  initial
  	forever
      begin
        @(reset_event);
        system_reset();
    end


endmodule : tb