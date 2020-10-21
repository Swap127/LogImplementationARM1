     AREA     taylorLog, CODE, READONLY
     EXPORT __main
	 ENTRY 
__main  FUNCTION		         
	 ;Calculating the value if ln(1.5) upto first 5 terms
	 ;ln(1+0.5) = 0.5 - ((0.5^2)/2) + ((0.5^3)/3) - ((0.5^4)/4) + ((0.5^5)/5)  = 0.407292
	 ;I have analyzed the taylor series equation and reduced it to summation from 1 to n: out= [out - (((-(1-x))^n)/n)]
	 
	 VMOV.F32 s0, #1.5                ;s0 stores the value (i.e 1.5),which is the number whose ln is being calculated
	 VMOV.F32 s1, #5                  ;s1 stores the value of the number of terms upto which the sum will be calculated
	 VMOV.F32 s2, #1                  ;storing the value 1(constant) in s2

	 VSUB.F32 s3, s0, s2              ;Extracting the value i.e. 0.5 by subtracting 1
	 VADD.F32 s4, s1, s2              ;This is done for the loop to run 5 times and stops when it starts variable becomes 6
	 
	 LDR r1, =0x00000000; 
   	 VMOV.F32 s5, r1            	  ;Loading the initial value with 0 as shown in class as directly moving 0 like other values does not work
	 
	 VMOV.F32 s6, #1				  ;Loading the initial value with 1 for the variable which increaments for the loop
	 VMOV.F32 s7, #-1                 ;Loading the initial value with -1 (it can be also be done using [VNEG.F32 s7,s6])
	
	 VMOV.F32 s8, #1                  ;Loading the initial value with 1  for storing multiplication output
	 VNEG.F32 s9,s3                   ;for getting the negative value as according to my method negative value i.e (-0.5) is required
	 
LOOP VCMP.F32 s4,s6                   ;Comparing between the upper limit and the loop variable respectively
     VMRS    APSR_nzcv, FPSCR         ;VMRS instruction is used to transfer the flags from the FPSCR to the APSR
	 VMULGT.F32 s8,s8,s9              ;(-0.5)^n is calculated and stored
	 VDIVGT.F32 s11,s8,s6             ;((-0.5)^n/n)
	 VSUBGT.F32 s5,s5,s11             ;accumulation of all the terms is done and stored  
	 VADDGT.F32 s6, s6, s2 		      ; increament n(increamenting loop)
     BGT LOOP 					      ; run the loop 5 times
     
	 
	 VMOV.F32 s12,s5                  ;The fianl value is transfered from s5 to s12 finally	 
stopProgram    B stopProgram          ; to stop the program
	 	 
     ENDFUNC
     END
                                      ;for checking the program the value for any value just store the number in s0 and the number of
                                      ;summation terms in s1 in the starting and at the end of the program the final value can be observed
                                      ;in s12									  