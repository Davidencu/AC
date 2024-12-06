module dec24(input [1:0]i, output reg [3:0]o);

always @(*) begin
case (i)
	2'b00: o=0'b0001;
	2'b01: o=0'b0010;
	2'b10: o=0'b0100;
	2'b11: o=0'b1000;
endcase
end

endmodule