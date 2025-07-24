class agent;
    mailbox gen2drv;
    mailbox mon2scb;
    generator gen;
    driver drv;
    monitor mon;
    virtual dut_if vif;

    function new();
        this.gen2drv = new();
        this.gen = new();
        this.drv = new();
        this.mon = new();
    endfunction;

    function build();
        gen.gen2drv = gen2drv;
        drv.gen2drv = gen2drv;
        mon.mon2scb = mon2scb;

        gen.drv_done = drv_done;
        drv.drv_done = drv_done;

        drv.vif = vif;
        mon.vif = vif;
    endfunction;

    virtual task run();
        fork
            gen.run();
            mon.run();
            drv.run();
        join_none
    endtask;
endclass : agent