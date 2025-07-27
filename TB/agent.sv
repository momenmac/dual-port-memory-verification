class agent;
  	string port_name;
    mailbox gen2drv;
    mailbox mon2scb;
    generator gen;
    driver drv;
    monitor mon;
    virtual dut_if vif;
//     coverage_collector cov_collector;

  function new(string port_name = "");
    	this.port_name = port_name;
        this.gen2drv = new(1);
        this.gen = new(port_name);
        this.drv = new(port_name);
        this.mon = new(port_name);
    endfunction

    function void set_generator(generator g);
        this.gen = g;
    endfunction

    function void build();
        gen.gen2drv = this.gen2drv;
        drv.gen2drv = this.gen2drv;
        mon.mon2scb = this.mon2scb;
      
      	this.gen.port_name = this.port_name;
        this.drv.port_name = this.port_name;
      	this.mon.port_name = this.port_name;

//         mon.cov_collector = this.cov_collector;

        drv.vif = this.vif;
        mon.vif = this.vif;
    endfunction

    virtual task run();
        fork
            gen.run();
            mon.run();
            drv.run();
        join_any
      $display("%s agent ended :**************************** [%t] ",port_name, $time);
    endtask
endclass : agent