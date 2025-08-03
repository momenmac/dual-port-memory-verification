class back_to_back_transactions_test extends test;
  	back_to_back_transactions_gen gen_1;
  	back_to_back_transactions_gen gen_2;

    function new(string name = "back_to_back_transactions_test");
        super.new(name);
    	gen_1 = new();
    	gen_2 = new();
    endfunction

    virtual task configure_test();
        e0.agent_a.set_generator(gen_1);
        e0.agent_b.set_generator(gen_2);
    endtask
endclass