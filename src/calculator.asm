.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Exemplu proiect desenare",0
area_width EQU 320
area_height EQU 420
area DD 0

counter DD 0 ; numara evenimentele de tip timer
numar DD 0
nr DD 0
q DD 10
nr1 DD 0
afisez dd 0
operatie DD 0   ; 0->egal/stergere,1->adunare,2->scadere,3->inmultire,4->impartire
 
arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20

symbol_width EQU 10
symbol_height EQU 20
button_width EQU 80
button_height EQU 60
include butoane_1.inc
include letters.inc
include digits.inc

.code

; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
make_button proc
    push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	je A
	cmp eax, 'B'
	je B
	cmp eax, 'C'
	je C1
	cmp eax, 'D'
	je D
	cmp eax, 'E'
	je E
	cmp eax, 'F'
	je F
	cmp eax, 'G'
	je G
	cmp eax, 'H'
	je H
	cmp eax, 'I'
	je I
	cmp eax, 'J'
	je J
	cmp eax, 'K'
	je K
	cmp eax, 'L'
	je L
	cmp eax, 'M'
	je M
	cmp eax, 'N'
	je N
	cmp eax, 'O'
	je O
	cmp eax, 'P'
	je P
A:	
	mov eax,0
	lea esi, zero
	jmp draw_button
B:	
	mov eax,0
	lea esi, unu
	jmp draw_button
C1:	
	mov eax,0
	lea esi, doi
	jmp draw_button
D:	
	mov eax,0
	lea esi, trei
	jmp draw_button
E:	
	mov eax,0
	lea esi, patru
	jmp draw_button
F:	
	mov eax,0
	lea esi, cinci
	jmp draw_button
G:	
	mov eax,0
	lea esi, sase
	jmp draw_button
H:	
	mov eax,0
	lea esi, sapte
	jmp draw_button
I:	
	mov eax,0
	lea esi, opt
	jmp draw_button
J:	
	mov eax,0
	lea esi, noua
	jmp draw_button
K:	
	mov eax,0
	lea esi, egal
	jmp draw_button
L:	
	mov eax,0
	lea esi, sterge
	jmp draw_button
M:	
	mov eax,0
	lea esi, plus
	jmp draw_button
N:	
	mov eax,0
	lea esi, minus
	jmp draw_button
O:	
	mov eax,0
	lea esi, ori
	jmp draw_button
P:	
	mov eax,0
	lea esi, impartire
	jmp draw_button
	
draw_button:
	mov ebx, button_width
	mul ebx
	mov ebx, button_height
	mul ebx
	add esi, eax
	mov ecx, button_height
bucla_button_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, button_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, button_width
bucla_button_coloane:
	cmp dword ptr [esi],0h
	je button_pixel_alb
	mov dword ptr [edi], 0h
	push ecx
	mov ecx, dword ptr [esi]
	mov dword ptr [edi], ecx
	pop ecx	
	jmp button_pixel_next
button_pixel_alb:
	;mov dword ptr [edi], 0FFFFFFh
button_pixel_next:
	add esi,4
	add edi, 4
	loop bucla_button_coloane
	pop ecx
	loop bucla_button_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_button endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
make_button_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_button
	add esp, 16
endm

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
    make_button_macro 'A',area, 80, 360		;0
	make_button_macro 'B', area, 0, 300		;1
	make_button_macro 'C', area, 80, 300	;2
	make_button_macro 'D', area, 160, 300	;3
	make_button_macro 'E', area, 0, 240		;4
	make_button_macro 'F', area, 80, 240	;5
	make_button_macro 'G', area, 160, 240	;6
	make_button_macro 'H', area, 0, 180		;7
	make_button_macro 'I', area, 80, 180	;8
	make_button_macro 'J', area, 160, 180	;9
	
	make_button_macro 'K', area, 160, 360   ;egal
	make_button_macro 'L', area, 0, 360		;sterge
	make_button_macro 'M', area, 240, 360	;plus
	make_button_macro 'N', area, 240, 300	;minus
	make_button_macro 'O', area, 240, 240	;ori
	make_button_macro 'P', area, 240, 180	;impartire
	
	push ecx    						;golire ecran
	mov eax,area
	mov ecx, 180
	loop_golire2:
	push ecx
	mov ecx,area_width
	loop_golire3:
		mov dword ptr [eax],0ffffffh
		add eax,4
		loop loop_golire3
	pop ecx
	loop loop_golire2
	pop ecx
	mov [nr],0							; initializam nr=0
	jmp final_draw
evt_click:
	
	mov ebx,[ebp+arg2] ;x
	mov eax,[ebp+arg3] ;y
	cmp eax, 180
	jg eticheta_comparare_240
	jl evt_timer
eticheta_comparare_240: 
	cmp eax, 240
	jg eticheta_comparare_300               ; y>240
	
	cmp ebx, 80                             ; 180<y<240, verificam intre ce valori este x
	jl et_sapte
	cmp ebx, 160
	jl et_opt
	cmp ebx, 240
	jl et_noua
	cmp ebx, 320
	jl et_impartire
	
et_sapte: 
	mov eax, nr
	mul q
	add eax, 7
	mov [nr], eax
	mov [numar], eax
	mov [afisez],1	;afisam numarul citit
	jmp afisare_numar
	
et_opt:
	mov eax, nr
	mul q
	add eax, 8
	mov [nr], eax
	mov [numar], eax	
	mov [afisez],1		;afisam numarul citit
	jmp afisare_numar
	
et_noua:
	mov eax, nr
	mul q
	add eax, 9
	mov [nr], eax
	mov [numar], eax	
	mov [afisez],1		;afisam numarul citit
	jmp afisare_numar

et_impartire:
	
	cmp operatie, 0
	jg adunare_next_impartire
	mov edx, nr
	mov [nr1], edx
	je et_impartire_1
	adunare_next_impartire: 
		cmp operatie, 1
		jg scadere_next_impartire
		mov eax, nr1
		add eax, nr
		mov [nr1], eax
		jmp et_impartire_1
	scadere_next_impartire:
		cmp operatie, 2
		jg inmultire_next_impartire
		mov ecx, nr
		cmp ecx, nr1
		jg eroare
		mov eax, nr1
		sub eax, nr
		mov [nr1], eax
		jmp et_impartire_1
	inmultire_next_impartire:
		cmp operatie, 3
		jg impartire_next_impartire
		mov eax, nr1
		mul nr
		mov [nr1], eax
		jmp et_impartire_1
	impartire_next_impartire:
		cmp nr, 0 
		je eroare
		mov eax, nr1
		mov edx, 0
		div nr
		mov [nr1],eax
	et_impartire_1:
		mov [operatie], 4
			
	push ecx
	mov eax,area
	mov ecx, 180
	loop_impartire2:
	push ecx
	mov ecx,area_width
	loop_impartire3:
		mov dword ptr [eax],0ffffffh
		add eax,4
	loop loop_impartire3
	pop ecx
	loop loop_impartire2
	pop ecx
	
	mov [nr],0								; reinitializam nr=0
	mov eax, nr1
	mov [numar], eax
	mov [afisez], 1
	jmp afisare_numar
	
eticheta_comparare_300:
	cmp eax, 300
	jg eticheta_comparare_360				; y>300
	
	cmp ebx, 80                             ; 240<y<300, verificam intre ce valori este x
	jl et_patru
	cmp ebx, 160
	jl et_cinci
	cmp ebx, 240
	jl et_sase
	cmp ebx, 320
	jl et_inmultire 

et_patru:
	mov eax, nr
	mul q
	add eax, 4
	mov [nr], eax
	mov [numar], eax	
	mov [afisez],1		;afisam numarul citit
	jmp afisare_numar
	
et_cinci:
	mov eax, nr
	mul q
	add eax, 5
	mov [nr], eax
	mov [numar], eax	
	mov [afisez],1		;afisam numarul citit
	jmp afisare_numar
	
et_sase: 
	mov eax, nr
	mul q
	add eax, 6
	mov [nr], eax
	mov [numar], eax	
	mov [afisez],1		;afisam numarul citit
	jmp afisare_numar

et_inmultire:
	
	cmp operatie, 0
	jg adunare_next_inmultire
	mov edx, nr
	mov [nr1], edx
	je et_inmultire_1
	adunare_next_inmultire: 
		cmp operatie, 1
		jg scadere_next_inmultire
		mov eax, nr1
		add eax, nr
		mov [nr1], eax
		jmp et_inmultire_1
	scadere_next_inmultire:
		cmp operatie, 2
		jg inmultire_next_inmultire
		mov ecx, nr
		cmp ecx, nr1
		jg eroare
		mov eax, nr1
		sub eax, nr
		mov [nr1], eax
		jmp et_inmultire_1
	inmultire_next_inmultire:
		cmp operatie, 3
		jg impartire_next_inmultire
		mov eax, nr1
		mul nr
		mov [nr1], eax
		jmp et_inmultire_1
	impartire_next_inmultire:
		cmp nr, 0 
		je eroare
		mov eax, nr1
		mov edx, 0
		div nr
		mov [nr1],eax
	et_inmultire_1:
		mov [operatie], 3
	
	push ecx
	mov eax,area
	mov ecx, 180
	loop_inmultire2:
	push ecx
	mov ecx,area_width
	loop_inmultire3:
		mov dword ptr [eax],0ffffffh
		add eax,4
	loop loop_inmultire3
	pop ecx
	loop loop_inmultire2
	pop ecx
	
	mov [nr],0								; reinitializam nr=0
	mov eax, nr1
	mov [numar], eax
	mov [afisez], 1
	jmp afisare_numar

eticheta_comparare_360:
	cmp eax, 360
	jg eticheta_comparare_420				; y>360
	
	cmp ebx, 80                             ; 300<y<360, verificam intre ce valori este x
	jl et_unu
	cmp ebx, 160
	jl et_doi
	cmp ebx, 240
	jl et_trei
	cmp ebx, 320
	jl et_scadere

et_unu:
	mov eax, nr
	mul q
	add eax, 1
	mov [nr], eax
	mov [numar], eax	
	mov [afisez],1		;afisam numarul citit
	jmp afisare_numar
	
et_doi:
	mov eax, nr
	mul q
	add eax, 2
	mov [nr], eax
	mov [numar], eax	
	mov [afisez],1		;afisam numarul citit
	jmp afisare_numar
	
et_trei:
	mov eax, nr
	mul q
	add eax, 3
	mov [nr], eax
	mov [numar], eax	
	mov [afisez],1		;afisam numarul citit
	jmp afisare_numar
	
et_scadere:
	
	cmp operatie, 0
	jg adunare_next_scadere
	mov edx, nr
	mov [nr1], edx
	je et_scadere_1
	adunare_next_scadere: 
		cmp operatie, 1
		jg scadere_next_scadere
		mov eax, nr1
		add eax, nr
		mov [nr1], eax
		jmp et_scadere_1
	scadere_next_scadere:
		cmp operatie, 2
		jg inmultire_next_scadere
		mov ecx, nr
		cmp ecx, nr1
		jg eroare
		mov eax, nr1
		sub eax, nr
		mov [nr1], eax
		jmp et_scadere_1
	inmultire_next_scadere:
		cmp operatie, 3
		jg impartire_next_scadere
		mov eax, nr1
		mul nr
		mov [nr1], eax
		jmp et_scadere_1
	impartire_next_scadere:
		cmp nr, 0 
		je eroare
		mov eax, nr1
		mov edx, 0
		div nr
		mov [nr1],eax
	et_scadere_1:
		mov [operatie], 2
	
	push ecx
	mov eax,area
	mov ecx, 180
	loop_scadere2:
	push ecx
	mov ecx,area_width
	loop_scadere3:
		mov dword ptr [eax],0ffffffh
		add eax,4
	loop loop_scadere3
	pop ecx
	loop loop_scadere2
	pop ecx
	
	mov [nr],0								; reinitializam nr=0
	mov eax, nr1
	mov [numar], eax
	mov [afisez], 1
	jmp afisare_numar

eticheta_comparare_420:
	cmp ebx, 80                             ; 360<y<420, verificam intre ce valori este x
	jl et_stergere
	cmp ebx, 160
	jl et_zero
	cmp ebx, 240
	jl et_egal
	cmp ebx, 320
	jl et_adunare
	
et_stergere:
	mov [operatie],0
	push ecx
	mov eax,area
	mov ecx, 180
	loop_stergere2:
		push ecx
		mov ecx,area_width
		loop_stergere3:
			mov dword ptr [eax],0ffffffh
			add eax,4
		loop loop_stergere3
		pop ecx
	loop loop_stergere2
	pop ecx
	make_text_macro 'S', area, 30, 20
	make_text_macro 'T', area, 40, 20
	make_text_macro 'E', area, 50, 20
	make_text_macro 'R', area, 60, 20
	make_text_macro 'S', area, 70, 20
	mov nr,0							; reinitializam nr=0
	jmp evt_timer
	
et_zero:
	mov eax, nr
	mul q
	add eax, 0
	mov [numar], eax	
	mov [afisez],1		;afisam numarul citit
	jmp afisare_numar
	
et_egal:
	
	cmp operatie, 0
	jg adunare_next_egal
	mov edx, nr
	mov [nr1], edx
	je et_egal_1
	adunare_next_egal: 
		cmp operatie, 1
		jg scadere_next_egal
		mov eax, nr1
		add eax, nr
		mov [nr1], eax
		jmp et_egal_1
	scadere_next_egal:
		cmp operatie, 2
		jg inmultire_next_egal
		mov ecx, nr
		cmp ecx, nr1
		jg eroare
		mov eax, nr1
		sub eax, nr
		mov [nr1], eax
		jmp et_egal_1
	inmultire_next_egal:
		cmp operatie, 3
		jg impartire_next_egal
		mov eax, nr1
		mul nr
		mov [nr1], eax
		jmp et_egal_1
	impartire_next_egal:
		cmp nr, 0 
		je eroare
		mov eax, nr1
		mov edx, 0
		div nr
		mov [nr1],eax
	et_egal_1:
		mov [operatie], 0
		
	push ecx
	mov eax,area
	mov ecx, 180
	loop_egal2:
	push ecx
	mov ecx,area_width
	loop_egal3:
		mov dword ptr [eax],0ffffffh      ;alb
		add eax,4
		loop loop_egal3
	pop ecx
	loop loop_egal2
	pop ecx
	
	mov [nr],0							; reinitializam nr=0
	mov eax,nr1
	mov [numar],eax
	mov [afisez],1
	jmp afisare_numar
	
et_adunare:
	
	cmp operatie, 0
	jg adunare_next_adunare
	mov edx, nr
	mov [nr1], edx
	je et_adunare_1
	
	adunare_next_adunare: 
		cmp operatie, 1
		jg scadere_next_adunare
		mov eax, nr1
		add eax, nr
		mov [nr1], eax
		jmp et_adunare_1
	scadere_next_adunare:
		cmp operatie, 2
		jg inmultire_next_adunare
		mov eax, nr1
		sub eax, nr
		mov [nr1], eax
		jmp et_adunare_1
	inmultire_next_adunare:
		cmp operatie, 3
		jg impartire_next_adunare
		mov eax, nr1
		mul nr
		mov [nr1], eax
		jmp et_adunare_1
	impartire_next_adunare:
		cmp nr, 0
		je eroare
		mov eax, nr1
		mov edx, 0
		div nr
		mov [nr1],eax
	et_adunare_1:
		mov [operatie], 1
	
	push ecx
	mov eax,area
	mov ecx, 180
	loop_adunare2:
	push ecx
	mov ecx,area_width
	loop_adunare3:
		mov dword ptr [eax],0ffffffh
		add eax,4
	loop loop_adunare3
	pop ecx
	loop loop_adunare2
	pop ecx
	
	mov [nr],0					; reinitializam nr=0
	mov eax, nr1
	mov [numar], eax
	mov [afisez], 1
	jmp afisare_numar

eroare:
		make_text_macro 'E', area, 20, 20
		make_text_macro 'R', area, 30, 30
		make_text_macro 'O', area, 40, 40
		make_text_macro 'A', area, 50, 50
		make_text_macro 'R', area, 60, 60
		make_text_macro 'E', area, 70, 70
		
		mov eax, 0
		mov nr1, eax
		mov [numar], eax
		jmp afisare_numar
		
afisare_numar:
	
	cmp afisez,0
	je evt_timer
	
	push ecx
	mov eax,area
	mov ecx, 180
	loop_2:
	push ecx
	mov ecx,area_width
	loop_3:
		mov dword ptr [eax],0ffffffh
		add eax,4
	loop loop_3
	pop ecx
	loop loop_2
	pop ecx
	
	mov ebx, 10
	mov eax, numar
	cmp eax, 999999999
	jg overflow
	mov ecx,area_width
	sub ecx, 10
loop1:
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, ecx, 10
	sub ecx, 10
	cmp eax, 0
	jg loop1
	mov [afisez],0
	jmp evt_timer
	
overflow: 
	make_text_macro 'O', area, 30, 20
	make_text_macro 'V', area, 40, 20
	make_text_macro 'E', area, 50, 20
	make_text_macro 'R', area, 60, 20
	make_text_macro 'F', area, 70, 20
	make_text_macro 'L', area, 80, 20
	make_text_macro 'O', area, 90, 20
	make_text_macro 'W', area, 100, 20
	mov eax, 0
	mov [nr], eax
	
evt_timer:


final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start
