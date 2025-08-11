module min_histoValue_unit #(
    parameter PixelSize = 8,
     parameter histoWidth = $clog2(640*480)
) (
    input [PixelSize-1:0] pixel_Value;
    input clk,
    input reset,
    input pixel_valid,
    output reg [histoWidth-1:0] min_histo
);
    reg [histoWidth-1:0] CurrentMinimum;
    always @(posedge clk) begin
        if(reset)begin
            CurrentMinimum<=2**histoWidth - 1;
            min_histo <= 0;
        end
        else begin
            if(pixel_valid)begin
                if(pixel_Value == CurrentMinimum)
                    min_histo = min_histo + 1;
                else if (pixel_Value < CurrentMinimum)begin
                    min_histo <=1;
                    CurrentMinimum<=pixel_Value;
                end
                    
            end
        end
    end
endmodule