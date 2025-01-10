# Trabalho Prático 2 (TP2) - Sistemas Operacionais com xv6

## Descrição

Este repositório contém a implementação do **Trabalho Prático 2 (TP2)** para o sistema operacional **xv6**, com foco no gerenciamento de memória e criação de chamadas de sistema. As principais tarefas incluem:

- Adicionar chamadas de sistema personalizadas.
- Explorar o gerenciamento de tabelas de páginas em arquiteturas **x86**.
- Implementar o conceito de **Copy-on-Write (COW)** para otimização de memória.

---

## Estrutura do Trabalho

### **TP2.1: Implementação da chamada `data`**

- **Objetivo:** Criar uma chamada de sistema chamada `data` que exibe a data e hora atual.  
- **Arquivos principais:**
  - `syscall.c`, `syscall.h`: Definição e registro da chamada.
  - `user.h`: Cabeçalho da chamada de sistema.
  - `sysproc.c`: Lógica da chamada.

---

### **TP2.2: Implementação de chamadas auxiliares**

#### **`virt2real`**
- **Descrição:** Converte um endereço virtual para um endereço físico.  
- **Protótipo:**  
  ```c
  char* virt2real(char *va);


Funcionamento:
Usa a função walkpgdir para acessar a tabela de páginas e retornar o endereço físico correspondente.
## 🔹 Chamada num_pages
Descrição: Retorna o número de páginas alocadas pelo processo atual.
Protótipo:
int num_pages(void);

Funcionamento:
Conta as páginas referenciadas no espaço de memória do processo atual.
Objetivo Geral: Explorar como hardware e software interagem no gerenciamento de memória em uma arquitetura x86.

# 🚀 TP2.3: Implementação do Copy-on-Write (COW)
## 🔹 Chamada forkcow
Descrição: Criação de uma chamada de sistema forkcow, similar a fork, mas com suporte a Copy-on-Write.
Diferenciais:
As páginas do processo pai e do filho são compartilhadas inicialmente como Read-Only.
Caso ocorra uma tentativa de escrita, o sistema gera uma cópia exclusiva da página.
## 🔹 Passos para Implementação
Gerenciar Referências de Páginas:
Criar um contador para rastrear o número de processos que compartilham cada página.
Marcar Páginas como Read-Only:
Alterar as permissões usando os bits apropriados na tabela de páginas.
Detectar Page Faults:
Tratar falhas de página geradas por operações de escrita, identificando a origem do erro.
Criar Páginas Exclusivas:
Alocar novos frames de memória conforme necessário.
Flush na TLB:
Garantir consistência entre a tabela de páginas e o cache de TLB após alterações.
## 🔹 Arquivos Modificados
vm.c: Gerenciamento de tabelas de páginas.
trap.c: Tratamento de interrupções e falhas de página.
kalloc.c: Gerenciamento de frames de memória.

# 🧪 Testes e Verificação
✅ Testes Automáticos
Rodar os comandos no xv6:

$ forktest
$ corretor

Ambos os testes devem passar para validar o trabalho.

# 🛠️ Debugging com GDB
Configurar o ambiente:

$ make qemu-gdb
$ gdb kernel

Sugerimos os seguintes pontos de interrupção:

(gdb) b exec
(gdb) c

# 🛠️ Requisitos

## Sistema Operacional: Linux (necessário para rodar o xv6).

Ferramentas:
gcc, make, qemu, gdb.

# 🚀 Como Executar

## Clonar o repositório:

git clone <URL do Repositório>
cd xv6

## Compilar o xv6:

make

## Executar o xv6:

make qemu

# 📂 Estrutura de Arquivos

user.h: Cabeçalhos das chamadas de sistema.

syscall.c e syscall.h: Registro e roteamento das chamadas.

vm.c: Gerenciamento de tabelas de páginas.

kalloc.c: Gerenciamento de frames de memória.

# 📖 Conclusão
Este trabalho explora conceitos fundamentais de sistemas operacionais, incluindo chamadas de sistema, tabelas de páginas e gerenciamento de memória. A implementação de Copy-on-Write (COW) demonstra como otimizar o uso de memória e melhorar o desempenho de processos filhos criados com fork.
trap.c: Tratamento de interrupções e falhas de página.
