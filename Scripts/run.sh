verilator --binary -j 0 -Wall -Wno-UNUSEDSIGNAL apb_timer.v apb_timer_tb.v --top apb_timer_tb --timing --CFLAGS "-std=c++20" --trace

make -f Vapb_timer_tb.mk Vapb_timer_tb || { echo "Compilation failed"; exit 1; }

./Vapb_timer_tb || { echo "Simulation failed"; exit 1; }
