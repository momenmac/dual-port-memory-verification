class scb;

    mailbox mon2scb_a;
    mailbox mon2scb_b;
    int pass_count = 0;
    int fail_count = 0;
  
  task run();
    $display("SCB is running");
    
    forever begin
      transaction item;
      mon2scb_a.get(item);
    end
  endtask
    
    function void report_statistics();
        $display("Pass Count: %0d", pass_count);
        $display("Fail Count: %0d", fail_count);
    endfunction
    
endclass : scb