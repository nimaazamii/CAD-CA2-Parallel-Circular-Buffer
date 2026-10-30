module simple_buffer # (
	parameter AWIDTH = 4,
	parameter DWIDTH = 8,
	parameter DEPTH  = 16,
	parameter PAR_RD = 4,
	parameter PAR_WR = 2
) (
	input  clk,
	input  wren,                            // write-enable

	input  [AWIDTH-1:0] raddr,             // starting read  address
	input  [AWIDTH-1:0] waddr,             // starting write address

	input  [0:PAR_WR*DWIDTH-1] din ,   // data-in
	output [0:PAR_RD*DWIDTH-1] dout    // data-out
);

	// Memory Array Definition
	reg  [DWIDTH-1:0] memory [0:DEPTH-1];

	// Write Mechanism
	reg  [AWIDTH-1:0] wr_idx[0:PAR_WR-1];   // individual write addresses
	genvar wi;

	generate
		for (wi=0; wi<PAR_WR; wi=wi+1)
		begin
			always @ (posedge clk) begin
				if (wren) begin
					wr_idx[wi] = (waddr+wi) % DEPTH;
					memory[wr_idx[wi]] = din[wi*DWIDTH : (wi+1)*DWIDTH-1];
				end
			end
		end
	endgenerate


	// Read Mechanism
	wire [AWIDTH-1:0] rd_idx[0:PAR_RD-1];   // individual read  addresses
	genvar ri;

	generate
		for (ri=0; ri<PAR_RD; ri=ri+1)
		begin
			assign rd_idx[ri] = (raddr+ri) % DEPTH;
			assign dout[ri*DWIDTH : (ri+1)*DWIDTH-1] = memory[rd_idx[ri]];
		end
	endgenerate

endmodule