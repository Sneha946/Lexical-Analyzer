function runAnalyzer() {
    const code = document.getElementById('codeInput').value;

    fetch('http://localhost:3000/analyze', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ code: code })
    })
    .then(res => res.json())
    .then(data => {
        const outputContainer = document.querySelector('.output-container');
        outputContainer.innerHTML = '';

        const tokenMap = new Map();

        // Count occurrences
        data.tokens.forEach(token => {
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
    })
    .catch(err => console.error(err));
}
