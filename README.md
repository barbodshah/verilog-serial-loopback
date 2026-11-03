# Verilog serial loopback

A shared-clock, UART-style serial link from a collaborative Digital Systems Design lab. Separate sender and receiver state machines use a start bit, an even-parity bit, seven data bits in LSB-first order, and a stop bit. The wrapper uses a high start bit and low idle level. The link is intended for synchronous loopback, with one bit per shared clock.

```sh
iverilog -g2012 -s loopback_tb -o loopback.vvp rtl/sender.v rtl/receiver.v rtl/uart.v tb/loopback_tb.v
vvp loopback.vvp
```

The smoke test checks two consecutive payloads, receive completion, and parity. The original lab RTL is reconstructed from the report. The receiver exposes parity status and assumes shared-clock framing.

This lab was a group submission. Confirm release permission and add the other contributors' preferred public names before uploading.
