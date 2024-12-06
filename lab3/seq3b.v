module seq3b (
  input [3:0] i,
  output reg o
);
  
  always @(*) begin
    if (i==0'b0000 || i==0'b0001 || i== 0'b1110 || i==0'b1111 || i==0'b1000 || i==0'b0111)
      o=1;
    else
      o=0;
  end
endmodule

module seq3b_tb;
  reg [3:0] i;
  wire o;

  seq3b seq3b_i (.i(i), .o(o));

  integer k;
  initial begin
    $display("Time\ti\t\to");
    $monitor("%0t\t%b(%2d)\t%b", $time, i, i, o);
    i = 0;
    for (k = 1; k < 16; k = k + 1)
      #10 i = k;
  end
endmodule