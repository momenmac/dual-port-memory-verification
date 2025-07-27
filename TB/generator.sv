`include "defines.sv"
class generator;
  	string port_name;
    mailbox gen2drv;
    transaction tr;
    transaction tmp;
    int addr;
    generator_state state;
    
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
      	tmp.print(port_name,"Generator", "Write Transaction");
        addr = tr.addr;
        gen2drv.put(tmp);
    endtask


    virtual task read();
        tr.we = 1'b0;
        tmp = new();
        tmp.copy(tr);
      tmp.print(port_name,"Generator", "Read Transaction");
        gen2drv.put(tmp);
    endtask

endclass : generator