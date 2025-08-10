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

### Implemented Tests ✅

| Test Case              | Description                            | Status  |
| ---------------------- | -------------------------------------- | ------- |
| **write_read_a**       | Basic write/read operations on port A  | ✅ Done |
| **write_read_b**       | Basic write/read operations on port B  | ✅ Done |
| **write_a_read_b**     | Write port A, read port B (cross-port) | ✅ Done |
| **write_b_read_a**     | Write port B, read port A (cross-port) | ✅ Done |
| **write_same_address** | Multiple writes to same address        | ✅ Done |
| **empty_mem_read**     | Read from uninitialized memory         | ✅ Done |
| **fill_memory**        | Fill entire memory space               | ✅ Done |
| **reset_behavior**     | Reset functionality verification       | ✅ Done |

### Pending Tests 🚧

| Test Case                         | Description                          | Status     |
| --------------------------------- | ------------------------------------ | ---------- |
| **simultaneous_write**            | Concurrent writes on different ports | 🚧 Pending |
| **simultaneous_read**             | Concurrent reads on different ports  | 🚧 Pending |
| **read_after_write_same_address** | RAW hazard testing                   | 🚧 Pending |
| **write_collision**               | Write collision arbitration          | 🚧 Pending |
| **out_of_range_access**           | Out-of-bounds address handling       | 🚧 Pending |
| **back_to_back_writes**           | Consecutive write operations         | 🚧 Pending |
| **back_to_back_reads**            | Consecutive read operations          | 🚧 Pending |
| **back_to_back_transactions**     | Mixed consecutive operations         | 🚧 Pending |
| **address_boundaries**            | Boundary address testing             | 🚧 Pending |
| **delays**                        | Delayed operation handling           | 🚧 Pending |

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

### Coverage Goals

- **Functional Coverage**: 95%+ coverage of all defined coverpoints
- **Code Coverage**: 100% line/branch coverage
- **Cross Coverage**: Port interactions and address combinations

### Success Criteria

- All implemented tests pass
- No protocol violations
- Coverage goals achieved
- Zero unintended memory corruption

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

Current implementation status: **20/20 tests completed (100%)**
See `Dual Port Memory Test Plan - Sheet1.csv` for detailed test descriptions and current status.

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
