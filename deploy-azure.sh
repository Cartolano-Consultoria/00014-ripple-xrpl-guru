#!/bin/bash

# Script de Deploy para Azure Static Web Apps
# XRPL Guru - Prototypes
# ======================================

set -e  # Para o script em caso de erro

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configurações (você pode modificar estas variáveis)
RESOURCE_GROUP="00014-ripple-xrpl-guru"
LOCATION="eastus2"
APP_NAME="xrpl-guru-prototype"
SOURCE_DIR="docs/prototypes"

# Banner
echo -e "${BLUE}"
echo "╔═══════════════════════════════════════════════╗"
echo "║   XRPL Guru - Deploy para Azure              ║"
echo "║   Static Web Apps                             ║"
echo "╚═══════════════════════════════════════════════╝"
echo -e "${NC}"

# Função para verificar se um comando existe
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Função para exibir mensagens de status
log_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

log_success() {
    echo -e "${GREEN}✓${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

log_error() {
    echo -e "${RED}✗${NC} $1"
}

# Verificar se Azure CLI está instalado
log_info "Verificando pré-requisitos..."
if ! command_exists az; then
    log_error "Azure CLI não está instalado!"
    echo ""
    echo "Instale o Azure CLI com:"
    echo "  macOS: brew install azure-cli"
    echo "  Linux: curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash"
    echo "  Windows: https://aka.ms/installazurecliwindows"
    exit 1
fi
log_success "Azure CLI está instalado"

# Verificar se está logado no Azure
log_info "Verificando login no Azure..."
if ! az account show >/dev/null 2>&1; then
    log_warning "Você não está logado no Azure. Iniciando login..."
    az login
else
    log_success "Já está logado no Azure"
fi

# Mostrar assinatura atual
SUBSCRIPTION=$(az account show --query name -o tsv)
log_info "Assinatura ativa: ${YELLOW}${SUBSCRIPTION}${NC}"
echo ""

# Verificar se o diretório fonte existe
if [ ! -d "$SOURCE_DIR" ]; then
    log_error "Diretório $SOURCE_DIR não encontrado!"
    exit 1
fi
log_success "Diretório fonte encontrado: $SOURCE_DIR"

# Criar Resource Group (se não existir)
log_info "Verificando Resource Group..."
if az group show --name "$RESOURCE_GROUP" >/dev/null 2>&1; then
    log_success "Resource Group '$RESOURCE_GROUP' já existe"
else
    log_info "Criando Resource Group '$RESOURCE_GROUP' em '$LOCATION'..."
    az group create \
        --name "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --output none
    log_success "Resource Group criado com sucesso"
fi

# Verificar se a extensão staticwebapp está instalada
log_info "Verificando extensão do Azure Static Web Apps..."
if ! az extension list --query "[?name=='staticwebapp'].name" -o tsv | grep -q staticwebapp; then
    log_info "Instalando extensão Azure Static Web Apps..."
    az extension add --name staticwebapp --only-show-errors
    log_success "Extensão instalada"
else
    log_success "Extensão já está instalada"
fi

# Criar Static Web App
log_info "Verificando se o Static Web App já existe..."
if az staticwebapp show --name "$APP_NAME" --resource-group "$RESOURCE_GROUP" >/dev/null 2>&1; then
    log_warning "Static Web App '$APP_NAME' já existe. Será usado o existente."
    EXISTING_APP=true
else
    log_info "Criando Azure Static Web App '$APP_NAME'..."
    az staticwebapp create \
        --name "$APP_NAME" \
        --resource-group "$RESOURCE_GROUP" \
        --location "$LOCATION" \
        --output none
    log_success "Static Web App criado com sucesso"
    EXISTING_APP=false
fi

# Obter deployment token
log_info "Obtendo deployment token..."
DEPLOYMENT_TOKEN=$(az staticwebapp secrets list \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "properties.apiKey" -o tsv)

if [ -z "$DEPLOYMENT_TOKEN" ]; then
    log_error "Não foi possível obter o deployment token"
    exit 1
fi
log_success "Deployment token obtido"

# Fazer deploy dos arquivos
log_info "Fazendo deploy dos arquivos..."

# Verificar se SWA CLI está instalado
if ! command_exists swa; then
    log_warning "SWA CLI não está instalado. Instalando automaticamente..."
    
    # Verificar se npm está instalado
    if ! command_exists npm; then
        log_error "npm não está instalado. Instale Node.js primeiro:"
        echo "  macOS: brew install node"
        echo "  Linux: https://nodejs.org/"
        exit 1
    fi
    
    log_info "Instalando SWA CLI via npm..."
    npm install -g @azure/static-web-apps-cli
    log_success "SWA CLI instalado com sucesso!"
fi

# Fazer deploy usando SWA CLI
log_info "Iniciando deploy... (isso pode levar alguns minutos)"
swa deploy "$SOURCE_DIR" \
    --deployment-token "$DEPLOYMENT_TOKEN" \
    --env production

log_success "Deploy concluído!"

# Obter URL do app
log_info "Obtendo URL do aplicativo..."
APP_URL=$(az staticwebapp show \
    --name "$APP_NAME" \
    --resource-group "$RESOURCE_GROUP" \
    --query "defaultHostname" -o tsv)

echo ""
echo -e "${GREEN}╔═══════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║   Deploy Concluído com Sucesso! 🎉           ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${BLUE}📱 URL do App:${NC} ${GREEN}https://${APP_URL}${NC}"
echo ""
echo -e "${YELLOW}⏱  Nota:${NC} O deploy pode levar alguns minutos para ficar disponível."
echo ""
echo -e "${BLUE}Comandos úteis:${NC}"
echo "  • Ver status: az staticwebapp show --name $APP_NAME --resource-group $RESOURCE_GROUP"
echo "  • Ver logs:   az staticwebapp logs show --name $APP_NAME --resource-group $RESOURCE_GROUP"
echo "  • Deletar:    az staticwebapp delete --name $APP_NAME --resource-group $RESOURCE_GROUP"
echo ""

log_success "Script finalizado!"

