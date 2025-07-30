class reset_behavior_gen extends generator;
  	event reset_event;

    virtual dut_if vif;
    int reset_delay;
    int counter, transaction_count;

    function new();
        super.new();
        this.counter = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
        repeat (counter) begin
            reset_delay = $urandom_range(1, 50);
            transaction_count = $urandom_range(1, 64);
                repeat (reset_delay) begin
                        randomize_transaction();
                        write();
                    end 
                  repeat (reset_delay) @(posedge vif.clk);
                  ->reset_event;

                read_all_memory();
        end
    endtask
endclass
