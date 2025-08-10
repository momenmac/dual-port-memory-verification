# Dual Port Memory Verification Testbench

A comprehensive SystemVerilog testbench for verifying dual-port memory functionality using object-oriented verification methodology.

## 🎯 Overview

This project implements a complete verification environment for a dual-port memory (DPM) design. The testbench follows modular architecture principles with transaction-based stimulus generation, configurable test scenarios, and systematic verification approach.

### Key Features

- **Dual-Port Memory Design**: 64x8-bit memory with independent read/write ports
- **Object-Oriented Architecture**: Modular testbench with transaction-level modeling
- **Comprehensive Test Suite**: 20+ test scenarios covering various edge cases
- **Advanced Features**: Handshake protocol support with valid/ready signals
- **Configurable**: Parameterized design with easy test configuration
- **Systematic Verification**: Built-in scoreboard and coverage tracking

## 🏗️ Architecture

### Design Under Test (DUT)

```systemverilog
Module: dpram
- Memory Size: 64 locations × 8 bits
- Dual independent ports (A & B)
- Handshake protocol (valid/ready)
- Synchronous reset
- Clock domain: Single clock
```

### Testbench Components

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                              TEST ENVIRONMENT                                   │
├─────────────────────────────────────────────────────────────────────────────────┤
│                                                                                 │
│  ┌─────────────────────────────┐       ┌─────────────────────────────┐         │
│  │         AGENT A             │       │         AGENT B             │         │
│  │  ┌─────────┐  ┌─────────┐   │       │   ┌─────────┐  ┌─────────┐  │         │
│  │  │Generator│  │ Driver  │   │       │   │Generator│  │ Driver  │  │         │
│  │  │    A    │  │    A    │   │       │   │    B    │  │    B    │  │         │
│  │  └─────────┘  └─────────┘   │       │   └─────────┘  └─────────┘  │         │
│  │       │            │        │       │        │            │       │         │
│  │  ┌─────────┐       │        │       │        │       ┌─────────┐  │         │
│  │  │ Monitor │       │        │       │        │       │ Monitor │  │         │
│  │  │    A    │       │        │       │        │       │    B    │  │         │
│  │  └─────────┘       │        │       │        │       └─────────┘  │         │
│  └──────────┼─────────┼────────┘       └────────┼─────────┼──────────┘         │
│             │         │                         │         │                    │
│             │         │                         │         │                    │
│  ┌──────────▼─────────▼─────────────────────────▼─────────▼──────────┐         │
│  │                      SCOREBOARD                                    │         │
│  │           (Collects data from both monitors)                       │         │
│  └─────────────────────────────┬───────────────────────────────────────┘         │
│                                │                                               │
│  ┌─────────────────────────────▼───────────────────────────────────────┐         │
│  │                         COVERAGE                                    │         │
│  │              (Functional & Cross Coverage)                          │         │
│  └─────────────────────────────────────────────────────────────────────┘         │
└───────────────────────────┬─────────────────┬───────────────────────────────────┘
                            │                 │
                    ┌───────▼───────┐ ┌───────▼───────┐
                    │  Interface A  │ │  Interface B  │
                    │  (Port A)     │ │  (Port B)     │
                    └───────┬───────┘ └───────┬───────┘
                            │                 │
                            └────────┬────────┘
                                     │
                            ┌────────▼────────┐
                            │   DUAL PORT     │
                            │     MEMORY      │
                            │    (dpram)      │
                            │                 │
                            │ Port A | Port B │
                            └─────────────────┘
```

## 📁 Project Structure

```
dual-port-memory-verification/
├── RTL/
│   └── dpm.sv                     # Dual-port memory RTL design
├── TB/                            # Testbench components
│   ├── defines.sv                 # Global definitions and parameters
│   ├── interface.sv               # DUT interface
│   ├── project_pkg.sv             # Package with all TB components
│   ├── transaction.sv             # Transaction class
│   ├── driver.sv                  # Driver component
│   ├── monitor.sv                 # Monitor component
│   ├── scoreboard.sv              # Scoreboard component
│   ├── generator.sv               # Base generator class
│   ├── agent.sv                   # Agent component
│   ├── enviroment.sv              # Test environment
│   ├── coverage.sv                # Coverage collector
│   ├── test_registry.sv           # Test configuration registry
│   ├── extended_generators.sv     # Extended generator classes
│   ├── tb.sv                      # Main testbench
│   └── top_tb.sv                  # Top-level testbench
├── Tests/                         # Test scenarios
│   ├── basic_test.sv              # Basic test template
│   ├── test_factory.sv            # Test factory implementation
│   ├── write_read_tests.sv        # Write-read test base
│   ├── 01_write_read_a/           # Port A write-read tests
│   ├── 02_write_read_b/           # Port B write-read tests
│   ├── 03_write_a_read_b/         # Cross-port tests A→B
│   ├── 04_write_b_read_a/         # Cross-port tests B→A
│   ├── 05_write_same_address/     # Same address write tests
│   ├── 06_empty_mem_read/         # Empty memory read tests
│   ├── 07_fill_memory/            # Memory fill tests
│   └── 08_reset_behavior/         # Reset behavior tests
├── Docs/
│   ├── run_sim.sh                 # Simulation script
│   └── structure.png              # Architecture diagram
├── Dual Port Memory Test Plan - Sheet1.csv  # Test plan spreadsheet
└── README.md                      # This file
```

## 🧪 Test Plan & Coverage

### Completed Tests ✅

| Test Case                     | Description                                        | Status   | Result  |
| ----------------------------- | -------------------------------------------------- | -------- | ------- |
| **write_read_a**              | Basic write/read operations on port A             | ✅ Done  | ✅ Pass |
| **write_read_b**              | Basic write/read operations on port B             | ✅ Done  | ✅ Pass |
| **write_a_read_b**            | Write port A, read port B (cross-port)            | ✅ Done  | ✅ Pass |
| **write_b_read_a**            | Write port B, read port A (cross-port)            | ✅ Done  | ✅ Pass |
| **write_same_address**        | Multiple writes to same address                    | ✅ Done  | ✅ Pass |
| **empty_mem_read**            | Read from uninitialized memory                    | ✅ Done  | ✅ Pass |
| **fill_memory**               | Fill entire memory space                          | ✅ Done  | ✅ Pass |
| **reset_behavior**            | Reset functionality verification                   | ✅ Done  | ✅ Pass |
| **simultaneous_write**        | Concurrent writes on different ports              | ✅ Done  | ✅ Pass |
| **simultaneous_read**         | Concurrent reads on different ports               | ✅ Done  | ✅ Pass |
| **sim_write_a_read_b**        | Simultaneous write port A, read port B           | ✅ Done  | ✅ Pass |
| **sim_write_b_read_a**        | Simultaneous write port B, read port A           | ✅ Done  | ✅ Pass |
| **write_collision**           | Write collision arbitration                       | ✅ Done  | ✅ Pass |
| **read_collision**            | Read collision handling                           | ✅ Done  | ✅ Pass |
| **out_of_range_access**       | Out-of-bounds address handling                    | ✅ Done  | ✅ Pass |
| **back_to_back_writes**       | Consecutive write operations (Port A & B)        | ✅ Done  | ✅ Pass |
| **back_to_back_reads**        | Consecutive read operations (Port A & B)         | ✅ Done  | ✅ Pass |
| **back_to_back_transactions** | Mixed consecutive operations                      | ✅ Done  | ✅ Pass |

## 🚀 Getting Started

### Prerequisites

- SystemVerilog simulator (ModelSim, Questa, VCS, Xcelium, or any SystemVerilog-compatible simulator)
- Basic SystemVerilog knowledge

### Running Simulations

1. **Clone the repository:**

   ```bash
   git clone <repository-url>
   cd dual-port-memory-verification
   ```

2. **Run basic simulation:**

   ```bash
   cd Docs
   chmod +x run_sim.sh
   ./run_sim.sh
   ```

3. **Run specific test:**

   ```bash
   # Example: Run write_read_a test
   vsim -do "run -all" +test_name=write_read_a top_tb
   ```

4. **EDA Playground:**
   - Visit: [EDA Playground Link](https://edaplayground.com/x/NGYh)
   - All testbench files are pre-loaded
   - Select your preferred simulator
   - Click "Run" to execute

### Configuration

Modify test parameters in `test_registry.sv`:

```systemverilog
TestRegistry::set_int("NoOfTransactions", 100);  // Number of transactions
TestRegistry::set_string("test_name", "write_read_a");  // Test selection
```

#### Test-Specific Configurations

Different tests use different transaction counts based on their complexity:

```bash
# High-intensity tests (100,000 transactions)
+test=write_read_a +NoTransactions=100000
+test=simultaneous_write +NoTransactions=100000
+test=back_to_back_writes +NoTransactions=100000

# Medium-intensity tests (10,000 transactions)  
+test=write_same_address +NoTransactions=10000
+test=empty_mem_read +NoTransactions=10000

# Low-intensity tests (5-10 transactions)
+test=fill_memory +NoTransactions=5
+test=reset_behavior +NoTransactions=10

# Port selection for back-to-back tests
+GenSelected=0  # Port A
+GenSelected=1  # Port B
```

## 🔧 Key Features

### 1. Transaction-Level Modeling

```systemverilog
class transaction;
    rand logic [`DATA_WIDTH-1:0] data;
    rand logic [`ADDR_WIDTH-1:0] addr;
    rand logic we;
    // ... additional fields
endclass
```

### 2. Handshake Protocol Support

The DUT implements valid/ready handshake:

- `valid_a/valid_b`: Indicates valid data from testbench
- `ready_a/ready_b`: Indicates DUT ready to accept transaction

### 3. Configurable Test Environment

- Parameterized memory size and width
- Configurable transaction counts
- Multiple test scenarios via test factory

### 4. Object-Oriented Verification Features

- **Scoreboard**: Automatic checking of expected vs actual results
- **Coverage**: Functional coverage collection
- **Monitor**: Protocol compliance checking
- **Agent**: Encapsulated driver-monitor pairs
- **Transaction Class**: Object-oriented stimulus generation

## 📊 Verification Metrics

### Current Status
- **Tests Completed**: 18/20 (90%)
- **Tests Passed**: 18/18 (100%)
- **Tests Cancelled**: 2/20 (10%)

### Known Issues
Based on testing, the following issues were identified:

#### Port A Write/Read Test:
- `ready_a` is high but `rd_data_a` shows XXXX initially
- Memory has 1 cycle read delay: ready=1, valid=1 but data comes next cycle

#### Simultaneous Write B Read A Test:
- When port B writes and port A reads same address simultaneously, port A gets old value instead of new one

#### Out of Range Access Test:
- Out-of-range memory access corrupts valid addresses

### Coverage Goals

- **Functional Coverage**: 95%+ coverage of all defined coverpoints
- **Code Coverage**: 100% line/branch coverage
- **Cross Coverage**: Port interactions and address combinations

### Success Criteria

- ✅ All implemented tests pass (18/18)
- ⚠️ Some protocol violations identified and documented
- 🔄 Coverage goals in progress
- ⚠️ Memory corruption issues documented for out-of-range access

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/new-test`)
3. Implement your test following the existing patterns
4. Add to test plan CSV
5. Submit pull request

### Adding New Tests

1. Create test directory in `Tests/`
2. Implement generator class extending `generator`
3. Implement test class extending appropriate base
4. Register in `test_factory.sv`
5. Update test plan

## 📝 Test Plan Status

**Current implementation status: 18/20 tests completed (90%)**
- **Passed**: 18 tests ✅
- **Cancelled**: 2 tests (address_boundaries, delays) ❌
- **Success Rate**: 100% for completed tests

See `Dual Port Memory Test Plan - Sheet1.csv` for detailed test descriptions, run options, and identified bugs.

### Test Execution Examples

```bash
# Basic port A write/read test
vsim +test=write_read_a +NoTransactions=100000 -l output.log +DebugEnabled=0

# Simultaneous operations test
vsim +test=simultaneous_write +NoTransactions=100000 -l output.log +DebugEnabled=0

# Back-to-back operations with port selection
vsim +test=back_to_back_writes +NoTransactions=100000 -l output.log +DebugEnabled=0 +GenSelected=0
```

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🎓 Learning Resources

- [SystemVerilog Fundamentals](https://www.asicworld.com/systemverilog/index.html)
- [ChipVerify SystemVerilog Tutorials](https://www.chipverify.com/systemverilog)
- [SystemVerilog Testbench Guide](https://verificationguide.com/systemverilog/)
- [EDA Playground - Online SystemVerilog Simulator](https://edaplayground.com/)
- [Memory Design and Verification Concepts](https://www.design-reuse.com/)

## Support

For questions or issues:

- Check the EDA Playground link for live simulation: [https://edaplayground.com/x/NGYh](https://edaplayground.com/x/NGYh)
- Review test plan CSV for verification strategy
- Examine individual test files in Tests/ directory for implementation examples

---

**Note**: This is an educational/demonstration project. The RTL design serves as a reference implementation for verification methodology showcase.
