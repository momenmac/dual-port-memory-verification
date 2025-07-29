class env;
    agent agent_a;
    agent agent_b;
    scb scb_inst;
    virtual dut_if vif_a;
    virtual dut_if vif_b;
    mailbox mon2scb_a;
    mailbox mon2scb_b;
//     coverage_collector cov_collector;

    function new();
      	this.agent_a = new("Port A");
      	this.agent_b = new("Port B");
        this.scb_inst = new();
        this.mon2scb_a = new();
        this.mon2scb_b = new();
//         this.cov_collector = new();
    endfunction

    function void build();
        agent_a.vif = this.vif_a;
        agent_b.vif = this.vif_b;

        agent_a.mon2scb = this.mon2scb_a;
        agent_b.mon2scb = this.mon2scb_b;

        scb_inst.mon2scb_a = this.mon2scb_a;
        scb_inst.mon2scb_b = this.mon2scb_b;
      	scb_inst.vif = vif_a;

//         agent_a.cov_collector = this.cov_collector;
//         agent_b.cov_collector = this.cov_collector;

        agent_a.build();
        agent_b.build();
    endfunction

    virtual task run();
      fork 
        begin
            fork
              agent_a.run();
              agent_b.run();
        	join
        end
        
		scb_inst.run();


      join_any

    endtask

    function void report_coverage();
//         cov_collector.report_coverage();
        scb_inst.report_statistics();
    endfunction

endclass : env