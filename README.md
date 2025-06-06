# Mutiplos_Relogios

## Deserializador (deserializer.sv)





















## top (top.sv)

Unidade onde os dois elementos são interligados, um clock de 1Mhz é 
gerado e então dividido (divisão realizada com um contador incrementando até 
ser igual ao divisor) por dez (100Khz), e por cem(10Khz), foram então
atribuídos ao deserializador e à fila respectivamente.

### top_tb (top_tb.sv)

Primeira iteração, o se escreve no deserializador até exceder a sua capacidade,
perdendo dados, já a segunda se escreve dentro da capacidade, apos a primeira
iteração a fila é esvaziada (se levanta o sinal de dequeue_in) e o deserializador é reiniciado


---



## Fila (queue.sv)

Unidade combinacional com o comportamento de FIFO, enfilera com *enqueue_in = 1*
e retira o elemento mais "antigo" com *enqueue_in = 1*. O enfileiramento funciona
com um shift de 8 posições adicionando o *data_in* na posição mais a direita
(nos bits menos significativos), enquanto o dequeue funciona com um case a partir
do *count* (numero de elementos enfileirados) selecionando o elemento mais a esquerda,
o elemento e então colocado no *data_reg_out*, ou seja, e enviado para fora, e então
se subtrai um do *count*. Caso o dequeue_in e o enqueue_in sejam ativados com o count
em 8, o count é mantido e o elemento é adicionado.


