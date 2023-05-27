module SHA256_Testbench;

  // Parameters
  parameter DATA_WIDTH = 32;  // Width of the data input

  // I/O
  reg [DATA_WIDTH-1:0] data_in [0:9] = {32'h41414141,32'h42424242,32'h43434343,32'h44444444,32'h45454545,32'h46464646,32'h47474747,32'h48484848,32'h49494949,32'h4a4a4a4a};
  wire [DATA_WIDTH-1:0] data_out [0:7];
  reg [DATA_WIDTH-1:0] W = data_out[0];


  // Clock and reset
    reg clk = 0;
    always #1 clk = ~clk;
    reg reset = 1;

  TenStagePipeline sha256_pipe (
    .clk(clk),
    .reset(reset),
    .message(data_in),
    .digest(data_out)
    );
  integer i = 0;
  integer j = 0;
  integer cycle = 1;
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    reset = 1;
    #1;
    reset = 0;
    while(i < 2) begin
      	j = 0;
        while(j < 10) begin  // print all stages
        #2;
        $display("CYCLE %d BLOCK %d NEW INPUT %h %h %h %h %h %h %h %h\n---------------------------------------------------",cycle, i, data_in[0],data_in[1],data_in[2],data_in[3],data_in[4],data_in[5],data_in[6],data_in[7]);
        $display("s1:  %h %h %h %h %h %h %h %h", sha256_pipe.stage_1_a, sha256_pipe.stage_1_b, sha256_pipe.stage_1_c, sha256_pipe.stage_1_d, sha256_pipe.stage_1_e, sha256_pipe.stage_1_f, sha256_pipe.stage_1_g, sha256_pipe.stage_1_h);
        $display("s2:  %h %h %h %h %h %h %h %h", sha256_pipe.stage_2_a, sha256_pipe.stage_2_b, sha256_pipe.stage_2_c, sha256_pipe.stage_2_d, sha256_pipe.stage_2_e, sha256_pipe.stage_2_f, sha256_pipe.stage_2_g, sha256_pipe.stage_2_h);
        $display("s3:  %h %h %h %h %h %h %h %h", sha256_pipe.stage_3_a, sha256_pipe.stage_3_b, sha256_pipe.stage_3_c, sha256_pipe.stage_3_d, sha256_pipe.stage_3_e, sha256_pipe.stage_3_f, sha256_pipe.stage_3_g, sha256_pipe.stage_3_h);
        $display("s4:  %h %h %h %h %h %h %h %h", sha256_pipe.stage_4_a, sha256_pipe.stage_4_b, sha256_pipe.stage_4_c, sha256_pipe.stage_4_d, sha256_pipe.stage_4_e, sha256_pipe.stage_4_f, sha256_pipe.stage_4_g, sha256_pipe.stage_4_h);
        $display("s5:  %h %h %h %h %h %h %h %h", sha256_pipe.stage_5_a, sha256_pipe.stage_5_b, sha256_pipe.stage_5_c, sha256_pipe.stage_5_d, sha256_pipe.stage_5_e, sha256_pipe.stage_5_f, sha256_pipe.stage_5_g, sha256_pipe.stage_5_h);
        $display("s6:  %h %h %h %h %h %h %h %h", sha256_pipe.stage_6_a, sha256_pipe.stage_6_b, sha256_pipe.stage_6_c, sha256_pipe.stage_6_d, sha256_pipe.stage_6_e, sha256_pipe.stage_6_f, sha256_pipe.stage_6_g, sha256_pipe.stage_6_h);
        $display("s7:  %h %h %h %h %h %h %h %h", sha256_pipe.stage_7_a, sha256_pipe.stage_7_b, sha256_pipe.stage_7_c, sha256_pipe.stage_7_d, sha256_pipe.stage_7_e, sha256_pipe.stage_7_f, sha256_pipe.stage_7_g, sha256_pipe.stage_7_h);
        $display("s8:  %h %h %h %h %h %h %h %h", sha256_pipe.stage_8_a, sha256_pipe.stage_8_b, sha256_pipe.stage_8_c, sha256_pipe.stage_8_d, sha256_pipe.stage_8_e, sha256_pipe.stage_8_f, sha256_pipe.stage_8_g, sha256_pipe.stage_8_h);
        $display("s9:  %h %h %h %h %h %h %h %h", sha256_pipe.stage_9_a, sha256_pipe.stage_9_b, sha256_pipe.stage_9_c, sha256_pipe.stage_9_d, sha256_pipe.stage_9_e, sha256_pipe.stage_9_f, sha256_pipe.stage_9_g, sha256_pipe.stage_9_h);
        $display("s10: %h %h %h %h %h %h %h %h", sha256_pipe.stage_10_a, sha256_pipe.stage_10_b, sha256_pipe.stage_10_c, sha256_pipe.stage_10_d, sha256_pipe.stage_10_e, sha256_pipe.stage_10_f, sha256_pipe.stage_10_g, sha256_pipe.stage_10_h);
        j = j + 1;
        cycle = cycle + 1;
          data_in[0] = data_in[0] + 1; // to give a new input (next block)
        end
    i = i + 1;
    end

  $finish;
  end
endmodule