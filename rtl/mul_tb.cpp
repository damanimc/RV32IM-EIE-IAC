#include "verilated.h"
#include "verilated_vcd_c.h"
#include "VCPU.h"
#include"vbuddy.cpp"

#define CYCLES 100
#define RF_WIDTH 8
#define ROM_SIZE 256
int main(int argc, char **argv, char **ldv){
    int i;
    int clk1;
    int clk2;

    Verilated::commandArgs(argc,argv);
    VCPU* top= new VCPU;

    Verilated::traceEverOn(true);
    VerilatedVcdC* tfp = new VerilatedVcdC;

    top->trace (tfp, 99);
    tfp->open("CPU.vcd");

    // if(vbdOpen()!=1) return(-1);
    // vbdHeader("PIPELINED");

    top->clk1=1;
    top->clk2=1;
    top->rst = 0;

 

     // run the simulation over 300 clk cycles
    for (i = 0; i<CYCLES; i++) {

        for (clk2 = 0; clk2 < 2; clk2++){
            tfp->dump (2*i+clk2);
            top->clk2 = !top->clk2;
            
            top->eval ();
        }
        if(0==0){
                top->clk1 = !top->clk1;
        }
        // vbdHex(4,(int(top->a0)/1000)&0xF);
        // vbdHex(3,(int(top->a0)%1000/100)& 0xF);
        // vbdHex(2,(int(top->a0)%100/10)& 0xF);
        // vbdHex(1,(int(top->a0)%10)& 0xF);
        // Sldd count value to Vbuddy
        if ((Verilated::gotFinish()) || (vbdGetkey()=='q')) 
            exit(0);    
    }
    // vbdClose();     // ++++
  tfp->close(); 
  printf("Exiting\n");
  exit(0);

    
}