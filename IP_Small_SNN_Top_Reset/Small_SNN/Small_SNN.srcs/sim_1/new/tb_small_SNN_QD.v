`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/02/18 07:24:17
// Design Name: 
// Module Name: tb_small_SNN_QD
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module tb_small_SNN_QD();
    // Testbench Signals
    reg clk;
    reg resetn_all;
    reg resetn_clk;
    reg signed [31:0] Threshold;
    reg signed [56*32-1:0] Input; // 56��Q4.12��ʽ����
    
    wire [2:0] SNN_out;  // Output from SNN core
    wire need_input_clk; // Signal from SNN core
    wire cal_done;       // Calculation completion signal

    // ͳ�� `SNN_out` ���
    integer class_count [0:2];

    // Clock generation (10 ns period)
    always begin
        #5 clk = ~clk;
    end

    // Memory files
    reg signed [31:0] input_mem [0:5599]; // 100���������ݣ�ÿ��56�� Q4.12��16-bit��

    integer i, j;
        
    initial begin
        // ��ʼ���ź�
        Threshold = 32'b00000001000000000000000000000000;  // 1.0 in Q8.24
        clk = 1;
        resetn_all = 0;
        resetn_clk = 1;
        // ͳ�Ƴ�ʼ��
        class_count[0] = 0;
        class_count[1] = 0;
        class_count[2] = 0;        

        // ��������
        $readmemb("input.mem", input_mem);

        // ����Ƿ�ɹ�����
        $display("Checking input_mem content:");
        for (i = 0; i < 5600; i = i + 1) begin
            $display("input_mem[%0d] = %b | Signed Int: %0d | Frac: %f | Final: %f",
                i, input_mem[i], $signed(input_mem[i][31:24]),
                input_mem[i][23:0] * 2.0**(-24),
                $signed(input_mem[i][31:24]) + input_mem[i][23:0] * 2.0**(-24)
            );
        end       

        // �ͷ�ȫ�ָ�λ
        #30 resetn_all = 1;

        // ������ 100 ������
        for (j = 0; j < 100; j = j + 1) begin
            #2 resetn_clk = 0;  // ��λ clk_gen_v2���������� resetn_clk��  
            #4 resetn_clk = 1;           
            @(posedge need_input_clk); // �ȴ���Ҫ�����ź�

            // ����һ������
            Input = {input_mem[j*56 + 55], input_mem[j*56 + 54], input_mem[j*56 + 53],
                     input_mem[j*56 + 52], input_mem[j*56 + 51], input_mem[j*56 + 50],
                     input_mem[j*56 + 49], input_mem[j*56 + 48], input_mem[j*56 + 47],
                     input_mem[j*56 + 46], input_mem[j*56 + 45], input_mem[j*56 + 44],
                     input_mem[j*56 + 43], input_mem[j*56 + 42], input_mem[j*56 + 41],
                     input_mem[j*56 + 40], input_mem[j*56 + 39], input_mem[j*56 + 38],
                     input_mem[j*56 + 37], input_mem[j*56 + 36], input_mem[j*56 + 35],
                     input_mem[j*56 + 34], input_mem[j*56 + 33], input_mem[j*56 + 32],
                     input_mem[j*56 + 31], input_mem[j*56 + 30], input_mem[j*56 + 29],
                     input_mem[j*56 + 28], input_mem[j*56 + 27], input_mem[j*56 + 26],
                     input_mem[j*56 + 25], input_mem[j*56 + 24], input_mem[j*56 + 23],
                     input_mem[j*56 + 22], input_mem[j*56 + 21], input_mem[j*56 + 20],
                     input_mem[j*56 + 19], input_mem[j*56 + 18], input_mem[j*56 + 17],
                     input_mem[j*56 + 16], input_mem[j*56 + 15], input_mem[j*56 + 14],
                     input_mem[j*56 + 13], input_mem[j*56 + 12], input_mem[j*56 + 11],
                     input_mem[j*56 + 10], input_mem[j*56 + 9],  input_mem[j*56 + 8],
                     input_mem[j*56 + 7],  input_mem[j*56 + 6],  input_mem[j*56 + 5],
                     input_mem[j*56 + 4],  input_mem[j*56 + 3],  input_mem[j*56 + 2],
                     input_mem[j*56 + 1],  input_mem[j*56 + 0]};

            // �ȴ��������
            @(posedge cal_done);
             // ͳ�� SNN_out ��ÿ��λ�� 1 ����
            if (SNN_out[0]) class_count[0] = class_count[0] + 1;
            if (SNN_out[1]) class_count[1] = class_count[1] + 1;
            if (SNN_out[2]) class_count[2] = class_count[2] + 1;           
        end

        // ��������
        #10 $finish;
    end

    // ���� cal_done=1 ʱ�� SNN_out �仯
    always @(posedge cal_done) begin
        $display("Time=%0t | SNN_out=%b | Predicted Counts: [%0d, %0d, %0d]",
                  $time, SNN_out, class_count[0], class_count[1], class_count[2]);
    end

    // ʵ���� Small_SNN_core
    Small_SNN_core #(
        .INPUT_SIZE(56),
        .LAYER1_SIZE(50),
        .LAYER2_SIZE(20),
        .LAYER3_SIZE(3),
        .DATA_WIDTH(32)  // �޸�Ϊ 16-bit
    ) uut (
        .clk(clk),
        .resetn_all(resetn_all),
        .resetn_clk(resetn_clk),
        .Threshold(Threshold),
        .Input(Input),
        .SNN_out(SNN_out),
        .need_input_clk(need_input_clk),
        .cal_done(cal_done)
    );

endmodule
    


