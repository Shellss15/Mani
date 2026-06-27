#!/bin/bash

# ==============================================================================
# PROJECT 1: AUTOMATED ENTERPRISE NETWORK TRAFFIC TRIAGE ENGINE
# AUTHOR: [Your Name]
# DESCRIPTION: Headless Tshark parsing utility for automated threat screening.
# ==============================================================================

# Visual Header
echo "=========================================================="
echo "    AUTONOMOUS NETWORK TRAFFIC TRIAGE AUTOMATION ENGINE   "
echo "=========================================================="

# Step 1: Ensure an input packet capture file was explicitly provided
if [ -z "$1" ]; then
    echo "[-] Error: Missing input vector. Usage: ./network-triage.sh <file.pcap>"
    echo "=========================================================="
    exit 1
fi

PCAP_FILE="$1"

# Step 2: Validate the file exists on the filesystem
if [ ! -f "$PCAP_FILE" ]; then
    echo "[-] Error: File '$PCAP_FILE' not found in current directory path."
    echo "=========================================================="
    exit 1
fi

echo "[+] Target Verified: $PCAP_FILE"
echo "[+] Initializing Headless Tshark Parsing Pipelines..."
echo "----------------------------------------------------------"

# Step 3: Extract and generate a clean, master structural text log matrix
echo "[+] Pipeline 1: Generating Structured Telemetry View..."
tshark -r "$PCAP_FILE" -T fields \
  -e frame.number -e eth.src -e eth.dst -e ip.src -e ip.dst -e _ws.col.Protocol \
  > master_telemetry_matrix.log

echo "[*] Success: Master logs compiled inside 'master_telemetry_matrix.log'"
echo "----------------------------------------------------------"

# Step 4: Run defensive filtering scripts to flag broadcast network loops
echo "[+] Pipeline 2: Screening Layer 2 MAC Broadcasts (ARP Scanning)..."
echo "--- [TOP BROADCAST TRAFFIC CONSUMERS] ---"
# Extracts column 2 (source MAC), filters out any traffic that isn't an explicit broadcast loop, and counts them
awk '{print $2, $3}' master_telemetry_matrix.log | grep "ff:ff:ff:ff:ff:ff" | sort | uniq -c | sort -nr | head -n 5
echo "----------------------------------------------------------"

# Step 5: Isolate and extract protocol volume counts for threat sizing
echo "[+] Pipeline 3: Calculating Network Protocol Metrics..."
echo "--- [PROTOCOL VOLUME DISTRIBUTION] ---"
# Isolates the very last column (the protocol name), strips spacing, and generates a count summary
awk '{print $NF}' master_telemetry_matrix.log | sort | uniq -c | sort -nr
echo "----------------------------------------------------------"

# Step 6: Consolidate high-risk outliers into a final Analyst Triage Report
echo "[+] Pipeline 4: Building Final Executive Analyst Triage Document..."
{
    echo "=========================================================="
    echo "             CRITICAL ANALYST TRIAGE REPORT               "
    echo "=========================================================="
    echo "Generated on: $(date)"
    echo "Analyzed Source File: $PCAP_FILE"
    echo "----------------------------------------------------------"
    echo "[!] TOP NETWORK CHATTER IDENTIFIED:"
    awk '{print $4}' master_telemetry_matrix.log | grep -v '^$' | sort | uniq -c | sort -nr | head -n 3
    echo "----------------------------------------------------------"
    echo "[!] HIGH-FREQUENCY PROTOCOL footprint:"
    awk '{print $NF}' master_telemetry_matrix.log | sort | uniq -c | sort -nr | head -n 2
} > critical_alerts.txt

echo "[*] Complete: Analysis finished without execution faults."
echo "[*] Review your specialized triage summary inside: 'critical_alerts.txt'"
echo "=========================================================="
