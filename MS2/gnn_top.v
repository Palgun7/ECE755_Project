module gnn_top #( 
     AGGR_OUT_SIZE = 7,
     WEIGHTED_OUT1_SIZE = 17,
     AGGR_IN_SIZE = 5,
     OUTPUT_SIZE  = 21

)(
     input signed [4:0] x0_node0, x1_node0, x2_node0, x3_node0;
     input signed [4:0] x0_node1, x1_node1, x2_node1, x3_node1;
     input signed [4:0] x0_node2, x1_node2, x2_node2, x3_node2;
     input signed [4:0] x0_node3, x1_node3, x2_node3, x3_node3;
     input signed [4:0] w04, w14, w24, w34;
     input signed [4:0] w05, w15, w25, w35;
     input signed [4:0] w06, w16, w26, w36;
     input signed [4:0] w07, w17, w27, w37;
     input signed [4:0] w48, w58, w68, w78;
     input signed [4:0] w49, w59, w69, w79;
     input signed clk;
     output [20:0] out0_node0, out1_node0;
     output [20:0] out0_node1, out1_node1;
     output [20:0] out0_node2, out1_node2;
     output [20:0] out0_node3, out1_node3;
     output out10_ready_node0, out11_ready_node0;
     output out10_ready_node1, out11_ready_node1;
     output out10_ready_node2, out11_ready_node2;
     output out10_ready_node3, out11_ready_node3;
);

// Wires for first aggregation (aggr -> dnn_layer_1)
wire aggr_ready_1;
wire signed [AGGR_OUT_SIZE - 1:0] x0_n0_aggr, x0_n1_aggr, x0_n2_aggr, x0_n3_aggr;
wire signed [AGGR_OUT_SIZE - 1:0] x1_n0_aggr, x1_n1_aggr, x1_n2_aggr, x1_n3_aggr;
wire signed [AGGR_OUT_SIZE - 1:0] x2_n0_aggr, x2_n1_aggr, x2_n2_aggr, x2_n3_aggr;
wire signed [AGGR_OUT_SIZE - 1:0] x3_n0_aggr, x3_n1_aggr, x3_n2_aggr, x3_n3_aggr;

// Wires for first DNN layer (dnn_layer_1 -> aggr)

wire signed [WEIGHTED_OUT_SIZE-1:0] y4_n0, y5_n0, y6_n0, y7_n0;
wire signed [WEIGHTED_OUT_SIZE-1:0] y4_n1, y5_n1, y6_n1, y7_n1;
wire signed [WEIGHTED_OUT_SIZE-1:0] y4_n2, y5_n2, y6_n2, y7_n2;
wire signed [WEIGHTED_OUT_SIZE-1:0] y4_n3, y5_n3, y6_n3, y7_n3;
wire mac_ready_n0, mac_ready_n1, mac_ready_n2, mac_ready_n3;

// Wires for second aggregation (aggr -> relu)
wire signed [OUTPUT_SIZE-1:0] y4_n0_aggr, y4_n1_aggr, y4_n2_aggr, y4_n3_aggr;
wire signed [OUTPUT_SIZE-1:0] y5_n0_aggr, y5_n1_aggr, y5_n2_aggr, y5_n3_aggr;
wire signed [OUTPUT_SIZE-1:0] y6_n0_aggr, y6_n1_aggr, y6_n2_aggr, y6_n3_aggr;
wire signed [OUTPUT_SIZE-1:0] y7_n0_aggr, y7_n1_aggr, y7_n2_aggr, y7_n3_aggr;
wire aggr_ready_2;

// Wires for RELU outputs
wire signed [OUTPUT_SIZE-1:0] y4_n0_relu, y4_n1_relu, y4_n2_relu, y4_n3_relu;
wire signed [OUTPUT_SIZE-1:0] y5_n0_relu, y5_n1_relu, y5_n2_relu, y5_n3_relu;
wire signed [OUTPUT_SIZE-1:0] y6_n0_relu, y6_n1_relu, y6_n2_relu, y6_n3_relu;
wire signed [OUTPUT_SIZE-1:0] y7_n0_relu, y7_n1_relu, y7_n2_relu, y7_n3_relu;
wire relu_ready;







// First Aggregation Stage
aggregation #(.AGGR_IN_SIZE(AGGR_IN_SIZE), .AGGR_OUT_SIZE(AGGR_OUT_SIZE)) 
    aggr_inst1 (
        .clk(clk), 
        .in_ready_aggr(in_ready),
        .x0_n0(x0_node0), .x1_n0(x1_node0), .x2_n0(x2_node0), .x3_n0(x3_node0),
        .x0_n1(x0_node1), .x1_n1(x1_node1), .x2_n1(x2_node1), .x3_n1(x3_node1),
        .x0_n2(x0_node2), .x1_n2(x1_node2), .x2_n2(x2_node2), .x3_n2(x3_node2),
        .x0_n3(x0_node3), .x1_n3(x1_node3), .x2_n3(x2_node3), .x3_n3(x3_node3),
        .x0_n0_aggr(x0_n0_aggr), .x0_n1_aggr(x0_n1_aggr), .x0_n2_aggr(x0_n2_aggr), .x0_n3_aggr(x0_n3_aggr),
        .x1_n0_aggr(x1_n0_aggr), .x1_n1_aggr(x1_n1_aggr), .x1_n2_aggr(x1_n2_aggr), .x1_n3_aggr(x1_n3_aggr),
        .x2_n0_aggr(x2_n0_aggr), .x2_n1_aggr(x2_n1_aggr), .x2_n2_aggr(x2_n2_aggr), .x2_n3_aggr(x2_n3_aggr),
        .x3_n0_aggr(x3_n0_aggr), .x3_n1_aggr(x3_n1_aggr), .x3_n2_aggr(x3_n2_aggr), .x3_n3_aggr(x3_n3_aggr),
        .out_ready_aggr(aggr_ready_1)
    );

dnn_layer1 #(.IN_SIZE(AGGR_OUT_SIZE), .OUT_SIZE(WEIGHTED_OUT_SIZE)) 
    dnn_node0 (
        .clk(clk), 
        .in_ready(aggr_ready_1),
        .x0(x0_n0_aggr), .x1(x1_n0_aggr), .x2(x2_n0_aggr), .x3(x3_n0_aggr),
        .w04(w04), .w05(w05), .w06(w06), .w07(w07),
        .w14(w14), .w15(w15), .w16(w16), .w17(w17),
        .w24(w24), .w25(w25), .w26(w26), .w27(w27),
        .w34(w34), .w35(w35), .w36(w36), .w37(w37),
        .out4(y4_n0), .out5(y5_n0), .out6(y6_n0), .out7(y7_n0),
        .mac_ready(mac_ready_n0)
    );

dnn_layer1 #(.IN_SIZE(AGGR_OUT_SIZE), .OUT_SIZE(WEIGHTED_OUT_SIZE)) 
    dnn_node1 (
        .clk(clk), 
        .in_ready(aggr_ready_1),
        .x0(x0_n1_aggr), .x1(x1_n1_aggr), .x2(x2_n1_aggr), .x3(x3_n1_aggr),
        .w04(w04), .w05(w05), .w06(w06), .w07(w07),
        .w14(w14), .w15(w15), .w16(w16), .w17(w17),
        .w24(w24), .w25(w25), .w26(w26), .w27(w27),
        .w34(w34), .w35(w35), .w36(w36), .w37(w37),
        .out4(y4_n1), .out5(y5_n1), .out6(y6_n1), .out7(y7_n1),
        .mac_ready(mac_ready_n1)
    );

dnn_layer1 #(.IN_SIZE(AGGR_OUT_SIZE), .OUT_SIZE(WEIGHTED_OUT_SIZE)) 
    dnn_node2 (
        .clk(clk), 
        .in_ready(aggr_ready_1),
        .x0(x0_n2_aggr), .x1(x1_n2_aggr), .x2(x2_n2_aggr), .x3(x3_n2_aggr),
        .w04(w04), .w05(w05), .w06(w06), .w07(w07),
        .w14(w14), .w15(w15), .w16(w16), .w17(w17),
        .w24(w24), .w25(w25), .w26(w26), .w27(w27),
        .w34(w34), .w35(w35), .w36(w36), .w37(w37),
        .out4(y4_n2), .out5(y5_n2), .out6(y6_n2), .out7(y7_n2),
        .mac_ready(mac_ready_n2)
    );

dnn_layer1 #(.IN_SIZE(AGGR_OUT_SIZE), .OUT_SIZE(WEIGHTED_OUT_SIZE)) 
    dnn_node3 (
        .clk(clk), 
        .in_ready(aggr_ready_1),
        .x0(x0_n3_aggr), .x1(x1_n3_aggr), .x2(x2_n3_aggr), .x3(x3_n3_aggr),
        .w04(w04), .w05(w05), .w06(w06), .w07(w07),
        .w14(w14), .w15(w15), .w16(w16), .w17(w17),
        .w24(w24), .w25(w25), .w26(w26), .w27(w27),
        .w34(w34), .w35(w35), .w36(w36), .w37(w37),
        .out4(y4_n3), .out5(y5_n3), .out6(y6_n3), .out7(y7_n3),
        .mac_ready(mac_ready_n3)
    );

// Second Aggregation Stage
aggregation #(.AGGR_IN_SIZE(WEIGHTED_OUT_SIZE), .AGGR_OUT_SIZE(OUTPUT_SIZE)) 
    aggr_inst1 (
        .clk(clk), 
        .in_ready_aggr(mac_ready_n0 & mac_ready_n1 & mac_ready_n2 & mac_ready_n3),
        .x0_n0(y4_n0), .x1_n0(y5_n0), .x2_n0(y6_n0), .x3_n0(y7_n0),
        .x0_n1(y4_n1), .x1_n1(y5_n1), .x2_n1(y6_n1), .x3_n1(y7_n1),
        .x0_n2(y4_n2), .x1_n2(y5_n2), .x2_n2(y6_n2), .x3_n2(y7_n2),
        .x0_n3(y4_n3), .x1_n3(y5_n3), .x2_n3(y6_n3), .x3_n3(y7_n3),
        .x0_n0_aggr(y4_n0_aggr), .x0_n1_aggr(y4_n1_aggr), .x0_n2_aggr(y4_n2_aggr), .x0_n3_aggr(y4_n3_aggr),
        .x1_n0_aggr(y5_n0_aggr), .x1_n1_aggr(y5_n1_aggr), .x1_n2_aggr(y5_n2_aggr), .x1_n3_aggr(y5_n3_aggr),
        .x2_n0_aggr(y6_n0_aggr), .x2_n1_aggr(y6_n1_aggr), .x2_n2_aggr(y6_n2_aggr), .x2_n3_aggr(y6_n3_aggr),
        .x3_n0_aggr(y7_n0_aggr), .x3_n1_aggr(y7_n1_aggr), .x3_n2_aggr(y7_n2_aggr), .x3_n3_aggr(y7_n3_aggr),
        .out_ready_aggr(aggr_ready_2)
    );


relu_4n #(.RELU4_SIZE(OUTPUT_SIZE)) 
    relu_inst (
        .clk(clk), 
        .in_ready(aggr_ready_2),
        .in0_n0(y4_n0_aggr), .in1_n0(y5_n0_aggr), .in2_n0(y6_n0_aggr), .in3_n0(y7_n0_aggr),
        .in0_n1(y4_n1_aggr), .in1_n1(y5_n1_aggr), .in2_n1(y6_n1_aggr), .in3_n1(y7_n1_aggr),
        .in0_n2(y4_n2_aggr), .in1_n2(y5_n2_aggr), .in2_n2(y6_n2_aggr), .in3_n2(y7_n2_aggr),
        .in0_n3(y4_n3_aggr), .in1_n3(y5_n3_aggr), .in2_n3(y6_n3_aggr), .in3_n3(y7_n3_aggr),
        .out0_n0(y4_n0_relu), .out1_n0(y5_n0_relu), .out2_n0(y6_n0_relu), .out3_n0(y7_n0_relu),
        .out0_n1(y4_n1_relu), .out1_n1(y5_n1_relu), .out2_n1(y6_n1_relu), .out3_n1(y7_n1_relu),
        .out0_n2(y4_n2_relu), .out1_n2(y5_n2_relu), .out2_n2(y6_n2_relu), .out3_n2(y7_n2_relu),
        .out0_n3(y4_n3_relu), .out1_n3(y5_n3_relu), .out2_n3(y6_n3_relu), .out3_n3(y7_n3_relu),
        .relu_ready(relu_ready)
    );






//Implementation of GNN
endmodule