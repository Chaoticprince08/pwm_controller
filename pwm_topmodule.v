`timescale 1ns/1ps
`include "clk_divider.v"
`include "pwm_controller.v"
`include "lcd_module.v"

module pdm_topmodule (
    input clk,
    input rst,
    input start,
    output pwm_out,
    output [6:0] seg,
    output [3:0] digit
);

wire slow_clk;
wire [2:0] count;
wire [6:0] seg;
wire [3:0] digit;
//Instantiate the PWM Controller module
pwm_controller inst1 (
    .clk(slow_clk),
    .rst(rst),
    .start(start),
    .pwm_out(pwm_out),
    .count(count)
);

// Instantiate the Clock Divider module
clock_divider inst2 (
    .clk(clk),
    .rst(rst),
    .slow_clk(slow_clk)
);

//Seven Segment Display module instantiation
lcd_module inst3 (
    .clk(slow_clk),
    .rst(rst),
    .count(count),
    .seg(seg),
    .digit(digit)
);

    
endmodule