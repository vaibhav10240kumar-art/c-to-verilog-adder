`timescale 1ns/1ps

// Testbench for the Bambu-generated 'add' module.
// Applies a = 5, b = 7 and checks that the result is 12.
module add_tb;
  reg clock = 0;
  reg reset = 0;
  reg start_port = 0;
  reg signed [31:0] a = 5;
  reg signed [31:0] b = 7;
  wire done_port;
  wire signed [31:0] return_port;

  add dut (
    .clock(clock),
    .reset(reset),
    .start_port(start_port),
    .a(a),
    .b(b),
    .done_port(done_port),
    .return_port(return_port)
  );

  // 100 MHz clock
  always #5 clock = ~clock;

  initial begin
    #2  reset = 0;
    #10 reset = 1;        // Bambu's default reset is active-low
    #10 start_port = 1;
    #10 start_port = 0;
    wait (done_port);
    #10;
    $display("a=%0d b=%0d result=%0d", a, b, return_port);
    if (return_port === a + b) $display("PASS");
    else                       $display("FAIL");
    $finish;
  end

  // Watchdog: stop if the design never finishes
  initial begin
    #10000;
    $display("TIMEOUT");
    $finish;
  end
endmodule
