# Instruções de Compilação

## v3 - PuTTY 0.74 (Versão Atual)

### Requisitos
- Visual Studio 2019 ou superior (MSVC v142)
- Windows SDK

### Compilação
1. Abrir a solution em `v3-putty074-2021/modificado/windows/MSVC/putty.sln`
2. Selecionar configuração **Release** / **x86**
3. Build → Build Solution
4. O executável será gerado em `windows/MSVC/putty/Release/putty.exe`
5. Renomear para `ClienteSAV.exe`

### Projetos alternativos
- `windows/VS2012/putty.sln` — Visual Studio 2012
- `windows/VS2010/putty.sln` — Visual Studio 2010
- `windows/DEVCPP/putty.dev` — Dev-C++

## v1/v2 - PuTTY 0.56

### Requisitos
- Borland C++ Builder ou MinGW

### Compilação (Borland)
```
cd v2-putty056-2011/modificado
make -f MAKEFILE.BOR
```

### Compilação (MinGW/Cygwin)
```
cd v2-putty056-2011/modificado
make -f Makefile.cyg
```
