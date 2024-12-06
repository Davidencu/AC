module text2nibble (
  input [7:0] i,
  output reg [3:0] o
);
  
  always @(*) begin
    if(i>=0'b110000 && i<=0'b111001)
      o=i%16;
    else
      o=0'd15;
  end
endmodule

module text2nibble_tb;
  reg [7:0] i;
  wire [3:0] o;

  text2nibble text2nibble_i (.i(i), .o(o));

  integer k;
  initial begin
    $display("Time\ti\ti_chr\to");
    $monitor("%0t\t%b\t%c\t%b(%d)", $time, i, i, o, o);
    i = 0;
    for (k = 1; k < 256; k = k + 1)
      #10 i = k;
  end
endmodule