async function updateCounter() {
    try {
        let response = await fetch('${api_url}', {
            method: 'POST'
        });
        
        let data = await response.json();
        document.getElementById('counter').innerText = data; 
    } catch (error) {
        console.error("Error fetching the counter:", error);
    }
}

updateCounter();