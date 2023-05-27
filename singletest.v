module SHA256_Testbench;

  // Parameters
  parameter DATA_WIDTH = 32;  // Width of the data input

  // I/O
  reg [DATA_WIDTH-1:0] data_in [0:9];
  wire [DATA_WIDTH-1:0] data_out [0:7];
  reg [31:0] k;
    // Constant K
  parameter [31:0] K [0:9] = {
    32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,
    32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
    32'hd807aa98, 32'h12835b01
    };

  // Instantiate the SHA256 module pipeline
  sha256_single_iteration sha256_inst (
    .W(data_in[0]),
    .K(k),
    .a(32'h3d49c98e),.b(32'h6a09e667),.c(32'hbb67ae85),.d(32'h3c6ef372),.e(32'hda0923e3),.f(32'h510e527f),.g(32'h9b05688c),.h(32'h1f83d9ab),
    .a_out(data_out[0]),.b_out(data_out[1]),.c_out(data_out[2]),.d_out(data_out[3]),.e_out(data_out[4]),.f_out(data_out[5]),.g_out(data_out[6]),.h_out(data_out[7])
  );

  initial begin
    data_in[0] = 32'h42424242;
    k = K[1];
    #3
    $display("--------------OUTPUT-------------------");
    $display("%h %h %h %h %h %h %h %h", data_out[0], data_out[1], data_out[2], data_out[3], data_out[4], data_out[5], data_out[6], data_out[7]);
    $display("--------------DEBUG--------------------");
    $display("Sum1: %d Ch: %d h: %d K: %d W: %d",sha256_inst.Sum1,sha256_inst.ch,32'h1f83d9ab,sha256_inst.K,sha256_inst.W);
//     $display("rotr 6 : ",sha256_inst.Rotr6);
//     $display("rotr 11: ",sha256_inst.Rotr11);
//     $display("rotr 25: ",sha256_inst.Rotr25);
//     $display("xortest: ",sha256_inst.Xortest);
    $display("t: %d %d",sha256_inst.t1,sha256_inst.t2);
    $finish;
  end

endmodule