
# Haskell Checkers

**Disciplina**: FGA0210 - PARADIGMAS DE PROGRAMAÇÃO - T01 <br>
**Nro do Grupo (de acordo com a Planilha de Divisão dos Grupos)**: 04<br>
**Paradigma**: Funcional<br>

## Alunos
|Matrícula | Aluno |
| -- | -- |
| 17/0085023 |  Carla Rocha Cangussú |
| 20/0028472 |  Vinícius Assumpcao de Araújo |
| 18/0063162 |  Daniel Primo de Melo |
| 20/2029012 |  Josué Teixeira Santana |
| 20/0020650 |  João Pedro de Camargo Vaz |
| 18/0124099 |  Juliana Pereira Valle Gonçalves |
| 20/0018248 |  Gabriel Roger Amorim da Cruz |

## Sobre 
Este é um projeto de implementação do jogo de damas em Haskell. O jogo de damas é um clássico jogo de tabuleiro para dois jogadores, onde o objetivo é capturar todas as peças do adversário ou bloqueá-las de forma que não possam mais mover.

### Funcionalidades Principais
- Representação do tabuleiro de damas em um formato de matriz bidimensional.
- Alternância de turnos entre os jogadores (preto e branco).
- Validação de movimentos de peças de acordo com as regras do jogo.
- Tratamento de capturas e movimentos especiais, como promoção de peças.
- Verificação de vitória para determinar o vencedor do jogo.

## Screenshots
<img width="1512" alt="Captura de Tela 2023-09-22 às 07 17 50" src="https://github.com/UnBParadigmas2023-2/2023.2_G4_Funcional/assets/78980842/f8b3fc11-1428-43a4-a978-b7c9d6232166">

<img width="1511" alt="Captura de Tela 2023-09-22 às 07 19 53" src="https://github.com/UnBParadigmas2023-2/2023.2_G4_Funcional/assets/78980842/f1004011-9557-495b-827c-6795a8916627">



## Instalação 
**Linguagens**: Haskell<br>
**Tecnologias**: GHC, Cabal, Make<br>

## Uso 
Certifique-se de ter o GHC (Glasgow Haskell Compiler) e também o Haskell instalado em seu sistema.
1. Clone o repositório

```bash
git clone https://github.com/UnBParadigmas2023-2/2023.2_G4_Funcional.git
```

2. Execute a aplicação
```bash
stack build
stack exec damas-exe
```
Após a execução destes comandos, você será capaz de visualizar a aplicação em execução no terminal. 

## Vídeo
Adicione 1 ou mais vídeos com a execução do projeto.
Procure: 
(i) Introduzir o projeto;
(ii) Mostrar passo a passo o código, explicando-o, e deixando claro o que é de terceiros, e o que é contribuição real da equipe;
(iii) Apresentar particularidades do Paradigma, da Linguagem, e das Tecnologias, e
(iV) Apresentar lições aprendidas, contribuições, pendências, e ideias para trabalhos futuros.
OBS: TODOS DEVEM PARTICIPAR, CONFERINDO PONTOS DE VISTA.
TEMPO: +/- 15min

## Participações
Apresente, brevemente, como cada membro do grupo contribuiu para o projeto.
|Nome do Membro | Contribuição | Significância da Contribuição para o Projeto (Excelente/Boa/Regular/Ruim/Nula) |
| -- | -- | -- |
| Vinicius Assumpção  |  Criação do esqueleto base que foi utilizado para a implementação do projeto, criacao inicial do menu, revisao das regras especiais e do menu final | Excelente |
| João Pedro de Camargo Vaz  |  Participação na criação e edição do esqueleto do jogo e criação de regras para validação de jogadas e de turnos | Excelente |
| Gabriel Roger Amorim da Cruz | Participação na criação de regras para validação de jogadas, criação de tratamentos para lidar com entradas inválidas/inesperadas do usuário, melhoria da interface e correção de erros | Excelente | 
| Josué Teixeira Santana | Participação na criação de regras para validação da captura de peças e correção nas configurações da aplicação | Excelente |
| Carla Rocha Cangussú | Criação da regra de verificação simples de vitória e participação na criação da regra de verificação de empate simples | Excelente |

## Outros 

Desenvolver um projeto de jogo de damas em Haskell foi um desafio que proporcionou valiosas lições. A linguagem funcional pura destacou a importância da abstração e da elegância na programação, incentivando a pensar de maneira estruturada. Além disso, a familiarização com ferramentas como o Haskell Stack e o Haskelline foi essencial, enquanto o planejamento detalhado e a resolução de problemas contínuos demonstraram a necessidade de uma abordagem organizada e perseverante no desenvolvimento de software. Em resumo, essa experiência ampliou o entendimento da programação funcional, fortaleceu nossas habilidades de resolução de problemas e reforçou a importância do planejamento e da divisão de tarefas em projetos complexos.

## Fontes
- http://blog.gbacon.com/2011/01/checkers-game-over-in-haskell.html
- https://github.com/Syk123/Checkers-Haskell
