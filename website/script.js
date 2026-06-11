async function updateCounter() {
    try {
        let response = await fetch('https://7i3463ojke.execute-api.eu-north-1.amazonaws.com/deployment/visits');
        let data = await response.json();
        document.getElementById('counter').innerText = data.body; 
    } catch (error) {
        console.error("Error fetching the counter:", error);
    }
}

updateCounter();