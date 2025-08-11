module histoEquilizer #(
    parameter DataWidth = 8 , NumberOfLevels = 256 , HistoWidth = $clog2(640*480) ,
    numerator=53,denominator=16777216
) (
    input clk ,
    input rst ,
    input [(HistoWidth * NumberOfLevels)-1:0] cumulativeHistoData ,
    input [HistoWidth-1:0] minCumulativeHisto,
    input startEquilization,
    output [(DataWidth * NumberOfLevels)-1:0] equalizedHistoData 
);
    parameter IDLE = 2'b00;
    parameter CALC = 2'b01;

    reg [1:0] state ;
    integer i ; 
    reg [HistoWidth-1] cumPixelValue;
    reg [HistoWidth-1] ScaledcumPixelValue;

    always @(posedge clk ) begin
        if(rst)begin
            equalizedHistoData <= 0;
            state <= IDLE;
            
        end
        else begin
            case (state)
               IDLE : begin
                if(startEquilization==1)
                    state <= CALC;
                    i <= 0;
               end 
               CALC : begin
                    if(i!=NumberOfLevels)begin
                        if(cumulativeHistoData[i*DataWidth+:DataWidth]==0)begin
                            equalizedHistoData[i*DataWidth+:DataWidth]<=0;
                        end
                        else begin
                            cumPixelValue <= cumulativeHistoData[i*DataWidth+:DataWidth] - minCumulativeHisto;
                            ScaledcumPixelValue <= cumPixelValue * (NumberOfLevels-1);
                            equalizedHistoData[i*DataWidth+:DataWidth] <= (ScaledcumPixelValue * numerator) / denominator;
                        end
                        i <= i + 1;
                    end
                    else
                        state <= IDLE;
               end
                default: state <= IDLE; 
            endcase
        end
    end
endmodule
