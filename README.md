# Idea Count - Contador Simples

## Definição do produto

- **Nome**: Idea Count
- **Objetivo**: Um contador digital simples, rápido e minimalista para aumentar ou diminuir um valor com apenas um toque.
- **Problema que resolve**: Permite realizar contagens rápidas sem distrações, substituindo métodos improvisados como contar mentalmente, usar papel ou aplicativos cheios de recursos desnecessários.
- **Público**: Usuários que precisam contar coisas rapidamente: repetições de exercícios; itens; pontuações; tarefas; qualquer contagem simples do dia a dia.
- **Plataformas**: Android.
- **Funcionalidades V1 (somente o essencial)**:
    - Exibir um número centralizado na tela.
    - Valor inicial: **0**.
    - Botão **+** para incrementar.
    - Botão **-** para decrementar.
    - Atualização instantânea do valor.
    - Botão resetar.
    - Interface minimalista.
- **Possíveis funcionalidades futuras (não entra na V1)**:
    - Salvar último valor.
    - Som e vibração.
    - Modo escuro.
    - Histórico de contagens.
    - Múltiplos contadores.
    - Temas personalizados.
    - Backup dos dados.
    - Animações e efeitos visuais avançados.
    - Login e sincronização entre dispositivos.
    - Publicidade.
- Referências de aplicativos similares:
    - Simple Tally Counter - lamnguyen: interessante, pois não tem botões.
    - Contador de Cliques (Counter) - flowbitlabs: tem botões, som e vibração, mas excesso de propaganda.
    - Click Counter - Max Vel: não gostei da animação, mas é extremamente minimalista.

## Design

**Descrição**: Contador simples, com número grande no meio da tela na cor escura. Embaixo do número há dois botões, um de - e outro de +, para aumentar ou diminuir o número, que em princípio será 0. Esses botões serão grandes e redondos na cor amarela.

![Idea Count Preview](docs/images/idea_count_preview.jpg)

![Idea Count Preview](docs/images/idea_count_preview2.jpg)


O Idea Count segue a identidade visual da Idea36 Labs:

- Interface minimalista.
- Fundo branco.
- Tipografia Inter.
- Número grande centralizado.
- Amarelo Idea36 (#FFC107) como cor de ação principal.
- Alto contraste e poucos elementos.

#### Princípios:

- simplicidade;
- uso rápido;
- foco no contador;
- experiência com uma mão.

## Arquitetura

### Estrutura de pastas

```
lib/
├── main.dart               # Ponto de entrada do aplicativo
├── pages/                  # Telas
│   └── counter_page.dart
├── widgets/                # Componentes reutilizáveis
│   └── counter_button.dart
├── theme/                  # Cores, tema e estilos globais
│   └── app_theme.dart
└── utils/                  # Utilitários (quando necessário)
```

### Responsabilidades

#### main.dart

- Inicializa o aplicativo.
- Configura o tema.
- Define a tela inicial.

#### pages/

Contém as telas completas do aplicativo.

#### widgets/

Componentes reutilizáveis e independentes da lógica da aplicação.

#### theme/

Centraliza:

- cores;
- tipografia;
- estilos;
- tema Material.

Evita cores e estilos espalhados pelo código.

#### utils/

Funções auxiliares que não pertencem a nenhuma tela ou widget específico.

### Gerenciamento de estado

A V1 utiliza apenas `StatefulWidget` e `setState()`.

Caso o aplicativo cresça, a migração para uma solução como Provider, Riverpod ou Bloc será avaliada apenas quando houver necessidade.