`timescale 1ns / 1ps
`include "pwm_controller.v"
module pwm_controller_tb;
reg clk,rst,start;
wire pwm_out;

pwm_controller dut (
    .clk(clk),
    .rst(rst),
    .start(start),
    .pwm_out(pwm_out)
);

// Clock Generation
initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;

end
initial begin
    $dumpfile("pwm_controller.vcd");
    $dumpvars;
    rst = 1'b1;
    #10;
    rst = 1'b0;
    #10;
    start = 1'b1; // Start PWM generation
    #1500 $finish;
end
endmodule