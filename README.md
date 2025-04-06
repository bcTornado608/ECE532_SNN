## A Customized Multiplier-less Spiking Neural Network Accelerator for Real-time Neural Signal Decoding

# Hierarchy
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
