`define MEMORY_DEPTH 49152
`define DATA_WIDTH 32
`define ADDR_WIDTH 16



typedef enum  { write_read_a, write_read_b, write_a_read_b, write_b_read_a, write_same_address, empty_memory_read, fill_memory, 
    reset_behavior, simultaneous_write, simultaneous_read, read_after_write_same_address, write_collision, out_of_range_access,
    back_to_back_writes, back_to_back_reads, back_to_back_transactions, address_boundaries,
    delays } test_name;

typedef enum {DISABLED, ENABLED} generator_state;
