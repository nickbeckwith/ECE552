module Hazard_Detection(input IF_EX_MemRead, input [3:0]ID_EX_RegisterRt, input[3:0] IF_ID_RegisterRs,
			input[3:0] IF_ID_RegisterRt, output stall_n, output write_pc, output write_IF_ID_reg);

	/*
		When connecting wires in cpu.v, IF_EX_MemRead input to this module should be generated by adding
		hardware to check if memory is read in the IF/EX stage of pipeline.
	*/
	wire [3:0] Rs_Eq_Rt, Rt_Eq_Rt;
	wire reg_cond1, reg_cond2, final_reg_cond;

  assign Rs_Eq_Rt = ID_EX_RegisterRt == IF_ID_RegisterRs ? 1'b1: 1'b0;
	assign Rt_Eq_Rt = ID_EX_RegisterRt == IF_ID_RegisterRt ? 1'b1 : 1'b0;
	//assign reg_cond1 = |Rs_Eq_Rt;
	//assign reg_cond2 = |Rt_Eq_Rt;
	//assign final_reg_cond = ~(reg_cond1|reg_cond2);
	assign final_reg_cond = Rs_Eq_Rt | Rt_Eq_Rt;
  //0 if stall has to occur - add as controlling signal to mux controlling output of control unit
	// if this signal is 0, output of mux should be 0s else select the control from control unit - no ops
	assign stall_n = (IF_EX_MemRead&final_reg_cond) ? 1'b0 : 1'b1;

  //0 if stall occurs - and with reg_write signal to pc to stall pc update
	assign write_pc = (IF_EX_MemRead&final_reg_cond) ? 1'b0: 1'b1;

  //0 if stall occurs - and with reg_write signal to IF/ID stage pipeline register to stall fetch
	assign write_IF_ID_reg = (IF_EX_MemRead&final_reg_cond) ? 1'b0: 1'b1;

endmodule
