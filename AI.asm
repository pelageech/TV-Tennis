asect 0x00
# i'm finished

continue: # пока скорость отрицательна, стоим
ldi r0, carrycnt # обнуляем кол-во керри
ldi r1, 0
st r0, r1
ldi r0, VX
ld r0, r0
tst r0
ble continue

start:# считка координат
ldi r1, VY # скорость по y
ld r1, r1
ldi r0, Y
ld r0, r0
if 
  tst r1 # если шарик летит вниз 
is mi
  neg r1 # инвертируем скорость
  neg r0
  ldi r3, 1
  ldi r2, carrycnt
  st r2, r3 
fi
ldi r2, bby
st r2, r0
ldi r2, vvy # создаем другую переменную
st r2, r1 # теперь в другой переменной модуль скорости

ldi r0, X
ld r0, r0
ldi r1, bbx
st r1, r0

ldi r0, VX 
ld r0, r0
ldi r1, vvx
st r1, r0
tst r0 # если скорость по X >=0 then считываем конечную координату
bpl toBot # если меньше 0, то ракетка просто стоит

toBot: # ищем "финальное расстояние"
ldi r2, kek # 224, x второй ракетки
ld r2, r2
while 
	ldi r0, bby # возможно финальный y мяча
	ldi r1, vvy # скорость по y
	ld r0, r0
	ld r1, r1
	ldi r3, carrycnt # кол--во керри
	ld r3, r3
	if # если при добавлении скорости, возникает керри - увеличиваем счетчик
		add r1, r0
	is cs
		inc r3
	fi
	ldi r1, bby # запоминаем новую мб финальную координату
	st r1, r0
	ldi r0, carrycnt # запоминаем новое кол-во керри
	st r0, r3
	ldi r0, bbx
	ld r0, r0
	cmp r0, r2 # если x больше -32
stays gt # мейн идея
		ldi r1, VX
		ld r1, r1
		tst r1
		bmi continue
	ldi r1, vvx
	ld r1, r1
	add r1, r0 
	ldi r3, bbx
	st r3, r0 # запоминаем новую x координату
wend
ldi r1, vvx
ldi r0, bbx
ld r1, r1
ld r0, r0
while 
  cmp r0, r2 # пока x меньше -32 (-128 - -32)
stays lt
  add r1, r0
  ldi r3, bbx
  st r3, r0 # запоминаем новый x
  ldi r0, bby
  ldi r1, vvy
  ld r0, r0
  ld r1, r1
  ldi r3, carrycnt # все тоже самое как в прошлом цикле, просто условие немного другое
  ld r3, r3
  if 
    add r1, r0
  is cs
    inc r3
  fi
  ldi r1, bby
  st r1, r0
  ldi r0, carrycnt
  st r0, r3 
  ldi r0, bbx
  ld r0, r0
  ldi r1, vvx
  ld r1, r1
wend
ldi r0, carrycnt
ld r0, r0
ldi r1, 1 # константа 1
ld r1, r1
if 
	and r0, r1 # если в кол-ве керри, нулевой бит равен 1, то инвертируем уже подсчитанную финальную координату
is nz		
then
	ldi r2, bby
	ld r2, r2
	neg r2 # инвертируем финальную координату мяча
	ldi r3, bby
	st r3, r2
fi
ldi r1, bby
ld r1, r1
ldi r0, bby
ldi r2, -8 # двигаю ракетку вниз, так как берем только 5 битов от результата. Этот параметр можно двигать хоть как, в пределах размера ракетки.
# сверху можно эксперементировать
if 
	add r1, r2 # если при добавлении -8, возникает телепортация ракетки из нижнего максимума в верхний, то не двигаем.
is mi, and	
is cc
then
	ldi r3, 8 # возвращаем ракетку на место, если всё плохо
	add r3, r2
fi	
st r0, r2

cycle: # когда посчитали координату, перемещаемся к ней
while 
	ldi r3, VX
	ld r3, r3
	tst r3
stays pl # если скорость по X >=0
	ldi r0, RightBatY
	ld r0, r0
	ldi r1, bby
	ld r1, r1
	ldi r2, speed
	ld r2, r2	
	ldi r3, RightBatY
	if 
		tst r0
	is pl # если ракетка бота в нижней половине
		if 	
			tst r1
		is pl # если мяч в нижней половине
		then
			if
				cmp r0, r1
			is pl # если ракетка выше мяча
			then
				sub r0, r2 # вычитаем скорость
			else # мяч выше ракетки
				add r0, r2 # прибавляем скорость
			fi
		else # мяч в верхней половине
			add r0, r2 
		fi
	else # ракетка в верхней половине
		if 
			tst r1
		is pl # мяч в нижней половине
		then 
			sub r0, r2 # отнимаем скорость
		else # мяч в верхней половине
			if 
				cmp r0, r1
			is pl # ракетка выше мяча
			then
				sub r0, r2 # отнимаем скорость
			else # ракетка ниже мяча
				add r0, r2 # прибавляем скорость
			fi
		fi
	fi	
	st r3, r2
wend

again:
br continue # заново

speed : dc 8 # можно уменьшать
bbx: ds 1
vvy: ds 1
bby: ds 1
vvx: ds 1
carrycnt: dc 0
kek : dc 228
asect 0xfb
VX: dc 2
asect 0xfc
VY: dc -2
asect 0xfd
X: dc 2
asect 0xfe
Y: dc 0xb6
asect 0xff
RightBatY: ds 1
end