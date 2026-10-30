module datapath #(
	parameter ADDR_WIDTH = 4,
	parameter DATA_WIDTH = 8,
	parameter BUFF_DEPTH = 16,
	parameter PAR_RD = 4,
	parameter PAR_WR = 2
)(
	input  clk,
	input  rst,
	input  wren,
	input  inc_rptr,
	input  inc_wptr,
	output ns_empty_flag,
	output ns_full_flag,
	output full_wr_flag,

	input  [0:DATA_WIDTH*PAR_WR-1] data_in,
	output [0:DATA_WIDTH*PAR_RD-1] data_out
);

	wire [ADDR_WIDTH-1:0] rd_ptr;
	wire [ADDR_WIDTH-1:0] wr_ptr;
	wire [ADDR_WIDTH  :0] next_rptr;
	wire [ADDR_WIDTH  :0] next_wptr;


	// A simple_buffer which is used as the base storage unit
	simple_buffer # (
		.AWIDTH ( ADDR_WIDTH ),
		.DWIDTH ( DATA_WIDTH ),
		.DEPTH  ( BUFF_DEPTH ),
		.PAR_RD ( PAR_RD     ),
		.PAR_WR ( PAR_WR     )
	) BASE_BUFF (
		.clk    ( clk        ),
		.wren   ( wren       ),
		.raddr  ( rd_ptr     ),
		.waddr  ( wr_ptr     ),
		.din    ( data_in    ),
		.dout   ( data_out   )
	);

	// Read-Pointer Register with internal update mechanism
	ptr_register #(
		.PTR_WIDTH  ( ADDR_WIDTH ),
		.BUF_DEPTH  ( BUFF_DEPTH ),
		.BATCH_SIZE ( PAR_RD     )
	) RPTR (
		.clk        ( clk        ),
		.rst        ( rst        ),
		.inc        ( inc_rptr   ),
		.ptr_value  ( rd_ptr     )
	);

	// Write-Pointer Register with internal update mechanism
	ptr_register #(
		.PTR_WIDTH  ( ADDR_WIDTH ),
		.BUF_DEPTH  ( BUFF_DEPTH ),
		.BATCH_SIZE ( PAR_WR     )
	) WPTR (
		.clk        ( clk        ),
		.rst        ( rst        ),
		.inc        ( inc_wptr   ),
		.ptr_value  ( wr_ptr     )
	);
	
	// Possible values of rd_ptr and wr_ptr in the next clock-cycle (next state) ignoring the buffer-depth-effect
	assign next_rptr = (inc_rptr) ? rd_ptr + PAR_RD : {1'b0, rd_ptr};
	assign next_wptr = (inc_wptr) ? wr_ptr + PAR_WR : {1'b0, wr_ptr};

	// Logic for generating ns_full_flag
	wire [ADDR_WIDTH  :0] next_rptr_compensate;
	wire [ADDR_WIDTH+1:0] next_rptr_plusA;
	wire [ADDR_WIDTH+1:0] next_wptr_plusA;
	
	assign next_rptr_compensate = (next_rptr > next_wptr) ? 0 : BUFF_DEPTH;
	assign next_rptr_plusA = next_rptr + next_rptr_compensate;
	assign next_wptr_plusA = next_wptr + PAR_WR;
	assign ns_full_flag = (next_rptr_plusA <= next_wptr_plusA) ? 1 : 0;
	


	// Logic for generating ns_empty_flag
	wire [ADDR_WIDTH  :0] next_wptr_compensate;
	wire [ADDR_WIDTH+1:0] next_rptr_plusB;
	wire [ADDR_WIDTH+1:0] next_wptr_plusB;
	
	assign next_wptr_compensate = (next_wptr >= next_rptr) ? 0 : BUFF_DEPTH;
	assign next_wptr_plusB = next_wptr + next_wptr_compensate;
	assign next_rptr_plusB = next_rptr + PAR_RD;
	assign ns_empty_flag   = (next_rptr_plusB > next_wptr_plusB) ? 1 : 0;
	
	// Logic for generating full_wr_flag (It means: Writing in the FULL state is valid)
	wire [ADDR_WIDTH  :0] wptr_plus;
	wire [ADDR_WIDTH  :0] rptr_plus;
	
	assign wptr_plus = wr_ptr + PAR_WR;
	assign rptr_plus = (rd_ptr >= wr_ptr) ? rd_ptr + PAR_RD :  rd_ptr + PAR_RD + BUFF_DEPTH;
	assign full_wr_flag = (wptr_plus < rptr_plus) ? 1 : 0;
	
endmodule
