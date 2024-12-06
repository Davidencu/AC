module hac(input x,y,output reg o,co);

always @(*) begin
o=x^y;
co=x&y;
end

endmodule
