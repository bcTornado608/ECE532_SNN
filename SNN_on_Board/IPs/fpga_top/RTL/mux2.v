module mux2 (
    input A,
    input B,
    input X,
    output C
);

assign C = X ? A : B;

endmodule