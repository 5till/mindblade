#!/bin/bash
# ralph.sh — Full AFK Ralph Loop with PLAN.md support
# Usage: ./ralph.sh 15     (runs up to 15 iterations)
#        ./ralph.sh 30     (runs up to 30 iterations)

set -e

# Check if user passed a number
if [ -z "$1" ]; then
  echo "Usage: $0 <max_iterations>"
  echo "Example: ./ralph.sh 10"
  echo "         ./ralph.sh 20"
  exit 1
fi

MAX_ITERATIONS=$1

echo "🚀 Starting Ralph Loop — Max $MAX_ITERATIONS iterations"
echo "Using: PRD.md + PLAN.md + progress.txt"
echo "--------------------------------------------------"

for i in $(seq 1 $MAX_ITERATIONS); do
  echo "=== Ralph Iteration $i of $MAX_ITERATIONS ==="

  # Run ralph-once and capture the full output
  OUTPUT=$(./ralph-once.sh 2>&1 | tee /dev/stderr)

  # Check if Ralph signaled that everything is complete
  if echo "$OUTPUT" | grep -q "<promise>COMPLETE</promise>"; then
    echo "🎉 Ralph finished early — all tasks appear complete!"
    exit 0
  fi

  echo "--------------------------------------------------"
done

echo "✅ Reached maximum iterations ($MAX_ITERATIONS)."
echo "Check progress.txt, test your app, and run ./ralph.sh again if needed."
