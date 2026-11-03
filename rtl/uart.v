module uart #(
    parameter START_SIG = 1
) (
    input           resetNot,
    input           CLK,
    input           send,
    input   [6:0]   dataToSend,
    output          signalOut,
    output          sent,
    output          received,
    output  [6:0]   dataReceived,
    output          parityCheck
);

sender #(START_SIG) SENDER (resetNot, CLK, send, dataToSend, signalOut, sent);
receiver #(START_SIG) RECEIVER (resetNot, CLK, signalOut, received, parityCheck, dataReceived);

endmodule
