# Mutiplos_Relogios

Para executar, baixe esse projeto e abra ele no ModelSim na raiz do arquivo .mpf. No terminal do ModelSim o comando `do sim.do` para simular o projeto, `do sim_deserializer.do` para simular o funcionamento somente do deserializador e `do sim_queue.do` para simular o funcionamento somente da queue.

---


## Top (top.sv)

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

---

## Deserializador (deserializer.sv)
Funcionamento
1. Reset:
Inicializa todos os registradores:

shift_reg: 00000000
bit_counter: 0
data_ready: 0
status_out: 1 (disponível).
2. Recebimento de Bits:
Quando status_out = 1 (disponível) e write_in = 1 (dado válido):

O bit em data_in é inserido no LSB (bit menos significativo) do shift_reg

O contador bit_counter incrementa a cada bit recebido.

3. Sinalização de Dado Pronto:
Após 8 bits (bit_counter == 7):

data_ready sobe para 1, indicando que data_out é válido.

status_out cai para 0, bloqueando novos dados até a confirmação.

4. Handshake de Confirmação (ACK):
Quando o consumidor lê o dado:

Envia ack_in = 1 para liberar o desserializador.

data_ready retorna a 0 e status_out a 1, reiniciando o ciclo e zerando o shift_reg (data_out).

