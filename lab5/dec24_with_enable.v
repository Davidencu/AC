module dec24_with_enable(input [1:0]i,enable, output reg [3:0]o);

always @(*) begin
if (enable) begin
case (i)
2'b00: o=4'b0001;
2'b01: o=4'b0010;
2'b10: o=4'b0100;
2'b11: o=4'b1000;
endcase

end

end

endmodule