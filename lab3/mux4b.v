module mux4b(
  input wire [3:0]i, [1:0]sel,
  output reg o
);
  
  always @(*)
    begin
      case (sel)
        2'b00: o=i[0];
        2'b01: o=i[1];
        2'b10: o=i[2];
        default: o=i[3];
      endcase
    end
        
endmodule