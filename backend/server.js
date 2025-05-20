const express = require('express');
const cors = require('cors');
const fs = require('fs');
const { exec } = require('child_process');

const app = express();
const PORT = 3000;

app.use(cors());
app.use(express.json());

const path = require('path');

app.post('/analyze', (req, res) => {
    const userCode = req.body.code;

    // Write code to analyzer/code.txt
    const analyzerPath = path.join(__dirname, 'analyzer');
    const codeFilePath = path.join(analyzerPath, 'code.txt');
    fs.writeFileSync(codeFilePath, userCode);

    // Execute analyzer.exe inside analyzer folder
    exec('analyzer.exe', { cwd: analyzerPath }, (error, stdout, stderr) => {
        if (error) {
            console.error(`Exec error: ${error.message}`);
            return res.status(500).json({ error: 'Analyzer failed' });
        }

        const lines = stdout.trim().split('\n');
        const tokens = lines.map(line => {
            const [value, type] = line.split(':');
            return { value, type };
        });
        console.log(lines);
        console.log(tokens);
        res.json({ tokens });
    });
});



app.listen(PORT, () => {
    console.log(`Server running on http://localhost:${PORT}`);
});
