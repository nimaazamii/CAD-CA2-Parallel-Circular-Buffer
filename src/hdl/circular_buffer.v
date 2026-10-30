module circular_buffer #(
	parameter ADDR_WIDTH = 4,
	parameter DATA_WIDTH = 8,
	parameter BUFF_DEPTH = 16,
	parameter PAR_RD     = 4,
	parameter PAR_WR     = 2
)(
	input  clk,
	input  rst,
	input  rd_req,
	input  wr_req,

	input  [0:DATA_WIDTH*PAR_WR-1] data_in,
	output [0:DATA_WIDTH*PAR_RD-1] data_out,

	output ready,
	output valid

);

	wire wren;
	wire inc_rptr;
	wire inc_wptr;
	wire ns_empty_flag;
	wire ns_full_flag;
	wire full_wr_flag;
	


	datapath #(
		.ADDR_WIDTH    ( ADDR_WIDTH    ),
		.DATA_WIDTH    ( DATA_WIDTH    ),
		.BUFF_DEPTH    ( BUFF_DEPTH    ),
		.PAR_RD        ( PAR_RD        ),
		.PAR_WR        ( PAR_WR        )
	) DP (
		.clk           ( clk           ),
		.rst           ( rst           ),
		.wren          ( wren          ),
		.inc_rptr      ( inc_rptr      ),
		.inc_wptr      ( inc_wptr      ),
		.ns_empty_flag ( ns_empty_flag ),
		.ns_full_flag  ( ns_full_flag  ),
		.full_wr_flag  ( full_wr_flag  ),
		.data_in       ( data_in       ),
		.data_out      ( data_out      ) 
	);


	ControlUnit CU (
		.clk           ( clk           ),
		.rst           ( rst           ),
		.rd_req        ( rd_req        ),
		.wr_req        ( wr_req        ),
		.ns_empty_flag ( ns_empty_flag ),
		.ns_full_flag  ( ns_full_flag  ),
		.full_wr_flag  ( full_wr_flag  ),
		.wren          ( wren          ),
		.inc_rptr      ( inc_rptr      ),
		.inc_wptr      ( inc_wptr      ),
		.valid         ( valid         ),
		.ready         ( ready         ) 
	);

endmodule
