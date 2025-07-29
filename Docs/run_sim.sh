#!/bin/bash

# Dual Port Memory Verification Simulation Script
# This script compiles and runs the SystemVerilog testbench

# Create logs directory if it doesn't exist
mkdir -p logs

# Get current timestamp for log file naming
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_FILE="logs/simulation_${TIMESTAMP}.log"

echo "Starting simulation at $(date)" > $LOG_FILE
echo "Log file: $LOG_FILE"
echo "========================================" >> $LOG_FILE

# Compile with VCS
echo "Compiling design..."
echo "Compiling design..." >> $LOG_FILE
vcs -full64 -licqueue '-timescale=1ns/1ns' '+vcs+flush+all' '+warn=all' '-sverilog' design.sv testbench.sv >> $LOG_FILE 2>&1

# Check if compilation was successful
if [ $? -eq 0 ]; then
    echo "Compilation successful!"
    echo "Compilation successful!" >> $LOG_FILE
    echo "========================================" >> $LOG_FILE
    echo "Running simulation..."
    echo "Running simulation..." >> $LOG_FILE
    
    # Run simulation
    ./simv +vcs+lic+wait '+test=write_read_c' '+NoTransactions=300' >> $LOG_FILE 2>&1
    
    if [ $? -eq 0 ]; then
        echo "========================================" >> $LOG_FILE
        echo "Simulation completed successfully at $(date)" >> $LOG_FILE
        echo "Simulation completed successfully!"
    else
        echo "========================================" >> $LOG_FILE
        echo "Simulation failed at $(date)" >> $LOG_FILE
        echo "Simulation failed!"
        exit 1
    fi
else
    echo "Compilation failed at $(date)" >> $LOG_FILE
    echo "Compilation failed!"
    exit 1
fi

echo "Log saved to: $LOG_FILE"
