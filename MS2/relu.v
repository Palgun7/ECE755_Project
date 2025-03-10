module relu #(parameter RELU_SIZE = 21) 
    (   
    input clk, in_ready,
    input  signed [RELU_SIZE - 1 : 0] in0, in1, in2, in3,
    
    output reg relu_ready,
    output reg signed [RELU_SIZE - 1 : 0] out0, out1, out2, out3
    );

    //ReLu Function 
	always @(posedge clk) begin         
        if(in_ready) begin
            //If negative number then assign as 0 else assign y
            out0 <= (in0 [RELU_SIZE -1]) ? 'b0 : in0;
            out1 <= (in1 [RELU_SIZE -1]) ? 'b0 : in1;
            out2 <= (in2 [RELU_SIZE -1]) ? 'b0 : in2;
            out3 <= (in3 [RELU_SIZE -1]) ? 'b0 : in3;
        end
        relu_ready <= in_ready;
    end
endmodule