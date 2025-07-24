class agent;
    mailbox gen2drv;
    mailbox mon2scb;
    generator gen;
    driver drv;
    monitor mon;
    virtual dut_if vif;
    coverage_collector cov_collector;

    function new();
        this.gen2drv = new(1);
        this.gen = new();
        this.drv = new();
        this.mon = new();
    endfunction;

    function build();
        gen.gen2drv = this.gen2drv;
        drv.gen2drv = this.gen2drv;
        mon.mon2scb = this.mon2scb;
        mon.cov_collector = this.cov_collector;

        drv.vif = this.vif;
        mon.vif = this.vif;
    endfunction;

    virtual task run();
        fork
            gen.run();
            mon.run();
            drv.run();
        join_none
    endtask;
endclass : agent