UDATA_ACS
delay_temp RES 1
CODE
asm_delay
SETF delay_temp
not_done
DECF delay_temp
BNZ not_done
done
RETURN
GLOBAL asm_delay ; export so linker can see it
END