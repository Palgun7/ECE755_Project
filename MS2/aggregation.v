module aggregation #(
    parameter AGGR_IN_SIZE = 5, 
    parameter AGGR_OUT_SIZE = 7
) (
    input clk, 
    input in_ready_aggr,
    input signed [AGGR_IN_SIZE - 1:0]  x0_n0, x1_n0, x2_n0, x3_n0,
                                       x0_n1, x1_n1, x2_n1, x3_n1,
                                       x0_n2, x1_n2, x2_n2, x3_n2,
                                       x0_n3, x1_n3, x2_n3, x3_n3,
    output reg out_ready_aggr,
    output reg signed [AGGR_OUT_SIZE - 1:0]  x0_n0_aggr, x0_n1_aggr, x0_n2_aggr, x0_n3_aggr,
                                             x1_n0_aggr, x1_n1_aggr, x1_n2_aggr, x1_n3_aggr,
                                             x2_n0_aggr, x2_n1_aggr, x2_n2_aggr, x2_n3_aggr,
                                             x3_n0_aggr, x3_n1_aggr, x3_n2_aggr, x3_n3_aggr
);

always @(posedge clk) begin
    if (in_ready_aggr) begin
        // Aggregation for Input x0
        x0_n0_aggr <= x0_n0 + x0_n1 + x0_n2;
        x1_n0_aggr <= x1_n0 + x1_n1 + x1_n2;
        x2_n0_aggr <= x2_n0 + x2_n1 + x2_n2;
        x3_n0_aggr <= x3_n0 + x3_n1 + x3_n2;

        x0_n1_aggr <= x0_n0 + x0_n1 + x0_n3;
        x1_n1_aggr <= x1_n0 + x1_n1 + x1_n3;
        x2_n1_aggr <= x2_n0 + x2_n1 + x2_n3;
        x3_n1_aggr <= x3_n0 + x3_n1 + x3_n3;
  
        x0_n2_aggr <= x0_n0 + x0_n2 + x0_n3;
        x1_n2_aggr <= x1_n0 + x1_n2 + x1_n3;
        x2_n2_aggr <= x2_n0 + x2_n2 + x2_n3;
        x3_n2_aggr <= x3_n0 + x3_n2 + x3_n3;

        x0_n3_aggr <= x0_n1 + x0_n2 + x0_n3;
        x1_n3_aggr <= x1_n1 + x1_n2 + x1_n3;
        x2_n3_aggr <= x2_n1 + x2_n2 + x2_n3;
        x3_n3_aggr <= x3_n1 + x3_n2 + x3_n3;

    end
    out_ready_aggr <= in_ready_aggr;
end

endmodule
