module tb_top();

	localparam ADDR_WIDTH =  4;
	localparam DATA_WIDTH =  8;
	localparam BUFF_DEPTH = 16;
	localparam PAR_RD     =  1;
	localparam PAR_WR     =  1;

	reg  clk;
	reg  rst;
	reg  rd_req;
	reg  wr_req;

	reg  [0:DATA_WIDTH*PAR_WR-1] data_in;
	wire [0:DATA_WIDTH*PAR_RD-1] data_out;

	wire ready;
	wire valid;


	circular_buffer #(
		.ADDR_WIDTH ( ADDR_WIDTH ),
		.DATA_WIDTH ( DATA_WIDTH ),
		.BUFF_DEPTH ( BUFF_DEPTH ),
		.PAR_RD     ( PAR_RD     ),
		.PAR_WR     ( PAR_WR     )
	) UUT (
		.clk        ( clk        ),
		.rst        ( rst        ),
		.rd_req     ( rd_req     ),
		.wr_req     ( wr_req     ),
		.data_in    ( data_in    ),
		.data_out   ( data_out   ),
		.ready      ( ready      ),
		.valid      ( valid      )

	);
	
	initial begin
		clk = 1;
		repeat (200)   #10 clk = ~clk;
	end
	
	initial begin
		rst = 0;
		#15 rst = 1;
		#20 rst = 0;
	end
	
	initial begin
		rd_req = 0;
		wr_req = 0;

		#30 rd_req = 1;
		#20 rd_req = 0; wr_req = 1; data_in = 16'h1234;
		#20 wr_req = 0; rd_req = 1;
		#20 rd_req = 0; wr_req = 1; data_in = 16'h5678;
		#20 rd_req = 0; wr_req = 1; data_in = 16'h9abc;
		#20 rd_req = 1; wr_req = 0;
		#20 rd_req = 1;
		#20 rd_req = 0; wr_req = 1; data_in = 16'hdeff;
		#20 data_in = 16'h1122;
		#20 data_in = 16'h3344;
		#20 data_in = 16'h5566;
		#20 data_in = 16'h7788;
		#20 data_in = 16'h99aa;
		#20 data_in = 16'hbbcc;
		#60 rd_req  = 1; // simultaneous read and write
		#20 wr_req  = 0;
		
	end

endmodule
