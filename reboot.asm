BITS 32

section .data
msg db "Rebooting your computer...", 0x0a

section .text
global _start
_start:

; call write() to print out the message from the .data section.
mov eax, 0x04  ; Syscall number 4 is write()
mov ebx, 0x01  ; Set filedescriptor (first argument) to 1 -> stdout.
mov ecx, msg   ; Put the string to print into ecx.
mov edx, 0x1c  ; Provide the length of the string including the terminating \x00 byte.
int 0x80       ; Call write()

; before calling reboot we should call the sync() syscall to prevent data loss.
mov eax, 0x24  ; syscall number 0x24 -> sync()
int 0x80       ; Execute sync().

; call the reboot() syscall to reboot the system.
mov eax, 0x58       ; syscall number 0x58
mov ebx, 0xfee1dead ; magic1, must be set to this value.
mov ecx, 0x28121969 ; magic2, must be set to this value.
mov edx, 0x01234567 ; LINUX_REBOOT_CMD_RESTART
mov esi, 0x0        ; Here we could define an argument to the reboot command, but we leave it empty.
int 0x80            ; Call reboot().

; call the exit() syscall to cleanly exit the program.
mov eax, 1 ; syscall number 1 is exit()
mov ebx, 0 ; Provide the error code for the exit function.
int 0x80   ; Call exit()
