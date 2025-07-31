import project_pkg::*;

class test;
    string name;
    env e0;

    function new(string n = "basic_test");
        this.name = n;
        e0 = new();
    endfunction

    virtual task run();

        configure_test();
        e0.build();


        fork
            e0.run();
        join
        #1000;
      	 e0.report_coverage();
      $finish;
      
      
       
    endtask

    virtual task configure_test();
      
    endtask
endclass;