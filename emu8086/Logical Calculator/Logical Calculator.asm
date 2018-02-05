.model large
.stack 100h
.data    

buffer DB 9,?,9 dup(?)
buf2   DB 9,?,9 dup(?)
     
OPERATION DB "Enter number of operation you want",13,10,"1-and",13,10,"2-or",13,10,"3-xor",13,10,"4-not",13,10,"$" 
FIRSTNUMBER DB "Enter the first number (1byte maximum) $" 
SECONDNUMBER DB "Enter the second number (1byte maximum) $" 
NUMBER DB "Enter the number (1byte maximum) $"  
THERESULT DB "The result is  $"
NLINE DB 13,10,'$'
  

.code
  
MOV AX,@DATA 
MOV DS,AX
MOV ES,AX    
main:
    LEA DX,OPERATION         
    CALL PrintString   
    CALL ReadChar
    CALL NewLine 
    
    cmp cl,1
    je _HLT
    cmp cl,2
    je _HLT
    cmp cl,3
    je _HLT
    cmp cl,4
    je _not
    jmp main 
    
    _and: call AND_
    jmp _HLT   
    _or: call OR_
    jmp _HLT
    _xor: call XOR_
    jmp _HLT
    _not: call NOT_ 
    jmp _HLT
    
    _HLT:
   
hlt 
     
PROC PrintString        
    PUSH AX
    MOV AH,09H
    INT 21H
    POP AX 
    RET
ENDP PrintString

PROC ReadChar          
    PUSH AX
    MOV AH,01h
    INT 21h
    MOV CH,00h
    MOV CL,AL 
    SUB CL,30h
    POP AX 
    RET
ENDP ReadChar    

PROC ReadString       
    PUSH AX
    PUSH DX
    PUSH BX
    MOV AH,0ah
    LEA DX,buffer
    INT 21h
    MOV Bl,buffer[1]
    MOV buffer[BX+2],'$' 
    POP BX
    POP DX
    POP AX
    RET
ENDP ReadString




PROC AND_   
    LEA DX,FIRSTNUMBER 
    CALL PrintString 
    CALL ReadString 
    CALL NewLine
    
    LEA SI,buffer[2]
    LEA DI,buf2[2]
    CLD
    MOV CL,buffer[1]
    MOV CH,0
    REP MOVSB
    
    LEA DX,SECONDNUMBER 
    CALL PrintString 
    CALL ReadString 
    CALL NewLine
    
    MOV BH,0
    MOV BL,buffer[1]
    
    _AGAIN:
    SUB buffer[BX+1],30H
    SUB buf2[BX+1],30H
    DEC BX 
    JNZ _AGAIN 
    
    MOV BL,buffer[1]
    MOV BH,0
    
    _LOOP2:
    MOV AL,BUF2[BX+1]
    AND buffer[BX+1],AL
    DEC BX
    JNZ _LOOP2
    
    MOV BH,0
    MOV BL,buffer[1]
    
    _AGAIN2:
    ADD buffer[BX+1],30H
    DEC BX 
    JNZ _AGAIN2
    LEA DX,THERESULT        
    CALL PrintString 
    LEA DX,buffer[2]
    CALL PRINTSTRING
    CALL NewLine             
    RET
ENDP AND_ 

PROC OR_   
    LEA DX,FIRSTNUMBER 
    CALL PrintString 
    CALL ReadString 
    CALL NewLine
    
    LEA SI,buffer[2]
    LEA DI,buf2[2]
    CLD
    MOV CL,buffer[1]
    MOV CH,0
    REP MOVSB
    
    LEA DX,SECONDNUMBER 
    CALL PrintString 
    CALL ReadString 
    CALL NewLine
    
    MOV BH,0
    MOV BL,buffer[1]
    
    _AGAIN3:
    SUB buffer[BX+1],30H
    SUB buf2[BX+1],30H
    DEC BX 
    JNZ _AGAIN3 
    
    MOV BL,buffer[1]
    MOV BH,0
    
    _LOOP3:
    MOV AL,BUF2[BX+1]
    OR buffer[BX+1],AL
    DEC BX
    JNZ _LOOP3
    
    MOV BH,0
    MOV BL,buffer[1]
    
    _AGAIN4:
    ADD buffer[BX+1],30H
    DEC BX 
    JNZ _AGAIN4
    
    LEA DX,THERESULT        
    CALL PrintString 
    LEA DX,buffer[2]
    CALL PRINTSTRING
    CALL NewLine             
    RET
ENDP OR_     

PROC XOR_   
    LEA DX,FIRSTNUMBER 
    CALL PrintString 
    CALL ReadString 
    CALL NewLine
    
    LEA SI,buffer[2]
    LEA DI,buf2[2]
    CLD
    MOV CL,buffer[1]
    MOV CH,0
    REP MOVSB
    
    LEA DX,SECONDNUMBER 
    CALL PrintString 
    CALL ReadString 
    CALL NewLine
    
    MOV BH,0
    MOV BL,buffer[1]
    
    _AGAIN5:
    SUB buffer[BX+1],30H
    SUB buf2[BX+1],30H
    DEC BX 
    JNZ _AGAIN5
    
    MOV BL,buffer[1]
    MOV BH,0
    
    _LOOP4:
    MOV AL,BUF2[BX+1]
    XOR buffer[BX+1],AL
    DEC BX
    JNZ _LOOP4
    
    MOV BH,0
    MOV BL,buffer[1]
    
    _AGAIN6:
    ADD buffer[BX+1],30H
    DEC BX 
    JNZ _AGAIN6
    
    LEA DX,THERESULT        
    CALL PrintString 
    LEA DX,buffer[2]
    CALL PRINTSTRING
    CALL NewLine             
    RET
ENDP XOR_  

PROC NOT_   
    
    LEA DX,NUMBER 
    CALL PrintString 
    CALL ReadString 
    CALL NewLine
    
;    LEA SI,buffer[2]
;    LEA DI,buf2[2]
;    CLD
;    MOV CL,buffer[1]
;    MOV CH,0
;    REP MOVSB
    
    MOV BH,0
    MOV BL,buffer[1]
    
    _AGAIN7:
    SUB buffer[BX+1],30H
    DEC BX 
    JNZ _AGAIN7
    
    MOV BL,buffer[1]
    MOV BH,0
    MOV AX,0001H
    
    _LOOP5:
    XOR BUFFER[BX+1],AL   
    DEC BX
    JNZ _LOOP5
    
    MOV BH,0
    MOV BL,buffer[1]
    
    _AGAIN8:
    ADD buffer[BX+1],30H
    DEC BX 
    JNZ _AGAIN8
    
    LEA DX,THERESULT        
    CALL PrintString 
    LEA DX,buffer[2]
    CALL PRINTSTRING
    CALL NewLine             
    RET
ENDP NOT_

PROC NewLine 
    PUSH AX 
    PUSH DX
    LEA DX,NLINE
    MOV AH,09H
    INT 21h 
    POP DX
    POP AX  
    RET
ENDP NewLine

