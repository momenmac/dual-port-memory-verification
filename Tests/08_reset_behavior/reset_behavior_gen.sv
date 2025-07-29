class reset_behavior_gen extends generator;
  	event reset_event;

    virtual dut_if vif;
    int reset_delay;
    int count;

    function new();
        super.new();
        this.count = TestRegistry::get_int("NoOfTransactions");
    endfunction

    virtual task run();
        repeat (count) begin
            reset_delay = $urandom_range(1, 50);
            fork : reset_fork
                begin
                    forever begin
                        randomize_transaction();
                        write();
                    end 
                end
                begin
                  repeat (reset_delay) @(posedge vif.clk);
                  ->reset_event;
                end
            join_any
            disable reset_fork;
            for(int i = 0; i < `MEMORY_SIZE; i++) begin
                randomize_transaction();
                tr.addr = i;
                read();
            end
        end
    endtask
endclass
