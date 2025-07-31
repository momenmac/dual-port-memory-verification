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
      "simultaneous_write": t = simultaneous_write_test::new();
      "simultaneous_read": t = simultaneous_read_test::new();
      "sim_write_a_read_b": t = sim_write_a_read_b_test::new();
      "sim_write_b_read_a": t = sim_write_b_read_a_test::new();
      "write_collision": t = write_collision_test::new();
      "read_collision": t = read_collision_test::new();
      "out_of_range_access": t = out_of_range_access_test::new();
      "back_to_back_writes": t = back_to_back_writes_test::new();
      default: t= new();
    endcase
    return t;
  endfunction
endclass
