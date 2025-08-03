class monitor;
  	string port_name;
    virtual dut_if vif;
    mailbox mon2scb;
    int index = 0;
    time collision_window = 0;
//     coverage_collector cov_collector;
  
    function new (string port_name = "");
      this.port_name = port_name;
    endfunction

    task run();
//         $display ("T=%0t [MON] starting ...", $time);
        forever begin
            transaction tr_start = new();
            transaction tr_end = new();
            
            @(posedge vif.clk iff vif.valid);
            tr_start.we = vif.we;
            tr_start.addr = vif.addr;
            tr_start.data = vif.data;
            tr_start.is_start = 1; 
            
            if(vif.we) begin
                tr_start.print(port_name,"Monitor", "Transaction (Write)", index);
            end else begin
                tr_start.print(port_name,"Monitor", "Transaction (Read)", index);
            end
            
            mon2scb.put(tr_start);
            
            if (vif.ready) begin
                tr_end.we = vif.we;
                tr_end.addr = vif.addr;
                tr_end.is_start = 0; 

                if(vif.we) begin
                    tr_end.data = vif.data;
                    tr_end.print(port_name,"Monitor", "Transaction (Write)", index);
                end else begin
                    tr_end.data = vif.q; 
                    tr_end.print(port_name,"Monitor", "Transaction (Read)", index);
                end
                
                index++;
                mon2scb.put(tr_end);
            end else begin
                @(posedge vif.clk iff (vif.valid && vif.ready));
                tr_end.we = vif.we;
                tr_end.addr = vif.addr;
                tr_end.is_start = 0; 

                if(vif.we) begin
                    tr_end.data = vif.data;
                    tr_end.print(port_name,"Monitor", "Transaction (Write)", index);
                end else begin
                    tr_end.data = vif.q; 
                    tr_end.print(port_name,"Monitor", "Transaction (Read)", index);
                end
                
                index++;
                mon2scb.put(tr_end);
            end
//                 cov_collector.sample(tr);
        end
    endtask
    
endclass: monitor