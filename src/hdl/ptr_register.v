module ptr_register #(
	parameter PTR_WIDTH = 4,
	parameter BUF_DEPTH = 16,
	parameter BATCH_SIZE = 4
)(
	input  clk,
	input  rst,
	input  inc,
	output [PTR_WIDTH-1:0] ptr_value
);

	wire  [PTR_WIDTH-1:0] next_value;
	wire  [PTR_WIDTH  :0] ptr_plus;

	register #(PTR_WIDTH) BASE_REG
	(
		.clk    ( clk        ),
		.rst    ( rst        ),
		.load   ( inc        ),
		.din    ( next_value ),
		.dout   ( ptr_value  )
	);
	
	assign ptr_plus = ptr_value + BATCH_SIZE;

	assign next_value = (ptr_plus < BUF_DEPTH) ? ptr_plus : ptr_plus - BUF_DEPTH;

endmodule
