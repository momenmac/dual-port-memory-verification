class scb;
    mailbox mon2scb_a;
    mailbox mon2scb_b;
    int index_a = 0;
    int index_b = 0;
    int pass_count_a = 0;
    int fail_count_a = 0;
    int pass_count_b = 0;
    int fail_count_b = 0;
    bit [`DATA_WIDTH - 1:0] memory [`MEMORY_DEPTH - 1:0] = '{default: 0};
    string tag_a;
    string tag_b;
	  virtual dut_if vif;
  	int debug_enabled;
  
    function void reset ();
      for (int i = 0; i < `MEMORY_DEPTH; i++) begin
            memory[i] <= 0;
        end
    endfunction
  
  function new();
    this.debug_enabled = TestRegistry::get_int("DebugEnabled");
  endfunction
  
  task run();
    $display("SCB is running");

    forever begin
    fork
      begin
        forever begin
          transaction item_a;
          mon2scb_a.get(item_a);
          tag_a = item_a.we ? "Write" : "Read";
          tag_a = $sformatf("Transaction (%s)", tag_a);
          item_a.print("Port_A", "ScoreBoard", tag_a, index_a);
          check_transaction(item_a, pass_count_a, fail_count_a,index_a);
      end
      end

      begin
        forever begin
          transaction item_b;
          mon2scb_b.get(item_b);
          tag_b = item_b.we ? "Write" : "Read";
          tag_b = $sformatf("Transaction (%s)", tag_b);
          item_b.print("Port_B", "ScoreBoard", tag_b, index_b);
          check_transaction(item_b, pass_count_b, fail_count_b,index_b);
        end
      end

      begin
        @(negedge vif.rst_n);
        $display("SCB reset started");
        reset();
        $display("SCB reset complete");
      end
    join_any
    disable fork;
    end
  endtask
    
  function void report_statistics();
      $display("==========================");
      $display("SCB Statistics:");
      $display("Total Passes (Port A): %0d", pass_count_a);
      $display("Total Failures (Port A): %0d", fail_count_a);
      $display("Pass Rate (Port A): %0.2f%%", (pass_count_a + fail_count_a) ? (pass_count_a * 100.0 / (pass_count_a + fail_count_a)) : 0);
      $display("Total Passes (Port B): %0d", pass_count_b);
      $display("Total Failures (Port B): %0d", fail_count_b);
      $display("Pass Rate (Port B): %0.2f%%", (pass_count_b + fail_count_b) ? (pass_count_b * 100.0 / (pass_count_b + fail_count_b)) : 0);
      $display("Total Transactions: %0d", pass_count_a + fail_count_a + pass_count_b + fail_count_b);
      $display("Pass Rate: %0.2f%%", (pass_count_a + fail_count_a + pass_count_b + fail_count_b) ? ((pass_count_a + pass_count_b) * 100.0 / (pass_count_a + fail_count_a + pass_count_b + fail_count_b)) : 0);
      $display("Fail Rate: %0.2f%%", (pass_count_a + fail_count_a + pass_count_b + fail_count_b) ? ((fail_count_a + fail_count_b) * 100.0 / (pass_count_a + fail_count_a + pass_count_b + fail_count_b)) : 0);
      $display("==========================");
  endfunction

  function void check_transaction(transaction tr, ref int pass_count, ref int fail_count,ref int index);


    if (tr.addr >= `MEMORY_DEPTH) begin
        	$error("Error: Address out of bounds: %0h", tr.addr);
          fail_count++;
          return;
    end

    if (tr.we) begin
      memory[tr.addr] = tr.data;
      if (debug_enabled)
        $display("Write successful to address %0h with data %0h", tr.addr, tr.data);
      index++;
      pass_count++;
    end
    else begin
      index++;
      assert (memory[tr.addr] == tr.data) begin
        if (debug_enabled)
          $display("read successful to address %0h with data %0h", tr.addr, tr.data);
        pass_count++;
      end
      else begin
        $error("Read mismatch at address %0h: expected %0h, got %0h", tr.addr, memory[tr.addr], tr.data);
        fail_count++;
      end
    end

  endfunction
  endclass : scb