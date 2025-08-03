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
    
    int collision_count = 0;

    transaction correct_data;
    
    transaction active_start_a, active_start_b;
    transaction pending_end_a, pending_end_b;
    time start_time_a = 0, start_time_b = 0;
    bit transaction_active_a = 0, transaction_active_b = 0;
    bit collision_detected_a = 0, collision_detected_b = 0;
    int collision_window = 0;
    
    // Bypass storage for collision handling
    bit [`DATA_WIDTH - 1:0] bypass_data;
    bit [`ADDR_WIDTH - 1:0] bypass_addr;
    bit bypass_active = 0; 
  
    function void reset ();
      for (int i = 0; i < `MEMORY_DEPTH; i++) begin
            memory[i] <= 0;
        end
    endfunction
  
  function new();
    this.debug_enabled = TestRegistry::get_int("DebugEnabled");
    this.active_start_a = null;
    this.active_start_b = null;
    this.pending_end_a = null;
    this.pending_end_b = null;
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
          check_enhanced_collision(item_a, "Port_A");
        end
      end

      begin
        forever begin
          transaction item_b;
          mon2scb_b.get(item_b);
          tag_b = item_b.we ? "Write" : "Read";
          tag_b = $sformatf("Transaction (%s)", tag_b);
          item_b.print("Port_B", "ScoreBoard", tag_b, index_b);
          check_enhanced_collision(item_b, "Port_B");
        end
      end

      begin
        @(negedge vif.rst_n);
        if (debug_enabled)
          $display("SCB reset started");
        reset();
        if (debug_enabled)
          $display("SCB reset complete");
      end
    join_any
    disable fork;
    end
  endtask
    
  function void check_enhanced_collision(transaction tr, string port_name);
    time current_time = $time;
    
    if (port_name == "Port_A") begin
      if (tr.is_start) begin
        active_start_a = tr;
        start_time_a = current_time;
        transaction_active_a = 1;
        collision_detected_a = 0;
        check_collision_between_ports();
        
      end else begin
        pending_end_a = tr;
        
        if (collision_detected_a) begin
          handle_collision_end(tr, active_start_a, active_start_b, "Port_A", "Port_B");
          collision_detected_a = 0;
        end else begin
          check_transaction(tr, pass_count_a, fail_count_a, index_a, port_name);
        end
        
        transaction_active_a = 0;
      end
      
    end else begin 
      if (tr.is_start) begin
        active_start_b = tr;
        start_time_b = current_time;
        transaction_active_b = 1;
        collision_detected_b = 0;
        
        check_collision_between_ports();
        
      end else begin
        pending_end_b = tr;
        
        if (collision_detected_b) begin
          handle_collision_end(tr, active_start_b, active_start_a, "Port_B", "Port_A");
          collision_detected_b = 0;
        end else begin
          check_transaction(tr, pass_count_b, fail_count_b, index_b, port_name);
        end
        transaction_active_b = 0;
      end
    end
  endfunction
  
  function void check_collision_between_ports();
    if (transaction_active_a && transaction_active_b && 
        active_start_a.addr == active_start_b.addr && 
        active_start_a.we != active_start_b.we) begin

        // Check for collision - either exact same time or overlapping transactions
        bit collision_detected = 0;
        
        // Case 1: Exact simultaneous start (true collision)
        if (start_time_a == start_time_b) begin
          collision_detected = 1;
          if(debug_enabled)
            $display("SIMULTANEOUS READ-WRITE COLLISION DETECTED at address %0h", active_start_a.addr);
        end
        // Case 2: Overlapping transactions (one starts while other is active)
        else begin
          collision_detected = 1;
          if(debug_enabled)
            $display("OVERLAPPING READ-WRITE DETECTED at address %0h: times %0t vs %0t", 
                    active_start_a.addr, start_time_a, start_time_b);
        end
        
        if (collision_detected) begin
          collision_count++;
          collision_detected_a = 1;
          collision_detected_b = 1;

          if(debug_enabled) begin
            $display("READ-WRITE COLLISION DETECTED at address %0h: Port_A(%s) vs Port_B(%s)", 
                    active_start_a.addr, active_start_a.we ? "Write" : "Read", active_start_b.we ? "Write" : "Read");
            if (active_start_a.we) begin
              $display("WRITE-READ COLLISION: Port_A write takes priority");
            end else begin
              $display("READ-WRITE COLLISION: Port_B write takes priority");
            end
          end
        end
    end
  endfunction
  
  function void handle_collision_end(transaction end_tr, transaction my_start, transaction other_start, string my_port, string other_port);
    
    if (my_start.we && !other_start.we) begin
      if(debug_enabled)
        $display("[%t] COLLISION END: %s write updating memory, %s read will get written value", $time, my_port, other_port);

      memory[my_start.addr] = my_start.data;
      if (debug_enabled)
        $display("<%s> Write successful to address %0h with data %0h", my_port, my_start.addr, my_start.data);
      
      if (my_port == "Port_A") begin
        pass_count_a++;
        index_a++;
      end else begin
        pass_count_b++;
        index_b++;
      end
      
    end else if (!my_start.we && other_start.we) begin
      if(debug_enabled)
        $display("[%t] COLLISION END: %s read getting value from %s write", $time, my_port, other_port);

      memory[other_start.addr] = other_start.data;
      
      correct_data = new();
      correct_data.copy(end_tr);
      correct_data.data = other_start.data; 
      
      if (my_port == "Port_A") begin
        check_transaction(correct_data, pass_count_a, fail_count_a, index_a, my_port);
      end else begin
        check_transaction(correct_data, pass_count_b, fail_count_b, index_b, my_port);
      end
    end
  endfunction
  
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
      $display("Collision Statistics:");
      $display("Total Read-Write Collisions: %0d", collision_count);
      $display("==========================");
  endfunction

  function void check_transaction(transaction tr, ref int pass_count, ref int fail_count,ref int index, input string port_name = "");

    if (tr.addr >= `MEMORY_DEPTH) begin
        	$display("Error: %s Address out of bounds: %0h", port_name, tr.addr);
          fail_count++;
          return;
    end

    if (tr.we) begin
      // Only update memory for write END transactions, not START transactions
      if (!tr.is_start) begin
        memory[tr.addr] = tr.data;
        if (debug_enabled)
          $display("<%s> Write successful to address %0h with data %0h", port_name, tr.addr, tr.data);
        index++;
        pass_count++;
      end
    end
    else begin
      // For read transactions, check against current memory value
      if (!tr.is_start) begin
        index++;
        assert (memory[tr.addr] == tr.data) begin
          if (debug_enabled)
            $display("<%s> Read successful to address %0h with data %0h", port_name, tr.addr, tr.data);
          pass_count++;
        end
        else begin
          $error("<%s> Read mismatch at address %0h: expected %0h, got %0h", port_name, tr.addr, memory[tr.addr], tr.data);
          fail_count++;
        end
      end
    end

  endfunction
  endclass : scb