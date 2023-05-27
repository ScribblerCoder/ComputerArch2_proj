module sha256_single_iteration (
    input [31:0] W, // Message schedule word
    input [31:0] K, // Constant K
    input [31:0] a, b, c, d, e, f, g, h,
    output reg [31:0] a_out, b_out, c_out, d_out, e_out, f_out, g_out, h_out
);

// Function definitions
function [31:0] Ch;
    input [31:0] x, y, z;
    begin
        Ch = (x & y) ^ (~x & z);
    end
endfunction

function [31:0] Maj;
    input [31:0] x, y, z;
    begin
        Maj = (x & y) ^ (x & z) ^ (y & z);
    end
endfunction

function [31:0] rotr;
    input [31:0] x;
    input int n;
    begin
        rotr = (x >> n) | (x << (32 - n));
    end
endfunction

function [31:0] sum0;
    input [31:0] x;
    begin
        sum0 = rotr(x, 2) ^ rotr(x, 13) ^ rotr(x, 22);
    end
endfunction

function [31:0] sum1;
    input [31:0] x;
    begin
        sum1 = rotr(x, 6) ^ rotr(x, 11) ^ rotr(x, 25);
    end
endfunction

function [31:0] sigma0;
    input [31:0] x;
    begin
        sigma0 = rotr(x, 7) ^ rotr(x, 18) ^ (x >> 3);
    end
endfunction

function [31:0] sigma1;
    input [31:0] x;
    begin
        sigma1 = rotr(x, 17) ^ rotr(x, 19) ^ (x >> 10);
    end
endfunction

// Intermediate variables
  reg [31:0] t1, t2, ch, maj, Rotr, Sum0, Sum1, Sigma0, Sigma1;

// Single iteration computation
always @(*) begin
    ch = Ch(e, f, g);
    maj = Maj(a, b, c);
    Sum0 = sum0(a);
    Sum1 = sum1(e);
    t1 = h + sum1(e) + Ch(e, f, g) + K + W;
    t2 = sum0(a) + Maj(a, b, c);
    h_out = g;
    g_out = f;
    f_out = e;
    e_out = d + t1;
    d_out = c;
    c_out = b;
    b_out = a;
    a_out = t1 + t2;
end

endmodule




module TenStagePipeline (
  input wire clk,
  input wire reset,
  input wire [31:0] message [0:9],
  output wire [31:0] digest [0:7]
);

  // Initial hash values
    parameter [31:0] H [0:7] = {
        32'h6a09e667, 32'hbb67ae85, 32'h3c6ef372, 32'ha54ff53a,
        32'h510e527f, 32'h9b05688c, 32'h1f83d9ab, 32'h5be0cd19
        };

  // Constant K
  parameter [31:0] K [0:9] = {
    32'h428a2f98, 32'h71374491, 32'hb5c0fbcf, 32'he9b5dba5,
    32'h3956c25b, 32'h59f111f1, 32'h923f82a4, 32'hab1c5ed5,
    32'hd807aa98, 32'h12835b01
    };

  // Pipeline stages
  reg [31:0] stage_1_a, stage_1_b, stage_1_c, stage_1_d, stage_1_e, stage_1_f, stage_1_g, stage_1_h;
  reg [31:0] stage_2_a, stage_2_b, stage_2_c, stage_2_d, stage_2_e, stage_2_f, stage_2_g, stage_2_h;
  reg [31:0] stage_3_a, stage_3_b, stage_3_c, stage_3_d, stage_3_e, stage_3_f, stage_3_g, stage_3_h;
  reg [31:0] stage_4_a, stage_4_b, stage_4_c, stage_4_d, stage_4_e, stage_4_f, stage_4_g, stage_4_h;
  reg [31:0] stage_5_a, stage_5_b, stage_5_c, stage_5_d, stage_5_e, stage_5_f, stage_5_g, stage_5_h;
  reg [31:0] stage_6_a, stage_6_b, stage_6_c, stage_6_d, stage_6_e, stage_6_f, stage_6_g, stage_6_h;
  reg [31:0] stage_7_a, stage_7_b, stage_7_c, stage_7_d, stage_7_e, stage_7_f, stage_7_g, stage_7_h;
  reg [31:0] stage_8_a, stage_8_b, stage_8_c, stage_8_d, stage_8_e, stage_8_f, stage_8_g, stage_8_h;
  reg [31:0] stage_9_a, stage_9_b, stage_9_c, stage_9_d, stage_9_e, stage_9_f, stage_9_g, stage_9_h;
  reg [31:0] stage_10_a, stage_10_b, stage_10_c, stage_10_d, stage_10_e, stage_10_f, stage_10_g, stage_10_h;

  wire [31:0] stage_1_a_out, stage_1_b_out, stage_1_c_out, stage_1_d_out, stage_1_e_out, stage_1_f_out, stage_1_g_out, stage_1_h_out;
  wire [31:0] stage_2_a_out, stage_2_b_out, stage_2_c_out, stage_2_d_out, stage_2_e_out, stage_2_f_out, stage_2_g_out, stage_2_h_out;
  wire [31:0] stage_3_a_out, stage_3_b_out, stage_3_c_out, stage_3_d_out, stage_3_e_out, stage_3_f_out, stage_3_g_out, stage_3_h_out;
  wire [31:0] stage_4_a_out, stage_4_b_out, stage_4_c_out, stage_4_d_out, stage_4_e_out, stage_4_f_out, stage_4_g_out, stage_4_h_out;
  wire [31:0] stage_5_a_out, stage_5_b_out, stage_5_c_out, stage_5_d_out, stage_5_e_out, stage_5_f_out, stage_5_g_out, stage_5_h_out;
  wire [31:0] stage_6_a_out, stage_6_b_out, stage_6_c_out, stage_6_d_out, stage_6_e_out, stage_6_f_out, stage_6_g_out, stage_6_h_out;
  wire [31:0] stage_7_a_out, stage_7_b_out, stage_7_c_out, stage_7_d_out, stage_7_e_out, stage_7_f_out, stage_7_g_out, stage_7_h_out;
  wire [31:0] stage_8_a_out, stage_8_b_out, stage_8_c_out, stage_8_d_out, stage_8_e_out, stage_8_f_out, stage_8_g_out, stage_8_h_out;
  wire [31:0] stage_9_a_out, stage_9_b_out, stage_9_c_out, stage_9_d_out, stage_9_e_out, stage_9_f_out, stage_9_g_out, stage_9_h_out;
  wire [31:0] stage_10_a_out, stage_10_b_out, stage_10_c_out, stage_10_d_out, stage_10_e_out, stage_10_f_out, stage_10_g_out, stage_10_h_out;

  
  reg [31:0] message_1 [0:9], message_2 [0:9], message_3 [0:9], message_4 [0:9], message_5 [0:9], message_6 [0:9], message_7 [0:9], message_8 [0:9], message_9 [0:9];

  // Instantiate sha256_single_iteration module for each stage
  sha256_single_iteration stage_1 (.W(message[0]), .K(K[0]), .a(32'h6a09e667),.b(32'hbb67ae85),.c(32'h3c6ef372),.d(32'ha54ff53a),.e(32'h510e527f),.f(32'h9b05688c),.g(32'h1f83d9ab),.h(32'h5be0cd19),.a_out(stage_1_a), .b_out(stage_1_b), .c_out(stage_1_c), .d_out(stage_1_d), .e_out(stage_1_e), .f_out(stage_1_f), .g_out(stage_1_g), .h_out(stage_1_h));
  sha256_single_iteration stage_2 (.W(message_1[1]), .K(K[1]), .a(stage_1_a), .b(stage_1_b), .c(stage_1_c), .d(stage_1_d), .e(stage_1_e), .f(stage_1_f), .g(stage_1_g), .h(stage_1_h),.a_out(stage_2_a), .b_out(stage_2_b), .c_out(stage_2_c), .d_out(stage_2_d), .e_out(stage_2_e), .f_out(stage_2_f), .g_out(stage_2_g), .h_out(stage_2_h));
  sha256_single_iteration stage_3 (.W(message_2[2]), .K(K[2]), .a(stage_2_a), .b(stage_2_b), .c(stage_2_c), .d(stage_2_d), .e(stage_2_e), .f(stage_2_f), .g(stage_2_g), .h(stage_2_h),.a_out(stage_3_a), .b_out(stage_3_b), .c_out(stage_3_c), .d_out(stage_3_d), .e_out(stage_3_e), .f_out(stage_3_f), .g_out(stage_3_g), .h_out(stage_3_h));
  sha256_single_iteration stage_4 (.W(message_3[3]), .K(K[3]), .a(stage_3_a), .b(stage_3_b), .c(stage_3_c), .d(stage_3_d), .e(stage_3_e), .f(stage_3_f), .g(stage_3_g), .h(stage_3_h),.a_out(stage_4_a), .b_out(stage_4_b), .c_out(stage_4_c), .d_out(stage_4_d), .e_out(stage_4_e), .f_out(stage_4_f), .g_out(stage_4_g), .h_out(stage_4_h));
  sha256_single_iteration stage_5 (.W(message_4[4]), .K(K[4]), .a(stage_4_a), .b(stage_4_b), .c(stage_4_c), .d(stage_4_d), .e(stage_4_e), .f(stage_4_f), .g(stage_4_g), .h(stage_4_h),.a_out(stage_5_a), .b_out(stage_5_b), .c_out(stage_5_c), .d_out(stage_5_d), .e_out(stage_5_e), .f_out(stage_5_f), .g_out(stage_5_g), .h_out(stage_5_h));
  sha256_single_iteration stage_6 (.W(message_5[5]), .K(K[5]), .a(stage_5_a), .b(stage_5_b), .c(stage_5_c), .d(stage_5_d), .e(stage_5_e), .f(stage_5_f), .g(stage_5_g), .h(stage_5_h),.a_out(stage_6_a), .b_out(stage_6_b), .c_out(stage_6_c), .d_out(stage_6_d), .e_out(stage_6_e), .f_out(stage_6_f), .g_out(stage_6_g), .h_out(stage_6_h));
  sha256_single_iteration stage_7 (.W(message_6[6]), .K(K[6]), .a(stage_6_a), .b(stage_6_b), .c(stage_6_c), .d(stage_6_d), .e(stage_6_e), .f(stage_6_f), .g(stage_6_g), .h(stage_6_h),.a_out(stage_7_a), .b_out(stage_7_b), .c_out(stage_7_c), .d_out(stage_7_d), .e_out(stage_7_e), .f_out(stage_7_f), .g_out(stage_7_g), .h_out(stage_7_h));
  sha256_single_iteration stage_8 (.W(message_7[7]), .K(K[7]), .a(stage_7_a), .b(stage_7_b), .c(stage_7_c), .d(stage_7_d), .e(stage_7_e), .f(stage_7_f), .g(stage_7_g), .h(stage_7_h),.a_out(stage_8_a), .b_out(stage_8_b), .c_out(stage_8_c), .d_out(stage_8_d), .e_out(stage_8_e), .f_out(stage_8_f), .g_out(stage_8_g), .h_out(stage_8_h));
  sha256_single_iteration stage_9 (.W(message_8[8]), .K(K[8]), .a(stage_8_a), .b(stage_8_b), .c(stage_8_c), .d(stage_8_d), .e(stage_8_e), .f(stage_8_f), .g(stage_8_g), .h(stage_8_h),.a_out(stage_9_a), .b_out(stage_9_b), .c_out(stage_9_c), .d_out(stage_9_d), .e_out(stage_9_e), .f_out(stage_9_f), .g_out(stage_9_g), .h_out(stage_9_h));
  sha256_single_iteration stage_10 (.W(message_9[9]), .K(K[9]), .a(stage_9_a), .b(stage_9_b), .c(stage_9_c), .d(stage_9_d), .e(stage_9_e), .f(stage_9_f), .g(stage_9_g), .h(stage_9_h), .a_out(stage_10_a), .b_out(stage_10_b), .c_out(stage_10_c), .d_out(stage_10_d), .e_out(stage_10_e), .f_out(stage_10_f), .g_out(stage_10_g), .h_out(stage_10_h));

  // Output data from the final pipeline stage
  assign digest = {stage_10_a_out, stage_10_b, stage_10_c, stage_10_d, stage_10_e, stage_10_f, stage_10_g, stage_10_h};

  always @(posedge clk) begin
    if (reset) begin
      // Reset all pipeline stages to 0
    //   stage_1_a <= 0; stage_1_b <= 0; stage_1_c <= 0; stage_1_d <= 0; stage_1_e <= 0; stage_1_f <= 0; stage_1_g <= 0; stage_1_h <= 0;
    //   stage_2_a <= 0; stage_2_b <= 0; stage_2_c <= 0; stage_2_d <= 0; stage_2_e <= 0; stage_2_f <= 0; stage_2_g <= 0; stage_2_h <= 0;
    //   stage_3_a <= 0; stage_3_b <= 0; stage_3_c <= 0; stage_3_d <= 0; stage_3_e <= 0; stage_3_f <= 0; stage_3_g <= 0; stage_3_h <= 0;
    //   stage_4_a <= 0; stage_4_b <= 0; stage_4_c <= 0; stage_4_d <= 0; stage_4_e <= 0; stage_4_f <= 0; stage_4_g <= 0; stage_4_h <= 0;
    //   stage_5_a <= 0; stage_5_b <= 0; stage_5_c <= 0; stage_5_d <= 0; stage_5_e <= 0; stage_5_f <= 0; stage_5_g <= 0; stage_5_h <= 0;
    //   stage_6_a <= 0; stage_6_b <= 0; stage_6_c <= 0; stage_6_d <= 0; stage_6_e <= 0; stage_6_f <= 0; stage_6_g <= 0; stage_6_h <= 0;
    //   stage_7_a <= 0; stage_7_b <= 0; stage_7_c <= 0; stage_7_d <= 0; stage_7_e <= 0; stage_7_f <= 0; stage_7_g <= 0; stage_7_h <= 0;
    //   stage_8_a <= 0; stage_8_b <= 0; stage_8_c <= 0; stage_8_d <= 0; stage_8_e <= 0; stage_8_f <= 0; stage_8_g <= 0; stage_8_h <= 0;
    //   stage_9_a <= 0; stage_9_b <= 0; stage_9_c <= 0; stage_9_d <= 0; stage_9_e <= 0; stage_9_f <= 0; stage_9_g <= 0; stage_9_h <= 0;
    //   stage_10_a <= 0; stage_10_b <= 0; stage_10_c <= 0; stage_10_d <= 0; stage_10_e <= 0; stage_10_f <= 0; stage_10_g <= 0; stage_10_h <= 0;
      // reset all message registers to 0
        message_1[0] <= 0; message_1[1] <= 0; message_1[2] <= 0; message_1[3] <= 0; message_1[4] <= 0; message_1[5] <= 0; message_1[6] <= 0; message_1[7] <= 0; message_1[8] <= 0; message_1[9] <= 0;
        message_2[0] <= 0; message_2[1] <= 0; message_2[2] <= 0; message_2[3] <= 0; message_2[4] <= 0; message_2[5] <= 0; message_2[6] <= 0; message_2[7] <= 0; message_2[8] <= 0; message_2[9] <= 0;
        message_3[0] <= 0; message_3[1] <= 0; message_3[2] <= 0; message_3[3] <= 0; message_3[4] <= 0; message_3[5] <= 0; message_3[6] <= 0; message_3[7] <= 0; message_3[8] <= 0; message_3[9] <= 0;
        message_4[0] <= 0; message_4[1] <= 0; message_4[2] <= 0; message_4[3] <= 0; message_4[4] <= 0; message_4[5] <= 0; message_4[6] <= 0; message_4[7] <= 0; message_4[8] <= 0; message_4[9] <= 0;
        message_5[0] <= 0; message_5[1] <= 0; message_5[2] <= 0; message_5[3] <= 0; message_5[4] <= 0; message_5[5] <= 0; message_5[6] <= 0; message_5[7] <= 0; message_5[8] <= 0; message_5[9] <= 0;
        message_6[0] <= 0; message_6[1] <= 0; message_6[2] <= 0; message_6[3] <= 0; message_6[4] <= 0; message_6[5] <= 0; message_6[6] <= 0; message_6[7] <= 0; message_6[8] <= 0; message_6[9] <= 0;
        message_7[0] <= 0; message_7[1] <= 0; message_7[2] <= 0; message_7[3] <= 0; message_7[4] <= 0; message_7[5] <= 0; message_7[6] <= 0; message_7[7] <= 0; message_7[8] <= 0; message_7[9] <= 0;
        message_8[0] <= 0; message_8[1] <= 0; message_8[2] <= 0; message_8[3] <= 0; message_8[4] <= 0; message_8[5] <= 0; message_8[6] <= 0; message_8[7] <= 0; message_8[8] <= 0; message_8[9] <= 0;
        message_9[0] <= 0; message_9[1] <= 0; message_9[2] <= 0; message_9[3] <= 0; message_9[4] <= 0; message_9[5] <= 0; message_9[6] <= 0; message_9[7] <= 0; message_9[8] <= 0; message_9[9] <= 0;
    end else begin
      // Update pipeline stages based on previous stages
    //   stage_1_a <= stage_1_a_out; stage_1_b <= stage_1_b_out; stage_1_c <= stage_1_c_out; stage_1_d <= stage_1_d_out; stage_1_e <= stage_1_e_out; stage_1_f <= stage_1_f_out; stage_1_g <= stage_1_g_out; stage_1_h <= stage_1_h_out;
    //   stage_2_a <= stage_2_a_out; stage_2_b <= stage_2_b_out; stage_2_c <= stage_2_c_out; stage_2_d <= stage_2_d_out; stage_2_e <= stage_2_e_out; stage_2_f <= stage_2_f_out; stage_2_g <= stage_2_g_out; stage_2_h <= stage_2_h_out;
    //   stage_3_a <= stage_3_a_out; stage_3_b <= stage_3_b_out; stage_3_c <= stage_3_c_out; stage_3_d <= stage_3_d_out; stage_3_e <= stage_3_e_out; stage_3_f <= stage_3_f_out; stage_3_g <= stage_3_g_out; stage_3_h <= stage_3_h_out;
    //   stage_4_a <= stage_4_a_out; stage_4_b <= stage_4_b_out; stage_4_c <= stage_4_c_out; stage_4_d <= stage_4_d_out; stage_4_e <= stage_4_e_out; stage_4_f <= stage_4_f_out; stage_4_g <= stage_4_g_out; stage_4_h <= stage_4_h_out;
    //   stage_5_a <= stage_5_a_out; stage_5_b <= stage_5_b_out; stage_5_c <= stage_5_c_out; stage_5_d <= stage_5_d_out; stage_5_e <= stage_5_e_out; stage_5_f <= stage_5_f_out; stage_5_g <= stage_5_g_out; stage_5_h <= stage_5_h_out;
    //   stage_6_a <= stage_6_a_out; stage_6_b <= stage_6_b_out; stage_6_c <= stage_6_c_out; stage_6_d <= stage_6_d_out; stage_6_e <= stage_6_e_out; stage_6_f <= stage_6_f_out; stage_6_g <= stage_6_g_out; stage_6_h <= stage_6_h_out;
    //   stage_7_a <= stage_7_a_out; stage_7_b <= stage_7_b_out; stage_7_c <= stage_7_c_out; stage_7_d <= stage_7_d_out; stage_7_e <= stage_7_e_out; stage_7_f <= stage_7_f_out; stage_7_g <= stage_7_g_out; stage_7_h <= stage_7_h_out;
    //   stage_8_a <= stage_8_a_out; stage_8_b <= stage_8_b_out; stage_8_c <= stage_8_c_out; stage_8_d <= stage_8_d_out; stage_8_e <= stage_8_e_out; stage_8_f <= stage_8_f_out; stage_8_g <= stage_8_g_out; stage_8_h <= stage_8_h_out;
    //   stage_9_a <= stage_9_a_out; stage_9_b <= stage_9_b_out; stage_9_c <= stage_9_c_out; stage_9_d <= stage_9_d_out; stage_9_e <= stage_9_e_out; stage_9_f <= stage_9_f_out; stage_9_g <= stage_9_g_out; stage_9_h <= stage_9_h_out;
    //   stage_10_a <= stage_10_a_out; stage_10_b <= stage_10_b_out; stage_10_c <= stage_10_c_out; stage_10_d <= stage_10_d_out; stage_10_e <= stage_10_e_out; stage_10_f <= stage_10_f_out; stage_10_g <= stage_10_g_out; stage_10_h <= stage_10_h_out;
      // pass the message to the next stage 
      message_1[0] <= message[0]; message_1[1] <= message[1]; message_1[2] <= message[2]; message_1[3] <= message[3]; message_1[4] <= message[4]; message_1[5] <= message[5]; message_1[6] <= message[6]; message_1[7] <= message[7]; message_1[8] <= message[8]; message_1[9] <= message[9];
      message_2[0] <= message_1[0]; message_2[1] <= message_1[1]; message_2[2] <= message_1[2]; message_2[3] <= message_1[3]; message_2[4] <= message_1[4]; message_2[5] <= message_1[5]; message_2[6] <= message_1[6]; message_2[7] <= message_1[7]; message_2[8] <= message_1[8]; message_2[9] <= message_1[9];
      message_3[0] <= message_2[0]; message_3[1] <= message_2[1]; message_3[2] <= message_2[2]; message_3[3] <= message_2[3]; message_3[4] <= message_2[4]; message_3[5] <= message_2[5]; message_3[6] <= message_2[6]; message_3[7] <= message_2[7]; message_3[8] <= message_2[8]; message_3[9] <= message_2[9];
      message_4[0] <= message_3[0]; message_4[1] <= message_3[1]; message_4[2] <= message_3[2]; message_4[3] <= message_3[3]; message_4[4] <= message_3[4]; message_4[5] <= message_3[5]; message_4[6] <= message_3[6]; message_4[7] <= message_3[7]; message_4[8] <= message_3[8]; message_4[9] <= message_3[9];
      message_5[0] <= message_4[0]; message_5[1] <= message_4[1]; message_5[2] <= message_4[2]; message_5[3] <= message_4[3]; message_5[4] <= message_4[4]; message_5[5] <= message_4[5]; message_5[6] <= message_4[6]; message_5[7] <= message_4[7]; message_5[8] <= message_4[8]; message_5[9] <= message_4[9];
      message_6[0] <= message_5[0]; message_6[1] <= message_5[1]; message_6[2] <= message_5[2]; message_6[3] <= message_5[3]; message_6[4] <= message_5[4]; message_6[5] <= message_5[5]; message_6[6] <= message_5[6]; message_6[7] <= message_5[7]; message_6[8] <= message_5[8]; message_6[9] <= message_5[9];
      message_7[0] <= message_6[0]; message_7[1] <= message_6[1]; message_7[2] <= message_6[2]; message_7[3] <= message_6[3]; message_7[4] <= message_6[4]; message_7[5] <= message_6[5]; message_7[6] <= message_6[6]; message_7[7] <= message_6[7]; message_7[8] <= message_6[8]; message_7[9] <= message_6[9];
      message_8[0] <= message_7[0]; message_8[1] <= message_7[1]; message_8[2] <= message_7[2]; message_8[3] <= message_7[3]; message_8[4] <= message_7[4]; message_8[5] <= message_7[5]; message_8[6] <= message_7[6]; message_8[7] <= message_7[7]; message_8[8] <= message_7[8]; message_8[9] <= message_7[9];
      message_9[0] <= message_8[0]; message_9[1] <= message_8[1]; message_9[2] <= message_8[2]; message_9[3] <= message_8[3]; message_9[4] <= message_8[4]; message_9[5] <= message_8[5]; message_9[6] <= message_8[6]; message_9[7] <= message_8[7]; message_9[8] <= message_8[8]; message_9[9] <= message_8[9];
    end
  end

 

endmodule