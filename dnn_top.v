module top (
    input clk,
    input in_ready,
    input signed [4:0] x0, x1, x2, x3, 
    input signed [4:0] w04, w05, w06, w07, 
    input signed [4:0] w14, w15, w16, w17, 
    input signed [4:0] w24, w25, w26, w27, 
    input signed [4:0] w34, w35, w36, w37,
    input signed [4:0] w48, w58, w68, w78, 
    input signed [4:0] w49, w59, w69, w79,
    output reg signed [16:0] out0, out1,
    output reg out0_ready, out1_ready
);

    reg signed [14:0] y4, y5, y6, y7;   // Hidden layer outputs (15-bit signed)
    reg signed [14:0] y4_relu, y5_relu, y6_relu, y7_relu; // ReLU outputs
    reg signed [16:0] out0_reg, out1_reg;

    //Compute first hidden layer outputs
    always @(posedge clk) begin
        if (in_ready) begin
            y4 <= (x0 * w04) + (x1 * w14) + (x2 * w24) + (x3 * w34);
            y5 <= (x0 * w05) + (x1 * w15) + (x2 * w25) + (x3 * w35);
            y6 <= (x0 * w06) + (x1 * w16) + (x2 * w26) + (x3 * w36);
            y7 <= (x0 * w07) + (x1 * w17) + (x2 * w27) + (x3 * w37);
        end
    end

    // ReLU Activation layer
    always @(posedge clk) begin
        y4_relu <= (y4 < 0) ? 0 : y4;
        y5_relu <= (y5 < 0) ? 0 : y5;
        y6_relu <= (y6 < 0) ? 0 : y6;
        y7_relu <= (y7 < 0) ? 0 : y7;
    end

    // Compute second layer outputs
    always @(posedge clk) begin
        out0_reg <= (y4_relu * w48) + (y5_relu * w58) + (y6_relu * w68) + (y7_relu * w78);
        out1_reg <= (y4_relu * w49) + (y5_relu * w59) + (y6_relu * w69) + (y7_relu * w79);
    end

    //Assign outputs
    always @(posedge clk) begin
        out0 <= out0_reg;
        out1 <= out1_reg;
        out0_ready <= out0_reg ? 1 : 0;
        out1_ready <= out1_reg ? 1 : 0;
    end

endmodule