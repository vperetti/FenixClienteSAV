import re

def extract_paths():
    with open('config.c', 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
    
    in_if_0 = False
    paths = []
    
    for i, line in enumerate(lines):
        if re.search(r'#if\s+0', line):
            in_if_0 = True
        elif re.search(r'#endif', line) and in_if_0:
            in_if_0 = False
        
        if not in_if_0:
            m1 = re.search(r'ctrl_getset\s*\(\s*[^,]+,\s*"([^"]*)",', line)
            if m1:
                paths.append((i+1, "getset", m1.group(1)))
            
            m2 = re.search(r'ctrl_settitle\s*\(\s*[^,]+,\s*"([^"]*)",', line)
            if m2:
                paths.append((i+1, "settitle", m2.group(1)))
                
    with open('windows/config.c', 'r', encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
    
    in_if_0 = False
    for i, line in enumerate(lines):
        if re.search(r'#if\s+0', line):
            in_if_0 = True
        elif re.search(r'#endif', line) and in_if_0:
            in_if_0 = False
        
        if not in_if_0:
            m1 = re.search(r'ctrl_getset\s*\(\s*[^,]+,\s*"([^"]*)",', line)
            if m1:
                paths.append((i+1, "win_getset", m1.group(1)))
            
            m2 = re.search(r'ctrl_settitle\s*\(\s*[^,]+,\s*"([^"]*)",', line)
            if m2:
                paths.append((i+1, "win_settitle", m2.group(1)))
                
    with open('out2.txt', 'w', encoding='latin-1') as fw:
        for p in paths:
            fw.write(f"Line {p[0]}: {p[1]} -> '{p[2]}'\n")

if __name__ == "__main__":
    extract_paths()
