class scb;

    mailbox mon2scb_a;
    mailbox mon2scb_b;
    int pass_count;
    int fail_count;

    // scoreboard class to verify the correctness of transactions

    function void report_statistics();
        $display("Pass Count: %0d", pass_count);
        $display("Fail Count: %0d", fail_count);
    endfunction
    
endclass : scb