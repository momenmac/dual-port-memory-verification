`include "defines.sv"
class generator;
  	string port_name;
    mailbox gen2drv;
    transaction tr;
    transaction tmp;
    int addr;
    generator_state state;
    int index = 0;
    
  	function new(string port_name = "");
      	this.port_name= port_name;
        this.tr = new();
        this.state = ENABLED;
    endfunction

    virtual function void configure_generator(generator_state state = ENABLED);
        this.state = state;
    endfunction

    virtual task run();
    if(state == ENABLED)begin
        int count = TestRegistry::get_int("NoOfTransactions");
      $display("%d : numeber of transactions", count);
        repeat (count) begin
            randomize_transaction();
            write();
            read();
            index++;
        end
    end
    endtask

    task randomize_transaction();
        assert (tr.randomize()) else begin
            $error("[Gen] Randomization failed for transaction");
            return;
        end
    endtask

    virtual task write();
        tr.we = 1'b1; 
        tmp = new();
        tmp.copy(tr);
        tmp.print(port_name,"Generator", "Write Transaction", index);
        addr = tr.addr;
        gen2drv.put(tmp);

    endtask


    virtual task read();
        tr.we = 1'b0;
        tmp = new();
        tmp.copy(tr);
        tmp.print(port_name,"Generator", "Read Transaction", index);
        gen2drv.put(tmp);
    endtask

    virtual task read_all_memory(int read_delay = -1);
        for(int i = 0; i < `MEMORY_SIZE; i++) begin
            randomize_transaction();
            tr.addr = i;
            if (read_delay >= 0)
                tr.delay = read_delay;
            read();
        end
    endtask

    virtual task write_all_memory(int write_delay = -1);
        for(int i = 0; i < `MEMORY_SIZE; i++) begin
            randomize_transaction();
            tr.addr = i;
            if (write_delay >= 0)
                tr.delay = write_delay;
            write();
        end
    endtask

endclass : generator