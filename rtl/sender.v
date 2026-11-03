module sender # (parameter START_SIG = 0) (
    input           resetNot,
    input           CLK,
    input           start,
    input   [6:0]   dataIn,
    output  reg     signalOut,
    output  reg     sent
);

localparam IDLE     = 0;
localparam START    = 1;
localparam PARITY   = 2;
localparam SEND     = 3;
localparam STOP     = 4;

reg [2:0]           state;
reg [6:0]           data;
reg [2:0]           dataIndex;
reg                 prevStart = 0;

wire                paritySig;
assign              paritySig = ^data;


always @(posedge CLK or negedge resetNot) begin
    if (~resetNot) begin
        state       <= IDLE;
        dataIndex   <= 0;
        signalOut   <= 0;
        sent        <= 0;
        prevStart   = 0;
    end
    else begin
        prevStart <= start;
        case (state)
            IDLE: begin
                if (start && prevStart == 0) begin
                    dataIndex   <= 0;
                    data        <= dataIn;
                    state       <= START;
                    sent        <= 0;
                end
            end
            START: begin
                signalOut       <= START_SIG;
                state           <= PARITY;
            end
            PARITY: begin
                signalOut       <= paritySig;
                state           <= SEND;
            end
            SEND: begin
                signalOut       <= data[dataIndex];
                dataIndex       <= dataIndex + 1;
                if (dataIndex == 6)
                    state       <= STOP;
            end
            STOP: begin
                signalOut       <= ~START_SIG;
                state           <= IDLE;
                sent            <= 1;
            end
            default: state      <= IDLE;
        endcase
    end
end

endmodule
