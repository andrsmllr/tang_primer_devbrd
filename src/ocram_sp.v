module ocram_sp #(
  parameter DWIDTH = 32,
  parameter AWIDTH = 14
) (
  input  wire              clk_i,
//  input  wire              rst_i,
  input  wire              ce_i,
  input  wire              we_i,
  input  wire [AWIDTH-1:0] addr_i,
  input  wire [DWIDTH-1:0] d_i,
  output reg  [DWIDTH-1:0] q_o
);

reg [DWIDTH-1:0] ram [2**AWIDTH-1:0];

always @ (posedge clk_i)
begin
  // No reset must be present here (even if the branch is empty), otherwise no RAM will be inferred (Anlogic TD 4.4.433).
  /*if (rst_i == 1'b1) begin
  end else*/
  if (ce_i == 1'b1) begin
    if (we_i == 1'b1) begin
      ram[addr_i] <= d_i;
    end else begin
      q_o <= ram[addr_i];
    end
  end
end

endmodule
