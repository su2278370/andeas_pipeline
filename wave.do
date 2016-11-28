onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -divider {Instruction Memory}
add wave -noupdate /top_tb/cpu/inst_memory/clk
add wave -noupdate /top_tb/cpu/inst_memory/rst
add wave -noupdate /top_tb/cpu/inst_memory/IM_read
add wave -noupdate -radix decimal /top_tb/cpu/inst_memory/IM_addr
add wave -noupdate -radix binary /top_tb/cpu/inst_memory/IM_out
add wave -noupdate /top_tb/cpu/inst_memory/i
add wave -noupdate -divider {Program counter}
add wave -noupdate /top_tb/cpu/program_counter/stall
add wave -noupdate /top_tb/cpu/program_counter/branch_true
add wave -noupdate -radix decimal /top_tb/cpu/program_counter/new_addr
add wave -noupdate -radix decimal /top_tb/cpu/program_counter/pc_output
add wave -noupdate -divider {Fetch to Decoder}
add wave -noupdate -radix decimal /top_tb/cpu/fetch_to_decoder/if_pc
add wave -noupdate -radix binary /top_tb/cpu/fetch_to_decoder/if_inst
add wave -noupdate -radix decimal /top_tb/cpu/fetch_to_decoder/id_pc
add wave -noupdate -radix binary /top_tb/cpu/fetch_to_decoder/id_inst
add wave -noupdate /top_tb/cpu/fetch_to_decoder/flush
add wave -noupdate /top_tb/cpu/fetch_to_decoder/stall
add wave -noupdate -divider Decoder
add wave -noupdate /top_tb/cpu/decoder1/inst_i
add wave -noupdate /top_tb/cpu/decoder1/reg1_data_i
add wave -noupdate /top_tb/cpu/decoder1/reg2_data_i
add wave -noupdate /top_tb/cpu/decoder1/sw_data_i
add wave -noupdate /top_tb/cpu/decoder1/branch_addr
add wave -noupdate /top_tb/cpu/decoder1/reg1_read
add wave -noupdate /top_tb/cpu/decoder1/reg2_read
add wave -noupdate /top_tb/cpu/decoder1/sw_read
add wave -noupdate /top_tb/cpu/decoder1/reg_write
add wave -noupdate /top_tb/cpu/decoder1/reg1_addr_o
add wave -noupdate /top_tb/cpu/decoder1/reg2_addr_o
add wave -noupdate /top_tb/cpu/decoder1/write_addr_o
add wave -noupdate /top_tb/cpu/decoder1/sw_addr_o
add wave -noupdate /top_tb/cpu/decoder1/reg1_o
add wave -noupdate /top_tb/cpu/decoder1/reg2_o
add wave -noupdate /top_tb/cpu/decoder1/sw_o
add wave -noupdate /top_tb/cpu/decoder1/write_o
add wave -noupdate /top_tb/cpu/decoder1/alu_ctrl
add wave -noupdate /top_tb/cpu/decoder1/lwsrc
add wave -noupdate /top_tb/cpu/decoder1/movsrc
add wave -noupdate /top_tb/cpu/decoder1/DM_read
add wave -noupdate /top_tb/cpu/decoder1/DM_write
add wave -noupdate /top_tb/cpu/decoder1/opcode
add wave -noupdate /top_tb/cpu/decoder1/sub_opcode
add wave -noupdate /top_tb/cpu/decoder1/sub_opcode_4
add wave -noupdate /top_tb/cpu/decoder1/sub_opcode_5
add wave -noupdate /top_tb/cpu/decoder1/sub_opcode_8
add wave -noupdate /top_tb/cpu/decoder1/sv
add wave -noupdate /top_tb/cpu/decoder1/aluSrc2
add wave -noupdate /top_tb/cpu/decoder1/imm
add wave -noupdate /top_tb/cpu/decoder1/thirdteenSE
add wave -noupdate /top_tb/cpu/decoder1/fifteenSE
add wave -noupdate /top_tb/cpu/decoder1/twentythreeSE
add wave -noupdate -divider Regfile
add wave -noupdate /top_tb/cpu/regfile1/write
add wave -noupdate /top_tb/cpu/regfile1/read1
add wave -noupdate /top_tb/cpu/regfile1/read2
add wave -noupdate /top_tb/cpu/regfile1/swread
add wave -noupdate /top_tb/cpu/regfile1/waddr1
add wave -noupdate /top_tb/cpu/regfile1/raddr1
add wave -noupdate /top_tb/cpu/regfile1/raddr2
add wave -noupdate /top_tb/cpu/regfile1/swaddr
add wave -noupdate /top_tb/cpu/regfile1/din
add wave -noupdate /top_tb/cpu/regfile1/dout1
add wave -noupdate /top_tb/cpu/regfile1/dout2
add wave -noupdate /top_tb/cpu/regfile1/swdout
add wave -noupdate /top_tb/cpu/regfile1/rw_reg
add wave -noupdate -divider {Forwarding Unit}
add wave -noupdate /top_tb/cpu/forward_unit/id_reg1_addr
add wave -noupdate /top_tb/cpu/forward_unit/id_reg2_addr
add wave -noupdate /top_tb/cpu/forward_unit/id_reg1_o
add wave -noupdate /top_tb/cpu/forward_unit/id_reg2_o
add wave -noupdate /top_tb/cpu/forward_unit/id_reg1_read
add wave -noupdate /top_tb/cpu/forward_unit/id_reg2_read
add wave -noupdate /top_tb/cpu/forward_unit/exe_write_addr
add wave -noupdate /top_tb/cpu/forward_unit/exe_reg_write
add wave -noupdate /top_tb/cpu/forward_unit/exe_movsrc
add wave -noupdate /top_tb/cpu/forward_unit/mem_write_addr
add wave -noupdate /top_tb/cpu/forward_unit/mem_reg_write
add wave -noupdate /top_tb/cpu/forward_unit/mem_data
add wave -noupdate /top_tb/cpu/forward_unit/forward1_data
add wave -noupdate /top_tb/cpu/forward_unit/forward2_data
add wave -noupdate -radix binary /top_tb/cpu/forward_unit/id_inst
add wave -noupdate /top_tb/cpu/forward_unit/stall_pc
add wave -noupdate /top_tb/cpu/forward_unit/stall_if_id
add wave -noupdate -radix binary /top_tb/cpu/forward_unit/opcode
add wave -noupdate -radix binary /top_tb/cpu/forward_unit/sub_opcode_8
add wave -noupdate -divider {Decoder to Execution}
add wave -noupdate -radix decimal /top_tb/cpu/decoder_to_execution/id_pc_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_branch_addr
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_reg1_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_reg2_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_sw_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_write_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_aluctrl
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_lwsrc
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_movsrc
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_DM_read
add wave -noupdate /top_tb/cpu/decoder_to_execution/id_DM_write
add wave -noupdate -radix decimal /top_tb/cpu/decoder_to_execution/exe_pc_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_branch_addr
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_reg1_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_reg2_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_aluctrl
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_sw_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_write_o
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_lwsrc
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_movsrc
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_DM_read
add wave -noupdate /top_tb/cpu/decoder_to_execution/exe_DM_write
add wave -noupdate /top_tb/cpu/decoder_to_execution/flush
add wave -noupdate -divider Execution
add wave -noupdate /top_tb/cpu/execution/src1
add wave -noupdate /top_tb/cpu/execution/src2
add wave -noupdate /top_tb/cpu/execution/aluctrl
add wave -noupdate -radix decimal /top_tb/cpu/execution/alu_pc_o
add wave -noupdate -radix decimal /top_tb/cpu/execution/alu_branch_addr
add wave -noupdate /top_tb/cpu/execution/alu_result
add wave -noupdate /top_tb/cpu/execution/overflow
add wave -noupdate /top_tb/cpu/execution/branch_true
add wave -noupdate -radix decimal /top_tb/cpu/execution/new_addr
add wave -noupdate /top_tb/cpu/execution/temp
add wave -noupdate -divider {Execution to Memory}
add wave -noupdate /top_tb/cpu/execution_to_memory/exe_sw_o
add wave -noupdate /top_tb/cpu/execution_to_memory/exe_write_o
add wave -noupdate /top_tb/cpu/execution_to_memory/exe_lwsrc
add wave -noupdate /top_tb/cpu/execution_to_memory/exe_movsrc
add wave -noupdate /top_tb/cpu/execution_to_memory/exe_DM_read
add wave -noupdate /top_tb/cpu/execution_to_memory/exe_DM_write
add wave -noupdate /top_tb/cpu/execution_to_memory/exe_alu_result
add wave -noupdate /top_tb/cpu/execution_to_memory/mem_lwsrc
add wave -noupdate /top_tb/cpu/execution_to_memory/mem_movsrc
add wave -noupdate /top_tb/cpu/execution_to_memory/mem_write_o
add wave -noupdate /top_tb/cpu/execution_to_memory/mem_sw_o
add wave -noupdate /top_tb/cpu/execution_to_memory/mem_DM_read
add wave -noupdate /top_tb/cpu/execution_to_memory/mem_DM_write
add wave -noupdate /top_tb/cpu/execution_to_memory/mem_alu_result
add wave -noupdate -divider {Data Memory}
add wave -noupdate /top_tb/cpu/data_memory/DM_read
add wave -noupdate /top_tb/cpu/data_memory/DM_write
add wave -noupdate /top_tb/cpu/data_memory/DM_in
add wave -noupdate /top_tb/cpu/data_memory/DM_addr
add wave -noupdate /top_tb/cpu/data_memory/DM_out
add wave -noupdate /top_tb/cpu/data_memory/i
add wave -noupdate -divider {Mux Move Source}
add wave -noupdate /top_tb/cpu/mux_movsrc1/S
add wave -noupdate /top_tb/cpu/mux_movsrc1/I0
add wave -noupdate /top_tb/cpu/mux_movsrc1/I1
add wave -noupdate /top_tb/cpu/mux_movsrc1/Y
add wave -noupdate -divider {Memory to writeback}
add wave -noupdate /top_tb/cpu/memory_to_write/mem_lwsrc
add wave -noupdate /top_tb/cpu/memory_to_write/mem_movsrc_result
add wave -noupdate /top_tb/cpu/memory_to_write/wb_lwsrc
add wave -noupdate /top_tb/cpu/memory_to_write/wb_movsrc_result
add wave -noupdate -divider {Mux Load Source}
add wave -noupdate /top_tb/cpu/mux_lwsrc1/S
add wave -noupdate -radix decimal /top_tb/cpu/mux_lwsrc1/I0
add wave -noupdate /top_tb/cpu/mux_lwsrc1/I1
add wave -noupdate /top_tb/cpu/mux_lwsrc1/Y
add wave -noupdate -divider {Performance Unit}
add wave -noupdate /top_tb/cpu/pmu/clk
add wave -noupdate /top_tb/cpu/pmu/rst
add wave -noupdate /top_tb/cpu/pmu/stall
add wave -noupdate /top_tb/cpu/pmu/flush
add wave -noupdate -radix decimal /top_tb/cpu/pmu/cycle_count
add wave -noupdate -radix decimal /top_tb/cpu/pmu/inst_count
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 7} {964520 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 353
configure wave -valuecolwidth 317
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {348530 ps} {542110 ps}
