module ControlUnit (
	input  clk,
	input  rst,
	input  rd_req,
	input  wr_req,

	input  ns_empty_flag,
	input  ns_full_flag,
	input  full_wr_flag,

	output wren,
	output inc_rptr,
	output inc_wptr,

	output reg valid,
	output reg ready
);

	localparam EMPTY = 2'b00;
	localparam MID   = 2'b01;
	localparam FULL  = 2'b10;

	reg [1:0] PS, NS;
	
	assign wren     = ready;
	assign inc_wptr = ready;
	assign inc_rptr = valid;

	always @(posedge clk)
	begin
		if (rst)
			PS = EMPTY;
		else
			PS = NS;
	end

	always @ (*)
	begin
		valid = 0;
		ready = rd_req;
		NS    = PS;

		case (PS)
			EMPTY: begin
				valid = 0;
				ready = wr_req;

				if      (!wr_req)          NS = EMPTY; // if not write stay at EMPTY state
				else if (ns_empty_flag)    NS = EMPTY;
				else if (ns_full_flag )    NS = FULL;
				else                       NS = MID;
			end

			MID: begin
				valid = rd_req;
				ready = wr_req;
				
				if      (ns_empty_flag)    NS = EMPTY;
				else if (ns_full_flag )    NS = FULL;
				else                       NS = MID;
			end

			FULL: begin
				valid = rd_req;
				ready = rd_req & full_wr_flag;
				
				if      (ns_empty_flag)    NS = EMPTY;
				else if (ns_full_flag )    NS = FULL;
				else                       NS = MID;
			end

			default: NS = PS;
		endcase
	end

endmodule
