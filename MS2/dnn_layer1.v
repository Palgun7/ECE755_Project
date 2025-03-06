module dnn_layer1 #(
    parameter IN_SIZE = 7,   // Bit width of inputs
    parameter OUT_SIZE = 17  // Bit width of outputs
)(
    input clk, in_ready,
    input signed [IN_SIZE-1:0] x0, x1, x2, x3,   // Inputs
    input signed [IN_SIZE-1:0] w04, w05, w06, w07, // Weights for in0
    input signed [IN_SIZE-1:0] w14, w15, w16, w17, // Weights for in1
    input signed [IN_SIZE-1:0] w24, w25, w26, w27, // Weights for in2
    input signed [IN_SIZE-1:0] w34, w35, w36, w37, // Weights for in3
    output signed [OUT_SIZE-1:0] out4, out5, out6, out7,    // Outputs before ReLU
    output reg mac_ready
);

    // Multiply and Accumulate (MAC) operations
    reg signed [OUT_SIZE-1:0] mac_out0, mac_out1;
    
    always @(posedge clk) begin
        if (in_ready) begin
            mac_out4 <= (w04 * x0) + (w14 * x1) + (w24 * x2) + (w34 * x3);
            mac_out5 <= (w05 * x0) + (w15 * x1) + (w25 * x2) + (w35 * x3);
            mac_out6 <= (w06 * x0) + (w16 * x1) + (w26 * x2) + (w36 * x3);
            mac_out7 <= (w07 * x0) + (w17 * x1) + (w27 * x2) + (w37 * x3);           
            mac_ready <= 1;
        end else begin
            mac_ready <= 0;
        end
    end

    assign out4 = mac_out4;
    assign out5 = mac_out5;
    assign out6 = mac_out6;
    assign out7 = mac_out7;

endmodule
