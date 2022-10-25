set step 5
set runtime 0
restart -force -nowave
add wave *

# apply all 512 (2^9) possible inputs to the design

for {set j 0} {$j < 512} {incr j} {
    force -freeze en    1'b[expr $j >> 8] $runtime
    force -freeze x     8'd$j             $runtime
    set runtime [expr $runtime + $step]
}
run $runtime
view wave