
module ch_unit #(parameter PixelSize = 8 , parameter histoWidth = $clog2(640*480) )(
    input [PixelSize-1:0] pixel_data_in,
    input pixel_data_valid,
    input [PixelSize-1:0] reference_pixel_value,
    output reg [histoWidth-1:0] histo_value,
    input clk,
    input rst
);
    always @(posedge clk ) begin
        if(rst)begin
            histo_value <=11'b0;
        end
        else begin
            if(pixel_data_valid)begin
                if(pixel_data_in <= reference_pixel_value)
                    histo_value <= histo_value + 1;
            end
        end
    end
endmodule