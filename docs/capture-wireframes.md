# Wireframe Screenshot Guide

## Como Capturar Screenshots dos Protótipos

### Opção A: Manualmente (Mais Simples)

1. **Abrir cada arquivo HTML no navegador:**
   - `prototypes/index.html`
   - `prototypes/knowledge-matrix.html`
   - `prototypes/profile.html`
   - `prototypes/opportunity-detail.html`
   - `prototypes/settings.html`

2. **Capturar screenshots:**
   - **macOS:** `Cmd + Shift + 4` (selecionar área) ou `Cmd + Shift + 3` (tela inteira)
   - **Chrome DevTools:** `Cmd + Shift + P` → "Capture full size screenshot"

3. **Salvar com nomes padronizados:**
   ```
   docs/wireframes/01-dashboard-overview.png
   docs/wireframes/02-knowledge-matrix.png
   docs/wireframes/03-profile.png
   docs/wireframes/04-opportunity-detail.png
   docs/wireframes/05-settings.png
   ```

4. **Screenshots adicionais (diferentes estados):**
   ```
   docs/wireframes/06-dashboard-my-cockpit.png
   docs/wireframes/07-dashboard-code-partner.png
   docs/wireframes/08-dashboard-learning-path.png
   docs/wireframes/09-dashboard-knowledge-base.png
   docs/wireframes/10-mobile-responsive.png
   ```

### Opção B: Usando Playwright (Automatizado)

Se você quiser automatizar, posso criar um script Node.js com Playwright:

```bash
# Instalar Playwright
npm install -D @playwright/test
npx playwright install

# Rodar script de captura
node scripts/capture-wireframes.js
```

## Estrutura de Pastas Recomendada

```
docs/
├── wireframes/               # Screenshots dos protótipos
│   ├── full/                # Screenshots completos
│   │   ├── 01-dashboard.png
│   │   ├── 02-knowledge-matrix.png
│   │   └── ...
│   ├── sections/            # Screenshots de seções específicas
│   │   ├── knowledge-matrix-grid.png
│   │   ├── learning-cards.png
│   │   └── ...
│   └── mobile/              # Views responsivas
│       ├── dashboard-mobile.png
│       └── ...
├── ux-design-specification.md
└── PRD.md
```

## Incluindo no Markdown

Depois de capturar, adicione ao `ux-design-specification.md`:

```markdown
### 11.5 Visual Assets - Final Prototypes

**Prototype References:**

#### Dashboard Overview
![Dashboard - 4-Mode Interface](wireframes/full/01-dashboard.png)
*Main dashboard showing My Cockpit, My Code Partner, My Learning Path, and Knowledge Base modes*

#### Knowledge Matrix
![Knowledge Matrix View](wireframes/full/02-knowledge-matrix.png)
*Dedicated knowledge matrix with skill tracking across topics and levels*

#### Profile Page
![User Profile](wireframes/full/03-profile.png)
*User profile with projects, validated skills, and activity timeline*

#### Opportunity Detail
![Opportunity Detail View](wireframes/full/04-opportunity-detail.png)
*Detailed view of grant opportunity with match analysis and requirements*

#### Settings
![Settings Page](wireframes/full/05-settings.png)
*User preferences: Account, Projects, Channels, Notifications, Privacy, Project Page*
```

## Tamanho e Qualidade Recomendados

- **Formato:** PNG (melhor para UI/screenshots)
- **Largura máxima:** 1920px (desktop), 375px (mobile)
- **Qualidade:** Alta resolução (2x retina se possível)
- **Otimização:** Comprimir com ImageOptim ou TinyPNG para reduzir tamanho

## Próximos Passos

1. ✅ Criar pasta `docs/wireframes/`
2. ⬜ Capturar screenshots dos 5 protótipos principais
3. ⬜ Capturar screenshots dos 4 modos do dashboard
4. ⬜ Capturar view mobile (responsive)
5. ⬜ Adicionar referências no `ux-design-specification.md`
6. ⬜ (Opcional) Criar versão automatizada com Playwright
