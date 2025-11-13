# Guia para Capturar Screenshots dos Wireframes

## Passos Rápidos

### 1. Abrir os arquivos HTML no navegador

Abrir cada arquivo diretamente no Chrome/Safari:

```
file:///Users/ecartolano/Workspace/caco/00014-ripple-xrpl-guru/prototypes/index.html
file:///Users/ecartolano/Workspace/caco/00014-ripple-xrpl-guru/prototypes/knowledge-matrix.html
file:///Users/ecartolano/Workspace/caco/00014-ripple-xrpl-guru/prototypes/profile.html
file:///Users/ecartolano/Workspace/caco/00014-ripple-xrpl-guru/prototypes/opportunity-detail.html
file:///Users/ecartolano/Workspace/caco/00014-ripple-xrpl-guru/prototypes/settings.html
```

### 2. Capturar Screenshots

**Melhor método (página completa):**
- Chrome DevTools: `Cmd + Shift + P` → digitar "screenshot" → "Capture full size screenshot"
- Isso captura a página inteira, não só o que está visível

**Alternativa (macOS):**
- `Cmd + Shift + 4` → selecionar área da janela

### 3. Salvar com os nomes corretos

Salvar na pasta `docs/wireframes/full/` com estes nomes:

```
01-dashboard-overview.png          ← index.html
02-knowledge-matrix.png            ← knowledge-matrix.html
03-profile.png                     ← profile.html
04-opportunity-detail.png          ← opportunity-detail.html
05-settings.png                    ← settings.html
```

### 4. Screenshots adicionais (opcional)

Se quiser capturar os diferentes modos do dashboard (index.html):

**Clicar nos botões no topo e capturar cada modo:**
- `06-dashboard-my-cockpit.png` → botão "My Cockpit"
- `07-dashboard-code-partner.png` → botão "My Code Partner"
- `08-dashboard-learning-path.png` → botão "My Learning Path"
- `09-dashboard-knowledge-base.png` → botão "Knowledge Base"

### 5. Verificar

Conferir se os arquivos estão em:
```
docs/wireframes/full/
├── 01-dashboard-overview.png
├── 02-knowledge-matrix.png
├── 03-profile.png
├── 04-opportunity-detail.png
└── 05-settings.png
```

## Depois de capturar

Quando terminar, eu atualizo o `ux-design-specification.md` para incluir as imagens!
