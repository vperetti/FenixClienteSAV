# ClienteSAV - PuTTY Fork para Fenix/SAV ERP

Fork customizado do PuTTY SSH para os ERPs **Fenix** e **SAV** (BasePro).

Intercepta escape sequences ANSI (LP ANSI) do servidor para abrir URLs no navegador
e executar relatórios via fenixReport.jar na máquina Windows do usuário.

## Versão Atual

**v3.0** — Baseado no PuTTY 0.74 (Janeiro 2021)

- Diretório: [`atual/`](atual/) (symlink para `v3-putty074-2021/`)
- Download: [Último release](../../releases/latest)
- Binário: `ClienteSAV.exe` (1006K)

## Como Funciona

O ClienteSAV intercepta **escape sequences ANSI de impressão** (Media Copy)
enviadas pelo servidor ERP e executa ações no Windows onde o terminal está rodando.

### Fluxo de Interceptação

O servidor envia dados encapsulados entre escape sequences de controle de impressão:

```
ESC[5i  ← Inicia modo de captura (Media Copy - start)
http://servidor/relatorio.pdf   ← Dados capturados
ESC[4i  ← Finaliza captura (Media Copy - stop)
```

Uma **máquina de estados** em `terminal.c` acumula todos os caracteres entre
`ESC[5i` e `ESC[4i` no buffer `MINHA_URL`. Ao detectar o fim (`ESC[4i`),
chama `term_print_finish()` que decide a ação:

```c
// Prefixo "httpjr" → abre fenixReport.jar com parâmetros
if (strncmp("httpjr", MINHA_URL, 6) == 0)
    meu_AbreFenixReport(term->win, MINHA_URL);

// Prefixo "http" → abre URL no navegador padrão do Windows
else if (strncmp("http", MINHA_URL, 4) == 0)
    meu_AbreURL(term->win, MINHA_URL);

// Qualquer outra coisa → envia para impressora normalmente
else
    printer_finish_job(term->print_job);
```

### Ações Suportadas

| Prefixo do servidor | Ação no Windows | Função |
|---------------------|-----------------|--------|
| `http://...` ou `https://...` | Abre URL no navegador padrão | `ShellExecuteA(hwnd, "open", URL, ...)` |
| `httpjr://...` | Executa `fenixReport.jar` com parâmetros | `ShellExecuteA(hwnd, "open", "fenixReport.jar", URL, "c:\\Fenix\\", ...)` |
| Qualquer outro texto | Envia para impressora Windows | `printer_finish_job()` |

### Menu Personalizado

O ClienteSAV adiciona um menu de contexto com atalhos para os sistemas web locais:

| Menu | URL |
|------|-----|
| Relatórios | `http://localhost:81/relatorios/` |
| Ajuda - Manual do Sistema | `http://localhost:81/help/` |
| Portal Intranet | `http://localhost:81/portal/` |
| Terminal Seguro | `http://localhost:82/` |
| Suporte | `http://www.basepro.com.br/` |

### Exemplo de Uso pelo Servidor

No código xHarbour do ERP, para abrir um relatório no navegador do cliente:

```clipper
// Envia escape sequence LP ANSI que o ClienteSAV intercepta
cEsc := Chr(27) + "[5i"
cURL := "http://servidor/fenixWeb/relatorio.php?id=123"
cFim := Chr(27) + "[4i"
QQout(cEsc + cURL + cFim)
```

### Integração com FenixReport

O ClienteSAV trabalha em conjunto com o projeto
[FenixReport](https://github.com/vperetti/FenixReport) — um visualizador de
relatórios JasperReports distribuído junto com o cliente Fenix.

Quando o servidor envia uma URL com prefixo `httpjr`, o ClienteSAV executa
`fenixReport.jar` no diretório `c:\Fenix\`, passando a URL completa como parâmetro:

```c
ShellExecuteA(hwnd, "open", "fenixReport.jar", cURL, "c:\\Fenix\\", SW_SHOWDEFAULT);
```

O fluxo completo:
1. Usuário solicita relatório no terminal do ERP
2. Servidor gera o relatório JasperReports e envia via escape sequence:
   `ESC[5i` + `httpjr://parametros-do-relatorio` + `ESC[4i`
3. ClienteSAV intercepta, detecta prefixo `httpjr` e executa `fenixReport.jar`
4. FenixReport abre o relatório na máquina do usuário com visualização e impressão

O `fenixReport.jar` e suas dependências (`lib/`) estão incluídos em
[`v3-putty074-2021/extras/`](v3-putty074-2021/extras/) para referência.

### Arquivos Modificados (marcados com `/*MEXIDAMINHA*/`)

| Arquivo | Modificação |
|---------|-------------|
| `terminal.c` | Máquina de estados para captura de URL + decisão http/httpjr/impressora |
| `windows/window.c` | Menu personalizado + funções `meu_AbreURL()`, `meu_AbreFenixReport()` |
| `putty.h` | Function pointer `ShellExecuteA` na vtable do TermWin |
| `be_all_s.c` | Branding: `appname = "Fenix"` |
| `config.c` | Interface traduzida para português |
| `windows/windlg.c` | Dialogs de senha e impressão com URLs localhost |
| `windows/wincfg.c` | Painéis avançados de configuração desabilitados |
| `windows/winprint.c` | Função `printer_abort_job()` para abortar impressão em ações URL |
| `windows/win_res.h` | Resource ID `IDA_PASSCHANGE` |

## Histórico de Versões

| Versão | Base PuTTY | Período | Status |
|--------|-----------|---------|--------|
| **v3** | 0.74 | 2020-2021 | **Atual** |
| v2 | 0.56 | 2008-2011 | Legado |
| v1 | 0.56 | 2004-2005 | Legado |

## Estrutura do Repositório

```
atual/              → symlink para v3-putty074-2021/ (versão atual)
v3-putty074-2021/   → PuTTY 0.74 com MEXIDAMINHA (2021)
  original/         → Fonte PuTTY 0.74 original
  modificado/       → Fonte com modificações MEXIDAMINHA
  bin/              → ClienteSAV.exe compilado
v2-putty056-2011/   → PuTTY 0.56 com MEXIDAMINHA evoluído (2008-2011)
v1-putty056-2005/   → PuTTY 0.56 com MEXIDAMINHA inicial (2004-2005)
docs/               → Documentação detalhada
```

## Compilação

Ver [docs/BUILD.md](docs/BUILD.md)

## Licença

PuTTY é licenciado sob MIT. Ver [LICENSE](LICENSE).
