`include "basic_test.sv"
`include "write_read_tests.sv"
`include "memory_fill_tests.sv"
// Include other test files

class test_factory;
    static function test create_test(test_name test_case);
        test t;

        case(test_case)
        write_read_a: t = new write_read_a_test();
        write_read_b: t = new write_read_b_test();
        endcase
        
        return t;
    endfunction
endclass
