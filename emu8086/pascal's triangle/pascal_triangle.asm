.Model LARGE   

.STACK  100 ;  size of the stack in  the program

.DATA   ;beginning of the data segment label



ROWSMSG DB "Enter number of rows(1-9): $"  

ERRMSG1 DB "Invalid number of rows!",13,10,'$'

NLINE DB 13,10,'$'
;SPACE DB 32,'$'
SPACE DB 9,'$' 

buffer DB 10,?,10 dup('/')

rows DB 5

cells DB ?

col DB 2
row DB 3  

arr2d DB 81 DUP(1),'$'

Tri DB 45 DUP(1),'$'




.CODE

    MOV AX,@DATA           ; we are loading the base address of . DATA label
                           ; into register AX                           
    MOV DS,AX              ; initialize data segment to the .DATA label
       
main:
    LEA DX,ROWSMSG         
    CALL PrintString
    CALL ReadChar 
    CALL NewLine
                  
    CMP CL,1
    JL _ERROR1
    
    CMP CL,9
    JG _ERROR1
    
    MOV [rows],CL
    
    CALL CalcCells
    CALL CreatPascTri  
    
    CALL PrintTri
    CALL NewLine
    JMP main
    
    _ERROR1:
    LEA DX,ERRMSG1
    CALL PRINTSTRING
    JMP main
      
    
        
JMP main 
;HLT



PROC CreatPascTri 
    PUSH AX      
    PUSH BX      
    PUSH CX
    PUSH DX
    PUSH SI      ;cell number in 2-D array = (row-1)*9+col-1
    PUSH DI      ;cell number in Pascal's Triangle
    
    
    MOV [col],2
    MOV [row],3
    MOV DI,04
    MOV CL,09
           
    FOR_COL:
    MOV AL,[row]  ;AL=row
    DEC AL        ;AL=row-1
    MUL CL        ;AL=(row-1)*9
    ADD AL,[col]  ;AL=(row-1)*9+col
    DEC AL        ;AL=(row-1)*9+col-1;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
    
    MOV SI,AX
    SUB SI,9      ;SI=(row-2)*9+col-1
    
    MOV DL,arr2d[SI]
    ADD DL,arr2d[SI-1]
    
    MOV arr2d[SI+9],DL
    MOV Tri[DI],DL
    ;ADD Tri[DI],30h
    
    INC [col]
    MOV AL,[row]
    CMP AL,[col]
    JE _EQ
    INC DI
    JMP FOR_COL
    
    _EQ:
    INC [row]
    MOV AL,[row]
    CMP AL,[rows]
    JG _END
    MOV [col],2
    ADD DI,3
    JMP FOR_COL      
    
    _END:
    POP DI
    POP SI       
    POP DX
    POP CX
    POP BX
    POP AX
    RET
ENDP CreatPascTri

PROC PrintTri
    PUSH AX
    PUSH BX
    PUSH DX
    MOV [row],1
    mov [col],1
    MOV BX,0000H
    _FOR_LOOP:
    MOV DL,Tri[BX]
    CMP DL,9
    JG _TEN
    ADD DL,30H
    CALL PrintChar
    _CONT:
    CALL P_SPACE
    
    MOV DL,[row]
    CMP DL,[col]
    JNE _OK 
    INC [row]
    MOV [col],0
    CALL NewLine
    _OK:
    INC [col]
    INC BL
    CMP BL,[cells]
    JNE _FOR_LOOP
    JMP _RET
    _TEN:
    MOV AL,DL
    MOV AH,00
    MOV DL,10
    DIV DL
    MOV DL,AL
    ADD DL,30H
    CALL PrintChar
    MOV DL,AH
    ADD DL,30H
    CALL PrintChar
    JMP _CONT
    _RET:
    POP DX
    POP BX
    POP AX
    RET
ENDP PrintTri

PROC CalcCells 
    PUSH AX
    PUSH CX
    MOV CH,00h
    MOV CL,[rows]
    MOV AX,0000h
    
    B:ADD AL,CL
    DEC CL
    JNZ B
    
    MOV [cells],AL
    POP CX
    POP AX
    RET
ENDP CalcCells

PROC ERR1 
    PUSH DX
    LEA DX,ERRMSG1
    CALL PrintString
    CALL NewLine
    POP DX
    RET
ENDP ERR1
           
PROC ReadChar          ;Character is stored in CL
    PUSH AX
    MOV AH,01h
    INT 21h
    MOV CH,00h
    MOV CL,AL 
    SUB CL,30h
    POP AX 
    RET
ENDP ReadChar

PROC ReadString        ;String is stored in buffer
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

PROC P_SPACE 
    PUSH AX 
    PUSH DX
    LEA DX,SPACE
    MOV AH,09H
    INT 21h 
    POP DX
    POP AX  
    RET
ENDP P_SPACE

PROC PrintChar           ;Character is in DL
    PUSH AX
    MOV AH,02H
    INT 21H
    POP AX 
    RET
ENDP PrintChar  

PROC PrintString         ;Offset of msg is in DX
    PUSH AX
    MOV AH,09H
    INT 21H
    POP AX 
    RET
ENDP PrintString   
