class env;
    agent agent_a;
    agent agent_b;
    scoreboard scb;
    virtual dut_if vif_a;
    virtual dut_if vif_b;
    mailbox mon2scb_a;
    mailbox mon2scb_b;
    coverage_collector cov_collector;

    function new();
        this.agent_a = new();
        this.agent_b = new();
        this.scb = new();
        this.mon2scb_a = new();
        this.mon2scb_b = new();
        this.cov_collector = new();
    endfunction;

    function build();
        agent_a.vif = this.vif_a;
        agent_b.vif = this.vif_b;

        agent_a.mon2scb = this.mon2scb_a;
        agent_b.mon2scb = this.mon2scb_b;

        scb.mon2scb_a = this.mon2scb_a;
        scb.mon2scb_b = this.mon2scb_b;

        agent_a.cov_collector = this.cov_collector;
        agent_b.cov_collector = this.cov_collector;

        agent_a.build();
        agent_b.build();
    endfunction

    virtual task run();
        fork
            scb.run();
            agent_a.run();
            agent_b.run();
        join_any
    endtask

    function void report_coverage();
        cov_collector.report_coverage();
        scb.report_statistics();
    endfunction

endclass : env