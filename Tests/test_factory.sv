class test_factory;
  static function test create_test(string test_name);
        test t;
    

    case(test_name)
          "write_read_a": t = write_read_a_test::new();
          "write_read_b": t = write_read_b_test::new();
            
            default: t= new();
        endcase
        
        return t;
    endfunction
endclass
