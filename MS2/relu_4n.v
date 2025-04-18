module relu_4n #(parameter RELU4_SIZE = 17) (
    input  signed [RELU4_SIZE - 1 : 0]    in0_n0, in1_n0, in2_n0, in3_n0,
                                            in0_n1, in1_n1, in2_n1, in3_n1,
                                            in0_n2, in1_n2, in2_n2, in3_n2,
                                            in0_n3, in1_n3, in2_n3, in3_n3,
    input clk, in_ready,

    output signed [RELU4_SIZE - 1 : 0]    out0_n0, out1_n0, out2_n0, out3_n0,
                                            out0_n1, out1_n1, out2_n1, out3_n1,
                                            out0_n2, out1_n2, out2_n2, out3_n2,
                                            out0_n3, out1_n3, out2_n3, out3_n3,
    output relu_ready);

    wire relu_ready_0, relu_ready_1, relu_ready_2, relu_ready_3;

    
    relu    #(.RELU_SIZE(RELU4_SIZE)) 
        R0  (.clk(clk), .in_ready(in_ready),
            .in0(in0_n0), .in1(in1_n0), .in2(in2_n0), .in3(in3_n0),
            .out0(out0_n0),.out1(out1_n0), .out2(out2_n0), .out3(out3_n0),
            .relu_ready(relu_ready_0));
    
    relu    #(.RELU_SIZE(RELU4_SIZE)) 
        R1  (.clk(clk), .in_ready(in_ready),
            .in0(in0_n1), .in1(in1_n1), .in2(in2_n1), .in3(in3_n1),
            .out0(out0_n1),.out1(out1_n1), .out2(out2_n1), .out3(out3_n1),
            .relu_ready(relu_ready_1));
    
    relu    #(.RELU_SIZE(RELU4_SIZE)) 
        R2  (.clk(clk), .in_ready(in_ready),
            .in0(in0_n2), .in1(in1_n2), .in2(in2_n2), .in3(in3_n2),
            .out0(out0_n2),.out1(out1_n2), .out2(out2_n2), .out3(out3_n2),
            .relu_ready(relu_ready_2));
    
    relu    #(.RELU_SIZE(RELU4_SIZE)) 
        R3  (.clk(clk), .in_ready(in_ready),
            .in0(in0_n3), .in1(in1_n3), .in2(in2_n3), .in3(in3_n3),
            .out0(out0_n3),.out1(out1_n3), .out2(out2_n3), .out3(out3_n3),
            .relu_ready(relu_ready_3));
        
    
    assign relu_ready = relu_ready_0 & relu_ready_1 & relu_ready_2 & relu_ready_3; 


endmodule