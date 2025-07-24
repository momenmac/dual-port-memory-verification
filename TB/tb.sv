module tb;
    logic clk;
    logic rst_n;
    string test_case_string;

    dut_if port_a_interface(clk, rst_n);
    dut_if port_b_interface(clk, rst_n);

    dpram dut (
        .data_a(port_a_interface.data),
        .data_b(port_b_interface.data),
        .addr_a(port_a_interface.addr),
        .addr_b(port_b_interface.addr),
        .we_a(port_a_interface.we),
        .we_b(port_b_interface.we),
        .clk(clk),
        .rst_n(rst_n),
        .valid_a(port_a_interface.valid),
        .valid_b(port_b_interface.valid),
        .ready_a(port_a_interface.ready),
        .ready_b(port_b_interface.ready),
        .q_a(port_a_interface.q),
        .q_b(port_b_interface.q)
    );

    initial begin
        rst_n = 1'b1;
        clk =0;
        forever #5 clk = ~clk;
    end

    task system_reset();
        rst_n = 1'b0;
        repeat (5) @(posedge clk);
        rst_n = 1'b1;
    endtask

    initial begin
        test_name test_case;
        test t;

        if($value$plusargs("test=%s", test_case_string)) begin
            test_case = test_name'(test_case_string);
            $display("Running test case: %s", test_case.name());
        end else begin
            $display("No test case specified, running default test.");
            test_case = write_read_a;
        end
    end

endmodule : tb