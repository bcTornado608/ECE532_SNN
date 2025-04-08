# A Customized Multiplier-less Spiking Neural Network Accelerator for Real-time Neural Signal Decoding

## Concept Hierarchy
```
Fpga top
├── Customed design controller
│   ├── data access
│   ├── clock generation
│   └── result display
├── SNN accelerator
│   ├── fully connected layers
│   ├── LIF neuron layers
│   └── BRAM cache (parameters)
├── Input data interface
│   ├── SD card controller
│   │   ├── Data concatenation and timing control
│   │   └── SD file reader
│   ├── Data mux
│   ├── BRAM cache (DATA)
│   └── ADC controller
└── Display interface
    ├── VGA display interface
    └── 7-segment display interface
```
## Implementation Hierarchy
```
Fpga_top.v
├── sd_read_file_top.v
└── PMOD_top_wrapper.v
    ├── Top.v
    │   ├── Clk_divider.v
    │   ├── Start_debounce_limiter.v
    │   ├── SNN_Top.v
    │   │   ├── SNN_Interface.v
    │   │   └── Small_SNN_core.v
    │   │       ├── Clk_gen_v2.v
    │   │       ├── Fc1_with_mul.v
    │   │       ├── Fc2_without_mul.v
    │   │       ├── Fc3_without_mul.v
    │   │       └── LIF_neuron.v
    │   ├── N_count_display_with_class.v
    │   └── Top_vga.v
    └── PMOD_AD1_wrapper.v
        ├── Clk_divider_20MHz.v
        ├── PMOD_AD1_interface.v
        └── data_input_mux.v

```
