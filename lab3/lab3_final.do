add wave *

#test no jump, no branch
#start from 00000000000000000000000000000000
#pc_net should be 00000000000000000000000000000001
force pc 00000000000000000000000000000000 
force pc_sel 00
force branch_type 00
run 2

#test jump there
#pc_net should be 00000000000000000000000000000001
#start from 00000000000000000000000000000000
#offet is 1
force pc 00000000000000000000000000000000 
force target_address 00000000000000000000000001  
force pc_sel 01
run 2

#test jr rs
#pc_net should be 00000000000000000000000000000010
#start from 00000000000000000000000000000000
#rs holds 2
force pc 00000000000000000000000000000000 
force rs 00000000000000000000000000000010 
force pc_sel 10
run 2

#test beq rs,rt, loop with rs = rt
#pc_net should be 00000000000000000000000000000100
#start from 00000000000000000000000000000000
#rs holds 1
#rt holds 1
force pc 00000000000000000000000000000000 
force rs 00000000000000000000000000000001 
force rt 00000000000000000000000000000001 
force target_address 00000000000000000000000011
force pc_sel 00
force branch_type 01
run 2

#test beq rs,rt, loop with rs = rt
#pc_net should be 00000000000000000000000000000001
#start from 00000000000000000000000000000001
#rs holds 1
#rt holds 1
force pc 00000000000000000000000000000001 
force rs 00000000000000000000000000000001 
force rt 00000000000000000000000000000001 
force target_address 00000000001111111111111111
force pc_sel 00
force branch_type 01
run 2

#test beq rs,rt, loop with rs /= rt
#pc_net should be 00000000000000000000000000000001
#start from 00000000000000000000000000000000
#rs holds 1
#rt holds 3
force pc 00000000000000000000000000000000 
force rs 00000000000000000000000000000001 
force rt 00000000000000000000000000000011 
force target_address 00000000000000000000000001
force pc_sel 00
force branch_type 01
run 2

#test bne rs,rt, loop with rs = rt
#pc should not change use offset, increment by 1
#start from 00000000
#rs holds 1
#rt holds 1
force pc 00000000000000000000000000000000 
force rs 00000000000000000000000000000001 
force rt 00000000000000000000000000000001 
force target_address 00000000000000000000000111
force pc_sel 00
force branch_type 10
run 2

#test bne rs,rt, loop with rs /= rt
#pc_net should be 00000000000000000000000000000011
#start from 00000000000000000000000000000000
#rs holds 1
#rt holds 3
#target is 2
force pc 00000000000000000000000000000000 
force rs 00000000000000000000000000000001
force rt 00000000000000000000000000000011 
force target_address 00000000000000000000000010
force pc_sel 00
force branch_type 10
run 2


#test bltz rs, loop with rs > 0
#pc_net should be 00000000000000000000000000000001
#start from 00000000000000000000000000000000
#rs holds 1
#target is 6
force pc 00000000000000000000000000000000 
force rs 00000000000000000000000000000001 
force target_address 00000000000000000000000110
force pc_sel 00
force branch_type 11
run 2

#test bltz rs, loop with rs < 0
#pc_net should be 00000000000000000000000000000011
#start from 00000000000000000000000000000000
#rs holds 11110000000000000000000000000000
#target is 2
force pc 00000000000000000000000000000000 
force rs 11110000000000000000000000000000 
force target_address 00000000000000000000000010
force pc_sel 00
force branch_type 11
run 2























