# Modificações MEXIDAMINHA

Todas as modificações no código fonte do PuTTY são marcadas com o comentário
`/*MEXIDAMINHA*/` ou `/*mexidaminha*/` para fácil localização.

## 1. Interceptação de Escape Sequences (terminal.c)

### Buffer de Captura

```c
#define MINHA_URL_TAM 180
char MINHA_URL[MINHA_URL_TAM];
```

### Máquina de Estados

O PuTTY possui um modo "Media Copy" ativado por `ESC[5i` (início) e `ESC[4i` (fim),
normalmente usado para redirecionar dados do terminal para a impressora.

O MEXIDAMINHA intercepta este fluxo: quando o terminal está em modo `only_printing`,
os caracteres são acumulados no buffer `MINHA_URL` ao invés de serem enviados
para a impressora. A máquina de estados monitora a sequência `ESC[4i` para saber
quando parar:

```
Estado 0 (normal) → recebe ESC → Estado 1
Estado 1          → recebe [   → Estado 2
Estado 2          → recebe 4   → Estado 3
Estado 3          → recebe i   → Estado 4 (fim - executa ação)
Qualquer outro caractere → Estado 0 (acumula em MINHA_URL)
```

### Decisão de Ação (term_print_finish)

Quando a sequência `ESC[4i` é detectada:

1. Remove o último caractere do buffer (caractere de controle residual)
2. Verifica o prefixo do conteúdo acumulado:
   - `"httpjr"` → chama `meu_AbreFenixReport()` para executar fenixReport.jar
   - `"http"` → chama `meu_AbreURL()` para abrir no navegador
   - Qualquer outro → envia para impressora normalmente via `printer_finish_job()`
3. Limpa o buffer `MINHA_URL`

## 2. Funções de Execução (windows/window.c)

### meu_AbreURL()
Abre uma URL no navegador padrão do Windows:
```c
void meu_AbreURL(TermWin *tw, char *cURL) {
    if (hwnd)
        ShellExecuteA(hwnd, "open", cURL, NULL, NULL, SW_SHOWDEFAULT);
}
```

### meu_AbreFenixReport()
Executa o fenixReport.jar com parâmetros:
```c
void meu_AbreFenixReport(TermWin* tw, char* cURL) {
    if (hwnd)
        ShellExecuteA(hwnd, "open", "fenixReport.jar", cURL, "c:\\Fenix\\", SW_SHOWDEFAULT);
}
```

### meu_MessageBox()
Exibe uma caixa de mensagem (usado para debug):
```c
void meu_MessageBox(TermWin *tw, char *mensagem, char *titulo) {
    if (hwnd)
        MessageBox(hwnd, mensagem, titulo, MB_OK);
}
```

## 3. Menu Personalizado (windows/window.c)

IDs definidos:
```c
#define IDM_MEU_RELATORIOS  0x0080
#define IDM_MEU_HELP        0x0090
#define IDM_MEU_SUPORTE     0x0100
#define IDM_MEU_PORTAL      0x0110
#define IDM_MEU_TERMSEG     0x0120
```

Cada menu item executa `ShellExecute` para abrir uma URL específica.

## 4. Branding (be_all_s.c)

```c
const char *const appname = "Fenix";
```

## 5. Tradução (config.c)

Strings traduzidas para português:
- "Host Name (or IP address)" → "Nome do Host (ou endereço IP)"
- "Port" → "Porta"
- "Connection type:" → "Tipo de Conexão"
- "Load" → "Carregar", "Save" → "Salvar", "Delete" → "Deletar"

## 6. Simplificação da UI (windows/wincfg.c)

Grandes seções de configuração avançada comentadas para simplificar a interface
para usuários finais do ERP.

## 7. Impressão (windows/winprint.c)

Função `printer_abort_job()` adicionada para abortar o job de impressão quando
a ação é uma URL ou fenixReport (não precisa imprimir nada).

## 8. Virtual Table (putty.h)

Function pointer `ShellExecuteA` adicionado à vtable `TermWinVtable`,
permitindo que `terminal.c` chame funções do Windows sem dependência direta.
