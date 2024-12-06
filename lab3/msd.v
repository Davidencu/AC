module msd(input [4:0]i,output reg [3:0]o);
  
  always @(*)
    begin
      if (0'd0 <=i && i<0'd10)
        o=0'd0;
      if (0'd10<=i && i<0'd20)
        o=0'd1;
      if (0'd20<=i && i<=0'd30)
        o=0'd2;
      if (i>=0'd30)
        o=0'd3;
    end
  
  
endmodule

module msd_tb;
  reg [4:0] i;
  wire [3:0] o;

  msd msd_i (.i(i), .o(o));

  integer k;
  initial begin
    $display("Time\ti\t\to");
    $monitor("%0t\t%b(%2d)\t%b(%0d)", $time, i, i, o, o);
    i = 0;
    for (k = 1; k < 32; k = k + 1)
      #10 i = k;
  end
endmodule