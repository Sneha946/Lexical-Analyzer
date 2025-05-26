const express = require('express');
const cors = require('cors');
const fs = require('fs');


const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());


const { exec } = require('child_process');
const path = require('path');

app.post('/analyze', (req, res) => {
  const userCode = req.body.code;
  const analyzerDir = path.join(__dirname, 'analyzer');
  const codeFilePath = path.join(analyzerDir, 'code.txt');

  // Write code to file for analyzer
  require('fs').writeFileSync(codeFilePath, userCode);

  exec('analyzer.exe', { cwd: analyzerDir }, (error, stdout, stderr) => {
    if (error) {
      console.error('Analyzer execution error:', error.message);
      return res.status(500).json({ error: 'Analyzer execution failed', details: error.message });
    }

    // Parse errors from stderr
    let errors = [];
    if (stderr && stderr.trim()) {
      errors = stderr
        .trim()
        .split('\n')
        .filter(line => line.startsWith('ERROR:'))
        .map(line => line.replace(/^ERROR:\s*/, ''));
    }

    // Parse symbol table from stdout
    const symbolTable = [];
    const lines = stdout.split('\n');
    let insideSymbolTable = false;
    const tokens = [];

    for (const line of lines) {
        const trimmed = line.trim();

        if (trimmed === 'SYMBOL_TABLE_START') {
            insideSymbolTable = true;
            continue;
        }

        if (trimmed === 'SYMBOL_TABLE_END') {
            insideSymbolTable = false;
            continue;
        }

        if (insideSymbolTable) {
            try {
            const sym = JSON.parse(trimmed);
            symbolTable.push(sym);
            } catch (e) {
            // Optionally handle malformed lines
            }
        } else {
            // Extract tokens from lines like: "Line 3: b:IDENTIFIER"
            const tokenMatch = trimmed.match(/^Line\s+(\d+):\s*(.+?):(.+)$/);
            if (tokenMatch) {
            const [, lineNum, value, type] = tokenMatch;
            tokens.push({
                line: parseInt(lineNum),
                value: value.trim(),
                type: type.trim()
            });
            }
        }
        }

    console.log("symbol table:",symbolTable);
    console.log("errors:",errors);
    console.log("tokens:",tokens);

    res.json({ errors, symbolTable,tokens });
  });
});
app.listen(PORT, () => {
  console.log(`Server running at http://localhost:${PORT}`);
});
