// Website/script.js
const socket = new WebSocket("ws://your-server-url"); // Replace with your server WebSocket URL

socket.onmessage = function(event) {
    const data = JSON.parse(event.data);
    if (data.endpoint === "AnalyticsUpdate") {
        updateDashboard(data.data);
    } else if (data.endpoint === "SecurityLog") {
        addSecurityLog(data.data);
    }
};

function updateDashboard(data) {
    if (data.Event === "PlayTime") {
        document.getElementById("playtime").textContent = `Avg Playtime: ${data.Value / 3600} hours`;
    } else if (data.Event === "Contribution") {
        document.getElementById("contributions").textContent = `Avg Contributions: ${data.Value}`;
    }
}

function addSecurityLog(data) {
    const logList = document.getElementById("security-logs");
    const li = document.createElement("li");
    li.textContent = `${data.UserId} - ${data.Action}`;
    logList.appendChild(li);
}

document.getElementById("logout").addEventListener("click", () => {
    // Handle logout logic
    alert("Logged out!");
});
