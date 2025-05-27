# 🔍 Lexical Analyzer Web Application

A simple and interactive **Lexical Analyzer** built using **Flex (Lex)** and **Bison (Yacc)**, combined with a **modern web-based interface** using HTML, CSS, and JavaScript.

This project scans source code, tokenizes it, displays categorized tokens, builds a symbol table, and allows users to **download results** — all in an easy-to-use interface.

---

## 🚀 Features

- ✅ Tokenizes C-like code into:
  - Keywords (`if`, `while`, `int`, etc.)
  - Identifiers
  - Operators (`+`, `-`, `==`, etc.)
  - Numbers and Floats
  - Symbols and Delimiters
- 📄 **Symbol Table** creation and display
- 💾 **Download** token list and symbol table as `.csv` or `.txt`
- 📤 Upload `.c`/`.txt` file for token analysis
- 📊 Token statistics: view frequency of each token type
- 🌓 Dark Mode toggle for better accessibility
- 🧑‍🏫 Designed for students and educators to visualize how lexical analysis works

---

## 🧰 Technologies Used

- **Frontend**:
  - HTML, CSS, JavaScript (Vanilla)
- **Backend / Lexical Engine**:
  - `Flex` (Lex)
  - `Bison` (Yacc) — optional for parsing stage
  - C/C++
- Optional:
  - Makefile for automated compilation

---

## 🛠️ Getting Started

### 🔧 Prerequisites

- Flex (Lex)
- Bison (Yacc) (optional if grammar parsing is involved)
- GCC or any C compiler
- Web browser

### ⚙️ Compilation

```bash
flex lexer.l         # Generates lex.yy.c
bison -d parser.y    # Generates parser.tab.c and parser.tab.h (if using Bison)
gcc lex.yy.c parser.tab.c -o analyzer -lfl


