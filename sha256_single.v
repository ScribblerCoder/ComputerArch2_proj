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
  reg [31:0] t1, t2, ch, maj, Sum0, Sum1, Sigma0, Sigma1;

// Single iteration computation
always @(*) begin
    ch = Ch(e, f, g);
    maj = Maj(a, b, c);
    Sum0 = sum0(a);
    Sum1 = sum1(e);
    t1 = h + Sum1 + ch + K + W;
    t2 = Sum0 + maj;
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
