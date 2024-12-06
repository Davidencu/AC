module check(input [4:0]i, output o);
assign o=i[1]&i[0];
endmodule