module receiver # (parameter START_SIG = 0) (
    input               resetNot,
    input               CLK,
    input               signalIn,
    output  reg         received,

    output              parityChecked,
    output  reg [6:0]   data
);

localparam IDLE       = 0;
localparam PARITY     = 1;
localparam RECEIVE    = 2;
localparam STOP       = 3;

reg [1:0]   state;
reg [2:0]   dataIndex;
reg         parityReceived;
wire        actualParity;

assign actualParity = ^data;
assign parityChecked = actualParity == parityReceived;

always @(posedge CLK or negedge resetNot) begin
    if (~resetNot) begin
        state <= IDLE;
        dataIndex <= 0;
        received <= 0;
        data <= 0;
    end
    else begin
        case (state)
            IDLE: begin
                if (signalIn == START_SIG) begin
                    dataIndex <= 0;
                    data <= 0;
                    state <= PARITY;
                    received <= 0;
                end
            end
            PARITY: begin
                parityReceived <= signalIn;
                state <= RECEIVE;
            end
            RECEIVE: begin
                data[dataIndex] <= signalIn;
                dataIndex <= dataIndex + 1;
                if (dataIndex == 6) begin
                    state <= STOP;
                end
            end
            STOP: begin
                state <= IDLE;
                received <= 1;
            end
            default: state <= IDLE;
        endcase
    end
end

endmodule
