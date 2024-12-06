module dflipflop(
  input wire clk, rst, d,
  output reg q
);

  always @(posedge clk or negedge rst)
begin
  if(~rst)
    begin
    q<=0;
    end
  else
    begin
  if (d==1)
    q<=1;
  else
    q<=0;
    end
end
  
endmodule