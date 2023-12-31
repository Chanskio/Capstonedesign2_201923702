`ifndef BFM_AXI_TEST_TASKS_V
`define BFM_AXI_TEST_TASKS_V
//////////////////////////////////////////////////////////////////////////////////
// Company: Personal
// Engineer: CHAN YONG PARK
//
// Create Date: 2023.10.9
// Design Name: bfm_axi_test_task.v
// Module Name: bfm_axi include file
// Project Name: amba bus signal verification
// Target Devices: 
// Tool Versions: XSIM(vcd file)
// Description: To study AMBA BUS
//
// Dependencies:
//
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
//----------------------------------------------------------------
// bfm_axi_test_tasks.v
//----------------------------------------------------------------
// VERSION: 2015.08.15.
//---------------------------------------------------------
// Read-After-Write
task test_raw;
     input [31:0] id;
     input [31:0] saddr; // start address
     input [31:0] depth; // size in byte
     input [31:0] bsize; // burst size in byte
     input [31:0] bleng; // burst length
     reg   [31:0] addr;
     integer      idx, idy, idz, error;
begin
    error = 0;
    addr = saddr;
    for (idy=0; idy<depth; idy=idy+bsize) begin
        for (idx=0; idx<bsize; idx=idx+1) begin
            dataWB[idx] = idy + idx + 1;
        end
//$display($time,,"%m idy=%03d", idy);
        write_task( id //input [31:0]         id;
                  , addr  //addr;
                  , bsize //size; // 1 ~ 128 byte in a beat
                  , bleng //leng; // 1 ~ 16  beats in a burst
                  , 0     //type; // burst type
                  );
        read_task ( id //input [31:0]         id;
                  , addr  //addr;
                  , bsize //size; // 1 ~ 128 byte in a beat
                  , bleng //leng; // 1 ~ 16  beats in a burst
                  , 0     //type; // burst type
                  );
        for (idz=0; idz<bsize; idz=idz+1) begin
             if (dataWB[idz]!=dataRB[idz]) begin
                 error = error + 1;
                 $display("%4d %m Error A:0x%x D:0x%x, but 0x%x expected",
                           $time, addr+idz, dataRB[idz], dataWB[idz]);
             end
             `ifdef DEBUG
             else $display("%4d %m OK A:0x%x D:0x%x", $time, addr+idz, dataRB[idz]);
             `endif
        end
        addr = addr + bsize;
    end
    if (error==0) $display("%4d %m test_raw from 0x%08x to 0x%08x %03d-size %03d-leng OK", $time, saddr, saddr+depth-1, bsize, bleng);
end
endtask
//----------------------------------------------------------------
// Read-After-Write ALL
task test_raw_all;
     input [31:0] id;
     input [31:0] saddr; // start address
     input [31:0] depth; // size in byte
     input [31:0] bsize; // burst size in byte
     input [31:0] bleng; // burst length
     reg   [31:0] addr;
     integer      idx, idy, idz, error;
begin
    error = 0;
    addr = saddr;
    for (idy=0; idy<depth; idy=idy+bsize) begin
        for (idx=0; idx<bsize; idx=idx+1) begin
            dataWB[idx] = idy + idx + 1;
        end
//$display($time,,"%m idy=%03d", idy);
        write_task( id //input [31:0]         id;
                  , addr  //addr;
                  , bsize //size; // 1 ~ 128 byte in a beat
                  , bleng //leng; // 1 ~ 16  beats in a burst
                  , 0     //type; // burst type
                  );
        addr = addr + bsize;
    end
    addr = saddr;
    for (idy=0; idy<depth; idy=idy+bsize) begin
        read_task ( id //input [31:0]         id;
                  , addr  //addr;
                  , bsize //size; // 1 ~ 128 byte in a beat
                  , bleng //leng; // 1 ~ 16  beats in a burst
                  , 0     //type; // burst type
                  );
        for (idx=0; idx<bsize; idx=idx+1) begin
             if ((idy+idx+1)!=dataRB[idx]) begin
                 error = error + 1;
                 $display("%m Error A:0x%x D:0x%x, but 0x%x expected",
                           $time, addr+idz, dataRB[idz], idy+idx+1);
             end
             `ifdef DEBUG
             else $display("%4d %m OK A:0x%x D:0x%x", $time, addr+idz, dataRB[idz]);
             `endif
        end
        addr = addr + bsize;
    end
    if (error==0) $display("%4d %m test_raw_all from 0x%08x to 0x%08x %03d-size %03d-leng OK",
                            $time, saddr, saddr+depth-1, bsize, bleng);
end
endtask
//----------------------------------------------------------------
// Revision History
//
//----------------------------------------------------------------
`endif
