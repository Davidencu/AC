module div3(input [3:0]i, output reg [2:0]o);
  
  
  always @(*) begin
  if(0'd0 <=i && i<0'd3)
    o = 0'd0;
  if(0'd3 <=i && i<0'd6)
    o = 0'd1;
  if(0'd6 <=i && i<0'd9)
    o = 0'd2;
  if(0'd9 <=i && i<0'd12)
    o = 0'd3;
  if(0'd12 <=i && i<0'd15)
    o = 0'd4;
  if(i == 0'd15)
    o = 0'd5;
  end
  
endmodule

module div3_tb;
  reg [3:0]i;
  wire [2:0]o;

  div3 div3_i (.i(i), .o(o));

  integer k;
  initial begin
    $display("Time\ti\t\to");
    $monitor("%0t\t%b(%2d)\t%b(%0d)", $time, i, i, o, o);
    i = 0;
    for (k = 1; k < 16; k = k + 1)
      #10 i = k;
  end
endmodule