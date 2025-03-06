module dnn_layer2 #(
    parameter IN_SIZE = 17,   // Bit width of inputs
    parameter OUT_SIZE = 21  // Bit width of outputs
)(
    input clk, in_ready,
    input signed [IN_SIZE-1:0] x0, x1, x2, x3,   // Inputs
    input signed [IN_SIZE-1:0] w48, w58, w68, w78, 
    input signed [IN_SIZE-1:0] w49, w59, w69, w79,
    output signed [OUT_SIZE-1:0] output0, output1,   
    output reg mac_ready0, mac_ready1
);

    // Multiply and Accumulate (MAC) operations
    reg signed [OUT_SIZE-1:0] mac_out0, mac_out1;
    
    always @(posedge clk) begin
        if (in_ready) begin
            mac_out0 <= (w48 * x0) + (w58 * x1) + (w68 * x2) + (w78 * x3);
            mac_out1 <= (w49 * x0) + (w59 * x1) + (w69 * x2) + (w79 * x3);
          
            mac_ready0 <= 1;
            mac_ready1 <= 1;
        end else begin
            mac_ready0 <= 0;
            mac_ready1 <= 0;
        end
    end

    assign output0 = mac_out0;
    assign output1 = mac_out1;

endmodule
