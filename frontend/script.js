function runAnalyzer() {
    const code = document.getElementById('codeInput').value;

    fetch('http://localhost:3000/analyze', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({ code })
        })
        .then(response => response.json())
        .then(data => {
          console.log(data);
                displaySymbolTable(data.symbolTable);
                displayError(data.errors);
                displayTokens(data.tokens);
            })
        .catch(error => console.error('Error:', error));

        }

function displaySymbolTable(symbolTable) {
  searchInput.addEventListener("input", () => {
    let searchInput=document.getElementById("searchInput");
    const filter = searchInput.value.toLowerCase();
    const filtered = symbolTable.filter(sym =>
      sym.name.toLowerCase().includes(filter) ||
      sym.type.toLowerCase().includes(filter) ||
      sym.line.toString().includes(filter)
    );
    renderTable(filtered);
  });
}



function renderTable(symbolTable) {
    const tableBody = document.querySelector("#symbolTable tbody");
    tableBody.innerHTML = "";

    symbolTable.forEach(sym => {
      const row = document.createElement("tr");
      row.innerHTML = `<td>${sym.name}</td><td>${sym.type}</td><td>${sym.line}</td>`;
      tableBody.appendChild(row);
    });
  }

  
function displayError(errors){
  const errorContainer=document.getElementById("error-container");
  errorContainer.innerHTML='';

  errors.forEach(error=>{
    let err=document.createElement("div");
    err.innerHTML=error;
    errorContainer.appendChild(err);
  })
}
function displayTokens(tokens){
    const outputContainer = document.querySelector('.output-container');
        outputContainer.innerHTML = '';

        const tokenMap = new Map();

        // Count occurrences
        tokens.forEach(token => {
            const key = token.value + ':' + token.type;
            if (tokenMap.has(key)) {
                tokenMap.get(key).count += 1;
            } else {
                tokenMap.set(key, { value: token.value, type: token.type, count: 1 });
            }
        });

        // Display unique tokens with count
        tokenMap.forEach(({ value, type, count }) => {
            const tokenDiv = document.createElement('button');
            tokenDiv.className = `token ${type.toLowerCase()}`;
            tokenDiv.textContent = `${value} (x${count})`;
            outputContainer.appendChild(tokenDiv);
        });
}
function downloadSymbolTable() {
    const table = document.getElementById("symbolTable");
    let csv = "";
    for (let row of table.rows) {
        let rowData = [];
        for (let cell of row.cells) {
            rowData.push(cell.textContent);
        }
        csv += rowData.join(",") + "\n";
    }

    const blob = new Blob([csv], { type: "text/csv" });
    const url = window.URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.setAttribute("hidden", "");
    a.setAttribute("href", url);
    a.setAttribute("download", "symbol_table.csv");
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
}
