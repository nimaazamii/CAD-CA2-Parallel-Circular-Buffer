module register #(parameter WIDTH = 8)
(
	input clk,
	input rst,
	input load,
	input      [WIDTH-1:0] din,
	output reg [WIDTH-1:0] dout
);
	always @(posedge clk or posedge rst)
	begin
		if (rst)         dout <= {WIDTH{1'b0}};
		else if (load)   dout <= din;
	end
endmodule
