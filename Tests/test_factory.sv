class test_factory;
  static function test create_test(string test_name);
        test t;
    

    case(test_name)
          "write_read_a": t = write_read_a_test::new();
          "write_read_b": t = write_read_b_test::new();
      	  "write_a_read_b": t = write_a_read_b_test::new();
          "write_b_read_a": t = write_b_read_a_test::new();
          "write_same_address": t = write_same_address_test::new();
          "empty_mem_read": t = empty_mem_read_test::new();
          "fill_memory": t = fill_memory_test::new();
          "reset_behavior": t = reset_behavior_test::new();

            default: t= new();
        endcase
        
        return t;
    endfunction
endclass
