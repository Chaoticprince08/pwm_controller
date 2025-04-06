`timescale 1ns / 1ps
module pwm_controller (
    input clk,
    input rst,
    input start,
    output reg pwm_out,
    output reg [2:0] count
);

reg [1:0] PS,NS; //State Registers
parameter [1:0] idle = 2'b00; //Idle State
parameter [1:0] PWM_40 = 2'b01; //PWM 40% State
parameter [1:0] PWM_60 = 2'b10; //PWM 60% State
parameter [1:0] PWM_80 = 2'b11; //PWM 80% State

//State Updation Logic
always @(posedge clk or posedge rst) begin
    if (rst) begin
        PS <= idle; //Reset to Idle State
    end else begin
        PS <= NS; //Update State
    end
end

//Counter Logic
//reg [2:0] count;

//Counter to control the PWM signal 
/*Counter is reset to 0 when rst is high or when count reaches 4.
The counter will count from 0 to 4, 
then reset to 0 therefore here a OR gate is realized to reset the counter when it reaches 4.*/
always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 3'b000; //Reset Counter
    end
    else if (count ==4) begin
        count <= 3'b000; //Reset Counter to 0
    end
    else begin
        count <= count + 1; //Increment Counter
    end
end

//State Transistion Logic
/* Asynchronous rst is used and at every state whenever count reached to 4 it will move to the next state*/
always @(start or rst or PS or count) begin
    if(rst) begin
        NS = idle; //Reset to Idle State
    end
    else begin
        case (PS)
            idle: begin
                if (start) begin
                    NS = PWM_40; //Transition to PWM 40% State
                end 
                else begin
                    NS = idle; //Stay in Idle State
                end
            end
            PWM_40: begin
                if (count == 4) begin
                    NS = PWM_60; //Transition to PWM 60% State
                end 
                else begin
                    NS = PWM_40; //Stay in PWM 40% State
                end
            end
            PWM_60: begin
                if (count == 4) begin
                    NS = PWM_80; //Transition to PWM 80% State
                end 
                else begin
                    NS = PWM_60; //Stay in PWM 60% State
                end
            end
            PWM_80: begin
                if (count == 4) begin
                    NS = PWM_40; //Transition to PWM 40% State
                end 
                else begin
                    NS = PWM_80; //Stay in PWM 80% State
                end
            end 
            default: NS = idle; //Default case to Idle State
        endcase
    end
end

//Output Logic

always @(PS or count) begin
    case(PS) 
        idle: begin
            pwm_out = 1'b0; //Output Low in Idle State
        end
        PWM_40: begin
            if (count <= 1) begin
                pwm_out = 1'b1; //Output High for 40% duty cycle
            end 
            else begin
                pwm_out = 1'b0; //Output Low for 60% duty cycle
            end
        end
        PWM_60: begin
            if (count <= 2) begin
                pwm_out = 1'b1; //Output High for 60% duty cycle
            end 
            else begin
                pwm_out = 1'b0; //Output Low for 40% duty cycle
            end
        end
        PWM_80: begin
            if (count <= 3) begin
                pwm_out = 1'b1; //Output High for 80% duty cycle
            end 
            else begin
                pwm_out = 1'b0; //Output Low for 20% duty cycle
            end
        end
    endcase
end


endmodule