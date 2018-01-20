;RYAN MEONI 
.ORIG x3000

BRnzp skip

startPrompt .STRINGZ "Enter 'E' to encrpyt, 'D' to decrpyt, X to quit\n" 
failPrompt .STRINGZ "\nYou need to enter E, D, or X\n" 
cipherPrompt .STRINGZ "\nPlease enter cipher key (1-25)\n" 
newLine .STRINGZ "\n"
enterString .STRINGZ "What is the string (up to 50 characters)?\n"
endPrompt .STRINGZ "\nProgram now ending" 
returnAddress .FILL #0 
E_OffsetAddress .FILL E_Offset 
E_RestoreAddress .FILL E_Restore 
D_OffsetAddress .FILL D_Offset 
D_RestoreAddress .FILL D_Restore 
X_Offset .FILL #-88
X_Restore .FILL #88
SUM .FILL #0 
ASCII_Offset .fill #-48 
startPromptAddress .FILL startPrompt  
printCounter .FILL #0
resetArrayCounter .FILL #100

skip
AND R0, R0, #0 
restartProgram 

AND R0, R0, #0
AND R1, R1, #0 ; key 
AND R2, R2, #0 ; row (0 or 1) 
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0

LD R0, startPromptAddress
PUTS
AND R0, R0, #0

getPromptChar ; Get the E, D, or X

	GETC 
	OUT
	LD R3, X_Offset
	ADD R0, R0, R3 ; test for 'X' 

BRz XEntered 
	
	LD R3, X_Restore 

	ADD R0, R0, R3 ; ; restore char 

	LDI R3, E_OffsetAddress
	ADD R0, R0, R3 ; test for 'E' entered

BRz E_entered 

	LDI R3, E_RestoreAddress
	ADD R0, R0, R3 ; restore char 

	LDI R3, D_OffsetAddress
	ADD R0, R0, R3 ; test for 'D' 

BRz D_entered 	 

	LEA R0, failPrompt
	PUTS 

BRnzp getPromptChar 

D_entered 

	LDI R3, D_RestoreAddress
	ADD R0, R0, R3 
	AND R3, R3, #0 
	LEA R0, cipherPrompt 
	PUTS 
getKey1 GETC 
	OUT
	ADD R0, R0, #-10 ; test for newline 
	BRz newLineEntered1
	ADD R0, R0, #10 ; reset char 
	AND R1, R1, #0 ; set This_Digit to 0. 
	LD R5, ASCII_Offset
	ADD R1, R0, R5 ; adds inputted digit to offset. 
	LDI R3, Key_Address

	while1 BRnz endWhile1 ; take if our multiplication is not with 0 (from R3).  

	ADD R4, R4, #10 ; add 10. 
	ADD R3, R3, #-1 ; decrement our User_Digit, which here is our counter. 

BR while1

endWhile1

	ADD R3, R4, R1 ; Complete User_Int = (User_Int * 10) + This_Digit 
	AND R4, R4, #0 ; Reset R4 
	AND R1, R1, #0 
	ADD R1, R1, R3
	STI R1, Key_Address ; store cipher in Key
	
BRnzp getKey1

	ADD R0, R0, #0

newLineEntered1

LEA R0, enterString ; Prompt for Decrypt/Encrypt String 
	PUTS 
	AND R0, R0, #0
	AND R1, R1, #0 
	AND R2, R2, #0 
	AND R3, R3, #0 
	ADD R2, R2, #1 ; For Decrypt 

getInput1 ; Get Decrypt/Encrypt String and store in array 
	
	GETC 
	OUT
	ADD R0, R0, #-10 ; test for newline 
	BRz newLine1
	ADD R0, R0, #10 ; reset char 
	JSR STORE  
	ADD R1, R1, #1
	ADD R3, R3, #1

BRnzp getInput1

newLine1

	AND R0, R0, #0 ; Add null at end 
	JSR STORE 
	AND R1, R1, #0 
	AND R2, R2, #0 

getLoadAndStoreDecryption ; Load, decrypt and store in array

	ADD R2, R2, #1
	JSR LOAD
	JSR Decrypt 
	ADD R2, R2, #-1 
	JSR STORE 
	ADD R1, R1, #1 
	AND R2, R2, #0 
	ADD R3, R3, #-1 

BRp getLoadAndStoreDecryption 	

	AND R0, R0, #0 ; Add null to end of second array portion 
	JSR STORE 
	AND R1, R1, #0 

JSR PRINT_ARRAY ; Print Array



LEA R0, newLine 
PUTS

AND R0, R0, #0 ; Reset our sum/key values to zero 
ST R0, SUM 
STI R0, Key_Address

BRnzp restartProgram


E_entered ; Encrypt 
 
	LDI R3, E_RestoreAddress
	ADD R0, R0, R3 
	AND R3, R3, #0 
	LEA R0, cipherPrompt 
	PUTS 
getKey2 GETC 
	OUT
	ADD R0, R0, #-10 ; test for newline 
	BRz newLineEntered2
	ADD R0, R0, #10 ; reset char 
	AND R1, R1, #0 ; set This_Digit to 0. 
	LD R5, ASCII_Offset
	ADD R1, R0, R5 ; adds inputted digit to offset. 
	LDI R3, Key_Address

while2 BRnz endWhile2 ; take if our multiplication is not with 0 (from R3).  

	ADD R4, R4, #10 ; add 10. 
	ADD R3, R3, #-1 ; decrement our User_Digit, which here is our counter. 

BR while2 

endWhile2 

	ADD R3, R4, R1 ; Complete User_Int = (User_Int * 10) + This_Digit 
	AND R4, R4, #0 ; Reset R4 
	AND R1, R1, #0 
	ADD R1, R1, R3
	STI R1, Key_Address ; store cipher in Key
	
BRnzp getKey2  

	ADD R0, R0, #0  

newLineEntered2 

	LEA R0, enterString ; Prompt for Encrypt/Decrypt string 
	PUTS 
	AND R0, R0, #0
	AND R1, R1, #0 
	AND R2, R2, #0 
	AND R3, R3, #0 

getInput2 ; Get Decrypt/Encrypt String and store in array 
	
	GETC 
	OUT
	ADD R0, R0, #-10 ; test for newline 
	BRz newLine2 
	ADD R0, R0, #10 ; reset char 
	JSR STORE  
	ADD R1, R1, #1
	ADD R3, R3, #1

BRnzp getInput2

newLine2

	AND R0, R0, #0 ; Add null to end of portion of array
	JSR STORE 
	AND R1, R1, #0 

getLoadAndStoreEncryption ; Load, encrypt, and store in array

	JSR LOAD
	JSR Encrypt
	ADD R2, R2, #1
	JSR STORE 
	ADD R1, R1, #1
	AND R2, R2, #0
	ADD R3, R3, #-1 

BRp getLoadAndStoreEncryption 	

	ADD R2, R2, #1 
	AND R0, R0, #0 ; Add null to end portion of array
	JSR STORE 
	AND R1, R1, #0 

JSR PRINT_ARRAY ; Print Array

LEA R0, newLine 
PUTS

AND R0, R0, #0 
ST R0, SUM 
STI R0, Key_Address

BRnzp restartProgram

XEntered
 
LEA R0, endPrompt 
PUTS

AND R0, R0, #0 

HALT 

Encrypt:

; Inputs:
; R0: A character to encrypt
; Key: A number between 1 and 25 to shift R0 by
; Outputs:
; R0: The input character, EN-crypted by shifting right encrypt only
; encrypts letters of the alphabet. Lower-case letters should remain 
; lowercase, uppercase letters should remain upper-case, and 
; punctuation marks and numbers should be unaffected.
; encrypt should be call-safe, returning any registers besides R0 
; to their original values.

ST R0, inputCharE
ST R1, printCounter
ST R7, returnAddress
LDI R1, Key_Address

LD R2, uppercaseLowerLimitOffset ; test if below ASCII value 65 
ADD R0, R0, R2 
BRn fail1
LD R2, uppercaseLowerLimitRestore 
ADD R0, R0, R2 

LD R2, lowercaseUpperLimitOffset ; test if above ASCII value 122 
ADD R0, R0, R2 
BRp fail2 
LD R2, lowercaseUpperLimitRestore 
ADD R0, R0, R2 

LD R2, randomLowerBoundTest ; <-- -91 
ADD R0, R0, R2 
BRzp checkfail1 ; take if possibly 91-96 ASCII 

BRnzp weGood1 ; if not zero or positive, must be uppercase char. 

checkfail1
LD R2, randomLowerBoundRestore ; <-- 91
ADD R0, R0, R2 

LD R2, randomUpperBoundTest ; <-- -96 
ADD R0, R0, R2 
BRnz fail3 ; take if char is found to be between 91 and 96. 

LD R2, randomUpperBoundRestore ; <-- 96
ADD R0, R0, R2 

weGood1 

LD R0, inputCharE

LD R2, lowercaseTestOffsetE ; <-- -90 
ADD R0, R0, R2 

BRp lowercaseEncrypt ; take if lowercase char  

LD R2, lowercaseTestRestoreE ; <-- 90 
ADD R0, R0, R2 
AND R2, R2, #0 

; begin uppercase encrypting 

ADD R0, R0, R1 
LD R2, lowercaseTestOffsetE ; <-- -90 
ADD R0, R0, R2

BRnz noWrapAround1 ; take if no wrap around needed

LD R2, lowercaseTestRestoreE ; <-- 90 
ADD R0, R0, R2 
LD R2, alphabetLength 
ADD R0, R0, R2 
BRnzp DONE

noWrapAround1

LD R2, lowercaseTestRestoreE ; <-- 90 
ADD R0, R0, R2 
 
BRnzp DONE 

lowercaseEncrypt 

LD R2, lowercaseTestRestoreE ; <-- 90 
ADD R0, R0, R2 
AND R2, R2, #0

; begin lowercase encrypting 

ADD R0, R0, R1 
LD R2, uppercaseTestOffsetE ; <-- -122
ADD R0, R0, R2

BRnz noWrapAround2 ; take if no wrap around needed

LD R2, uppercaseTestRestoreE ; <-- 122
ADD R0, R0, R2 
LD R2, alphabetLength 
ADD R0, R0, R2 

BRnzp DONE

noWrapAround2 

LD R2, uppercaseTestRestoreE ; <-- 122 
ADD R0, R0, R2 
 
BRnzp DONE 

fail1
ADD R0, R0, #0 
fail2
ADD R0, R0, #0 
fail3 
LD R0, inputCharE
BRnzp SuperDone 

DONE 
ADD R0, R0, #0 
AND R2, R2, #0 
SuperDone

ST R0, inputCharE
AND R2, R2, #0 
LD R1, printCounter
LD R7, returnAddress


RET 

ADD R0, R0, #0

BRnzp skip1
Key_Address .FILL Key
printCounter_Address .FILL printCounter
myArray_Address .FILL myArray
skip1

ADD R0, R0, #0 

Decrypt:

; Inputs:
; R0: A character to decrypt
; Key: A number between 1 and 25 to shift R0 by
; Outputs:
; R0: The input character, DE-crypted by shifting LEFT
; DECRYPT only encrypts letters of the alphabet. Lower-case letters
; should remain lowercase, uppercase letters should remain upper-case, 
; and punctuation marks and numbers should be unaffected.
; DECRYPT should be call-safe, returning any registers besides R0 
; to their original values.


ST R0, inputCharD
ST R1, printCounter
ST R2, decrypt_R2save
STI R7, returnAddress_Address
LDI R1, Key_Address

LD R2, uppercaseLowerLimitOffset ; test if below ASCII value 65 
ADD R0, R0, R2 
BRn fail11
LD R2, uppercaseLowerLimitRestore 
ADD R0, R0, R2 

LD R2, lowercaseUpperLimitOffset ; test if above ASCII value 122 
ADD R0, R0, R2 
BRp fail22
LD R2, lowercaseUpperLimitRestore 
ADD R0, R0, R2 

LD R2, randomLowerBoundTest ; <-- -91 
ADD R0, R0, R2 
BRzp checkfail11 ; take if possibly 91-96 ASCII 

BRnzp weGood11 ; if not zero or positive, must be uppercase char. 

checkfail11
LD R2, randomLowerBoundRestore 
ADD R0, R0, R2 

LD R2, randomUpperBoundTest ; <-- -96 
ADD R0, R0, R2 
BRnz fail33 ; take if char is found to be between 91 and 96. 

LD R2, randomUpperBoundRestore ; <-- 96
ADD R0, R0, R2 



weGood11
AND R2, R2, #0 

LD R0, inputCharD

LD R2, lowercaseTestOffsetE ; <-- -90 
ADD R0, R0, R2 

BRp lowercaseDecrypt11 ; take if lowercase char  

LD R2, lowercaseTestRestoreE ; <-- 90 
ADD R0, R0, R2 
AND R2, R2, #0 

; begin uppercase Decrypting 

NOT R1, R1 ; invert for decrypting 
ADD R1, R1, #1 
ADD R0, R0, R1 
LD R2, uppercaseLowerLimitOffset  ; <-- -65
ADD R0, R0, R2

BRzp noWrapAround11 ; take if no wrap around needed

LD R2, uppercaseLowerLimitRestore; <-- 65 
ADD R0, R0, R2 
LD R2, alphabetLengthDecrypt 
ADD R0, R0, R2
 
BRnzp DONE11

noWrapAround11

LD R2, uppercaseLowerLimitRestore ; <-- 65
ADD R0, R0, R2 

BRnzp DONE11

lowercaseDecrypt11

LD R2, lowercaseTestRestoreE ; <-- 90 
ADD R0, R0, R2 
AND R2, R2, #0

; begin lowercase Decrypting 

NOT R1, R1 ; invert for decrypting 
ADD R1, R1, #1 
ADD R0, R0, R1 
LD R2, lowercaseDecryptTestOffset  ; <-- -97
ADD R0, R0, R2

BRzp noWrapAround22 ; take if no wrap around needed

LD R2, lowercaseDecryptTestRestore ; <-- 97 
ADD R0, R0, R2 
LD R2, alphabetLengthDecrypt 
ADD R0, R0, R2 

BRnzp DONE11

noWrapAround22

LD R2, lowercaseDecryptTestRestore ; <-- 97
ADD R0, R0, R2 

BRnzp DONE11

fail11
ADD R0, R0, #0 
fail22
ADD R0, R0, #0 
fail33
LD R0, inputCharD
BRnzp SuperDone11

DONE11
ADD R0, R0, #0 
SuperDone11
ST R0, inputCharD
LD R2, decrypt_R2save
LDI R1, printCounter_Address
LDI R7, returnAddress_Address

RET 

BRnzp skip2
returnAddress_Address .FILL returnAddress
skip2

ADD R0, R0, #0 

LOAD

; Inputs:
; R1 = the index of a column of CIPHER_ARRAY (0-49)
; R2 = the index of a row of CIPHER_ARRAY (0 or 1)
; Outputs:
; R0 = the contents of CIPHER_ARRAY[R1, R2]

ST R1, indexCol 
ST R2, indexRow 
STI R7, returnAddress_Address 
ST R3, originalR3
LD R3, myArrayRowSize 
AND R4, R4, #0 

checkMultiplicationDone 

ADD R2, R2, #0 

BRz getIndexDone 

ADD R4, R4, R3 
ADD R2, R2, #-1 
BRnzp checkMultiplicationDone 

getIndexDone 

ADD R4, R4, R1 ; add col target (R1) to R4 (50 or 0). 

LEA R5, myArray 
ADD R5, R5, R4 
LDR R0, R5, #0 

AND R4, R4, #0 

LD R3, originalR3
LD R1, indexCol 
LD R2, indexRow 
LDI R7, returnAddress_Address

RET 

STORE

; Inputs:
; R1 = the index of a column of CIPHER_ARRAY (0-49)
; R2 = the index of a row of CIPHER_ARRAY (0 or 1)
; R0 = an ASCII character to store.
; Outputs: None

ST R1, indexCol 
ST R2, indexRow 
STI R7, returnAddress_Address 
ST R6, originalChar 
ST R3, originalR3

LD R3, myArrayRowSize 
AND R4, R4, #0 

checkMultiplicationDone2

ADD R2, R2, #0 

BRz getIndexDone2

ADD R4, R4, R3 
ADD R2, R2, #-1 
BRnzp checkMultiplicationDone2 

getIndexDone2

ADD R4, R4, R1 

LEA R5, myArray 
ADD R5, R5, R4 
STR R0, R5, #0 

AND R4, R4, #0 

LD R3, originalR3
LD R1, indexCol 
LD R2, indexRow
LD R6, originalChar 
LDI R7, returnAddress_Address

RET


PRINT_ARRAY

; INPUTS: None
; OUTPUTS: None
; PRINT_ARRAY will display the contents of CIPHER_ARRAY on the console.

STI R7, returnAddress_Address
LEA R0, firstHalfArrayPrompt
PUTS 
AND R0, R0, #0 

LEA R0, myArray ; Go to first half (decrypted) of array
LD R2, myArrayRowSize 

PUTS 

LEA R0, secondHalfArrayPrompt 
PUTS
AND R0, R0, #0 
LD R2, myArrayRowSize 

LEA R0, myArray ; Go to second half (encrypted) of array
ADD R1, R1, R2 
ADD R0, R0, R2 

PUTS

LDI R7, returnAddress_Address
AND R1, R1, #0 
AND R2, R2, #0 

RET 

decrypt_R2save .FILL #0 
inputChar .FILL #0 
inputCharE .FILL #0 
inputCharD .FILL #0 
Key .FILL #0
originalR3 .FILL #0
uppercaseLowerLimitOffset .FILL #-65
lowercaseUpperLimitOffset .FILL #-122
uppercaseLowerLimitRestore .FILL #65
lowercaseUpperLimitRestore .FILL #122 
randomLowerBoundRestore .FILL #91 
randomLowerBoundTest .FILL #-91 
randomUpperBoundTest .FILL #-96 
randomUpperBoundRestore .FILL #96 
lowercaseTestOffsetE .FILL #-90 
lowercaseTestRestoreE .FILL #90 
uppercaseTestOffsetE .FILL #-122
uppercaseTestRestoreE .FILL #122
lowercaseDecryptTestOffset .FILL #-97 
lowercaseDecryptTestRestore .FILL #97 
alphabetLength .FILL #-26 
alphabetLengthDecrypt .FILL #26 
myArrayRowSize .FILL #50
indexCol .FILL #0
indexRow .FILL #0 
originalChar .FILL #0
E_Offset .FILL #-69 
E_Restore .FILL #69
D_Offset .FILL #-68
D_Restore .FILL #68 
myArray .BLKW #100
firstHalfArrayPrompt .STRINGZ "Plaintext: "
secondHalfArrayPrompt .STRINGZ " \nEncrypted: "
.END